-- Conversion of other ores to money

if bitchange.use_technic_zinc and minetest.get_modpath("technic_worldgen") then
	minetest.register_craft({
		output = "bitchange:mineninth 8",
		recipe = {
			{"technic:zinc_block", "default:pick_diamond"},
			{"technic:zinc_block", ""}
		},
		replacements = { {"default:pick_diamond", "default:pick_diamond"} }
	})
end

if bitchange.use_quartz and minetest.get_modpath("quartz") then
	minetest.register_craft({
		output = "bitchange:mineninth",
		recipe = {
			{"quartz:quartz_crystal", "default:pick_diamond"},
			{"quartz:quartz_crystal", "quartz:quartz_crystal"},
			{"quartz:quartz_crystal", "quartz:quartz_crystal"}
		},
		replacements = { {"default:pick_diamond", "default:pick_diamond"} }
	})
end

if bitchange.use_moreores_tin then
	bitchange.use_default_tin = true
	minetest.log("warning", "[bitchange] Loaded deprecated setting 'use_default_tin'")
end

if bitchange.use_default_tin then
	minetest.register_craft({
		output = "bitchange:mineninth 18",
		recipe = {
			{"default:tinblock", "default:pick_diamond"},
			{"default:tinblock", ""}
		},
		replacements = { {"default:pick_diamond", "default:pick_diamond"} }
	})
end
