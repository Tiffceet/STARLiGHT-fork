local t = Def.ActorFrame{
};
local jk = LoadModule "Jacket.lua"

t[#t+1] = Def.ActorFrame{
	Name="FocusedCD",
	InitCommand=function(s) s:xy(_screen.cx,_screen.cy+200):diffusealpha(0) end,
	CurrentSongChangedMessageCommand=function(s) s:finishtweening():linear(0.1):addy(-SCREEN_HEIGHT):linear(0.1):addy(SCREEN_HEIGHT) end,
	OffCommand=function(s) s:finishtweening():sleep(0.1):linear(0.1):addy(-200):sleep(0.1):accelerate(0.15):zoom(5):rotationz(360):diffusealpha(0) end,
	OnCommand=function(s) s:diffusealpha(1) end,
	Def.Sprite{
		Texture=THEME:GetPathG("","MusicWheelItem Song NormalPart/Jukebox/cd/cd_mask"),
		InitCommand=function(s) s:blend(Blend.NoEffect):zwrite(1):clearzbuffer(true) end,
	};
	Def.Sprite{
		BeginCommand=function(s) s:ztest(1):queuecommand("Set") end,
		CurrentSongChangedMessageCommand=function(s,p)
			local song = GAMESTATE:GetCurrentSong();
			local so = GAMESTATE:GetSortOrder();
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			if not mw then return end
			if song then
				local songtit = song:GetDisplayMainTitle();
				if CDImage[songtit] ~= nil then
					local diskImage = CDImage[songtit];
					s:Load(THEME:GetPathG("","MusicWheelItem Song NormalPart/Jukebox/cd/"..diskImage));
					s:zoomtowidth(475):zoomtoheight(475);
				else
					s:Load(jk.GetSongGraphicPath(song,"Jacket"))
				end
			elseif mw:GetSelectedType('WheelItemDataType_Section') then
				s:Load(jk.GetGroupGraphicPath(mw:GetSelectedSection(),"Jacket",so))
			else
				s:Load( THEME:GetPathG("","MusicWheelItem fallback") );
			end
			s:zoomto(475,475);
		end,
	};
	Def.Sprite{
		InitCommand=function(s) s:ztest(1) end,
		CurrentSongChangedMessageCommand=function(s)
			if not GAMESTATE:IsAnExtraStage() then
				local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
				if not mw then return end
				if mw:GetSelectedType() == 'WheelItemDataType_Custom' then
					s:Load(THEME:GetPathG("","_jackets/COURSE.png")):visible(true)
				else
					s:visible(false)
				end
				s:zoomto(475,475);
			end
		end,
	};
	Def.BitmapText{
		Font="_avenirnext lt pro bold 25px",
		SetCommand=function(s)
			s:diffuse(Color.White):strokecolor(Alpha(Color.Black,0.5)):xy(160,50)
			local song = GAMESTATE:GetCurrentSong()
			local text;
			if song then
				if song:IsLong() then
					text = "Long ver."
				elseif song:IsMarathon() then
					text = "Single ver."
				else
					text = "";
				end
			else
				text = "";
			end
			s:settext(text)
		end,
		CurrentSongChangedMessageCommand=function(s) s:playcommand("Set") end,
	};
	Def.Sprite{
		Texture=THEME:GetPathG("","MusicWheelItem Song NormalPart/Jukebox/cd/overlay"),
	};
};

t[#t+1] = LoadActor("BannerHandler.lua")..{
	InitCommand=function(s) end,
};


-- Left/right arrows that bounce to the beat
t[#t+1] = Def.ActorFrame{
  InitCommand=cmd(xy,_screen.cx-320,SCREEN_BOTTOM-260;zoom,3);
  OffCommand=cmd(stopeffect;accelerate,0.3;addx,-SCREEN_WIDTH);
  OnCommand=cmd(zoom,0;decelerate,0.2;zoom,3;);
  LoadActor("../2014Deco/arrowb") .. {
    InitCommand = cmd(bounce),
    OnCommand = cmd(bounce;effectclock,"beat";effectperiod,1;
      effectmagnitude,10,0,0;effectoffset,0.2),
      PreviousSongMessageCommand=cmd(finishtweening;linear,0;x,-20;decelerate,0.5;x,0);
    };
  LoadActor("../2014Deco/arrowm") .. {
    InitCommand = cmd(bounce;diffusealpha,0),
    OnCommand = cmd(bounce;effectclock,"beat";effectperiod,1;
    effectmagnitude,10,0,0;effectoffset,0.2),
    PreviousSongMessageCommand=cmd(finishtweening;linear,0;diffusealpha,1;x,-20;decelerate,0.5;x,0;sleep,0;diffusealpha,0);
  };
};

t[#t+1] = Def.ActorFrame{
  InitCommand=cmd(xy,_screen.cx+320,SCREEN_BOTTOM-260;zoomx,-1);
  OnCommand=cmd(zoomx,0;zoomy,0;decelerate,0.2;zoomx,-3;zoomy,3);
  OffCommand=cmd(stopeffect;accelerate,0.3;addx,SCREEN_WIDTH);
  LoadActor("../2014Deco/arrowb") .. {
  InitCommand = cmd(bounce),
  OnCommand = cmd(bounce;effectclock,"beat";effectperiod,1;
    effectmagnitude,10,0,0;effectoffset,0.2),
  NextSongMessageCommand=cmd(finishtweening;linear,0;x,-20;decelerate,0.5;x,0);
  };
  LoadActor("../2014Deco/arrowm") .. {
  InitCommand = cmd(bounce;diffusealpha,0),
  OnCommand = cmd(bounce;effectclock,"beat";effectperiod,1;
    effectmagnitude,10,0,0;effectoffset,0.2),
  NextSongMessageCommand=cmd(finishtweening;linear,0;diffusealpha,1;x,-20;decelerate,0.5;x,0;sleep,0;diffusealpha,0);
  };
};

t[#t+1] = LoadActor("../2014Deco/BPM.lua")..{
	InitCommand=function(s) s:y(-190) end,
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

for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
t[#t+1] = LoadActor("../2014Deco/Difficulty/default.lua", pn)..{
InitCommand=cmd(diffusealpha,1; draworder,40;addy,600),
}
t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/2014Deco/RadarHandler"),pn)..{
	InitCommand=cmd(diffusealpha,1),
}
end
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP1_Default", "GrooveRadarP1_Default" );
	t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP2_Default", "GrooveRadarP2_Default" );

t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay")..{
	InitCommand=cmd(xy,_screen.cx,_screen.cy-270;zoom,1;draworder,100);
  };

  t[#t+1] = LoadActor("Header.png")..{
	  InitCommand=function(s) s:xy(_screen.cx,SCREEN_TOP):valign(0) end,
	  OnCommand=function(s) s:addy(-220):sleep(0.1):decelerate(0.2):addy(220) end,
	  OffCommand=function(s) s:accelerate(0.2):addy(-220) end,
  }

return t;
