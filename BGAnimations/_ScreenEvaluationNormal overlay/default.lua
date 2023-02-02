local t = Def.ActorFrame{};

local screen = Var("LoadingScreen")

t[#t+1] = Def.Actor{
  OnCommand=function(s)
    if GAMESTATE:GetNumStagesLeft(GAMESTATE:GetMasterPlayerNumber()) > 1 then
      CustStage = CustStage + 1
    end
  end
};

t[#t+1] = StandardDecorationFromFile("StageDisplay","StageDisplay");

if THEME:GetMetric(screen, "ShowHeader") then
	t[#t+1] = LoadActor(THEME:GetPathG(screen, "Header")) .. {
		Name = "Header",
	}
end

t[#t+1] = LoadActor(THEME:GetPathS("","_siren"))..{
	OnCommand=function(self)
		if GAMESTATE:HasEarnedExtraStage() then
			self:play()
		end;
	end;
};

if GAMESTATE:HasEarnedExtraStage() == false then
t[#t+1] = LoadActor(GetMenuMusicPath "results")..{
	OnCommand=function(self)
		self:play()
	end;
}
end;

--BannerArea
t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-184):diffusealpha(1) end,
  OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(1) end,
	OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
  LoadActor("_jacket back");
  Def.Sprite{
    OnCommand=function(s) s:queuecommand("Set") end,
    SetCommand=function(self)
      local song = GAMESTATE:GetCurrentSong();
      if song then
		self:_LoadSCJacket(song);
      end;
      self:zoomtowidth(378);
      self:zoomtoheight(378);
    end;
  };
};

t[#t+1] = Def.ActorFrame{
	OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(1) end,
	OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
	InitCommand=function(s) s:xy(_screen.cx,_screen.cy+66) end,
	LoadActor("titlebox");
	LoadFont("_avenirnext lt pro bold 25px") .. {
		InitCommand = function(s) s:y(-8):maxwidth(400):playcommand("Set") end,
		SetCommand = function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:settext(song and song:GetDisplayFullTitle() or "")
    end;
	};
	LoadFont("_avenirnext lt pro bold 25px") .. {
		InitCommand = function(s) s:y(20):maxwidth(400):playcommand("Set") end,
		SetCommand = function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:settext(song and song:GetDisplayArtist() or "")
		end,
	};
};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("grade", pn)
end



for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
  t[#t+1] = Def.ActorFrame{
    InitCommand=function(s) s:y(_screen.cy-346):draworder(-1)
      if IsUsingWideScreen() then
        s:x(pn==PLAYER_1 and _screen.cx-494 or _screen.cx+494)
      else
        s:x(pn==PLAYER_1 and _screen.cx-320 or _screen.cx+320)
      end
    end,
    OnCommand=function(s) s:zoom(0):sleep(0.3):bounceend(0.2):zoom(1) end,
    OffCommand=function(s) s:linear(0.2):zoom(0) end,
    Def.BitmapText{
      Font="_handel gothic itc std Bold 32px";
      OnCommand=function(self)
        self:y(-40)
        self:uppercase(true):settext(GAMESTATE:GetCurrentStyle():GetName()):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_handel gothic itc std Bold 32px";
      OnCommand=function(self)
        local diff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
        self:uppercase(true):settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)))
        :diffuse(CustomDifficultyToColor(diff)):strokecolor(Color.Black)
      end;
    };
    Def.BitmapText{
      Font="_handel gothic itc std Bold 32px";
      OnCommand=function(self)
        self:y(36)
        local meter = GAMESTATE:GetCurrentSteps(pn):GetMeter();
        self:settext(meter):strokecolor(Color.Black)
      end;
    };
  };
end;

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.ActorFrame{
    OnCommand=function(self)
      self:addx(pn=="PlayerNumber_P2" and 300 or -300)
      self:sleep(0.3):linear(0.2):addx(pn=="PlayerNumber_P2" and -300 or 300)
    end;
    OffCommand=function(self)
      self:linear(0.2):addx(pn=="PlayerNumber_P2" and 300 or -300)
    end;
    LoadActor("player")..{
      InitCommand=function(self)
        self:zoomx(pn=="PlayerNumber_P2" and -1 or 1)
        self:x(pn=="PlayerNumber_P2" and SCREEN_RIGHT or SCREEN_LEFT)
        self:halign(0):y(_screen.cy-310)
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 25px";
      InitCommand=function(self)
        self:x(pn=="PlayerNumber_P2" and SCREEN_RIGHT-110 or SCREEN_LEFT+120)
        self:y(_screen.cy-314)
        if PROFILEMAN:IsPersistentProfile(pn) then
          self:settext(PROFILEMAN:GetProfile(pn):GetDisplayName())
        else
          self:settext(pn=="PlayerNumber_P2" and "PLAYER 2" or "PLAYER 1")
        end
      end;
    }
  }
  t[#t+1] = LoadActor("stats.lua",pn)..{
    InitCommand=function(s)
      s:y(_screen.cy)
      if IsUsingWideScreen() then
        s:x(pn==PLAYER_1 and _screen.cx-500 or _screen.cx+500)
      else
        s:x(pn==PLAYER_1 and _screen.cx-380 or _screen.cx+380)
      end
    end,
  }
end

t[#t+1] = Def.ActorFrame{
  LoadActor("EXOverlay.lua"),
};

return t;
