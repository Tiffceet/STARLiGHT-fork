local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	-- failed song --
    LoadActor("../_failed.ogg") .. {
		StartTransitioningCommand=function(s) s:sleep(0.2):queuecommand("Play") end,
		PlayCommand=function(s) s:play() end,
	};
};

t[#t+1] = Def.ActorFrame {
  LoadActor(THEME:GetPathB("","ScreenWithMenuElements background/background"))..{
		InitCommand=function(s) s:FullScreen():diffuse(color("0.6,0.6,1,1")) end,
		OnCommand=function(s) s:diffusealpha(0):linear(0.2):diffusealpha(1):linear(0.3):diffuse(color("1,0.2,0.2,1")):sleep(4):linear(0.3):diffuse(color("1,1,1,1")) end,
	};
	-- Failed
	LoadActor("doors")..{
		InitCommand=function(s) s:diffusealpha(0) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.2):diffusealpha(1):queuecommand("AnOn"):sleep(4):queuecommand("AnOff") end,
	};
	LoadActor("failed")..{
		InitCommand=function(s) s:Center() end,
		OnCommand=function(s) s:diffusealpha(0):zoomy(0):zoomx(4):linear(0.198):diffusealpha(1):zoomy(1):zoomx(1):sleep(2.604):linear(0.132):zoomy(0):zoomx(4):diffusealpha(0) end,
	};
};

return t;
