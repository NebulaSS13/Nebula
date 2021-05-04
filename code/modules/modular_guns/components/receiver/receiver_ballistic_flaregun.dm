/obj/item/firearm_component/receiver/ballistic/flaregun
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 1
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'
	loaded = /obj/item/ammo_casing/shotgun/flash

/obj/item/firearm_component/receiver/ballistic/flaregun/show_examine_info(mob/user)
	. = ..()
	if(length(loaded))
		to_chat(user, SPAN_NOTICE("\A [loaded[1]] is chambered."))

/obj/item/firearm_component/receiver/ballistic/flaregun/special_check()
	if(length(loaded) && !istype(loaded[1], /obj/item/ammo_casing/shotgun/flash))
		var/damage = chambered.BB.get_structure_damage()
		if(istype(chambered.BB, /obj/item/projectile/bullet/pellet))
			var/obj/item/projectile/bullet/pellet/PP = chambered.BB
			damage = PP.damage*PP.pellets
		if(damage > 5)
			var/mob/living/carbon/C = holder?.loc || loc
			if(istype(C))
				C.visible_message(SPAN_DANGER("\The [holder || src] explodes in [C]'s hands!"), SPAN_DANGER("\The [holder || src] explodes in your face!"))
				C.drop_from_inventory(src)
				for(var/zone in list(BP_L_HAND, BP_R_HAND))
					C.apply_damage(rand(10,20), def_zone=zone)
			else
				visible_message(SPAN_DANGER("\The [holder || src] explodes!"))
			explosion(get_turf(src), -1, -1, 1)
			qdel(holder || src)
			return FALSE
	. = ..()