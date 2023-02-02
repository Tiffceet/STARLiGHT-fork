local group;
local jk = LoadModule "Jacket.lua"

local t = Def.ActorFrame{
	Def.Sprite {
		SetMessageCommand=function(self,params)
			group = params.Text;
			local so = GAMESTATE:GetSortOrder();
			if group then
				self:Load(jk.GetGroupGraphicPath(group,"Jacket",so))
			end;
			self:setsize(230,230)
		end;
	};
	LoadActor(THEME:GetPathG("","_jackets/over.png"))..{
		InitCommand=function(s) s:visible(false) end,
		SetMessageCommand=function(self,params)
			local pt_text = params.Text;
			local group = params.Text;
			if group then
				if so == "SortOrder_Group" then
					self:visible(true)
				else
					self:visible(false)
				end
			end;
			self:setsize(230,230)
		end;
	};
	LoadActor(THEME:GetPathG("","_jackets/glow.png"))..{
		InitCommand=function(s) s:visible(false):blend(Blend.Add) end,
		SetMessageCommand=function(self,params)
			local pt_text = params.Text;
			local group = params.Text;
			local so = GAMESTATE:GetSortOrder()
			if group then
				if so == "SortOrder_Group" then
					self:visible(true)
				else
					self:visible(false)
				end
			end;
			self:setsize(230,230)
		end;
	};
	LoadFont("_avenirnext lt pro bold 10px")..{
		InitCommand=cmd(diffusealpha,0.9;y,-107);
		SetMessageCommand=function(self,params)
			local group = params.Text;
			local so = GAMESTATE:GetSortOrder();
			if group then
				if so == "SortOrder_Group" then
					self:settext(THEME:GetString("MusicWheel","GROUPTop"))
				end;
			else
				self:settext()
			end;
		end;
	};
	LoadFont("_avenirnext lt pro bold 10px")..{
		InitCommand=cmd(diffusealpha,0.9;y,107);
		SetMessageCommand=function(self,params)
			local group = params.Text;
			local so = GAMESTATE:GetSortOrder();
			if group then
				if so == "SortOrder_Group" then
					self:settext(THEME:GetString("MusicWheel","GROUPBot"))
				end;
			else
				self:settext()
			end;
		end;
	};
	LoadFont("_avenirnext lt pro bold 46px")..{
		InitCommand=function(s) s:y(-20):diffusealpha(1):maxwidth(200):diffusebottomedge(color("#d8d8d8")):diffusetopedge(color("#8c8c8c")):strokecolor(Color.Black) end,
		SetMessageCommand=function(self,params)
			local group = params.Text;
			local so = GAMESTATE:GetSortOrder();
			if group then
				if so == "SortOrder_Genre" then
					self:settext(group)
				else
					self:settext("")
				end;
			else
				self:settext()
			end;
		end;
	};
};
return t;
