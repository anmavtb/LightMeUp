BuildLight.buildLightSwitchMenu = function(subMenu, player)
    local sprite = nil
    local option = nil
    local tooltip = nil
    local name = ""

    BuildLight.neededMaterials = {{
        Material = "Base.ElectronicsScrap",
        Amount = 2
    }, {
        Material = "Radio.ElectricWire",
        Amount = 2
    }, {
        Material = "Base.LightBulb",
        Amount = 1
    }}

    BuildLight.neededTools = {"Screwdriver"}

    local needSkills = {
        Electricity = 5
    }

    sprite = {}
    sprite.sprite = "lighting_indoor_01_0";
    sprite.northSprite = "lighting_indoor_01_1";
    sprite.eastSprite = "lighting_indoor_01_3";
    sprite.southSprite = "lighting_indoor_01_2";

    local perk = BuildLight.playerSkills["Electricity"]

    name = getText "ContextMenu_LightSwitch"
    option = subMenu:addOption(name, nil, BuildLight.onBuildLightSwitch, sprite, perk, name, player)
    tooltip = BuildLight.canBuild(needSkills, option, player)
    tooltip:setName(name)
    tooltip.description = getText("ContextMenu_LightSwitch") .. tooltip.description
    tooltip:setTexture(sprite.sprite)
end

BuildLight.onBuildLightSwitch = function(sprite, perk, name, player)
    -- local switch = ISSwitch:new(sprite.sprite, sprite.northSprite, perk);

    -- switch.player = player
    -- switch.name = name
    -- switch.completionSound = "Screwdriver"

    -- switch.modData["need:Base.ElectronicsScrap"] = 2;
    -- switch.modData["need:Radio.ElectricWire"] = 2;
    -- switch.modData["need:Base.LightBulb"] = 1;
    -- switch.modData["xp:Electricity"] = 5;

    -- getCell():setDrag(switch, player)
    print("SWITCH CONSTRUIT")
end
