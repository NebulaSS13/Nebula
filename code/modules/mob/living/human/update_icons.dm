var/global/list/_limb_mask_cache = list()
/proc/get_limb_mask_for(obj/item/organ/external/limb)
	var/decl/bodytype/bodytype = limb?.bodytype
	var/bodypart = limb?.icon_state
	if(!bodytype || !bodypart)
		return
	LAZYINITLIST(_limb_mask_cache[bodytype])
	if(!_limb_mask_cache[bodytype][bodypart])
		var/icon/limb_mask = icon(bodytype.icon_base, bodypart)
		limb_mask.MapColors(0,0,0, 0,0,0, 0,0,0, 1,1,1)
		_limb_mask_cache[bodytype][bodypart] = limb_mask
	return _limb_mask_cache[bodytype][bodypart]

/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk 1 or 0.
	TODO: Proper documentation
	icon_key is [bodytype.get_icon_cache_uid(src)][g][husk][skin_tone]
*/
var/global/list/human_icon_cache    = list()
var/global/list/eye_icon_cache      = list()
var/global/list/tail_icon_cache     = list() //key is [bodytype.get_icon_cache_uid(src)][skin_colour]

/proc/overlay_image(icon,icon_state,color,flags)
	var/image/ret = image(icon,icon_state)
	ret.color = color
	ret.appearance_flags = flags
	return ret

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/*

UPDATED August 2023: The comments below are from a point where human equipment overlay code was entirely
defined in procs in this file; please refer to get/set_current_mob_underlay/overlay and update_equipment_overlay.

Calling this  a system is perhaps a bit trumped up. It is essentially update_clothing dismantled into its
core parts. The key difference is that when we generate overlays we do not generate either lying or standing
versions. Instead, we generate both and store them in two fixed-length lists, both using the same list-index
(The indexes are in update_icons.dm): Each list for humans is (at the time of writing) of length 19.
This will hopefully be reduced as the system is refined.

When we call update_icons, the 'current_posture.prone' variable is checked and then the appropriate list is assigned to our overlays!
That in itself uses a tiny bit more memory (no more than all the ridiculous lists the game has already mind you).

On the other-hand, it should be very CPU cheap in comparison to the old system.
In the old system, we updated all our overlays every life() call, even if we were standing still inside a crate!
or dead!. 25ish overlays, all generated from scratch every second for every xeno/human/monkey and then applied.
More often than not update_clothing was being called a few times in addition to that! CPU was not the only issue,
all those icons had to be sent to every client. So really the cost was extremely cumulative. To the point where
update_clothing would frequently appear in the top 10 most CPU intensive procs during profiling.

Another feature of this new system is that our lists are indexed. This means we can update specific overlays!
So we only regenerate icons when we need them to be updated! This is the main saving for this system.

In practice this means that:
	everytime you fall over, we just switch between precompiled lists. Which is fast and cheap.
	Everytime you do something minor like take a pen out of your pocket, we only update the in-hand overlay
	etc...


There are several things that need to be remembered:

>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src) )
	You will need to call the update_equipment_overlay() proc with the approriate slot flag ie.
		update_equipment_overlay(slot_wear_suit_str)

>	There are also these special cases:
		update_genetic_conditions()	//handles updating your appearance for certain mutations.  e.g TK head-glows
		update_damage_overlays()	//handles damage overlays for brute/burn damage //(will rename this when I geta round to it)
		update_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
		update_hair()	//Handles updating your hair overlay (used to be update_face, but mouth and
																			...eyes were merged into update_body)

>	All of these procs update our overlay lists, and then call update_icon() by default.
	If you wish to update several overlays at once, you can set the argument to 0 to disable the update and call
	it manually:
		e.g.
		update_equipment_overlay(slot_head_str, FALSE)
		update_inhand_overlays()		//<---calls update_icon()

	or equivillantly:
		update_equipment_overlay(slot_head_str, FALSE)
		update_inhand_overlays(FALSE)
		update_icon()

>	If you need to update all overlays you can use try_refresh_visible_overlays(). it works exactly like update_clothing used to.

>	I reimplimented an old unused variable which was in the code called (coincidentally) var/update_icon
	It can be used as another method of triggering update_icon(). It's basically a flag that when set to non-zero
	will call update_icon() at the next life() call and then reset itself to 0.
	The idea behind it is icons are regenerated only once, even if multiple events requested it.

This system is confusing and is still a WIP. It's primary goal is speeding up the controls of the game whilst
reducing processing costs. So please bear with me while I iron out the kinks. It will be worth it, I promise.
If I can eventually free var/lying stuff from the life() process altogether, stuns/death/status stuff
will become less affected by lag-spikes and will be instantaneous! :3

If you have any questions/constructive-comments/bugs-to-report/or have a massivly devestated butt...
Please contact me on #coderbus IRC. ~Carn x
*/

/mob/living/human/refresh_visible_overlays()
	update_genetic_conditions(FALSE)
	update_body(FALSE)
	update_skin(FALSE)
	update_underwear(FALSE)
	update_hair(FALSE)
	update_inhand_overlays(FALSE)
	update_fire(FALSE)
	update_surgery(FALSE)
	update_bandages(FALSE)
	update_damage_overlays(FALSE)
	return ..()

/mob/living/human/on_update_icon()
	if(regenerate_body_icon)
		regenerate_body_icon = FALSE
	..()

/mob/living/human/apply_visible_overlays()
	var/list/visible_overlays
	var/list/visible_underlays
	if(is_cloaked())
		icon = 'icons/mob/human.dmi'
		icon_state = "blank"
		visible_overlays = get_current_mob_overlay(HO_INHAND_LAYER)
	else
		icon = stand_icon
		icon_state = null
		visible_overlays = 	get_all_current_mob_overlays()
		visible_underlays = get_all_current_mob_underlays()

	var/decl/bodytype/root_bodytype = get_bodytype()
	// We are somehow updating with no torso, or a torso with no bodytype (probably gibbing). No point continuing.
	if(!root_bodytype)
		return

	var/matrix/M = matrix()
	if(current_posture?.prone && (root_bodytype.prone_overlay_offset[1] || root_bodytype.prone_overlay_offset[2]))
		M.Translate(root_bodytype.prone_overlay_offset[1], root_bodytype.prone_overlay_offset[2])

	var/mangle_planes = FALSE
	for(var/i = 1 to LAZYLEN(visible_overlays))
		var/entry = visible_overlays[i]
		if(istype(entry, /image))
			var/image/overlay = entry
			if(i != HO_DAMAGE_LAYER)
				overlay.transform = M
			add_overlay(entry)
			mangle_planes = mangle_planes || overlay.plane >= ABOVE_LIGHTING_PLANE
		else if(islist(entry))
			for(var/image/overlay in entry)
				if(i != HO_DAMAGE_LAYER)
					overlay.transform = M
				add_overlay(overlay)
				mangle_planes = mangle_planes || overlay.plane >= ABOVE_LIGHTING_PLANE

	if(mangle_planes)
		z_flags |= ZMM_MANGLE_PLANES
	else
		z_flags &= ~ZMM_MANGLE_PLANES

	for(var/i = 1 to LAZYLEN(visible_underlays))
		var/entry = visible_underlays[i]
		if(istype(entry, /image))
			var/image/underlay = entry
			underlay.transform = M
		else if(islist(entry))
			for(var/image/underlay in entry)
				underlay.transform = M
	underlays = visible_underlays

/mob/living/proc/get_icon_scale_mult()
	// If you want stuff like scaling based on species or something, here is a good spot to mix the numbers together.
	return list(icon_scale_x, icon_scale_y)

/mob/living/human/update_appearance_flags(add_flags, remove_flags)
	. = ..()
	if(.)
		update_icon()

// Separate and duplicated from human logic due to humans having postures and many overlays.
/mob/living/update_transform()
	var/list/icon_scale_values = get_icon_scale_mult()
	var/desired_scale_x = icon_scale_values[1]
	var/desired_scale_y = icon_scale_values[2]
	var/matrix/M = matrix()
	M.Scale(desired_scale_x, desired_scale_y)
	M.Translate(0, 16 * (desired_scale_y - 1))
	if(transform_animate_time)
		animate(src, transform = M, time = transform_animate_time)
	else
		transform = M
	return transform

/mob/living/human/update_transform()

	// First, get the correct size.
	var/list/icon_scale_values = get_icon_scale_mult()
	var/desired_scale_x = icon_scale_values[1]
	var/desired_scale_y = icon_scale_values[2]

	// Apply KEEP_TOGETHER so all the component overlays move properly when
	// applying a transform, or remove it if we aren't doing any transforms
	// (due to cost).
	if(!current_posture.prone && desired_scale_x == 1 && desired_scale_y == 1 && !("turf_alpha_mask" in filter_data))
		update_appearance_flags(remove_flags = KEEP_TOGETHER)
	else
		update_appearance_flags(add_flags = KEEP_TOGETHER)

	// Scale/translate/rotate and apply the transform.
	var/turn_angle
	var/matrix/M = matrix()
	M.Scale(desired_scale_x, desired_scale_y)
	if(current_posture.prone && get_bodytype()?.rotate_on_prone)
		// This locate is very bad but trying to get it to respect the buckled dir is proving tricky.
		if((dir & EAST) || (isturf(loc) && (locate(/obj/structure/bed) in loc)))
			turn_angle = 90
		else if(dir & WEST)
			turn_angle = -90
		else
			turn_angle = pick(-90, 90)
		M.Turn(turn_angle)
		M.Translate(turn_angle == 90 ? 1 : -2, (turn_angle == 90 ? -6 : -5) - default_pixel_z)
	else
		M.Translate(0, 16 * (desired_scale_y - 1))

	if(transform_animate_time)
		animate(src, transform = M, time = transform_animate_time)
	else
		transform = M

	var/atom/movable/mask = global._alpha_masks[src]
	if(mask)
		var/matrix/inverted_transform = matrix()
		inverted_transform.Scale(desired_scale_y, desired_scale_x)
		if(current_posture.prone)
			inverted_transform.Turn(-turn_angle)
			inverted_transform.Translate(turn_angle == -90 ? 1 : -2, (turn_angle == -90 ? -6 : -5) - default_pixel_z)
		else
			inverted_transform.Translate(0, 16 * (desired_scale_y - 1))
		if(transform_animate_time)
			animate(mask, transform = inverted_transform, time = transform_animate_time)
		else
			mask.transform = inverted_transform

	return transform

/mob/living/human/update_damage_overlays(update_icons = TRUE)
	. = ..()
	update_bandages(update_icons)

/mob/living/human/proc/update_bandages(var/update_icons=1)
	var/list/bandage_overlays
	var/bandage_icon = get_bodytype().get_bandages_icon(src)
	if(bandage_icon)
		for(var/obj/item/organ/external/O in get_external_organs())
			var/bandage_level = O.bandage_level()
			if(bandage_level)
				LAZYADD(bandage_overlays, image(bandage_icon, "[O.icon_state][bandage_level]"))
	set_current_mob_overlay(HO_DAMAGE_LAYER, bandage_overlays, update_icons)

/mob/living/human/proc/get_human_icon_cache_key()
	. = list()
	for(var/limb_tag in global.all_limb_tags)
		. += "[limb_tag]_"
		var/obj/item/organ/external/part = GET_EXTERNAL_ORGAN(src, limb_tag)
		if(isnull(part) || part.skip_body_icon_draw)
			. += "skip"
			continue
		part.update_icon() // This wil regenerate their icon if needed, and more importantly set their cache key.
		. += part._icon_cache_key
	. += "husked_[!!has_genetic_condition(GENE_COND_HUSK)]"
	. = JOINTEXT(.)

//BASE MOB SPRITE
/mob/living/human/update_body(var/update_icons = TRUE)

	var/list/limbs = get_external_organs()
	if(!LAZYLEN(limbs))
		return // Something is trying to update our body pre-init (probably loading a preview image during world startup).

	var/decl/bodytype/root_bodytype = get_bodytype()
	var/icon_key = get_human_icon_cache_key()

	stand_icon = global.human_icon_cache[icon_key]
	if(!stand_icon)
		//BEGIN CACHED ICON GENERATION.
		stand_icon = new(root_bodytype.icon_template || 'icons/mob/human.dmi', "blank")
		for(var/obj/item/organ/external/part in limbs)
			if(isnull(part) || part.skip_body_icon_draw)
				continue
			var/icon/temp = part.icon
			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position & (LEFT | RIGHT))
				var/icon/temp2 = icon(root_bodytype.icon_template)
				temp2.Insert(new /icon(temp,dir=NORTH),dir=NORTH)
				temp2.Insert(new /icon(temp,dir=SOUTH),dir=SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new /icon(temp,dir=EAST),dir=EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new /icon(temp,dir=WEST),dir=WEST)
				stand_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new /icon(temp,dir=EAST),dir=EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new /icon(temp,dir=WEST),dir=WEST)
				stand_icon.Blend(temp2, ICON_UNDERLAY)
			else if(part.icon_position & UNDER)
				stand_icon.Blend(temp, ICON_UNDERLAY)
			else
				stand_icon.Blend(temp, ICON_OVERLAY)
		//Handle husk overlay.
		if(has_genetic_condition(GENE_COND_HUSK))
			var/husk_icon = root_bodytype.get_husk_icon(src)
			if(husk_icon)
				var/icon/mask = new(stand_icon)
				var/icon/husk_over = new(husk_icon, "")
				mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
				husk_over.Blend(mask, ICON_ADD)
				stand_icon.Blend(husk_over, ICON_OVERLAY)
			else
				stand_icon.ColorTone("#605850")
		global.human_icon_cache[icon_key] = stand_icon

	//tail
	update_tail_showing(0)
	..()

//UNDERWEAR OVERLAY

/mob/living/human/proc/update_underwear(var/update_icons=1)
	var/list/undies = list()
	for(var/entry in worn_underwear)

		var/obj/item/underwear/UW = entry
		if (!UW?.icon) // Avoid runtimes for nude underwear types
			continue

		var/decl/bodytype/root_bodytype = get_bodytype()
		if(!root_bodytype)
			continue // Avoid runtimes for dummy mobs with no bodytype set

		var/image/I
		if(UW.slot_offset_str && LAZYACCESS(root_bodytype.equip_adjust, UW.slot_offset_str))
			I = root_bodytype.get_offset_overlay_image(src, UW.icon, UW.icon_state, UW.color, UW.slot_offset_str)
		else
			I = image(icon = UW.icon, icon_state = UW.icon_state)
			I.color = UW.color
		if(I) // get_offset_overlay_image() may potentially return null
			I.appearance_flags |= RESET_COLOR
			undies += I
	set_current_mob_overlay(HO_UNDERWEAR_LAYER, undies, update_icons)

/mob/living/human/update_hair(var/update_icons=1)
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD, /obj/item/organ/external/head)
	var/list/new_accessories = head_organ?.get_mob_overlays()
	set_current_mob_overlay(HO_HAIR_LAYER, new_accessories, update_icons)

/mob/living/human/proc/update_skin(var/update_icons=1)
	// todo: make this use bodytype
	set_current_mob_overlay(HO_SKIN_LAYER, species.update_skin(src), update_icons)

/mob/living/human/update_genetic_conditions(var/update_icons=1)
	var/list/condition_overlays = null
	for(var/decl/genetic_condition/condition as anything in get_genetic_conditions())
		var/condition_overlay = condition.get_mob_overlay()
		if(condition_overlay)
			LAZYADD(condition_overlays, condition_overlay)
	set_current_mob_overlay(HO_CONDITION_LAYER, condition_overlays, update_icons)

/mob/living/human/hud_reset(full_reset = FALSE)
	if((. = ..()) && internals && internal)
		internals.icon_state = "internal1"
