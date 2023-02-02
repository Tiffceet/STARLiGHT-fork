function fucking_pages(self,offsetFromCenter,itemIndex,numItems)
	self:x( offsetFromCenter*160 )
	--[[if offsetFromCenter == 0 then
		self:addy(-10);
		self:addx(10);
	end;]]
end

function curved_wheel_transform(self,offsetFromCenter,_fake1,_fake2)

	local numItems = THEME:GetMetric("MusicWheelWheel","NumWheelItems")
	local curve3D = THEME:GetMetric("MusicWheelWheel", "CirclePercent")*4*math.pi
	local fRotX = scale(offsetFromCenter, -numItems/2,numItems/2, -curve3D/2,curve3D/2)
	local radius = THEME:GetMetric("MusicWheelWheel","Wheel3DRadius")
	local curveX = THEME:GetMetric("MusicWheelWheel","ItemCurveX")
	local spacingY = THEME:GetMetric("MusicWheelWheel","ItemSpacingY")
	self:x( (1-math.cos(offsetFromCenter/math.pi))*72 )
	--self:y( (offsetFromCenter*scale(math.abs(offsetFromCenter), 0,numItems/2, spacingY,spacingY*math.sin(1.151))) )
	self:z( -10*math.abs(offsetFromCenter*2.5) )
	self:rotationx((offsetFromCenter*14) * math.sin(180/math.pi))
	self:y( (offsetFromCenter*scale(math.abs(offsetFromCenter), 0,numItems/2, spacingY,spacingY*math.sin(0.8))) )
	if offsetFromCenter < -0.5 then
		self:addy( -20 );
		self:addx(0)
	elseif offsetFromCenter > 0.5 then
		self:addy( 20 );
		self:addx(0)
	elseif offsetFromCenter >= -0.5 and offsetFromCenter <= 0.5 then
		self:addy( offsetFromCenter*20 );
		self:addx( 40 )
	end
end

function MusicWheelType()
	return "MusicWheel"..ThemePrefs.Get("WheelType")
end;

function ScrollBarH()
	if ThemePrefs.Get("WheelType") == "A" then
		return SCREEN_HEIGHT/4
	elseif ThemePrefs.Get("WheelType") == "Wheel" then
		return SCREEN_HEIGHT/3
	else
		return 1
	end
end

function ScrollBarOn(s)
	if ThemePrefs.Get("WheelType") == "A" then
		s:xy(450,-140):skewx(0.25):zoomx(1.5)
	elseif ThemePrefs.Get("WheelType") == "Wheel" then
		s:xy(600,-140):zoomx(-1.5):zoomy(1.5):draworder(500)
	else
		s:diffusealpha(0)
	end
end

function WheelOn(self)
	if ThemePrefs.Get("WheelType") == "Jukebox" then
		self:fov(75)
		self:rotationx(-55)
		self:diffusealpha(0):linear(0.25):diffusealpha(1)
	elseif ThemePrefs.Get("WheelType") == "Banner" then
		self:zoom(IsUsingWideScreen() and 1 or 0.97)
		self:fov(75)
		self:rotationx(-75)
		self:diffusealpha(0):sleep(0.4):linear(0.1):diffusealpha(1)
	elseif ThemePrefs.Get("WheelType") == "Wheel" then
		self:rotationy(30)
		self:addx(1100):sleep(0.412):linear(0.196):addx(-1100)
	elseif ThemePrefs.Get("WheelType") == "A" then
		self:diffusealpha(0):sleep(0.05):diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(1)
		:sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(1)
	else
		self:fov(60)
	end;
	self:SetDrawByZPosition(true)
end;

function WheelOff(self)
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		self:bouncebegin(0.15):zoomx(3):diffusealpha(0)
	else
		self:bouncebegin(0.15):zoomx(3):diffusealpha(0)
	end;
end;

function WheelSteps(self)
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		self:bouncebegin(0.15):zoomx(3):diffusealpha(0)
	else

	end;
end;

function MusicWheelX(self)
	if ThemePrefs.Get("WheelType") == "Wheel" then
		return SCREEN_CENTER_X+360
	else
		return SCREEN_CENTER_X
	end;
end;

function MusicWheelY(self)
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		return SCREEN_CENTER_Y+254
	elseif ThemePrefs.Get("WheelType") == "A" then
		return SCREEN_CENTER_Y
	elseif ThemePrefs.Get("WheelType") == "Banner" then
		return SCREEN_CENTER_Y+240
	elseif ThemePrefs.Get("WheelType") == "Jukebox" then
	    return SCREEN_CENTER_Y-160
	elseif ThemePrefs.Get("WheelType") == "Wheel" then
		return SCREEN_CENTER_Y+20
	end;
end;

--This is here because a bunch of wheel item things need it, and also because
--it barely does any error checking at all
function SameDiffSteps(song, pn)
    if song then
		local diff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty();
		local st = GAMESTATE:GetCurrentStyle():GetStepsType();
		return song:GetOneSteps(st, diff);
	end;
end;

ClearLampColors = {
	[0]={1,1,1,0},
	color "#555452",
	color "#f70b9e",
	GameColor.Judgment["JudgmentLine_W4"],
	GameColor.Judgment["JudgmentLine_W3"],
	GameColor.Judgment["JudgmentLine_W2"],
	GameColor.Judgment["JudgmentLine_W1"]
};

local BestGetHighScoreList;
if Profile.GetHighScoreListIfExists then
	BestGetHighScoreList = Profile.GetHighScoreListIfExists;
else
	BestGetHighScoreList = Profile.GetHighScoreList;
end;

function ClearLamp(song, steps, pn)
	local best_lamp = 0; --No Play
	if PROFILEMAN:IsPersistentProfile(pn) then
		local prof = PROFILEMAN:GetProfile(pn);
		local st = GAMESTATE:GetCurrentStyle():GetStepsType();
		local list = BestGetHighScoreList(prof, song, steps);
		if list then
			for score in ivalues(list:GetHighScores()) do
				local this_lamp = 0;
				if score:GetGrade() == 'Grade_Failed' then
					this_lamp = 1; --Failed
				else
					local missed_nontaps = (score:GetHoldNoteScore'HoldNoteScore_LetGo'
					+ score:GetHoldNoteScore'HoldNoteScore_MissedHold'
					+ score:GetTapNoteScore'TapNoteScore_HitMine')>0
					if missed_nontaps or score:GetTapNoteScore'TapNoteScore_Miss'>0 then
						this_lamp = 2; --Cleared
					elseif score:GetTapNoteScore'TapNoteScore_W5'>0
						or score:GetTapNoteScore'TapNoteScore_W4'>0
					then
						this_lamp = 3; --Good FC
					elseif score:GetTapNoteScore'TapNoteScore_W3'>0 then
						this_lamp = 4; --Great FC
					elseif score:GetTapNoteScore'TapNoteScore_W2'>0 then
						this_lamp = 5; --Perfect FC
					elseif score:GetTapNoteScore'TapNoteScore_W1'>0 then
						--no reason to keep searching, this is the best one
						return 6; --Marvelous FC
					else
						--this means the chart has no notes.
						--treat this as a normal clear.
						return 2; --Cleared
					end;
				end;
				if this_lamp > best_lamp then
					best_lamp = this_lamp;
				end;
			end;
		end;
	end;
	return best_lamp;
end;
