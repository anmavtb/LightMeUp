print("MOD DEBUG: LIGHT ME UP MOD DEBUG LUA LOADED")

LightMeUp = {}

-- Materials needed to build
LightMeUp.neededMaterials = {}
-- Tools needed to build
LightMeUp.neededTools = {}
-- Skills needed to build
LightMeUp.playerSkills = {}

-- Tooltip text
LightMeUp.textSkillsRed = {}
LightMeUp.textSkillsGreen = {}

-- Check items for damage
local function predicateNotBroken(item)
    return not item:isBroken()
end

-- Make the Electricity menu aviable if the player has a screwdriver in their inventory
LightMeUp.doElecMenu = function(player, context, worldobjects, test)
    if test and ISWorldObjectContextMenu.Test then return true end

    if getCore():getGameMode()=="LastStand" then return; end

    if test then return ISWorldObjectContextMenu.setTest() end

    local playerObj = getSpecificPlayer(player)
    local playerInv = playerObj:getInventory()

    if playerObj:getVehicle() then return; end

    if (LightMeUp.haveTool(playerObj, "Screwdriver")) then
        LightMeUp.buildSkillsList(playerObj)

        --LMU Context Menu
        local electricityOption = context:addOption(getText("ContextMenu_Electricity"))
        local subMenu = ISContextMenu:getNew(context)
        context:addSubMenu(electricityOption, subMenu)

        LightMeUp.cellingLampMenu(subMenu, playerObj)
    end
end

-- Test if the player have the tool and return true. Otherwise return false
LightMeUp.haveTool = function(player, tool)
    local haveTools = nil
    if player:getInventory():getFirstTagEvalRecurse(tool, predicateNotBroken) then
        haveTools = true
    else
        haveTools = false
    end
    return haveTools or ISBuildMenu.cheat
end

-- Construct Skill text
LightMeUp.buildSkillsList = function(player)
    local perks = PerkFactory.PerkList
    local perkID = nil
    local perkType = nil
    for i = 0, perks:size() - 1 do
        perkID = perks:get(i):getId()
        perkType = perks:get(i):getType()
        LightMeUp.playerSkills[perkID] = player:getPerkLevel(perks:get(i))
        LightMeUp.textSkillsRed[perkID] = " <RGB:1,0,0>" .. PerkFactory.getPerkName(perkType)
        LightMeUp.textSkillsGreen[perkID] = " <RGB:1,1,1>" .. PerkFactory.getPerkName(perkType)
    end
end

function getLightMeUpInstance()
    return LightMeUp
end

-- register the OnFillWorldObjectContextMenu event
Events.OnFillWorldObjectContextMenu.Add(LightMeUp.doElecMenu)