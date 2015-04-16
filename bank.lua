bitchange.bank = {}
bitchange.bank.players = {}
bitchange.bank.file_path = ""
bitchange.bank.exchange_worth = 0
bitchange.bank.changes_made = false

minetest.after(1, function()
	local file = io.open(bitchange.bank.file_path, "r")
	if not file then
		return
	end
	bitchange.bank.exchange_worth = tonumber(file:read("*l"))
	io.close(file)
end)

function round(num, idp)
	if idp and idp>0 then
		local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end

function bitchange.bank.save()
	if not bitchange.bank.changes_made then
		return
	end
	local file = io.open(bitchange.bank.file_path, "w")
	file:write(tostring(bitchange.bank.exchange_worth))
	io.close(file)
	bitchange.bank.changes_made = false
end


local ttime = 0
minetest.register_globalstep(function(t)
	ttime = ttime + t
	if ttime < 240 then --every 4min'
			return
	end
	bitchange.bank.save()
	ttime = 0
end)

minetest.register_on_shutdown(function() 
	bitchange.bank.save()
end)

minetest.register_node("bitchange:bank", {
	description = "Bank",
	tiles = {"bitchange_bank_side.png", "bitchange_bank_side.png",
			 "bitchange_bank_side.png", "bitchange_bank_side.png",
			 "bitchange_bank_side.png", "bitchange_bank_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=1,level=1},
	sounds = default.node_sound_stone_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("infotext", "Bank (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Bank (constructing)")
		meta:set_string("formspec", "")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("coins", 8*3)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		if meta:get_string("owner") == player:get_player_name() then
			return meta:get_inventory():is_empty("coins")
		else
			return false
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack)
		local player_name = clicker:get_player_name()
		local view = 1
		bitchange.bank.players[player_name] = pos
		if clicker:get_player_control().aux1 then
			view = 2
		end
		minetest.show_formspec(player_name, "bitchange:bank_formspec", bitchange.bank.get_formspec(view, pos))
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if bitchange.has_access(meta:get_string("owner"), player:get_player_name()) then
			return count
		end
		return 0
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if bitchange.has_access(meta:get_string("owner"), player:get_player_name()) then
			return stack:get_count()
		end
		return 0
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if bitchange.has_access(meta:get_string("owner"), player:get_player_name()) then
			return stack:get_count()
		end
		return 0
	end,
})