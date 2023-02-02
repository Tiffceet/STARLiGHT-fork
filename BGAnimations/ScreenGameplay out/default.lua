-- normal and rave are handled in normal/default.lua
-- extra stages are in extra1 and extra2.

return Def.ActorFrame{
	Def.Actor{
		OnCommand=function(s) s:sleep(3) end,
	};
	LoadActor("normal")
};
