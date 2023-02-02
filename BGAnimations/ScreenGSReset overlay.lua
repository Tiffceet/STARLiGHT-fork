return Def.ActorFrame{
    BeginCommand=function(s)
        GAMESTATE:Reset()
        if MEMCARDMAN:GetCardState(PLAYER_1) == 'MemoryCardState_ready' then
            GAMESTATE:JoinInput(PLAYER_1)
        elseif MEMCARDMAN:GetCardState(PLAYER_2) == 'MemoryCardState_ready' then
            GAMESTATE:JoinInput(PLAYER_2)
        end
        s:queuecommand("Load")
    end,
    LoadCommand=function() SCREENMAN:GetTopScreen():SetNextScreenName(Branch.StartGame()):StartTransitioningScreen("SM_GoToNextScreen") end;
    Def.Quad{
        InitCommand=function(s) s:FullScreen():diffuse(Color.Black) end,
    },
}