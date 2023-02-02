local function CreditsText()
	local text = LoadFont("_avenirnext lt pro bold 20px") .. {
		InitCommand=function(s) s:xy(_screen.cx,SCREEN_BOTTOM-16):zoom(1.3):strokecolor(color("0,0,0,1")):playcommand("Refresh") end,
		RefreshCommand=function(self)
		--Other coin modes
			if GAMESTATE:IsEventMode() then self:settext('') return end
			if GAMESTATE:GetCoinMode()=='CoinMode_Free' then self:settext('FREE PLAY') return end
			if GAMESTATE:GetCoinMode()=='CoinMode_Home' then self:settext('HOME MODE') return end
		--Normal pay
			local coins=GAMESTATE:GetCoins()
			local coinsPerCredit=PREFSMAN:GetPreference('CoinsPerCredit')
			local credits=math.floor(coins/coinsPerCredit)
			local remainder=math.mod(coins,coinsPerCredit)
			local s='CREDIT:'
			if credits > 1 then
				s='CREDITS:'..credits
			elseif credits == 1 then
				s=s..credits
			else
				s=s..0
			end
			self:halign(0.5)
			self:settext(s)
		end;
		UpdateVisibleCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			local bShow = true;
			if screen then
				local sClass = screen:GetName();
				bShow = THEME:GetMetric( sClass, "ShowCreditDisplay" );
			end;

			self:visible( bShow );
		end;
		CoinInsertedMessageCommand=function(s) s:stoptweening():playcommand("Refresh") end,
		RefreshCreditTextMessageCommand=function(s) s:stoptweening():playcommand("Refresh") end,
		PlayerJoinedMessageCommand=function(s) s:stoptweening():playcommand("Refresh") end,
		ScreenChangedMessageCommand=function(s) s:stoptweening():playcommand("Refresh") end,
	};
	return text;
end;

local function PlayerText( pn )
	local text = LoadFont(Var "LoadingScreen","credits") .. {
		InitCommand=function(self)
			self:name("Credits" .. PlayerNumberToString(pn))
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen");
		end;
		UpdateTextCommand=function(s)
			--s:settext(PROFILEMAN:GetProfile(pn):GetDisplayName())
			s:settext("")
		end;
		UpdateVisibleCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			local bShow = true;
			if screen then
				local sClass = screen:GetName();
				bShow = THEME:GetMetric( sClass, "ShowCreditDisplay" );
			end

			self:visible( bShow );
		end
	};
	return text;
end;

local t = Def.ActorFrame {}

t[#t+1] = Def.ActorFrame {
	CreditsText();
	PlayerText( PLAYER_1 );
	PlayerText( PLAYER_2 ); 
};

	-- Text
	t[#t+1] = Def.ActorFrame {
		Def.Quad {
			InitCommand=function(s) s:zoomto(SCREEN_WIDTH,30):align(0,0):y(SCREEN_TOP):diffuse(color("0,0,0,0")) end,
			OnCommand=function(s) s:finishtweening():diffusealpha(0.85) end,
			OffCommand=function(s) s:sleep(3):linear(0.5):diffusealpha(0) end,
		};
		Def.BitmapText{
			Font="_avenirnext lt pro bold 25px";
			Name="Text";
			InitCommand=function(s) s:maxwidth(750):align(0,0):xy(SCREEN_LEFT+10,SCREEN_TOP+10):shadowlength(1):diffusealpha(0) end,
			OnCommand=function(s) s:finishtweening():diffusealpha(1):zoom(0.5) end,
			OffCommand=function(s) s:sleep(3):linear(0.5):diffusealpha(0) end,
		};
		SystemMessageMessageCommand = function(self, params)
			self:GetChild("Text"):settext( params.Message );
			self:playcommand( "On" );
			if params.NoAnimate then
				self:finishtweening();
			end
			self:playcommand( "Off" );
		end;
		HideSystemMessageMessageCommand = function(s) s:finishtweening() end,
	};

return t;
