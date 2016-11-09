--bitcoins by MilesDyson@DistroGeeks.com
--Modified by Krock
--License: WTFPL

-- Node definitions
minetest.register_node("bitchange:minecoin_in_ground", {
	description = "MineCoin Ore",
	tiles = { "default_stone.png^bitchange_minecoin_in_ground.png" },
	is_ground_content = true,
	groups = {cracky=2},
	sounds = default.node_sound_stone_defaults(),
	drop = {
		max_items = 2,
		items = {
			{items = {"bitchange:minecoin"}, rarity = 2 },
			{items = {"bitchange:minecoin 3"} }
		}
	},
})

minetest.register_node("bitchange:mineninth_in_ground", {
	description = "MineNinth Ore",
	tiles = { "default_stone.png^bitchange_mineninth_in_ground.png" },
	is_ground_content = true,
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	drop = {
		max_items = 3,
		items = {
			{items = {"bitchange:coinbase"}, rarity = 5 },
			{items = {"bitchange:coinbase 2"}, rarity = 3 },
			{items = {"bitchange:coinbase 6"} }
		}
	},
})

minetest.register_node("bitchange:minecoinblock", {
	description = "MineCoin Block",
	tiles = { "bitchange_minecoinblock.png" },
	is_ground_content = true,
	groups = {cracky=2},
	sounds = default.node_sound_stone_defaults(),
	stack_max = 30000,
})

minetest.register_craftitem("bitchange:minecoin", {
	description = "MineCoin",
	inventory_image = "bitchange_minecoin.png",
	stack_max = 30000,
})

minetest.register_craftitem("bitchange:mineninth", {
	description = "MineNinth",
	inventory_image = "bitchange_mineninth.png",
	stack_max = 30000,
})

minetest.register_craftitem("bitchange:coinbase", {
	description = "Coin base",
	inventory_image = "bitchange_coinbase.png",
})

-- Crafting
minetest.register_craft({
	output = "bitchange:minecoinblock",
	recipe = {
		{"bitchange:minecoin", "bitchange:minecoin", "bitchange:minecoin"},
		{"bitchange:minecoin", "bitchange:minecoin", "bitchange:minecoin"},
		{"bitchange:minecoin", "bitchange:minecoin", "bitchange:minecoin"},
	}
})

minetest.register_craft({
	output = "bitchange:minecoin 9",
	recipe = {
		{"bitchange:minecoinblock"},
	}
})

minetest.register_craft({
	output = "bitchange:minecoin",
	recipe = {
		{"bitchange:mineninth", "bitchange:mineninth", "bitchange:mineninth"},
		{"bitchange:mineninth", "bitchange:mineninth", "bitchange:mineninth"},
		{"bitchange:mineninth", "bitchange:mineninth", "bitchange:mineninth"},
	}
})

minetest.register_craft({
	output = "bitchange:mineninth 9",
	recipe = {
		{"bitchange:minecoin"},
	}
})

-- Cooking
minetest.register_craft({
	type = "cooking",
	recipe = "bitchange:coinbase",
	output = "bitchange:mineninth",
})

minetest.register_craft({
	type = "cooking",
	recipe = "default:goldblock",
	output = "bitchange:minecoinblock 2",
})

minetest.register_craft({
	type = "cooking",
	recipe = "bitchange:minecoinblock",
	output = "default:gold_ingot 4",
})

-- Generation
if bitchange.enable_generation then
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "bitchange:minecoin_in_ground",
	wherein        = "default:stone",
	clust_scarcity = 15*15*15,
	clust_num_ores = 3,
	clust_size     = 7,
	y_max          = -512,
	y_min          = -18000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "bitchange:mineninth_in_ground",
	wherein        = "default:stone",
	clust_scarcity = 12*12*12,
	clust_num_ores = 5,
	clust_size     = 8,
	y_max          = -256,
	y_min          = -511,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "bitchange:mineninth_in_ground",
	wherein        = "default:stone",
	clust_scarcity = 13*13*13,
	clust_num_ores = 3,
	clust_size     = 7,
	y_max          = 28000,
	y_min          = -255,
})
end
