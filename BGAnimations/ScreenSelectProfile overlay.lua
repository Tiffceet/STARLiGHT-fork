--[[
This script was taken from KENp's DDR X2 theme
and was recoded by FlameyBoy and Inorizushi
]]--

local ProfileInfoCache = {}
setmetatable(ProfileInfoCache, {__index =
function(table, ind)
    local out = {}
    local prof = PROFILEMAN:GetLocalProfileFromIndex(ind-1)
    out.DisplayName = prof:GetDisplayName()
    out.UserTable = prof:GetUserTable()
    rawset(table, ind, out)
    return out
end
})

local profnum = PROFILEMAN:GetNumLocalProfiles();
local keyset = {0,0}

--�d�����e����---------------------------
function LoadCard(cColor,cColor2,Player,IsJoinFrame)
	local t = Def.ActorFrame {
		LoadActor( THEME:GetPathG("","ScreenSelectProfile/BG01") ) .. {
			InitCommand=function(self)
				(cmd(shadowlength,0;zoomy,0))(self);
			end;
			OnCommand=cmd(sleep,0.3;linear,0.3;zoomy,1;);
			OffCommand=function(self)
				if IsJoinFrame then
					(cmd(linear,0.1;zoomy,0))(self);
				else
					(cmd(sleep,0.3;linear,0.1;zoomy,0))(self);
				end
			end;
		};
		LoadActor( THEME:GetPathG("","ScreenSelectProfile/card") )..{
			Name = 'Card';
			InitCommand=cmd(diffusealpha,0;zoom,0.75);
			OnCommand=function(self)
			  if IsJoinFrame then
				(cmd(linear,0.3;diffusealpha,0))(self);
			  else
				self:sleep(0.7):linear(0.1):diffusealpha(1):zoom(1.1):linear(0.1):zoom(1)
			  end
			end;
			OffCommand=function(self)
			  self:diffusealpha(0)
			end;
		  };
    Def.ActorFrame{
      Name="Topper";
      InitCommand=function(self)
        (cmd(shadowlength,0;y,-292))(self);
      end;
      OnCommand=cmd(y,0;sleep,0.3;linear,0.3;y,-292;);
      OffCommand=function(self)
				if IsJoinFrame then
					(cmd(linear,0.1;y,0;sleep,0;diffusealpha,0))(self);
				else
					(cmd(sleep,0.3;linear,0.1;y,0;sleep,0;diffusealpha,0))(self);
				end
			end;
      LoadActor( THEME:GetPathG("","ScreenSelectProfile/BGTOP") )..{
        InitCommand=cmd(valign,1);
      };
      LoadActor( THEME:GetPathG("","ScreenSelectProfile/TOP-LINE") )..{
        InitCommand=function(self)
          self:valign(1):diffuse(PlayerColor(Player));
        end;
      };
      Def.BitmapText{
        Font="_handel gothic itc std Bold 18px";
        InitCommand=function(self)
          self:diffuse(PlayerColor(Player)):zoom(1.3):y(-26)
          if Player == PLAYER_1 then
            self:settext("PLAYER 1")
          else
            self:settext("PLAYER 2")
          end;
        end;
      };
    };
    Def.ActorFrame{
      Name="Bottom";
      InitCommand=function(self)
        (cmd(shadowlength,0))(self);
      end;
      OnCommand=cmd(y,0;sleep,0.3;linear,0.3;y,286;);
      OffCommand=function(self)
				if IsJoinFrame then
					(cmd(linear,0.1;y,0;sleep,0;diffusealpha,0))(self);
				else
					(cmd(sleep,0.3;linear,0.1;y,0;sleep,0;diffusealpha,0))(self);
				end
			end;
      LoadActor( THEME:GetPathG("","ScreenSelectProfile/BGBOTTOM") )..{
        InitCommand=cmd(valign,0);
      };
      LoadActor( THEME:GetPathG("","ScreenSelectProfile/start game") )..{
        InitCommand=cmd(valign,0;diffusealpha,0);
        OnCommand=cmd(sleep,0.8;diffusealpha,1);
      };
    };
	};

	return t
end

function LoadPlayerStuff(Player)

	local t = {};
	local pn = (Player == PLAYER_1) and 1 or 2;


	t[#t+1] = Def.ActorFrame {
		Name = 'JoinFrame';
		LoadCard(Color('Outline'),color('0,0,0,0'),Player,true);

		LoadActor( THEME:GetPathG("ScreenSelectProfile/ScreenSelectProfile","Start") ) .. {
			InitCommand=cmd(zoomy,0;diffuseshift;effectcolor1,Color('White');effectcolor2,color("#A5A6A5"));
			OnCommand=cmd(zoomy,0;zoomx,0;sleep,0.5;linear,0.1;zoomx,1;zoomy,1);
			OffCommand=cmd(linear,0.1;zoomy,0;diffusealpha,0);
		};

	};

	t[#t+1] = Def.ActorFrame {
		Name = 'BigFrame';
		LoadCard(PlayerColor(),color('1,1,1,1'),Player,false);
	};
	t[#t+1] = Def.ActorFrame {
		Name = 'SmallFrame';
		InitCommand=cmd(y,5);
	};
	t[#t+1] = Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=1;

		OnCommand=cmd(draworder,1000;y,5;SetFastCatchup,true;SetMask,0,29;SetSecondsPerItem,0.15);
		TransformFunction=function(self, offset, itemIndex, numItems)
			local focus = scale(math.abs(offset),0,2,1,0);
			self:visible(false);
			self:y(math.floor( offset*20 ));

		end;
	};


	t[#t+1] = Def.ActorFrame {
		Name = "EffectFrame";
	};
	--�U���d��-----------------
	t[#t+1] = LoadFont("_avenirnext lt pro bold 25px") .. {
		Name = 'SelectedProfileText';
    InitCommand=function(self)
      (cmd(xy,5,-14;zoom,0.9;diffuse,color("#b5b5b5");diffusetopedge,color("#e5e5e5");diffusealpha,0;maxwidth,400))(self);
    end;
		OnCommand=cmd(sleep,0.7;linear,0.2;diffusealpha,1);
    OffCommand=function(self)
      self:diffusealpha(0)
    end;
	};

	t[#t+1] = LoadFont("_avenirnext lt pro bold 25px") .. {
		Name = 'selectPlayerUID';
		InitCommand=cmd(zoom,0.9;diffuse,color("#b5b5b5");diffusetopedge,color("#e5e5e5");diffusealpha,0;xy,5,38);
    OnCommand=function(self)
      if IsJoinFrame then
        (cmd(linear,0.3;diffusealpha,0))(self);
      else
        self:sleep(0.7):linear(0.1):diffusealpha(1):zoom(1.1):linear(0.1):zoom(1)
      end
    end;
    OffCommand=function(self)
      self:diffusealpha(0)
    end;
	};
	t[#t+1] = Def.ActorFrame{
		Name = 'SelectTimer';
		InitCommand=function(s)
			s:xy(180,-340)
			if PREFSMAN:GetPreference("MenuTimer") then
				s:zoom(1)
			else
				s:zoom(0)
			end
		end,
		OnCommand=cmd(diffusealpha,0;sleep,0.7;linear,0.2;diffusealpha,1);
		OffCommand=cmd(linear,0.2;diffusealpha,0;);
		LoadActor(THEME:GetPathG("","MenuTimer frame"))..{ InitCommand=function(s) s:xy(11,25) end,};
		Def.BitmapText{
			Font="MenuTimer numbers";
			OnCommand=function(s) s:xy(-34,0):skewx(-0.1):queuecommand("Update") end,
			UpdateCommand=function(s)
				local MenuT = SCREENMAN:GetTopScreen():GetChild("Timer")
				local time = MenuT:GetSeconds()
				if PREFSMAN:GetPreference("MenuTimer") then
					local digit = math.floor(time/10)
					s:settext(string.format("%01d",digit))
					if time <= 10 then
						s:diffuseshift():effectperiod(1):effectcolor1(Color.White):effectcolor2(Color.Red):sleep(1):queuecommand("Update")
					elseif time <=5 then
						s:diffuseshift():effectperiod(0.2):effectcolor1(Color.White):effectcolor2(Color.Red):sleep(1):queuecommand("Update")
					else
						s:sleep(1):queuecommand("Update")
					end
				end
			end,
		};
		Def.BitmapText{
			Font="MenuTimer numbers";
			OnCommand=function(s) s:xy(32,-7):zoom(0.75):skewx(-0.1):queuecommand("Update") end,
			UpdateCommand=function(s)
				local MenuT = SCREENMAN:GetTopScreen():GetChild("Timer")
				local time = MenuT:GetSeconds()
				if PREFSMAN:GetPreference("MenuTimer") then
					local digit = math.mod(time,10)
					s:settext(string.format("%01d",digit))
					if time <= 10 then
						s:diffuseshift():effectperiod(1):effectcolor1(Color.White):effectcolor2(Color.Red):sleep(1):queuecommand("Update")
					elseif time <=5 then
						s:diffuseshift():effectperiod(0.2):effectcolor1(Color.White):effectcolor2(Color.Red):sleep(1):queuecommand("Update")
					else
						s:sleep(1):queuecommand("Update")
					end
				end
			end,
		};
	};
	return t;
end;

function UpdateInternal3(self, Player)

	local pn = (Player == PLAYER_1) and 1 or 2;
	local frame = self:GetChild(string.format('P%uFrame', pn));
	local scroller = frame:GetChild('Scroller');
	local seltext = frame:GetChild('SelectedProfileText');
	local joinframe = frame:GetChild('JoinFrame');
	local smallframe = frame:GetChild('SmallFrame');
	local bigframe = frame:GetChild('BigFrame');
	local selectPlayerUID = frame:GetChild('selectPlayerUID');
	local SelectTimer = frame:GetChild('SelectTimer');
	--MyGrooveRadar
	local selPlayerUID;

	local PcntLarger;
	--local selMostCoursePlayed = frame:GetChild('selectedMostCoursePlayed');
	if GAMESTATE:IsHumanPlayer(Player) then
		frame:visible(true);
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player);
			local set_ind;
			local key_ind;
			if Player == PLAYER_1 then
				set_ind = {PLAYER_1,PLAYER_2};
				key_ind = {keyset[1],keyset[2]};
			else
				set_ind = {PLAYER_2,PLAYER_1};
				key_ind = {keyset[2],keyset[1]};
			end;
			if SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[1]) == SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[2]) then
				if key_ind[1] == 1 and key_ind[2] < 1 then
					if SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[1]) == profnum then
						SCREENMAN:GetTopScreen():SetProfileIndex(set_ind[2], SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[2])-1 );
					else SCREENMAN:GetTopScreen():SetProfileIndex(set_ind[2], SCREENMAN:GetTopScreen():GetProfileIndex(set_ind[2])+1 );
					end
				end
			end
			if keyset[pn] < 1 then
				--using profile if any
				joinframe:visible(false);
				smallframe:visible(true);
				bigframe:visible(false);
				seltext:visible(true);
				scroller:visible(true);
				SelectTimer:visible(true)
				selectPlayerUID:visible(true);
			else
				joinframe:visible(false);
				smallframe:visible(true);
				bigframe:visible(false);
				seltext:visible(true);
				scroller:visible(true);
				SelectTimer:visible(true)
				selectPlayerUID:visible(true);
				frame:queuecommand("Off")
			end

			if ind > 0 then
				local profile = PROFILEMAN:GetLocalProfileFromIndex(ind-1);

				bigframe:visible(true);
				SelectTimer:visible(true)
				if profnum > 0 then
					scroller:SetDestinationItem(ind-1);
				else
					scroller:SetDestinationItem(ind);
				end
				seltext:settext(ProfileInfoCache[ind].DisplayName);

				selPlayerUID = PROFILEMAN:GetLocalProfileFromIndex(ind-1):GetGUID();
				selectPlayerUID:settext(string.upper(string.sub(selPlayerUID,1,4).."-"..string.sub(selPlayerUID,5,8)));

				local profileID = PROFILEMAN:GetLocalProfileIDFromIndex(ind-1)
				local prefs = ProfilePrefs.Read(profileID)
				if SN3Debug then
					ProfilePrefs.Save(profileID)
				end

			else
				if SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				else
					joinframe:visible(false);
					smallframe:visible(true);
					bigframe:visible(true);
					scroller:visible(false);
					SelectTimer:visible(false)
					seltext:settext('No profile');
					selectPlayerUID:settext('------------');
				end;
			end;
		else
			--using card
			if keyset[pn] < 1 then
				--using profile if any
				joinframe:visible(false);
				smallframe:visible(true);
				bigframe:visible(true);
				seltext:visible(true);
				scroller:visible(false);
				SelectTimer:visible(true)
			else
				joinframe:visible(false);
				smallframe:visible(true);
				bigframe:visible(true);
				seltext:visible(true);
				scroller:visible(true);
				SelectTimer:visible(true)
				selectPlayerUID:visible(true);
				frame:queuecommand("Off")
			end
			local text;
			if MEMCARDMAN:GetName(Player) ~= "" then
				text = MEMCARDMAN:GetName(Player)
			else
				text = "No Name"
			end
			seltext:settext(text);
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0);
		end;
	else
		joinframe:visible(true);
		scroller:visible(false);
		seltext:visible(false);
		selectPlayerUID:visible(false);
		smallframe:visible(false);
		bigframe:visible(false);
		SelectTimer:visible(false)
	end;
end;

local screen = Var("LoadingScreen")

--�D�{��
local t = Def.ActorFrame {

	StorageDevicesChangedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	CodeMessageCommand = function(self, params)
		if params.Name == 'Start' or params.Name == 'Center' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				if GAMESTATE:GetNumPlayersEnabled() > 1 then
					if params.PlayerNumber == 'PlayerNumber_P1' then
						keyset[1] = 1
						self:queuecommand('UpdateInternal2');
					else
						keyset[2] = 1
						self:queuecommand('UpdateInternal2');
					end
				end
				MESSAGEMAN:Broadcast("StartButton");
				if GAMESTATE:GetNumPlayersEnabled() == 1 then
					self:queuecommand('UpdateInternal4')
					MESSAGEMAN:Broadcast("StartButton");
				else
					if keyset[1] == 1 and keyset[2] == 1 then
						self:queuecommand('UpdateInternal4')
						MESSAGEMAN:Broadcast("StartButton");
					end
				end
			else
				if GAMESTATE:EnoughCreditsToJoin() then
					if GAMESTATE:GetCoinMode() == "CoinMode_Pay" then
						GAMESTATE:InsertCoin(-1)
					end
					SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -1);
					MESSAGEMAN:Broadcast("StartButton");
				end
			end;
		end;
		if params.Name == 'Up' or params.Name == 'Up2' or params.Name == 'DownLeft' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
				if ind > 1 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind - 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton");
						self:queuecommand('UpdateInternal2');
					end;
				end;
			end;
		end;
		if params.Name == 'Down' or params.Name == 'Down2' or params.Name == 'DownRight' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
				if ind > 0 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind + 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton");
						self:queuecommand('UpdateInternal2');
					end;
				end;
			end;
		end;
		if params.Name == 'Back' then
			if GAMESTATE:GetNumPlayersEnabled()==0 then
				SCREENMAN:GetTopScreen():Cancel();
			else
				MESSAGEMAN:Broadcast("BackButton");
				SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -2);
			end;
		end;
	end;

	PlayerJoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	PlayerUnjoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	OnCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1);
		UpdateInternal3(self, PLAYER_2);
	end;

	UpdateInternal4Command=function(self)
		if PROFILEMAN:GetNumLocalProfiles() >= 1 then
			SCREENMAN:GetTopScreen():Finish();
		else
			SCREENMAN:GetTopScreen():StartTransitioningScreen('SM_GoToNextScreen')
		end
	end;

	children = {
		Def.ActorFrame {
			Name = 'P1Frame';
			InitCommand=cmd(x,SCREEN_CENTER_X-402;y,SCREEN_CENTER_Y-2);
      OnCommand=cmd(zoomx,0;linear,0.2;zoomx,1);
			OffCommand=cmd();
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_1 then
					(cmd(zoomx,1;zoomy,0.15;linear,0.175;zoomy,1;))(self);
				end;
			end;
			children = LoadPlayerStuff(PLAYER_1);
		};
		Def.ActorFrame {
			Name = 'P2Frame';
			InitCommand=cmd(x,SCREEN_CENTER_X+406;y,SCREEN_CENTER_Y-2);
      OnCommand=cmd(zoomx,0;linear,0.2;zoomx,1);
			OffCommand=cmd();
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_2 then
					(cmd(zoomx,1;zoomy,0.15;linear,0.175;zoomy,1;))(self);
				end;
			end;
			children = LoadPlayerStuff(PLAYER_2);
		};
		-- sounds
		Def.Actor{
			StartButtonMessageCommand=function(s)
				SOUND:PlayOnce(THEME:GetPathS("Common","start"))
				SOUND:PlayOnce(THEME:GetPathS("","Profile_start"))
			end,
		};
		LoadActor( THEME:GetPathS("Common","cancel") )..{
			BackButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("","Profile_Move") )..{
			DirectionButtonMessageCommand=cmd(play);
		};
		LoadActor(THEME:GetPathG(screen, "Header")) .. {
  			Name = "Header",
		};
		Def.Actor{
			OffCommand=function(s)
				SOUND:DimMusic(0.5,math.huge)
			end,
		}
	};
};


return t;
