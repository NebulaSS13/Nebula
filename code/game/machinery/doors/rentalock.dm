/obj/machinery/door/airlock/rentalock
	locked 				= TRUE				// Always start locked.

	// Configuration variables.
	var/price			= 3000				// How much it costs to rent this airlock.
	var/rent_duration	= 259200 SECONDS	// How long the door can be rented for.
	var/overlap_duration = 86400 SECONDS	// The overlap of rentable periods, that less us renew/re-rent early.

	// Stateful variables.
	var/expiration							// When the rent expires.
	var/renter_name		= null				// Who rented.
	var/awaiting_payment = FALSE			// Are we waiting for payment? Assign to timestamp of when we'll stop waiting if true.

/obj/machinery/door/airlock/rentalock/Initialize()
	. = ..()

	set_extension(src, /datum/extension/lockable)

/obj/machinery/door/airlock/rentalock/attackby(var/obj/item/W, var/mob/user)
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
		if(paid && handled)
			confirm_rent(user)
			
/obj/machinery/door/airlock/rentalock/AltClick(var/mob/user)
	if(!CanPhysicallyInteract(user))
		return
	ui_interact(user)

/obj/machinery/door/airlock/rentalock/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = list()

	if(awaiting_payment < world.timeofday)
		awaiting_payment = FALSE
	data["awaiting_payment"] = TRUE

	data["locked"] = locked
	data["price"] = price

	if(is_rented())
		data["rented"] = TRUE
		data["rented_by"] = renter_name
		data["can_deposit"] = (expiration - world.realtime) <= overlap_duration
		data["rented_for"] = time2text(expiration - world.realtime)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "rentalock.tmpl", "Door Controls", 450, 350, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/door/airlock/rentalock/Topic(href, href_list)
	. = TOPIC_REFRESH
	if(href_list["unlock"])
		src.unlock()
		to_chat(usr, "The door bolts have been raised.")
	if(href_list["lock"])
		src.lock()
		to_chat(usr, "The door bolts have been dropped.")
	if(href_list["cancel"])
		awaiting_payment = FALSE
	if(href_list["rent"])
		awaiting_payment = world.realtime + 60 SECONDS


/**
 *  Receive payment with cashmoney.
 */
/obj/machinery/door/airlock/rentalock/proc/pay_with_cash(var/obj/item/cash/cashmoney)
	if(price > cashmoney.absolute_worth)
		// This is not a status display message, since it's something the character
		// themselves is meant to see BEFORE putting the money in
		to_chat(usr, SPAN_WARNING("\icon[cashmoney] That is not enough money."))
		return FALSE
	visible_message(SPAN_INFO("\The [usr] inserts some cash into \the [src]."))
	cashmoney.adjust_worth(-(price))
	return TRUE

/**
 * Scan a chargecard and deduct payment from it.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed.
 */
/obj/machinery/door/airlock/rentalock/proc/pay_with_charge_card(var/obj/item/charge_card/wallet)
	visible_message(SPAN_INFO("\The [usr] swipes \the [wallet] through \the [src]."))
	if(price > wallet.loaded_worth)
		status_message = "Insufficient funds on charge-stick."
		status_error = TRUE
		return FALSE
	else
		wallet.adjust_worth(-(price))
		return TRUE

/obj/machinery/door/airlock/rentalock/proc/is_rented()
	return world.realtime < expiration

/obj/machinery/door/airlock/rentalock/proc/confirm_rent(var/mob/user)
	renter_name = user.name
	var/remaining_time = 0
	if(expiration > world.realtime)
		remaining_time = expiration - world.realtime
	expiration = world.realtime + rent_duration + remaining_time
	to_chat(user, SPAN_NOTICE("\icon[src] \The [src] affirmatively beeps as rent is deposited."))
