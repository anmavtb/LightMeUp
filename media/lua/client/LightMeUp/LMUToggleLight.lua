require "TimedActions/ISBaseTimedAction"

LMUToggleLight = ISBaseTimedAction:derive("LMUToggleLight");

function LMUToggleLight:isValid()
    if self.lightSource:getSquare():haveElectricity() or (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier) or self.lightSource:isLightSourceOn() then
		return true
	end
	return false
end

function LMUToggleLight:start()
end

function LMUToggleLight:update()
end

function LMUToggleLight:stop()
    ISBaseTimedAction.stop(self)
end

function LMUToggleLight:perform()
    if isClient() then
		local sq = self.lightSource:getSquare()
		local args = { x = sq:getX(), y = sq:getY(), z = sq:getZ() }
		sendClientCommand(self.character, 'object', 'toggleLight', args)
	else
		self.lightSource:toggleLightSource(not self.lightSource:isLightSourceOn())
	end
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function LMUToggleLight:new(character, lightSource, time)
	local o = ISBaseTimedAction.new(self, character)
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time
	o.lightSource = lightSource
	return o
end