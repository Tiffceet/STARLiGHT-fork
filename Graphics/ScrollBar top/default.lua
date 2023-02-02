local t = Def.ActorFrame{
    LoadActor("top")..{
        InitCommand=function(s) s:y(-6) end,
    }
};
return t;