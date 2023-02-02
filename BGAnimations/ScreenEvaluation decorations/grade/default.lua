local args = {...}
-- the only arg is arg 1, the player number
local function m(metric)
	metric = metric:gsub("PN", ToEnumShortString(args[1]))
	return THEME:GetMetric(Var "LoadingScreen",metric)
end

local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(args[1])

local tier = pss:GetFailed() and 'Grade_Failed' or pss:GetGrade()

if ThemePrefs.Get("ConvertScoresAndGrades") == true then
	tier = pss:GetFailed() and 'Grade_Failed' or SN2Grading.ScoreToGrade(pss:GetScore())
end

local t = Def.ActorFrame {};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("fc_ring",pss)..{InitCommand=function(s) s:xy(m "GradePNX"+140,m "GradePNY"+25)end,}
end;

t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		InitCommand = function(s) s:x(m "GradePNX"):y(m "GradePNY"):queuecommand("Set") end,
		OnCommand = m "GradePNOnCommand",
		OffCommand = m "GradePNOffCommand",
		SetCommand= function(s)
			s:Load(THEME:GetPathB("ScreenEvaluation decorations/grade/GradeDisplayEval", ToEnumShortString(tier)))
		end;
	};
};

return t;
