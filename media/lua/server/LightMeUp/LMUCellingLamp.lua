LMUCellingLamp = ISBuildingObject:derive("LMUCellingLamp")

function LMUCellingLamp:create(x, y, z, north, sprite)
    local cell = getWorld():getCell()
    self.sq = cell:getGridSquare(x, y, z)
    self.javaObject = IsoThumpable.new(cell, self.sq, sprite, north, self)
    buildUtil.setInfo(self.javaObject, self)

    -- light stuff
    local offsetX = 0
    local offsetY = 0
    if self.east then
        offsetX = self.offsetX
    elseif self.west then
        offsetX = -self.offsetX
    elseif self.south then
        offsetY = self.offsetY
    elseif self.north then
        offsetY = -self.offsetY
    end

    -- local baseItem = self.character:getInventory():getFirstTypeRecurse(self.baseItem)
    -- if not baseItem then
    --     local itemsOnGround = buildUtil.getMaterialOnGround(self.sq)
    --     baseItem = itemsOnGround[self.baseItem] and itemsOnGround[self.baseItem][1] or nil
    -- end

    local lightB = self.character:getInventory():AddItem("Base.LightBulb")

    self.javaObject:createLightSource(self.radius, offsetX, offsetY, 0, 0, nil, lightB, self.character)
    self.javaObject:setHaveFuel(false)
    if not (self.sq:haveElectricity() or
        (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier)) then
        self.javaObject:toggleLightSource(false)
    end

    self.character:getInventory():Remove(lightB)
    self.javaObject:getModData()["need:" .. self.baseItem] = "1"

    buildUtil.consumeMaterial(self)
    self.javaObject:setMaxHealth(100)
    self.javaObject:setBreakSound("BreakObject")
    self.sq:AddSpecialObject(self.javaObject)

    self.javaObject:transmitCompleteItemToServer()

end

function LMUCellingLamp:new(name, sprite, player)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o:init()
    o:setSprite(sprite)
    o:setNorthSprite(sprite)
    o.canBarricade = false
    o.dismantable = true
    o.character = player
    o.name = name
    return o
end

function LMUCellingLamp:getHealth()
    return 100
end

function LMUCellingLamp:isValid(square)
    if not square.haveRoof then
        return false
    end
    if not self:haveMaterial(square) then
        return false
    end
    return square:isFree(true)
end

function LMUCellingLamp:render(x, y, z, square)
    ISBuildingObject.render(self, x, y, z, square)
end
