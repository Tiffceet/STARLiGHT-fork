local group;
local getOn = 0;

local jk = LoadModule "Jacket.lua"

return Def.ActorFrame{
	SetCommand=function(self,params)
		local song = params.Text
		local index = params.DrawIndex
		if song then
			if getOn == 0 then
				if index then
				if index == 4 then
					self:finishtweening():zoom(0):sleep(0.3):decelerate(0.4):zoom(1)
				elseif index < 4 then
					self:finishtweening():addx(-SCREEN_WIDTH):sleep(0.3):decelerate(0.4):addx(SCREEN_WIDTH)
				elseif index > 4 then
					self:finishtweening():addx(SCREEN_WIDTH):sleep(0.3):decelerate(0.4):addx(-SCREEN_WIDTH)
				end;
			end;
			end;
		end;
		self:queuecommand("SetOn");
	end;
	SetOnCommand=function(self)
		getOn = 1;
	end;
	Def.Sprite {
		SetMessageCommand=function(self,params)
			self:Load(jk.GetGroupGraphicPath(params.Text,"Jacket",GAMESTATE:GetSortOrder()))
			self:setsize(230,230)
		end;
	};
	LoadActor(THEME:GetPathG("","_jackets/glow.png"))..{
		InitCommand=function(s) s:visible(false) end,
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
		InitCommand=function(s) s:diffusealpha(0.9):y(-107):strokecolor(color("0,0,0,0.5")) end,
		SetMessageCommand=function(self,params)
			local group = params.Text;
			local so = GAMESTATE:GetSortOrder();
			if group then
				if so == "SortOrder_Group" then
					self:settext(THEME:GetString("MusicWheel","GROUPTop"))
				else
					self:settext("")
				end;
			else
				self:settext("")
			end;
		end;
	};
	LoadFont("_avenirnext lt pro bold 10px")..{
		InitCommand=function(s) s:diffusealpha(0.9):y(107) end,
		SetMessageCommand=function(self,params)
			local group = params.Text;
			local so = GAMESTATE:GetSortOrder();
			if group then
				if so == "SortOrder_Group" then
					self:settext(THEME:GetString("MusicWheel","GROUPBot"))
				else
					self:settext("")
				end;
			else
				self:settext("")
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
				self:settext("")
			end;
		end;
	};
};
