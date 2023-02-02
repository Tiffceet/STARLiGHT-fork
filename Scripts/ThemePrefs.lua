local Prefs =
{
	
	FlashyCombo =
	{
		Default = true,
		Choices = { "Off", "On" },
		Values = { false, true }
	},
	ComboUnderField =
	{
		Default = true,
		Choices = { "Off", "On" },
		Values = { false, true }
	},
	ConvertScoresAndGrades =
	{
		Default = true,
		Choices = {"No", "Yes"},
		Values = {false, true}
	},
	ComboColorMode =
	{
		Default = "arcade",
		Choices = {"Arcade Style", "Wii Style", "Waiei Style"},
		Values = {"arcade", "wii", "waiei"}
	},
	MenuBG =
	{
		Default = "New",
		Choices = { "New", "Old", "SN1" },
		Values = { "New", "Old", "SN1" }
	},
	MenuMusic =
	{
		Default = "Default",
		Choices = { "Default", "saiiko", "Inori", "fancy cake", "NextGen" },
		Values = { "Default", "saiiko", "Inori", "fancy cake", "NextGen" }
	},
	WheelType =
	{
		Default = "CoverFlow",
		Choices = { "CoverFlow", "A", "Banner", "Jukebox", "Wheel" },
		Values = { "CoverFlow", "A", "Banner", "Jukebox", "Wheel" }
	},
	ShowHTP = 
	{
		Default = false,
		Choices = {"No", "Yes"},
		Values = {false, true}
	}
};

ThemePrefs.InitAll(Prefs)

function ComboUnderField()
	return ThemePrefs.Get("ComboUnderField")
end

function OptionRowScreenFilter()
	--we use integers equivalent to the alpha value multiplied by 10
	--to work around float precision issues
	local choiceToAlpha = {0, 25, 50, 75}
	local alphaToChoice = {[0]=1, [25]=2, [5]=3, [75]=4}
	local t = {
		Name="Filter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = { THEME:GetString('OptionNames','Off'),
			THEME:GetString('OptionTitles', 'FilterDark'),
			THEME:GetString('OptionTitles', 'FilterDarker'),
			THEME:GetString('OptionTitles', 'FilterDarkest'),
		 },
		LoadSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local filterValue = getenv("ScreenFilter"..pName)

			if filterValue ~= nil then
				local val = alphaToChoice[filterValue] or 1
				list[val] = true
			else
				setenv("ScreenFilter"..pName,0)
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						setenv("ScreenFilter"..pName,choiceToAlpha[i])
						found = true
					end
				end
			end
		end,
	};
	setmetatable(t, t)
	return t
end

function stringify( tbl, form )
	if not tbl then return end

	local t = {}
	for _,value in ipairs(tbl) do
		t[#t+1] = (type(value)=="number" and form and form:format(value) ) or tostring(value)
	end
	return t
end

function MiniSelector()
	local t = {
		Name="Mini",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true,
		Choices = stringify(fornumrange(0,100,5), "%g%%"),
		LoadSelections=function(self,list,pn)
			if pn == PLAYER_1 or self.NumPlayers == 1 then
				list[1]= true
			else
				list[2]= true
			end
			setenv("NumMini",#list)
		end,
		SaveSelections=function(self,list,pn)
			for i, choice in ipairs(self.Choices) do
				if list[i] then
					local poptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
					local stoptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Stage")
					local soptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Song")
					local coptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Current")
					local mini = string.gsub(choice,"%%","")/100
					poptions:Mini(mini)
					stoptions:Mini(mini)
					soptions:Mini(mini)
					coptions:Mini(mini)
				end
			end
		end,
	}
	return t
end

local judgmentTransformYs = {
	Standard={normal=-76, reverse=67},
	Old={normal=-30, reverse=30}
}
setmetatable(judgmentTransformYs, {__index=function(this, _) return this.Standard end})

function JudgmentTransformCommand( self, params )
	self:x( 0 )
	self:y( judgmentTransformYs
		[ThemePrefs.Get("JudgmentHeight")]
		[params.bReverse and "reverse" or "normal"] )
end

