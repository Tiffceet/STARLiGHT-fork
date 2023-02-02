local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
  LoadActor(ThemePrefs.Get("MenuBG"));
};

return t
