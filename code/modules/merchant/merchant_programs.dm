/datum/computer_file/program/merchant
	filename = "mlist"
	filedesc = "Merchant's List"
	extended_desc = "Allows communication and trade between vessels and trade hubs."
	program_icon_state = "comm"
	program_menu_icon = "cart"
	nanomodule_path = /datum/nano_module/program/merchant
	size = 12
	usage_flags = PROGRAM_CONSOLE
	required_access = list(access_merchant)
	var/datum/trade_hub/current_hub
	var/datum/trader/current_trader
	var/obj/machinery/merchant_pad/pad = null
	var/show_trades = 0
	var/hailed_merchant = 0
	var/last_comms = null
	var/temp = null
	var/bank = 0 //A straight up money till

/datum/computer_file/program/merchant/proc/get_current_hub(var/datum/trade_hub/supplied_hub)
	if(supplied_hub)
		current_hub = supplied_hub
	if(!istype(current_hub) || QDELETED(current_hub) || !current_hub.is_accessible_from(get_turf(holder)))
		current_hub = null
		current_trader = null
	return current_hub

/datum/computer_file/program/merchant/proc/get_current_trader()
	var/datum/trade_hub/hub = get_current_hub()
	if(QDELETED(hub) || QDELETED(current_trader) || (current_trader && !(current_trader in hub.traders)))
		current_trader = null
	return current_trader

/datum/computer_file/program/merchant/Destroy()
	current_hub = null
	current_trader = null
	. = ..()

/datum/computer_file/program/merchant/proc/get_available_hubs()
	. = list()
	var/turf/T = get_turf(holder)
	for(var/datum/trade_hub/hub in SStrade.trade_hubs)
		if(hub.is_accessible_from(T))
			. |= hub

/datum/nano_module/program/merchant
	name = "Merchant's List"

/datum/nano_module/program/merchant/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/show_trade = 0
	var/hailed = 0
	var/datum/trader/T
	if(program)
		var/datum/computer_file/program/merchant/P = program
		T = P.get_current_trader()
		data["temp"] = P.temp
		data["mode"] = !isnull(T)
		data["last_comms"] = P.last_comms
		data["pad"] = !!P.pad
		data["bank"] = P.bank
		show_trade = P.show_trades
		hailed = P.hailed_merchant
		var/list/hub_data = list()
		for(var/datum/trade_hub/hub in P.get_available_hubs())
			hub_data += list(list("name" = hub.name, "ref" = "\ref[hub]"))
		data["hubs"] = hub_data
	data["mode"] = !!T
	if(T)
		data["traderName"] = T.name
		data["origin"]     = T.origin
		data["hailed"]     = hailed
		if(show_trade)
			var/list/trades = list()
			if(T.trading_items.len)
				for(var/i in 1 to T.trading_items.len)
					trades += T.print_trading_items(i)
			data["trades"] = trades

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "merchant.tmpl", "Merchant List", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/computer_file/program/merchant/proc/connect_pad()
	for(var/obj/machinery/merchant_pad/P in orange(1,get_turf(computer)))
		pad = P
		return

/datum/computer_file/program/merchant/proc/test_fire()
	if(pad && pad.get_target())
		return 1
	return 0

/datum/computer_file/program/merchant/proc/offer_money(var/datum/trader/T, var/num, skill)
	if(pad)
		var/response = T.offer_money_for_trade(num, bank, skill)
		if(istext(response))
			last_comms = T.get_response(response, "No thank you.")
		else
			last_comms = T.get_response("trade_complete", "Thank you!")
			T.trade(null,num, get_turf(pad))
			bank -= response
		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/bribe(var/datum/trader/T, var/amt)
	if(bank < amt)
		last_comms = "ERROR: NOT ENOUGH FUNDS."
		return

	bank -= amt
	last_comms = T.bribe_to_stay_longer(amt)

/datum/computer_file/program/merchant/proc/offer_item(var/datum/trader/T, var/num, skill)
	if(pad)
		var/list/targets = pad.get_targets()
		for(var/target in targets)
			if(!computer_emagged && istype(target,/mob/living/carbon/human))
				last_comms = "SAFETY LOCK ENABLED: SENTIENT MATTER UNTRANSMITTABLE"
				return
		var/response = T.offer_items_for_trade(targets,num, get_turf(pad), skill)
		if(istext(response))
			last_comms = T.get_response(response,"No, a million times no.")
		else
			last_comms = T.get_response("trade_complete","Thanks for your business!")

		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/sell_items(var/datum/trader/T, skill)
	if(pad)
		var/list/targets = pad.get_targets()
		var/response = T.sell_items(targets, skill)
		if(istext(response))
			last_comms = T.get_response(response, "Nope. Nope nope nope.")
		else
			last_comms = T.get_response("trade_complete", "Glad to be of service!")
			bank += response
		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/transfer_to_bank()
	if(pad)
		var/list/targets = pad.get_targets()
		for(var/target in targets)
			if(istype(target, /obj/item/cash))
				var/obj/item/cash/cash = target
				bank += cash.absolute_worth
				qdel(target)
		last_comms = "ALL MONEY DETECTED ON PAD TRANSFERED"
		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/get_money()
	if(!pad)
		last_comms = "PAD NOT CONNECTED. CANNOT TRANSFER"
		return
	var/turf/T = get_turf(pad)
	var/obj/item/cash/B = new(T)
	B.adjust_worth(bank)
	bank = 0

/datum/computer_file/program/merchant/Topic(href, href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(href_list["PRG_connect_pad"])
		. = 1
		connect_pad()
	if(href_list["PRG_continue"])
		. = 1
		temp = null
	if(href_list["PRG_transfer_to_bank"])
		. = 1
		transfer_to_bank()
	if(href_list["PRG_get_money"])
		. = 1
		get_money()
	if(href_list["PRG_main_menu"])
		. = 1
		current_trader = null
		current_hub = null

	if(href_list["PRG_merchant_list"])
		. = 1
		current_trader = null
		current_hub = get_current_hub(locate(href_list["PRG_merchant_list"]))
		if(current_hub && length(current_hub.traders))
			current_trader = current_hub.traders[1]
			last_comms = null
			hailed_merchant = FALSE
		else
			temp = "There are no available traders at the target hub, or the target hub has moved out of range."

	if(href_list["PRG_test_fire"])
		. = 1
		if(test_fire())
			temp = "Test fire successful."
		else
			temp = "Test fire unsuccessful."
	if(href_list["PRG_scroll"])
		. = 1
		var/datum/trader/T = get_current_trader()
		if(T)
			var/new_merchant = (href_list["PRG_scroll"] == "right") ? next_in_list(T, current_hub.traders) : previous_in_list(T, current_hub.traders)
			if(new_merchant != T)
				hailed_merchant = 0
				last_comms = null
				current_trader = new_merchant
	var/datum/trader/T = get_current_trader()
	if(T)
		if(!T.can_hail())
			last_comms = T.get_response("hail_deny", "No, I'm not speaking with you.")
			. = 1
		else
			if(href_list["PRG_hail"])
				. = 1
				last_comms = T.hail(user)
				show_trades = 0
				hailed_merchant = 1
			if(href_list["PRG_show_trades"])
				. = 1
				show_trades = !show_trades
			if(href_list["PRG_insult"])
				. = 1
				last_comms = T.insult()
			if(href_list["PRG_compliment"])
				. = 1
				last_comms = T.compliment()
			if(href_list["PRG_offer_item"])
				. = 1
				offer_item(T,text2num(href_list["PRG_offer_item"]) + 1, user.get_skill_value(SKILL_FINANCE))
			if(href_list["PRG_how_much_do_you_want"])
				. = 1
				last_comms = T.how_much_do_you_want(text2num(href_list["PRG_how_much_do_you_want"]) + 1, user.get_skill_value(SKILL_FINANCE))
			if(href_list["PRG_offer_money_for_item"])
				. = 1
				offer_money(T, text2num(href_list["PRG_offer_money_for_item"])+1, user.get_skill_value(SKILL_FINANCE))
			if(href_list["PRG_what_do_you_want"])
				. = 1
				last_comms = T.what_do_you_want()
			if(href_list["PRG_sell_items"])
				. = 1
				sell_items(T, user.get_skill_value(SKILL_FINANCE))
			if(href_list["PRG_bribe"])
				. = 1
				bribe(T, text2num(href_list["PRG_bribe"]))