local out = Def.ActorFrame{
  InitCommand=function(s) s:xy(_screen.cx,SCREEN_BOTTOM-68) end,
  OnCommand=function(s) s:addy(140):decelerate(0.18):addy(-140) end,
  OffCommand =cmd(linear,0.15;addy,140);
  LoadActor("base");
  LoadActor("side glow")..{
    OnCommand=cmd(cropleft,0.5;cropright,0.5;sleep,0.3;decelerate,0.4;cropleft,0;cropright,0;sleep,0.5;queuecommand,"Anim");
    AnimCommand=function(s) s:diffuseshift():effectcolor1(color("1,1,1,1")):effectcolor2(color("1,1,1,0.5")):effectperiod(2) end,
  };
  Def.ActorFrame{
    OnCommand=cmd(diffusealpha,0;sleep,0.3;decelerate,0.5;diffusealpha,1);
    LoadActor("arrow")..{
      InitCommand=cmd(y,-26);
      OnCommand=cmd(addy,100;sleep,0.25;decelerate,0.4;addy,-100);
    };
  };
};

local screen = Var "LoadingScreen"
local screenName = THEME:GetMetric(screen,"FooterText");
local footerTextImage

if screenName then
	table.insert(out,LoadActor("text/"..screenName..".png")..{
		InitCommand = cmd(xy,0,26;diffusealpha,0),
    OnCommand=function(s) s:diffusealpha(0):sleep(0.25):linear(0.05):diffusealpha(0.5):linear(0.05):diffusealpha(0):linear(0.05):diffusealpha(1):linear(0.05):diffusealpha(0):linear(0.05):diffusealpha(0.5):decelerate(0.1):diffusealpha(1):sleep(0.1):queuecommand("Anim") end,
    AnimCommand=function(s) s:diffuseshift():effectcolor1(color("1,1,1,1")):effectcolor2(color("1,1,1,0.5")):effectperiod(0.4) end,
		OffCommand = cmd(linear,0.05;diffusealpha,0),
	})
end;



return out;
