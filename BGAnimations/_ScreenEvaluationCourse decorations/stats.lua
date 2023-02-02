local t = Def.ActorFrame{};

local xPosPlayer = {
    P1 = SCREEN_CENTER_X-495,
    P2 = SCREEN_CENTER_X+495
}

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do

local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)

local Combo = 	pss:MaxCombo();

local Marvelous = pss:GetTapNoteScores("TapNoteScore_W1");
local Perfect = pss:GetTapNoteScores("TapNoteScore_W2");
local Great = pss:GetTapNoteScores("TapNoteScore_W3");
local Good = pss:GetTapNoteScores("TapNoteScore_W4");
local Ok = pss:GetHoldNoteScores("HoldNoteScore_Held");
local Miss = pss:GetTapNoteScores("TapNoteScore_Miss") + STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetTapNoteScores("TapNoteScore_W5");

local Score = pss:GetScore();
local seconds = pss:GetSurvivalSeconds()

local function FindText(pss)
  return string.format("%02d STAGE",pss:GetSongsPassed())
end

t[#t+1] = Def.ActorFrame{
  InitCommand=function(self)
    local short = ToEnumShortString(pn)
    self:x(xPosPlayer[short]):y(SCREEN_CENTER_Y-346)
  end;
  OnCommand=function(s) s:zoom(0):sleep(0.3):bounceend(0.2):zoom(1) end,
  OffCommand=function(s) s:linear(0.2):zoom(0) end,
  LoadActor("info")..{
    InitCommand=function(self)
      self:diffuse(PlayerColor(pn))
    end;
  };
  Def.BitmapText{
    Font="_avenirnext lt pro bold 46px";
    InitCommand=function(s) s:y(46) end,
    OnCommand=function(self)
      self:strokecolor(Color.Black)
      self:settext(SecondsToMMSS(seconds));
    end;
  };
  Def.BitmapText{
    Font="_handel gothic itc std Bold 32px";
    InitCommand=function(s) s:y(-40):zoom(2):diffuse(color("#FFFFFF")):diffusebottomedge(color("#7c7c7c")):strokecolor(color("0,0,0,1")) end,
    OnCommand=function(self)
      self:settext(FindText(pss))
    end;
  };
  Def.Quad{
    InitCommand=function(s) s:setsize(300,28):y(4) end,
  };
  Def.Sprite{
    Texture="Bars 1x2.png";
    InitCommand=function(s) s:y(4):pause():setstate(0) end,
    OnCommand=function(self)
      self:setstate(pn=="PlayerNumber_P2" and 1 or 0):cropright(1):sleep(0.7):decelerate(0.7):cropright(math.max(0,1-pss:GetPercentDancePoints()))
    end;
  };
}

t[#t+1] = Def.ActorFrame{
  Def.RollingNumbers{
    Font="_avenirnext lt pro bold 46px";
    OnCommand=function(self)
      local short = ToEnumShortString(pn)
  		self:x(xPosPlayer[short]+8):y(SCREEN_CENTER_Y-10):strokecolor(Color.Black)
      self:Load("RollingNumbersEvaluation");
      self:targetnumber(Score);
      self:zoom(0):sleep(0.3):bounceend(0.2):zoom(2)
    end;
    OffCommand=function(s) s:linear(0.2):zoom(0) end,
  };
};

if pss:GetMachineHighScoreIndex() == 0 or pss:GetPersonalHighScoreIndex() == 0 then
  t[#t+1] = LoadActor(THEME:GetPathB("","ScreenEvaluationNormal overlay/Record.png"))..{
    OnCommand=function(self)
      local short = ToEnumShortString(pn)
      self:x(xPosPlayer[short]):y(SCREEN_CENTER_Y-68)
      self:zoom(0):sleep(0.3):bounceend(0.2):zoom(1)
      self:glowblink():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,0.2")):effectperiod(0.2)
    end;
    OffCommand=function(s) s:linear(0.2):zoom(0) end,
  };
end;

t[#t+1] = Def.ActorFrame{
  InitCommand=function(self)
		local short = ToEnumShortString(pn)
		self:x(xPosPlayer[short]):y(SCREEN_CENTER_Y+240)
	end,
  OnCommand=function(s) s:addy(800):sleep(0.3):linear(0.2):addy(-800) end,
  OffCommand=function(s) s:linear(0.2):addy(800) end,
  LoadActor(THEME:GetPathB("","ScreenEvaluationNormal overlay/box.png"));
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
};
end;

return t;
