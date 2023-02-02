local t = Def.ActorFrame {}
t[#t+1] = LoadActor("../everyone.dance.lua")
t[#t+1] = Def.Actor{
	BeginCommand=function(s)
		if GAMESTATE:IsAnExtraStage() then
			local song = SONGMAN:FindSong("Next Generation")
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			if song then
				mw:SelectSong(song)
				mw:Move(1)
				mw:Move(-1)
				mw:Move(0)
        	end
   		end
	end,
	OffCommand=function(s)
		local song = GAMESTATE:GetCurrentSong()
		local gettitle = song:GetDisplayMainTitle()
		if gettitle == "BroGamer" then
			if PROFILEMAN:IsPersistentProfile(PLAYER_1) or PROFILEMAN:IsPersistentProfile(PLAYER_2) then
				if PROFILEMAN:GetSongNumTimesPlayed(song, 'ProfileSlot_Player1') >= 1 or PROFILEMAN:GetSongNumTimesPlayed(song, 'ProfileSlot_Player2') >=10 then
					s:sleep(0.5):queuecommand("Bruh")
				end
			end
		end
	end,
	BruhCommand=function(s)
		SOUND:PlayOnce(THEME:GetPathB("ScreenSelectMusic","overlay/bruh.ogg"))
	end,

}

t[#t+1] = LoadActor("InputHandler.lua");

t[#t+1] = Def.ActorFrame {
	LoadActor(THEME:GetPathS("","Music_In"))..{
		OnCommand=cmd(play);
	};
};

if not GAMESTATE:IsCourseMode() then
if ThemePrefs.Get("WheelType") == "CoverFlow" then
		t[#t+1] = LoadActor("2014Deco");
	elseif ThemePrefs.Get("WheelType") == "A" then
		t[#t+1] = LoadActor("ADeco");
elseif ThemePrefs.Get("WheelType") == "Jukebox" then
	t[#t+1] = LoadActor("JukeboxDeco");
elseif ThemePrefs.Get("WheelType") == "Wheel" then
	t[#t+1] = LoadActor("WheelDeco");
elseif ThemePrefs.Get("WheelType") == "Banner" then
	t[#t+1] = LoadActor("BannerDeco");
end;
end;
--[[function play_sample_music(self)
    if GAMESTATE:IsCourseMode() then return end
    local song = GAMESTATE:GetCurrentSong()

    if song then
        local songpath = song:GetMusicPath()
        local sample_start = song:GetSampleStart()
        local sample_len = song:GetSampleLength()

        if songpath and sample_start and sample_len then
          SOUND:PlayMusicPart(songpath, sample_start,sample_len, 1, 1.5, true, true)
        else
            SOUND:PlayMusicPart("", 0, 0)
        end
    end
end


--Music Preview
t[#t+1] = Def.Actor{
	CurrentSongChangedMessageCommand=function(self)
		self:queuecommand("PlayMusicPreview")
	end;
	PlayMusicPreviewCommand=function(subself) play_sample_music() end,
	PlayerJoinedMessageCommand=function(self,param)
		SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectMusic"):StartTransitioningScreen("SM_GoToNextScreen")
  	end;

}]]
t[#t+1] = StandardDecorationFromFile( "Balloon", "Balloon" );

return t

