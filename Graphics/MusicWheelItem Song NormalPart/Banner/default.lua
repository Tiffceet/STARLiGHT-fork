local t = Def.ActorFrame{};

local jk = LoadModule "Jacket.lua"

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:y(-120) end,
	LoadActor(THEME:GetPathG("","MusicWheelItem Song NormalPart/Jukebox/cd/cd_mask"))..{
		InitCommand=function(s) s:blend(Blend.NoEffect):zwrite(1):clearzbuffer(true):zoom(0.27) end,
	};
	Def.Banner{
	Name="SongCD";
	SetMessageCommand=function(self,params)
		self:ztest(1)
		local song = params.Song;
		if song then
			local songtit = params.Song:GetDisplayMainTitle();
			if CDImage[songtit] ~= nil then
				local diskImage = CDImage[songtit];
				self:Load(THEME:GetPathG("","MusicWheelItem Song NormalPart/Jukebox/cd/"..diskImage));
			else
			--Fallback to Jacket/BG or just load the fallback cd.
				--Verify Jacket
				if jk.GetSongGraphicPath(song) then
					self:Load(jk.GetSongGraphicPath(song))
				else
					self:Load(THEME:GetPathG("", "MusicWheelItem Song NormalPart/Jukebox/cd/fallback"));
				end;
			end;
			self:setsize(128,128);
		end;
	end;
	};
	Def.ActorFrame{
		Name="CdOver";
		LoadActor(THEME:GetPathG("", "MusicWheelItem Song NormalPart/Jukebox/cd/overlay"))..{
			InitCommand=function(s) s:zoom(0.27) end,
		SetMessageCommand=function(self,params)
			local song = params.Song;
			if song then
				local songtit = params.Song:GetDisplayMainTitle();
				if CDImage[songtit] ~= nil then
					self:visible(false)
				else
					self:visible(true)
				end;
			else
				self:visible(false)
			end;
		end;
		};
	};
};

local factorsx = {-538, -350, -175, 0, 175, 350, 538};
local factorsy = {-538, -536, -536, -536, -536, -536, -538};
local zoom = {0.78, 0.76, 0.75, 0.75 ,0.75 ,0.76 ,0.78}
local sizes = {186, 182, 180, 180, 180, 182, 186};
local indexes = {18, 19, 20, 21, 22, 23, 24};

for i = 1,7 do
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:rotationx(75) end,
		SetMessageCommand=function(s,p)
			local index = p.DrawIndex
			if index then
				if index == indexes[i] then
					s:visible(true)
				else
					s:visible(false)
				end
			end
		end,
		Def.Quad{
			InitCommand=function(s) s:xy(factorsx[i],-460):diffuse(color("1,1,1,0.5")) end,
			SetMessageCommand=function(self,params)
				local index = params.DrawIndex
				if index then
					if index == indexes[i] then
						self:setsize(sizes[i]+3,sizes[i]+3)
					end;
				end;
			end;
		};
		Def.Sprite{
			InitCommand=function(s) s:xy(factorsx[i],-460) end,
			SetMessageCommand=function(self,params)
				local song = params.Song
				local index = params.DrawIndex
				if song then
					if index then
						if index == indexes[i] then
							self:Load(jk.GetSongGraphicPath(song))
							self:setsize(sizes[i],sizes[i])
						end;
					end;
				end;
			end;
		};
		Def.ActorFrame{
			SetMessageCommand=function(self,params)
				local index = params.DrawIndex
				local song = params.Song
				if song and index then
					if song:IsLong() or song:IsMarathon() then
						self:visible(true)
					else
						self:visible(false)
					end
				end
			end,
			Def.Quad{
				InitCommand=function(s) s:xy(factorsx[i],-378) end,
				OnCommand=function(s) s:setsize(sizes[i],15):diffuse(Alpha(Color.Black,0.5)) end,
			},
			Def.BitmapText{
				Font="Common normal",
				InitCommand=function(s) s:xy(factorsx[i],-378):zoomx(0.7):zoomy(0.6):uppercase(true) end,
				SetMessageCommand=function(s,p)
					local song = p.Song
					local text;
					if song then
						if song:IsLong() then
							s:settext("Long")
						elseif song:IsMarathon() then
							s:settext("Marathon")
						else
							s:settext("")
						end
					else
						s:settext("")
					end
				end
			},
		};
	};

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:rotationx(75) end,
		Def.ActorFrame{
			InitCommand=function(s) s:xy(factorsx[i],factorsy[i]):zoom(zoom[i]) end,
			SetMessageCommand=function(s,p)
				local song = p.Song
				local index = p.DrawIndex
				if song and index then
					if index == indexes[i] then
						s:visible(true)
					else
						s:visible(false)
					end
				end
			end;
			LoadActor("../diff.lua","./A/diff.png", pn)..{
				OnCommand=function(s) s:xy(pn==PLAYER_2 and 86 or -86,-6) end,
			};
		};
	};
end

end;

return t;
