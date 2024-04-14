--[[	  
	Author:
	  ZeFreestyle   
--]]


local Timer = {}
Timer.__index = Timer

local Signal = require(script.Signal)

function Timer.new(second:number)
	if not second or not typeof(second) == "number" then second = 0 end
	
	local self = setmetatable({}, Timer)
	self.Time = second
	self.BaseTime = second
	self.IsPlaying = false
	self.SecondMultiplier = 1
	self.SpeedTime = 1
	self.TimeChanged = Signal.new()
	
	function self:Play()
		if not self.IsPlaying then
			self.IsPlaying = true
			self.Time = self.BaseTime
			spawn(function()
				while self.IsPlaying and self.Time > 0 do
					self.Time = self.Time - self.SecondMultiplier
					self.TimeChanged:Fire(self.Time)
					wait(self.SpeedTime)
				end
			end)
		else
			warn(debug.traceback("Timer is already playing."))
		end
	end

	function self:Pause()
		if self.IsPlaying then
			self.IsPlaying = false
		else
			warn(debug.traceback("Timer is already paused"))
		end
	end

	function self:Resume()
		if self.Time == 0 then
			warn(debug.traceback("Can't resume the Timer because the timer has ended."))
		else
			if self.IsPlaying == false then
				self.IsPlaying = true
				spawn(function()
					while self.IsPlaying and self.Time > 0 do
						self.Time = self.Time - self.SecondMultiplier
						self.TimeChanged:Fire(self.Time)
						wait(self.SpeedTime)
					end
				end)
			else
				warn(debug.traceback("Timer is already playing."))
			end
		end
	end

	function self:AddTime(secondsToAdd:number)
		if not secondsToAdd then error(debug.traceback("Missing 1 arguments to play the function.")) end
		if not typeof(secondsToAdd) == "number" then error(debug.traceback("The secondsToAdd arguments must be a number")) end

		self.Time = self.Time + secondsToAdd
	end

	function self:SkipTime(secondsToSkip:number)
		if not secondsToSkip then error(debug.traceback("Missing 1 arguments to play the function.")) end
		if not typeof(secondsToSkip) == "number" then error(debug.traceback("The secondsToSkip arguments must be a number")) end

		self.Timer = self.Timer - secondsToSkip
	end

	function self:SetSecondMultiplier(newMultiplier:number)
		if not newMultiplier then newMultiplier = 1 end
		if not typeof(newMultiplier) == "number" then error(debug.traceback("The newMultiplier arguments must be a number")) end

		self.SecondMultiplier = newMultiplier
	end

	function self:SetSpeedTime(newMultiplier:number)
		if not newMultiplier then newMultiplier = 1 end
		if not typeof(newMultiplier) == "number" then error(debug.traceback("The newMultiplier arguments must be a number")) end

		self.SpeedTime = newMultiplier
	end

	function self:Stop()
		self.IsPlaying = false
		self.Timer = self.BaseTime
	end
	
	return self
end

return Timer
