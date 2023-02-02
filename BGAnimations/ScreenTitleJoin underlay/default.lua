local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathB("","ScreenLogo underlay/flourish")) .. {
		-- Swoosh under the dancer
		InitCommand = cmd(xy,_screen.cx,_screen.cy+92;diffusealpha,0.5),
	  OnCommand=cmd(cropright,1;linear,0.3;cropright,0);
	};
	LoadActor(THEME:GetPathB("","ScreenLogo underlay/streak")) .. {
		-- Swoosh behind the logo text
		InitCommand = cmd(xy,_screen.cx+25,_screen.cy+8),
	  OnCommand=cmd(cropright,1;linear,0.3;cropright,0);
	};
	LoadActor(THEME:GetPathB("","ScreenLogo underlay/dancer")) .. {
		InitCommand = cmd(clearzbuffer,true;
			xy,_screen.cx-432,_screen.cy+11),
	  OnCommand=cmd(diffusealpha,0;linear,0.3;diffusealpha,1);
	};
	LoadActor(THEME:GetPathB("","ScreenLogo underlay/spotlight")) .. {
		InitCommand = cmd(zoomtoheight,_screen.h;
			xy,_screen.cx-414,_screen.cy),
	  OnCommand=cmd(diffusealpha,0;linear,0.3;diffusealpha,1);
	};
  };
  
  t[#t+1] = Def.ActorFrame{
	LoadActor(THEME:GetPathB("","ScreenLogo underlay/XX.png"))..{
	  InitCommand=cmd(xy,_screen.cx+360,_screen.cy);
	};
	LoadActor(THEME:GetPathB("","ScreenLogo underlay/starlight.png"))..{
	  InitCommand=cmd(xy,_screen.cx-20,_screen.cy+10);
	};
	LoadActor(THEME:GetPathB("","ScreenLogo underlay/main.png"))..{
	  InitCommand=cmd(xy,_screen.cx-100,_screen.cy-90);
	};
  };
  
  t[#t+1] = Def.ActorFrame{
	Def.Quad {
		InitCommand = cmd(zoomto,80,504;xy,_screen.cx-562,_screen.cy+4;skewx,3;
			MaskSource,true),
		OnCommand = cmd(queuecommand,"Animate"),
		AnimateCommand = cmd(x,_screen.cx-562;linear,0.8;addx,1500;
		 sleep,7;queuecommand,"Animate"),
	};
	LoadActor(THEME:GetPathB("","ScreenLogo underlay/shine.png")) .. {
	  -- Using WriteOnFail here allows us to display only what is UNDER the
	  -- mask instead of only what is NOT UNDER it.
	  InitCommand = cmd(xy,_screen.cx+106,_screen.cy+4;
		  MaskDest;ztestmode,"ZTestMode_WriteOnFail"),
	};
  };

local coinmode = GAMESTATE:GetCoinMode()

-- top message
t[#t+1] = Def.Sprite{
	InitCommand=function(s) s:xy(_screen.cx,_screen.cy+340):diffuseshift():effectcolor1(Color.White):effectcolor2(color("#B4FF01")) end,
	BeginCommand=function(s) s:queuecommand("Set") end,
	CoinInsertedMessageCommand=function(s) s:queuecommand("Set") end,
	SetCommand=function(s)
	  if coinmode == 'CoinMode_Free' then
		s:Load(THEME:GetPathB("","ScreenTitleJoin underlay/_press start"))
	  else
		if GAMESTATE:EnoughCreditsToJoin() == true then
		  s:Load(THEME:GetPathB("","ScreenTitleJoin underlay/_press start"))
		else
		  s:Load(THEME:GetPathB("","ScreenTitleJoin underlay/_insert coin"))
		end
	  end
	end
  };

  t[#t+1] = Def.Actor{
	  BeginCommand=function(s) s:queuecommand("Delay") end,
	  DelayCommand=function(s) s:sleep(10):queuecommand("SetScreen") end,
	  SetScreenCommand=function(s)
		SCREENMAN:GetTopScreen():SetNextScreenName("ScreenDemonstration"):StartTransitioningScreen("SM_GoToNextScreen")
	  end,
  }

return t;