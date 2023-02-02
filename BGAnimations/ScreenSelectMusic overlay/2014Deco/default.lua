local t = Def.ActorFrame{};

local SongAttributes = LoadModule"SongAttributes.lua"

if not GAMESTATE:IsCourseMode() then
	t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");
	t[#t+1] = LoadActor("BPM.lua");

	if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
	t[#t+1] = LoadActor("PaneOne",PLAYER_1)..{
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
		OffCommand=function(s) s:visible(false) end,
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
	t[#t+1] = LoadActor("PaneOne",PLAYER_2)..{
		InitCommand=function(s)
			local profileID = GetProfileIDForPlayer(PLAYER_1)
			local pPrefs = ProfilePrefs.Read(profileID)
			s:visible(pPrefs.Pane == true and true or false)
		end,
		OffCommand=function(s) s:visible(false) end,
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

	-- Left/right arrows that bounce to the beat
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx-155,MusicWheelY()) end,
		OffCommand=function(s) s:stopeffect():accelerate(0.3):addx(-SCREEN_WIDTH) end,
		OnCommand=function(s) s:zoom(0):decelerate(0.2):zoom(1) end,
		StartSelectingStepsMessageCommand=function(s) s:playcommand("Off") end,
		SongUnchosenMessageCommand=function(s) s:accelerate(0.3):addx(SCREEN_WIDTH) end,
		LoadActor("arrowb") .. {
			OnCommand=function(s) s:bounce():effectclock("beat"):effectperiod(1):effectmagnitude(10,0,0):effectoffset(0.2) end,
			PreviousSongMessageCommand=function(s) s:stoptweening():linear(0):x(-20):decelerate(0.5):x(0) end,
		};
		LoadActor("arrowm") .. {
			OnCommand=function(s) s:diffusealpha(0):bounce():effectclock("beat"):effectperiod(1):effectmagnitude(10,0,0):effectoffset(0.2) end,
			PreviousSongMessageCommand=function(s) s:stoptweening():linear(0):diffusealpha(1):x(-20):decelerate(0.5):x(0):sleep(0):diffusealpha(0) end,
		};
	};

	t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx+155,MusicWheelY()):zoomx(-1) end,
		OnCommand=function(s) s:zoomx(0):zoomy(0):decelerate(0.2):zoomx(-1):zoomy(1) end,
		OffCommand=function(s) s:stopeffect():accelerate(0.3):addx(SCREEN_WIDTH) end,
		StartSelectingStepsMessageCommand=function(s) s:playcommand("Off") end,
		SongUnchosenMessageCommand=function(s) s:accelerate(0.3):addx(-SCREEN_WIDTH) end,
		LoadActor("arrowb") .. {
			OnCommand=function(s) s:bounce():effectclock("beat"):effectperiod(1):effectmagnitude(10,0,0):effectoffset(0.2) end,
			NextSongMessageCommand=function(s) s:stoptweening():linear(0):x(-20):decelerate(0.5):x(0) end,
		};
		LoadActor("arrowm") .. {
			OnCommand = function(s) s:diffusealpha(0):bounce():effectclock("beat"):effectperiod(1):effectmagnitude(10,0,0):effectoffset(0.2) end,
			NextSongMessageCommand=function(s) s:stoptweening():linear(0):diffusealpha(1):x(-20):decelerate(0.5):x(0):sleep(0):diffusealpha(0) end,
		};
	};

t[#t+1] = LoadActor("BannerHandler")..{
	InitCommand=function(s) s:xy(_screen.cx,_screen.cy-150):diffusealpha(1):draworder(1):zoomy(0) end,
  	OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(1) end,
  	OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
};

	for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
		t[#t+1] = LoadActor("Difficulty", pn);
		t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/2014Deco/RadarHandler"),pn);
	end

	t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP1_Default", "GrooveRadarP1_Default" );
	t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP2_Default", "GrooveRadarP2_Default" );
	local Started = 0;
	for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
		t[#t+1] = Def.Sprite{
			InitCommand=function(s) s:player(pn):draworder(100):xy(pn=="PlayerNumber_P2" and _screen.cx+160 or _screen.cx-160,_screen.cy-30):zoom(5):diffuseshift():effectcolor1(color("1,1,1,1")):effectcolor2(color("0.85,0.85,0.85,1")):effectperiod(0.25):diffusealpha(0)
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
		t[#t+1] = LoadActor("TwoPart", pn);
	end
end


return t;
