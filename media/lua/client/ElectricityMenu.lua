local getSpecificPlayer = getSpecificPlayer
local pairs = pairs
local split = string.split
local getItemNameFromFullType = getItemNameFromFullType
local getSprite = getSprite
local getFirstTypeEval = getFirstTypeEval
local getItemCountFromTypeRecurse = getItemCountFromTypeRecurse
local getText = getText

print("MOD DEBUG: LIGHT ME UP MOD DEBUG LUA LOADED")

local LightMeUp = {}

LightMeUp.neededMaterials = {}
LightMeUp.neededTools = {}
LightMeUp.toolsList = {}
LightMeUp.playerSkills = {}

local function predicateNotBroken(item)
    return not item:isBroken();
end

-- Make the Electricity menu aviable if the player have a screwdriver in their inventory
LightMeUp.doElecMenu = function(player, context, worldobjects, test)
    if test and ISWorldObjectContextMenu.Test then
        return true
    end

    if getCore():getGameMode() == "LastStand" then
        return;
    end

    local player = getSpecificPlayer(player)
    if player:getVehicle() then
        return
    end

    local playerInv = player:getInventory();

    LightMeUp.getRoom(player)

    if (LightMeUp.haveTool(player, "Screwdriver")) then
        local electricityOption = context:addOption(getText("ContextMenu_Electricity"));
        local subMenu = ISContextMenu:getNew(context);
        context:addSubMenu(electricityOption, subMenu);

        LightMeUp.cellingLampMenu(subMenu, player);
    end
end

-- @param player number : IsoPlayer index
-- @param tool string   : Tool type
LightMeUp.equipToolPrimary = function(player, tool)
    local tools = player:getInventory():getFirstTypeEval(tool, predicateNotBroken)
    if tools then
        ISInventoryPaneContextMenu.equipWeapon(tool, true, false, player)
    end
end

-- @param player number : IsoPlayer index
-- @param tool string   : Tool type
-- @return boolean      : if the player have the tool return true otherwise return false
LightMeUp.haveTool = function(player, tool)
    local haveTools = nil
    if player:getInventory():containsTagEvalRecurse(tool, predicateNotBroken) then
        haveTools = true
    else
        haveTools = false
    end
    return haveTools or ISBuildMenu.cheat
end

-- Count the material in the player inventory and adjacent containers and add it to the tooltip
LightMeUp.countMaterial = function(player, material, amount, tooltip)
    local playerInv = player:getInventory()
    local type = split(material, "\\.")[2]
    local count = 0
    local groundItem = ISBuildMenu.materialOnGround

    if amount > 0 then
        count = inv:getItemCountFromTypeRecurse(material)

        for groundItemType, groundItemCount in pairs(groundItem) do
            if groundItemType == type then
                count = count + groundItemCount
            end
        end

        if material == "Base.Screws" then
            count = count + playerInv:getItemCountFromTypeRecurse("Base.ScrewsBox") * 100
            if groundItem["Base.ScrewsBox"] then
                count = count + groundItem["Base.ScrewsBox"] * 100
            end
        end

        if count < amount then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType(material) .. " " ..
                                      count .. "/" .. amount .. " <LINE>"
            return false
        else
            tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType(material) .. " " ..
                                      count .. "/" .. amount .. " <LINE>"
            return true
        end
    end
end

-- Test if tool is in inventory and add it to the tooltip
LightMeUp.tooltipCheckForTool = function(player, tool, tooltip)
    local tools = LightMeUp.haveTool(player, tool)
    if tools then
        tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. getItemNameFromFullType(tools) .. " <LINE>"
        return true
    else
        tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. getItemNameFromFullType(tools) .. " <LINE>"
        return false
    end
end

LightMeUp.canBuild = function(skills, option, player)
    local tooltip = ISToolTip:new();
    tooltip:initialise()
    tooltip:setVisible(false)
    option.toolTip = tooltip;

    local result = true;
    local currentResult = true;

    tooltip.description = "" .. getText("Tooltip_craft_Needs") .. ": <LINE>";

    -- test all materials
    for _, currentMaterial in pairs(LightMeUp.neededMaterials) do
        if currentMaterial["Material"] and currentMaterial["Amount"] then
            currentResult = LightMeUp.countMaterial(player, currentMaterial["Material"], currentMaterial["Amount"],
                tooltip)
        else
            tooltip.description = tooltip.description .. " <RGB:1,0,0> Error in required material definition. <LINE>"
            result = false
        end

        if not currentResult then
            result = false
        end
    end

    -- test for tool
    for _, _currentTool in pairs(LightMeUp.neededTools) do
        result = LightMeUp.tooltipCheckForTool(player, _currentTool, tooltip)

        if not currentResult then
            result = false
        end
    end

    -- test for skill
    for skill, level in pairs(skills) do
        if (LightMeUp.playerSkills[skill] < level) then
            tooltip.description = tooltip.description .. " <RGB:1,0,0>" .. skill .. " " ..
                                      player:getPerkLevel(skill) .. "/" .. level .. " <LINE>";
            result = false;
        else
            tooltip.description = tooltip.description .. " <RGB:1,1,1>" .. skill .. " " ..
                                      player:getPerkLevel(skill) .. "/" .. level .. " <LINE>";
        end
    end

    if not result and not ISBuildMenu.cheat then
        option.onSelect = nil
        option.notAvailable = true
    end

    toolTip.footNote = getText("Tooltip_craft_pressToRotate", Keyboard.getKeyName(getCore():getKey("Rotate building")));
    return tooltip;
end

-- Get MoreBuild instance
-- @return table: MoreBuild table
function getLightMeUpInstance()
    return LightMeUp
end

-- register the OnFillWorldObjectContextMenu event
Events.OnFillWorldObjectContextMenu.Add(LightMeUp.doElecMenu);
