return Def.ActorFrame{
	StorageDevicesChangedMessageCommand=function(self, params)
		MemCardInsert()
	end;
	LoadActor("image") .. {
		InitCommand = cmd(Center),
	},
	Fade(Color.Black, 0.7, 3, 0.7, Color.White)
}

