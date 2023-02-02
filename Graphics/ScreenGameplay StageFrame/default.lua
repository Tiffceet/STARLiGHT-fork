local t = Def.ActorFrame{};
local stageframe  = "normal"

if GAMESTATE:IsAnExtraStage() then
    stageframe = "extra"
end

t[#t+1] = LoadActor(stageframe);

return t;
