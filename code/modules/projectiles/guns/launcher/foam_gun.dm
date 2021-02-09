/obj/item/gun/foam
	name = "foam blaster"
	desc = "The classic Jorf blaster!"
	icon = 'icons/obj/guns/foam/blaster.dmi'
	icon_state = ICON_STATE_WORLD
	force = 1
	w_class = ITEM_SIZE_SMALL
	obj_flags = null
	slot_flags = SLOT_LOWER_BODY | SLOT_HOLSTER
	accuracy = 1
	fire_sound = 'sound/weapons/foamblaster.ogg'
	fire_sound_text = "a pleasing 'pomp'"
	material = /decl/material/solid/plastic
	receiver = /obj/item/firearm_component/receiver/launcher/foam

/obj/item/gun/foam/burst
	name = "foam machine pistol"
	desc = "The Jorf Outlander, a machine pistol blaster, fires two darts in rapid succession. Holds 4 darts."
	icon =  'icons/obj/guns/foam/pistol.dmi'
	w_class = ITEM_SIZE_NORMAL
	burst = 2
	fire_delay = 12
	receiver = /obj/item/firearm_component/receiver/launcher/foam/smg

/obj/item/gun/foam/revolver
	name = "foam revolver"
	desc = "The Jorf Desperado is a revolver blaster, with a hammer action so you can fan the hammer like a real desperado! It holds 6 darts."
	icon =  'icons/obj/guns/foam/revolver.dmi'
	w_class = ITEM_SIZE_NORMAL
	fire_delay = 4
	receiver = /obj/item/firearm_component/receiver/launcher/foam/revolver

/obj/item/gun/foam/revolver/tampered
	receiver = /obj/item/firearm_component/receiver/launcher/foam/revolver/tampered
//the projectile
/obj/item/foam_dart
	name = "foam dart"
	desc = "An offical Jorf brand foam dart, for use only with offical Jorf brand foam dart launching products."
	icon = 'icons/obj/guns/foam/dart.dmi'
	icon_state = "dart"
	w_class = ITEM_SIZE_TINY
	force = 0
	randpixel = 10
	throwforce = 0
	throw_range = 3
	does_spin = FALSE

/obj/item/foam_dart/Initialize()
	mix_up()
	. = ..()
	
/obj/item/foam_dart/proc/mix_up()
	pixel_x = rand(-randpixel, randpixel)
	pixel_y = rand(-randpixel, randpixel)
	set_dir(pick(global.alldirs))

/obj/item/foam_dart/tampered
	throwforce = 4

/obj/item/foam_dart/tampered/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, SPAN_WARNING("Closer inspection reveals some weights in the rubber dome."))

//boxes of the projectile
/obj/item/storage/box/foam_darts
	name = "box of foam darts"
	desc = "It's a box of offical Jorf brand foam darts, for use only with offical Jorf brand products."
	icon = 'icons/obj/guns/foam/boxes.dmi'
	icon_state = "dart_box"
	startswith = list(/obj/item/foam_dart = 14)

//preset boxes
/obj/item/storage/box/large/foam_gun
	name = "\improper Jorf blaster set"
	desc = "It's an official Jorf brand blaster, with three official Jorf brand darts!"
	icon = 'icons/obj/guns/foam/boxes.dmi'
	icon_state = "blaster_box"
	startswith = list(/obj/item/gun/foam,
					  /obj/item/foam_dart = 3)

/obj/item/storage/box/large/foam_gun/burst
	name = "\improper Jorf Outlander set"
	desc = "It's an official Jorf brand Outlander, with six official Jorf brand darts!"
	startswith = list(/obj/item/gun/foam/burst,
					  /obj/item/foam_dart = 6)

/obj/item/storage/box/large/foam_gun/revolver
	name = "\improper Jorf Desperado set"
	desc = "It's an official Jorf brand Desperado, with eight official Jorf brand darts!"
	startswith = list(/obj/item/gun/foam/revolver,
					  /obj/item/foam_dart = 8)

/obj/item/storage/box/large/foam_gun/revolver/tampered
	desc = "It's a Jorf brand Desperado, with fourteen Jorf brand darts!"
	startswith = list(/obj/item/gun/foam/revolver/tampered,
					  /obj/item/foam_dart/tampered = 14)