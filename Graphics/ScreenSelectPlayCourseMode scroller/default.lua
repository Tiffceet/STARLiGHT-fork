local gc = Var("GameCommand");
local t = Def.ActorFrame {};
-- Emblem Frame
t[#t+1] = Def.ActorFrame {
	FOV=90;
	InitCommand=cmd(x,0;zoom,1);
	-- Main Emblem
	LoadActor( gc:GetName() ) .. {

	};
};
return t
