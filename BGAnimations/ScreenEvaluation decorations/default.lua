local t = LoadFallbackB();
t[#t+1] = LoadActor("../everyone.dance.lua")

local screen = Var("LoadingScreen")
local ES = GAMESTATE:HasEarnedExtraStage()

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
    local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
    local Score = pss:GetScore()
    local seconds = pss:GetSurvivalSeconds()

    local function FindText(pss)
        return string.format("%02d STAGE",pss:GetSongsPassed())
    end

    t[#t+1] = LoadActor("grade",pn)
    if GAMESTATE:IsCourseMode() then
        t[#t+1] = Def.ActorFrame{
            InitCommand=function(s)
                s:xy(pn==PLAYER_1 and (IsUsingWideScreen() and _screen.cx-494 or _screen.cx-260) or (IsUsingWideScreen() and _screen.cx+494 or _screen.cx+260),_screen.cy-346)
                :draworder(-1)
            end,
            OnCommand=function(s) s:zoom(0):sleep(0.3):bounceend(0.2):zoom(0.8) end,
            OffCommand=function(s) s:linear(0.2):zoom(0) end,
            Def.Sprite{ Texture="info", InitCommand=function(s) s:diffuse(PlayerColor(pn)) end},
            Def.BitmapText{
                Font="_avenirnext lt pro bold 42px",
                OnCommand=function(s) s:y(46):settext(SecondsToMMSS(seconds)):strokecolor(Color.Black) end,
            };
            Def.BitmapText{
                Font="_avenirnext lt pro bold 36px";
                InitCommand=function(s) s:y(-40):zoom(1.8):diffuse(color("#FFFFFF")):diffusebottomedge(color("#7c7c7c")):strokecolor(color("0,0,0,1")) end,
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
        };
    else
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
    end
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
    };
end


local jk = LoadModule"Jacket.lua"
return Def.ActorFrame{
    OnCommand=function(s)
        if GAMESTATE:GetNumStagesLeft(GAMESTATE:GetMasterPlayerNumber()) > 1 then
            CustStage = CustStage + 1
        end
    end,
    Def.Sound{
        File=THEME:GetPathS("","_siren");
        OnCommand=function(s)
            if not ES then
                s:load(GetMenuMusicPath"results")
            end
            s:play()
        end,
    };
    Def.ActorFrame{
        Name="BannerArea",
        InitCommand=function(s) s:xy(_screen.cx,_screen.cy-184) end,
        OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(1) end,
        OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
        Def.Sprite{
            Texture="_jacket back",
        };
        Def.Sprite{
            InitCommand=function(self)
              local song;
              if GAMESTATE:IsCourseMode() then
                  song = GAMESTATE:GetCurrentCourse()
              else
                  song = GAMESTATE:GetCurrentSong();
              end
              if song then
                  if GAMESTATE:IsCourseMode() then
                      self:Load(song:GetBannerPath())
                  else
                      self:Load(jk.GetSongGraphicPath(song,"Jacket"))
                  end
              end;
              self:zoomto(378,378)
            end;
          };
    };
    Def.ActorFrame{
        Name="TitleBox",
        InitCommand=function(s) s:xy(_screen.cx,_screen.cy+66) end,
        OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(1) end,
	    OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
	    Def.Sprite{
            Texture="titlebox",
        };
	    LoadFont("_avenirnext lt pro bold 25px") .. {
	    	InitCommand = function(s) s:maxwidth(400):playcommand("Set") end,
	    	SetCommand = function(s)
                if GAMESTATE:IsCourseMode() then
                    s:y(0)
                    s:settext(GAMESTATE:GetCurrentCourse() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() or "")
                else
                    s:y(-8)
                    s:settext(GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSong():GetDisplayFullTitle() or ""):y(-8)
                end	
            end;
	    };
	    LoadFont("_avenirnext lt pro bold 25px") .. {
	    	InitCommand = function(s) s:y(20):maxwidth(400):playcommand("Set") end,
	    	SetCommand = function(self)
                if not GAMESTATE:IsCourseMode() then
                        local song = GAMESTATE:GetCurrentSong()
                  self:settext(song and song:GetDisplayArtist() or "")
                end
            end,
	    };
    };
    t;
    StandardDecorationFromFile("StageDisplay","StageDisplay")..{
        InitCommand=function(s)
            s:visible(not GAMESTATE:IsCourseMode())
        end
    };
    LoadActor("EXOverlay.lua")
}
