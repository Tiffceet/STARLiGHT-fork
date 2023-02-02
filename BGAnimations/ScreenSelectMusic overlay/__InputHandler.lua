local function WheelMove(mov)
  local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel");
	mw:Move(mov)
end

local t = Def.ActorFrame{
  OnCommand=function(self)
	  SCREENMAN:GetTopScreen():AddInputCallback(DDRInput(self))
	  SCREENMAN:set_input_redirected(PLAYER_1, true)
	  SCREENMAN:set_input_redirected(PLAYER_2, true)
	end,
	OffCommand=function(self)
	  SCREENMAN:GetTopScreen():RemoveInputCallback(DDRInput(self))
	  SCREENMAN:set_input_redirected(PLAYER_1, false)
	  SCREENMAN:set_input_redirected(PLAYER_2, false)
	end,
  StartReleaseCommand=function(self)
	  local mw = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel");
    local song = GAMESTATE:GetCurrentSong() 
    if mw:GetSelectedType() == 'WheelItemDataType_Section' then
      if GAMESTATE:GetExpandedSectionName() == mw:GetSelectedSection() then
        mw:SetOpenSection("")
      else
        mw:SetOpenSection(mw:GetSelectedSection())
      end;
      SOUND:PlayOnce(THEME:GetPathS("","MusicWheel expand.ogg"))
    end
    if ThemePrefs.Get("WheelType") == "Jukebox" or ThemePrefs.Get("WheelType") == "Wheel" then
		  if song then
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_MenuTimer")
      end
    else
      SCREENMAN:AddNewScreenToTop("ScreenSelectDifficulty")
		end;
  end;
  StartRepeatCommand=function(self)
    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
    local song = GAMESTATE:GetCurrentSong()
    if song then
      if ThemePrefs.Get("WheelType") == "Jukebox" or ThemePrefs.Get("WheelType") == "Wheel" then
        SCREENMAN:AddNewScreenToTop("ScreenPlayerOptionsPopup","SM_MenuTimer")
      else
        SCREENMAN:AddNewScreenToTop("ScreenPlayerOptionsPopup")
      end
    else
    end;
  end;
  SongUnchosenMessageCommand=function(self)
    self:sleep(0.5):queuecommand("On");
  end;
  MenuLeftCommand=function(s) WheelMove(-1)
    SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change.ogg"))
  end;
  MenuLeftRepeatCommand=function(s) s:queuecommand("MenuLeft") end;
  MenuLeftReleaseCommand=function(self) WheelMove(0) end;
  MenuRightCommand=function(s)
    WheelMove(1)
    SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change.ogg"))
  end;
  MenuRightRepeatCommand=function(s) s:queuecommand("MenuRight") end;
  MenuRightReleaseCommand=function(self) WheelMove(0) end;
  MenuUpCommand=function(s)
    if ThemePrefs.Get("WheelType") == "A" then
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel");
      if mw:GetSelectedType() == 'WheelItemDataType_Song' then
        WheelMove(-3)
      else
        WheelMove(1)
      end
      SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change.ogg"))
    end
  end,
  MenuUpRepeatCommand=function(s) s:queuecommand("MenuUp") end;
  MenuUpReleaseCommand=function(self) WheelMove(0) end;
  MenuDownCommand=function(s)
    if ThemePrefs.Get("WheelType") == "A" then
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel");
      if mw:GetSelectedType() == 'WheelItemDataType_Song' then
        WheelMove(3)
      else
        WheelMove(-1)
      end
      SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change.ogg"))
    end
  end,
  MenuDownRepeatCommand=function(s) s:queuecommand("MenuDown") end;
  MenuDownReleaseCommand=function(self) WheelMove(0) end;
};

return t;
