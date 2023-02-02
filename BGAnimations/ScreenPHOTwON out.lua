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
    ThemePrefs.Set("WheelType",ThemePrefs.Get("WheelType"))
    THEME:ReloadMetrics()
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
      f:Write(GetMenuMusicPath("common",true))
      f:Close()
    elseif SN3Debug then
      SCREENMAN:SystemMessage("Couldn't open select music redir")
    end
    f:destroy()
	CurrentMenuMusic = ThemePrefs.Get("MenuMusic")
    THEME:ReloadMetrics()
  end
end

return t;
