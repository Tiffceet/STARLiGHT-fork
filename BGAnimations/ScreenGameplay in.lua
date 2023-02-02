local playMode = GAMESTATE:GetPlayMode()
if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
	curStage = playMode;
end;
local sStage = GAMESTATE:GetCurrentStage();
local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
};

if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
else
	sStage = sStage;
end;
local t = Def.ActorFrame {};

--BGVideo
	t[#t+1] = Def.ActorFrame {
		LoadActor("ScreenWithMenuElements background")..{
			InitCommand=function(s)
				s:visible(true)
				if GAMESTATE:IsAnExtraStage() then
					s:diffuse(Color.Red)
				end
			end,
			OnCommand=function(s) s:linear(0.25):diffusealpha(0):queuecommand("Finish") end,
			FinishCommand=function(s) s:finishtweening():visible(false) end,
		};
	};
--Jacket--

t[#t+1] = Def.ActorFrame {
 	InitCommand=function(s) s:CenterX():y(SCREEN_CENTER_Y):diffusealpha(1):zoom(1) end,
	OnCommand=function(s) s:playcommand("Set"):sleep(0.5):accelerate(0.1):zoom(5):diffusealpha(0) end,
	Def.Sprite {
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			local group = song:GetGroupName();
				if song then
					if song:HasJacket() then
						self:LoadBackground(song:GetJacketPath());
						self:setsize(457,457);
					elseif song:HasBackground() then
						self:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
						self:setsize(457,457);
					else
						self:Load(THEME:GetPathG("","Common fallback jacket"));
						self:setsize(457,457);
					end;
				else
					self:diffusealpha(0);
				end;
		end;
	};
};

return t;
