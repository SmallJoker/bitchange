--Created by Krock for the BitChange mod
local mod_path = minetest.get_modpath("bitchange")

dofile(mod_path.."/config.txt")
dofile(mod_path.."/minecoins.lua")
if(bitchange_use_moreores_tin or bitchange_use_technic_zinc or bitchange_use_gold) then
	dofile(mod_path.."/moreores.lua")
end
if(bitchange_enable_exchangeshop) then
	dofile(mod_path.."/shop.lua")
end
if(bitchange_enable_moneychanger) then
	dofile(mod_path.."/moneychanger.lua")
end
if(bitchange_enable_warehouse) then
	dofile(mod_path.."/warehouse.lua")
end
if(bitchange_enable_toolrepair) then
	dofile(mod_path.."/toolrepair.lua")
end
if(bitchange_enable_bank) then
	local loaded_bank = ""
	if(minetest.get_modpath("money") ~= nil) then
		loaded_bank = "money"
		dofile(mod_path.."/bank_"..loaded_bank..".lua")
	elseif(minetest.get_modpath("money2") ~= nil) then
		loaded_bank = "money2"
		dofile(mod_path.."/bank_"..loaded_bank..".lua")
	elseif(minetest.get_modpath("currency") ~= nil) then
		loaded_bank = "currency"
		dofile(mod_path.."/bank_"..loaded_bank..".lua")
	end
	if(loaded_bank ~= "") then
		print("[BitChange] Bank loaded: "..loaded_bank)
	end
end

if(not minetest.setting_getbool("creative_mode") and bitchange_initial_give > 0) then
	-- Giving initial money
	minetest.register_on_newplayer(function(player)
		player:get_inventory():add_item("main", "bitchange:mineninth "..bitchange_initial_give)
	end)
end

-- Privs
minetest.register_privilege("bitchange", "Can access to owned nodes of the bitchange mod")
function bitchange_has_access(owner, player_name)
	return (player_name == owner or minetest.get_player_privs(player_name).server or minetest.get_player_privs(player_name).bitchange)
end

print("[BitChange] Loaded.")