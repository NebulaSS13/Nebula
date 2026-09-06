// Used in conjunction with /obj/structure/target_stake.
/obj/item/training_dummy
	name                 = "shooting target"
	desc                 = "A shooting target."
	icon                 = 'icons/obj/items/training_dummies/standard.dmi'
	icon_state           = ICON_STATE_WORLD
	material             = /decl/material/solid/metal/aluminium
	material_alteration  = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	max_health           = 1800
	appearance_flags     = KEEP_TOGETHER // Needed for BLEND_INSET_OVERLAY on the decals.

	// Burn/bullet hole/dent decals to apply to our icon.
	var/list/decals
	var/const/MAX_DECALS = 250

	// Very crude bounding box; we do pixel-precise checking within these ranges.
	var/decal_min_x   = 7
	var/decal_min_y   = 3
	var/decal_range_x = 17
	var/decal_range_y = 25

/obj/item/training_dummy/proc/get_damage_decal_icon()
	return 'icons/obj/items/training_dummies/damage.dmi'

// Can't repair cloth, straw or plastic targets currently.
/obj/item/training_dummy/proc/can_repair_with(obj/item/thing)
	return IS_WELDER(thing) && istype(material, /decl/material/solid/metal)

/obj/item/training_dummy/proc/perform_repair(mob/user, obj/item/tool)
	var/obj/item/weldingtool/welder = tool
	if(!istype(welder) || !welder.isOn())
		to_chat(user, SPAN_WARNING("Turn \the [welder] on first."))
		return FALSE
	return tool.do_tool_interaction(TOOL_WELDER, user, src, 2 SECONDS)

/obj/item/training_dummy/proc/repair_target_dummy(obj/item/used_item, mob/user)

	if(!can_repair_with(used_item))
		return FALSE

	var/max_health = get_max_health()
	if(current_health >= max_health)
		to_chat(user, SPAN_NOTICE("\The [src] doesn't need repairs."))
		return TRUE

	if(perform_repair(user, used_item))
		current_health += rand(100,200) // They have a lot of HP.
		if(LAZYLEN(decals))
			if(current_health >= get_max_health())
				current_health = get_max_health()
				LAZYCLEARLIST(decals)
			else
				var/remove_decal = pick(decals)
				LAZYREMOVE(decals, remove_decal)
			update_icon()
		return TRUE

	return FALSE

/obj/item/training_dummy/attackby(obj/item/used_item, mob/user)
	if(repair_target_dummy(used_item, user))
		return TRUE
	return ..()

/obj/item/training_dummy/take_damage(damage, damage_type, damage_flags, inflicter, armor_pen, silent, do_update_health)

	var/old_health = current_health
	. = ..()
	if(QDELETED(src) || old_health == current_health)
		return

	if(damage <= 0)
		update_icon()
		return

	if(LAZYLEN(decals) >= MAX_DECALS)
		return

	var/decal_icon = get_damage_decal_icon()
	if(!decal_icon)
		return

	var/decal_state
	if(damage_type == BURN)
		if(damage < 10)
			decal_state = "light_scorch"
		else
			decal_state = "scorch"
	else if(damage_type == BRUTE)
		if(damage < 10)
			decal_state = "dent"
		else
			decal_state = "bhole"
	else
		return

	var/image/new_decal = image(decal_icon, decal_state)
	new_decal.blend_mode = BLEND_INSET_OVERLAY
	new_decal = apply_decal_offsets(new_decal)
	if(new_decal)
		LAZYADD(decals, new_decal)
		update_icon()

/obj/item/training_dummy/proc/apply_decal_offsets(image/decal)

	// Static list cache for this broke immediately, so seems like we need a fresh icon every time.
	// At least it isn't being assigned anywhere so shouldn't cause network overhead.
	var/icon/check_icon = icon(icon, icon_state)
	if(!check_icon)
		return

	var/use_pixel_x
	var/use_pixel_y
	var/sanity = 100
	while(sanity)
		sanity--
		use_pixel_x = decal_min_x + rand(decal_range_x)
		use_pixel_y = decal_min_y + rand(decal_range_y)
		var/check_pixel = check_icon.GetPixel(use_pixel_x, use_pixel_y)
		// Pixel has a colour and no alpha component; we are good.
		if(istext(check_pixel) && length(check_pixel) == 7)
			break

	if(!sanity || !isnum(use_pixel_x) || use_pixel_x < 0 || !isnum(use_pixel_y) || use_pixel_y < 0)
		return

	decal.pixel_x = use_pixel_x
	decal.pixel_y = use_pixel_y
	return decal

/obj/item/training_dummy/on_update_icon()
	. = ..()
	if(LAZYLEN(decals))
		if(current_health >= get_max_health())
			LAZYCLEARLIST(decals)
		else
			set_overlays(decals.Copy())
		if(istype(loc, /obj/structure/target_stake))
			compile_overlays() // We need to update our loc immediately.
			loc.update_icon()

/obj/item/training_dummy/syndicate
	icon                = 'icons/obj/items/training_dummies/syndicate.dmi'
	desc                = "A shooting target that looks like a hostile agent."
	decal_min_x         = 7
	decal_min_y         = 2
	decal_range_x       = 18
	decal_range_y       = 30

/obj/item/training_dummy/alien
	icon                = 'icons/obj/items/training_dummies/alien.dmi'
	desc                = "A shooting target with a threatening silhouette."
	decal_min_x         = 7
	decal_min_y         = 2
	decal_range_x       = 18
	decal_range_y       = 30

/obj/item/training_dummy/straw
	name                = "training dummy"
	icon                = 'icons/obj/items/training_dummies/straw.dmi'
	desc                = "A roughly humanoid shape used for melee practice."
	material            = /decl/material/solid/organic/plantmatter/grass/dry
	material_alteration = MAT_FLAG_ALTERATION_ALL
	decal_min_x         = 8
	decal_min_y         = 12
	decal_range_x       = 16
	decal_range_y       = 17

/obj/item/training_dummy/straw/archery
	name                = "archery butt"
	icon                = 'icons/obj/items/training_dummies/archery.dmi'
	desc                = "A thick circular mat used for archery practice."
	decal_min_x         = 7
	decal_min_y         = 5
	decal_range_x       = 19
	decal_range_y       = 21
