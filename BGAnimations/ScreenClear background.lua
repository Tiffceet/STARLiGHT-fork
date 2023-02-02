local invalidprefsBGM = {
	"leeium",
	"SN3",
	"RGTM"
};

local invalidprefsWheel = {
	"Default",
	"CoverFlow",
	"Solo"
};

local invalidprefsmenu = {
	"NG2",
	"Default",
	"2019"
};

if has_value(invalidprefsmenu,ThemePrefs.Get("MenuBG")) then
	ThemePrefs.Set("MenuBG","New")
end
if has_value(invalidprefsWheel,ThemePrefs.Get("WheelType")) then
	ThemePrefs.Set("WheelType","CoverFlow")
end
if has_value(invalidprefsBGM,ThemePrefs.Get("MenuMusic")) then
	ThemePrefs.Set("MenuMusic","Default")
end

local mus_path = THEME:GetCurrentThemeDirectory().."/Sounds/ScreenSelectMusic music (loop).redir"
local f = RageFileUtil.CreateRageFile()
if f:Open(mus_path, 1) then
	if GetMenuMusicPath("music") then
		if GetMenuMusicPath("music") ~= "/"..THEME:GetCurrentThemeDirectory().."Sounds/"..f:Read() then
			--I don't know why the FUCK I have to do this but it read+write just doesn't work I guess.
			f:Close()
			f:Open(mus_path, 2)
			f:Write(GetMenuMusicPath("music",true))
			f:Close()
		end
		f:destroy()
		THEME:ReloadMetrics()
	end
end

return Def.Actor{
	OnCommand=function(s)
		AttractFreq = 0
		local coins = GAMESTATE:GetCoins()
		if coins >= 1 then
			GAMESTATE:InsertCoin(-coins)
		end
	end,
};

