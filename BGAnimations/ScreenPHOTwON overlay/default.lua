--Taken from Project XV Epsilon, customized for STARLight, Inori

local curState = "MenuState_Main";

local MenuState = {
  MenuState_Main,
  MenuState_MenuBG,
  MenuState_BGM,
  MenuState_Wheel,
  MenuState_Gameplay,
};

local curIndex = 1;
local MenuChoices = {
  "MenuBG",
  "BGM",
  "Wheel",
  "Gameplay",
  "Back"
};

local menuC;
local wait = 0;

local t = Def.ActorFrame{
	OnCommand=function(s)
        SCREENMAN:GetTopScreen():lockinput(1)
        s:sleep(1):queuecommand("UpdateWait")
    end,
    UpdateWaitCommand=function(s)
        wait = 1
    end,
	InitCommand=function(self)
		menuC = self:GetChildren();
	end;
	Def.Actor{
		Name="MenuController";
		MenuInputMessageCommand=function(self,param)
			if GAMESTATE:IsHumanPlayer(param.Player) then
				if curState == "MenuState_Main" then
					if param.Input == "Start" then
						if wait ~= 0 then
							if curIndex == 1 then
								curState = "MenuState_MenuBG";
							elseif curIndex == 2 then
								curState = "MenuState_BGM";
							elseif curIndex == 3 then
								curState = "MenuState_Wheel";
							elseif curIndex == 4 then
								curState = "MenuState_Gameplay";
								SCREENMAN:AddNewScreenToTop("ScreenOptionsTheme","SM_GoToNextScreen")
            				elseif curIndex == 5 then
								  SCREENMAN:GetTopScreen():SetNextScreenName(Branch.FirstScreen()):StartTransitioningScreen("SM_GoToNextScreen")
								  SOUND:StopMusic()
							end;
							MESSAGEMAN:Broadcast("MenuStateChanged",{ NewState = curState; });
						end
					elseif param.Input == "Back" then
						-- in MenuState_Main, we quit.
						SCREENMAN:GetTopScreen():Cancel()
					elseif param.Input == "Up" or param.Input == "Left" then
						if curIndex == 1 then curIndex = #MenuChoices;
						else curIndex = curIndex - 1;
						end;

						local curItemName = MenuChoices[curIndex];
						local lastIndex = (curIndex == #MenuChoices) and 1 or curIndex+1;
						local prevItemName = MenuChoices[lastIndex];

						MESSAGEMAN:Broadcast("MainMenuFocusChanged",{Gain = curItemName, Lose = prevItemName});
						menuC[curItemName]:playcommand("GainFocus");
						menuC[prevItemName]:playcommand("LoseFocus");
					elseif param.Input == "Down" or param.Input == "Right" then
						if curIndex == #MenuChoices then curIndex = 1;
						else curIndex = curIndex + 1;
						end;

						local curItemName = MenuChoices[curIndex];
						local lastIndex = (curIndex == 1) and #MenuChoices or curIndex-1;
						local prevItemName = MenuChoices[lastIndex];

						MESSAGEMAN:Broadcast("MainMenuFocusChanged",{Gain = curItemName, Lose = prevItemName});
						menuC[curItemName]:playcommand("GainFocus");
						menuC[prevItemName]:playcommand("LoseFocus");
					else
						--Trace("Input ".. param.Input .." not implemented on main menu");
					end;
				else
					-- if we're not on the main menu, we want to send the
					-- input messages so effort isn't duplicated elsewhere.
					local inputParam = {
						Player = param.Player,
						Input = param.Input,
						Choice = curChoice,
						MenuState = curState
					};
					-- broadcast an input message so other elements can access it
					MESSAGEMAN:Broadcast("PlayerMenuInput",inputParam);
				end;
			end;
		end;
		MenuUpP1MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_1, Input = "Up", }); end;
		MenuUpP2MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_2, Input = "Up", }); end;
		MenuDownP1MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_1, Input = "Down", }); end;
		MenuDownP2MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_2, Input = "Down", }); end;
		MenuLeftP1MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_1, Input = "Left", }); end;
		MenuLeftP2MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_2, Input = "Left", }); end;
		MenuRightP1MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_1, Input = "Right", }); end;
		MenuRightP2MessageCommand=function(self) MESSAGEMAN:Broadcast("MenuInput", { Player = PLAYER_2, Input = "Right", }); end;
		-- via codes
		CodeMessageCommand=function(self,param)
			MESSAGEMAN:Broadcast("MenuInput", { Player = param.PlayerNumber, Input = param.Name })
		end;
		MenuStateChangedMessageCommand=function(self,param)
			local curItemName = MenuChoices[curIndex];
			if param.NewState == 'MenuState_Main' then
				menuC[curItemName]:playcommand("FinishedEditing");
				-- restore all dimmed items
				for idx, nam in pairs(MenuChoices) do
					if nam ~= "Exit" and nam ~= curItemName then
						menuC[nam]:playcommand("UnfocusedOut");
					end;
				end;
			else
				menuC[curItemName]:playcommand("StartedEditing");
				-- dim all non-selected items
				for idx, nam in pairs(MenuChoices) do
					if nam ~= "Exit" and nam ~= curItemName then
						menuC[nam]:playcommand("UnfocusedIn");
					end;
				end;
			end;
			curState = param.NewState;
		end;
		OffCommand=function(self) setenv("PHOTwONSpecialEditMode",false); end;
	};
};

-- Life Frame Styles
t[#t+1] = LoadActor("MenuBG");

t[#t+1] = LoadActor("_menuitem menubg")..{
	Name="MenuBG";
	InitCommand=function(s) s:xy(_screen.cx,_screen.cy-300) end,
	OnCommand=function(s) s:queuecommand("GainFocus") end,
	GainFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,1")) end,
	LoseFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,0.5")) end,
	StartedEditingCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-SCREEN_HEIGHT) end,
	FinishedEditingCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-300) end,
	UnfocusedInCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-SCREEN_HEIGHT) end,
	UnfocusedOutCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-300) end,
};

t[#t+1] = LoadActor("BGM");
t[#t+1] = LoadActor("_menuitem BGM")..{
	Name="BGM";
	InitCommand=function(s) s:xy(_screen.cx,_screen.cy-120) end,
	OnCommand=function(s) s:queuecommand("LoseFocus") end,
	GainFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,1")) end,
	LoseFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,0.5")) end,
 	StartedEditingCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-SCREEN_HEIGHT) end,
	FinishedEditingCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-120) end,
	UnfocusedInCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-SCREEN_HEIGHT) end,
	UnfocusedOutCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-120) end,
};

t[#t+1] = LoadActor("Wheel");
t[#t+1] = LoadActor("_menuitem wheel")..{
	Name="Wheel";
	InitCommand=function(s) s:xy(_screen.cx,SCREEN_CENTER_Y+60) end,
	OnCommand=function(s) s:queuecommand("LoseFocus") end,
	GainFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,1")) end,
	LoseFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,0.5")) end,
	StartedEditingCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-SCREEN_HEIGHT) end,
	FinishedEditingCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y+60) end,
	UnfocusedInCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-SCREEN_HEIGHT) end,
	UnfocusedOutCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y+60) end,
};

t[#t+1] = LoadActor("_menuitem gameplay")..{
	Name="Gameplay";
	InitCommand=function(s) s:xy(_screen.cx,SCREEN_CENTER_Y+240) end,
	OnCommand=function(s) s:queuecommand("LoseFocus") end,
	GainFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,1")) end,
	LoseFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,0.5")) end,
	StartedEditingCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-SCREEN_HEIGHT) end,
	FinishedEditingCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y+240) end,
	UnfocusedInCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-SCREEN_HEIGHT) end,
	UnfocusedOutCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y+240) end,
}

t[#t+1] = LoadActor("_menuitem exit")..{
	Name="Back";
	InitCommand=function(s) s:xy(_screen.cx,SCREEN_CENTER_Y+420) end,
	OnCommand=function(s) s:queuecommand("LoseFocus") end,
	GainFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,1")) end,
	LoseFocusCommand=function(s) s:stoptweening():diffuse(color("1,1,1,0.5")) end,
	UnfocusedInCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y-SCREEN_HEIGHT) end,
	UnfocusedOutCommand=function(s) s:stoptweening():decelerate(0.3):y(SCREEN_CENTER_Y+420) end,
};

return t;
