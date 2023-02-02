local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	Def.Quad{
		InitCommand=function(s) s:FullScreen():diffuse(Alpha(Color.Black,0)) end,
		OnCommand=function(s)
			if getenv("FixStage") == 1 then
				s:diffusealpha(1):linear(0.2):diffusealpha(0):sleep(0.55)
			else
				s:diffusealpha(0):sleep(0.75)
			end
		end,
	};
	LoadActor(THEME:GetPathS("","ScreenSelectStyle in.ogg"))..{
		OnCommand=cmd(sleep,0.2;queuecommand,"Play");
		PlayCommand=cmd(play)
	};
};

return t;
