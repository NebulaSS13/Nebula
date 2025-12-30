/**
 *  A vending machine
 */
/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/machines/vending/generic.dmi'
	icon_state = ICON_STATE_WORLD
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	clicksound = "button"
	clickvol = 40
	base_type = /obj/machinery/vending/assist
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	idle_power_usage = 10
	emagged = 0 //Ignores if somebody doesn't have card access to that machine.
	wires = /datum/wires/vending
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES

	// Power
	var/vend_power_usage = 150 //actuators and stuff

	// Vending-related
	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 10 //How long does it take to vend?
	var/categories = CAT_NORMAL // Bitmask of cats we're currently showing
	var/datum/stored_items/vending_products/currently_vending = null // What we're requesting payment for right now
	var/status_message = "" // Status screen messages like "insufficient funds", displayed in NanoUI
	var/status_error = 0 // Set to 1 if status_message is an error

	/*
		Variables used to initialize the product list
		These are used for initialization only, and so are optional if
		product_records is specified
	*/
	var/markup
	var/list/products	= list() // For each, use the following pattern:
	var/list/contraband	= list() // list(/type/path = amount,/type/path2 = amount2)

	// List of vending_product items available.
	var/list/product_records = list()

	// Variables used to initialize advertising
	var/product_slogans = "" //String of slogans spoken out loud, separated by semicolons
	var/product_ads = "" //String of small ad messages in the vending screen

	var/list/ads_list = list()

	// Stuff relating vocalizations
	var/list/slogan_list = list()
	var/shut_up = 1 //Stop spouting those godawful pitches!
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 6000 //How long until we can pitch again?

	// Things that can go wrong
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!
	var/shooting_chance = 2 //The chance that items are being shot per tick

	var/vendor_currency
	var/scan_id = 1

/obj/machinery/vending/Initialize(mapload, d=0, populate_parts = TRUE)
	..()
	if(isnull(markup))
		markup = 1.1 + (rand() * 0.4)
	if(!ispath(vendor_currency, /decl/currency))
		vendor_currency = global.using_map.default_currency
	if(product_slogans)
		slogan_list += splittext(product_slogans, ";")

		// So not all machines speak at the exact same time.
		// The first time this machine says something will be at slogantime + this random value,
		// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
		last_slogan = world.time + rand(0, slogan_delay)

	if(product_ads)
		ads_list += splittext(product_ads, ";")

	build_inventory(populate_parts)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/vending/LateInitialize()
	..()
	update_icon()

/**
 *  Build produdct_records from the products lists
 *
 *  products and contraband lists allow specifying products that
 *  the vending machine is to carry without manually populating
 *  product_records.
 */

/obj/machinery/vending/proc/build_inventory(populate_parts = FALSE)
	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN)
	)
	for(var/current_list in all_products)
		var/category = current_list[2]
		for(var/entry in current_list[1])
			var/datum/stored_items/vending_products/product = new(src, entry)
			product.price = ceil(atom_info_repository.get_combined_worth_for(entry) * markup)
			product.category = category
			if(product && populate_parts)
				product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			if(ispath(product.item_path, /obj/item/stack/material))
				var/obj/item/stack/material/M = product.item_path
				var/decl/material/mat = GET_DECL(initial(M.material))
				if(mat)
					var/mat_amt = initial(M.amount)
					product.item_name = "[mat.solid_name] [mat_amt == 1 ? initial(M.singular_name) : initial(M.plural_name)] ([mat_amt]x)"
			product_records.Add(product)

/obj/machinery/vending/Destroy()
	for(var/datum/stored_items/vending_products/product_record in product_records)
		qdel(product_record)
	product_records = null
	return ..()

/obj/machinery/vending/explosion_act(severity)
	..()
	if(!QDELETED(src))
		if(severity == 1 || (severity == 2 && prob(50)))
			qdel(src)
		else if(prob(25))
			malfunction()

/obj/machinery/vending/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		emagged = 1
		req_access.Cut()
		to_chat(user, "You short out the product lock on \the [src].")
		return 1

/obj/machinery/vending/receive_mouse_drop(atom/dropping, mob/user, params)
	if(!(. = ..()) && isitem(dropping) && istype(user) && user.check_intent(I_FLAG_HELP) && CanPhysicallyInteract(user))
		return attempt_to_stock(dropping, user)

/obj/machinery/vending/attackby(obj/item/used_item, mob/user)

	var/obj/item/charge_stick/CS = used_item.GetChargeStick()
	if (currently_vending && vendor_account && !vendor_account.suspended)

		if(!vend_ready)
			to_chat(user, SPAN_WARNING("\The [src] is vending a product, wait a second!"))
			return TRUE

		var/paid = 0
		var/handled = 0

		if (CS)
			paid = pay_with_charge_card(CS)
			handled = 1
		else if (istype(used_item, /obj/item/cash))
			var/obj/item/cash/C = used_item
			paid = pay_with_cash(C)
			handled = 1

		if(paid)
			vend(currently_vending, usr)
			return TRUE
		else if(handled)
			SSnano.update_uis(src)
			return TRUE // don't smack that machine with your $2

	if (istype(used_item, /obj/item/cash))
		attack_hand_with_interaction_checks(user)
		return TRUE

	if(IS_MULTITOOL(used_item) || IS_WIRECUTTER(used_item))
		if(panel_open)
			attack_hand_with_interaction_checks(user)
			return TRUE

	if((. = component_attackby(used_item, user)))
		return

	if((user.check_intent(I_FLAG_HELP)) && attempt_to_stock(used_item, user))
		return TRUE

	return ..() // handle anchoring and bashing

/obj/machinery/vending/state_transition(decl/machine_construction/new_state)
	. = ..()
	SSnano.update_uis(src)

/obj/machinery/vending/proc/attempt_to_stock(var/obj/item/I, var/mob/user)
	for(var/datum/stored_items/vending_products/product_record in product_records)
		if(I.type == product_record.item_path)
			stock(I, product_record, user)
			return 1

/**
 *  Receive payment with cashmoney.
 */
/obj/machinery/vending/proc/pay_with_cash(var/obj/item/cash/cashmoney)
	if(currently_vending.price > cashmoney.absolute_worth)
		// This is not a status display message, since it's something the character
		// themselves is meant to see BEFORE putting the money in
		to_chat(usr, SPAN_WARNING("[html_icon(cashmoney)] That is not enough money."))
		return 0
	visible_message(SPAN_INFO("\The [usr] inserts some cash into \the [src]."))
	cashmoney.adjust_worth(-(currently_vending.price))
	// Vending machines have no idea who paid with cash
	credit_purchase("(cash)")
	return 1

/**
 * Scan a chargecard and deduct payment from it.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed.
 */
/obj/machinery/vending/proc/pay_with_charge_card(var/obj/item/charge_stick/wallet)
	visible_message(SPAN_INFO("\The [usr] plugs \the [wallet] into \the [src]."))
	if(wallet.is_locked())
		status_message = "Unlock \the [wallet] before using it."
		status_error = TRUE
	else if(currently_vending.price > wallet.loaded_worth)
		status_message = "Insufficient funds on \the [wallet]."
		status_error = TRUE
	else
		wallet.adjust_worth(-(currently_vending.price))
		credit_purchase("[wallet.id]")
		return TRUE
	if(status_message && status_error)
		to_chat(usr, SPAN_WARNING(status_message))
	return FALSE


/**
 *  Add money for current purchase to the vendor account.
 *
 *  Called after the money has already been taken from the customer.
 */
/obj/machinery/vending/proc/credit_purchase(var/target as text)
	vendor_account.deposit(currently_vending.price, "Purchase of [currently_vending.item_name]", target)

/obj/machinery/vending/physical_attack_hand(mob/user)
	if(seconds_electrified != 0)
		if(shock(user, 100))
			return TRUE
	return FALSE

/obj/machinery/vending/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/vending/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)
	var/decl/currency/cur = GET_DECL(vendor_currency)
	var/list/data = list()
	if(currently_vending)
		data["mode"] = 1
		data["product"] = currently_vending.item_name
		data["price"] = cur.format_value(currently_vending.price)
		data["price_num"] = floor(currently_vending.price / cur.absolute_value)
		data["message"] = status_message
		data["message_err"] = status_error
	else
		data["mode"] = 0
		var/list/listed_products = list()

		for(var/key = 1 to product_records.len)
			var/datum/stored_items/vending_products/I = product_records[key]

			if(!(I.category & categories))
				continue

			listed_products.Add(list(list(
				"key" =    key,
				"name" =   I.item_name,
				"price" =  cur.format_value(I.price),
				"price_num" = floor(I.price / cur.absolute_value),
				"color" =  I.display_color,
				"amount" = I.get_amount())))

		data["products"] = listed_products

	if(panel_open)
		data["panel"] = 1
		data["speaker"] = shut_up ? 0 : 1
	else
		data["panel"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "vending_machine.tmpl", name, 520, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/vending/OnTopic(mob/user, href_list, datum/topic_state/state)

	if (href_list["vend"] && !currently_vending)
		var/key = text2num(href_list["vend"])
		var/datum/stored_items/vending_products/product_record = LAZYACCESS(product_records, key)
		if(!product_record)
			return TOPIC_REFRESH

		// This should not happen unless the request from NanoUI was bad
		if(!(product_record.category & categories))
			return TOPIC_REFRESH

		if(product_record.price <= 0)
			vend(product_record, user)
		else if(issilicon(user)) //If the item is not free, provide feedback if a synth is trying to buy something.
			to_chat(user, SPAN_DANGER("Artificial unit recognized.  Artificial units cannot complete this transaction.  Purchase canceled."))
		else
			currently_vending = product_record
			if(!vendor_account || vendor_account.suspended)
				status_message = "This machine is currently unable to process payments due to problems with the associated account."
				status_error = 1
			else
				status_message = "Please insert cash or a credstick to pay for the product."
				status_error = 0
		return TOPIC_REFRESH

	if(href_list["cancelpurchase"])
		currently_vending = null
		return TOPIC_REFRESH

	if(href_list["togglevoice"] && panel_open)
		shut_up = !shut_up
		return TOPIC_HANDLED

/obj/machinery/vending/get_req_access()
	if(!scan_id)
		return list()
	return ..()

/obj/machinery/vending/proc/vend(var/datum/stored_items/vending_products/product_record, mob/user)
	if(!vend_ready)
		return
	if((!allowed(user)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
		to_chat(user, SPAN_WARNING("Access denied."))//Unless emagged of course
		var/deny_state = "[icon_state]-deny"
		if(check_state_in_icon(deny_state, icon))
			flick(deny_state, src)
		return

	vend_ready = 0 //One thing at a time!!
	status_message = "Vending..."
	status_error = 0
	SSnano.update_uis(src)

	do_vending_reply()

	use_power_oneoff(vend_power_usage)	//actuators and stuff
	var/vend_state = "[icon_state]-vend"
	if (check_state_in_icon(vend_state, icon)) //Show the vending animation if needed
		flick(vend_state, src)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/vending, finish_vending), product_record), vend_delay)

/obj/machinery/vending/proc/do_vending_reply()
	set waitfor = FALSE
	if(vend_reply && last_reply + vend_delay + 200 <= world.time)
		speak(vend_reply)
		last_reply = world.time

/obj/machinery/vending/proc/finish_vending(var/datum/stored_items/vending_products/product)
	set waitfor = FALSE
	if(!product)
		return
	product.get_product(get_turf(src))
	visible_message("\The [src] clunks as it vends \the [product.item_name].")
	playsound(src, 'sound/machines/vending_machine.ogg', 25, 1)
	if(prob(1)) //The vending gods look favorably upon you
		sleep(3)
		if(product.get_product(get_turf(src)))
			visible_message(SPAN_NOTICE("\The [src] clunks as it vends an additional [product.item_name]."))
	status_message = ""
	status_error = 0
	vend_ready = 1
	currently_vending = null
	SSnano.update_uis(src)

/**
 * Add item to the machine
 *
 * Checks if item is vendable in this machine should be performed before
 * calling. used_item is the item being inserted, product_record is the associated vending_product entry.
 */
/obj/machinery/vending/proc/stock(obj/item/used_item, var/datum/stored_items/vending_products/product_record, var/mob/user)
	if(!user.try_unequip(used_item))
		return

	if(product_record.add_product(used_item))
		to_chat(user, SPAN_NOTICE("You insert \the [used_item] in the product receptor."))
		SSnano.update_uis(src)
		return 1

	SSnano.update_uis(src)

/obj/machinery/vending/Process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!active)
		return

	if(seconds_electrified > 0)
		seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(((last_slogan + slogan_delay) <= world.time) && (slogan_list.len > 0) && (!shut_up) && prob(5))
		var/slogan = pick(slogan_list)
		speak(slogan)
		last_slogan = world.time

	if(shoot_inventory && prob(shooting_chance))
		throw_item()

	return

/obj/machinery/vending/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if (!message)
		return

	audible_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>")
	return

/obj/machinery/vending/powered()
	return anchored && ..()

/obj/machinery/vending/on_update_icon()
	cut_overlays()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else if( !(stat & NOPOWER) )
		icon_state = initial(icon_state)
	else
		spawn(rand(0, 15))
			icon_state = "[initial(icon_state)]-off"
	if(panel_open)
		add_overlay("[initial(icon_state)]-panel")

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	set waitfor = FALSE
	for(var/datum/stored_items/vending_products/product_record in product_records)
		while(product_record.get_amount()>0)
			product_record.get_product(loc)
		break
	set_broken(TRUE)

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_items/vending_products/product_record in shuffle(product_records))
		throw_item = product_record.get_product(loc)
		if(!QDELETED(throw_item))
			break
	if(QDELETED(throw_item))
		return 0
	spawn(0)
		throw_item.throw_at(target, rand(1,2), 3)
	visible_message(SPAN_WARNING("\The [src] launches \a [throw_item] at \the [target]!"))
	return 1
