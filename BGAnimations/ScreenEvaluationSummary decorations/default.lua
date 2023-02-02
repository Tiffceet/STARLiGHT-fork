local i = 0;

local t = Def.ActorFrame{};
local jk = LoadModule "Jacket.lua"

local function StageCheck()
	if getenv("FixStage") == 1 then return 2 else return 1 end
end

local yspacing = 105

local mStages = STATSMAN:GetStagesPlayed()
for i = StageCheck(), mStages do
	local ssStats;
	if getenv("FixStage") == 1 then
		ssStats = STATSMAN:GetPlayedStageStats( i-1 );
	else
		ssStats = STATSMAN:GetPlayedStageStats( i );
	end
	local sssong = ssStats:GetPlayedSongs()[1];
	t[#t+1] = Def.ActorFrame{
		Name="Center",
		Def.ActorFrame{
			InitCommand=function(s) s:y(_screen.cy + ((mStages - i)*yspacing)):x(_screen.cx)
				:basezoom(IsUsingWideScreen() and 1 or 0.8):zoomy(0)
			end,
			OnCommand=function(self) self:zoomy(0):sleep(0.25+(i-mStages)*-0.1):linear(0.2):zoomy(1) end;
			OffCommand=function(s) s:linear(0.25):zoomy(0) end,
			Def.Sprite{Texture="line.png",};
			Def.Sprite{
				Name="Jacket";
				BeginCommand=function(s)
					s:x(-290)
					:Load(jk.GetSongGraphicPath(sssong,"Jacket")):scaletoclipped(87,87)
				end,
			};
			Def.BitmapText{
				Name="Title",
				Font="_avenirnext lt pro bold 42px",
				BeginCommand=function(s)
					s:x(26):settext(sssong:GetDisplayFullTitle()):maxwidth(400)
				end,
			};
		};
	};
	for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
		local pss = ssStats:GetPlayerStageStats(pn)
		t[#t+1] = Def.ActorFrame{
			Name="Stats",
			InitCommand=function(s)
				s:y(_screen.cy + ((mStages - i)*yspacing)):basezoom(IsUsingWideScreen() and 1 or 0.8)
				if IsUsingWideScreen() then
					s:x(pn==PLAYER_1 and SCREEN_LEFT+248 or SCREEN_RIGHT-248)
				else
					s:x(pn==PLAYER_1 and SCREEN_LEFT+200 or SCREEN_RIGHT-200)
				end
				s:addx(pn==PLAYER_1 and -SCREEN_WIDTH or SCREEN_WIDTH)
			end,
			OnCommand=function(s)
				s:sleep(0.05+(i-mStages)*-0.1):linear(0.4):addx(pn==PLAYER_1 and SCREEN_WIDTH or -SCREEN_WIDTH)
			end,
			OffCommand=function(s)
				s:linear(0.4):addx(pn==PLAYER_1 and -SCREEN_WIDTH or SCREEN_WIDTH)
			end,
			Def.Sprite{Texture="total",};
			Def.Sprite{
				Texture="lamp",
				InitCommand=function(s) s:visible(false):x(pn==PLAYER_1 and 256 or -256):rotationy(pn==PLAYER_1 and 0 or 180) end,
				BeginCommand=function(s)
					if ssStats then
						s:diffuse(CustomDifficultyToColor(pss:GetPlayedSteps()[1]:GetDifficulty())):visible(true)
					end
				end,
			};
			LoadActor("FullCombo")..{
				InitCommand=function(s)
					s:xy(pn==PLAYER_1 and 210 or -210,30):visible(false)
				end,
				OnCommand=function(self)
					self:zoom(0):sleep(0.45+(i-mStages)*-0.1):linear(0.4):zoom(0.3);
				end;
				BeginCommand=function(s)
					if pss:GetGrade() ~= "Grade_Tier08" then
						local fc_type = pss:FullComboType();
						if fc_type then
							s:diffuse(FullComboEffectColor[fc_type]):visible(true);
						end
					end;
				end,
			};
			Def.Sprite{
				Name="Grade",
				InitCommand=function(s)
					s:zoomy(0):diffuseshift():effectcolor1(Color.White):effectcolor2(Alpha(Color.White,0.8)):effectperiod(0.2)
				end,
				BeginCommand=function(s)
					local tier;
					if ThemePrefs.Get("ConvertScoresAndGrades") == true then
						tier = SN2Grading.ScoreToGrade(pss:GetScore())
					else
						tier = pss:GetGrade()
					end
					local Grade = pss:GetFailed() and 'Grade_Failed' or tier
					s:Load(THEME:GetPathB("ScreenEvaluation decorations/grade/GradeDisplayEval",ToEnumShortString(Grade)))
					s:x(pss:FullComboType() and (pn==PLAYER_1 and 154 or -154) or (pn==PLAYER_1 and 174 or -174))
					s:zoomx(0.25)
				end,
				OnCommand=function(s) s:sleep(0.45+(i-mStages)*-0.1):linear(0.4):zoomy(0.25) end;
			};
			Def.BitmapText{
				Name="Stage",
				Font="_avenirnext lt pro bold 36px",
				InitCommand=function(s)
					s:xy(pn==PLAYER_1 and 36 or -36,-20):maxwidth(190):zoomy(0.8):zoomx(0.92):halign(pn==PLAYER_1 and 1 or 0)
				end,
				BeginCommand=function(s)
					local pStage = ssStats:GetStage()
					if getenv("FixStage") == 1 then
						s:settextf("%s STAGE",THEME:GetString("StageFix",StageToLocalizedString(pStage)))
					else
						s:settext(StageToLocalizedString(pStage).." STAGE")
					end	
				end
			};
			Def.RollingNumbers{
				File=THEME:GetPathF("","_avenirnext lt pro bold 36px"),
				InitCommand=function(s) s:zoom(0.9):Load("RollingNumbersScore"):xy(pn==PLAYER_1 and 36 or -36,20)
					:strokecolor(Color.Black):halign(pn==PLAYER_1 and 1 or 0)
				end,
				BeginCommand=function(s)
					s:targetnumber(pss:GetScore())
				end,
			}
		};
	end
end


t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:xy(_screen.cx,_screen.cy-320) end,
	OnCommand=function(s) s:addy(-SCREEN_HEIGHT):sleep(0.2):decelerate(.2):addy(SCREEN_HEIGHT) end,
	OffCommand=function(s) s:decelerate(0.2):addy(-SCREEN_HEIGHT) end,
	Def.Sprite{
		OnCommand=function(s)
			local style = GAMESTATE:GetCurrentStyle():GetName()
			s:Load(THEME:GetPathB("","ScreenEvaluationSummary decorations/"..style)):y(-40)
		end;
	};
	Def.Sprite{
		OnCommand=function(s)
			local style = GAMESTATE:GetCurrentStyle():GetStyleType()
			if style == 'StyleType_OnePlayerOneSide' then
				s:Load(THEME:GetPathB("","ScreenEvaluationSummary decorations/1Pad"))
			else
				s:Load(THEME:GetPathB("","ScreenEvaluationSummary decorations/2Pad"))
			end;
			s:y(30)
		end;
	};
};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.ActorFrame{
    OnCommand=function(s)
      s:addx(pn=="PlayerNumber_P2" and 300 or -300):sleep(0.3):linear(0.2):addx(pn=="PlayerNumber_P2" and -300 or 300)
    end;
    OffCommand=function(s)
      s:linear(0.2):addx(pn=="PlayerNumber_P2" and 300 or -300)
    end;
    LoadActor("../ScreenEvaluation decorations/player")..{
      InitCommand=function(s)
        s:zoomx(pn=="PlayerNumber_P2" and -1 or 1):x(pn=="PlayerNumber_P2" and SCREEN_RIGHT or SCREEN_LEFT):halign(0):y(_screen.cy-300)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 25px";
      InitCommand=function(s)
        s:xy(pn=="PlayerNumber_P2" and SCREEN_RIGHT-110 or SCREEN_LEFT+120,_screen.cy-304)
        s:settext(PROFILEMAN:GetProfile(pn):GetDisplayName())
      end;
    }
  }
end


local screen = Var("LoadingScreen")
t[#t+1] = LoadActor(THEME:GetPathG(screen, "Header")) .. {
	Name = "Header",
}

t[#t+1] = StandardDecorationFromFileOptional("Help","Help");

return t;