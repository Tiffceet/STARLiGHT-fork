local t = LoadFallbackB()
local t = Def.ActorFrame{};

t[#t+1] = Def.ActorFrame{
	InitCommand = function(s) s:draworder(100):xy(_screen.cx,SCREEN_TOP+68) end,
	OnCommand = function(s) s:addy(-140):decelerate(0.18):addy(140) end,
	OffCommand = function(s) s:linear(0.15):addy(-140) end,
	LoadActor(THEME:GetPathG("","ScreenWithMenuElements Header/header/default.lua")) .. {
		InitCommand = function(s) s:valign(0) end,
	};
	LoadActor(THEME:GetPathG("","ScreenWithMenuElements Header/text/mainmenu")) .. {
		InitCommand = function(s) s:y(10):diffusealpha(0) end, 
		OnCommand=function(s) s:diffusealpha(0):sleep(0.25):linear(0.05):diffusealpha(0.5):linear(0.05):diffusealpha(0):linear(0.05):diffusealpha(1):linear(0.05):diffusealpha(0):linear(0.05):diffusealpha(0.5):decelerate(0.1):diffusealpha(1) end,
		OffCommand = function(s) s:linear(0.05):diffusealpha(0) end,
	};
};

t[#t+1] = Def.ActorFrame{
	InitCommand = function(s) s:draworder(100):xy(_screen.cx,SCREEN_BOTTOM-68) end,
	OnCommand = function(s) s:addy(140):decelerate(0.18):addy(-140) end,
	OffCommand = function(s) s:linear(0.15):addy(140) end,
	LoadActor(THEME:GetPathG("","ScreenWithMenuElements footer/base"));
	LoadActor(THEME:GetPathG("","ScreenWithMenuElements footer/side glow")) .. {
		OnCommand=function(s) s:cropleft(0.5):cropright(0.5):sleep(0.3):decelerate(0.4):cropleft(0):cropright(0) end,
	};
	LoadActor(THEME:GetPathG("","ScreenWithMenuElements footer/text/welcome")) .. {
		InitCommand = function(s) s:y(26):diffusealpha(0) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.25):linear(0.05):diffusealpha(0.5):linear(0.05):diffusealpha(0):linear(0.05):diffusealpha(1):linear(0.05):diffusealpha(0):linear(0.05):diffusealpha(0.5):decelerate(0.1):diffusealpha(1) end,
		OffCommand = function(s) s:linear(0.05):diffusealpha(0) end,
	};
};

if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then
--XXX: it's easier to have it up here

local heardBefore = false

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:zoom(1);
	end;
	LoadActor(THEME:GetPathS("","Title_In"))..{
		OnCommand=function(s) s:play() end,
	};
	Def.Quad{
		InitCommand=function(s) s:FullScreen():diffuse(color("0,0,0,0.5")) end,
	};
	Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx-435,_screen.cy-10) end,
		OnCommand=function(s) s:addx(-SCREEN_WIDTH):sleep(0.2):decelerate(0.2):addx(SCREEN_WIDTH) end,
		OffCommand=function(s) s:linear(0.2):addx(-SCREEN_WIDTH) end,
		LoadActor("windowmid")..{
			TitleSelectionMessageCommand=function(self, params)
				self:finishtweening()
				if heardBefore then
					self:accelerate(0.1);
				else heardBefore = true end
				self:croptop(0.5):cropbottom(0.5)
				self:sleep(0.1)
				self:accelerate(0.2)
				self:croptop(0):cropbottom(0)
			end;
		};
		Def.Sprite{
			Name="ImageLoader";
			TitleSelectionMessageCommand=function(self, params)
				choice = string.lower(params.Choice)
				self:finishtweening()
				if heardBefore then
					self:accelerate(0.1);
				else heardBefore = true end
				self:croptop(0.5):cropbottom(0.5):queuecommand("TitleSelectionPart2")
			end;
			TitleSelectionPart2Command=function(self, params)
				self:Load(THEME:GetPathG("","_TitleImages/"..choice))
				self:sleep(0.1)
				self:accelerate(0.2);
				self:croptop(0):cropbottom(0)
			end;
			OffCommand=function(s) s:accelerate(.4):croptop(0.5):cropbottom(0.5) end,
		};
		LoadActor("windowtop")..{
			InitCommand=function(s) s:y(-172):valign(1) end,
			TitleSelectionMessageCommand=function(self, params)
				self:finishtweening()
				if heardBefore then
					self:accelerate(0.1);
				else heardBefore = true end
				self:y(0)
				self:sleep(0.1)
				self:accelerate(0.2)
				self:y(-172)
			end;
		};
		LoadActor("windowbottom")..{
			InitCommand=function(s) s:y(172):valign(0); end,
			TitleSelectionMessageCommand=function(self, params)
				self:finishtweening()
				if heardBefore then
					self:accelerate(0.1);
				else heardBefore = true end
				self:y(0)
				self:sleep(0.1)
				self:accelerate(0.2)
				self:y(172)
			end;
		};
	};
	Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx,_screen.cy+276) end,
		OnCommand=function(s) s:zoomy(0):sleep(0.1):accelerate(0.3):zoomy(1) end,
		OffCommand=function(s) s:linear(0.2):zoomy(0) end,
		LoadActor("exp");
		Def.BitmapText{
			Font="_avenirnext lt pro bold 36px";
			Text="";
			InitCommand=function(self) self:hibernate(0.4):zoom(0.75):maxwidth(570):wrapwidthpixels(570):vertspacing(2) end;
			TitleSelectionMessageCommand=function(self, params) self:settext(THEME:GetString("ScreenTitleMenu","Description"..params.Choice)) end;
			OnCommand=function(s) s:cropbottom(1):sleep(0.1):accelerate(0.3):cropbottom(0) end,
		};
	}
};
end

return t
