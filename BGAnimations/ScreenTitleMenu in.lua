return Def.Quad{
  InitCommand=cmd(diffuse,color("0,0,0,1");FullScreen);
  OnCommand=cmd(linear,0.2;diffusealpha,0);
};
