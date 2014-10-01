-- Bank node for the mod: money (by kotolegokot)

-- default worth in "money" for one MineCoin
bitchange.bank.exchange_worth = 70.0

function bitchange.bank.get_formspec(number, pos)
	local formspec = ""
	local name = "nodemeta:"..pos.x..","..pos.y..","..pos.z
	if number == 1 then
		-- customer
		formspec = ("size[8,8]"..
				"label[0,0;Bank]"..
				"label[2,0;View reserve with (E) + (Right click)]"..
				"label[1,1;Current worth of a MineCoin:]"..
				"label[3,1.5;~ "..round(bitchange.bank.exchange_worth, 4).." money]"..
				"button[2,3;3,1;sell10;Buy 10 MineCoins]"..
				"button[2,2;3,1;buy10;Sell 10 MineCoins]"..
				"list[current_player;main;0,4;8,4;]")
	elseif number == 2 then
		-- owner
		formspec = ("size[8,9;]"..
				"label[0,0;Bank]"..
				"label[1,0.5;Current MineCoin reserve: (editable by owner)]"..
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
	local err_msg = false
	
	if fields.buy10 then
		local new_worth = bitchange.bank.exchange_worth / 1.0059
		if not player_inv:contains_item("main", coin_stack) then
			err_msg = "You do not have the needed MineCoins."
		end
		if not err_msg == "" then
			if not bank_inv:room_for_item("coins", coin_stack) then
				err_msg = "This bank has no space to buy more MineCoins."
			end
		end
		if not err_msg == "" then
			bitchange.bank.exchange_worth = bitchange.bank.exchange_worth / 1.0059
			local price = round(bitchange.bank.exchange_worth - 0.1, 1) * 10
			local cur_money = money.get_money(player_name)
			money.set_money(player_name, cur_money + price)
			player_inv:remove_item("main", coin_stack)
			bank_inv:add_item("coins", coin_stack)
			bitchange.bank.changes_made = true
			err_msg = "Sold 10 MineCoins for "..price.." money"
		end
	elseif fields.sell10 then
		local price = round(bitchange.bank.exchange_worth, 1) * 10
		local cur_money = money.get_money(player_name)
		if cur_money < price  then
			err_msg = "You do not have the required money. ("..price.." money)"
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
			money.set_money(player_name, cur_money - price)
			bank_inv:remove_item("coins", coin_stack)
			player_inv:add_item("main", coin_stack)
			bitchange.bank.exchange_worth = bitchange.bank.exchange_worth * 1.006
			bitchange.bank.changes_made = true
			err_msg = "Bought 10 MineCoins for "..price.." money"
		end
	end
	if err_msg then
		minetest.chat_send_player(player_name, "Bank: "..err_msg)
	end
end)