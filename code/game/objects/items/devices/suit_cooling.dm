/obj/item/suit_cooling_unit
	name = "portable cooling unit"
	desc = "A large portable heat sink with liquid cooled radiator packaged into a modified backpack."
	w_class = ITEM_SIZE_LARGE
	icon = 'icons/obj/items/suitcooler.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_BACK

	//copied from tank.dm
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4
	action_button_name = "Toggle Heatsink"

	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = "{'magnets':2,'materials':2}"

	var/on = 0								//is it turned on?
	cell_cover = TRUE
	cell = /obj/item/cell/high
	cell_allowed = /obj/item/cell
	power_usage = 2 KILOWATTS
	var/max_cooling = 12					// in degrees per second - probably don't need to mess with heat capacity here
		// energy usage at full power
	var/thermostat = T20C

/obj/item/suit_cooling_unit/ui_action_click()
	toggle(usr)

/obj/item/suit_cooling_unit/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
//there was a note about 10k cell. what is this code from, 2016?

/obj/item/suit_cooling_unit/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/suit_cooling_unit/Process()
	if (!on || !cell)
		return

	if (!is_in_slot())
		return

	var/mob/living/carbon/human/H = loc

	var/temp_adj = min(H.bodytemperature - thermostat, max_cooling)

	if (temp_adj < 0.5)	//only cools, doesn't heat, also we don't need extreme precision
		return

	var/charge_usage = (temp_adj/max_cooling)*power_usage

	H.bodytemperature -= temp_adj

	cell.use(charge_usage * CELLRATE)
	update_icon()

	if(cell.charge <= 0) //i feel like this is really ancient but okay
		turn_off(1)

// Checks whether the cooling unit is being worn on the back/suit slot.
// That way you can't carry it in your hands while it's running to cool yourself down.
/obj/item/suit_cooling_unit/proc/is_in_slot()
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		return 0
	return H.get_equipped_item(slot_back_str) == src || H.get_equipped_item(slot_s_store_str) == src

/obj/item/suit_cooling_unit/proc/turn_on()
	if(!cell)
		return
	if(cell.charge <= 0)
		return

	on = 1
	update_icon()

/obj/item/suit_cooling_unit/proc/turn_off(var/failed)
	if(failed) visible_message("\The [src] clicks and whines as it powers down.")
	on = 0
	update_icon()

/obj/item/suit_cooling_unit/attack_self(var/mob/user)
	if(cell_cover && cell)
		remove_cell(user)
		return

	toggle(user)

/obj/item/suit_cooling_unit/proc/toggle(var/mob/user)
	if(on)
		turn_off()
	else
		turn_on()
	to_chat(user, "<span class='notice'>You switch \the [src] [on ? "on" : "off"].</span>")

/obj/item/suit_cooling_unit/on_update_icon()
	. = ..()
	if(cell_cover)
		add_overlay("[icon_state]-open")
		if(cell)
			add_overlay("[icon_state]-cell")
		return

	if(!cell || !on)
		return

	switch(round(cell.percent()))
		if(86 to INFINITY)
			add_overlay("[icon_state]-battery-0")
		if(69 to 85)
			add_overlay("[icon_state]-battery-1")
		if(52 to 68)
			add_overlay("[icon_state]-battery-2")
		if(35 to 51)
			add_overlay("[icon_state]-battery-3")
		if(18 to 34)
			add_overlay("[icon_state]-battery-4")
		if(-INFINITY to 17)
			add_overlay("[icon_state]-battery-5")

/obj/item/suit_cooling_unit/examine(mob/user, distance)
	. = ..()
	if(distance >= 1)
		return
	if (on)
		to_chat(user, "It's switched on and running.")
	else
		to_chat(user, "It is switched off.")