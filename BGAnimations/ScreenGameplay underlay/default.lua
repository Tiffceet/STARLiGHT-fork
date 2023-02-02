local t = Def.ActorFrame{};
local style = GAMESTATE:GetCurrentStyle():GetStyleType()
local st = GAMESTATE:GetCurrentStyle():GetStepsType();
local show_cutins = GAMESTATE:GetCurrentSong() and (not GAMESTATE:GetCurrentSong():HasBGChanges()) or true;
local Center1Player = PREFSMAN:GetPreference('Center1Player')

local x_table = {
  PlayerNumber_P1 = {SCREEN_CENTER_X+428},
  PlayerNumber_P2 = {SCREEN_CENTER_X-428}
}
--toasty loader
if show_cutins and st ~= 'StepsType_Dance_Double' and ThemePrefs.Get("FlashyCombo") == true and IsUsingWideScreen() then
--use ipairs here because i think it expects P1 is loaded before P2
for _, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
t[#t+1] = Def.ActorFrame{
  LoadActor("Cutin.lua", pn)..{
    OnCommand=function(s) s:setsize(450,SCREEN_HEIGHT) end,
    InitCommand=function(self)
      self:CenterY()
      if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
        self:x(SCREEN_CENTER_X);
      else
        if Center1Player then
          self:x(pn==PLAYER_1 and _screen.cx-600 or _screen.cx+600)
        else
          self:x(x_table[pn][1]);
        end
      end;
    end;
  };
};
end;
end;

return t;
