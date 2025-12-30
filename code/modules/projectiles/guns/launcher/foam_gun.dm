/obj/item/gun/launcher/foam
	name = "foam blaster"
	desc = "The classic Jorf blaster!"
	icon = 'icons/obj/guns/foam/blaster.dmi'
	icon_state = ICON_STATE_WORLD
	_base_attack_force = 1
	w_class = ITEM_SIZE_SMALL
	obj_flags = null
	slot_flags = SLOT_LOWER_BODY | SLOT_HOLSTER
	release_force = 1.5
	throw_distance = 6
	accuracy = 1
	one_hand_penalty = 0
	fire_sound = 'sound/weapons/foamblaster.ogg'
	fire_sound_text = "a pleasing 'pomp'"
	material = /decl/material/solid/organic/plastic

	var/max_darts = 1
	var/list/darts = new/list()

/obj/item/gun/launcher/foam/attackby(obj/item/used_item, mob/user)
	if(!istype(used_item, /obj/item/foam_dart))
		return ..()
	if(darts.len < max_darts)
		if(!user.try_unequip(used_item, src))
			return TRUE
		darts += used_item
		to_chat(user, SPAN_NOTICE("You slot \the [used_item] into \the [src]."))
		return TRUE
	else
		to_chat(user, SPAN_WARNING("\The [src] can hold no more darts."))
		return TRUE

/obj/item/gun/launcher/foam/consume_next_projectile()
	if(darts.len)
		var/obj/item/thing = darts[1]
		darts -= thing
		return thing
	return null

/obj/item/gun/launcher/foam/CtrlAltClick(mob/user)
	if(darts.len && src.loc == user)
		to_chat(user, "You empty \the [src].")
		for(var/obj/item/foam_dart/D in darts)
			darts -= D
			D.dropInto(user.loc)
			D.mix_up()

/obj/item/gun/launcher/foam/crossbow
	name = "foam dart crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/guns/energy_crossbow.dmi'
	max_darts = 5

/obj/item/gun/launcher/foam/burst
	name = "foam machine pistol"
	desc = "The Jorf Outlander, a machine pistol blaster, fires two darts in rapid succession. Holds 4 darts."
	icon =  'icons/obj/guns/foam/pistol.dmi'
	w_class = ITEM_SIZE_NORMAL
	burst = 2
	fire_delay = 12
	one_hand_penalty = 1
	max_darts = 4

/obj/item/gun/launcher/foam/revolver
	name = "foam revolver"
	desc = "The Jorf Desperado is a revolver blaster, with a hammer action so you can fan the hammer like a real desperado! It holds 6 darts."
	icon =  'icons/obj/guns/foam/revolver.dmi'
	w_class = ITEM_SIZE_NORMAL
	fire_delay = 4
	one_hand_penalty = 1
	max_darts = 6

/obj/item/gun/launcher/foam/revolver/tampered
	release_force = 3
	throw_distance = 12

/obj/item/gun/launcher/foam/revolver/tampered/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "The hammer is a lot more resistant than you'd expect."

/obj/item/gun/launcher/foam/machine_gun
	name = "foam machine gun"
	desc = "The Jorf machine gun, hose the competition down and hate yourself while you spend forever reloading! It holds 30 darts."
	icon =  'icons/obj/guns/foam/machine_gun.dmi'
	w_class = ITEM_SIZE_NORMAL
	fire_delay = 0
	autofire_enabled = 1
	one_hand_penalty = 3
	max_darts = 30
	burst_delay = 1
	burst = 3
	burst_accuracy = list(0,-1,-1)
	dispersion = list(0.0, 0.6, 1.0)

//the projectile
/obj/item/foam_dart
	name = "foam dart"
	desc = "An official Jorf brand foam dart, for use only with official Jorf brand foam dart launching products."
	icon = 'icons/obj/guns/foam/dart.dmi'
	icon_state = "dart"
	w_class = ITEM_SIZE_TINY
	randpixel = 10
	throw_range = 3
	does_spin = FALSE
	material = /decl/material/solid/organic/plastic/foam
	_base_attack_force = 0
	_thrown_force_multiplier = 5

/obj/item/foam_dart/Initialize()
	mix_up()
	. = ..()

/obj/item/foam_dart/proc/mix_up()
	pixel_x = rand(-randpixel, randpixel)
	pixel_y = rand(-randpixel, randpixel)
	set_dir(pick(global.alldirs))

/obj/item/foam_dart/tampered
	_base_attack_force = 1

/obj/item/foam_dart/tampered/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += SPAN_WARNING("Closer inspection reveals some weights in the rubber dome.")

//boxes of the projectile
/obj/item/box/foam_darts
	name = "box of foam darts"
	desc = "It's a box of official Jorf brand foam darts, for use only with official Jorf brand products."
	icon = 'icons/obj/guns/foam/boxes.dmi'
	icon_state = "dart_box"

/obj/item/box/foam_darts/WillContain()
	return list(/obj/item/foam_dart = 14)

//preset boxes
/obj/item/box/large/foam_gun
	name = "\improper Jorf blaster set"
	desc = "It's an official Jorf brand blaster, with three official Jorf brand darts!"
	icon = 'icons/obj/guns/foam/boxes.dmi'
	icon_state = "blaster_box"

/obj/item/box/large/foam_gun/WillContain()
	return list(
			/obj/item/gun/launcher/foam,
			/obj/item/foam_dart = 3
		)

/obj/item/box/large/foam_gun/burst
	name = "\improper Jorf Outlander set"
	desc = "It's an official Jorf brand Outlander, with six official Jorf brand darts!"

/obj/item/box/large/foam_gun/burst/WillContain()
	return list(
			/obj/item/gun/launcher/foam/burst,
			/obj/item/foam_dart = 6
		)

/obj/item/box/large/foam_gun/revolver
	name = "\improper Jorf Desperado set"
	desc = "It's an official Jorf brand Desperado, with eight official Jorf brand darts!"

/obj/item/box/large/foam_gun/revolver/WillContain()
	return list(
			/obj/item/gun/launcher/foam/revolver,
			/obj/item/foam_dart = 8
		)

/obj/item/box/large/foam_gun/revolver/tampered
	desc = "It's a Jorf brand Desperado, with fourteen Jorf brand darts!"

/obj/item/box/large/foam_gun/revolver/tampered/WillContain()
	return list(
			/obj/item/gun/launcher/foam/revolver/tampered,
			/obj/item/foam_dart/tampered = 14
		)