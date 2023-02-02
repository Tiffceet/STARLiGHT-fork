local args = {...};
local pn = args[1];

local song = GAMESTATE:GetCurrentSong()
local st = GAMESTATE:GetCurrentStyle():GetStepsType()
local steps = song:GetStepsByStepsType(st)
local curIndex = 1


local function input(event,param)
    if not event.PlayerNumber or not event.button then
        return false
    end
    if event.type ~= "InputEventType_Release" then
        if event.GameButton == "Start" then
            SCREENMAN:GetTopScreen():SetNextScreenName("ScreenStageInformation"):StartTransitioningScreen("SM_GoToNextScreen")
        elseif event.GameButton == "MenuRight" then
            if curIndex >= #steps then
                curIndex = curIndex
            else
                curIndex = curIndex+1
            end
        elseif event.GameButton == "MenuLeft" then
            if curIndex == 1 then
                curIndex = curIndex
            else
                curIndex = curIndex-1
            end
        end
        MESSAGEMAN:Broadcast("MoveScroller")
    end
    return false
end

local function p(text)
    return text:gsub("%%", ToEnumShortString(pn));
end

local screen = SCREENMAN:GetTopScreen();
local function MakeRow(steps,idx)
    local hasFocus = idx == 1;
    return Def.ActorFrame{
        Name="Row"..idx;
        BeginCommand=function(s) s:playcommand(idx == curIndex and "GainFocus" or "LoseFocus") end,
        MoveScrollerMessageCommand=function(self,param)
			if curIndex == idx then
				self:playcommand("GainFocus")
			else
				self:playcommand("LoseFocus")
			end
		end;
        Def.Quad{
            InitCommand=function(s) s:setsize(128,50) end,
            GainFocusCommand=cmd(diffuse,color("0,0,0,1"));
			LoseFocusCommand=cmd(diffuse,color("1,1,1,1"));
        },
        Def.Sprite{
            InitCommand=function(s)
                s:Load(THEME:GetPathB("ScreenSelectDifficulty","decorations/TwoPart/"..THEME:GetString("CustomDifficulty",ToEnumShortString(steps:GetDifficulty()))..".png"))
            end
        },
    }
end

local RowList = {};
for i=1,#steps do
    RowList[#RowList+1] = MakeRow(steps[i],i)
end

local t = Def.ActorFrame{
    InitCommand=function(s) s:Center():queuecommand("Capture") end,
    CaptureCommand=function(s) 
		SCREENMAN:GetTopScreen():AddInputCallback(input)
		SOUND:PlayOnce(THEME:GetPathS("_PHOTwON","back"))
	end,
    Def.ActorScroller{
        Name="DiffScroller";
        SecondsPerItem=0;
        NumItemsToDraw=30;
        TransformFunction=function(self,offsetFromCenter,itemIndex,numItems)
			self:y( offsetFromCenter * 20 );
		end;
        children = RowList;
        MoveScrollerMessageCommand=function(s,param)
            local screen = SCREENMAN:GetTopScreen{};
            s:SetCurrentAndDestinationItem(curIndex)
		end,
    },
};

t[#t+1] = LoadActor( THEME:GetPathS("", "_MusicWheel change") )..{ Name="change_sound", SupportPan = false }
t[#t+1] = LoadActor( THEME:GetPathS("", "player mine") )..{ Name="change_invalid", SupportPan = false }
t[#t+1] = LoadActor( THEME:GetPathS("common", "start") )..{ Name="start_sound", SupportPan = false }

return t;