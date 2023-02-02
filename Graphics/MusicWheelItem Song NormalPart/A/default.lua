local SongAttributes = LoadModule "SongAttributes.lua"
centerSongObjectProxy = nil;
local top
local jk = LoadModule "Jacket.lua"

function arrangeXPosition(myself, index)
	if index then
		--[[local xVal = index%3
		myself:x((xVal-1)*250+(math.floor((index+3)/3)-1))]]
		if index%3==0 then
			myself:x(-250)
		elseif index%3==1 then
			myself:x(0)
		elseif index%3==2 then
			myself:x(250)
		end
	end;
end

--technika2/3 style hack ;)
function arrangeYPosition(myself, index)
	if index then
		if index%3==0 then
			myself:y(80);
		elseif index%3==1 then
			myself:y(0);
		elseif index%3==2 then
			myself:y(-80);
		end;
	end;
end

local clearglow = Def.ActorFrame{};
local diffblocks = Def.ActorFrame{};

for pn in EnabledPlayers() do
	clearglow[#clearglow+1] = loadfile(THEME:GetPathG("MusicWheelItem","Song NormalPart/clear.lua"))("A/glow.png",pn)..{
		OnCommand=function(s) s:diffusealpha(0):sleep(0.7):diffusealpha(1) end,
	};
	diffblocks[#diffblocks+1] = loadfile(THEME:GetPathG("MusicWheelItem","Song NormalPart/diff.lua"))("A/diff.png",pn,0.7)..{
		InitCommand=function(s) s:xy(pn==PLAYER_1 and -100 or 100,pn==PLAYER_1 and -60 or 60) end,
	}
end


return Def.ActorFrame{
	OnCommand = function(self)
		top = SCREENMAN:GetTopScreen()
	end;
	SetMessageCommand=function(self,params)
		local index = params.Index
		arrangeXPosition(self,index);
		arrangeYPosition(self,index);
		if index ~= nil then
			self:zoom(params.HasFocus and 1.2 or 1);
			self:name(tostring(params.Index))
		end
	end;
	Def.Sprite{
		Texture="backer",
	},
	Def.Sprite{
		Texture="glow",
		InitCommand=function(s) s:diffusealpha(0.5) end,
	},
	Def.Sprite{
		SetMessageCommand=function(s,p)
			local song = p.Song
			if p.HasFocus then
				centerSongObjectProxy = s;
			end
			if song then
				s:Load(jk.GetSongGraphicPath(song,"Jacket"))
			end
			s:setsize(140,140):xy(2,-1)
		end
	};
	Def.ActorFrame{
		Name="Textbox",
		InitCommand=function(s) s:xy(16,104) end,
		Def.ActorFrame{
			InitCommand=function(s) s:diffusealpha(0.75) end,
			Def.Quad{
				InitCommand=function(s) s:setsize(220,30):diffuse(Color.Black) end,
			},
			Def.Quad{
				InitCommand=function(s) s:setsize(214,24):diffuse(Alpha(Color.White,0.5)):diffusetopedge(color("1,1,1,0")) end,
			},
		};
		Def.BitmapText{
			Font="_avenirnext lt pro bold 20px",
			SetMessageCommand=function(s,p)
				local song = p.Song
				if song then
					s:settext(song:GetDisplayMainTitle()):diffuse(SongAttributes.GetMenuColor(song))
				end
				s:maxwidth(200)
			end,
		}
	};
	Def.ActorFrame{
		Name="Additional Effects",
		SetMessageCommand=function(s,p)
			if p.Index then
				s:visible(p.HasFocus)
			end
		end,
		OffCommand=function(s) s:stopeffect():sleep(0.2):diffusealpha(0) end,
		Def.Sprite{
			Texture="hl.png",
			InitCommand=function(s) s:diffuseramp():effectcolor1(color("1,1,1,0.2"))
				:effectcolor2(color("1,1,1,1")):effectclock('beatnooffset')
			end,
		};
		Def.ActorFrame{
			Name="Cursor",
			InitCommand=function(s) s:diffuseramp():effectcolor1(color("1,1,1,0"))
				:effectcolor2(color("1,1,1,1")):effectclock('beatnooffset')
			end,
			Def.Sprite{
				Texture="cursor",
				InitCommand=function(s) s:thump(1):effectmagnitude(1.1,1,0):effectclock('beatnooffset') end,
			};
		};
		Def.Sprite{
			Texture=THEME:GetPathG("","_shared/arrows/arrowb"),
			InitCommand=function(s) s:x(-140):bounce():effectmagnitude(6,0,0):effectclock('beatnooffset') end,
		};
		Def.Sprite{
			Texture=THEME:GetPathG("","_shared/arrows/arrowb"),
			InitCommand=function(s) s:x(140):rotationy(180):bounce():effectmagnitude(-6,0,0):effectclock('beatnooffset') end,
		};
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
			InitCommand=function(s) s:setsize(140,15):xy(2,70):valign(1):diffuse(Alpha(Color.Black,0.5)) end,
		},
		Def.BitmapText{
			Font="Common normal",
			InitCommand=function(s) s:valign(1):y(68):zoomx(0.7):zoomy(0.6):uppercase(true) end,
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
	};
	clearglow;
	diffblocks;
};