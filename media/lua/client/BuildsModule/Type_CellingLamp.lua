if not getLightMeUpInstance then
    require("ElectricityMenu")
end

local LightMeUp = getLightMeUpInstance()

function LightMeUp.loadTextures()
    getTexture('item_CellingLamp1.png');
end

Events.OnGameBoot.Add(LightMeUp.loadTextures);

LightMeUp.cellingLampMenu = function(subMenu, player)
    local _sprite = nil
    local _option = nil
    local _tooltip = nil
    local _name = ""

    -- Simple Celling Lamp --

    LightMeUp.neededMaterials = {{
        Material = "Base.LightBulb",
        Amount = 1
    }, {
        Material = "Radio.ElectricWire",
        Amount = 2
    }, {
        Material = "Base.Aluminum",
        Amount = 2
    }, {
        Material = "Base.Screws",
        Amount = 4
    }}

    LightMeUp.neededTools = {"Screwdriver"}

    local needSkills = {
        Electricity = 5
    }

    _sprite = {}
    _sprite.sprite = "media/textures/item_CellingLamp1.png"

    _name = getText "ContextMenu_Simple_Celling_Lamp"
    _option = subMenu:addOption(_name, nil, LightMeUp.onBuildSimpleCellingLamp, _sprite, player, _name)
    _tooltip = LightMeUp.canBuild(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip.description = getText("Tooltip_Simple_Celling_Lamp") .. "<LINE> <LINE>" .. _tooltip.description
    _tooltip:setTexture("media/textures/item_CellingLamp1.png")

    -- Metal Celling Lamp --

    LightMeUp.neededMaterials = {{
        Material = "Base.LightBulb",
        Amount = 4
    }, {
        Material = "Radio.ElectricWire",
        Amount = 8
    }, {
        Material = "Base.SmallSheetMetal",
        Amount = 2
    }, {
        Material = "Base.Screws",
        Amount = 4
    }}

    LightMeUp.neededTools = {"BlowTorch", "WeldingMask"}

    local needSkills = {
        Electricity = 5,
        MetalWelding = 4
    }

    _sprite = {}
    _sprite.sprite = "media/textures/item_CellingLamp1.png"

    _name = getText "ContextMenu_Metal_Celling_Lamp"
    _option = subMenu:addOption(_name, nil, LightMeUp.onBuildMetalCellingLamp, _sprite, player, _name)
    _tooltip = LightMeUp.canBuild(needSkills, _option, player)
    _tooltip:setName(_name)
    _tooltip.description = getText("Tooltip_Metal_Celling_Lamp") .. "<LINE> <LINE>" .. _tooltip.description
    _tooltip:setTexture("media/textures/item_CellingLamp1.png")

end

-- SIMPLE CELLING LAMP
LightMeUp.onBuildSimpleCellingLamp = function(ignoreThisArgument, sprite, player, name)
    local _SimpleCellingLamp = ISLightSource:new(sprite.sprite, sprite.sprite, player)

    _SimpleCellingLamp.player = player
    _SimpleCellingLamp.name = name
    _SimpleCellingLamp.canPassThrough = true
    _SimpleCellingLamp.needRoof = true

    _SimpleCellingLamp.offsetX = 0
    _SimpleCellingLamp.offsetY = 0
    _SimpleCellingLamp.fuel = 'Base.Battery'
    _SimpleCellingLamp.baseItem = 'Base.LightBulb'
    _SimpleCellingLamp.radius = 10

    _SimpleCellingLamp.modData["need:Base.LightBulb"] = 1
    _SimpleCellingLamp.modData["need:Radio.ElectricWire"] = 1
    _SimpleCellingLamp.modData["need:Base.Aluminum"] = 2
    _SimpleCellingLamp.modData["need:Base.Screws"] = 4
    _SimpleCellingLamp.modData["xp:Electricity"] = 5
    _SimpleCellingLamp.modData["IsLighting"] = true

    print()
    print(name, " | ", sprite.sprite)

    getCell():setDrag(_SimpleCellingLamp, player:getPlayerNum())
end

-- METAL CELLING LAMP
LightMeUp.onBuildMetalCellingLamp = function(ignoreThisArgument, sprite, player, name)
    local _MetalCellingLamp = ISLightSource:new(sprite.sprite, sprite.sprite, player)

    _MetalCellingLamp.player = player
    _MetalCellingLamp.name = name
    _MetalCellingLamp.canPassThrough = true
    _MetalCellingLamp.needRoof = true

    _MetalCellingLamp.completionSound = "BuildMetalStructureSmallScrap"
    _MetalCellingLamp.craftingBank = "BlowTorch"
    _MetalCellingLamp.actionAnim = "BlowTorchUp"

    _MetalCellingLamp.offsetX = 0
    _MetalCellingLamp.offsetY = 0
    _MetalCellingLamp.fuel = 'Base.Battery'
    _MetalCellingLamp.baseItem = 'Base.LightBulb'
    _MetalCellingLamp.radius = 20

    _MetalCellingLamp.modData["need:Base.LightBulb"] = 4
    _MetalCellingLamp.modData["need:Radio.ElectricWire"] = 8
    _MetalCellingLamp.modData["need:Base.SmallSheetMetal"] = 2
    _MetalCellingLamp.modData["need:Base.Screws"] = 4
    _MetalCellingLamp.modData["use:Base.BlowTorch"] = 10
    _MetalCellingLamp.modData["xp:MetalWelding"] = 10
    _MetalCellingLamp.modData["xp:Electricity"] = 10
    _MetalCellingLamp.modData["IsLighting"] = true

    print()
    print(name, " | ", sprite.sprite)

    getCell():setDrag(_MetalCellingLamp, player:getPlayerNum())
end

-- function ISLightSource:isValid(square)
--     if self.needRoof then
--         for i = 0, square:getObjects():size() - 1 do
--             local obj = square:getObjects():get(i);
--             if (square.haveRoof) then
--                 return true;
--             end
--         end
--     end
-- end
