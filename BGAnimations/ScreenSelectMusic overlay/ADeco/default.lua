local t = Def.ActorFrame{};

for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
t[#t+1] = LoadActor("../2014Deco/Difficulty", pn)..{
InitCommand=function(s) s:diffusealpha(1):draworder(40):y(_screen.cy-140) end,
OnCommand=function(s) s:diffusealpha(0):linear(0.2):diffusealpha(1) end,
		OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
}
t[#t+1] = LoadActor("../2014Deco/TwoPart", pn)..{
InitCommand=function(s) s:diffusealpha(1):draworder(40) end,
}
end

if not GAMESTATE:IsCourseMode() then
--t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");

if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	t[#t+1] = LoadActor("../2014Deco/PaneOne",PLAYER_1)..{
		InitCommand=function(s)
			local profileID = GetProfileIDForPlayer(PLAYER_1)
			local pPrefs = ProfilePrefs.Read(profileID)
			s:visible(pPrefs.Pane == true and true or false)
		end,
		CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
			if song then
				self:zoom(1);
			else
				self:zoom(1);
			end;
		end;
		CodeMessageCommand=function(self,params)
			local pn = params.PlayerNumber
			if pn == PLAYER_1 then
				if params.Name=="OpenPanes1" then
					local profileID = GetProfileIDForPlayer(PLAYER_1)
					local pPrefs = ProfilePrefs.Read(profileID)
					pPrefs.Pane = true
					ProfilePrefs.Save(profileID)
					ProfilePrefs.SaveAll()
					self:visible(true)
				end;
				if params.Name=="ClosePanes" then
					local profileID = GetProfileIDForPlayer(PLAYER_1)
					local pPrefs = ProfilePrefs.Read(profileID)
					pPrefs.Pane = false
					ProfilePrefs.Save(profileID)
					ProfilePrefs.SaveAll()
					self:visible(false)
				end;
			end;
		end;
	};
	end;
	
	if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
	t[#t+1] = LoadActor("../2014Deco/PaneOne",PLAYER_2)..{
		InitCommand=function(s)
			local profileID = GetProfileIDForPlayer(PLAYER_2)
			local pPrefs = ProfilePrefs.Read(profileID)
			s:visible(pPrefs.Pane == true and true or false)
		end,
		CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong()
			if song then
				self:zoom(1);
			else
				self:zoom(1);
			end;
		end;
		CodeMessageCommand=function(self,params)
			local pn = params.PlayerNumber
			if pn == PLAYER_2 then
				if params.Name=="OpenPanes1" then
					local profileID = GetProfileIDForPlayer(PLAYER_2)
					local pPrefs = ProfilePrefs.Read(profileID)
					pPrefs.Pane = true
					ProfilePrefs.Save(profileID)
					ProfilePrefs.SaveAll()
					self:visible(true)
				end;
				if params.Name=="ClosePanes" then
					local profileID = GetProfileIDForPlayer(PLAYER_2)
					local pPrefs = ProfilePrefs.Read(profileID)
					pPrefs.Pane = false
					ProfilePrefs.Save(profileID)
					ProfilePrefs.SaveAll()
					self:visible(false)
				end;
			end;
		end;
	};
	end;

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/2014Deco/RadarHandler"),pn);
end

t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP1_Default", "GrooveRadarP1_Default" );
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP2_Default", "GrooveRadarP2_Default" );

t[#t+1] = LoadActor(THEME:GetPathS("","MusicWheel expand"))..{
	CodeMessageCommand=function(self,params)
		local pn = params.PlayerNumber
		if pn==PLAYER_1 or pn==PLAYER_2 then
			if params.Name=="OpenPanes1" or params.Name=="ClosePanes" then
				self:play()
			end;
		end;
	end;
};
end;

local Started = 0;
for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.Sprite{
		InitCommand=function(s) s:player(pn):draworder(100):xy(pn=="PlayerNumber_P2" and _screen.cx+300 or _screen.cx+100,_screen.cy-295):zoom(5):diffuseshift():effectcolor1(color("1,1,1,1")):effectcolor2(color("0.85,0.85,0.85,1")):effectperiod(0.25):diffusealpha(0)
			s:Load(THEME:GetPathB("ScreenSelectMusic","overlay/_ShockArrow_mark "..ToEnumShortString(pn)))
		end,
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			local diffuse = 0
			if song then
				local steps = GAMESTATE:GetCurrentSteps(pn)
				if steps then
					if steps:GetRadarValues(pn):GetValue('RadarCategory_Mines') == 0 then
						zoom = 0
						diffuse = 0
					else
						zoom = 1.5
						diffuse = 1
					end
				else
					zoom = 0
					diffuse = 0
				end
			else
				zoom = 0
				diffuse = 0
			end
			self:finishtweening()
			self:diffusealpha(0)
			if Started == 0 then self:sleep(0.4) end
			self:zoom(5):linear(0.1):zoom(1):diffusealpha(diffuse):linear(0.1)
			self:zoom(zoom)
			self:queuecommand("SetStart")
		end,
		SetStartCommand=function(s) Started = 1 end,
		CurrentSongChangedMessageCommand=function(s) s:stoptweening():queuecommand("Set") end,
		["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:stoptweening():queuecommand("Set") end,
 		OffCommand=function(s) s:stoptweening():sleep(0.5):linear(0.2):diffusealpha(0) end,
	};
end

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:xy(_screen.cx-100,_screen.cy-396) end,
	OnCommand=function(s) s:diffusealpha(0):linear(0.2):diffusealpha(1) end,
	OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
	LoadActor("BannerHandler.lua");
	Def.ActorFrame{
		Name="BPMBar";
		InitCommand=function(s) s:xy(140,48) end,
		LoadActor("BPM.lua");
	};
};

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:xy(SCREEN_LEFT,_screen.cy-275) end,
	OnCommand=function(s) s:draworder(144):stoptweening():addx(-400):decelerate(0.2):addx(400) end,
	OffCommand=function(s) s:decelerate(0.2):addx(-400) end,
	LoadActor("Stager")..{
		InitCommand=function(s) s:halign(0) end,
	};
};

t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
--[[
t[#t+1] = Def.Actor{
	CurrentSongChangedMessageCommand=function(s)
		local wheel = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
		if wheel:GetSelectedType() == 'WheelItemDataType_Song' then
			if wheel:GetCurrentIndex()%3 == 0 then
				wheel:sleep(0.05):xy(_screen.cx-30,_screen.cy-80)
			elseif wheel:GetCurrentIndex()%3 == 1 then
				wheel:sleep(0.05):xy(_screen.cx,_screen.cy)
			else
				wheel:sleep(0.05):xy(_screen.cx+30,_screen.cy+80)
			end
		else
			wheel:xy(_screen.cx,_screen.cy)
		end
	end,

};]]

return t;