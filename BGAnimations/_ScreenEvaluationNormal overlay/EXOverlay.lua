local t = Def.ActorFrame{};

if GAMESTATE:HasEarnedExtraStage() then
    t[#t+1] = Def.ActorFrame{
        LoadActor("extraunder")..{
            InitCommand=function(s) s:Center():setsize(SCREEN_WIDTH,300) end,
            OnCommand=function(s) s:zoomx(0):sleep(0.1):linear(0.1):zoomx(1):sleep(1.5):linear(0.2):zoomx(0) end,
        },
        LoadActor("extratitle")..{
            InitCommand=function(s) s:Center() end,
            OnCommand=function(s) s:zoomx(10):zoomy(0):sleep(0.1):linear(0.2):zoomx(1):zoomy(1):sleep(1.3):linear(0.1):zoomx(10):zoomy(0) end,
        },
    };
end

return t