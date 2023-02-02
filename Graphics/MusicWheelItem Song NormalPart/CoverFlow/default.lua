centerSongObjectProxy = nil;
local jk = LoadModule"Jacket.lua"

local getOn = 0

local diff = Def.ActorFrame{};
for pn in EnabledPlayers() do
	diff[#diff+1] = Def.ActorFrame{
		LoadActor("../diff.lua", "diff.png", pn)..{
			OnCommand=function(s) s:xy(2,pn==PLAYER_1 and 153 or 190):diffusealpha(0):addy(-100)
				:sleep(0.7):diffusealpha(1):decelerate(0.3):addy(100)
			end,
		};
		LoadActor("../clear.lua", "./CoverFlow/glow.png", pn)..{
			OnCommand=function(s) s:diffusealpha(0):sleep(0.7):diffusealpha(1) end,
		};
	} 
end;

return Def.ActorFrame{
	SetCommand=function(self,params)
		local song = params.Song
		local index = params.DrawIndex
		if getOn == 0 then
			if index then
			if index == 4 then
				self:finishtweening():zoom(0):sleep(0.3):decelerate(0.4):zoom(1)
			elseif index <= 4 then
				self:finishtweening():addx(-SCREEN_WIDTH):sleep(0.3):decelerate(0.4):addx(SCREEN_WIDTH)
			elseif index >= 4 then
				self:finishtweening():addx(SCREEN_WIDTH):sleep(0.3):decelerate(0.4):addx(-SCREEN_WIDTH)
			end;
		end;
		end;
		self:queuecommand("SetOn");
	end;
	SetOnCommand=function(self)
		getOn = 1;
	end;
	diff;
	Def.Quad {
		InitCommand = function(s) s:zoomto(232,232):diffuse(color("1,1,1,0.5")) end,
	};
	Def.Sprite {
		-- Load the banner
		-- XXX Same code can be reused for courses, etc.  Folders too?
		SetMessageCommand = function(self, params)
			local song = params.Song
			if song then
				if params.HasFocus then
					centerSongObjectProxy = self;
				end
				self:Load(jk.GetSongGraphicPath(song))
			end
			self:setsize(230,230)
		end,
	};
	Def.ActorFrame{
		SetCommand=function(s,params)
			local song = params.Song
			if song then
				if song:IsLong() or song:IsMarathon() then
					s:visible(true)
				else
					s:visible(false)
				end
			end
		end,
		Def.Quad{
			InitCommand=function(s) s:setsize(232,20):y(115):valign(1):diffuse(Alpha(Color.Black,0.5)) end,
		},
		Def.BitmapText{
			Font="Common normal",
			InitCommand=function(s) s:valign(1):y(113):zoomy(0.9):uppercase(true) end,
			SetMessageCommand=function(s,p)
				local song = p.Song
				local text;
				if song then
					if song:IsLong() then
						text = "Long"
					elseif song:IsMarathon() then
						text = "Marathon"
					else
						text = ""
					end
				else
					text = ""
				end
				s:settext(text)
			end
		},
	},
};

