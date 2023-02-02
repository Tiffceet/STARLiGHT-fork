local t = Def.ActorFrame{
    LoadActor("A")..{
        InitCommand=function(s) s:zoomtoheight(1) end,
    }
};
return t;