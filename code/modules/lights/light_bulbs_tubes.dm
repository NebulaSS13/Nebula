// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/light
	icon = 'icons/obj/lighting.dmi'
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel
	atom_flags = ATOM_FLAG_CAN_BE_PAINTED
	obj_flags = OBJ_FLAG_HOLLOW
	var/const/MODE_EMERGENCY = "emergency_lighting"
	var/const/MODE_READY = "ready"

	var/const/STATUS_OK = 0
	var/const/STATUS_EMPTY = 1
	var/const/STATUS_BROKEN = 2
	var/const/STATUS_BURNED = 3

	var/status = STATUS_OK // STATUS_OK, STATUS_BURNED or STATUS_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	var/rigged = 0		// true if rigged to explode
	var/broken_chance = 2

	var/b_power = 0.7
	var/b_range = 5
	var/b_color = LIGHT_COLOR_HALOGEN
	var/list/lighting_modes = list()
	var/sound_on

/obj/item/light/get_color()
	return b_color

/obj/item/light/set_color(color)
	b_color = isnull(color) ? COLOR_WHITE : color
	queue_icon_update() // avoid running update_icon before Initialize

/obj/item/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	material = /decl/material/solid/glass
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT)

	b_range = 8
	b_power = 0.8
	b_color = LIGHT_COLOR_HALOGEN
	lighting_modes = list(
		MODE_EMERGENCY = list(l_range = 4, l_power = 1, l_color = LIGHT_COLOR_EMERGENCY),
	)
	sound_on = 'sound/machines/lightson.ogg'

/obj/item/light/tube/party/Initialize() //Randomly colored light tubes. Mostly for testing, but maybe someone will find a use for them.
	. = ..()
	b_color = rgb(pick(0,255), pick(0,255), pick(0,255))

/obj/item/light/tube/large
	w_class = ITEM_SIZE_SMALL
	name = "large light tube"
	b_power = 4
	b_range = 12

/obj/item/light/tube/large/party/Initialize() //Randomly colored light tubes. Mostly for testing, but maybe someone will find a use for them.
	. = ..()
	b_color = rgb(pick(0,255), pick(0,255), pick(0,255))

/obj/item/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	broken_chance = 3
	material = /decl/material/solid/glass
	b_color = LIGHT_COLOR_TUNGSTEN
	lighting_modes = list(
		MODE_EMERGENCY = list(l_range = 3, l_power = 1, l_color = LIGHT_COLOR_EMERGENCY),
	)

/obj/item/light/bulb/red
	color = LIGHT_COLOR_RED
	b_color = LIGHT_COLOR_RED

/obj/item/light/bulb/red/readylight
	lighting_modes = list(
		MODE_READY = list(l_range = 5, l_power = 1, l_color = LIGHT_COLOR_GREEN),
	)

/obj/item/light/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "fbulb"
	base_state = "fbulb"
	item_state = "egg4"
	material = /decl/material/solid/glass

// update the icon state and description of the light
/obj/item/light/on_update_icon()
	. = ..()
	var/broken
	switch(status)
		if(STATUS_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(STATUS_BURNED)
			icon_state = "[base_state]_burned"
			desc = "A burnt-out [name]."
		if(STATUS_BROKEN)
			icon_state = "[base_state]_broken"
			desc = "A broken [name]."
			broken = TRUE
	add_overlay(overlay_image(icon, "[base_state]_attachment[broken ? "_broken" : ""]", flags = RESET_COLOR|RESET_ALPHA))

/obj/item/light/Initialize(mapload)
	. = ..()
	update_icon()

// attack bulb/tube with object
// if a syringe, can inject flammable liquids to make it explode
/obj/item/light/attackby(var/obj/item/used_item, var/mob/user)
	..()
	if(istype(used_item, /obj/item/chems/syringe) && used_item.reagents?.total_volume)
		var/obj/item/chems/syringe/S = used_item
		to_chat(user, "You inject the solution into \the [src].")
		for(var/decl/material/reagent as anything in S.reagents?.reagent_volumes)
			if(reagent.accelerant_value > FUEL_VALUE_ACCELERANT)
				rigged = TRUE
				log_and_message_admins("injected a light with flammable reagents, rigging it to explode.", user)
				break
		S.reagents.clear_reagents()
		return TRUE
	. = ..()

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /obj/machinery/light))
		return
	if(!user.check_intent(I_FLAG_HARM))
		return

	shatter()

/obj/item/light/shatter()
	if(status == STATUS_OK || status == STATUS_BURNED)
		src.visible_message(SPAN_WARNING("[name] shatters."), SPAN_WARNING("You hear a small glass object shatter."))
		status = STATUS_BROKEN
		set_sharp(TRUE)
		set_base_attack_force(5)
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		update_icon()

/obj/item/light/proc/switch_on()
	switchcount++
	if(rigged)
		addtimer(CALLBACK(src, PROC_REF(do_rigged_explosion)), 0.2 SECONDS)
		status = STATUS_BROKEN
	else if(prob(min(60, switchcount*switchcount*0.01)))
		status = STATUS_BURNED
	else if(sound_on)
		playsound(src, sound_on, 75)
	return status

/obj/item/light/proc/do_rigged_explosion()
	if(!rigged)
		return
	log_and_message_admins("Rigged light explosion, last touched by [fingerprintslast]")
	var/turf/T = get_turf(src)
	explosion(T, 0, 0, 3, 5)
	if(!QDELETED(src))
		QDEL_IN(src, 1)
