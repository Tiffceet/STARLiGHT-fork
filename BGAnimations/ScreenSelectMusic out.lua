LoadFromProfilePrefs()
local t = Def.ActorFrame{
	LoadActor(THEME:GetPathS("","_swoosh out"))..{
		StartTransitioningCommand=function(s) s:play() end,
	};
	StartTransitioningCommand=function(self) SOUND:DimMusic(0,math.huge) end,
};

return t;
