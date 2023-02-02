local StageDisplay = Def.ActorFrame{
	BeginCommand=cmd(playcommand,"Set";);
	CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Set";);
};

function MakeBitmapText()
	return LoadFont("_avenirnext lt pro bold 36px") .. {
		InitCommand=cmd(maxwidth,180);
	};
end

if GAMESTATE:IsCourseMode() then
	StageDisplay[#StageDisplay+1] = MakeBitmapText() .. {
		Text="",
		SetCommand=function(self, _)
			local Stage1=tostring(GAMESTATE:GetAppropriateStageNum())
			self:settext(FormatNumberAndSuffix(Stage1))
		end,
		DoneLoadingNextSongMessageCommand=function(s) s:queuecommand("Set") end
	}
else
	for s in ivalues(Stage) do

	if s ~= 'Stage_Next' and s ~= 'Stage_Nonstop' and s ~= 'Stage_Oni' and s ~= 'Stage_Endless' and s ~= 'Stage_Demo' then
		StageDisplay[#StageDisplay+1] = MakeBitmapText() .. {
			SetCommand=function(self, params)
				local Stage = GAMESTATE:GetCurrentStage();
				local StageIndex = GAMESTATE:GetCurrentStageIndex()+1
				local screen = SCREENMAN:GetTopScreen()
				if getenv("FixStage") == 1 then
					self:settext(THEME:GetString("CustStageSt",CustStageCheck()))
				elseif GAMESTATE:IsEventMode() then
					self:settext(FormatNumberAndSuffix(StageIndex))
				else
					self:settext(StageToLocalizedString(Stage))
				end
			end;
		};
	end

	end
end

return StageDisplay;
