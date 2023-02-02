return Def.ActorFrame {
	OnCommand=function(s) s:sleep(0) end,
	Def.Quad {
		InitCommand=function(s) s:Center():zoomto(SCREEN_WIDTH+1,SCREEN_HEIGHT) end,
		OnCommand=function(s) s:diffuse(color("0,0,0,0")):sleep(0):linear(0.9):diffusealpha(0) end,
	};
	LoadActor("../_swoosh_out")..{
		OffCommand=function(s) s:play() end,
	};
};