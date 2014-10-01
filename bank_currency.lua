-- Bank node for the mod: currency (by Dan Duncombe)

-- default worth in "money" for 10 MineCoins
bitchange.bank.exchange_worth = 8

function bitchange.bank.get_formspec(number, pos)
	local formspec = ""
	local name = "nodemeta:"..pos.x..","..pos.y..","..pos.z
	if number == 1 then
		-- customer
		formspec = ("size[8,8]"..
				"label[0,0;Bank]"..
				"label[2,0;View reserve with (E) + (Right click)]"..
				"label[1,1;Current worth of a MineCoin:]"..
				"label[3,1.5;~ "..round(bitchange.bank.exchange_worth / 10, 2).." MineGeld]"..
				"button[2,3;3,1;sell10;Buy 10 MineCoins]"..
				"button[2,2;3,1;buy10;Sell 10 MineCoins]"..
				"list[current_player;main;0,4;8,4;]")
	elseif number == 2 then
		-- owner
		formspec = ("size[8,9;]"..
				"label[0,0;Bank]"..
				"label[1,0.5;Current MineCoin and MineGeld reserve: (editable by owner)]"..
				"list["..name..";coins;0,1;8,3;]"..
				"list[current_player;main;0,5;8,4;]")
	end
	return formspec
end

minetest.register_on_player_receive_fields(function(sender, formname, fields)
	if formname ~= "bitchange:bank_formspec" then
		return
	end
	local player_name = sender:get_player_name()
	if fields.quit then
		bitchange.bank.players[player_name] = nil
		return
	end
	if bitchange.bank.exchange_worth < 1 then
		bitchange.bank.exchange_worth = 1
	end
	local pos = bitchange.bank.players[player_name]
	local bank_inv = minetest.get_meta(pos):get_inventory()
	local player_inv = sender:get_inventory()
	local coin_stack = "bitchange:minecoin 10"
	local geld_stack = "currency:minegeld "
	local err_msg = false
	
	if fields.buy10 then
		local new_worth = bitchange.bank.exchange_worth * 0.995
		geld_stack = geld_stack..math.floor(new_worth + 0.5)
		if not player_inv:contains_item("main", coin_stack) then
			err_msg = "You do not have the needed MineCoins."
		end
		if not err_msg == "" then
			if not bank_inv:room_for_item("coins", coin_stack) then
				err_msg = "This bank has no space to buy more MineCoins."
			end
		end
		if not err_msg == "" then
			if not bank_inv:contains_item("coins", geld_stack) then
				err_msg = "This bank has no MineGeld ready to sell."
			end
		end
		if not err_msg == "" then
			if not player_inv:room_for_item("main", geld_stack) then
				err_msg = "You do not have enough space in your inventory."
			end
		end
		if not err_msg == "" then
			bitchange.bank.exchange_worth = new_worth
			bank_inv:remove_item("coins", geld_stack)
			player_inv:add_item("main", geld_stack)
			player_inv:remove_item("main", coin_stack)
			bank_inv:add_item("coins", coin_stack)
			bitchange.bank.changes_made = true
			err_msg = "Sold 10 MineCoins for "..math.floor(new_worth + 0.5).." MineGeld"
		end
	elseif fields.sell10 then
		local price = math.floor(bitchange.bank.exchange_worth + 0.5)
		geld_stack = geld_stack..price
		if not player_inv:contains_item("main", geld_stack) then
			err_msg = "You do not have the required money. ("..price.." x 1 MineGeld pieces)"
		end
		if not err_msg == "" then
			if not bank_inv:room_for_item("coins", geld_stack) then
				err_msg = "This bank has no space to buy more MineGeld."
			end
		end
		if not err_msg == "" then
			if not bank_inv:contains_item("coins", coin_stack) then
				err_msg = "This bank has no MineCoins ready to sell."
			end
		end
		if not err_msg == "" then
			if not player_inv:room_for_item("main", coin_stack) then
				err_msg = "You do not have enough space in your inventory."
			end
		end
		if not err_msg == "" then
			player_inv:remove_item("main", geld_stack)
			bank_inv:add_item("coins", geld_stack)
			bank_inv:remove_item("coins", coin_stack)
			player_inv:add_item("main", coin_stack)
			bitchange.bank.exchange_worth = bitchange.bank.exchange_worth * 1.005
			bitchange.bank.changes_made = true
			err_msg = "Bought 10 MineCoins for "..price.." MineGeld"
		end
	end
	if err_msg then
		minetest.chat_send_player(player_name, "Bank: "..err_msg)
	end
end)
