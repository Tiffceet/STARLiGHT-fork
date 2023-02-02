local t = Def.ActorFrame{
};

--Top
t[#t+1] = Def.ActorFrame{
  InitCommand=cmd(CenterX;y,SCREEN_TOP;valign,0);
  AnOnCommand=cmd(y,SCREEN_TOP-500;sleep,0.2;decelerate,0.2;y,SCREEN_TOP);
  AnOffCommand=cmd(decelerate,0.2;y,SCREEN_TOP-500);
  LoadActor("mult")..{
    InitCommand=cmd(valign,0;blend,'BlendMode_WeightedMultiply';diffusealpha,0.25);
  };
  LoadActor("base")..{
    InitCommand=cmd(valign,0);
    AnOnCommand=cmd(diffuse,color("0.5,0.5,0.5,1");sleep,0.5;decelerate,1;diffuse,color("1,1,1,1"));
  };
  LoadActor("mid base")..{
    InitCommand=cmd(y,120);
  };
  LoadActor("mid progress")..{
    InitCommand=cmd(y,120;cropright,1);
    AnOnCommand=cmd(cropright,1;sleep,0.5;decelerate,2;cropright,0);
  };
  LoadActor("side lasers.png")..{
    InitCommand=cmd(valign,0;cropbottom,1);
    AnOnCommand=cmd(sleep,0.5;decelerate,2;cropbottom,0);
  };
  LoadActor("Initializing.png")..{
    InitCommand=cmd(y,80;diffusealpha,0);
    AnOnCommand=cmd(diffusealpha,0;sleep,0.5;linear,0.05;diffusealpha,0.5;linear,0.05;diffusealpha,0;linear,0.05;diffusealpha,1;linear,0.05;diffusealpha,0;linear,0.05;diffusealpha,0.5;decelerate,0.1;diffusealpha,1);
  };
  LoadActor("Starlight.png")..{
    InitCommand=cmd(y,160;diffusealpha,0);
    AnOnCommand=cmd(sleep,1.5;decelerate,0.5;diffusealpha,1);
  };
};

--Top
t[#t+1] = Def.ActorFrame{
  InitCommand=cmd(CenterX;y,SCREEN_BOTTOM;valign,1);
  AnOnCommand=cmd(y,SCREEN_BOTTOM+500;sleep,0.2;decelerate,0.2;y,SCREEN_BOTTOM);
  AnOffCommand=cmd(decelerate,0.2;y,SCREEN_BOTTOM+500);
  LoadActor("mult")..{
    InitCommand=cmd(rotationz,180;valign,0;blend,'BlendMode_WeightedMultiply';diffusealpha,0.25);
  };
  LoadActor("base")..{
    InitCommand=cmd(valign,0;rotationz,180);
    AnOnCommand=cmd(diffuse,color("0.5,0.5,0.5,1");sleep,0.5;decelerate,1;diffuse,color("1,1,1,1"));
  };
  LoadActor("mid base")..{
    InitCommand=cmd(y,-120;;rotationz,180);
  };
  LoadActor("mid progress")..{
    InitCommand=cmd(y,-120;cropright,1;;rotationz,180);
    AnOnCommand=cmd(cropleft,1;sleep,0.5;decelerate,2;cropleft,0);
  };
  LoadActor("side lasers.png")..{
    InitCommand=cmd(valign,0;cropbottom,1;;rotationz,180);
    AnOnCommand=cmd(sleep,0.5;decelerate,2;cropbottom,0);
  };
  LoadActor("dance.png")..{
    InitCommand=cmd(y,-160;diffusealpha,0);
    AnOnCommand=cmd(diffusealpha,0;sleep,0.5;linear,0.05;diffusealpha,0.5;linear,0.05;diffusealpha,0;linear,0.05;diffusealpha,1;linear,0.05;diffusealpha,0;linear,0.05;diffusealpha,0.5;decelerate,0.1;diffusealpha,1);
  };
  LoadActor("prep.png")..{
    InitCommand=cmd(y,-80;diffusealpha,0);
    AnOnCommand=cmd(diffusealpha,0;sleep,0.5;linear,0.05;diffusealpha,0.5;linear,0.05;diffusealpha,0;linear,0.05;diffusealpha,1;linear,0.05;diffusealpha,0;linear,0.05;diffusealpha,0.5;decelerate,0.1;diffusealpha,1);
  };
};

return t;
