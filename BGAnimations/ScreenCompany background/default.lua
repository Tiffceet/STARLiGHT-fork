return Def.ActorFrame{
	StorageDevicesChangedMessageCommand=function(self, params)
		MemCardInsert()
	end;
	Def.Quad {
		InitCommand = function(s) s:FullScreen() end,
		OnCommand = function(s) s:sleep(1.7):decelerate(1):diffuse(Color.Black) end,
	},
	LoadActor("konami") .. {
		InitCommand = function(s) s:Center():diffusealpha(0):addy(30):rotationy(-90) end,
		OnCommand = function(s) s:decelerate(0.5):addy(-30):rotationy(0):diffusealpha(1):sleep(1.2):decelerate(1):diffusealpha(0):addy(-30):rotationy(90) end,
	},
	LoadActor("silverdragon designs") .. {
		InitCommand = function(s) s:Center():addy(30):diffusealpha(0):rotationy(-90) end,
		OnCommand = function(s) s:sleep(1.7):decelerate(1):diffusealpha(1):addy(-30):rotationy(0):sleep(1):linear(0.5):diffusealpha(0) end,
	},
}

