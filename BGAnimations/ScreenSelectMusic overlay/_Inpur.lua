local function InputHandler(event)
local player = event.PlayerNumber
local MusicWheel = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel");
  if event.type == "InputEventType_Release" then return false end
    if MusicWheel ~= nil then
      if event.GameButton == "MenuLeft" then
        	MusicWheel:Move(-1)
        SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change.ogg"))
      end
      if event.GameButton == "MenuRight" then
        MusicWheel:Move(1)
        SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change.ogg"))
      end
      if ThemePrefs.Get("WheelType") == "A" then
        if event.GameButton == "MenuDown" then
  				if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
            MusicWheel:Move(3)
            MusicWheel:Move(0)
          else
            MusicWheel:Move(1)
  				end
          SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change.ogg"))
        end
        if event.GameButton == "MenuUp" then
  				if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
            MusicWheel:Move(-3)
            MusicWheel:Move(0)
  				else
  					MusicWheel:Move(-1)
  				end
          SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change.ogg"))
        end
      end;
    end
	end
local t = Def.ActorFrame {
	OnCommand=function(self)
    local MusicWheel = SCREENMAN:GetTopScreen():GetChild("MusicWheel");
    SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
  end;
  SongChosenMessageCommand=function(self)
    local MusicWheel = SCREENMAN:GetTopScreen():GetChild("MusicWheel");
    self:hibernate(0.5)
    SCREENMAN:GetTopScreen():RemoveInputCallback(InputHandler)
  end;
  SongUnchosenMessageCommand=function(self)
    self:sleep(0.5);
    self:queuecommand("On");
  end;
};

return t;
