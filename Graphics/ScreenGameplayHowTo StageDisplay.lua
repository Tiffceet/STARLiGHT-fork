local StageDisplay = Def.ActorFrame{
	BeginCommand=cmd(playcommand,"Set";);
	CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Set";);
};

function MakeBitmapText()
	return LoadFont("_avenirnext lt pro bold 36px") .. {
		InitCommand=cmd(maxwidth,180);
	};
end

StageDisplay[#StageDisplay+1] = MakeBitmapText() .. {
	SetCommand=function(self, params)
		self:settext( "HOW TO PLAY" );
	end;
};

return StageDisplay;
