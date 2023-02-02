-- I got this idea for using a single sprite instead of PerChoiceScrollElement
-- from k//eternal's PROJEKTXV theme.
--
-- The "GameCommand" var is defined in ScreenSelectMaster.cpp:
--   LuaThreadVariable var("GameCommand", LuaReference::Create(&mc));
local style = Var("GameCommand"):GetName()

local t = Def.ActorFrame{}

-- Loads the graphic which matches the choice name from metrics.ini!
t[#t+1] = Def.ActorFrame{
	OnCommand=cmd(addy,SCREEN_HEIGHT;sleep,0.2;decelerate,0.2;addy,-SCREEN_HEIGHT);
	OffCommand=cmd(linear,0.2;addy,-SCREEN_HEIGHT);
	LoadActor(style);
	LoadActor("hl")..{
		GainFocusCommand=cmd(stoptweening;diffusealpha,0;linear,0.1;diffusealpha,1);
		LoseFocusCommand=cmd(stoptweening;linear,0.1;diffusealpha,0);
	};
};

return t
