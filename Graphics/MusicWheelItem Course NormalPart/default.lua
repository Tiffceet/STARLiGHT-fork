local getOn = 0;
local getOff = 1;
local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame{
	SetCommand=function(self,params)
		local song = params.Song
		local index = params.DrawIndex
		if getOn == 0 then
			if index then
			if index == 8 then
				self:finishtweening():zoom(0):sleep(0.3):decelerate(0.4):zoom(1)
			elseif index < 8 then
				self:finishtweening():addx(-SCREEN_WIDTH):sleep(0.3):decelerate(0.4):addx(SCREEN_WIDTH)
			elseif index > 8 then
				self:finishtweening():addx(SCREEN_WIDTH):sleep(0.3):decelerate(0.4):addx(-SCREEN_WIDTH)
			end;
		end;
		end;
		self:queuecommand("SetOn");
	end;
	SetOnCommand=function(self)
		getOn = 1;
	end;
	Def.Quad {
		InitCommand = cmd(zoomto,232,232;diffuse,color("1,1,1,0.5"));
	};
--banner
	Def.Banner {
		Name="SongBanner";
		InitCommand=cmd(scaletoclipped,230,230;);
		SetMessageCommand=function(self,params)
			self:LoadFromCourse(params.Course);
		end;
	};
};
return t;
