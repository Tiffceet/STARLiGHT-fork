-- BeforeLoadingNextCourseSongMessageCommand
-- StartCommand
-- ChangeCourseSongInMessageCommand
-- ChangeCourseSongOutMessageCommand
-- FinishCommand

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

return Def.ActorFrame {
	LoadActor(THEME:GetPathB("","ScreenWithMenuElements background/background"))..{
		InitCommand=function(s) s:FullScreen():diffusealpha(0) end,
		ChangeCourseSongInMessageCommand=function(s) s:linear(0.2):diffusealpha(1) end,
		FinishCommand=function(s) s:sleep(1):linear(0.2):diffusealpha(0) end,
	};
	LoadActor("ScreenStageInformation in/doors/default.lua")..{
		ChangeCourseSongInMessageCommand=function(s) s:playcommand("AnOn") end,
		FinishCommand=function(s) s:sleep(1):queuecommand("AnOff") end,
	};
	LoadActor(THEME:GetPathS( "", "_Door" ) ) .. {
		ChangeCourseSongInMessageCommand=function(s) s:queuecommand("Play") end,
		PlayCommand=function(s) s:play() end,
	};
	Def.Sprite{
		InitCommand=function(s) s:Center() end,
		BeforeLoadingNextCourseSongMessageCommand=function(self)
			local song = SCREENMAN:GetTopScreen():GetNextCourseSong()
			if song:HasJacket() then
				self:LoadBackground(song:GetJacketPath())
			end;
			self:setsize(457,457);
		end;
		ChangeCourseSongInMessageCommand=function(self)
			self:diffusealpha(0):zoom(4):sleep(0.099):linear(0.2):diffusealpha(1):zoom(1)
		end;
		FinishCommand=function(s) s:sleep(2):accelerate(0.1):zoom(5):diffusealpha(0) end,
	};
	-- Ready
	LoadActor(THEME:GetPathB("ScreenGameplay","ready/ready")) .. {
		InitCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffusealpha(0) end,
		ChangeCourseSongInMessageCommand=function(s) s:diffusealpha(0) end,
		FinishCommand = function(s) s:sleep(2.2):diffusealpha(0):zoomx(4):zoomy(0):accelerate(0.09):zoomx(1):zoomy(1):diffusealpha(1):sleep(1):accelerate(0.132):zoomx(4):zoomy(0):diffusealpha(0) end,
	};
	--go
	LoadActor(THEME:GetPathB("ScreenGameplay","go/go")) .. {
		InitCommand=function(s) s:Center():diffusealpha(0) end,
		ChangeCourseSongInMessageCommand=function(s) s:diffusealpha(0) end,
		FinishCommand = function(s) s:sleep(3.5):diffusealpha(0):zoomx(4):zoomy(0):accelerate(0.132):zoomx(1):zoomy(1):diffusealpha(1):sleep(1):accelerate(0.132):zoomx(4):zoomy(0):diffusealpha(0) end,
	};
};
