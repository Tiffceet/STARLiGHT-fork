return Def.ActorFrame {
	Def.Sprite{
		Texture="Choice Extended A.png";
		InitCommand=cmd();
		OnCommand=cmd(addy,-SCREEN_HEIGHT;sleep,0.1;decelerate,0.2;addy,SCREEN_HEIGHT);
		OffCommand=function(s) s:accelerate(0.2):addy(-SCREEN_HEIGHT) end,
		GainFocusCommand=function(self)
			self:Load(THEME:GetPathG("","ScreenSelectPlayCourseMode scroller/Choice Extended A.png"))
			self:stoptweening():linear(0.05):x(50)
		end;
		LoseFocusCommand=function(self)
			self:Load(THEME:GetPathG("","ScreenSelectPlayCourseMode scroller/Choice Extended B.png"))
			self:stoptweening():linear(0.05):x(60)
		end;
	};
	LoadActor(THEME:GetPathG("","_shared/garrows/_selectarrowg"))..{
		InitCommand=cmd(x,-350;zoomx,-1);
		OnCommand=cmd(addx,-SCREEN_WIDTH;sleep,0.1;decelerate,0.2;addx,SCREEN_WIDTH);
		OffCommand=function(s) s:decelerate(0.2):addx(-SCREEN_WIDTH) end,
		GainFocusCommand=cmd(stoptweening;stopeffect;diffusealpha,0;linear,0.05;diffusealpha,1;x,-350;bob;effectmagnitude,10,0,0;effectperiod,0.7);
		LoseFocusCommand=cmd(stoptweening;linear,0.05;diffusealpha,0;x,-400);
	};
};
