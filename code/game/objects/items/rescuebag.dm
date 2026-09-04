
/obj/item/bodybag/rescue
	name = "rescue bag"
	desc = "A folded, reusable bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile environment."
	icon = 'icons/obj/closets/rescuebag.dmi'
	icon_state = "folded"
	origin_tech = @'{"biotech":2}'
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/silicon = MATTER_AMOUNT_SECONDARY)
	bag_type = /obj/structure/closet/body_bag/rescue
	var/obj/item/tank/airtank

/obj/item/bodybag/rescue/loaded
	airtank = /obj/item/tank/emergency/oxygen/double

/obj/item/bodybag/rescue/Initialize()
	. = ..()
	if(ispath(airtank))
		airtank = new airtank(src)
	update_icon()

/obj/item/bodybag/rescue/Destroy()
	QDEL_NULL(airtank)
	return ..()

/obj/item/bodybag/rescue/create_bag_structure(mob/user)
	var/obj/structure/closet/body_bag/rescue/bag = ..()
	if(istype(bag) && airtank)
		bag.set_tank(airtank)
		airtank = null
	return bag

/obj/item/bodybag/rescue/attackby(obj/item/used_item, mob/user, var/click_params)
	if(istype(used_item,/obj/item/tank))
		if(airtank)
			to_chat(user, "\The [src] already has an air tank installed.")
			return TRUE
		if(user.try_unequip(used_item))
			used_item.forceMove(src)
			airtank = used_item
			to_chat(user, "You install \the [used_item] in \the [src].")
		return TRUE
	else if(airtank && IS_SCREWDRIVER(used_item))
		to_chat(user, "You remove \the [airtank] from \the [src].")
		airtank.dropInto(loc)
		airtank = null
		return TRUE
	else
		return ..()

/obj/item/bodybag/rescue/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(airtank)
		. += "The pressure meter on \the [airtank] shows '[airtank.air_contents.return_pressure()] kPa'."
		. += "The distribution valve on \the [airtank] is set to '[airtank.distribute_pressure] kPa'."
	else
		. += SPAN_WARNING("The air tank is missing.")

/obj/structure/closet/body_bag/rescue
	name = "rescue bag"
	desc = "A reusable plastic bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile environment."
	icon = 'icons/obj/closets/rescuebag.dmi'
	item_path = /obj/item/bodybag/rescue
	storage_types = CLOSET_STORAGE_MOBS
	var/obj/item/tank/airtank
	var/datum/gas_mixture/atmo

/obj/structure/closet/body_bag/rescue/Initialize()
	. = ..()
	atmo = new()
	atmo.total_volume = 0.1*CELL_VOLUME
	START_PROCESSING(SSobj, src)

/obj/structure/closet/body_bag/rescue/Destroy()
	QDEL_NULL(airtank)
	return ..()

/obj/structure/closet/body_bag/rescue/proc/set_tank(obj/item/tank/newtank)
	airtank = newtank
	if(airtank)
		airtank.forceMove(null)
	update_icon()

/obj/structure/closet/body_bag/rescue/on_update_icon()
	..()
	if(airtank)
		add_overlay("tank")

/obj/structure/closet/body_bag/rescue/attackby(obj/item/used_item, mob/user, var/click_params)
	if(istype(used_item,/obj/item/tank))
		if(airtank)
			to_chat(user, "\The [src] already has an air tank installed.")
		else if(user.try_unequip(used_item, src))
			set_tank(used_item)
			to_chat(user, "You install \the [used_item] in \the [src].")
		return TRUE
	else if(airtank && IS_SCREWDRIVER(used_item))
		to_chat(user, "You remove \the [airtank] from \the [src].")
		airtank.dropInto(loc)
		airtank = null
		update_icon()
		return TRUE
	else
		return ..()

/obj/structure/closet/body_bag/rescue/fold(var/user)
	var/obj/item/tank/my_tank = airtank
	airtank = null
	var/obj/item/bodybag/rescue/folded = ..()
	if(istype(folded) && my_tank)
		my_tank.air_contents.merge(atmo)
		folded.airtank = my_tank
		airtank.forceMove(folded)

/obj/structure/closet/body_bag/rescue/Process()
	if(!airtank)
		return
	var/env_pressure = atmo.return_pressure()
	var/pressure_delta = max(airtank.distribute_pressure, 51) - env_pressure
	if(airtank.air_contents.temperature > 0 && pressure_delta > 0)
		var/transfer_moles = calculate_transfer_moles(airtank.air_contents, atmo, pressure_delta)
		pump_gas_passive(airtank, airtank.air_contents, atmo, transfer_moles)

/obj/structure/closet/body_bag/rescue/return_air() //Used to make stasis bags protect from vacuum.
	return atmo

/obj/structure/closet/body_bag/rescue/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(airtank)
		. += "The pressure meter on \the [airtank] shows '[airtank.air_contents.return_pressure()] kPa'."
		. += "The distribution valve on \the [airtank] is set to '[airtank.distribute_pressure] kPa'."
	else
		. += SPAN_WARNING("The air tank is missing.")
	. += "The pressure meter on [src] shows '[atmo.return_pressure()] kPa'."

/obj/structure/closet/body_bag/rescue/examined_by(mob/user, distance, infix, suffix)
	. = ..()
	if(Adjacent(user)) //The bag's rather thick and opaque from a distance.
		to_chat(user, SPAN_INFO("You peer into \the [src]."))
		for(var/mob/living/patient in contents)
			patient.examined_by(user, distance, infix, suffix)
	return TRUE