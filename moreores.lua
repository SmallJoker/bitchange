--Created by Krock
--License: WTFPL

if(bitchange_use_moreores_tin) then
if(minetest.get_modpath("moreores")) then
	minetest.register_craft({
		output = "bitchange:coinbase 18",
		recipe = {
			{"moreores:tin_block", "default:pick_diamond"},
			{"moreores:tin_block", ""}
		},
		replacements = { {"default:pick_diamond", "default:pick_diamond"} },
	})
else
	print("[BitChange] Error: tin support disabled, missing mod: 'moreores'"
end
end

if(bitchange_use_technic_zinc) then
if(minetest.get_modpath("technic_worldgen")) then
	minetest.register_craft({
		output = "bitchange:coinbase 8",
		recipe = {
			{"technic:zinc_block", "default:pick_diamond"},
			{"technic:zinc_block", ""}
		},
		replacements = { {"default:pick_diamond", "default:pick_diamond"} },
	})
else
	print("[BitChange] Warning: zinc support disabled, missing mod: 'technic_worldgen'"
end
end

if(bitchange_use_quartz) then
if(minetest.get_modpath("quartz")) then
	minetest.register_craft({
		output = "bitchange:coinbase",
		recipe = {
			{"quartz:quartz_crystal", "default:pick_diamond"},
			{"quartz:quartz_crystal", "quartz:quartz_crystal"},
			{"quartz:quartz_crystal", "quartz:quartz_crystal"}
		},
		replacements = { {"default:pick_diamond", "default:pick_diamond"} },
	})
else
	print("[BitChange] Error: quartz support disabled, missing mod: 'quartz'"
end
end