local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
  InitCommand=cmd(xy,_screen.cx,SCREEN_TOP+100);
  LoadActor("bluething")..{
    InitCommand=cmd(xy,68,34);
    OnCommand=cmd(addx,SCREEN_WIDTH;decelerate,0.2;addx,-SCREEN_WIDTH);
    OffCommand=cmd(decelerate,0.2;addx,-SCREEN_WIDTH);
  };
  LoadActor("star")..{
    InitCommand=cmd(xy,-138,64);
    OnCommand=cmd(addx,SCREEN_WIDTH;sleep,0.1;decelerate,0.24;addx,-SCREEN_WIDTH);
    OffCommand=cmd(sleep,0.1;decelerate,0.24;addx,-SCREEN_WIDTH);
  };
  LoadActor("star")..{
    InitCommand=cmd(xy,318,-60);
    OnCommand=cmd(addx,SCREEN_WIDTH;sleep,0.25;decelerate,0.22;addx,-SCREEN_WIDTH);
    OffCommand=cmd(sleep,0.25;decelerate,0.22;addx,-SCREEN_WIDTH-200);
  };
  LoadActor("arrow")..{
    InitCommand=cmd(zoom,0.4;xy,-768,-56);
    OnCommand=cmd(addx,SCREEN_WIDTH;sleep,0.2;decelerate,0.28;addx,-SCREEN_WIDTH);
    OffCommand=cmd(sleep,0.2;decelerate,0.28;addx,-SCREEN_WIDTH);
  };
  LoadActor("arrow")..{
    InitCommand=cmd(zoom,0.6;xy,628,-26);
    OnCommand=cmd(addx,SCREEN_WIDTH;sleep,0.25;decelerate,0.18;addx,-SCREEN_WIDTH);
    OffCommand=cmd(sleep,0.25;decelerate,0.18;addx,-SCREEN_WIDTH);
  };
  LoadActor("arrow")..{
    InitCommand=cmd(xy,-476,-10);
    OnCommand=cmd(addx,SCREEN_WIDTH;sleep,0.3;decelerate,0.2;addx,-SCREEN_WIDTH);
    OffCommand=cmd(sleep,0.3;decelerate,0.2;addx,-SCREEN_WIDTH);
  };
  LoadActor("text")..{
    InitCommand=cmd(xy,0,-10);
    OnCommand=cmd(diffusealpha,0;sleep,0.5;decelerate,0.2;diffusealpha,1);
    OffCommand=cmd(decelerate,0.2;diffusealpha,0);
  };
};

return t;
