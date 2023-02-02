local t = LoadFallbackB();

local screenName = Var "LoadingScreen";

t[#t+1] = Def.ActorFrame{
	OnCommand=function(s) s:draworder(-10):addy(SCREEN_HEIGHT):sleep(0.2):decelerate(0.2):addy(-SCREEN_HEIGHT) end,
	OffCommand=function(s) s:accelerate(0.2):addy(-SCREEN_HEIGHT) end,
	Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx-417,SCREEN_CENTER_Y-90) end,
		LoadActor("DialogBox");
		LoadActor("DialogTop")..{
			InitCommand=function(s) s:y(-320) end,
		};
	};
	LoadActor("expbox")..{
		InitCommand=function(s) s:xy(_screen.cx-417,SCREEN_BOTTOM-180) end,
	};
};

return t
