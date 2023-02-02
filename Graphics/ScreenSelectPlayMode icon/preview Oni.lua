local t = Def.ActorFrame {
  Def.ActorFrame{
		GainFocusCommand=cmd(diffuse,color("1,1,1,1"));
		LoseFocusCommand=cmd(diffuse,color("0.5,0.5,0.5,1"));
    LoadActor( "Course Play/box" )..{
	  	InitCommand=cmd(y,192);
			OnCommand=cmd(diffusealpha,0;zoomy,0;sleep,0.2;smooth,0.2;zoomy,1;diffusealpha,1);
		};
	};
};
t[#t+1] = Def.ActorFrame{
  InitCommand=cmd(y,-28);
-- Load of Music play frame --
  Def.Sprite{
    OnCommand=cmd(diffusealpha,1);
    GainFocusCommand=function(self)
      self:Load(THEME:GetPathG("","ScreenSelectPlayMode icon/Course Play/bgframe"))
    end;
    LoseFocusCommand=function(self)
      self:Load(THEME:GetPathG("","ScreenSelectPlayMode icon/Course Play/bg dark"))
    end;
  };
  Def.Sprite{
    InitCommand=cmd(y,-32);
    GainFocusCommand=function(self)
      self:Load(THEME:GetPathG("","ScreenSelectPlayMode icon/Course Play/char.png"))
    end;
    LoseFocusCommand=function(self)
      self:Load(THEME:GetPathG("","ScreenSelectPlayMode icon/Course Play/char dark.png"))
    end;
  };
  Def.ActorFrame{
		InitCommand=cmd(;x,-300;y,240;zoomx,1);
		OnCommand=cmd(zoomy,0;sleep,0.2;linear,0.2;zoomy,1;queuecommand,"Animate");
		AnimateCommand=cmd(bob;effectmagnitude,10,0,0;effectperiod,0.7);
		GainFocusCommand=cmd(finishtweening;linear,0.2;zoomx,1;zoomy,1;queuecommand,"Animate");
		LoseFocusCommand=cmd(stoptweening;linear,0.1;zoom,0);
		OffCommand=cmd(diffusealpha,0);
    LoadActor( THEME:GetPathG("","ScreenSelectPlayMode icon/_selectarrowg") );
		LoadActor( THEME:GetPathG("","ScreenSelectPlayMode icon/_selectarrowr") )..{
			InitCommand=cmd(diffusealpha,0;draworder,100);
			GainFocusCommand=cmd(diffusealpha,0);
			LoseFocusCommand=cmd(diffusealpha,1;sleep,0.4;diffusealpha,0);
		};
	};
}

return t;
