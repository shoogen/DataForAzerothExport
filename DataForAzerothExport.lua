local FIELDS = {
    sourceID = {},
    decorID = {},
    questID = { itemID = true, mountmodID = true },
    recipeID = { itemID = true },
    achievementID = {},
    factionID = {},
    toyID = {},
    titleID = {},
    mountID = {},
    speciesID = {}, -- pets
    itemID = {} -- heirlooms
}

-- helper function to lookup field value in parent nodes too
function bubble(table, field)
    if table[field] then
        return table[field]
    end

    if table.parent then
        return bubble(table.parent, field)
    end
end

-- helper function to decide which fields to export
function checkfield(category, table, field)
    if FIELDS[category][field] then
        return table[field]
    end
end

SLASH_DFAEXPORT1 = "/dfaexport"
SlashCmdList.DFAEXPORT = function(msg)
    if msg == "keys" then
        for category, _ in pairs(ATT_CURRENT_CACHE) do
            print(category)
        end
        return
    end

    if msg == "clear" then
        DFA_EXPORT = {}
        return
    end

    if ATT_CURRENT_CACHE then -- global variable must be set by ATT code
        print("Exporting...")
        DFA_EXPORT = {}

        for category, _ in pairs(FIELDS) do
            DFA_EXPORT[category] = {}

            local cache = ATT_CURRENT_CACHE[category]
            for id, _ in pairs(cache) do
                for idx, item in ipairs(cache[id]) do
                    --DevTools_Dump(item)
                    -- TODO Export category name
                    table.insert(DFA_EXPORT[category], { id = id, itemID = checkfield(category, item, "itemID"), mountmodID = checkfield(category, item, "mountmodID"), u = bubble(item, "u"), b = bubble(item, "b"), rwp = bubble(item, "rwp") })
                end
            end
        end

        print("...done")
    else
        print("ATT_CURRENT_CACHE not found")
    end
end