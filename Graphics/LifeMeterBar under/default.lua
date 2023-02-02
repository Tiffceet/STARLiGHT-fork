return LoadActor("back")..{
	InitCommand=function(s)
		if GAMESTATE:IsDemonstration() then
			s:zoomto(680,51)
		else
			s:zoomto(642,42)
		end
		s:x(-12)
	end,
};
