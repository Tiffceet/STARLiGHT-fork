-- gameplay life frame

local t = Def.ActorFrame{}
t[#t+1] = LoadActor("flicker");
for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.Sprite{
		Name = pn,
    InitCommand=function(self)
      self:zoom(IsUsingWideScreen() and 1 or 0.8):rotationy(pn == PLAYER_2 and 180 or 0)
      :x(pn==PLAYER_1 and ScreenGameplay_P1X()-7 or ScreenGameplay_P2X()+7)
		end,
    BeginCommand=function(self)
      if GAMESTATE:IsAnExtraStage() then
        self:Load(THEME:GetPathG("ScreenGameplay","LifeFrame/extra.png"))
      elseif GAMESTATE:PlayerIsUsingModifier(pn,'battery') or GAMESTATE:GetPlayMode() == 'PlayMode_Oni' then
        self:Load(THEME:GetPathG("ScreenGameplay","LifeFrame/4live.png"))

      else
        self:Load(THEME:GetPathG("ScreenGameplay","LifeFrame/normal.png"))
      end;
    end;
	};
end;


return t
