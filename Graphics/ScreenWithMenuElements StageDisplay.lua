local StageDisplay = Def.ActorFrame{
	BeginCommand=cmd(playcommand,"Set";);
	CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Set";);
};

local screen2 = Var "LoadingScreen"

	StageDisplay[#StageDisplay+1] = LoadFont("_stagetext") .. {
		SetCommand=function(self, params)
			local Stage = GAMESTATE:GetCurrentStage();
			local StageIndex = GAMESTATE:GetCurrentStageIndex();
			local screen = SCREENMAN:GetTopScreen();
			if screen and screen.GetStageStats then
				local ss = screen:GetStageStats();
				Stage = ss:GetStage();
				StageIndex = ss:GetStageIndex();
			end
			if getenv("FixStage") == 1 then
				self:settextf("%s STAGE",THEME:GetString("CustStageSt",CustStageCheck()))
			else
				self:settextf("%s STAGE",THEME:GetString("Stage",ToEnumShortString(Stage)));
			end
			if GAMESTATE:IsAnExtraStage() and screen2 == "ScreenSelectMusic" then
				self:diffuse(color("#f900fe"))
				self:strokecolor(Alpha(color("#f900fe"),0.15));
			else
				self:diffuse(color("#dff0ff"));
				self:strokecolor(Alpha(color("#00baff"),0.15));
			end
			
		end;
	};

return StageDisplay;
