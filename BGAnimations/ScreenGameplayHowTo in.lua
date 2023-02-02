local t = Def.ActorFrame{
    LoadActor(THEME:GetPathB("","ScreenWithMenuElements background/background"))..{
		InitCommand=function(s) s:FullScreen() end,
		OnCommand=function(s) s:diffusealpha(1):sleep(2):linear(0.2):diffusealpha(0) end,
  };
  LoadActor(THEME:GetPathB("","ScreenGameplay out/swoosh.ogg"))..{
    OnCommand=function(s) s:sleep(2):queuecommand("Play") end,
    PlayCommand=function(s) s:play() end,
  }
};

--Top
t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:x(_screen.cx,SCREEN_TOP):valign(0) end,
  OnCommand=function(s) s:sleep(2):decelerate(0.2):y(SCREEN_TOP-500) end,
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mult"))..{
    InitCommand=function(s) s:valign(0):blend('BlendMode_WeightedMultiply'):diffusealpha(0.25) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/base"))..{
    InitCommand=function(s) s:valign(0) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mid base"))..{
    InitCommand=function(s) s:y(120) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mid progress"))..{
    InitCommand=function(s) s:y(120):cropright(0) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/side lasers"))..{
    InitCommand=function(s) s:valign(0):cropbottom(0) end,
  };
};

--Top
t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:xy(_screen.cx,SCREEN_BOTTOM):valign(1) end,
  OnCommand=function(s) s:sleep(2):decelerate(0.2):y(SCREEN_BOTTOM+500) end,
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mult"))..{
    InitCommand=function(s) s:rotationz(180):valign(0):blend('BlendMode_WeightedMultiply'):diffusealpha(0.25) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/base"))..{
    InitCommand=function(s) s:valign(0):rotationz(180) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mid base"))..{
    InitCommand=function(s) s:y(-120):rotationz(180) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/mid progress"))..{
    InitCommand=function(s) s:y(-120):cropright(0):rotationz(180) end,
  };
  LoadActor(THEME:GetPathB("ScreenStageInformation","in/doors/side lasers"))..{
    InitCommand=function(s) s:valign(0):cropbottom(0):rotationz(180) end,
  };
};

return t;
