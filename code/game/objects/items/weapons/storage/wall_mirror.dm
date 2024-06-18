/obj/structure/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) mirror! The leading brand in hair salon products, utilizing nano-machinery to style your hair just right. The black box inside warns against attempting to release the nanomachines."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	material = /decl/material/solid/glass
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY)
	storage = /datum/storage/structure/mirror
	directional_offset = @'{"NORTH":{"y":-29}, "SOUTH":{"y":29}, "EAST":{"x":29}, "WEST":{"x":-29}}'
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/shattered = FALSE
	var/list/ui_users

/obj/structure/mirror/WillContain()
	return list(
			/obj/item/grooming/comb/colorable/random,
			/obj/item/grooming/brush/colorable/random,
			/obj/item/grooming/file,
			/obj/random/medical/lite,
			/obj/random/lipstick,
			/obj/random/eyeshadow,
			/obj/random/soap,
			/obj/item/chems/spray/cleaner/deodorant,
			/obj/item/towel/random
		)

/obj/structure/mirror/Destroy()
	clear_ui_users(ui_users)
	. = ..()

/obj/structure/mirror/storage_inserted(atom/movable/thing)
	. = ..()
	flick("mirror_open",src)

/obj/structure/mirror/storage_removed(atom/movable/thing)
	. = ..()
	flick("mirror_open",src)

/obj/structure/mirror/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	if(prob(damage))
		visible_message(SPAN_WARNING("[src] shatters!"))
		shatter()
	. = ..()

/obj/structure/mirror/attack_hand(mob/user)
	if(user.a_intent == I_HURT)
		return ..()
	if(shattered)
		to_chat(user, SPAN_WARNING("You enter the key combination for the style you want on the panel, but the nanomachines inside \the [src] refuse to come out."))
	else
		open_mirror_ui(user, ui_users, "SalonPro Nano-Mirror&trade;", mirror = src)
	return TRUE

/obj/structure/mirror/proc/shatter()
	if(shattered)	return
	shattered = TRUE
	icon_state = "mirror_broke"
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_DANGER("\The [src] [material ? material.destruction_desc : "shatters"]!"))
	material.place_shards(T)
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"

/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.get_structure_damage() * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()

/obj/item/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! Now a portable version."
	icon = 'icons/obj/items/mirror.dmi'
	icon_state = "mirror"
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY
	)
	var/list/ui_users

/obj/item/mirror/attack_self(mob/user)
	open_mirror_ui(user, ui_users, "SalonPro Nano-Mirror&trade;", APPEARANCE_HAIR, src)

/obj/item/mirror/Destroy()
	clear_ui_users(ui_users)
	. = ..()

/proc/open_mirror_ui(var/mob/user, var/ui_users, var/title, var/flags, var/obj/item/mirror)
	if(!ishuman(user))
		return

	var/W = weakref(user)
	var/datum/nano_module/appearance_changer/AC = LAZYACCESS(ui_users, W)
	if(!AC)
		AC = new(mirror, user)
		AC.name = title
		if(flags)
			AC.flags = flags
		LAZYSET(ui_users, W, AC)
	AC.ui_interact(user)

/proc/clear_ui_users(var/list/ui_users)
	for(var/W in ui_users)
		var/AC = ui_users[W]
		qdel(AC)
	LAZYCLEARLIST(ui_users)
