local t = Def.ActorFrame{};


t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,-120);
	LoadActor(THEME:GetPathG("","_jackets/COURSE.png")) .. {
	Name="SongCD";
	InitCommand=function(self)
    self:setsize(120,120)
	end;
	};
};
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(rotationx,75);
	LoadActor(THEME:GetPathG("","_jackets/COURSE.png")) .. {
		Name="-3 Banner";
		BeginCommand=cmd();
		InitCommand=cmd(xy,-538,-458);
    SetMessageCommand=function(self,params)
  		local group = params.Text;
			local index = params.DrawIndex
			if index then
				if index == 18 then
          self:setsize(186,186)
					self:visible(true)
				else
					self:visible(false)
				end;
			end;
		end;
	};
	LoadActor(THEME:GetPathG("","_jackets/COURSE.png")) .. {
		Name="-2 Banner";
		BeginCommand=cmd();
		InitCommand=cmd(xy,-350,-460);
    SetMessageCommand=function(self,params)
  		local group = params.Text;
			local index = params.DrawIndex
			if index then
				if index == 19 then
          self:setsize(184,184)
					self:visible(true)
				else
					self:visible(false)
				end;
			end;
		end;
	};
	LoadActor(THEME:GetPathG("","_jackets/COURSE.png")) .. {
		Name="-1 Banner";
		BeginCommand=cmd();
		InitCommand=cmd(xy,-175,-461);
    SetMessageCommand=function(self,params)
  		local group = params.Text;
			local index = params.DrawIndex
			if index then
				if index == 20 then
          self:setsize(182,182)
					self:visible(true)
				else
					self:visible(false)
				end;
			end;
		end;
	};
	LoadActor(THEME:GetPathG("","_jackets/COURSE.png")) .. {
		Name="CenterBanner";
		BeginCommand=cmd();
		InitCommand=cmd(xy,1,-460);
    SetMessageCommand=function(self,params)
  		local group = params.Text;
			local index = params.DrawIndex
			if index then
				if index == 21 then
          self:setsize(186,186)
					self:visible(true)
				else
					self:visible(false)
				end;
			end;
		end;
	};
  LoadActor(THEME:GetPathG("","_jackets/COURSE.png")) .. {
		Name="+1 Banner";
		InitCommand=cmd(xy,175,-461);
    SetMessageCommand=function(self,params)
  		local group = params.Text;
			local index = params.DrawIndex
			if index then
				if index == 22 then
          self:setsize(186,186)
					self:visible(true)
				else
					self:visible(false)
				end;
			end;
		end;
	};
  LoadActor(THEME:GetPathG("","_jackets/COURSE.png")) .. {
		Name="+2 Banner";
		InitCommand=cmd(xy,350,-460);
    SetMessageCommand=function(self,params)
  		local group = params.Text;
			local index = params.DrawIndex
			if index then
				if index == 23 then
          self:setsize(182,182)
					self:visible(true)
				else
					self:visible(false)
				end;
			end;
		end;
	};
	LoadActor(THEME:GetPathG("","_jackets/COURSE.png")) .. {
		Name="+3 Banner";
		InitCommand=cmd(xy,538,-458);
    SetMessageCommand=function(self,params)
  		local group = params.Text;
			local index = params.DrawIndex
			if index then
				if index == 24 then
          self:setsize(186,186)
					self:visible(true)
				else
					self:visible(false)
				end;
			end;
		end;
	};
};

return t;
