local t = Def.ActorFrame{
	Def.Actor{ OnCommand=function(s) s:sleep(4) end, };
};

t[#t+1] = LoadActor(("../cheer"))..{
	StartTransitioningCommand=function(s) s:sleep(3):queuecommand("Play") end,
	PlayCommand=function(s)
		if GAMESTATE:GetCurrentSong():GetDisplayMainTitle() == "Tohoku EVOLVED" or GAMESTATE:GetCurrentSong():GetDisplayMainTitle() == "COVID" then
			return
		else
			s:play()
		end
	end,
};
t[#t+1] = LoadActor(("../swoosh.ogg"))..{
	StartTransitioningCommand=function(s) s:sleep(3):queuecommand("Play") end,
	PlayCommand=function(s) s:play() end,
};

t[#t+1] = Def.ActorFrame {
	LoadActor(THEME:GetPathB("","ScreenWithMenuElements background/background"))..{
		InitCommand=function(s) s:FullScreen() end,
		OnCommand=function(s) s:diffusealpha(0):sleep(3):linear(0.2):diffusealpha(1) end,
	};
	-- Failed
	LoadActor("doors")..{
		InitCommand=function(s) s:diffusealpha(0) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(3.2):diffusealpha(1):queuecommand("AnOn"):sleep(4):queuecommand("AnOff"):sleep(2) end,
	};
	Def.Sprite{
		Texture="cleared",
		InitCommand=function(s) 
			s:Center()
			if not GAMESTATE:IsCourseMode() then
				if GAMESTATE:GetCurrentSong():GetDisplayMainTitle() == "Tohoku EVOLVED" or GAMESTATE:GetCurrentSong():GetDisplayMainTitle() == "COVID" then 
					s:Load(THEME:GetPathB("ScreenGameplay","out/normal/PRAY FOR ALL"))
				end
			end
		end,
		OnCommand=function(s) s:diffusealpha(0):zoomy(0):zoomx(4):sleep(3):linear(0.198):diffusealpha(1):zoomy(1):zoomx(1):sleep(2.604):linear(0.132):zoomy(0):zoomx(4):diffusealpha(0) end,
	};
};

return t
