--StatsEngine v0.81
--by tertu
--TODO for version 1.0
--1. saving data isn't supported at all
--2. some code cleanup is necessary
--3. I haven't figured out certain things
--[[Changes since v0.8
*Optimizations
*Added Offset to the judgment information
*Collect more garbage
--]]
local cache = setmetatable({}, {__mode="kv"})

--the dependency solving process is kinda tedious, so just do it once
--and save it for later. i'm not too worried about keeping this in
--memory because it's just an array of numbers
local RunOrders = {}
do

	local succ, results = pcall(dofile, THEME:GetPathO("_StatsEngine","Modules"))
	if not succ then
		error("StatsEngine: couldn't load modules for dependency resolution: "..results)
	end

	--an edge is a dependency but that's what Wikiped calls it when describing
	--this algorithm so i'm doing that to keep track of things more easily
	local edges = {}
	local roots = {}
	local sorted = {}
	local modCount = #results
	
	--pass 1: find roots
	for i=1,modCount do
		local deps = results[i].Requires
		if not deps or #deps == 0 then
			RunOrders[i] = 0
			edges[i] = nil
			roots[#roots+1] = i
		else
			edges[i] = deps
		end
	end
	
	if #roots == 0 then
		error "StatsEngine: at least one module must not depend on any other module"
	elseif #roots ~= modCount then --at least one module has a dependency
		
		--pass 2: strip away dependencies until there are none. this uses
		--Kahn's algorithm, implemented based on the description at Wikipedia
		local curRoot = 0
		while curRoot < #roots do
			
			curRoot = curRoot + 1
			
			local rootName = results[roots[curRoot]].Name
			sorted[#sorted+1] = curRoot
			
			for i, edgeSet in pairs(edges) do
					
				for j=1,#edgeSet do
					if edgeSet[j] == rootName then
						table.remove(edgeSet, j)
						if #edgeSet == 0 then
							edges[i] = nil
							roots[#roots+1] = i
							break
						end
					end
				end
				
			end
			
		end
		
		if next(edges) ~= nil then
			local fmt = "StatsEngine: module %s has unresolved deps: %s."
			local joiner = ","
			for i, edgeSet in pairs(edges) do
				print(fmt:format(results[i].Name, table.concat(edgeSet, joiner)))
			end
		
			error "StatsEngine: couldn't resolve dependencies. This means there is a cycle or missing dependencies."
		end

		for i=1, modCount do
			RunOrders[sorted[i]] = i
		end
	end
end
collectgarbage()

function StatsEngine()
	local modules = cache.modules
	if not modules then
		modules = dofile(THEME:GetPathO("_StatsEngine","Modules"))
		for i=1,#modules do modules[i].Index = i end
		table.sort(modules, function(a, b) return RunOrders[a.Index] < RunOrders[b.Index] end)
		cache.modules = modules
	end

	local output = {Class='Actor'}
	local song
	local course = GAMESTATE:GetCurrentCourse()
	local liveModules = {}
	local dataTables = {}
	
	local function InitializeModule(module, pn, idx)
		local player_modules = liveModules[pn]
		local steps = GAMESTATE:GetCurrentSteps(pn)
		local trail = GAMESTATE:GetCurrentTrail(pn)
		local co = coroutine.create(module.Code)
		local succ, results = coroutine.resume(co, pn, song, steps, course, trail)
		if not succ then
			lua.ReportScriptError("loading StatsEngine module "..module.Name.." for player "..ToEnumShortString(pn).." failed: "..tostring(results))
		elseif coroutine.status(co) ~= "dead" then
			player_modules[#player_modules+1] = 
				{module.Name, module.RunOrder, co, module.IgnoreMines, module.IgnoreCheckpoints, module.CourseBehavior, idx}
		else
			print("StatsEngine: stats module "..name.." decided not to load for player "..ToEnumShortString(pn))
		end
	end
	
	local function ProcessEvent(process, pn, eventFlags, eventData, filter, delete)
		local dataTable = dataTables[pn]
		
		if not dataTable then
			dataTables[pn] = {}
			dataTable = dataTables[pn]
		end
			
		local msgParams = {Player=pn, Data=dataTable}
		
		if not eventData then 
			eventData = eventFlags
		else
			for flag, _ in pairs(eventFlags) do
				eventData[flag] = true
				msgParams[flag] = true
			end
		end
		
		local flag_str
		local anyRan = false
	
		for idx=1,#process do
			local module = process[idx]
			if module then
				if (not filter) or filter(module, pn, eventData) then
				
					anyRan = true
					
					local succ, results = coroutine.resume(module[3], eventData, dataTable)
					if not succ then
						if not flag_str then
							flag_str = ""
							for flag, _ in pairs(eventFlags) do
								flag_str = flag_str .. " " .. flag
							end
						end
						lua.ReportScriptError("error in StatsEngine module "..module[1].." for player "..ToEnumShortString(pn).." (event flags:" .. flag_str .. "), unloading: "..tostring(results))
						table.remove(process, idx)
					else
						if results then
							dataTable[module[1]] = results
						end
						if replace then
							local m_idx = module[7]
							process[idx] = InitializeModule(modules[m_idx], pn, m_idx)
						end
					end
				end
			end
		end
		
		if anyRan then
			MESSAGEMAN:Broadcast("AfterStatsEngine", msgParams)
		end
	end
	
	output.JudgmentMessageCommand=function(s, params)
		local pn = params.Player
		local process = liveModules[pn]
		if not process then return end

		if not dataTables[pn] then
			dataTables[pn] = {}
		end

		local p = {}
		p.Original = params
		local tns = params.TapNoteScore and ToEnumShortString(params.TapNoteScore) or nil
		local hns = params.HoldNoteScore and ToEnumShortString(params.HoldNoteScore) or nil
		p.TNS = tns
		p.HNS = hns
		p.PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
		p.Offset = params.TapNoteOffset
		
		local filter = function(module, pn, eventData)

			local tns = eventData.TNS
			return ((not module[4]) or (tns ~= 'HitMine' and tns ~= 'AvoidMine'))
			and ((not module[5]) or (tns ~= 'CheckpointHit' and tns ~= 'CheckpointMiss'))
		end
		
		local flags = {Judgment=true}
		ProcessEvent(process, pn, flags, p, filter)
	end
	
	--this command fires off once before gameplay starts. do setup then
	local initialized = false
	output.DoneLoadingNextSongMessageCommand=function()
		song = GAMESTATE:GetCurrentSong()
		
		if not initialized then
			for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
				liveModules[pn] = {}
				for idx=1,#modules do
					local module = modules[idx]
					if (not course) or module.CourseBehavior~='Disable' then
						InitializeModule(module, pn, idx)
					end
				end
				if #liveModules[pn] == 0 then
					liveModules[pn] = nil
				end
			end

			initialized = true
			return
		end
		
		local flags = {NextSong=true}
		local final_flags = {Finalize=true}
		for pn, process in pairs(liveModules) do
			ProcessEvent(process, pn, flags, {Song=song, Steps=GAMESTATE:GetCurrentSteps(pn)},
			function(module) return module[6] == 'PerSong' end)
			ProcessEvent(process, pn, final_flags, final_flags, 
			function(m) local mode = m[6]; return mode == 'Reset' or mode == 'ResetAndSave' end, true)
		end
	end
	
	output.OffCommand=function()
		local flags = {Finalize=true}
		for pn, process in pairs(liveModules) do
			ProcessEvent(process, pn, flags) 
		end
	end
	
	return output, dataTables
end
