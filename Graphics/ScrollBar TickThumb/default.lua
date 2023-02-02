local t = Def.ActorFrame{

	LoadActor("TickThumb")..{
		OnCommand=cmd(x,5;zoomy,0;linear,0.3;zoomy,1;queuecommand,"Repeat";);
		RepeatCommand=cmd(glowshift;effectclock,'beatnooffset';effectcolor1,color("1,1,1,0");effectcolor2,color("1,1,1,1"););
		OffCommand=cmd(stoptweening;linear,0.3;zoomy,0;);
	};
};

return t;