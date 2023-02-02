local t = Def.ActorFrame{
    LoadActor("bottom")..{
        InitCommand=function(s) s:y(110) end,
    },
    LoadActor("glow")..{
        InitCommand=function(s) s:y(110)
        :diffuseshift():effectcolor1(color("1,1,1,0.75")):effectcolor2(color("1,1,1,1")):effectclock('beatnooffset') end,
    }
};
return t;