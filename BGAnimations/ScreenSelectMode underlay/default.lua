local t = Def.ActorFrame{
  OnCommand=function(self)
    if not FILEMAN:DoesFileExist("Save/ThemePrefs.ini") then
      Trace("ThemePrefs doesn't exist; creating file")
      ThemePrefs.ForceSave()
    end
    if SN3Debug then
      SCREENMAN:SystemMessage("Saving ThemePrefs.")
    end
    ThemePrefs.Save()
  end;
};

local mus_path = THEME:GetCurrentThemeDirectory().."/Sounds/ScreenSelectMusic music (loop).redir"
--update the select music redir here...
if ThemePrefs.Get("MenuMusic") ~= CurrentMenuMusic then
  if not CurrentMenuMusic and FILEMAN:DoesFileExist(mus_path) then
    CurrentMenuMusic = ThemePrefs.Get("MenuMusic")
  else
    local f = RageFileUtil.CreateRageFile()
    local worked = f:Open(mus_path, 10)
    if worked then
      f:Write(GetMenuMusicPath("music",true))
      f:Close()
    elseif SN3Debug then
      SCREENMAN:SystemMessage("Couldn't open select music redir")
    end
    f:destroy()
	CurrentMenuMusic = ThemePrefs.Get("MenuMusic")
    THEME:ReloadMetrics()
  end
end

t[#t+1] = Def.ActorFrame{
  LoadActor(THEME:GetPathB("","ScreenLogo underlay/XX.png")) .. {
    InitCommand=function(s) s:Center() end,
    OnCommand=function(s) s:x(_screen.cx+360) end,
  };
  LoadActor(THEME:GetPathB("","ScreenLogo underlay/starlight.png")) .. {
    InitCommand=function(s) s:xy(_screen.cx-20,_screen.cy+10) end,
  };
  LoadActor(THEME:GetPathB("","ScreenLogo underlay/main.png")) .. {
    InitCommand=function(s) s:xy(_screen.cx-100,_screen.cy-90) end,
  };
};

t[#t+1] = Def.Quad{
	InitCommand=function(s) s:FullScreen():diffuse(color("0,0,0,1")) end,
	OnCommand=function(s) s:diffusealpha(0):linear(0.2):diffusealpha(0.5) end,
};

t[#t+1] = Def.ActorFrame {
  Def.BitmapText{
  Font="Common normal",
  Text=themeInfo["Name"] .. " " .. themeInfo["Version"] .. " by " .. themeInfo["Author"] .. (SN3Debug and " (debug mode)" or "") ,
  InitCommand=function(s) s:halign(1):xy(SCREEN_RIGHT,SCREEN_TOP+90):diffusealpha(0.5):wrapwidthpixels(400) end,
};}


return t;
