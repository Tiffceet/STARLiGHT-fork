local pn = ({...})[1] --only argument to file
local short_pn = ToEnumShortString(pn)
local env = GAMESTATE:Env()
local charName = env['SNCharacter'..short_pn] or ""
local style = GAMESTATE:GetCurrentStyle():GetStyleType();

local maskfile =
{
	P1 = THEME:GetPathB("ScreenGameplay", "underlay/Cutin/_Mask_down"),
	P2 = THEME:GetPathB("ScreenGameplay", "underlay/Cutin/_Mask_up")
}
maskfile = maskfile[short_pn]

local versus_y = {
	P1 = -240,
	P2 = 240
}
versus_y = versus_y[short_pn]

local t = Def.ActorFrame{};
if (charName ~= "") then
  local charComboA = Characters.GetAssetPath(charName, "comboA.png")
  local charComboB = Characters.GetAssetPath(charName, "comboB.png")
  local charCombo100 = Characters.GetAssetPath(charName, "combo100.png")
  local charColor = (Characters.GetConfig(charName)).color
  local charVer = (Characters.GetConfig(charName)).version

t[#t+1] = Def.ActorFrame{
  ComboChangedMessageCommand=function(self, params)
    if params.Player ~= pn then return end
    local tapsAndHolds = GAMESTATE:GetCurrentSteps(params.Player):GetRadarValues(params.Player)
    	:GetValue('RadarCategory_TapsAndHolds')
    local CurCombo = params.PlayerStageStats:GetCurrentCombo()
    if CurCombo == 0 or CurCombo == params.OldCombo then
    	return
    elseif CurCombo == math.floor(tapsAndHolds/2)
    	or CurCombo == math.floor(tapsAndHolds*0.9) then
      self:playcommand("Popup", {type='B'})
    elseif CurCombo % 100 == 0 then
      self:playcommand("Popup", {type='C'})
    elseif CurCombo == 20 or (CurCombo % 50 == 0) then
      self:playcommand("Popup", {type='A'})
    end;
  end;

------------------
-- Mask --
  Def.Sprite{
    InitCommand=function(self)
      self:clearzbuffer(true);
      self:zwrite(true);
	  self:blend('BlendMode_NoEffect');
      if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
			  self:Load(maskfile);
			  if PLAYER_2 then
				self:croptop(0.1)
			  end
		  else
			  self:visible(false);
		  end
	   end;
   };
-----------------------------
-- Cutin background --
LoadActor("Back") .. {
  InitCommand=function(self)
    self:setsize(450,1080):setstate(0)
    self:diffusealpha(0)
	self:MaskDest();
	if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
		if pn == PLAYER_2 then
			self:croptop(0.3)
		else
			self:croptop(0)
		end
	end
  end;
	PopupCommand=function(self)
		self:finishtweening():setstate(0)
		self:linear(0.2);
		self:diffusealpha(1);
		self:diffuse(unpack(charColor));
		self:sleep(1);
		self:linear(0.2);
		self:diffusealpha(0);
	end;
};
---------------------------
-- 100 Combos character Sprite
Def.Sprite {
  InitCommand=function(self)
    self:MaskDest();
    self:diffusealpha(0);
    if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
      self:y(versus_y)
    end
    --this forces StepMania to have these all in memory so gameplay doesn't freeze up
    self:Load(charComboA)
    self:Load(charComboB)
    self:Load(charCombo100)
  end;
  PopupCommand=function(self, params)
  	if params.type == 'A' then
  		self:Load(charComboA)
			if charVer <= 2 then
	      self:setsize(450,1080)
	    else
	      self:scaletoclipped(450,1080)
	    end;
  	elseif params.type == 'B' then
  		self:Load(charComboB)
			if charVer <= 2 then
	      self:setsize(450,1080)
	    else
	      self:scaletoclipped(450,1080)
	    end;
  	elseif params.type == 'C' then
  		self:Load(charCombo100)
			if charVer <= 2 then
	      self:setsize(450,1080)
	    else
	      self:scaletoclipped(450,1080)
	    end;
  	else
  		error("Cutin: unknown Popup type "..tostring(type))
  	end
    self:finishtweening();
    if charVer ~= 3 then
    	self:y(44);
	else
  		self:addy(13);
  	end
  	self:sleep(0.1);
  	self:linear(0.1);
  	self:diffusealpha(1);
  	self:linear(1);
  	if charVer ~=3 then
  		self:y(26)
  	else
  		self:addy(-13);
  	end
  	self:linear(0.1);
  	self:diffusealpha(0);
end;
};

-- Light
Def.Quad{
	InitCommand=function(self)
		self:MaskDest()
		self:diffusetopedge(color("#000000"))
		self:diffusebottomedge(unpack(charColor))
		self:diffusealpha(0)
		self:blend('BlendMode_Add')
    self:setsize(450,1080)
		if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
			self:y(versus_y)
		end
	end;
	PopupCommand=function(self)
		self:finishtweening();
		self:sleep(0);
		self:linear(0.2);
		self:diffusealpha(0.5);
		self:sleep(0.8);
		self:linear(0.2);
		self:diffusealpha(0);
	end;
};

Def.ActorFrame {
	InitCommand=function(self)
		self:MaskDest()
	--	self:diffuse(CutInColor())
		if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
			self:y(versus_y)
    end;
	end;
	-- Left 1
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.17);
			self:diffusealpha(1);
			self:x(-191.25);
			self:y(202.5);
			self:zoomx(1.6);
			self:zoomy(4.95);
			self:linear(0.4);
			self:y(-337.5);
			self:diffusealpha(0);
		end;
	};
	-- Right 1
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.17);
			self:diffusealpha(1);
			self:x(60*2.25);
			self:y(155*2.25);
			self:zoomx(0.95*2.25);
			self:zoomy(1.6*2.25);
			self:linear(0.4*2.25);
			self:y(-10*2.25);
			self:diffusealpha(0);
		end;
	};
	-- Center 2 Right
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.33);
			self:diffusealpha(1);
			self:x(10*2.25);
			self:y(150*2.25);
			self:zoomx(0.8*2.25);
			self:zoomy(1.75*2.25);
			self:linear(0.4*2.25);
			self:y(-30*2.25);
			self:diffusealpha(0);
		end;
	};
	-- Center 2 Left
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.33);
			self:diffusealpha(1);
			self:x(-40*2.25);
			self:y(210*2.25);
			self:zoomx(0.8*2.25);
			self:zoomy(1*2.25);
			self:linear(0.4*2.25);
			self:y(110*2.25);
			self:diffusealpha(0);
		end;
	};
	-- Right 3
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.53);
			self:diffusealpha(1);
			self:x(70*2.25);
			self:y(120*2.25);
			self:zoomx(0.6*2.25);
			self:zoomy(2.07*2.25);
			self:linear(0.4);
			self:y(-120*2.25);
			self:diffusealpha(0);
		end;
	};
	-- Left 3 big
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.5);
			self:diffusealpha(1);
			self:x(-75*2.25);
			self:y(-90*2.25);
			self:zoomx(1*2.25);
			self:zoomy(4.45*2.25);
			self:linear(0.4);
			self:y(-320*2.25);
			self:diffusealpha(0);
		end;
	};
	-- Left 4
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.63);
			self:diffusealpha(1);
			self:x(-75*2.25);
			self:y(85*2.25);
			self:zoomx(1.2*2.25);
			self:zoomy(2.2*2.25);
			self:linear(0.4);
			self:y(-150*2.25);
			self:diffusealpha(0);
		end;
	};
	-- Right 4 small
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.63);
			self:diffusealpha(1);
			self:x(40*2.25);
			self:y(185*2.25);
			self:zoomx(0.6*2.25);
			self:zoomy(1.1*2.25);
			self:linear(0.4);
			self:y(85*2.25);
			self:diffusealpha(0);
		end;
	};
	-- Right 5 big
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.86);
			self:diffusealpha(1);
			self:x(70*2.25);
			self:y(20*2.25);
			self:zoomx(0.9*2.25);
			self:zoomy(3*2.25);
			self:linear(0.4);
			self:y(-190*2.25);
			self:diffusealpha(0);
		end;
	};
	-- Left 5
	LoadActor("_Circles")..{
		InitCommand=function(s) s:diffusealpha(0):blend('BlendMode_Add'):vertalign(top) end,
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.86);
			self:diffusealpha(1);
			self:x(-30*2.25);
			self:y(150*2.25);
			self:zoomx(0.6*2.25);
			self:zoomy(1.7*2.25);
			self:linear(0.4);
			self:y(-25*2.25);
			self:diffusealpha(0);
		end;
	};
};
};
end;

return t;
