if not _IE then
    error("\n\n[CTF Info] Please add the mod to secure.trusted_mods for the mod to function!\n")
    else
        lua_utf8 = _IE.require 'lua-utf8'
end

local old_string = {}

--[[old_string.match = string.match
string.match = function(s, pattern, init)
    local success, res = pcall(function(s, pattern, init) return lua_utf8.match(s, pattern, init) end)
    if not success then return old_string.match(s, pattern, init) end
    return res
end

old_string.find = string.find
string.find = function(s, pattern, init, plain)
    local success, res = pcall(function(s, pattern, init, plain) return lua_utf8.find(s, pattern, init, plain) end)
    if not success then return old_string.find(s, pattern, init, plain) end
    return res
end

old_string.sub = string.sub
    string.sub = function(s, i, j)
    local success, res = pcall(function(s, i, j) return lua_utf8.sub(s, i, j) end)
    if not success then return old_string.sub(s, i, j) end
    return res
end]]

old_string.lower = string.lower
string.lower = function(s)
    local success, res = pcall(lua_utf8.lower, s)
    if not success then return old_string.lower(s) end
    return res
end


local old_handle_node_drops = core.handle_node_drops

function core.handle_node_drops(pos, drops, digger)
	-- Add dropped items to object's inventory
	local inv = digger and digger:get_inventory()
	if not inv or not inv:get_list("offhand") then
        old_handle_node_drops(pos, drops, digger)
        return
    end
	local left_items = {}
    local give_item = function(item)
        return inv:add_item("offhand", item)
    end
    
    for _, dropped_item in pairs(drops) do
        if inv:contains_item("offhand", dropped_item) then
            local left = give_item(dropped_item)
            if not left:is_empty() then
                table.insert(left_items, left)
            end
        else
            table.insert(left_items, dropped_item)
        end
    end
	old_handle_node_drops(pos, left_items, digger)

end

core.register_on_item_pickup(function(itemstack, picker, pointed_thing, time_from_last_punch,  ...)
    local inv = picker and picker:get_inventory()
    if not inv or not inv:get_list("offhand") then return end
    if inv:contains_item("offhand", itemstack:get_name()) then
        itemstack = inv:add_item("offhand", itemstack)
    end
	-- Pickup item.
	if inv then
		return inv:add_item("main", itemstack)
	end
    return itemstack
end)

core.register_on_mods_loaded(function()
    xcompat.materials.slab_stone = 'default:slab_stone_8'
    xcompat.materials.steel_bar = 'basic_materials:steel_bar'
    xcompat.materials.plastic_sheet = 'basic_materials:plastic_sheet'
    core.register_alias("oil:oil", "techage:oil")
    core.register_alias("oil:oil_source", "techage:oil_source")
    core.register_alias("oil:oil_flowing", "techage:oil_flowing")
    core.register_alias("oil:oil_bucket", "techage:bucket_oil")
    core.register_alias("mesecraft_mobs:bone", "bonemeal:bone")

    core.register_alias("multidecor:metal_bar", "basic_materials:steel_bar")
    core.register_alias("multidecor:plastic_sheet", "basic_materials:plastic_sheet")
    core.register_alias("multidecor:plastic_strip", "basic_materials:plastic_strip")
    core.register_alias("multidecor:brass_ingot", "basic_materials:brass_ingot")
    core.register_alias("multidecor:steel_stripe", "basic_materials:steel_strip")

    core.clear_craft({output = "x_enchanting:grindstone"})
    core.clear_craft({output = "logistica:cobblegen_supplier"})

    core.register_craft({
        output = 'x_enchanting:grindstone',
        recipe = {
            { 'group:stick', xcompat.materials.slab_stone, 'group:stick' },
            { 'group:wood', '', 'group:wood' }
        }
    })

    core.register_craft({
        type = "cooking",
        output = "multidecor:wax_lump",
        recipe = "bees:wax",
        cooktime = 10
    })
    
    --fix ma and pops recipe conflict
    local hedge_table = { --material, name
        {'leaves', 'apple'},
        {'pine_needles', 'pine'},
        {'jungleleaves', 'jungle'},
        {'acacia_leaves', 'acacia'},
        {'aspen_leaves', 'aspen'}
    }

    for i in ipairs (hedge_table) do
        local material = hedge_table[i][1]
        local name = hedge_table[i][2]
        
        core.clear_craft({output = 'ma_pops_furniture:'..name..'_hedge'})

        core.register_craft({
            output = 'ma_pops_furniture:'..name..'_hedge',
            recipe = {
                {'default:'..material, 'default:'..material, ''},
                {'default:'..material, 'default:'..material, ''},
                {'default:'..material, 'default:'..material, ''}
                }
        })
    end
    --end fix ma and pops
    
    --fix farming:thread missing 'thread' group
    local string_def = core.registered_items["farming:string"]
    local new_groups = table.copy(string_def.groups or {})
    new_groups.thread = 1

    core.override_item("farming:string", {
        groups = new_groups,
    })
    --fix farming:thread
    
    string_def = core.registered_items["default:obsidian_glass"]
    new_groups = table.copy(string_def.groups or {})
    new_groups.pit_plasma_resistant = 1
    core.override_item("default:obsidian_glass", {
        groups = new_groups,
    })
    
    string_def = core.registered_items["default:obsidianbrick"]
    new_groups = table.copy(string_def.groups or {})
    new_groups.pit_plasma_resistant = 1
    core.override_item("default:obsidianbrick", {
        groups = new_groups,
    })
    
    lumberjack.register_tree("ebiomes:birch_tree", "ebiomes:birch_sapling", 1, 2)
    lumberjack.register_tree("ebiomes:downy_birch_tree", "ebiomes:downy_birch_sapling", 1, 2)
    lumberjack.register_tree("ebiomes:willow_tree", "ebiomes:willow_sapling", 2, 3)
    lumberjack.register_tree("ebiomes:alder_tree", "ebiomes:alder_sapling", 2, 3)
    lumberjack.register_tree("ebiomes:ash_tree", "ebiomes:ash_sapling", 3, 3)
    lumberjack.register_tree("ebiomes:oak_tree", "ebiomes:oak_sapling", 4, 3)
    lumberjack.register_tree("ebiomes:maple_tree", "ebiomes:maple_sapling", 2, 3)
    lumberjack.register_tree("ebiomes:sugi_tree", "ebiomes:sugi_sapling", 1, 3)
    lumberjack.register_tree("ebiomes:mizunara_tree", "ebiomes:mizunara_sapling", 3, 3)
    lumberjack.register_tree("ebiomes:stoneoak_tree", "ebiomes:stoneoak_sapling", 1, 3)
    lumberjack.register_tree("ebiomes:cypress_tree", "ebiomes:cypress_sapling", 1, 2)
    lumberjack.register_tree("ebiomes:olive_tree", "ebiomes:olive_sapling", 2, 2)
    lumberjack.register_tree("ebiomes:afzelia_tree", "ebiomes:afzelia_sapling", 6, 3)
    lumberjack.register_tree("ebiomes:limba_tree", "ebiomes:limba_sapling", 3, 3)
    lumberjack.register_tree("ebiomes:siri_tree", "ebiomes:siri_sapling", 3, 3)
    lumberjack.register_tree("ebiomes:tamarind_tree", "ebiomes:tamarind_sapling", 2, 2)
    lumberjack.register_tree("ebiomes:beech_tree", "ebiomes:beech_sapling", 4, 3)
    lumberjack.register_tree("ebiomes:pear_tree", "ebiomes:pear_sapling", 1, 3)
    lumberjack.register_tree("ebiomes:quince_tree", "ebiomes:quince_sapling", 0, 2)
    lumberjack.register_tree("ebiomes:hornbeam_tree", "ebiomes:hornbeam_sapling", 1, 2)
    
    give_initial_stuff.items = {
        "default:axe_wood",
    }
    
    core.clear_craft({output = "multidecor:plaster_lump"})
    minetest.register_craft({
        type = "cooking",
        output = "multidecor:plaster_lump",
        recipe = "techage:clay_powder",
        cooktime = 8
    })
    core.clear_craft({output = "cottages:straw_bale"})
    minetest.register_craft({
        type = "shapeless",
        output = "cottages:straw_bale 2",
        recipe = {
            "farming:straw",
            "farming:straw",
        },
    })
    core.clear_craft({output = "cottages:straw_mat"})
    minetest.register_craft({
        type = "shapeless",
        output = "cottages:straw_mat 6",
        recipe = {
            "cottages:straw_bale",
            "cottages:straw_bale",
        },
    })
    
    minetest.register_craft({
        type = "shapeless",
        output = "moreores:mithril_ingot 9",
        recipe = {
            "moreores:mithril_block",
        },
    })
    minetest.register_craft({
        type = "shapeless",
        output = "moreores:silver_ingot 9",
        recipe = {
            "moreores:silver_block",
        },
    })
    
    techage.furnace.register_recipe({
        output = "default:steel_ingot 4",
        recipe = {"default:coal_lump", "techage:iron_ingot", "techage:iron_ingot", "techage:iron_ingot"},
        time = 4,
    })

end)

--[[core.register_on_joinplayer(function(player)
    player:set_lighting({
        shadows = { intensity = 0.33},
        bloom = { intensity = 0.05 },
        volumetric_light = { strength = 0.2 },
    })
end)]]


core.log("info", "LnD-compat loaded successfully!")
