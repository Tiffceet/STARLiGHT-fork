local t = Def.ActorFrame{};

for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
t[#t+1] = LoadActor("2014Deco/Difficulty.lua", pn)..{
InitCommand=cmd(diffusealpha,1; draworder,40;),
}
t[#t+1] = LoadActor("2014Deco/TwoPart.lua", pn)..{
InitCommand=cmd(diffusealpha,1; draworder,40;),
}
end

if not GAMESTATE:IsCourseMode() then
--t[#t+1] = StandardDecorationFromFileOptional("BPMDisplay","BPMDisplay");
t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay")..{
	OnCommand=cmd(draworder,144;stoptweening;addx,-400;decelerate,0.2;addx,400);
	OffCommand=cmd(decelerate,0.2;addx,-400);
};

if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
t[#t+1] = LoadActor("2014Deco/PaneOne P1.lua")..{
	InitCommand=cmd(visible,false;xy,-260,300);
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
				self:visible(true)
			end;
			if params.Name=="ClosePanes" then
				self:visible(false)
			end;
		end;
	end;
};
end;

if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
t[#t+1] = LoadActor("2014Deco/PaneOne P2.lua")..{
	InitCommand=cmd(visible,false;xy,260,300);
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
				self:visible(true)
			end;
			if params.Name=="ClosePanes" then
				self:visible(false)
			end;
		end;
	end;
};
end;

t[#t+1] = Def.ActorFrame{
	InitCommand = cmd(player,PLAYER_1;xy,SCREEN_LEFT+180,_screen.cy+51),
	OnCommand=cmd(zoom,0;linear,0.135;zoom,1);
	OffCommand=cmd(sleep,0.3;decelerate,0.3;zoom,0);
	LoadActor("2014Deco/RadarLabels")..{
		InitCommand=cmd(y,-8);
	};
 	LoadActor("2014Deco/GrooveRadar base");
	LoadActor("2014Deco/sweep") .. {
		InitCommand = cmd(zoom,1.275),
		OnCommand = cmd(hibernate,0.8;queuecommand,"Animate"),
		AnimateCommand = cmd(rotationz,0;linear,2;rotationz,360;queuecommand,"Animate"),
	}
};
t[#t+1] = Def.ActorFrame{
	InitCommand = cmd(player,PLAYER_2;xy,SCREEN_RIGHT-180,_screen.cy+51),
	OffCommand=cmd(sleep,0.3;decelerate,0.3;zoom,0);
	OnCommand=cmd(zoom,0;linear,0.135;zoom,1);
	LoadActor("2014Deco/RadarLabels")..{
		InitCommand=cmd(y,-8);
	};
 	LoadActor("2014Deco/GrooveRadar base");
	LoadActor("2014Deco/sweep") .. {
		InitCommand = cmd(zoom,1.275),
		OnCommand = cmd(hibernate,0.8;queuecommand,"Animate"),
		AnimateCommand = cmd(rotationz,0;linear,2;rotationz,360;queuecommand,"Animate"),
	}
};

t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP1_Default", "GrooveRadarP1_Default" );
t[#t+1] = StandardDecorationFromFileOptional( "GrooveRadarP2_Default", "GrooveRadarP2_Default" );

t[#t+1] = LoadActor(THEME:GetPathS("","MusicWheel expand.mp3"))..{
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

t[#t+1] = LoadActor( "2014Deco/_ShockArrow_mark 1P" ) .. {
	InitCommand=cmd(player,PLAYER_1;draworder,100;x,SCREEN_CENTER_X-185;y,SCREEN_CENTER_Y;zoom,1.5;
	diffuseshift;effectcolor1,1,1,1,1;effectcolor2,0.85,0.85,0.85,1;effectperiod,0.25;queuecommand,"Set");
	SetCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		local diffuse = 0
		if song then
			local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
			if steps then
				if steps:GetRadarValues(PLAYER_1):GetValue('RadarCategory_Mines') == 0 then
					yZoom = 0
				else
					yZoom = 1.5
				end
			else
				yZoom = 0
			end
		else
			yZoom = 0
		end
		self:finishtweening()
		self:zoomy(yZoom)
	end;
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	OffCommand=cmd(stoptweening;sleep,0.5;linear,0.2;diffusealpha,0);
};

-- ShockArrow mark 2P
t[#t+1] = LoadActor( "2014Deco/_ShockArrow_mark 2P" ) .. {
	InitCommand=cmd(player,PLAYER_2;draworder,100;x,SCREEN_CENTER_X+195;y,SCREEN_CENTER_Y;zoom,1.5;
	diffuseshift;effectcolor1,1,1,1,1;effectcolor2,0.85,0.85,0.85,1;effectperiod,0.25;queuecommand,"Set");
	SetCommand=function(self)
		local yZoom = 0
		if GAMESTATE:GetCurrentSong() then
			local steps = GAMESTATE:GetCurrentSteps(PLAYER_2)
			if steps then
				if steps:GetRadarValues(PLAYER_2):GetValue('RadarCategory_Mines') == 0 then
					yZoom = 0
				else
					yZoom = 1.5
				end
			else
				yZoom = 0
			end
		else
			yZoom = 0
		end
		self:finishtweening()
		self:zoomy(yZoom)
	end;
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
	OffCommand=cmd(decelerate,0.25;zoomy,0);
};

return t;
