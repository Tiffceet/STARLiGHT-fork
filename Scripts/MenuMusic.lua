do
	--if there isn't music for a specific screen it falls back to common
	local music = {
		common = {
			["Default"] = "MenuMusic/common/Default (loop).ogg";
			["saiiko"] = "MenuMusic/common/sk2_menu2 (loop).ogg";
			["inori"] = "MenuMusic/common/inori (loop).ogg";
			["fancy cake"] = "MenuMusic/common/fancycake (loop).ogg";
			["NextGen"] = "MenuMusic/common/NextGen (loop).ogg";
		};
		profile = {
			["Default"] = "MenuMusic/profile/Default (loop).ogg";
			["saiiko"] = "MenuMusic/profile/sk2_menu1 (loop).ogg";
			["inori"] = "MenuMusic/common/inori (loop).ogg";
			["fancy cake"] = "MenuMusic/profile/fancycake (loop).ogg";
			["NextGen"] = "MenuMusic/profile/NextGen (loop).ogg";
		};
		results = {
			["Default"] = "MenuMusic/common/Default (loop).ogg";
			["saiiko"] = "MenuMusic/results/sk2_menu3 (loop).ogg";
			["inori"] = "MenuMusic/common/inori (loop).ogg";
			["fancy cake"] = "MenuMusic/results/fancycake (loop).ogg";
			["NextGen"] = "MenuMusic/results/NextGen (loop).ogg";
		};
		music = {
			["Default"] = "MenuMusic/common/Default (loop).ogg";
			["saiiko"] = "MenuMusic/common/sk2_menu2 (loop).ogg";
			["inori"] = "MenuMusic/common/inori (loop).ogg";
			["fancy cake"] = "MenuMusic/common/fancycake (loop).ogg";
			["NextGen"] = "MenuMusic/SelMusic/NextGen (loop).ogg";
		}
	}
	--thanks to this code
	for name,child in pairs(music) do
		if name ~= "common" then
			setmetatable(child, {__index=music.common})
		end
	end
	function GetMenuMusicPath(type, relative)
		local possibles = music[type]
			or error("GetMenuMusicPath: unknown menu music type "..type, 2)
		local selection = ThemePrefs.Get("MenuMusic")
		local file = possibles[selection]
			or error("GetMenuMusicPath: no menu music defined for selection"..selection, 2)
		return relative and file or THEME:GetPathS("", file)
	end
end
