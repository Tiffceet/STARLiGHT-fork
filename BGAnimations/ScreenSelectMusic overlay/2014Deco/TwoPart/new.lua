local args = {...};
local pn = args[1];

local t = Def.ActorFrame{};

local function MakeDiffItem(diff, idx)
  local diffname = diff:GetDifficulty()
  return Def.ActorFrame{
    CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
    ["CurrentSteps"..pn.."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
    Def.Sprite{
      InitCommand=function(s) s:zoomx(pn==PLAYER_2 and -1 or 1) end,
      SetCommand=function(s)
        s:Load(THEME:GetPathB("","ScreenSelectMusic overlay/2014Deco/TwoPart/"..THEME:GetString("CustomDifficulty",ToEnumShortString(diffname))..".png"))
      end,
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold 36px";
      InitCommand=function(s)
        s:halign(pn==PLAYER_2 and 1 or 0):zoom(0.85):xy(pn==PLAYER_2 and 220 or -220,-40)
        s:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diffname))):diffuse(CustomDifficultyTwoPartToColor(diffname))
      end,
    };
    Def.BitmapText{
      Name="Desc";
      Font="_avenirnext lt pro bold 25px";
      InitCommand=function(s)
        s:halign(pn==PLAYER_2 and 1 or 0):zoom(0.85):valign(0):zoom(0.7):xy(pn==PLAYER_2 and 220 or -220,-8)
        s:strokecolor(ColorDarkTone(CustomDifficultyTwoPartToColor(diffname)))
        s:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diffname).."Desc"))
      end,
    };
    Def.BitmapText{
      Name="Meter";
      Font="_avenirnext lt pro bold 36px";
      InitCommand=function(s)
        s:xy(pn==PLAYER_2 and -174 or 174,16):diffuse(CustomDifficultyTwoPartToColor(diffname))
        local song = GAMESTATE:GetCurrentSong()
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        if song then
          if song:HasStepsTypeAndDifficulty(st,diffname) then
            local steps=song:GetOneSteps(st,diffname)
            s:settext(steps:GetMeter())
          end
        end
      end,
    };
  };
end

local difflist = GAMESTATE:GetCurrentSong():GetStepsByStepsType(GAMESTATE:GetCurrentStyle():GetStepsType());

function diffupdate(self)
  local song = GAMESTATE:GetCurrentSong()
  if song then
    difflist = GAMESTATE:GetCurrentSong():GetStepsByStepsType(GAMESTATE:GetCurrentStyle():GetStepsType());
  end
end

local DifficultList = {};
for i=1,#difflist do
  DifficultList[#DifficultList+1] = MakeDiffItem(difflist[i],i)
end

t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:xy(pn==PLAYER_2 and SCREEN_RIGHT-232 or SCREEN_LEFT+232,_screen.cy)
    s:queuecommand("UpdateInternal")
  end,
  BeginCommand=function(s) s:addx(pn==PLAYER_2 and 463 or -463) end,
  StartSelectingStepsMessageCommand=function(s) s:linear(0.4):addx(pn==PLAYER_2 and -463 or 463) end,
  SongUnchosenMessageCommand=function(s) s:linear(0.4):addx(pn==PLAYER_2 and 463 or -463) end,
  CurrentSongChangedMessageCommand=function(self)
    self:queuecommand("UpdateInternal")
  end,
  UpdateInternalCommand=function(s)
    diffupdate(s)
  end,
  Def.Quad{
    InitCommand=function(s) s:setsize(463,SCREEN_HEIGHT):diffuse(Alpha(Color.Black,0.75)) end,
  };
  Def.ActorScroller{
    Name="DiffScroller";
    InitCommand=function(s) s:y(-200) end,
    SecondsPerItem=0;
    NumItemsToDraw=10;
    TransformFunction=function(self,offsetFromCenter,itemIndex,numItems)
			self:y( offsetFromCenter * 150 );
    end;
    children=DifficultList;
  };
};

return t;
