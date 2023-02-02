return Def.CourseContentsList {

	MaxSongs = 10;
	NumItemsToDraw = 9;
	ShowCommand=cmd(bouncebegin,0.3;zoomy,1);
	HideCommand=cmd(linear,0.3;zoomy,0);
	SetCommand=function(self)
		self:pause()
		self:finishtweening()
		self:SetFromGameState();
		self:SetCurrentAndDestinationItem(0);
		self:SetPauseCountdownSeconds(1);
		self:SetSecondsPauseBetweenItems( 0.5 );
		if GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() > 5 then
			self:SetDestinationItem(GAMESTATE:GetCurrentCourse():GetEstimatedNumStages()-5);
			seconds = self:GetSecondsToDestination();
			self:queuecommand("Reset");
		else
		end;
	end;
	ResetCommand=function(self)
		self:sleep(seconds+5):queuecommand("Set");
	end;
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");

	Display = Def.ActorFrame {
		InitCommand=cmd(setsize,608,136);
		SetOnCommand=function(s) GetOn = 1 end,
		LoadActor(THEME:GetPathG("CourseEntryDisplay","base")) .. {
			SetSongCommand=function(self, params)
				self:diffuse( color("#FFFFFF") );
				(cmd(finishtweening;diffusealpha,0;sleep,0.125*params.Number;linear,0.125;diffusealpha,1;linear,0.05;glow,color("1,1,1,0.5");decelerate,0.1;glow,color("0,0,0,0")))(self);
			end;
		};

		-----SongBanner--------------------------------------------
		Def.Sprite {
			Name="SongBanner";
			SetSongCommand=function(self, params)
				if params.Song then
					if GAMESTATE:GetCurrentCourse():AllSongsAreFixed() then
						self:Load(params.Song:GetJacketPath());
					else
						self:Load(THEME:GetPathG("","MusicWheelItem fallback.png"));
					end;
				else
					self:Load(THEME:GetPathG("","MusicWheelItem fallback.png"));
				end
				self:scaletoclipped( 112,112 );
				self:x(-210);
				(cmd(finishtweening;zoomy,0;sleep,0.125*params.Number;linear,0.125;zoomy,1.1;linear,0.05;zoomx,1.1;decelerate,0.1;zoom,1))(self);
			end;
		};

		--------------Song Text
		LoadFont("_avenirnext lt pro bold 25px") .. {
			InitCommand=cmd(x,-140;y,-42;maxwidth,250;horizalign,left;zoom,1.25);
			SetSongCommand=function(self, params)
			self:diffuse( color("0,0,0,1") );
				if params.Secret ==true then
					self:settext("??????");
				else
					if params.Song then
						self:settext(params.Song:GetDisplayFullTitle());
					end;
				end;
				(cmd(finishtweening;diffusealpha,0;sleep,0.125*params.Number;linear,0.125;diffusealpha,1;))(self);
			end;
		};

		LoadFont("_avenirnext lt pro bold 25px") .. {
			InitCommand=cmd(x,-140;y,-10;maxwidth,350;horizalign,left;zoom,1.25);
			SetSongCommand=function(self, params)
			self:diffuse( color("0,0,0,1") );
				if params.Secret ==true then
					self:settext("??????");
				else
					if params.Song then
						self:settext(params.Song:GetDisplayArtist());
					end;
				end;
				(cmd(finishtweening;diffusealpha,0;sleep,0.125*params.Number;linear,0.125;diffusealpha,1;))(self);
			end;
		};

		LoadFont("_avenirnext lt pro bold 36px") .. {
			Name="Number";
			InitCommand=cmd(x,-288);
			SetSongCommand=function(self, params)
				self:settext(string.format("%i", params.Number));

				(cmd(finishtweening;zoom,0.8;zoomy,1.75*1.5;diffusealpha,0;sleep,0.125*params.Number;linear,0.125;diffusealpha,1;linear,0.08;zoomy,0.8*1;zoomx,0.8*1.1;glow,color("1,1,1,0.5");decelerate,0.1;zoomx,0.8;zoomy,1.75;glow,color("1,1,1,0")))(self);
			end;
		};

 		LoadFont("_avenirnext lt pro bold 25px") .. {
			Name="Meter";
			InitCommand=cmd(x,260;y,30;zoom,1.5);
			SetSongCommand=function(self, params)
				if params.PlayerNumber ~= GAMESTATE:GetMasterPlayerNumber() then return end
				self:settext( params.Meter );
				self:diffuse( CustomDifficultyToColor(params.Difficulty) );
				(cmd(finishtweening;zoomy,0;sleep,0.125*params.Number;linear,0.125;zoomy,2;linear,0.05;zoomx,2;decelerate,0.1;zoom,1.5))(self);
			end;
		};

		LoadActor(THEME:GetPathG("CourseEntryDisplay","metertick")) .. {
			InitCommand=cmd(x,-130;y,30;zoom,0.8);
			SetSongCommand=function(self, params)
				if params.Difficulty then
					self:diffuse( CustomDifficultyToColor(params.Difficulty) );
				else
					self:diffuse( color("#FFFFFF") );
				end
			    if tonumber(params.Meter) ~= nil then
				(cmd(finishtweening;horizalign,left;cropright,1;diffusealpha,0;sleep,0.125*params.Number;linear,0.125;diffusealpha,1;linear,0.05;glow,color("1,1,1,0.5");decelerate,0.1;glow,color("1,1,1,0");decelerate,0.1;cropright,1-(params.Meter)/20))(self);
				else
					(cmd(finishtweening;horizalign,left;cropright,1;diffusealpha,0;))(self);
				end;
			end;
		};

	};
};
