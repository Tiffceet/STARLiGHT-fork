return Def.ActorFrame{
	Def.Actor{
		OnCommand=function(s) SOUND:PlayOnce(THEME:GetPathB("","ScreenCaution underlay/sound.ogg")) end,
	};
	LoadActor(THEME:GetPathB("","ScreenGameplay out/normal/doors.lua"))..{
		BeginCommand=function(s)
			if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
				s:visible(false)
			else
				s:visible(true)
			end
		end,
		OnCommand=function(s) 
			if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
			else
				s:queuecommand("AnOn"):sleep(2)
			end
		end,
	};
	LoadActor("frame")..{
		OnCommand=function(s) s:diffusealpha(0):Center():zoomy(0):sleep(0.1):diffusealpha(1):linear(0.066):zoom(1) end,
		OffCommand=function(s) s:linear(0.134):zoomy(0) end,
	};
	LoadActor("text")..{
		OnCommand=function(s) s:diffusealpha(0):Center():zoomy(0):sleep(0.1):diffusealpha(1):linear(0.066):zoom(1):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+40) end,
		OffCommand=function(s) s:linear(0.134):zoomy(0) end,
	};
	LoadActor("flare")..{
		OnCommand=function(s) s:diffusealpha(0):zoomx(1.75):zoomy(0.75):sleep(0.034):diffusealpha(1):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-10):linear(0.066):zoom(1):addy(-4):linear(0.084):y(SCREEN_CENTER_Y-110):queuecommand("Animate") end,
		AnimateCommand=function(s) s:zoomy(1):diffusealpha(.5):linear(1):zoomy(1.53):linear(.5):diffusealpha(0):queuecommand("Animate") end,
		OffCommand=function(s) s:stoptweening():diffusealpha(0) end,
	};
	LoadActor("flare")..{
		OnCommand=function(s) s:diffusealpha(0):zoomx(1.75):zoomy(0.75):sleep(0.034):diffusealpha(1):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+10):linear(0.066):zoom(1):addy(-4):linear(0.084):y(SCREEN_CENTER_Y+180):queuecommand("Animate") end,
		AnimateCommand=function(s) s:zoomy(1):diffusealpha(.5):linear(1):zoomy(1.53):linear(.5):diffusealpha(0):queuecommand("Animate") end,
		OffCommand=function(s) s:stoptweening():diffusealpha(0) end,
	};
	LoadActor("caution")..{
		OnCommand=function(s) s:diffusealpha(0):zoomx(1.75):zoomy(0.75):sleep(0.034):diffusealpha(1):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-8):linear(0.066):zoom(1):addy(-4):linear(0.084):y(SCREEN_CENTER_Y-160) end,
		OffCommand=function(s) s:linear(0.084):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-8):sleep(0.0):linear(0.001):zoomx(1.75):zoomy(0.75):diffusealpha(0) end,
	};
};
