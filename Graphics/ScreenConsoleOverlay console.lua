local size = 200


local t = Def.ActorFrame{}

-- Console background
t[#t+1] = Def.Quad {
	InitCommand = cmd(stretchto,0,-size*1.1,_screen.w,0;
		diffusetopedge,color("0,0,0,0.5");diffusebottomedge,color("0,0,0,0.8")),
}

-- Console output text
t[#t+1] = LoadFont() .. {
	InitCommand = cmd(halign,0;valign,1;xy,4,-10;zoom,0.7;
		wrapwidthpixels,(_screen.w-8)/0.7),

	-- Broadcast when new text is logged to the console
	UpdateConsoleMessageCommand = cmd(settext,Console:GetText()),
}

-- Prompt and user input
t[#t+1] = LoadFont() .. {
	InitCommand = function(self)
		self:zoom(0.7)
		self:halign(0)
		self:valign(1)
		self:xy(4,-8)

		-- Set up some variables we'll use
		self.CursorVisible = false
		self.InputText = ""
	end,

	-- We've just GOT to have that blinking cursor :)
	OnCommand = cmd(queuecommand,"Blink"),

	BlinkCommand = function(self)
		self:sleep(0.3)
		self.CursorVisible = not self.CursorVisible
		self:settext("> " .. self.InputText .. (self.CursorVisible and "_" or ""))
		self:queuecommand("Blink")
	end,

	-- Broadcast from ScreenConsoleInput whenever the input changes
	ConsoleInputMessageCommand = function(self, params)
		self.InputText = params.Text
		self:settext("> " .. self.InputText .. (self.CursorVisible and "_" or ""))
	end,
}

t.AnimateInCommand = cmd(ease,0.3,170; y,size)
t.AnimateOutCommand = cmd(ease,0.3,-170; y,0)

return t
