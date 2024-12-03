local INFINITY_ROUNDED_DOWN                                           = 250      -- It's pretty close
local HAS_SPACE_AGE                                                   = mods["space-age"] ~= nil

data.raw["utility-constants"].default.max_belt_stack_size             = INFINITY_ROUNDED_DOWN
data.raw["utility-constants"].default.inserter_hand_stack_max_sprites = INFINITY_ROUNDED_DOWN

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

if(not HAS_SPACE_AGE) then
    local sounds = require("__base__.prototypes.entity.sounds")
    local item_sounds = require("__base__.prototypes.item_sounds")
    local hit_effects = require("__base__.prototypes.entity.hit-effects")
    local explosion_animations = require("__base__.prototypes.entity.explosion-animations")

    -- Required to load space-travel feature flag without space age
    if not data.raw.tile["empty-space"] then
    local empty_space = table.deepcopy(data.raw.tile["out-of-map"])
    empty_space.name = "empty-space"
    data:extend{empty_space}
    end

    data.raw["inserter"]["bulk-inserter"].next_upgrade = "stack-inserter"

    data:extend{
    {
        type = "item",
        name = "stack-inserter",
        icon = "__infinite-belt-stacking__/graphics/icons/stack-inserter.png",
        subgroup = "inserter",
        colorblind_aid = { text = "B" },
        order = "h[stack-inserter]",
        inventory_move_sound = item_sounds.wire_inventory_move,
        pick_sound = item_sounds.wire_inventory_pickup,
        drop_sound = item_sounds.wire_inventory_move,
        place_result = "stack-inserter",
        stack_size = 50,
        default_import_location = "nauvis",
        weight = 20*kg
    },
    {
        type = "recipe",
        name = "stack-inserter",
        enabled = false,
        energy_required = 0.5,
        ingredients =
        {
        {type = "item", name = "bulk-inserter", amount = 1},
        {type = "item", name = "processing-unit", amount = 1},
        {type = "item", name = "low-density-structure", amount = 1},
        },
        results = {{type="item", name="stack-inserter", amount=1}}
    },
    {
        type = "technology",
        name = "stack-inserter",
        icon = "__infinite-belt-stacking__/graphics/technology/stack-inserter.png",
        icon_size = 256,
        effects =
        {
        {
            type = "unlock-recipe",
            recipe = "stack-inserter"
        },
        {
            type = "belt-stack-size-bonus",
            modifier = 1
        }
        },
        prerequisites = {"utility-science-pack", "bulk-inserter"},
        unit =
        {
        count = 1000,
        ingredients =
        {
            {"automation-science-pack",   1},
            {"logistic-science-pack",     1},
            {"chemical-science-pack",     1},
            {"utility-science-pack",      1},
        },
        time = 60
        }
    },
    {
        type = "technology",
        name = "transport-belt-capacity-1",
        localised_description = {"technology-description.belt-capacity"},
        icons = util.technology_icon_constant_stack_size("__infinite-belt-stacking__/graphics/technology/transport-belt-capacity.png"),
        effects =
        {
        {
            type = "belt-stack-size-bonus",
            modifier = 1
        }
        },
        prerequisites = {"production-science-pack", "stack-inserter"},
        unit =
        {
        count = 2000,
        ingredients =
        {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"chemical-science-pack",        1},
            {"production-science-pack",      1},
            {"utility-science-pack",         1},
        },
        time = 60
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "transport-belt-capacity-2",
        localised_description = {"technology-description.belt-capacity"},
        icons = util.technology_icon_constant_stack_size("__infinite-belt-stacking__/graphics/technology/transport-belt-capacity.png"),
        effects =
        {
        {
            type = "belt-stack-size-bonus",
            modifier = 1
        },
        {
            type = "inserter-stack-size-bonus",
            modifier = 1
        }
        },
        prerequisites = {"space-science-pack", "transport-belt-capacity-1"},
        unit =
        {
        count = 3000,
        ingredients =
        {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"chemical-science-pack",        1},
            {"production-science-pack",      1},
            {"utility-science-pack",         1},
            {"space-science-pack",           1},
        },
        time = 60
        },
        upgrade = true
    },
    {
        type = "inserter",
        name = "stack-inserter",
        icon = "__infinite-belt-stacking__/graphics/icons/stack-inserter.png",
        flags = {"placeable-neutral", "placeable-player", "player-creation"},
        stack_size_bonus = 4,
        bulk = true,
        grab_less_to_match_belt_stack = true,
        wait_for_full_hand = true,
        enter_drop_mode_if_held_stack_spoiled = true,
        max_belt_stack_size = 4,
        minable = { mining_time = 0.1, result = "stack-inserter" },
        max_health = 160,
        corpse = "stack-inserter-remnants",
        dying_explosion = "stack-inserter-explosion",
        resistances =
        {
        {
            type = "fire",
            percent = 90
        }
        },
        collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
        selection_box = {{-0.4, -0.35}, {0.4, 0.45}},
        damaged_trigger_effect = hit_effects.entity(),
        pickup_position = {0, -1},
        insert_position = {0, 1.2},
        energy_per_movement = "40kJ",
        energy_per_rotation = "40kJ",
        energy_source =
        {
        type = "electric",
        usage_priority = "secondary-input",
        drain = "1kW"
        },
        --heating_energy = "50kW",
        extension_speed = 0.1,
        rotation_speed = 0.04,
        filter_count = 5,
        icon_draw_specification = {scale = 0.5},
        fast_replaceable_group = "inserter",
        open_sound = sounds.inserter_open,
        close_sound = sounds.inserter_close,
        working_sound = sounds.inserter_fast,
        hand_base_picture =
        {
        filename = "__infinite-belt-stacking__/graphics/entity/stack-inserter-hand-base.png",
        priority = "extra-high",
        width = 32,
        height = 136,
        scale = 0.25
        },
        hand_closed_picture =
        {
        filename = "__infinite-belt-stacking__/graphics/entity/stack-inserter-hand-closed.png",
        priority = "extra-high",
        width = 112,
        height = 164,
        scale = 0.25
        },
        hand_open_picture =
        {
        filename = "__infinite-belt-stacking__/graphics/entity/stack-inserter-hand-open.png",
        priority = "extra-high",
        width = 134,
        height = 164,
        scale = 0.25
        },
        hand_base_shadow =
        {
        filename = "__base__/graphics/entity/burner-inserter/burner-inserter-hand-base-shadow.png",
        priority = "extra-high",
        width = 32,
        height = 132,
        scale = 0.25
        },
        hand_closed_shadow =
        {
        filename = "__infinite-belt-stacking__/graphics/entity/stack-inserter-hand-closed-shadow.png",
        priority = "extra-high",
        width = 112,
        height = 164,
        scale = 0.25
        },
        hand_open_shadow =
        {
        filename = "__infinite-belt-stacking__/graphics/entity/stack-inserter-hand-open-shadow.png",
        priority = "extra-high",
        width = 134,
        height = 164,
        scale = 0.25
        },
        platform_picture =
        {
        sheet =
        {
            filename = "__infinite-belt-stacking__/graphics/entity/stack-inserter-platform.png",
            priority = "extra-high",
            width = 105,
            height = 79,
            shift = util.by_pixel(1.5, 7.5-1),
            scale = 0.5
        }
        },
        circuit_connector = circuit_connector_definitions["inserter"],
        circuit_wire_max_distance = inserter_circuit_wire_max_distance,
        default_stack_control_input_signal = inserter_default_stack_control_input_signal
    },
    {
        type = "explosion",
        name = "stack-inserter-explosion",
        icon = "__infinite-belt-stacking__/graphics/icons/stack-inserter.png",
        flags = {"not-on-map"},
        hidden = true,
        subgroup = "inserter-explosions",
        order = "c-h-a",
        height = 0,
        animations = explosion_animations.small_explosion(),
        smoke = "smoke-fast",
        smoke_count = 2,
        smoke_slow_down_factor = 1,
        sound = sounds.small_explosion,
        created_effect =
        {
        type = "direct",
        action_delivery =
        {
            type = "instant",
            target_effects =
            {
            {
                type = "create-particle",
                repeat_count = 17,
                particle_name = "bulk-inserter-metal-particle-medium",
                offset_deviation = { { -0.5, -0.4922 }, { 0.5, 0.4922 } },
                initial_height = 0.3,
                initial_height_deviation = 0.44,
                initial_vertical_speed = 0.058,
                initial_vertical_speed_deviation = 0.05,
                speed_from_center = 0.04,
                speed_from_center_deviation = 0.05
            },
            {
                type = "create-particle",
                repeat_count = 10,
                particle_name = "bulk-inserter-metal-particle-small",
                offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
                initial_height = 0.2,
                initial_height_deviation = 0.5,
                initial_vertical_speed = 0.08,
                initial_vertical_speed_deviation = 0.05,
                speed_from_center = 0.05,
                speed_from_center_deviation = 0.05
            },
            {
                type = "create-particle",
                repeat_count = 7,
                particle_name = "cable-and-electronics-particle-small-medium",
                offset_deviation = { { -0.5, -0.5 }, { 0.5, 0.5 } },
                initial_height = 0.3,
                initial_height_deviation = 0.4,
                initial_vertical_speed = 0.06,
                initial_vertical_speed_deviation = 0.049,
                speed_from_center = 0.04,
                speed_from_center_deviation = 0.05
            }
            }
        }
        }
    },
    {
        type = "corpse",
        name = "stack-inserter-remnants",
        icon = "__infinite-belt-stacking__/graphics/icons/stack-inserter.png",
        flags = {"placeable-neutral", "not-on-map"},
        hidden_in_factoriopedia = true,
        subgroup = "inserter-remnants",
        order = "a-h-a",
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        tile_width = 1,
        tile_height = 1,
        selectable_in_game = false,
        time_before_removed = 60 * 60 * 15, -- 15 minutes
        expires = false,
        final_render_layer = "remnants",
        remove_on_tile_placement = false,
        animation = make_rotated_animation_variations_from_sheet (4,
        {
        filename = "__infinite-belt-stacking__/graphics/entity/stack-inserter-remnants.png",
        line_length = 1,
        width = 132,
        height = 96,
        direction_count = 1,
        shift = util.by_pixel(3, -1.5),
        scale = 0.5
        })
    },
    }
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