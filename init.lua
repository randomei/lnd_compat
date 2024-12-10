minetest.register_on_mods_loaded(function()
    xcompat.materials.slab_stone = 'default:slab_stone_8'
    xcompat.materials.steel_bar = 'basic_materials:steel_bar'
    xcompat.materials.plastic_sheet = 'basic_materials:plastic_sheet'
    minetest.register_alias("oil:oil", "techage:oil")
    minetest.register_alias("oil:oil_source", "techage:oil_source")
    minetest.register_alias("oil:oil_flowing", "techage:oil_flowing")
    minetest.register_alias("oil:oil_bucket", "techage:bucket_oil")
    minetest.register_alias("mesecraft_mobs:bone", "bonemeal:bone")

    minetest.clear_craft({output = "x_enchanting:grindstone"})

    minetest.register_craft({
        output = 'x_enchanting:grindstone',
        recipe = {
            { 'group:stick', xcompat.materials.slab_stone, 'group:stick' },
            { 'group:wood', '', 'group:wood' }
        }
    })

    minetest.register_craft({
        type = "cooking",
        output = "multidecor:wax_lump",
        recipe = "bees:wax",
        cooktime = 10
    })
    
    give_initial_stuff.items = {
        "default:axe_wood",
    }

end)


minetest.log("info", "LnD-compat loaded successfully!")
