require "BuildingObjects/ISBuildingObject"

ISSwitch = ISBuildingObject:derive("ISSwitch");

function ISSwitch:create(x, y, z, north, sprite)

    local cell = getWorld():getCell();
    self.sq = cell:getGridSquare(x, y, z);
    BuildLight.getRoom(self.sq)
    self.javaObject = IsoLightSwitch.new(cell, self.sq, sprite, 17); -- Trouver un moyen de régler le RoomID
    self.sq:AddSpecialObject(self.javaObject);
    self.javaObject:transmitCompleteItemToServer();
end

function ISSwitch:isValid(square)
    if not ISBuildingObject.isValid(self, square) then
        return false
    end
    if self.needToBeAgainstWall then
        for i = 0, square:getObjects():size() - 1 do
            local obj = square:getObjects():get(i)
            if self:getSprite() == obj:getTextureName() then
                return false
            end
            if (not self.north and obj:getProperties():Is("WallN")) or
                (self.northSprite and obj:getProperties():Is("WallW")) then
                return true
            end
        end
        return false
    else
        if buildUtil.stairIsBlockingPlacement(square, true) then
            return false
        end
    end
    return true
end

function ISSwitch:render(x, y, z, square)
    ISSwitch.render(self, x, y, z, square)
end

function ISSwitch:new(sprite, northSprite, player)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o:init();
    o:setSprite(sprite);
    o:setNorthSprite(northSprite);
    o.player = player
    o.dismantable = true
    o.needToBeAgainstWall = true
    o.name = name
    o.stopOnWalk = true
    o.stopOnRun = true
    o.maxTime = 500
    return o
end
