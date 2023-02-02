local t = Def.ActorFrame{
	OnCommand=function(s)
		SCREENMAN:GetTopScreen():RemoveInputCallback(DDRInput(self))
		SCREENMAN:set_input_redirected(PLAYER_1, false)
		SCREENMAN:set_input_redirected(PLAYER_2, false)
	end
};

if GAMESTATE:IsHumanPlayer(PLAYER_1) then
	t[#t+1] = LoadActor("DiffScroller.lua",PLAYER_1);
end;

if GAMESTATE:IsHumanPlayer(PLAYER_2) then
	t[#t+1] = LoadActor("DiffScroller.lua",PLAYER_2);
end;

return t;