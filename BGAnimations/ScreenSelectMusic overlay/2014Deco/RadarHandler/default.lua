local pn = ({...})[1] --only argument to file
local GR = {
    {-1,-122, "Stream"}, --STREAM
    {-120,-43, "Voltage"}, --VOLTAGE
    {-108,72, "Air"}, --AIR
    {108,72, "Freeze"}, --FREEZE
    {120,-43, "Chaos"}, --CHAOS
};

local t = Def.ActorFrame{
    InitCommand = function(s) s:xy(pn=="PlayerNumber_P2" and SCREEN_RIGHT-200 or SCREEN_LEFT+200,RadarY()) end,
    LoadActor("GrooveRadar base")..{
        OnCommand=function(s) s:zoom(0):rotationz(-360):decelerate(0.4):zoom(1):rotationz(0) end,
        OffCommand=function(s) s:sleep(0.3):decelerate(0.3):rotationz(-360):zoom(0) end,
    };
    LoadActor("sweep") .. {
        InitCommand = function(s) s:zoom(1.275):spin():effectmagnitude(0,0,100) end,
        OnCommand = function(s) s:hibernate(0.4) end,
        OffCommand=function(s) s:finishtweening():sleep(0.3):decelerate(0.3):rotationz(-360):zoom(0) end,
    };
};

for i,v in ipairs(GR) do
    t[#t+1] = Def.ActorFrame{
        OnCommand=function(s)
            s:xy(v[1],v[2])
            :diffusealpha(0):addx(-10):sleep(0.1+i/10):linear(0.1):diffusealpha(1):addx(10)
        end;
        OffCommand=function(s)
            s:sleep(i/10):linear(0.1):diffusealpha(0):addx(-10)
        end;
        Def.Sprite{
            Texture=THEME:GetPathB("ScreenSelectMusic","overlay/2014Deco/RadarHandler/RLabels"),
            OnCommand=function(s) s:animate(0):setstate(i-1) end,
        };
        Def.BitmapText{
            Font="_avenirnext lt pro bold 20px";
            SetCommand=function(s)
                local song = GAMESTATE:GetCurrentSong();
                    if song then
                        local cSteps = GAMESTATE:GetCurrentSteps(pn)
                        local Value = cSteps:GetRadarValues(pn):GetValue('RadarCategory_'..v[3]);
                        local conv = math.round(Value*100);
                        s:settext(string.format("%03d",conv))
                    else
                        s:settext("")
                    end
                s:strokecolor(color("#1f1f1f")):y(28)
            end,
            CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
            ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
            ["CurrentTrail"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
        };
    };
end

t[#t+1] = Def.ActorFrame{
    Def.BitmapText{
        Font="_stagetext",
        InitCommand=function(s) s:y(50):diffuse(color("#dff0ff")):strokecolor(color("#00baff")):zoom(0.75):maxwidth(300) end,
        OnCommand=function(s) s:diffusealpha(0):decelerate(0.4):diffusealpha(1) end,
        OffCommand=function(s) s:sleep(0.3):decelerate(0.3):diffusealpha(0) end,
        CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
		["CurrentSteps" .. ToEnumShortString(pn) .. "ChangedMessageCommand"]=function(s) s:stoptweening():queuecommand("Set") end,
        SetCommand=function(s)
            if GAMESTATE:GetCurrentSong() then
                if GAMESTATE:GetCurrentSteps(pn) then
                    if GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit() ~= "" then
                        s:settext(GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit())
                    else
                        s:settext("Unknown Chart Artist")
                    end
                else
                    s:settext("")
                end
            else
                s:settext("")
            end
        end,
    }
}

return t;