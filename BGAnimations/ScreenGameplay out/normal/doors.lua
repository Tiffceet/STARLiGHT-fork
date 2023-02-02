local t = Def.ActorFrame{
};

--Top
t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:x(_screen.cx,SCREEN_TOP):valign(0) end,
  AnOnCommand=function(s) s:y(SCREEN_TOP-500):sleep(0.2):decelerate(0.2):y(SCREEN_TOP) end,
  AnOffCommand=function(s) s:decelerate(0.2):y(SCREEN_TOP-500) end,
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mult"))..{
    InitCommand=function(s) s:valign(0):blend('BlendMode_WeightedMultiply'):diffusealpha(0.25) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/base"))..{
    InitCommand=function(s) s:valign(0) end,
    AnOnCommand=function(s) s:diffuse(color("0.5,0.5,0.5,1")):sleep(0.5):decelerate(1):diffuse(color("1,1,1,1")) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mid base"))..{
    InitCommand=function(s) s:y(120) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mid progress"))..{
    InitCommand=function(s) s:y(120):cropright(1) end,
    AnOnCommand=function(s) s:cropright(1):sleep(0.5):decelerate(2):cropright(0) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/side lasers"))..{
    InitCommand=function(s) s:valign(0):cropbottom(1) end,
    AnOnCommand=function(s) s:sleep(0.5):decelerate(2):cropbottom(0) end,
  };
};

--Top
t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:xy(_screen.cx,SCREEN_BOTTOM):valign(1) end,
  AnOnCommand=function(s) s:y(SCREEN_BOTTOM+500):sleep(0.2):decelerate(0.2):y(SCREEN_BOTTOM) end,
  AnOffCommand=function(s) s:decelerate(0.2):y(SCREEN_BOTTOM+500) end,
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mult"))..{
    InitCommand=function(s) s:rotationz(180):valign(0):blend('BlendMode_WeightedMultiply'):diffusealpha(0.25) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/base"))..{
    InitCommand=function(s) s:valign(0):rotationz(180) end,
    AnOnCommand=function(s) s:diffuse(color("0.5,0.5,0.5,1")):sleep(0.5):decelerate(1):diffuse(color("1,1,1,1")) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mid base"))..{
    InitCommand=function(s) s:y(-120):rotationz(180) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mid progress"))..{
    InitCommand=function(s) s:y(-120):cropright(1):rotationz(180) end,
    AnOnCommand=function(s) s:cropleft(1):sleep(0.5):decelerate(2):cropleft(0) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/side lasers"))..{
    InitCommand=function(s) s:valign(0):cropbottom(1):rotationz(180) end,
    AnOnCommand=function(s) s:sleep(0.5):decelerate(2):cropbottom(0) end, 
  };
};

return t;
