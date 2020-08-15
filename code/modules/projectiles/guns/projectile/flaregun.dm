/obj/item/gun/projectile/flare
	name = "flaregun"
	desc = "A single shot polymer flare gun, the XI-54 \"Sirius\" is a reliable way to launch flares away from yourself."
	icon = 'icons/obj/guns/flaregun.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a satisfying 'thump'"
	slot_flags = SLOT_LOWER_BODY | SLOT_HOLSTER
	w_class = ITEM_SIZE_SMALL
	obj_flags = 0
	slot_flags = SLOT_LOWER_BODY | SLOT_HOLSTER
	material = /decl/material/solid/plastic
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)

	caliber = CALIBER_SHOTGUN
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 1
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'

/obj/item/gun/projectile/flare/loaded
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/gun/projectile/flare/examine(mob/user, distance)
	. = ..()
	if(distance <= 2 && loaded.len)
		to_chat(user, "\A [loaded[1]] is chambered.")

/obj/item/gun/projectile/flare/special_check()
	if(loaded.len && !istype(loaded[1], /obj/item/ammo_casing/shotgun/flash))
		var/damage = chambered.BB.get_structure_damage()
		if(istype(chambered.BB, /obj/item/projectile/bullet/pellet))
			var/obj/item/projectile/bullet/pellet/PP = chambered.BB
			damage = PP.damage*PP.pellets
		if(damage > 5)
			var/mob/living/carbon/C = loc
			if(istype(C))
				C.visible_message("<span class='danger'>[src] explodes in [C]'s hands!</span>", "<span class='danger'>[src] explodes in your face!</span>")
				C.drop_from_inventory(src)
				for(var/zone in list(BP_L_HAND, BP_R_HAND))
					C.apply_damage(rand(10,20), def_zone=zone)
			else
				visible_message("<span class='danger'>[src] explodes!</span>")
			explosion(get_turf(src), -1, -1, 1)
			qdel(src)
			return FALSE
	return ..()