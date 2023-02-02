local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
  LoadActor(THEME:GetPathB("","ScreenWithMenuElements background/"..ThemePrefs.Get("MenuBG")));
};

return t;
