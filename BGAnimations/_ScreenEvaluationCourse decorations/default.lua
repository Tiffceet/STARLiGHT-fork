local t = Def.ActorFrame{};
local course = GAMESTATE:GetCurrentCourse()

local screen = Var("LoadingScreen")

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
  InitCommand=function(s) s:xy(_screen.cx+8,_screen.cy-184):diffusealpha(1):draworder(1) end,
  OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(1) end,
	OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
  LoadActor(THEME:GetPathB("","ScreenEvaluationNormal overlay/_jacket back"));
  Def.Banner{
    OnCommand=function(s) s:queuecommand("Set") end,
    SetCommand=function(self)
      if course:GetBackgroundPath() then
				self:Load(course:GetBackgroundPath())
			else
				self:Load(THEME:GetPathG("","Common fallback jacket"));
      end;
      self:zoomtowidth(390);
      self:zoomtoheight(390);
    end;
  };
};

t[#t+1] = Def.ActorFrame{
	OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(1) end,
	OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
	InitCommand=function(s) s:xy(_screen.cx+8,_screen.cy+66) end,
	LoadActor("../ScreenSelectMusic overlay/2014Deco/titlebox");
	LoadFont("_avenirnext lt pro bold 25px") .. {
		InitCommand = function(s) s:maxwidth(480):playcommand("Set") end,
		SetCommand = function(self)
			self:settext(course:GetDisplayFullTitle())
    end;
	};
};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("grade", pn)
end

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.ActorFrame{
    OnCommand=function(self)
      self:addx(pn=="PlayerNumber_P2" and 300 or -300)
      self:sleep(0.3):linear(0.2):addx(pn=="PlayerNumber_P2" and -300 or 300)
    end;
    OffCommand=function(self)
      self:linear(0.2):addx(pn=="PlayerNumber_P2" and 300 or -300)
    end;
    LoadActor(THEME:GetPathB("","ScreenEvaluationNormal overlay/player"))..{
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
end

t[#t+1] = Def.ActorFrame{
  LoadActor("stats.lua");
};

return t;
