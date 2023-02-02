local t = Def.ActorFrame{};

t[#t+1] = StandardDecorationFromFileOptional("StageFrame","StageFrame");
t[#t+1] = StandardDecorationFromFile("LifeFrame","LifeFrame")
t[#t+1] = StandardDecorationFromFile("ScoreFrame","ScoreFrame")

t[#t+1] = StandardDecorationFromFile("StageDisplay","StageDisplay")
t[#t+1] = StatsEngine()

local LoadingScreen = Var "LoadingScreen"

t[#t+1] = Def.Actor{
    AfterStatsEngineMessageCommand = function(_,params)
      local pn = params.Player
      --So there's settings in StepMania for enabling/disabling fail for Beginner/Easy difficulties.
      --They don't do anything normally.
      --Yeah I don't know why we need to do this but we do and it's absolutely fucking stupid.
      if PREFSMAN:GetPreference("FailOffForFirstStageEasy") == false and GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == 'Difficulty_Easy' then
        if GAMESTATE:GetCurrentStage() == 0 or CustStageCheck() == 1 or GAMESTATE:GetCurrentStage() == 13 then
          GAMESTATE:SetFailTypeExplicitlySet()
        end
      end
      if PREFSMAN:GetPreference("FailOffInBeginner") == false and GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == 'Difficulty_Beginner' then
        GAMESTATE:SetFailTypeExplicitlySet()
      end
      local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

      local aScore = params.Data.AScoring
      pss:SetScore(aScore.Score)
      pss:SetCurMaxScore(aScore.MaxScore)

      
      local fast, slow = 0, 0

      local fastSlow = params.Data.FastSlowRecord
      if fastSlow then
        fast = fastSlow.Fast
        slow = fastSlow.Slow
      end

      local short = ToEnumShortString(pn)
      setenv("numFast"..short, fast)
      setenv("numSlow"..short, slow)
    end,
}

--options--
t[#t+1] = LoadActor( THEME:GetPathB("","optionicon_P1") ) .. {
		InitCommand=function(s) s:player(PLAYER_1):zoomx(1.8):zoomy(1.8):x(IsUsingWideScreen() and SCREEN_CENTER_X-744 or _screen.cx-420):draworder(1) end,
		OnCommand=function(self)
			if GAMESTATE:PlayerIsUsingModifier(PLAYER_1,'reverse') then
				self:y(SCREEN_TOP+138);
			else
				self:y(SCREEN_BOTTOM-130);
			end;
		end;
	};
t[#t+1] = LoadActor( THEME:GetPathB("","optionicon_P2") ) .. {
	InitCommand=function(s) s:player(PLAYER_2):zoomx(1.8):zoomy(1.8):x(IsUsingWideScreen() and SCREEN_CENTER_X+744 or _screen.cx+420):draworder(1) end,
	OnCommand=function(self)
		if GAMESTATE:PlayerIsUsingModifier(PLAYER_2,'reverse') then
			self:y(SCREEN_TOP+138);
		else
			self:y(SCREEN_BOTTOM-130);
		end;
	end;
};

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
  t[#t+1] = Def.ActorFrame{
    InitCommand=function(self) 
      self:draworder(3)
      if LoadingScreen == "ScreenDemonstration" then
        self:x(pn=="PlayerNumber_P2" and _screen.cx+602 or _screen.cx-602)
        self:y(SCREEN_TOP+44)
      else
        self:x(pn=="PlayerNumber_P2" and ScreenGameplay_P2X()-7 or ScreenGameplay_P1X()+7)
        self:y(SCREEN_TOP+62)
      end
    end,
    Def.Sprite{
      Texture = "normal";
      BeginCommand=function(s)
        if LoadScreen == "ScreenDemonstration" then
          s:setsize(680,51) 
        else
          s:setsize(642,45)
        end
      end,
      OnCommand=function(self)
        self:MaskDest():ztestmode("ZTestMode_WriteOnFail"):customtexturerect(0,0,1,1)
        :texcoordvelocity(pn=="PlayerNumber_P2" and 1 or -1,0)
      end;
      HealthStateChangedMessageCommand=function(self, param)
    		if param.PlayerNumber == pn then
    			if param.HealthState == "HealthState_Danger" then
    				self:Load(THEME:GetPathB("","ScreenGameplay decorations/danger (stretch).png"))
    			elseif param.HealthState == "HealthState_Hot" then
            self:Load(THEME:GetPathB("","ScreenGameplay decorations/hot (stretch).png"))
          else
            self:Load(THEME:GetPathB("","ScreenGameplay decorations/normal (stretch).png"))
          end;
          self:setsize(642,45)
    		end;
    	end;
    };
  };
end;


  t[#t+1] = StandardDecorationFromFileOptional("Help","Help");

return t
