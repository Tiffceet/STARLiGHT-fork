local t = Def.ActorFrame {};
local gc = Var("GameCommand");
local max_stages = PREFSMAN:GetPreference( "SongsPerPlay" );
--------------------------------------
t[#t+1] = Def.ActorFrame {
	InitCommand=cmd(zoom,1;xy,SCREEN_CENTER_X+332,SCREEN_CENTER_Y+12);
  LoadActor( gc:GetName()..".png" )..{
		GainFocusCommand=function(self)
			self:diffusealpha(0):zoomy(0):smooth(0.2):zoomy(1):diffusealpha(1)
		end;
		OnCommand=function(self)
			if GAMESTATE:GetNumPlayersEnabled() > 1 and gc:GetName() == "Versus" then
				self:diffusealpha(0):zoomy(0):smooth(0.2):zoomy(1):diffusealpha(1)
			elseif gc:GetName() == "Single" and GAMESTATE:GetNumPlayersEnabled() == 1 then
				self:diffusealpha(0):zoomy(0):smooth(0.2):zoomy(1):diffusealpha(1)
			else
				self:diffusealpha(0):zoomy(0):smooth(0.2)
			end;
		end;
		LoseFocusCommand=function(s) s:smooth(0.1):zoomy(0):diffusealpha(0) end,
		OffCommand=function(s) s:smooth(0.2):addy(300):diffusealpha(0) end,
	};
};

return t;
