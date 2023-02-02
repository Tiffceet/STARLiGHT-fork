local t = Def.ActorFrame {
	LoadActor("in") .. {
		StartTransitioningCommand=function(s) s:play() end,
	};
	LoadActor("score") .. {
		StartTransitioningCommand=function(s) s:sleep(0.2):playcommand("Play") end,
		PlayCommand=function(s) s:play() end,
	};
	LoadActor(THEME:GetPathB("","ScreenWithMenuElements background/background"))..{
		InitCommand=function(s) s:FullScreen() end,
		StartTransitioningCommand=function(s) s:linear(0.2):diffusealpha(0) end,
	};
};
return t;
