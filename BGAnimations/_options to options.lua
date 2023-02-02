return Def.ActorFrame{
	LoadActor(THEME:GetPathS("","_swoosh in"))..{
		StartTransitioningCommand=function(s) s:play() end,
	};
};
