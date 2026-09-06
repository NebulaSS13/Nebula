
/obj/item/bodybag/cryobag
	name = "stasis bag"
	desc = "A folded, reusable bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile environment."
	icon = 'icons/obj/closets/cryobag.dmi'
	icon_state = "bodybag_folded"
	origin_tech = @'{"biotech":4}'
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE
	)
	bag_type = /obj/structure/closet/body_bag/cryobag
	var/stasis_power

/obj/item/bodybag/cryobag/get_cryogenic_power()
	return stasis_power

/obj/item/bodybag/cryobag/create_bag_structure(mob/user)
	var/obj/structure/closet/body_bag/cryobag/bag = ..()
	if(istype(bag) && stasis_power)
		bag.stasis_power = stasis_power
	return bag

/obj/structure/closet/body_bag/cryobag
	name = "stasis bag"
	desc = "A reusable plastic bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile environment."
	icon = 'icons/obj/closets/cryobag.dmi'
	item_path = /obj/item/bodybag/cryobag
	material = /decl/material/solid/organic/plastic
	storage_types = CLOSET_STORAGE_MOBS
	var/datum/gas_mixture/airtank

	var/stasis_power = 20
	var/degradation_time = 150 //ticks until stasis power degrades, ~5 minutes

/obj/structure/closet/body_bag/cryobag/Initialize()
	. = ..()
	airtank = new()
	airtank.temperature = T0C
	airtank.adjust_gas(/decl/material/gas/oxygen, MOLES_O2STANDARD, 0)
	airtank.adjust_gas(/decl/material/gas/nitrogen, MOLES_N2STANDARD)
	update_icon()

/obj/structure/closet/body_bag/cryobag/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(airtank)
	return ..()

/obj/structure/closet/body_bag/cryobag/Entered(atom/movable/AM)
	if(ishuman(AM))
		START_PROCESSING(SSobj, src)
	..()

/obj/structure/closet/body_bag/cryobag/Exited(atom/movable/AM)
	if(ishuman(AM))
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/closet/body_bag/cryobag/on_update_icon()
	..()
	var/image/I = image(icon, "indicator[opened]")
	I.appearance_flags = RESET_COLOR
	var/maxstasis = initial(stasis_power)
	if(stasis_power > 0.5 * maxstasis)
		I.color = COLOR_LIME
	else if(stasis_power)
		I.color = COLOR_YELLOW
	else
		I.color = COLOR_RED
	add_overlay(I)

/obj/structure/closet/body_bag/cryobag/proc/get_saturation()
	return stasis_power / initial(stasis_power)

/obj/structure/closet/body_bag/cryobag/fold(var/user)
	var/obj/item/bodybag/cryobag/folded = ..()
	if(istype(folded))
		folded.stasis_power = stasis_power
		folded.color = color_matrix_saturation(get_saturation())

/obj/structure/closet/body_bag/cryobag/Process()
	if(stasis_power < 2)
		return PROCESS_KILL
	var/mob/living/patient = locate() in src
	if(!patient)
		return PROCESS_KILL
	degradation_time--
	if(degradation_time < 0)
		degradation_time = initial(degradation_time)
		stasis_power = round(0.75 * stasis_power)
		animate(src, color = color_matrix_saturation(get_saturation()), time = 10)
		update_icon()
	patient.add_mob_modifier(/decl/mob_modifier/stasis, 2 SECONDS, source = src)

/obj/structure/closet/body_bag/cryobag/return_air() //Used to make stasis bags protect from vacuum.
	if(airtank)
		return airtank
	..()

/obj/structure/closet/body_bag/cryobag/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	. += "The stasis meter shows '[stasis_power]x'."

/obj/structure/closet/body_bag/cryobag/examined_by(mob/user, distance, infix, suffix)
	. = ..()
	if(Adjacent(user)) //The bag's rather thick and opaque from a distance.
		to_chat(user, SPAN_INFO("You peer into \the [src]."))
		for(var/mob/living/patient in contents)
			patient.examined_by(user, distance, infix, suffix)
	return TRUE

/obj/item/usedcryobag
	name = "used stasis bag"
	desc = "Pretty useless now..."
	icon_state = "bodybag_used"
	icon = 'icons/obj/closets/cryobag.dmi'
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE
	)

/obj/structure/closet/body_bag/cryobag/blank
	stasis_power = 60
	degradation_time = 1800 //ticks until stasis power degrades, ~5 minutes

/obj/structure/closet/body_bag/cryobag/blank/open(mob/user)
	. = ..()
	new /obj/item/usedcryobag(loc)
	qdel(src)

/obj/structure/closet/body_bag/cryobag/blank/WillContain()
	return list(/mob/living/human/blank)

/obj/structure/closet/body_bag/cryobag/blank/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
