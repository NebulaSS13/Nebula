/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo/casings/pistol.dmi'
	icon_state = ICON_STATE_WORLD + "-preview"
	randpixel = 10
	obj_flags = OBJ_FLAG_CONDUCTIBLE | OBJ_FLAG_HOLLOW
	slot_flags = SLOT_LOWER_BODY | SLOT_EARS
	w_class = ITEM_SIZE_TINY
	color = /decl/material/solid/metal/brass::color // mapping preview color
	material = /decl/material/solid/metal/brass
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	drop_sound = list(
		'sound/weapons/guns/casingfall1.ogg',
		'sound/weapons/guns/casingfall2.ogg',
		'sound/weapons/guns/casingfall3.ogg'
	)

	var/leaves_residue = TRUE
	var/caliber = ""					//Which kind of guns it can be loaded into
	var/projectile_type					//The bullet type to create when New() is called
	var/obj/item/projectile/BB = null	//The loaded bullet - make it so that the projectiles are created only when needed?
	var/bullet_color = COLOR_COPPER
	var/marking_color

/obj/item/ammo_casing/get_contained_external_atoms()
	. = ..()
	if(. && BB)
		LAZYREMOVE(., BB)

/obj/item/ammo_casing/Initialize()
	if(ispath(projectile_type))
		BB = new projectile_type(src)
		if(caliber && istype(BB, /obj/item/projectile/bullet))
			var/obj/item/projectile/bullet/B = BB
			B.caliber = caliber
	. = ..()

/obj/item/ammo_casing/Destroy()
	QDEL_NULL(BB)
	return ..()

//removes the projectile from the ammo casing
/obj/item/ammo_casing/proc/expend()
	. = BB
	BB = null
	set_dir(pick(global.alldirs)) //spin spent casings
	// Aurora forensics port, gunpowder residue.
	if(leaves_residue)
		leave_residue()
	update_icon()
	update_name()

/obj/item/ammo_casing/Crossed(atom/movable/AM)
	..()
	if(!isliving(AM))
		return

	var/mob/living/L = AM
	if(L.buckled || MOVING_DELIBERATELY(L) || prob(90))
		return

	playsound(src, pick(drop_sound), 50, 1)
	var/turf/turf_current = get_turf(src)
	var/turf/turf_destiinaton = get_step(turf_current, AM.dir)
	if(turf_destiinaton.Adjacent(turf_current))
		throw_at(turf_destiinaton, 2, 2, spin = FALSE)
		animate(src, pixel_x = rand(-16, 16), pixel_y = rand(-16, 16), transform = turn(matrix(), rand(120, 300)), time = rand(3, 8))

/obj/item/ammo_casing/proc/leave_residue()
	var/obj/item/gun/G = get_recursive_loc_of_type(/obj/item/gun)
	if(G)
		put_residue_on(G)
		var/mob/living/human/H = G.get_recursive_loc_of_type(/mob/living/human)
		if(H)
			var/holding_slot = H.get_held_slot_for_item(G)
			if(holding_slot)
				var/target = H.get_covering_equipped_item_by_zone(holding_slot) || GET_EXTERNAL_ORGAN(H, holding_slot)
				if(target)
					put_residue_on(target)
	if(prob(30))
		put_residue_on(get_turf(src))

/obj/item/ammo_casing/proc/put_residue_on(atom/A)
	if(A)
		var/datum/extension/forensic_evidence/forensics = get_or_create_extension(A, /datum/extension/forensic_evidence)
		forensics.add_from_atom(/datum/forensics/gunshot_residue, src)

/obj/item/ammo_casing/attackby(obj/item/used_item, mob/user)
	if(!IS_SCREWDRIVER(used_item))
		return ..()
	if(!BB)
		to_chat(user, "<span class='notice'>There is no bullet in the casing to inscribe anything into.</span>")
		return TRUE

	var/tmp_label = ""
	var/label_text = sanitize_safe(input(user, "Inscribe some text into \the [initial(BB.name)]","Inscription",tmp_label), MAX_NAME_LEN)
	if(length(label_text) > 20)
		to_chat(user, "<span class='warning'>The inscription can be at most 20 characters long.</span>")
	else if(!label_text)
		to_chat(user, "<span class='notice'>You scratch the inscription off of [initial(BB)].</span>")
		BB.SetName(initial(BB.name))
	else
		to_chat(user, "<span class='notice'>You inscribe \"[label_text]\" into \the [initial(BB.name)].</span>")
		BB.SetName("[initial(BB.name)] (\"[label_text]\")")
	return TRUE

// This is separate because on_update_icon() needs to call parent,
// and shells need to override this.
/obj/item/ammo_casing/proc/update_casing_icon()
	if(BB)
		var/image/I = overlay_image(icon, "[icon_state]-bullet", bullet_color, flags=RESET_COLOR)
		I.dir = dir // don't overlays inherit dir already? is this needed?
		add_overlay(I)
	if(marking_color)
		var/image/I = overlay_image(icon, "[icon_state]-marking", marking_color, flags=RESET_COLOR)
		I.dir = dir
		add_overlay(I)

/obj/item/ammo_casing/on_update_icon()
	. = ..()
	update_casing_icon()

/obj/item/ammo_casing/update_name()
	. = ..()
	if(!BB)
		SetName("spent [name]")

/obj/item/ammo_casing/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(caliber)
		. += "Its caliber is [caliber]."
	if (!BB)
		. += "This one is spent."

//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "357"
	icon = 'icons/obj/ammo.dmi'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	item_state = "syringe_kit"
	material = /decl/material/solid/metal/steel
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 10

	var/list/stored_ammo = list()
	var/mag_type = SPEEDLOADER //ammo_magazines can only be used with compatible guns. This is not a bitflag, the load_method var on guns is.
	var/caliber = "357"
	var/max_ammo = 7

	var/ammo_type = /obj/item/ammo_casing //ammo type that is initially loaded
	var/initial_ammo = null

	var/multiple_sprites = 0
	var/list/labels						//If something should be added to name on spawn aside from caliber
	//because BYOND doesn't support numbers as keys in associative lists
	var/list/icon_keys = list()		//keys
	var/list/ammo_states = list()	//values

	/// Determines whether or not we wait until the first time our contents are gotten to initialize contents. May lead to icon bugs if not handled delicately.
	var/lazyload_contents = TRUE
	/// Whether or not our contents have been initialized or not, used in lazyloaded contents.
	var/contents_initialized = FALSE

/obj/item/ammo_magazine/box
	w_class = ITEM_SIZE_NORMAL

/obj/item/ammo_magazine/proc/create_initial_contents()
	if(contents_initialized || !initial_ammo || !ammo_type)
		return
	for(var/i in 1 to initial_ammo)
		stored_ammo += new ammo_type(src)
	contents_initialized = TRUE

/obj/item/ammo_magazine/get_contained_matter(include_reagents = TRUE)
	. = ..()
	if(!lazyload_contents || contents_initialized || !ammo_type || !initial_ammo)
		return
	// Add our expected matter from lazyloaded stuff.
	var/list/ammo_matter = atom_info_repository.get_matter_for(ammo_type).Copy()
	for(var/matter_entry in ammo_matter)
		ammo_matter[matter_entry] *= initial_ammo
	. = MERGE_ASSOCS_WITH_NUM_VALUES(., ammo_matter)

/obj/item/ammo_magazine/proc/get_stored_ammo_count()
	. = length(stored_ammo)
	if(!contents_initialized)
		. += initial_ammo

/obj/item/ammo_magazine/Initialize()
	. = ..()
	if(multiple_sprites)
		initialize_magazine_icondata(src)

	if(isnull(initial_ammo))
		initial_ammo = max_ammo

	if(!lazyload_contents)
		create_initial_contents()
	if(caliber)
		LAZYINSERT(labels, caliber, 1)
	if(LAZYLEN(labels))
		SetName("[name] ([english_list(labels, and_text = ", ")])")
	update_icon()

/obj/item/ammo_magazine/attackby(obj/item/used_item, mob/user)
	if(!istype(used_item, /obj/item/ammo_casing))
		return ..()
	var/obj/item/ammo_casing/C = used_item
	if(C.caliber != caliber)
		to_chat(user, "<span class='warning'>[C] does not fit into [src].</span>")
		return TRUE
	if(get_stored_ammo_count() >= max_ammo)
		to_chat(user, "<span class='warning'>[src] is full!</span>")
		return TRUE
	if(!user.try_unequip(C, src))
		return TRUE
	stored_ammo.Add(C)
	playsound(user, 'sound/weapons/guns/interaction/bullet_insert.ogg', 50, 1)
	update_icon()
	return TRUE

/obj/item/ammo_magazine/attack_self(mob/user)
	if(!get_stored_ammo_count())
		to_chat(user, SPAN_NOTICE("[src] is already empty!"))
		return
	to_chat(user, SPAN_NOTICE("You empty [src]."))
	create_initial_contents()
	for(var/obj/item/ammo_casing/C in stored_ammo)
		C.forceMove(user.loc)
		C.set_dir(pick(global.alldirs))
	stored_ammo.Cut()
	update_icon()


/obj/item/ammo_magazine/attack_hand(mob/user)
	if(!user.is_holding_offhand(src) || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	if(!get_stored_ammo_count())
		to_chat(user, SPAN_NOTICE("\The [src] is already empty!"))
		return TRUE
	create_initial_contents()
	var/obj/item/ammo_casing/C = stored_ammo[stored_ammo.len]
	stored_ammo -= C
	user.put_in_hands(C)
	user.visible_message(
		"\The [user] removes \a [C] from [src].",
		SPAN_NOTICE("You remove \a [C] from [src].")
	)
	update_icon()
	return TRUE

/obj/item/ammo_magazine/on_update_icon()
	. = ..()
	if(multiple_sprites)
		//find the lowest key greater than or equal to our ammo count
		var/new_state = null
		var/self_ammo_count = get_stored_ammo_count()
		for(var/idx in 1 to icon_keys.len)
			var/icon_ammo_count = icon_keys[idx]
			if (icon_ammo_count >= self_ammo_count)
				new_state = ammo_states[idx]
				break
		icon_state = (new_state)? new_state : initial(icon_state)

/obj/item/ammo_magazine/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/self_ammo_count = get_stored_ammo_count()
	. += "There [(self_ammo_count == 1)? "is" : "are"] [self_ammo_count] round\s left!"

//magazine icon state caching
var/global/list/magazine_icondata_keys = list()
var/global/list/magazine_icondata_states = list()

/proc/initialize_magazine_icondata(var/obj/item/ammo_magazine/M)
	var/typestr = "[M.type]"
	if(!(typestr in magazine_icondata_keys) || !(typestr in magazine_icondata_states))
		magazine_icondata_cache_add(M)

	M.icon_keys = magazine_icondata_keys[typestr]
	M.ammo_states = magazine_icondata_states[typestr]

/proc/magazine_icondata_cache_add(var/obj/item/ammo_magazine/M)
	var/list/icon_keys = list()
	var/list/ammo_states = list()
	for(var/i = 0, i <= M.max_ammo, i++)
		var/ammo_state = "[M.icon_state]-[i]"
		if(check_state_in_icon(ammo_state, M.icon))
			icon_keys += i
			ammo_states += ammo_state

	magazine_icondata_keys["[M.type]"] = icon_keys
	magazine_icondata_states["[M.type]"] = ammo_states
