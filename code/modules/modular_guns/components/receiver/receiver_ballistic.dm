/obj/item/firearm_component/receiver/ballistic
	var/caliber = CALIBER_PISTOL
	var/handle_casings = EJECT_CASINGS
	var/load_method = SINGLE_CASING|SPEEDLOADER
	var/max_shells = 0                       // the number of casings that will fit inside
	var/is_jammed = FALSE                    // Whether this gun is jammed
	var/jam_chance = 0                       // Chance it jams on fire
	var/allowed_magazines                    // magazine types that may be loaded. Can be a list or single path
	var/auto_eject = FALSE                   // if the magazine should automatically eject itself when empty.
	var/ammo_indicator                       // if true, draw ammo indicator overlays
	var/list/loaded                          // Currently loaded shots. Set to a path to fill the list at Initialize()
	var/obj/item/ammo_magazine/ammo_magazine //stored magazine, set to a path to spawn/load at Initialize()
	var/obj/item/ammo_casing/chambered
	var/auto_eject_sound
	var/load_sound =       'sound/weapons/guns/interaction/bullet_insert.ogg'
	var/mag_insert_sound = 'sound/weapons/guns/interaction/pistol_magin.ogg'
	var/mag_remove_sound = 'sound/weapons/guns/interaction/pistol_magout.ogg'

/obj/item/firearm_component/receiver/ballistic/Initialize(ml, material_key)
	. = ..()
	if(ispath(loaded))
		var/ammo_type = loaded
		loaded = list()
		for(var/i in 1 to max_shells)
			loaded += new ammo_type(src)
	if(!islist(loaded))
		loaded = list()
	if(ispath(ammo_magazine))
		ammo_magazine = new ammo_magazine(src)

/obj/item/firearm_component/receiver/ballistic/get_caliber()
	return caliber

/obj/item/firearm_component/receiver/ballistic/get_next_projectile(var/mob/user)

	if(!istype(loc, /obj/item/gun))
		return

	if(!is_jammed && prob(jam_chance))
		loc.visible_message(SPAN_DANGER("\The [loc] jams!"))
		if(istype(user))
			if(prob(user.skill_fail_chance(SKILL_WEAPONS, 100, SKILL_PROF)))
				return
			to_chat(user, SPAN_NOTICE("You reflexively clear the jam on \the [src]."))
			is_jammed = FALSE
			playsound(loc, 'sound/weapons/flipblade.ogg', 50, 1)
	if(is_jammed)
		return

	if(length(loaded))
		chambered = loaded[1]
		if(handle_casings != HOLD_CASINGS)
			loaded -= chambered
	else if(length(ammo_magazine?.stored_ammo))
		chambered = ammo_magazine.stored_ammo[ammo_magazine.stored_ammo.len]
		if(handle_casings != HOLD_CASINGS)
			ammo_magazine.stored_ammo -= chambered
	if(chambered)
		return chambered.BB

/obj/item/firearm_component/receiver/ballistic/can_accept_ammo(var/obj/item/ammo)
	return FALSE

/obj/item/firearm_component/receiver/ballistic/get_caliber()
	return caliber

/obj/item/firearm_component/receiver/ballistic/set_caliber(var/_caliber)
	caliber = _caliber

/obj/item/firearm_component/receiver/ballistic/Initialize(ml, material_key)
	. = ..()
	name = "\improper [caliber] [name]"

/obj/item/firearm_component/receiver/ballistic/handle_post_holder_fire()
	if(chambered)
		chambered.expend()
	if(istype(loc, /obj/item/gun) && auto_eject && ammo_magazine && !length(ammo_magazine.stored_ammo))
		ammo_magazine.dropInto(get_turf(src))
		loc.visible_message(SPAN_NOTICE("\The [ammo_magazine] falls out of \the [loc] and clatters on the floor!"))
		if(auto_eject_sound)
			playsound(loc, auto_eject_sound, 40, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon()
		loc.update_icon()

/obj/item/firearm_component/receiver/ballistic/process_point_blank(obj/projectile, mob/user, atom/target)
	..()
	if(chambered && ishuman(target))
		var/mob/living/carbon/human/H = target
		var/zone = BP_CHEST
		if(user && user.zone_sel)
			zone = user.zone_sel.selecting
		var/obj/item/organ/external/E = H.get_organ(zone)
		if(E)
			chambered.put_residue_on(E)
			H.apply_damage(3, BURN, used_weapon = "Gunpowder Burn", given_organ = E)

/obj/item/firearm_component/receiver/ballistic/handle_click_empty()
	..()
	process_chambered()

/obj/item/firearm_component/receiver/ballistic/process_chambered()
	if(!chambered)
		return
	switch(handle_casings)
		if(EJECT_CASINGS)
			chambered.dropInto(get_turf(src))
			chambered.throw_at(get_ranged_target_turf(get_turf(src), turn(loc.dir,270), 1), rand(0,1), 5)
			if(LAZYLEN(chambered.fall_sounds))
				playsound(loc, pick(chambered.fall_sounds), 50, 1)
		if(CYCLE_CASINGS)
			if(ammo_magazine)
				ammo_magazine.stored_ammo += chambered
			else
				loaded += chambered
	if(handle_casings != HOLD_CASINGS)
		chambered = null

/obj/item/firearm_component/receiver/ballistic/can_accept_ammo(var/obj/item/ammo)

	if(istype(ammo, /obj/item/ammo_magazine))
		var/obj/item/ammo_magazine/magazine = ammo
		return (load_method & magazine.mag_type) && get_caliber() == magazine.caliber

	if(istype(ammo, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/casing = ammo
		return (load_method & SINGLE_CASING) && get_caliber() == casing.caliber

	return FALSE

/obj/item/firearm_component/receiver/ballistic/load_ammo(var/mob/user, var/obj/item/loading)

	if(!can_accept_ammo(loading))
		return FALSE

	if(istype(loading, /obj/item/ammo_magazine))
		. = TRUE
		var/obj/item/ammo_magazine/magazine = loading
		if(magazine.mag_type == MAGAZINE)
			if(allowed_magazines)
				if(!(loading.type in (islist(allowed_magazines) ? allowed_magazines : list(allowed_magazines))))
					to_chat(user, SPAN_WARNING("\The [loading] won't fit into \the [loc]."))
					return TRUE
				if(ammo_magazine)
					to_chat(user, SPAN_WARNING("\The [loc] already has a magazine loaded."))
					return TRUE
				if(user.unEquip(loading, src))
					ammo_magazine = loading
					user.visible_message(SPAN_NOTICE("\The [user] inserts \the [loading] into \the [loc]."))
					playsound(loc, mag_insert_sound, 50, 1)

		else if(magazine.mag_type == SPEEDLOADER)
			if(length(loaded) >= max_shells)
				to_chat(user, SPAN_WARNING("\The [loc] is full!"))
				return TRUE
			var/count = 0
			for(var/obj/item/ammo_casing/casing in magazine.stored_ammo)
				if(length(loaded) >= max_shells)
					break
				if(casing.caliber == get_caliber())
					casing.forceMove(src)
					loaded += casing
					magazine.stored_ammo -= casing
					count++
				if(count)
					user.visible_message(SPAN_NOTICE("\The [user] reloads \the [loc]."), SPAN_NOTICE("You load [count] round\s into \the [loc]."))
					playsound(loc, 'sound/weapons/empty.ogg', 50, 1)

	else if(istype(loading, /obj/item/ammo_casing))
		. = TRUE
		var/obj/item/ammo_casing/casing = loading
		if(length(loaded) >= max_shells)
			to_chat(user, SPAN_WARNING("\The [loc] is full."))
			return
		if(user.unEquip(casing, src))
			loaded.Insert(1, casing)
			user.visible_message(SPAN_NOTICE("\The [user] inserts \a [casing] into \the [loc]."), SPAN_NOTICE("You insert \a [casing] into \the [loc]."))
			playsound(loc, load_sound, 50, 1)

	if(.)
		update_icon()
		loading.update_icon()


/obj/item/firearm_component/receiver/ballistic/unload_ammo(var/mob/user)

	if(is_jammed)
		user.visible_message(SPAN_NOTICE("\The [user] begins to unjam \the [loc]."), SPAN_NOTICE("You clear the jam and unload \the [loc]."))
		if(!do_after(user, 4, loc))
			return
		if(is_jammed)
			is_jammed = FALSE
			playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)

	if(ammo_magazine)
		user.put_in_hands(ammo_magazine)
		user.visible_message(SPAN_NOTICE("\The [user] removes \the [ammo_magazine] from \the [loc]."))
		playsound(loc, mag_remove_sound, 50, 1)
		ammo_magazine.update_icon()
		ammo_magazine = null
		update_icon()
		loc.update_icon()
		return TRUE

	if(!length(loaded))
		to_chat(user, SPAN_WARNING("\The [loc] is empty."))
		return TRUE

	if(load_method & SPEEDLOADER)
		var/count = 0
		var/turf/T = get_turf(src)
		for(var/obj/item/ammo_casing/casing in loaded)
			if(LAZYLEN(casing.fall_sounds))
				playsound(loc, pick(casing.fall_sounds), 50, 1)
			casing.forceMove(T)
			count++
		loaded.Cut()
		if(count)
			user.visible_message(SPAN_NOTICE("\The [user] unloads \the [loc]."), SPAN_NOTICE("You unload [count] round\s from \the [loc]."))
		. = TRUE
	else if(load_method & SINGLE_CASING)
		var/obj/item/ammo_casing/casing = loaded[loaded.len]
		loaded -= casing
		user.put_in_hands(casing)
		user.visible_message(SPAN_NOTICE("\The [user] removes \a [casing] from \the [loc]."))
		. = TRUE

	if(.)
		update_icon()
		loc.update_icon()

/obj/item/firearm_component/receiver/ballistic/show_examine_info(var/mob/user)
	if(is_jammed && user.skill_check(SKILL_WEAPONS, SKILL_BASIC))
		to_chat(user, SPAN_WARNING("It looks jammed."))
	if(ammo_magazine)
		to_chat(user, "It has \a [ammo_magazine] loaded.")
	if(user.skill_check(SKILL_WEAPONS, SKILL_ADEPT))
		to_chat(user, "It has [length(loaded) + length(ammo_magazine?.stored_ammo) + !!chambered] round\s remaining.")

/obj/item/firearm_component/receiver/ballistic/get_holder_overlay(holder_state)
	var/image/ret = ..()
	if(ret && ammo_indicator)
		ret.overlays += get_ammo_indicator(holder_state)
	return ret

/obj/item/firearm_component/receiver/ballistic/proc/get_ammo_indicator(var/base_state)
	var/remaining_shots = length(ammo_magazine?.stored_ammo)
	if(!remaining_shots)
		return mutable_appearance(icon, "[base_state]-ammo_bad")
	else if(remaining_shots <= ammo_magazine.max_ammo * 0.5)
		return mutable_appearance(icon, "[base_state]-ammo_warn") 
	else
		return mutable_appearance(icon, "[base_state]-ammo_ok") 

// Subtypes
/obj/item/firearm_component/receiver/ballistic/cycle
	loaded = /obj/item/ammo_casing/shotgun/beanbag
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2

/obj/item/firearm_component/receiver/ballistic/pistol
	load_method = MAGAZINE
	ammo_magazine = /obj/item/ammo_magazine/pistol
	allowed_magazines = /obj/item/ammo_magazine/pistol
	ammo_indicator = TRUE

/obj/item/firearm_component/receiver/ballistic/pistol/get_ammo_indicator(base_state)
	var/image/ret = ..()
	if(ret && !length(ammo_magazine?.stored_ammo))
		ret.overlays += "[base_state]-e"
	return ret

/obj/item/firearm_component/receiver/ballistic/pistol/holdout
	ammo_magazine = /obj/item/ammo_magazine/pistol/small
	allowed_magazines = /obj/item/ammo_magazine/pistol/small
	ammo_indicator = FALSE

/obj/item/firearm_component/receiver/ballistic/zipgun
	handle_casings = CYCLE_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1 
