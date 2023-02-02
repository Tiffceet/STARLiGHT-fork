local player = ...
local t = Def.ActorFrame{
  BeginCommand=function(self)
    if player==PLAYER_1 then
      self:addx(-463)
    elseif player==PLAYER_2 then
      self:addx(463)
    end;
  end;
  StartSelectingStepsMessageCommand=function(self)
    if player==PLAYER_1 then
      self:decelerate(0.4):addx(463)
    elseif player==PLAYER_2 then
      self:decelerate(0.4):addx(-463)
    end;
  end;
  SongUnchosenMessageCommand=function(self)
    if player==PLAYER_1 then
      self:accelerate(0.4):addx(-463)
    elseif player==PLAYER_2 then
      self:accelerate(0.4):addx(463)
    end;
  end;
};

local function GetDifListX(self,offset)
        if player==PLAYER_1 then
                self:x(SCREEN_LEFT+232+offset)
        elseif player==PLAYER_2 then
                self:x(SCREEN_RIGHT-232-offset)
        end
end

local SpacingY = 150;

t[#t+1] = Def.Quad{
  InitCommand=function(self)
    self:y(SCREEN_CENTER_Y)
    GetDifListX(self, 0)
    self:setsize(463,SCREEN_HEIGHT);
    self:diffuse(color("0,0,0,0.75"))
  end;
  OffCommand=function(self)
    self:sleep(0.15):accelerate(0.25):addx(player==PLAYER_2 and 463 or -463)
  end;
}

local function DrawDifListItem(diff)
  local DifficultyListItem = Def.ActorFrame{
    InitCommand=cmd(y, _screen.cy-380 ),
    CurrentSongChangedMessageCommand=function(self) self:queuecommand("Set") end,
   ["CurrentSteps"..ToEnumShortString(player).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end,
   ["CurrentTrail"..ToEnumShortString(player).."ChangedMessageCommand"]=function(self) self:queuecommand("Set") end,
    CurrentCourseChangedMessageCommand=function(self) self:queuecommand("Set") end,
    OffCommand=function(self) self:sleep(0.15):linear(0.25):addx(player==PLAYER_2 and 463 or -463) end,
    Def.Sprite{
      InitCommand=function(self)self:zoomx(player=='PlayerNumber_P2' and -1 or 1)end;
      SetCommand=function(self)
        self:stoptweening()
        self:Load(THEME:GetPathB("","ScreenSelectMusic overlay/2014Deco/TwoPart/"..THEME:GetString("CustomDifficulty",ToEnumShortString(diff))..".png"))
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          GetDifListX(self, 0)
          self:y(Difficulty:Reverse()[diff] * SpacingY)
          if song:HasStepsTypeAndDifficulty( st, diff ) then
            local steps = song:GetOneSteps( st, diff )
            self:visible(true)
          else
            self:visible(false)
          end
        end;
      end;
    };
    LoadFont("_avenirnext lt pro bold 36px")..{
      Name="DiffLabel";
      InitCommand=function(self)
        self:halign(player=='PlayerNumber_P2' and 1 or 0):zoom(0.85):draworder(1000)
      end;
      SetCommand=function(self)
        self:stoptweening()
        self:diffuse(CustomDifficultyTwoPartToColor(diff))
        self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)))
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          GetDifListX(self, -220)
          self:y(Difficulty:Reverse()[diff] * SpacingY-40)
          if song:HasStepsTypeAndDifficulty( st, diff ) then
            local steps = song:GetOneSteps( st, diff )
            self:visible(true)
          else
            self:visible(false)
          end
        end;
      end;
    };
    LoadFont("_avenirnext lt pro bold 25px")..{
      Name="DiffDesc";
      InitCommand=function(self)
        self:halign(player=='PlayerNumber_P2' and 1 or 0):valign(0):zoom(0.7):draworder(1000)
      end;
      SetCommand=function(self)
        self:stoptweening()
        self:strokecolor(ColorDarkTone(CustomDifficultyTwoPartToColor(diff)))
        self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff).."Desc"))
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          GetDifListX(self, -220)
          self:y(Difficulty:Reverse()[diff] * SpacingY-8)
          if song:HasStepsTypeAndDifficulty( st, diff ) then
            local steps = song:GetOneSteps( st, diff )
            self:visible(true)
          else
            self:visible(false)
          end
        end;
      end;
    };
    LoadFont("_avenirnext lt pro bold 36px")..{
      Name="Meter";
      InitCommand=cmd(draworder,99);
      SetCommand=function(self)
        self:stoptweening()
        self:diffuse(CustomDifficultyTwoPartToColor(diff))
        self:settext("")
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          GetDifListX(self, 174)
          self:y( Difficulty:Reverse()[diff] * SpacingY+16)
          if song:HasStepsTypeAndDifficulty( st, diff ) then
            local steps = song:GetOneSteps( st, diff )
            self:settext( steps:GetMeter() )
          end
        end;
      end;
    };
    LoadActor("HL.png")..{
      InitCommand=function(self)self:blend(Blend.Add):zoomx(player=='PlayerNumber_P2' and -1 or 1)GetDifListX(self, 0)end;
      AnimCommand=cmd(finishtweening;diffusealpha,0;linear,0.05;diffusealpha,0.5;linear,0.5;diffusealpha,0;sleep,0.1;queuecommand,"Anim");
      ["CurrentSteps" .. ToEnumShortString(player) .. "ChangedMessageCommand"]=function(self)
        self:stoptweening()
        self:linear(0.2):diffusealpha(1)
        local song=GAMESTATE:GetCurrentSong()
        if song then
          local steps = GAMESTATE:GetCurrentSteps(player)
          if steps then
            local diff = steps:GetDifficulty();
            self:y(Difficulty:Reverse()[diff] * SpacingY)
            self:queuecommand("Anim")
          end;
        end;
      end;
      CurrentSongChangedMessageCommand=cmd(finishtweening;queuecommand,"Anim");
    };
    LoadActor("ConSel")..{
      InitCommand=function(self)
        GetDifListX(self, 0)
        self:y(-100):zoom(0.75)
      end;
    }
  };
  return DifficultyListItem
end;

local difficulties = {"Beginner", "Easy", "Medium", "Hard", "Challenge", "Edit"}

for difficulty in ivalues(difficulties) do
        t[#t+1] = DrawDifListItem("Difficulty_" .. difficulty);
end

return t;
