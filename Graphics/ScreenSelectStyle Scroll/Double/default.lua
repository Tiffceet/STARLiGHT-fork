local Image = Def.ActorFrame{
	GainFocusCommand=cmd(stoptweening;smooth,0.3;zoom,1);
	LoseFocusCommand=cmd(stoptweening;smooth,0.3;zoom,0.825);
	LoadActor("pad") ..{
		InitCommand=cmd(diffusealpha,0;zoomx,1;xy,2,288);
		OnCommand=cmd(zoom,0;sleep,0.5;linear,0.1;diffusealpha,1.0;zoom,1;smooth,0.1;zoom,0.9;smooth,0.1;zoom,1);
		GainFocusCommand=cmd(smooth,0.3;diffusealpha,1;diffuseshift;effectcolor1,color("1,1,1,1");effectcolor2,color("0.75,0.75,0.75,1");effectperiod,2);
		LoseFocusCommand=cmd(stopeffect;diffuse,color("0.75,0.75,0.75,1"));
	};
  LoadActor("Character") ..{
		InitCommand=cmd(diffusealpha,0;zoomx,1;xy,60,-10);
		OnCommand=cmd(sleep,0.6;linear,0.1;diffusealpha,1;zoomy,0.8;linear,0.1;zoomy,1;zoomx,1.2;linear,0.1;zoomx,1);
	};
};

local t = Def.ActorFrame{
	Image;
	--Put the reflected version in another actorframe since addy won't work.
	Def.ActorFrame{
		InitCommand=cmd(addy,750;);
		Image..{
			InitCommand=cmd(rotationx,180;diffusealpha,0;fadetop,1;zoomx,1);
			OnCommand=function(self)
				self:sleep(0.6):linear(0.1):diffusealpha(0.15):zoomy(0.55):linear(0.1):zoomy(0.825):zoomx(1):linear(0.1):zoomx(0.825)
			end;
		};
	},
	LoadActor("title small")..{
		InitCommand=cmd(diffusealpha,0;x,178;y,-120);
		MenuLeftP1MessageCommand=cmd(playcommand,"Change1");
		MenuLeftP2MessageCommand=cmd(playcommand,"Change1");
		MenuRightP1MessageCommand=cmd(playcommand,"Change1");
		MenuRightP2MessageCommand=cmd(playcommand,"Change1");
		MenuUpP1MessageCommand=cmd(playcommand,"Change1");
		MenuUpP2MessageCommand=cmd(playcommand,"Change1");
		MenuDownP1MessageCommand=cmd(playcommand,"Change1");
		MenuDownP2MessageCommand=cmd(playcommand,"Change1");
		OnCommand=function(self)
			self:playcommand("Change1")
		end;
		Change1Command=function(self)
		  local env = GAMESTATE:Env()
		  if env.DOUBLESELECT then
			self:queuecommand("GainFocus")
		  else
			self:finishtweening():linear(0.1):cropright(1):sleep(0.3):queuecommand("Change2")
		  end;
		end;
		Change2Command=cmd(zoomy,1;cropright,1;diffusealpha,1;linear,0.2;cropright,0;queuecommand,"Animate");
		GainFocusCommand=function(self)
		  local env = GAMESTATE:Env()
		  env.DOUBLESELECT = true
		  self:stoptweening():linear(0.1):zoomy(0)
		end;
		LoseFocusCommand=function(self)
		  local env = GAMESTATE:Env()
		  env.DOUBLESELECT = false
		end;
		AnimateCommand=cmd(linear,0.1;rotationz,3;linear,0.1;rotationz,-3;linear,0.1;rotationz,3;linear,0.1;rotationz,-3;linear,0.1;rotationz,0;sleep,1;queuecommand,"Animate");
		OffCommand=cmd(stoptweening;smooth,0.2;zoom,0;diffusealpha,0;);
	  };
};



return t;
