local curIndex = 0 ;
local screen = SCREENMAN:GetTopScreen{};

local diffnames = {"Beginner", "Easy", "Medium", "Hard", "Challenge", "Edit"};

local function MakeRow(diffnames, idx)
  return Def.ActorFrame{
    Name="Diff"..idx;
    BeginCommand=function(self)
			self:playcommand(idx == curIndex and "GainFocus" or "LoseFocus")
		end;
		MoveScrollerP1MessageCommand=function(self,param)
			if curIndex == idx then
				self:playcommand("GainFocus")
			end
		end;
		Def.Quad{
			InitCommand=cmd(setsize,616,39);
			GainFocusCommand=cmd(diffusealpha,0.25);
		};
  };
end;

local DiffList = {};
for i=1,#diffnames do
  DiffList[#DiffList+1] = MakeRow(diffnames[i],i)
end;

local t = Def.ActorFrame{
  InitCommand=cmd(Center);
  Def.Actor{
		Name="InputHandler";
		MenuUpP1MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_1, Input = "Up", }); end;
		MenuDownP1MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_1, Input = "Down", }); end;
		MenuStartP1MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_1, Input = "Start", }); end;
		CodeMessageCommand=function(self,param)
			MESSAGEMAN:Broadcast("MenuInput", { Player = param.PlayerNumber, Input = param.Name, })
		end;

		MenuInputMessageCommand=function(self,param)
			-- direction
			curIndex = GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty()
			if param.Input == "Up" and param.Player == PLAYER_1 then
				if curIndex == 1 then
					curIndex = 1
				else
					curIndex = curIndex - 1
				end
			elseif param.Input == "Down" and param.Player == PLAYER_1 then
				if curIndex < #DiffList then
					curIndex = curIndex + 1
				end
			end
			MESSAGEMAN:Broadcast("MoveScrollerP1",{Input = param.Input});
		end
	};
  Def.ActorScroller{
		Name="ListScrollerP1";
		SecondsPerItem=0;
		NumItemsToDraw=30;
		InitCommand=cmd(y,-300);
		TransformFunction=function(self,offsetFromCenter,itemIndex,numItems)
			self:y( offsetFromCenter * 49 );
		end;
		children = DiffList;
	};
};

return t;
