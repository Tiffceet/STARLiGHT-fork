local screen = Var "LoadingScreen"

local t = Def.ActorFrame{
  LoadActor("under mult.png")..{
    InitCommand=cmd(blend,Blend.Subtract);
  };
  LoadActor("base");
  LoadActor("side glows.png")..{
    OnCommand=cmd(cropleft,0.5;cropright,0.5;sleep,0.3;decelerate,0.4;cropleft,0;cropright,0);
    InitCommand=function(s)
      if GAMESTATE:IsAnExtraStage() and screen == "ScreenSelectMusic" then
				s:diffuse(color("#f900fe"))
      end
    end,
  };
  LoadActor("center glows.png")..{
    InitCommand=function(s)
      if GAMESTATE:IsAnExtraStage() and screen == "ScreenSelectMusic" then
				s:diffuse(color("#f900fe"))
      end
    end,
    OnCommand=cmd(cropleft,0.5;cropright,0.5;sleep,0.3;decelerate,0.4;cropleft,0;cropright,0);
  };
  Def.ActorFrame{
    OnCommand=cmd(diffusealpha,0;sleep,0.3;decelerate,0.5;diffusealpha,1);
    LoadActor("arrow")..{
      InitCommand=function(s)
        if GAMESTATE:IsAnExtraStage() and screen == "ScreenSelectMusic" then
          s:diffuse(color("#f900fe"))
        end
      end,
      OnCommand=cmd(addy,-100;sleep,0.25;decelerate,0.4;addy,100);
    };
  };
};

return t
