local player = ...

local function GetDifListX(self,offset)
        if player==PLAYER_1 then
                self:x(SCREEN_LEFT+220+offset)
        elseif player==PLAYER_2 then
                self:x(SCREEN_RIGHT-220-offset)
        end
end

local yspacing = 32;

local t = Def.ActorFrame{
  InitCommand=function(s)
    GetDifListX(s, 0)
    s:y(_screen.cy-362)
  end,
  OnCommand=function(s) s:addx(player==PLAYER_2 and 500 or -500):sleep(0.2):decelerate(0.2):addx(player==PLAYER_2 and -500 or 500) end,
    OffCommand=function(self)
       self:sleep(0.15):linear(0.25):addx(player=="PlayerNumber_P2" and 500 or -500)
    end;
};

t[#t+1] = Def.ActorFrame{
  LoadActor("cursorglow")..{
    InitCommand=function(self)
      self:diffusealpha(0)
    end;
    ["CurrentSteps" .. ToEnumShortString(player) .. "ChangedMessageCommand"]=function(self)
      self:diffusealpha(0)
      self:finishtweening()
      self:diffusealpha(1)
      local song=GAMESTATE:GetCurrentSong()
      if song then
        local steps = GAMESTATE:GetCurrentSteps(player)
        if steps then
          local diff = steps:GetDifficulty();
          local st=GAMESTATE:GetCurrentStyle():GetStepsType();
          self:y(Difficulty:Reverse()[diff] * yspacing)
        end;
      end;
    end;
  };
}

local function DrawDifListItem(diff)
  local DifficultyListItem = Def.ActorFrame{
    InitCommand=function(self)
      self:y(Difficulty:Reverse()[diff] * yspacing)
    end;
    CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentCourseChangedMessageCommand=function(s) s:queuecommand("Set") end,
    SetCommand=function(self)
      local st=GAMESTATE:GetCurrentStyle():GetStepsType()
      local song=GAMESTATE:GetCurrentSong()
      if song then
        if song:HasStepsTypeAndDifficulty( st, diff ) then
          local steps = song:GetOneSteps( st, diff )
          self:diffusealpha(1)
        else
          self:diffusealpha(0.5)
        end
      else
        self:diffusealpha(0.5)
      end;
    end;
    Def.Quad{
      Name="Background";
      InitCommand=function(s) s:setsize(336,28):diffusealpha(0.8):draworder(0) end,
    };
    LoadFont("_avenirnext lt pro bold 20px")..{
      Name="DiffLabel";
      InitCommand=function(self)
        self:halign(player=='PlayerNumber_P2' and 1 or 0):draworder(99):diffuse(CustomDifficultyToColor(diff)):strokecolor(Color.Black)
        self:x(player=="PlayerNumber_P2" and 164 or -164)
        self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)))
      end;
    };
    LoadFont("_avenirnext lt pro bold 25px")..{
      Name="Meter";
      InitCommand=function(s) s:draworder(99):strokecolor(Color.Black):x(player==PLAYER_2 and 20 or -20) end,
      SetCommand=function(self)
        self:settext("")
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          if song:HasStepsTypeAndDifficulty( st, diff ) then
            local steps = song:GetOneSteps( st, diff )
            self:settext( steps:GetMeter() )
          end
        end;
      end;
    };

    LoadFont("_avenirnext lt pro bold 20px")..{
      Name="Score";
      InitCommand=function(s) s:draworder(5):x(player==PLAYER_2 and -69 or 69) end,
      SetCommand=function(self)
        self:settext("")

        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          if song:HasStepsTypeAndDifficulty(st,diff) then
            local steps = song:GetOneSteps(st,diff)

            if PROFILEMAN:IsPersistentProfile(player) then
              profile = PROFILEMAN:GetProfile(player)
            else
              profile = PROFILEMAN:GetMachineProfile()
            end;

            scorelist = profile:GetHighScoreList(song,steps)
            local scores = scorelist:GetHighScores()
            local topscore = 0

            if scores[1] then
              if scores[1] then
                if ThemePrefs.Get("ConvertScoresAndGrades") == true then
                  topscore = 10*math.round(SN2Scoring.GetSN2ScoreFromHighScore(steps, scores[1])/10)
                else
                  topscore = scores[1]:GetScore()
                end
              end
            end;

            self:strokecolor(Color.Black)
            self:diffusealpha(1)

            if topscore ~= 0 then
                self:settext(commify(topscore))
            end;
          end;
        end;
      end;
    };
    Def.ActorFrame{
      InitCommand=function(s) s:x(player==PLAYER_2 and -148 or 140) end,
      LoadActor(THEME:GetPathG("Player","Badge FullCombo"))..{
        InitCommand=function(s) s:shadowlength(1):zoom(0):draworder(5):xy(18,4) end,
        OffCommand=function(s) s:decelerate(0.05):diffusealpha(0) end,
        SetCommand=function(self)
          local st=GAMESTATE:GetCurrentStyle():GetStepsType();
          local song=GAMESTATE:GetCurrentSong();
          local course = GAMESTATE:GetCurrentCourse();
          if song then
            if song:HasStepsTypeAndDifficulty(st,diff) then
              local steps = song:GetOneSteps( st, diff );
              if PROFILEMAN:IsPersistentProfile(player) then
                profile = PROFILEMAN:GetProfile(player);
              else
                profile = PROFILEMAN:GetMachineProfile();
              end;
              scorelist = profile:GetHighScoreList(song,steps);
              assert(scorelist);
              local scores = scorelist:GetHighScores();
              assert(scores);
              local topscore;
              if scores[1] then
                topscore = scores[1];
                assert(topscore);
                local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")+topscore:GetHoldNoteScore("HoldNoteScore_LetGo")+topscore:GetHoldNoteScore("HoldNoteScore_MissedHold")
                local boos = topscore:GetTapNoteScore("TapNoteScore_W5")
                local goods = topscore:GetTapNoteScore("TapNoteScore_W4")
                local greats = topscore:GetTapNoteScore("TapNoteScore_W3")
                local perfects = topscore:GetTapNoteScore("TapNoteScore_W2")
                local marvelous = topscore:GetTapNoteScore("TapNoteScore_W1")
                if (misses+boos) == 0 and scores[1]:GetScore() > 0 and (marvelous+perfects)>0 then
                  if (greats+perfects) == 0 then
                    self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
                    self:glowblink();
                    self:effectperiod(0.20);
                    self:zoom(0.5);
                  elseif greats == 0 and goods == 0 then
                    self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
                    self:glowshift();
                    self:zoom(0.5);
                  elseif (misses+boos+goods) == 0 then
                    self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
                    self:stopeffect();
                    self:zoom(0.5);
                  elseif (misses+boos) == 0 then
                    self:diffuse(GameColor.Judgment["JudgmentLine_W4"]);
                    self:stopeffect();
                    self:zoom(0.5);
                  end;
                  self:diffusealpha(0.8);
                else
                  self:diffusealpha(0);
                end;
              else
                self:diffusealpha(0);
              end;
            else
              self:diffusealpha(0);
            end;
          else
            self:diffusealpha(0);
          end;
        end
      };
      Def.Quad{
        Name="Grade";
      InitCommand=function(s) s:draworder(5) end,
      SetCommand=function(self)
        local st=GAMESTATE:GetCurrentStyle():GetStepsType();
        local song=GAMESTATE:GetCurrentSong();
        if song then
          if song:HasStepsTypeAndDifficulty(st,diff) then
            local steps = song:GetOneSteps(st, diff)
            if PROFILEMAN:IsPersistentProfile(player) then
              profile = PROFILEMAN:GetProfile(player)
            else
              profile = PROFILEMAN:GetMachineProfile()
            end
  
            scorelist = profile:GetHighScoreList(song,steps)
            local scores = scorelist:GetHighScores()
  
            local topscore=0
            if scores[1] then
              if ThemePrefs.Get("ConvertScoresAndGrades") == true then
                topscore = 10*math.round(SN2Scoring.GetSN2ScoreFromHighScore(steps, scores[1])/10)
              else
                topscore = scores[1]:GetScore()
              end
            end
  
            local topgrade
            if scores[1] then
              topgrade = scores[1]:GetGrade();
              local tier
              if ThemePrefs.Get("ConvertScoresAndGrades") == true then
                tier = SN2Grading.ScoreToGrade(topscore, diff)
              else
                tier = topgrade
              end
              assert(topgrade);
              if scores[1]:GetScore()>1  then
                if topgrade == 'Grade_Failed' then
                  self:LoadBackground(THEME:GetPathG("","myMusicWheel/GradeDisplayEval Failed"));
                else
                  self:LoadBackground(THEME:GetPathG("myMusicWheel/GradeDisplayEval",ToEnumShortString(tier)));
                end;
                self:diffusealpha(1);
              else
                self:diffusealpha(0);
              end;
            else
              self:diffusealpha(0);
            end;
          else
            self:diffusealpha(0);
          end;
        else
          self:diffusealpha(0);
        end;
      end;
      };
    };
  };
  return DifficultyListItem
end;


t[#t+1] = LoadActor("DiffFrame.png")..{
  OnCommand=function(self)
    self:xy(player=="PlayerNumber_P2" and 8 or -8,80):zoomx(player=='PlayerNumber_P2' and -1 or 1)
  end,
  OffCommand=function(self)
    self:sleep(0.15):linear(0.25):addx(player=="PlayerNumber_P2" and 500 or -500)
  end;
};

local difficulties = {"Beginner", "Easy", "Medium", "Hard", "Challenge", "Edit"}

for difficulty in ivalues(difficulties) do
  t[#t+1] = DrawDifListItem("Difficulty_" .. difficulty);
end

return t;
