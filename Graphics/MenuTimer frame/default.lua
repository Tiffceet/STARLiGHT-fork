local t = Def.ActorFrame{};
local screen = Var "LoadingScreen"

t[#t+1] = Def.ActorFrame{
  Def.ActorFrame{
    InitCommand=function(s) s:spin():effectmagnitude(5,10,8) end,
    LoadActor( "star" )..{
      InitCommand=function(s) s:rotationx(60):rotationy(20):diffusealpha(0.4) end,
      OnCommand=function(self)
        self:spin():effectmagnitude(0,0,-100):blend(Blend.Add)
      end;
      OffCommand=cmd(stoptweening;);
    };
  };
  LoadActor( "timer ring" )..{
    InitCommand=function(s) s:rotationx(60):rotationy(-20) end,
    OnCommand=function(self)
      self:spin():effectmagnitude(0,0,100)
    end;
    OffCommand=cmd(stoptweening;);
  };
};

return t;
