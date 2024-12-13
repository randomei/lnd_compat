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
    
    give_initial_stuff.items = {
        "default:axe_wood",
    }

end)


core.log("info", "LnD-compat loaded successfully!")
