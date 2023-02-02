local function InputHandler(event)
  local player = event.PlayerNumber
  local MusicWheel = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel");
  if event.type == "InputEventType_Release" then return false end
  if MusicWheel ~= nil then
    if event.GameButton == "MenuLeft" and GAMESTATE:IsPlayerEnabled(player) then
      SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
    end
    if event.GameButton == "MenuRight" and GAMESTATE:IsPlayerEnabled(player) then
      SOUND:PlayOnce(THEME:GetPathS("","_MusicWheel change"))
    end
  end
end
local t = Def.ActorFrame{
  OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) end;
  OffCommand=function(self) SCREENMAN:GetTopScreen():RemoveInputCallback(InputHandler) end,
};

return t;
