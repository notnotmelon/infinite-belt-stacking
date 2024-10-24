local INFINITY_ROUNDED_DOWN                                           = 250      -- It's pretty close

data.raw["utility-constants"].default.max_belt_stack_size             = INFINITY_ROUNDED_DOWN
data.raw["utility-constants"].default.inserter_hand_stack_max_sprites = INFINITY_ROUNDED_DOWN

data:extend {{
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
        ingredients =
        {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"military-science-pack",        1},
            {"chemical-science-pack",        1},
            {"production-science-pack",      1},
            {"utility-science-pack",         1},
            {"space-science-pack",           1},
            {"agricultural-science-pack",    1},
        },
        time = 120
    },
    max_level = "infinite",
    upgrade = true
}}
