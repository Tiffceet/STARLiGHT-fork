return Def.ActorFrame{
    LoadActor("_marathon")..{
        InitCommand=function(s) s:align(0,0):xy(-189,-189):cropbottom(0.5) end,
        ShowCommand=function(s) s:finishtweening():diffusealpha(0):x(-300):decelerate(0.1):x(-189):diffusealpha(1) end,
        HideCommand=function(s) s:finishtweening():linear(0.1):x(-300):diffusealpha(0) end,
    },
    LoadActor("_marathon")..{
        InitCommand=function(s) s:align(1,1):xy(189,189):croptop(0.5) end,
        ShowCommand=function(s) s:finishtweening():diffusealpha(0):x(300):decelerate(0.1):x(189):diffusealpha(1) end,
        HideCommand=function(s) s:finishtweening():linear(0.1):x(300):diffusealpha(0) end,
    },
}