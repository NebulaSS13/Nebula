/obj/machinery/vending/infini
	var/max_purchase_interval = 43200 SECONDS

/obj/machinery/vending/infini/attempt_to_stock(var/obj/item/I, var/mob/user)
	return

/obj/machinery/vending/infini/attackby(obj/item/W, mob/user)
	var/obj/item/card/id/I = W.GetIdCard()

	if (currently_vending && vendor_account && !vendor_account.suspended)
		var/paid = 0
		var/handled = 0

		if (I) //for IDs and PDAs and wallets with IDs
			paid = pay_with_card(I,W)
			handled = 1
		else if (istype(W, /obj/item/charge_card))
			var/obj/item/charge_card/C = W
			paid = pay_with_charge_card(C)
			handled = 1
		else if (istype(W, /obj/item/cash))
			var/obj/item/cash/C = W
			paid = pay_with_cash(C)
			handled = 1

		if(paid)
			vend(currently_vending, usr)
			return TRUE
		else if(handled)
			SSnano.update_uis(src)
			return TRUE // don't smack that machine with your $2

	if (I || istype(W, /obj/item/cash))
		attack_hand(user)
		return TRUE
	if(isMultitool(W) || isWirecutter(W))
		return // REJECT!
	if((user.a_intent == I_HELP) && attempt_to_stock(W, user))
		return TRUE
	if((. = component_attackby(W, user)))
		return
	if((obj_flags & OBJ_FLAG_ANCHORABLE) && isWrench(W))
		return

/obj/machinery/vending/infini/OnTopic(mob/user, href_list, datum/topic_state/state)

	if (href_list["vend"] && vend_ready && !currently_vending)
		var/key = text2num(href_list["vend"])
		if(!is_valid_index(key, product_records))
			return TOPIC_REFRESH
		var/datum/stored_items/vending_products/R = product_records[key]
		if(!istype(R))
			return TOPIC_REFRESH

		// This should not happen unless the request from NanoUI was bad
		if(!(R.category & categories))
			return TOPIC_REFRESH

		if(type in user.mind.infini_purchases && user.mind.infini_purchases[type] + max_purchase_interval > world.time)
			to_chat(user, SPAN_DANGER("Max purchase limit reached for today."))
			return TOPIC_REFRESH

		if(R.price <= 0)
			vend(R, user)
		else if(istype(user,/mob/living/silicon)) //If the item is not free, provide feedback if a synth is trying to buy something.
			to_chat(user, SPAN_DANGER("Artificial unit recognized.  Artificial units cannot complete this transaction.  Purchase canceled."))
		else
			currently_vending = R
			if(!vendor_account || vendor_account.suspended)
				status_message = "This machine is currently unable to process payments due to problems with the associated account."
				status_error = 1
			else
				status_message = "Please swipe a card or insert cash to pay for the item."
				status_error = 0
		return TOPIC_REFRESH

	if(href_list["cancelpurchase"])
		currently_vending = null
		return TOPIC_REFRESH

	// if(href_list["togglevoice"] && panel_open)
	// 	shut_up = !shut_up
	// 	return TOPIC_HANDLED

/obj/machinery/vending/infini/vend(var/datum/stored_items/vending_products/R, mob/user)
	if((!allowed(user)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
		to_chat(user, SPAN_WARNING("Access denied."))//Unless emagged of course
		flick(icon_deny,src)
		return
	vend_ready = 0 //One thing at a time!!
	status_message = "Vending..."
	status_error = 0
	SSnano.update_uis(src)

	do_vending_reply()

	use_power_oneoff(vend_power_usage)	//actuators and stuff
	if (icon_vend) //Show the vending animation if needed
		flick(icon_vend,src)
	addtimer(CALLBACK(src, /obj/machinery/vending/proc/finish_vending, R), vend_delay)
	user.mind.infini_purchases[type] = world.time

/obj/machinery/vending/infini/finish_vending(var/datum/stored_items/vending_products/product)
	set waitfor = FALSE
	if(!product)
		return
	product.get_product(get_turf(src))
	visible_message("\The [src] clunks as it vends \the [product.item_name].")
	playsound(src, 'sound/machines/vending_machine.ogg', 25, 1)
	status_message = ""
	status_error = 0
	vend_ready = 1
	currently_vending = null
	SSnano.update_uis(src)

/obj/machinery/vending/infini/Process()
	return // No process

/obj/machinery/vending/infini/malfunction()
	return // No malfunction

/obj/machinery/vending/infini/build_inventory(populate_parts = FALSE)
	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN)
	)
	for(var/current_list in all_products)
		var/category = current_list[2]
		for(var/entry in current_list[1])
			var/datum/stored_items/vending_products/infini/product = new(src, entry, get_product_name(entry))
			product.price = atom_info_repository.get_combined_worth_for(entry) * markup
			product.category = category
			if(product && populate_parts)
				product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product_records.Add(product)

/datum/mind
	var/infini_purchases = list() // list format is: MACHINE TYPE = world time

/datum/stored_items/vending_products/infini/get_amount()
	return 999

/datum/stored_items/vending_products/infini/get_product(var/product_location)
	if(!get_amount() || !product_location)
		return

	var/atom/movable/product
	if(LAZYLEN(instances))
		product = instances[instances.len]	// Remove the last added product
		LAZYREMOVE(instances, product)
	else
		product = new item_path(storing_object)

	product.forceMove(product_location)
	return product