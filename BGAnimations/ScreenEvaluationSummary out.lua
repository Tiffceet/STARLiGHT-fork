return Def.ActorFrame{
	Def.Quad{
		InitCommand=function(s) s:FullScreen():diffusealpha(0) end,
		BeginCommand=function(s)
			if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
				s:diffuse(Color.Black)
			else
				s:diffuse(Color.White)
			end
		end,
		OnCommand=function(s)
			s:diffusealpha(0):sleep(0.1):linear(0.2):diffusealpha(1)
		end,
	}
}
