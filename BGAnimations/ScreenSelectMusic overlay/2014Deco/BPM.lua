local LoadingScreen = Var "LoadingScreen"
--smcmd is "screen metrics command", gmcmd is "general metrics command"
--these make it require a little less typing to run useful BPMDisplay related commands
local smcmd, gmcmd
do
	smcmd = function(s, name)
		return (THEME:GetMetric(LoadingScreen, name))(s)
	end
	gmcmd = function(s, name)
		return (THEME:GetMetric("BPMDisplay", name))(s)
	end
end

local counter = 0
local targetDelta = 1/60
local timer = GetUpdateTimer(targetDelta)

--displays 3 digit numbers 000, 111, 222... 999, 000... every 1/60 of a second (about)
local function RandomBPM(self, _)
	local s = self:GetChild"BPMDisplay"
	if not timer() then return end
	s:settext("BPM "..string.rep(tostring(counter),3))
	counter = (counter+1)%10
end

local function textBPM(dispBPM)
	return string.format("BPM %03d", math.round(dispBPM))
end

local function VariedBPM(self, _)
	local s = self:GetChild"BPMDisplay"
	s:settextf("BPM %03d - %03d",math.round(dispBPMs[1]),math.round(dispBPMs[2]))
end


return Def.ActorFrame{
	--only ActorFrames and classes based on ActorFrame have update functions, which we need
	Name="SNBPMDisplayHost",
	Def.BitmapText{
		Font="_avenirnext lt pro bold 25px",
		Name="BPMDisplay",
		InitCommand=function(s) s:aux(0):settext "000":strokecolor(Alpha(Color.Black,0.5)):x(THEME:GetMetric(LoadingScreen,"BPMDisplayX"))
			:y(THEME:GetMetric(LoadingScreen,"BPMDisplayY")); return gmcmd(s, "SetNoBpmCommand") end,
		OnCommand=function(s) return smcmd(s, "BPMDisplayOnCommand") end,
		OffCommand=function(s) return smcmd(s, "BPMDisplayOffCommand") end,
		StartSelectingStepsMessageCommand=function(s) s:playcommand("Off") end,
		SongUnchosenMessageCommand=function(s) s:playcommand("On")end,
		CurrentSongChangedMessageCommand = function(s, _)
			local song = GAMESTATE:GetCurrentSong()
			if song then
				if song:IsDisplayBpmRandom() or song:IsDisplayBpmSecret() then
					gmcmd(s, song:IsDisplayBpmRandom() and "SetRandomCommand" or "SetExtraCommand")
					--I do not believe that it is necessary to reset this counter every time.
					--It may even be incorrect.
					counter = 0
					timer = GetUpdateTimer(targetDelta)
					--an aux value of -1 is intended as a special value but it is not used.
					s:aux(-1):settext "BPM 999":GetParent():SetUpdateFunction(RandomBPM)
				else
					local dispBPMs = song:GetDisplayBpms() 
					if song:IsDisplayBpmConstant() then
						gmcmd(s, "SetNormalCommand")
						s:settextf("BPM %03d",math.round(dispBPMs[1])):GetParent():SetUpdateFunction(nil)
					else
						gmcmd(s, "SetChangeCommand")
						s:settextf("BPM %03d - %03d",math.round(dispBPMs[1]),math.round(dispBPMs[2])):GetParent():SetUpdateFunction(nil)
					end
				end
			else
				gmcmd(s, "SetNoBpmCommand")
				s:settext "":GetParent():SetUpdateFunction(nil)
			end
		end
	}
}
