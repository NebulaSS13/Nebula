// A vendor machine for modular computer portable devices - Laptops and Tablets

/obj/machinery/lapvend
	name = "computer vendor"
	desc = "A vending machine with a built-in microfabricator, capable of dispensing various computers."
	icon = 'icons/obj/machines/vending/laptops.dmi'
	icon_state = ICON_STATE_WORLD
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE

	// The actual laptop/tablet
	var/obj/item/modular_computer/laptop/fabricated_laptop = null
	var/obj/item/modular_computer/tablet/fabricated_tablet = null

	// Utility vars
	var/const/STATE_DEVICE_SEL  = 0
	var/const/STATE_LOADOUT_SEL = 1
	var/const/STATE_PAYMENT     = 2
	var/const/STATE_THANK_YOU   = 3
	var/state = STATE_DEVICE_SEL
	var/const/DEVICE_TYPE_NONE    = 0
	var/const/DEVICE_TYPE_LAPTOP  = 1
	var/const/DEVICE_TYPE_TABLET  = 2
	var/devtype = DEVICE_TYPE_NONE
	/// The calculated price of the currently vended device.
	var/total_price = 0

	// Device loadout
	var/const/COMPONENT_NONE     = 0
	var/const/COMPONENT_PRESENT  = 1
	var/const/COMPONENT_BASIC    = 1
	var/const/COMPONENT_UPGRADED = 2
	var/const/COMPONENT_ADVANCED = 3
	/// What kind of CPU are we adding? Valid states: COMPONENT_BASIC, COMPONENT_UPGRADED
	var/dev_cpu = COMPONENT_BASIC
	/// What kind of battery are we adding? Valid states: COMPONENT_BASIC, COMPONENT_UPGRADED, COMPONENT_ADVANCED
	var/dev_battery = COMPONENT_BASIC
	/// What kind of battery are we adding? Valid states: COMPONENT_BASIC, COMPONENT_UPGRADED, COMPONENT_ADVANCED
	var/dev_disk = COMPONENT_BASIC
	/// What kind of network card are we adding? Valid states: COMPONENT_NONE, COMPONENT_BASIC, COMPONENT_UPGRADED
	var/dev_netcard = COMPONENT_NONE
	/// Are we adding a tesla relay? Valid states: COMPONENT_NONE, COMPONENT_PRESENT
	var/dev_tesla = COMPONENT_NONE
	/// Are we adding a printer? Valid states: COMPONENT_NONE, COMPONENT_PRESENT
	var/dev_nanoprint = COMPONENT_NONE
	/// Are we adding a card reader? Valid states: COMPONENT_NONE, COMPONENT_PRESENT
	var/dev_card = COMPONENT_NONE
	/// Are we adding an AI slot? Valid states: COMPONENT_NONE, COMPONENT_PRESENT
	var/dev_aislot = COMPONENT_NONE

/obj/machinery/lapvend/on_update_icon()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else if(!(stat & NOPOWER))
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"

// Removes all traces of old order and allows you to begin configuration from scratch.
/obj/machinery/lapvend/proc/reset_order()
	state = STATE_DEVICE_SEL
	devtype = DEVICE_TYPE_NONE
	QDEL_NULL(fabricated_laptop)
	QDEL_NULL(fabricated_tablet)
	dev_cpu = COMPONENT_BASIC
	dev_battery = COMPONENT_BASIC
	dev_disk = COMPONENT_BASIC
	dev_netcard = COMPONENT_NONE
	dev_tesla = COMPONENT_NONE
	dev_nanoprint = COMPONENT_NONE
	dev_card = COMPONENT_NONE
	dev_aislot = COMPONENT_NONE

// Recalculates the price and optionally even fabricates the device.
/obj/machinery/lapvend/proc/fabricate_and_recalc_price(var/fabricate = FALSE)
	total_price = 0
	if(devtype == DEVICE_TYPE_LAPTOP) 		// Laptop, generally cheaper to make it accessible for most station roles
		var/datum/extension/assembly/modular_computer/assembly
		if(fabricate)
			fabricated_laptop = new(src)
			assembly = get_extension(fabricated_laptop, /datum/extension/assembly)
		total_price = atom_info_repository.get_single_worth_for(/obj/item/modular_computer/laptop)
		switch(dev_cpu)
			if(COMPONENT_BASIC)
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/processor_unit/small)
				if(fabricate)
					assembly.add_replace_component(null, PART_CPU, new/obj/item/stock_parts/computer/processor_unit/small(fabricated_laptop))
			if(COMPONENT_UPGRADED)
				if(fabricate)
					assembly.add_replace_component(null, PART_CPU, new/obj/item/stock_parts/computer/processor_unit(fabricated_laptop))
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/processor_unit)
		switch(dev_battery)
			if(COMPONENT_BASIC) // Basic(750C)
				if(fabricate)
					assembly.add_replace_component(null, PART_BATTERY, new/obj/item/stock_parts/computer/battery_module(fabricated_laptop))
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/battery_module)
			if(COMPONENT_UPGRADED) // Upgraded(1100C)
				if(fabricate)
					assembly.add_replace_component(null, PART_BATTERY, new/obj/item/stock_parts/computer/battery_module/advanced(fabricated_laptop))
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/battery_module/advanced)
			if(COMPONENT_ADVANCED) // Advanced(1500C)
				if(fabricate)
					assembly.add_replace_component(null, PART_BATTERY, new/obj/item/stock_parts/computer/battery_module/super(fabricated_laptop))
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/battery_module/super)
		switch(dev_disk)
			if(COMPONENT_BASIC) // Basic(128GQ)
				if(fabricate)
					assembly.add_replace_component(null, PART_HDD, new/obj/item/stock_parts/computer/hard_drive(fabricated_laptop))
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/hard_drive)
			if(COMPONENT_UPGRADED) // Upgraded(256GQ)
				if(fabricate)
					assembly.add_replace_component(null, PART_HDD, new/obj/item/stock_parts/computer/hard_drive/advanced(fabricated_laptop))
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/hard_drive/advanced)
			if(COMPONENT_ADVANCED) // Advanced(512GQ)
				if(fabricate)
					assembly.add_replace_component(null, PART_HDD, new/obj/item/stock_parts/computer/hard_drive/super(fabricated_laptop))
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/hard_drive/super)
		switch(dev_netcard)
			if(COMPONENT_BASIC) // Basic(Short-Range)
				if(fabricate)
					assembly.add_replace_component(null, PART_NETWORK, new/obj/item/stock_parts/computer/network_card(fabricated_laptop))
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/network_card)
			if(COMPONENT_UPGRADED) // Advanced (Long Range)
				if(fabricate)
					assembly.add_replace_component(null, PART_NETWORK, new/obj/item/stock_parts/computer/network_card/advanced(fabricated_laptop))
				total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/network_card/advanced)
		if(dev_tesla)
			if(fabricate)
				assembly.add_replace_component(null, PART_TESLA, new/obj/item/stock_parts/computer/tesla_link(fabricated_laptop))
			total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/tesla_link)
		if(dev_nanoprint)
			if(fabricate)
				assembly.add_replace_component(null, PART_PRINTER, new/obj/item/stock_parts/computer/nano_printer(fabricated_laptop))
			total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/nano_printer)
		if(dev_card)
			if(fabricate)
				assembly.add_replace_component(null, PART_CARD, new/obj/item/stock_parts/computer/card_slot(fabricated_laptop))
			total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/card_slot)
		if(dev_aislot)
			if(fabricate)
				assembly.add_replace_component(null, PART_AI, new/obj/item/stock_parts/computer/ai_slot(fabricated_laptop))
			total_price += atom_info_repository.get_single_worth_for(/obj/item/stock_parts/computer/ai_slot)

		return total_price
	else if(devtype == DEVICE_TYPE_TABLET) 	// Tablet, more expensive, not everyone could probably afford this.
		var/datum/extension/assembly/modular_computer/assembly
		if(fabricate)
			fabricated_tablet = new(src)
			assembly = get_extension(fabricated_tablet, /datum/extension/assembly)
			assembly.add_replace_component(null, PART_CPU, new/obj/item/stock_parts/computer/processor_unit/small(fabricated_tablet))
		total_price = 199
		switch(dev_battery)
			if(COMPONENT_BASIC) // Basic(300C)
				if(fabricate)
					assembly.add_replace_component(null, PART_BATTERY, new/obj/item/stock_parts/computer/battery_module/nano(fabricated_tablet))
			if(COMPONENT_UPGRADED) // Upgraded(500C)
				if(fabricate)
					assembly.add_replace_component(null, PART_BATTERY, new/obj/item/stock_parts/computer/battery_module/micro(fabricated_tablet))
				total_price += 199
			if(COMPONENT_ADVANCED) // Advanced(750C)
				if(fabricate)
					assembly.add_replace_component(null, PART_BATTERY, new/obj/item/stock_parts/computer/battery_module(fabricated_tablet))
				total_price += 499
		switch(dev_disk)
			if(COMPONENT_BASIC) // Basic(32GQ)
				if(fabricate)
					assembly.add_replace_component(null, PART_HDD, new/obj/item/stock_parts/computer/hard_drive/micro(fabricated_tablet))
			if(COMPONENT_UPGRADED) // Upgraded(64GQ)
				if(fabricate)
					assembly.add_replace_component(null, PART_HDD, new/obj/item/stock_parts/computer/hard_drive/small(fabricated_tablet))
				total_price += 99
			if(COMPONENT_ADVANCED) // Advanced(128GQ)
				if(fabricate)
					assembly.add_replace_component(null, PART_HDD, new/obj/item/stock_parts/computer/hard_drive(fabricated_tablet))
				total_price += 299
		switch(dev_netcard)
			if(COMPONENT_BASIC) // Basic(Short-Range)
				if(fabricate)
					assembly.add_replace_component(null, PART_NETWORK, new/obj/item/stock_parts/computer/network_card(fabricated_tablet))
				total_price += 99
			if(COMPONENT_UPGRADED) // Advanced (Long Range)
				if(fabricate)
					assembly.add_replace_component(null, PART_NETWORK, new/obj/item/stock_parts/computer/network_card/advanced(fabricated_tablet))
				total_price += 299
		if(dev_nanoprint)
			total_price += 99
			if(fabricate)
				assembly.add_replace_component(null, PART_PRINTER, new/obj/item/stock_parts/computer/nano_printer(fabricated_tablet))
		if(dev_card)
			total_price += 199
			if(fabricate)
				assembly.add_replace_component(null, PART_CARD, new/obj/item/stock_parts/computer/card_slot(fabricated_tablet))
		if(dev_tesla)
			total_price += 399
			if(fabricate)
				assembly.add_replace_component(null, PART_TESLA, new/obj/item/stock_parts/computer/tesla_link(fabricated_tablet))
		if(dev_aislot)
			total_price += 499
			if(fabricate)
				assembly.add_replace_component(null, PART_AI, new/obj/item/stock_parts/computer/ai_slot(fabricated_tablet))
		return total_price
	return 0

/obj/machinery/lapvend/OnTopic(mob/user, href_list)
	if((. = ..()))
		return

	if(href_list["pick_device"])
		if(state) // We've already picked a device type
			return TOPIC_REFRESH // Your UI must be out of date (or you're trying to href hack...)
		devtype = text2num(href_list["pick_device"])
		state = STATE_LOADOUT_SEL
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	if(href_list["clean_order"])
		reset_order()
		return TOPIC_REFRESH
	// Following IFs should only be usable when in the Select Loadout mode.
	if(state != STATE_LOADOUT_SEL)
		return TOPIC_NOACTION
	// Proceed to payment
	if(href_list["confirm_order"])
		state = STATE_PAYMENT // Wait for ID swipe for payment processing
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	// Hardware selection
	if(href_list["hw_cpu"])
		dev_cpu = text2num(href_list["hw_cpu"])
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	if(href_list["hw_battery"])
		dev_battery = text2num(href_list["hw_battery"])
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	if(href_list["hw_disk"])
		dev_disk = text2num(href_list["hw_disk"])
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	if(href_list["hw_netcard"])
		dev_netcard = text2num(href_list["hw_netcard"])
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	if(href_list["hw_tesla"])
		dev_tesla = text2num(href_list["hw_tesla"])
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	if(href_list["hw_nanoprint"])
		dev_nanoprint = text2num(href_list["hw_nanoprint"])
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	if(href_list["hw_card"])
		dev_card = text2num(href_list["hw_card"])
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	if(href_list["hw_aislot"])
		dev_aislot = text2num(href_list["hw_aislot"])
		fabricate_and_recalc_price(FALSE)
		return TOPIC_REFRESH
	return TOPIC_NOACTION

/obj/machinery/lapvend/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/lapvend/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(inoperable(MAINT))
		if(ui)
			ui.close()
		return
	var/list/data = list()
	data["state"] = state
	if(state == STATE_LOADOUT_SEL)
		data["devtype"] = devtype
		data["hw_battery"] = dev_battery
		data["hw_disk"] = dev_disk
		data["hw_netcard"] = dev_netcard
		data["hw_tesla"] = dev_tesla
		data["hw_nanoprint"] = dev_nanoprint
		data["hw_card"] = dev_card
		data["hw_cpu"] = dev_cpu
		data["hw_aislot"] = dev_aislot
	if(state == STATE_LOADOUT_SEL || state == STATE_PAYMENT)
		var/decl/currency/cur = GET_DECL(global.using_map.default_currency)
		data["totalprice"] = cur.format_value(total_price)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "computer_fabricator.tmpl", "Personal Computer Vendor", 500, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/lapvend/attackby(obj/item/used_item, mob/user)
	if(state == STATE_PAYMENT && process_payment(used_item))
		fabricate_and_recalc_price(TRUE)
		flick("world-vend", src)
		if((devtype == DEVICE_TYPE_LAPTOP) && fabricated_laptop)
			fabricated_laptop.forceMove(src.loc)
			fabricated_laptop.update_icon()
			fabricated_laptop.update_verbs()
			fabricated_laptop = null
		else if((devtype == DEVICE_TYPE_TABLET) && fabricated_tablet)
			fabricated_tablet.forceMove(src.loc)
			fabricated_tablet.update_verbs()
			fabricated_tablet = null
		ping("Enjoy your new product!")
		state = STATE_THANK_YOU
		return TRUE
	return ..()


// Simplified payment processing, returns TRUE on success.
/obj/machinery/lapvend/proc/process_payment(var/obj/item/charge_stick/I)
	if(!istype(I))
		ping("Invalid payment format.")
		return FALSE
	visible_message(SPAN_INFO("\The [usr] inserts \the [I] into \the [src]."))
	if(total_price > I.loaded_worth)
		ping("Unable to process transaction: insufficient funds.")
		return FALSE
	I.loaded_worth -= total_price
	return TRUE