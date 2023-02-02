local out = Def.ActorFrame {
	InitCommand = cmd(xy,_screen.cx,SCREEN_TOP+68),
	OnCommand = cmd(addy,-140;decelerate,0.18;addy,140),
	OffCommand = cmd(linear,0.15;addy,-140),
	LoadActor("header/default.lua") .. {
		InitCommand = cmd(valign,0),
	};
};

local screen = Var "LoadingScreen"
local screenName = THEME:GetMetric(screen,"HeaderText");
local headerTextImage

if screenName then
	table.insert(out,LoadActor("text/"..screenName..".png")..{
		InitCommand=function(s)
			s:diffusealpha(0)
			if screen == "ScreenSelectMusic" or screen == "ScreenEvaluationNormal" or screen == "ScreenEvaluationCourse" then
				s:y(-1)
			else
				s:y(10)
			end
			if GAMESTATE:IsAnExtraStage() and screen == "ScreenSelectMusic" then
				s:diffuse(color("#f900fe"))
			else
				s:diffuse(Color.White)
			end
		end;
		OnCommand=cmd(diffusealpha,0;sleep,0.25;linear,0.05;diffusealpha,0.5;linear,0.05;diffusealpha,0;linear,0.05;diffusealpha,1;linear,0.05;diffusealpha,0;linear,0.05;diffusealpha,0.5;decelerate,0.1;diffusealpha,1);
		OffCommand = cmd(linear,0.05;diffusealpha,0),
	})
end;

return out
