local beginTime = GetTimeSinceStart()
local lastSeenTime = beginTime
local flickerState = false
local FlickerLog = nil
local FlickerPrint = nil
if SN3Debug then
    local flickerRecord = {}
    FlickerLog = function()
        table.insert(flickerRecord, true)
    end
    local oldDiff = 0
    FlickerPrint = function()
        local diff = math.floor(lastSeenTime-beginTime)
        if (diff % 15 == 0) and (diff ~= oldDiff) then
            oldDiff = diff
            SCREENMAN:SystemMessage("flicker debug: flickered avg "..tostring((#flickerRecord)/15).."Hz over last 15 sec")
            flickerRecord = {}
        end
    end
end

local targetDelta = 1/60
local function CalculateFlickerWaitFrames(delta)
    return math.max(1, math.round(targetDelta/delta))-1
end

local fCounter = 0
local function FlickerUpdate(self, _)
    lastSeenTime = GetTimeSinceStart()
    if FlickerPrint then FlickerPrint() end
    if fCounter >0 then fCounter = fCounter-1 return end

    if FlickerLog then FlickerLog() end
    flickerState = not flickerState

    for pn, item in pairs(self:GetChildren()) do
        item:visible((GAMESTATE:GetPlayerState(pn):GetHealthState() == 'HealthState_Hot')
            and flickerState)
    end

    fCounter = CalculateFlickerWaitFrames(DISPLAY:GetFPS())
end

local host = Def.ActorFrame{
    Name = "HotLifeFlicker",
    InitCommand = function(self) self:SetUpdateFunction(FlickerUpdate) end;
}

local xPosPlayer = {
    P1 = (ScreenGameplay_P1X()+7),
    P2 = (ScreenGameplay_P2X()-7)
}

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
    table.insert(host,Def.Quad{
        Name = pn,
        InitCommand=function(self)
          local short = ToEnumShortString(pn)
          self:visible(false):setsize(642,42)
          :diffuse(color "0.25,0.25,0.25,0.5"):y(2)
          if GAMESTATE:PlayerIsUsingModifier(pn,'battery') or GAMESTATE:GetPlayMode() == 'PlayMode_Oni' then
            if pn == "PlayerNumber_P2" then
              self:x(xPosPlayer[short]-6)
            else
              self:x(xPosPlayer[short]+6)
            end;
          else
            self:x(xPosPlayer[short])
          end;
        end,
        OnCommand=function(s) s:draworder(3):zoomx(pn=='PlayerNumber_P2' and -1 or 1) end,
    })
end
return host
