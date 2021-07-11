/**
 *  A vending machine
 */
/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	layer = BELOW_OBJ_LAYER
	anchored = 1
	density = 1
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

	var/icon_vend //Icon_state when vending
	var/icon_deny //Icon_state when denying access

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
	. = ..()
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

/**
 *  Build produdct_records from the products lists
 *
 *  products and contraband lists allow specifying products that
 *  the vending machine is to carry without manually populating
 *  product_records.
 */

/obj/machinery/vending/proc/get_product_name(var/entry)
	return

/obj/machinery/vending/proc/build_inventory(populate_parts = FALSE)
	var/list/all_products = list(
		list(products, CAT_NORMAL),
		list(contraband, CAT_HIDDEN)
	)
	for(var/current_list in all_products)
		var/category = current_list[2]
		for(var/entry in current_list[1])
			var/datum/stored_items/vending_products/product = new(src, entry, get_product_name(entry))
			product.price = atom_info_repository.get_combined_worth_for(entry) * markup
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
	for(var/datum/stored_items/vending_products/R in product_records)
		qdel(R)
	product_records = null
	return ..()

/obj/machinery/vending/get_codex_value()
	return "vendomat"

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
		to_chat(user, "You short out the product lock on \the [src]")
		return 1

/obj/machinery/vending/attackby(obj/item/W, mob/user)

	var/obj/item/charge_stick/CS = W.GetChargeStick()
	if (currently_vending && vendor_account && !vendor_account.suspended)

		if(!vend_ready)
			to_chat(user, SPAN_WARNING("\The [src] is vending a product, wait a second!"))
			return TRUE

		var/paid = 0
		var/handled = 0

		if (CS)
			paid = pay_with_charge_card(CS)
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

	if (istype(W, /obj/item/cash))
		attack_hand(user)
		return TRUE
	if(isMultitool(W) || isWirecutter(W))
		if(panel_open)
			attack_hand(user)
			return TRUE
	if((user.a_intent == I_HELP) && attempt_to_stock(W, user))
		return TRUE
	if((. = component_attackby(W, user)))
		return
	if((obj_flags & OBJ_FLAG_ANCHORABLE) && isWrench(W))
		wrench_floor_bolts(user)
		power_change()
		return

/obj/machinery/vending/state_transition(decl/machine_construction/new_state)
	. = ..()
	SSnano.update_uis(src)

/obj/machinery/vending/receive_mouse_drop(atom/dropping, var/mob/user)
	. = ..()
	if(!. && dropping.loc == user && attempt_to_stock(dropping, user))
		return TRUE

/obj/machinery/vending/proc/attempt_to_stock(var/obj/item/I, var/mob/user)
	for(var/datum/stored_items/vending_products/R in product_records)
		if(I.type == R.item_path)
			stock(I, R, user)
			return 1

/**
 *  Receive payment with cashmoney.
 */
/obj/machinery/vending/proc/pay_with_cash(var/obj/item/cash/cashmoney)
	if(currently_vending.price > cashmoney.absolute_worth)
		// This is not a status display message, since it's something the character
		// themselves is meant to see BEFORE putting the money in
		to_chat(usr, "[html_icon(cashmoney)] <span class='warning'>That is not enough money.</span>")
		return 0
	visible_message("<span class='info'>\The [usr] inserts some cash into \the [src].</span>")
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
	visible_message("<span class='info'>\The [usr] plugs \the [wallet] into \the [src].</span>")
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
		data["price_num"] = FLOOR(currently_vending.price / cur.absolute_value)
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
				"price_num" = FLOOR(I.price / cur.absolute_value),
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
		if(!is_valid_index(key, product_records))
			return TOPIC_REFRESH
		var/datum/stored_items/vending_products/R = product_records[key]
		if(!istype(R))
			return TOPIC_REFRESH

		// This should not happen unless the request from NanoUI was bad
		if(!(R.category & categories))
			return TOPIC_REFRESH

		if(R.price <= 0)
			vend(R, user)
		else if(istype(user,/mob/living/silicon)) //If the item is not free, provide feedback if a synth is trying to buy something.
			to_chat(user, "<span class='danger'>Artificial unit recognized.  Artificial units cannot complete this transaction.  Purchase canceled.</span>")
		else
			currently_vending = R
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

/obj/machinery/vending/proc/vend(var/datum/stored_items/vending_products/R, mob/user)
	if(!vend_ready)
		return
	if((!allowed(user)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
		to_chat(user, "<span class='warning'>Access denied.</span>")//Unless emagged of course
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
			visible_message("<span class='notice'>\The [src] clunks as it vends an additional [product.item_name].</span>")
	status_message = ""
	status_error = 0
	vend_ready = 1
	currently_vending = null
	SSnano.update_uis(src)

/**
 * Add item to the machine
 *
 * Checks if item is vendable in this machine should be performed before
 * calling. W is the item being inserted, R is the associated vending_product entry.
 */
/obj/machinery/vending/proc/stock(obj/item/W, var/datum/stored_items/vending_products/R, var/mob/user)
	if(!user.unEquip(W))
		return

	if(R.add_product(W))
		to_chat(user, "<span class='notice'>You insert \the [W] in the product receptor.</span>")
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
	overlays.Cut()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else if( !(stat & NOPOWER) )
		icon_state = initial(icon_state)
	else
		spawn(rand(0, 15))
			icon_state = "[initial(icon_state)]-off"
	if(panel_open)
		overlays += image(icon, "[initial(icon_state)]-panel")

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	set waitfor = FALSE
	for(var/datum/stored_items/vending_products/R in product_records)
		while(R.get_amount()>0)
			R.get_product(loc)
		break
	set_broken(TRUE)

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_items/vending_products/R in shuffle(product_records))
		throw_item = R.get_product(loc)
		if(!QDELETED(throw_item))
			break
	if(QDELETED(throw_item))
		return 0
	spawn(0)
		throw_item.throw_at(target, rand(1,2), 3)
	visible_message("<span class='warning'>\The [src] launches \a [throw_item] at \the [target]!</span>")
	return 1
