local t = Def.ActorFrame{};
t[#t+1] = LoadActor("Header/default.lua");

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenWithMenuElements Header/old.png"))..{
  InitCommand=function(s) s:xy(_screen.cx,SCREEN_TOP+160) end,
  OnCommand=function(s)s :addx(-SCREEN_WIDTH):linear(0.2):addx(SCREEN_WIDTH) end,
  OffCommand=function(s)s :linear(0.2):addx(SCREEN_WIDTH) end,
};
t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay")..{
  InitCommand=function(s) s:zoom(1.25) end,
};

t[#t+1] = LoadActor("../2014Deco/BPM.lua")..{
  InitCommand=function(s) s:y(-110) end,
};

t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:xy(_screen.cx,_screen.cy+270) end,
  CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set"); end,
  OnCommand=function(s) s:zoomy(0):decelerate(0.3):zoomy(1) end,
  OffCommand=function(s) s:accelerate(0.2):zoomy(0) end,
  Def.Banner{
    SetCommand=function(self,params)
      local song = GAMESTATE:GetCurrentSong();
      local so = GAMESTATE:GetSortOrder();
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if not mw then return end
			if song then
        self:visible(true)
				if song:HasBanner() then
					self:LoadBackground(song:GetBannerPath());
				elseif song:HasBackground() then
					self:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
				else
					self:Load(THEME:GetPathG("","MusicWheelItem fallback"));
				end
      else
        self:visible(false)
      end
      self:zoomtowidth(256);
      self:zoomtoheight(80);
		end;
  };
};

-- Left/right arrows that bounce to the beat
t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:xy(_screen.cx-354,SCREEN_BOTTOM-95) end,
  OffCommand=function(s) s:stopeffect():accelerate(0.3):addx(-SCREEN_WIDTH) end,
  OnCommand=function(s) s:zoom(0):decelerate(0.2):zoom(1.8) end,
  LoadActor("../2014Deco/arrowb") .. {
    PreviousSongMessageCommand=function(s) s:stoptweening():linear(0):x(-20):decelerate(0.5):x(0) end,
  };
  LoadActor("../2014Deco/arrowm") .. {
    InitCommand = function(s) s:diffusealpha(0) end,
    PreviousSongMessageCommand=function(s) s:stoptweening():linear(0):diffusealpha(1):x(-20):decelerate(0.5):x(0):sleep(0):diffusealpha(0) end,
  };
};

t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:xy(_screen.cx+340,SCREEN_BOTTOM-94):zoomx(-1.8) end,
  OnCommand=function(s) s:zoomx(0):zoomy(0):decelerate(0.2):zoomx(-1.8):zoomy(1.8) end,
  OffCommand=function(s) s:stopeffect():accelerate(0.3):addx(SCREEN_WIDTH) end,
  LoadActor("../2014Deco/arrowb") .. {
    NextSongMessageCommand=function(s) s:stoptweening():linear(0):x(-20):decelerate(0.5):x(0) end,
  };
  LoadActor("../2014Deco/arrowm") .. {
  InitCommand = function(s) s:diffusealpha(0) end,
  NextSongMessageCommand=function(s) s:stoptweening():linear(0):diffusealpha(1):x(-20):decelerate(0.5):x(0):sleep(0):diffusealpha(0) end,
  };
};

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
    t[#t+1] = LoadActor("../2014Deco/PaneOne",PLAYER_2)..{
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

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
  t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/2014Deco/RadarHandler"),pn);
end

t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP1_Default", "GrooveRadarP1_Default" );
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP2_Default", "GrooveRadarP2_Default" );

t[#t+1] = Def.Sprite{
  Texture="consel.png",
  InitCommand=function(s) s:xy(_screen.cx,SCREEN_BOTTOM-40):visible(false) end,
  OnCommand=function(s) s:addy(100):decelerate(0.2):addy(-100) end,
  OffCommand=function(s) s:accelerate(0.2):addy(100) end,
  StartSelectingStepsMessageCommand=function(self)
    self:visible(true)
  end;
  SongUnchosenMessageCommand=function(self)
    self:visible(false)
  end;
};

t[#t+1] = Def.Quad{
  InitCommand=function(self)
    self:valign(1)
    self:xy(_screen.cx,SCREEN_BOTTOM)
    self:setsize(SCREEN_WIDTH,578);
    self:diffuse(color("1,1,1,1")):diffusetopedge(color("0.5,0.5,1,1"))
  end;
  OnCommand=function(self)
    self:diffusealpha(0)
  end;
  StartSelectingStepsMessageCommand=function(self)
    self:linear(0.25)
    self:diffusealpha(0.75)
  end;
  SongUnchosenMessageCommand=function(self)
    self:linear(0.25)
    self:diffusealpha(0)
  end;
  OffCommand=function(self)
    self:linear(0.25)
    self:diffusealpha(0)
  end;
}

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
  t[#t+1] = LoadActor("TwoPart.lua", pn);
end

local Textbox = Def.BitmapText{
  Font="_avenirnext lt pro bold 25px";
  InitCommand=function(s) s:maxwidth(480):strokecolor(Color.Black) end,
};

t[#t+1] = Def.ActorFrame{
	OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(1) end,
	OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
  InitCommand=function(s) s:xy(_screen.cx,_screen.cy-14) end,
  CurrentSongChangedMessageCommand = function(s) s:queuecommand("Set") end,
	CurrentCourseChangedMessageCommand = function(s) s:queuecommand("Set") end,
	ChangedLanguageDisplayMessageCommand = function(s) s:queuecommand("Set") end,
	Textbox..{
		SetCommand = function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:settext(song and song:GetDisplayFullTitle() or "")
		end,
	};
	Textbox..{
		SetCommand = function(self)
			local song = GAMESTATE:GetCurrentSong()
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			if song then
				self:settext("");
			elseif mw:GetSelectedType('WheelItemDataType_Section') then
				local group = mw:GetSelectedSection()
				if group_name[group] ~= nil then
					self:settext(group_rename[group])
				else
					self:settext(group)
				end;
			else
				self:settext("");
			end;
		end,
	};
};

return t;
