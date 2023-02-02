DDR ={}

function DDR.Resize(width,height,setwidth,sethight)

	if height >= sethight and width >= setwidth then
		if height*(setwidth/sethight) >= width then
			return sethight/height
		else
			return setwidth/width
		end
	elseif height >= sethight then
		return sethight/height
	elseif width >= setwidth then
		return setwidth/width
	else 
		return 1
	end
end

function DDRInput(self)
    return function(event)
        if not event.PlayerNumber then return end
		self.pn = event.PlayerNumber
        if ToEnumShortString(event.type) == "FirstPress" then
            self:queuecommand(event.GameButton)
    	end
        if ToEnumShortString(event.type) == "Release" then
            self:queuecommand(event.GameButton.."Release")
        end
		if ToEnumShortString(event.type) == "Repeat" then
			self:queuecommand(event.GameButton.."Repeat")
		end
    end
end

function PillNum(self)
	if GAMESTATE:IsDemonstration() then
		return "25"
	else
		return "24"
	end
end