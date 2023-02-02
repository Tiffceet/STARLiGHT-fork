local t = Def.ActorFrame{}

local wheel = ThemePrefs.Get("WheelType");

if wheel == "A" then
    t[#t+1] = LoadActor("A.lua")
else
    t[#t+1] = LoadActor(THEME:GetPathG("MusicWheelItem","SectionCollapsed NormalPart/"..wheel.."/default.lua"))
end

return t;
