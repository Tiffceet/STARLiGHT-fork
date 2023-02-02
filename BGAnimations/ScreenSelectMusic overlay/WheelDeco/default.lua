local t = Def.ActorFrame{};

t[#t+1] = LoadActor("BannerHandler.lua");

t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay")..{
  InitCommand=cmd(xy,SCREEN_LEFT+340,_screen.cy-160;zoom,1);
};

t[#t+1] = Def.ActorFrame{
	InitCommand = cmd(xy,IsUsingWideScreen() and _screen.cx-488 or _screen.cx-240,SCREEN_BOTTOM-150),
	OnCommand=cmd(addy,600;sleep,0.4;decelerate,0.3;addy,-600);
  OffCommand=cmd(sleep,0.3;decelerate,0.3;addy,600);
  LoadActor("RadarBack");
  LoadActor("eq") .. {
    InitCommand = cmd(diffuse,color("0.25,0.25,0.25,0.5")),
  };
  LoadActor("BPM.lua");
  Def.ActorFrame{
    Def.Quad {
    	InitCommand = cmd(zoomto,916,204;y,-10),
    	OnCommand = cmd(bounce;effectclock,"beat";
    		effectperiod,2;effectmagnitude,0,254,0;MaskSource,true),
    };
    LoadActor("eq") .. {
    	InitCommand = cmd(MaskDest;ztestmode,"ZTestMode_WriteOnFail"),
    };
  };
};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
  t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/WheelDeco/RadarHandler.lua"),pn);
t[#t+1] = LoadActor("Pane.lua")..{
  InitCommand = cmd(xy,IsUsingWideScreen() and _screen.cx-488 or _screen.cx-240,SCREEN_BOTTOM-145),
	OnCommand=cmd(addy,600;sleep,0.4;decelerate,0.3;addy,-600);
	OffCommand=cmd(sleep,0.3;decelerate,0.3;addy,600);
  CurrentSongChangedMessageCommand=function(self)
    local song = GAMESTATE:GetCurrentSong()
  	if song then
  			self:zoom(1);
  		else
  			self:zoom(1);
  		end;
  	end;
  };
end;

if GAMESTATE:IsPlayerEnabled('PlayerNumber_P1') then
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP1_Default", "GrooveRadarP1_Default" )..{
  InitCommand = cmd(player,PLAYER_1;xy,SCREEN_LEFT+174,SCREEN_BOTTOM-130;zoom,0.6),
};
end

if GAMESTATE:IsPlayerEnabled('PlayerNumber_P2') then
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP2_Default", "GrooveRadarP2_Default" )..{
  InitCommand = cmd(player,PLAYER_2;xy,SCREEN_LEFT+174,SCREEN_BOTTOM-130;zoom,0.6),
};
end

t[#t+1] = Def.ActorFrame{
  InitCommand=cmd(xy,SCREEN_CENTER_X+436,_screen.cy+24);
  LoadActor("frame")..{
    OnCommand=cmd(addx,1100;sleep,0.5;decelerate,0.2;addx,-1100);
    OffCommand=cmd(sleep,0.3;decelerate,0.3;addx,1100);
  };
};


t[#t+1] = Def.ActorFrame{
  InitCommand=function(s)
    s:xy(IsUsingWideScreen() and SCREEN_LEFT+408 or SCREEN_LEFT+330,_screen.cy+80)
    :zoom(IsUsingWideScreen() and 1 or 0.8)
  end,
  OnCommand=cmd(addx,-800;sleep,0.3;decelerate,0.3;addx,800);
  OffCommand=cmd(sleep,0.3;decelerate,0.3;addx,-800);
  LoadActor("DiffBacker");
  LoadActor("DiffFrame")..{
    InitCommand=function(self) self:x(4) end
  };
  LoadActor("DDRDifficultyList.lua")..{
    InitCommand=function(self) self:x(4) end
  };
};

--Banner Area
t[#t+1] = LoadActor("Header")..{
  InitCommand=cmd(align,0,0;xy,SCREEN_LEFT,SCREEN_TOP+16);
  OnCommand=cmd(addx,-1000;sleep,0.1;decelerate,0.3;addx,1000);
  OffCommand=cmd(sleep,0.3;decelerate,0.3;addx,-1000);
};

return t;
