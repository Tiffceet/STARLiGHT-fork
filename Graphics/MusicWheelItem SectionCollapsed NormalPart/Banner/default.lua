local t = Def.ActorFrame{};
local jk = LoadModule "Jacket.lua"

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,-120);
	Def.Sprite {
		SetMessageCommand=function(self,params)
			self:Load(jk.GetGroupGraphicPath(params.Text,"Jacket",GAMESTATE:GetSortOrder()))
			self:setsize(120,120)
		end;
	};
	LoadFont("_avenirnext lt pro bold 20px")..{
		InitCommand=function(s) s:y(-20):diffusealpha(1):maxwidth(100):diffusebottomedge(color("#d8d8d8")):diffusetopedge(color("#8c8c8c")):strokecolor(Color.Black) end,
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

local factorsx = {-538, -350, -175, 0, 175, 350, 538};
local factorsy = {-538, -536, -536, -536, -536, -536, -538};
local zoom = {0.78, 0.76, 0.75, 0.75 ,0.75 ,0.76 ,0.78}
local sizes = {186, 182, 180, 180, 180, 182, 186};
local indexes = {18, 19, 20, 21, 22, 23, 24};

for i = 1,7 do
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(rotationx,75);
		Def.Quad{
			InitCommand=cmd(xy,factorsx[i],-460;;diffuse,color("1,1,1,0.5"));
			SetMessageCommand=function(self,params)
				local index = params.DrawIndex
				if index then
					if index == indexes[i] then
						self:setsize(sizes[i]+3,sizes[i]+3)
						self:visible(true)
					else
						self:visible(false)
					end;
				end;
			end;
		};
		Def.Sprite {
			InitCommand=cmd(xy,factorsx[i],-460);
			SetMessageCommand=function(self,params)
				local index = params.DrawIndex
				if index then
					if index == indexes[i] then
						self:visible(true)
						self:Load(jk.GetGroupGraphicPath(params.Text,"Jacket",GAMESTATE:GetSortOrder()))
						self:setsize(sizes[i],sizes[i])
					else
						self:visible(false)
					end
				end
			end;
		};
		LoadFont("_avenirnext lt pro bold 42px")..{
			InitCommand=function(s) s:xy(factorsx[i],-480)
				s:diffusealpha(1):maxwidth(180):diffusebottomedge(color("#d8d8d8")):diffusetopedge(color("#8c8c8c")):strokecolor(Color.Black) end,
			SetMessageCommand=function(self,params)
				local group = params.Text;
				local so = GAMESTATE:GetSortOrder();
				local index = params.DrawIndex
				if index then
					if index == indexes[i] then
						if group then
							if so == "SortOrder_Genre" then
								self:settext(group)
							else
								self:settext("")
							end;
						else
							self:settext("")
						end;
					else
						self:settext("")
					end
				end
			end;
		};
	};
end;

return t;
