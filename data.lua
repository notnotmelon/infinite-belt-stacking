local INFINITY_ROUNDED_DOWN                                           = 250      -- It's pretty close
local STACKINSERTERMODS                                               = {"space-age", "stack-inserters"}
local HAS_SPACE_AGE                                                   = mods["space-age"] ~= nil

data.raw["utility-constants"].default.max_belt_stack_size             = INFINITY_ROUNDED_DOWN
data.raw["utility-constants"].default.inserter_hand_stack_max_sprites = INFINITY_ROUNDED_DOWN

local HAS_STACK_INSERTER_MOD = false
for _, mod in ipairs(STACKINSERTERMODS) do
    if mods[mod] ~= nil then
        HAS_STACK_INSERTER_MOD = true
        break
    end
end

if not HAS_STACK_INSERTER_MOD then
    error("Custom crash message: Required stack inserter mod not found. Please install one of the following mods: " .. table.concat(STACKINSERTERMODS, ", "))
end


local ingredients = {
    {"automation-science-pack",      1},
    {"logistic-science-pack",        1},
    {"military-science-pack",        1},
    {"chemical-science-pack",        1},
    {"production-science-pack",      1},
    {"utility-science-pack",         1},
    {"space-science-pack",           1},
}

if HAS_SPACE_AGE then
    table.insert(ingredients, {"agricultural-science-pack", 1})
end

data:extend { {
    type = "technology",
    name = "transport-belt-capacity-3",
    localised_description = {"technology-description.belt-capacity"},
    icons = util.technology_icon_constant_stack_size("__infinite-belt-stacking__/graphics/technology/transport-belt-capacity-2.png"),
    effects = {
        {
            type = "belt-stack-size-bonus",
            modifier = 1
        },
        {
            type = "bulk-inserter-capacity-bonus",
            modifier = 1
        }
    },
    prerequisites = {"transport-belt-capacity-2", "inserter-capacity-bonus-7"},
    unit = {
        count_formula = "1.1^(L-3)*1000+3000",
        ingredients = ingredients,
        time = 120
    },
    max_level = "infinite",
    upgrade = true
} }
