local pn = ...
local t = Def.ActorFrame{};

local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

local Combo = 	pss:MaxCombo();

local Marvelous = pss:GetTapNoteScores("TapNoteScore_W1");
local Perfect = pss:GetTapNoteScores("TapNoteScore_W2");
local Great = pss:GetTapNoteScores("TapNoteScore_W3");
local W4 = pss:GetTapNoteScores("TapNoteScore_W4");
local W5 = pss:GetTapNoteScores("TapNoteScore_W5");
local Good = W4 + W5;
local Ok = pss:GetHoldNoteScores("HoldNoteScore_Held");
local RealMiss = pss:GetTapNoteScores("TapNoteScore_Miss");
local LetGo = pss:GetHoldNoteScores("HoldNoteScore_LetGo");
local Miss = RealMiss + LetGo;

local Score = pss:GetScore()

local EXScore = SN2Scoring.ComputeEXScoreFromData(SN2Scoring.GetCurrentScoreData(pss));

t[#t+1] = Def.ActorFrame{
  InitCommand=function(s)
    s:x(IsUsingWideScreen() and 0 or pn==PLAYER_1 and -100 or 80)
  end,
  Def.RollingNumbers{
    Font="_avenirnext lt pro bold 46px";
    OnCommand=function(self)
  		self:x(8):y(-10):strokecolor(Color.Black)
      self:Load("RollingNumbersEvaluation");
      self:targetnumber(Score);
      self:zoom(0):sleep(0.3):bounceend(0.2):zoom(2)
    end;
    OffCommand=function(s) s:linear(0.2):zoom(0) end,
  };
  Def.BitmapText{
    Font="_avenirnext lt pro bold 25px";
    OnCommand=function(self)
  		self:x(240):y(40):strokecolor(Color.Black):halign(1)
      self:zoom(0):sleep(0.3):bounceend(0.2):zoom(1)
      local steps = GAMESTATE:GetCurrentSteps(pn)
      local song=GAMESTATE:GetCurrentSong()
      if song then
        local st=GAMESTATE:GetCurrentStyle():GetStepsType();

        if PROFILEMAN:IsPersistentProfile(pn) then
          profile = PROFILEMAN:GetProfile(pn)
        else
          profile = PROFILEMAN:GetMachineProfile()
        end;

        scorelist = profile:GetHighScoreList(song,steps)
        local scores = scorelist:GetHighScores()
        local HS = 0

        if scores[2] then
            HS = scores[2]:GetScore()
        end;
        local adjHS = Score-HS
        if adjHS > 0 then
          self:settextf("+".."%7d",adjHS)
          self:diffuse(color("0.3,0.7,1,1"))
        else
          self:settextf("%7d",adjHS)
          self:diffuse(color("1,0.3,0.5,1"))
        end
      end

    end;
    OffCommand=function(s) s:linear(0.2):zoom(0) end,
  };
};

if pss:GetMachineHighScoreIndex() == 0 or pss:GetPersonalHighScoreIndex() == 0 then
  t[#t+1] = LoadActor("Record.png")..{
    OnCommand=function(self)
      self:x(IsUsingWideScreen() and 0 or pn==PLAYER_1 and -100 or 80)
      self:y(-68)
      self:zoom(0):sleep(0.3):bounceend(0.2):zoom(1)
      self:glowblink():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,0.2")):effectperiod(0.2)
    end;
    OffCommand=function(s) s:linear(0.2):zoom(0) end,
  };
end;

t[#t+1] = Def.ActorFrame{
  InitCommand=function(self)
		self:y(240)
	end,
  OnCommand=function(s) s:addy(800):sleep(0.3):linear(0.2):addy(-800) end,
  OffCommand=function(s) s:linear(0.2):addy(800) end,
  LoadActor("box");
  Def.ActorFrame{
    Name="Combo Line";
    InitCommand=function(s) s:xy(-104,-105) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(60)
        self:settext("MAX COMBO"):halign(1):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(155)
        self:settextf(Combo):halign(1):strokecolor(Color.Black)
      end;
    };
  };
  Def.ActorFrame{
    Name="Marvelous Line";
    InitCommand=function(s) s:xy(-104,-62) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(60)
        self:settext("MARVELOUS"):halign(1):diffuse(color("#fff4ba")):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(155)
        self:settextf(Marvelous):halign(1):strokecolor(Color.Black)
      end;
    };
  };
  Def.ActorFrame{
    Name="Perfect Line";
    InitCommand=function(s) s:xy(-104,-22) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(60)
        self:settext("PERFECT"):halign(1):diffuse(color("#ffe345")):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(155)
        self:settextf(Perfect):halign(1):strokecolor(Color.Black)
      end;
    };
  };
  Def.ActorFrame{
    Name="Great Line";
    InitCommand=function(s) s:xy(-104,20) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(60)
        self:settext("GREAT"):halign(1):diffuse(color("#3dea2f")):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(155)
        self:settextf(Great):halign(1):strokecolor(Color.Black)
      end;
    };
  };
  Def.ActorFrame{
    Name="Good Line";
    InitCommand=function(s) s:xy(-104,60) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(60)
        self:settext("GOOD"):halign(1):diffuse(color("#5ad3ff")):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(155)
        self:settextf(Good):halign(1):strokecolor(Color.Black)
      end;
    };
  };
  Def.ActorFrame{
    Name="Hold Line";
    InitCommand=function(s) s:xy(-104,100) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(60)
        self:settext("O.K."):halign(1):diffuse(color("#ff9c00")):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(155)
        self:settextf(Ok):halign(1):strokecolor(Color.Black)
      end;
    };
  };
  Def.ActorFrame{
    Name="Hold Line";
    InitCommand=function(s) s:xy(-104,140) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(60)
        self:settext("MISS"):halign(1):diffuse(color("#ff2860")):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:x(155)
        self:settextf(Miss):halign(1):strokecolor(Color.Black)
      end;
    };
  };
  Def.ActorFrame{
    Name="EXScore Line";
    InitCommand=function(s) s:xy(280,-110) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:settext("EX SCORE"):halign(1):zoom(0.75):diffuse(color("#FFFFFF")):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:y(30)
        self:settextf(EXScore):halign(1):strokecolor(Color.Black)
      end;
    };
  };
  Def.ActorFrame{
    Name="Fast Line";
    InitCommand=function(s) s:xy(280,0) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:settext("FAST"):halign(1):zoom(0.75):diffuse(color("#FFFFFF")):strokecolor(color("#0060ff"))
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:y(30)
        local FastNum = getenv("numFast"..ToEnumShortString(pn))
        self:settextf(FastNum):halign(1):strokecolor(Color.Black)
      end;
    };
  };
  Def.ActorFrame{
    Name="Slow Line";
    InitCommand=function(s) s:xy(280,110) end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:settext("SLOW"):halign(1):zoom(0.75):diffuse(color("#FFFFFF")):strokecolor(color("#cc00ff"))
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      OnCommand=function(self)
        self:y(30)
        local FastNum = getenv("numSlow"..ToEnumShortString(pn))
        self:settextf(FastNum):halign(1):strokecolor(Color.Black)
      end;
    };
  };
};

return t;
