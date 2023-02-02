local player = ...
local t = Def.ActorFrame{
  OnCommand=function(self)
    self:diffusealpha(0)
  end;
  StartSelectingStepsMessageCommand=function(self)
    self:linear(0.25)
    self:diffusealpha(1)
  end;
  SongUnchosenMessageCommand=function(self)
    self:linear(0.25)
    self:diffusealpha(0)
  end;
  OffCommand=cmd(queuecommand,"SongUnchosenMessageCommand");
};

local function GetDifListX(self,offset)
        if player==PLAYER_1 then
                self:x(_screen.cx-360+offset)
        elseif player==PLAYER_2 then
                self:x(_screen.cx+140-offset)
        end
end

local SpacingY = 60;

local function DrawDifListItem(diff)
  local DifficultyListItem = Def.ActorFrame{
    InitCommand=cmd(y, _screen.cy+50;zoom,1.1 ),
    CurrentSongChangedMessageCommand=cmd(playcommand,"Set"),
    CurrentStepsP1ChangedMessageCommand=function(self) if player == PLAYER_1 then self:playcommand("Set") end end,
    CurrentStepsP2ChangedMessageCommand=function(self) if player == PLAYER_2 then self:playcommand("Set") end end,
    CurrentTrailP1ChangedMessageCommand=function(self) if player == PLAYER_1 then self:playcommand("Set") end end,
    CurrentTrailP2ChangedMessageCommand=function(self) if player == PLAYER_2 then self:playcommand("Set") end end,
    CurrentCourseChangedMessageCommand=cmd(playcommand,"Set"),
    OffCommand=function(self)
      self:linear(0.25)
      self:diffusealpha(0)
    end;
    Def.Sprite{
      Name = "TicksOver",
      Texture = "_ticks",
      SetCommand=function(self)
        self:diffuse(CustomDifficultyToColor(diff))
        local song = GAMESTATE:GetCurrentSong()
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        if song then
          GetDifListX(self, 250)
          self:y(Difficulty:Reverse()[diff] * SpacingY)
          local steps = song:GetOneSteps(GAMESTATE:GetCurrentStyle():GetStepsType(), diff)
          if steps then
              local meter = steps:GetMeter()
              if meter > 10 then
                  self:diffuse(CustomDifficultyToColor(diff)):cropright(1-meter/10):glowshift():effectcolor1(CustomDifficultyToColor(diff)):effectcolor2(color "#FFFFFF")
              else
                  self:diffuse(CustomDifficultyToColor(diff)):stopeffect():cropright(1-meter/10)
              end
          else
              self:stopeffect():cropright(1)
          end;
        end;
      end;
    };
    LoadActor("DiffColor")..{
      Name="Background";
      SetCommand=function(self)
        self:diffuse(CustomDifficultyToColor(diff))
        local song=GAMESTATE:GetCurrentSong()
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
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
    LoadActor("DiffCenter")..{
      SetCommand=function(self)
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
    LoadFont("_avenirnext lt pro bold 25px")..{
      Name="DiffLabel";
      SetCommand=function(self)
        if player == PLAYER_1 then
          self:halign(0)
        elseif player == PLAYER_2 then
          self:halign(1)
        end;
        self:diffuse(CustomDifficultyToColor(diff))
        self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)))
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          GetDifListX(self, -120)
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
    Def.Quad{
      Name="DiffShine";
      InitCommand=cmd(setsize,256,6;diffusealpha,0.25;blend,Blend.Add;);
      SetCommand=function(self)
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          GetDifListX(self, 0)
          self:y(Difficulty:Reverse()[diff] * SpacingY+2)
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
      Name="Meter";
      InitCommand=cmd(draworder,99;diffuse,Color.White;strokecolor,Color.Black;);
      SetCommand=function(self)
        self:settext("")
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          GetDifListX(self, 100)
          self:y( Difficulty:Reverse()[diff] * SpacingY)
          if song:HasStepsTypeAndDifficulty( st, diff ) then
            local steps = song:GetOneSteps( st, diff )
            self:settext( steps:GetMeter() )
          end
        end;
      end;
    };
  };
  return DifficultyListItem
end;

local difficulties = {"Beginner", "Easy", "Medium", "Hard", "Challenge", "Edit"}

for difficulty in ivalues(difficulties) do
        t[#t+1] = DrawDifListItem("Difficulty_" .. difficulty);
end

t[#t+1] = Def.ActorFrame{
  InitCommand=cmd(y, _screen.cy+50;zoom,1.1 ),
  LoadActor("DiffColor")..{
    Name="Background";
    InitCommand=function(self)
      GetDifListX(self, 0)
    end;
    OffCommand=function(self)
      self:linear(0.25)
      self:diffusealpha(0)
    end;
    ["CurrentSteps" .. ToEnumShortString(player) .. "ChangedMessageCommand"]=function(self)
      self:diffusealpha(0)
      self:stoptweening()
      self:diffusealpha(1)
      self:queuecommand("Anim")
      local song=GAMESTATE:GetCurrentSong()
      if song then
        local steps = GAMESTATE:GetCurrentSteps(player)
        if steps then
          local diff = steps:GetDifficulty();
          local st=GAMESTATE:GetCurrentStyle():GetStepsType();
          self:y(Difficulty:Reverse()[diff] * SpacingY)
        end;
      end;
    end;
    AnimCommand=cmd(diffuseshift;effectclock,"beat";effectcolor1,color("1,1,1,0.75");effectcolor2,color("1,1,1,0"));
  };
}

return t;
