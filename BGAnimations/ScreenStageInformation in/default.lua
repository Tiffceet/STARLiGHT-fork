local playMode = GAMESTATE:GetPlayMode()
if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
	curStage = playMode;
end;
local sStage = GAMESTATE:GetCurrentStage();
local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
};

local jk = LoadModule"Jacket.lua"

if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
else
	sStage = sStage;
end;

local t = Def.ActorFrame {
	--LoadActor("BranchHandler.lua");
	LoadActor("../ScreenWithMenuElements background")..{
		OffCommand=function(s) s:finishtweening() end,
	},
	Def.Quad{
		InitCommand=function(s)
			if GAMESTATE:IsAnExtraStage() then
		  		s:FullScreen():diffuse(Alpha(Color.Red,0)):blend(Blend.Multiply)
		  		s:linear(0.2)
				  s:diffusealpha(0.8)
			else
				s:diffusealpha(0)
			end
		end,
	},
	LoadActor("doors/default.lua")..{
		OnCommand=cmd(playcommand,"AnOn");
	};
};
t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:y(SCREEN_CENTER_Y);
	end;
	-- Door sound
	LoadActor(THEME:GetPathS( "", "_Door" ) ) .. {
		StartTransitioningCommand=function(self)
			self:play();
		end;
	};
	LoadActor(THEME:GetPathS( "", "_Cheer" ) ) .. {
		StartTransitioningCommand=function(self)
			self:sleep(0.5):playcommand("Play")
		end;
		PlayCommand=cmd(play);
	};
};
--song jacket--
t[#t+1] = Def.ActorFrame {
	Def.Sprite {
		OnCommand=cmd(playcommand,'Set';Center;diffusealpha,0;zoom,4;sleep,2.5;linear,0.2;diffusealpha,1;zoom,1;sleep,3;diffusealpha,1);
		SetCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:Load(jk.GetSongGraphicPath(GAMESTATE:GetCurrentCourse()))
			else
				self:Load(jk.GetSongGraphicPath(GAMESTATE:GetCurrentSong()))
			end
			self:setsize(457,457)
		end;
	};
};
t[#t+1] = LoadActor("StageDisplay");

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("record", pn)
	t[#t+1] = Def.Actor{
		OnCommand=function(self)
			if GAMESTATE:GetPlayMode() == "PlayMode_Oni" or GAMESTATE:IsExtraStage() then
				GAMESTATE:ApplyPreferredModifiers(pn,"4 lives,battery,failimmediate")
			elseif GAMESTATE:IsExtraStage2() then
				GAMESTATE:ApplyPreferredModifiers(pn,"1 lives,battery,failimmediate")
			end
		end;
	};
end

return t
