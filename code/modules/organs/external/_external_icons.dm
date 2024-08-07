var/global/list/limb_icon_cache = list()

/obj/item/organ/external
	var/force_limb_dir = SOUTH

/obj/item/organ/external/set_dir()
	return ..(force_limb_dir)

/obj/item/organ/external/proc/compile_icon()
	 // This is a kludge, only one icon has more than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				child.update_icon()
				child.compile_overlays()
		organ.update_icon()
		organ.compile_overlays()
	update_icon()
	compile_overlays()

/obj/item/organ/external/proc/get_surgery_overlay_icon()
	if(limb_flags & ORGAN_FLAG_SKELETAL)
		return null
	if(BP_IS_PROSTHETIC(src))
		return null
	return species?.get_surgery_overlay_icon(owner)

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/human/human)
	_icon_cache_key = null
	skin_tone = null
	skin_colour = null
	// This used to do a bodytype set but that was *really really bad.* Things that need that should do it themselves.
	skin_blend = bodytype.limb_blend
	if(!isnull(human.skin_tone) && bodytype?.appearance_flags & HAS_A_SKIN_TONE)
		skin_tone = human.skin_tone
	if(bodytype.appearance_flags & HAS_SKIN_COLOR)
		skin_colour = human.get_skin_colour()

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/human/human)
	..()
	var/obj/item/organ/internal/eyes/eyes = human.get_organ(BP_EYES, /obj/item/organ/internal/eyes)
	if(eyes) eyes.update_colour()

/obj/item/organ/external/head/on_remove_effects(mob/living/last_owner)
	update_icon(1)
	if(last_owner)
		SetName("[last_owner.real_name]'s head")
		addtimer(CALLBACK(last_owner, TYPE_PROC_REF(/mob, update_hair)), 1, TIMER_UNIQUE)
	return ..()

/obj/item/organ/external/proc/update_limb_icon_file()
	if(!bodytype) // This should not happen.
		icon = initial(icon)
	else if(limb_flags & ORGAN_FLAG_SKELETAL)
		icon = bodytype.get_skeletal_icon(owner)
	else if(!BP_IS_PROSTHETIC(src) && (status & ORGAN_MUTATED))
		icon = bodytype.get_base_icon(owner, get_deform = TRUE)
	else
		icon = bodytype.get_base_icon(owner)

var/global/list/organ_icon_cache = list()
/obj/item/organ/external/proc/generate_mob_icon()

	// Generate base icon with colour and tone.
	var/icon/ret = bodytype.apply_limb_colouration(src, new /icon(icon, icon_state))
	if(limb_flags & ORGAN_FLAG_SKELETAL)
		global.organ_icon_cache[_icon_cache_key] = ret
		return ret

	if((status & ORGAN_DEAD))
		ret.ColorTone(rgb(10,50,0))
		ret.SetIntensity(0.7)

	if(skin_tone)
		if(skin_tone >= 0)
			ret.Blend(rgb(skin_tone, skin_tone, skin_tone), ICON_ADD)
		else
			ret.Blend(rgb(-skin_tone,  -skin_tone,  -skin_tone), ICON_SUBTRACT)

	if((bodytype.appearance_flags & HAS_SKIN_COLOR) && skin_colour)
		ret.Blend(skin_colour, skin_blend)

	// Body markings, hair, lips, etc.
	for(var/accessory_category in _sprite_accessories)
		var/list/draw_accessories = _sprite_accessories[accessory_category]
		for(var/accessory in draw_accessories)
			var/decl/sprite_accessory/accessory_decl = resolve_accessory_to_decl(accessory)
			if(!istype(accessory_decl))
				continue
			if(!isnull(accessory_decl.sprite_overlay_layer) || !accessory_decl.draw_accessory)
				continue
			ret.Blend(accessory_decl.get_cached_accessory_icon(src, draw_accessories[accessory]), accessory_decl.layer_blend)
	if(render_alpha < 255)
		ret += rgb(,,,render_alpha)
	global.organ_icon_cache[_icon_cache_key] = ret
	return ret

/obj/item/organ/external/proc/get_mob_overlays()
	for(var/accessory_category in _sprite_accessories)
		var/list/draw_accessories = _sprite_accessories[accessory_category]
		for(var/accessory in draw_accessories)
			var/decl/sprite_accessory/accessory_decl = resolve_accessory_to_decl(accessory)
			if(!istype(accessory_decl))
				continue
			if(isnull(accessory_decl.sprite_overlay_layer) || !accessory_decl.draw_accessory)
				continue
			var/image/accessory_image = image(accessory_decl.get_cached_accessory_icon(src, draw_accessories[accessory]))
			if(accessory_decl.sprite_overlay_layer != FLOAT_LAYER)
				accessory_image.layer = accessory_decl.sprite_overlay_layer
			if(accessory_decl.layer_blend != ICON_OVERLAY)
				accessory_image.blend_mode = iconMode2blendMode(accessory_decl.layer_blend)
			LAZYADD(., accessory_image)

/obj/item/organ/external/proc/get_icon_cache_key_components()

	. = list("[icon_state]_[species.name]_[bodytype?.name || "BAD_BODYTYPE"]_[render_alpha]_[icon]")

	// Skeletons don't care about most icon appearance stuff.
	if(limb_flags & ORGAN_FLAG_SKELETAL)
		. += "_skeletal_[skin_blend]"
		return

	if(status & ORGAN_DEAD)
		. += "_dead"
	. += "_tone_[skin_tone]_color_[skin_colour]_[skin_blend]"
	for(var/accessory_category in _sprite_accessories)
		var/list/draw_accessories = _sprite_accessories[accessory_category]
		for(var/accessory in draw_accessories)
			var/decl/sprite_accessory/accessory_decl = resolve_accessory_to_decl(accessory)
			if(istype(accessory_decl) && !accessory_decl.sprite_overlay_layer)
				. += "_[accessory]_[json_encode(draw_accessories[accessory])]"

/obj/item/organ/external/proc/clear_sprite_accessories(var/skip_update = FALSE)
	if(!length(_sprite_accessories))
		return
	LAZYCLEARLIST(_sprite_accessories)
	if(!skip_update)
		if(owner)
			owner.update_body()
		update_icon()

/obj/item/organ/external/proc/clear_sprite_accessories_by_category(var/accessory_category, var/skip_update = FALSE)
	var/list/category_accessories = get_sprite_accessories_by_category(accessory_category)
	category_accessories?.Cut()
	_sprite_accessories?[accessory_category] = null
	if(skip_update)
		return
	owner?.update_body(update_icons = TRUE)

/obj/item/organ/external/proc/get_sprite_accessories_by_category(var/accessory_category)
	return LAZYACCESS(_sprite_accessories, accessory_category)

/obj/item/organ/external/proc/get_sprite_accessory_categories()
	. = list()
	for(var/category_type in _sprite_accessories)
		. += GET_DECL(category_type)

/obj/item/organ/external/proc/get_sprite_accessory_by_category(var/accessory_category)
	var/list/accessories = get_sprite_accessories_by_category(accessory_category)
	if(length(accessories))
		return accessories[1]

/obj/item/organ/external/proc/get_sprite_accessory_metadata(var/accessory_type, var/metadata_tag)
	var/decl/sprite_accessory/accessory = GET_DECL(accessory_type)
	var/list/accessories = istype(accessory) && LAZYACCESS(_sprite_accessories, accessory.accessory_category)
	if(accessories)
		var/list/metadata = accessories[accessory_type] || accessory.get_default_accessory_metadata()
		if(islist(metadata) && metadata_tag)
			metadata = metadata[metadata_tag]
		return islist(metadata) ? metadata.Copy() : metadata

/obj/item/organ/external/proc/set_sprite_accessory(var/accessory_type, var/accessory_category, var/accessory_metadata, var/skip_update = FALSE)

	var/decl/sprite_accessory/accessory_decl = GET_DECL(accessory_type)
	if(!accessory_category)
		if(!accessory_decl)
			return FALSE
		accessory_category = accessory_decl.accessory_category

	var/decl/sprite_accessory_category/accessory_cat_decl = GET_DECL(accessory_category)

	var/list/accessories = LAZYACCESS(_sprite_accessories, accessory_category)
	if(!accessories)
		accessories = list()
		LAZYSET(_sprite_accessories, accessory_category, accessories)

	if(!accessory_type)
		var/decl/sprite_accessory_category/accessory_cat = GET_DECL(accessory_category)
		accessory_type = accessory_cat?.default_accessory
		if(!accessory_type)
			return FALSE
		accessory_decl = GET_DECL(accessory_type)

	var/list/refresh_accessories
	if(accessory_metadata)
		if(!accessory_decl.accessory_is_available(owner, species, bodytype))
			return FALSE
		var/list/existing_metadata = LAZYACCESS(accessories, accessory_type)
		if(same_entries(existing_metadata, accessory_metadata))
			return FALSE
		if(accessory_cat_decl.single_selection)
			LAZYDISTINCTADD(refresh_accessories, accessories)
			accessories.Cut()
		LAZYSET(accessories, accessory_type, accessory_decl.update_metadata(accessory_metadata, existing_metadata))
		LAZYDISTINCTADD(refresh_accessories, accessory_decl)
	else
		if(!(accessory_type in accessories))
			return FALSE
		remove_sprite_accessory(accessory_type, TRUE)

	if(!skip_update)
		if(owner && length(refresh_accessories))
			for(var/refresh_accessory_type in refresh_accessories)
				var/decl/sprite_accessory/refresh_accessory = GET_DECL(refresh_accessory_type)
				if(refresh_accessory)
					refresh_accessory.refresh_mob(owner)
		update_icon()
	return TRUE

/obj/item/organ/external/proc/get_heritable_sprite_accessories()
	for(var/accessory_category in _sprite_accessories)
		var/list/draw_accessories = _sprite_accessories[accessory_category]
		for(var/accessory in draw_accessories)
			var/decl/sprite_accessory/accessory_decl = GET_DECL(accessory)
			if(accessory_decl?.is_heritable)
				LAZYSET(., accessory, draw_accessories[accessory])

/obj/item/organ/external/proc/set_sprite_accessory_by_category(accessory_type, accessory_category, accessory_metadata, preserve_colour = TRUE, preserve_type = TRUE, skip_update)
	if(!accessory_category)
		return FALSE
	if(istype(accessory_type, /decl/sprite_accessory))
		var/decl/accessory_decl = accessory_type
		accessory_type = accessory_decl.type

	// If there is a pre-existing sprite accessory to replace, we may want to keep the old colour value.
	var/replacing_type = get_sprite_accessory_by_category(accessory_category)
	if(replacing_type)

		if(preserve_colour && !accessory_metadata)
			accessory_metadata = get_sprite_accessory_metadata(replacing_type)

		// We may only be setting colour, in which case we don't bother with a removal.
		if(preserve_type && !accessory_type)
			accessory_type = replacing_type
		else if (accessory_type != replacing_type)
			remove_sprite_accessory(replacing_type, TRUE)

	// We have already done our removal above and have nothing further to set below.
	if(!accessory_metadata && !accessory_type)
		if(!skip_update)
			if(owner)
				var/decl/sprite_accessory/refresh_accessory = GET_DECL(replacing_type || accessory_category)
				if(refresh_accessory)
					refresh_accessory.refresh_mob(owner)
			update_icon()
		return TRUE

	// We need to now set a replacement accessory type down the chain.
	return set_sprite_accessory(accessory_type, accessory_category, accessory_metadata, skip_update)

/obj/item/organ/external/proc/remove_sprite_accessory(var/accessory_type, var/skip_update = FALSE)
	if(!accessory_type)
		return
	var/decl/sprite_accessory/removing_accessory = GET_DECL(accessory_type)
	var/list/removing = LAZYACCESS(_sprite_accessories, removing_accessory.accessory_category)
	if(!LAZYLEN(removing))
		return
	LAZYREMOVE(removing, accessory_type)
	if(!length(removing))
		LAZYREMOVE(_sprite_accessories, removing_accessory.accessory_category)
	if(!skip_update)
		if(owner && removing_accessory)
			removing_accessory.refresh_mob(owner)
		update_icon()

/obj/item/organ/external/on_update_icon()
	. = ..()

	if(!istext(organ_tag)) // how?? this happened on Scav in relation to runtimes in update_limb_icon_file() so might be unneeded with that fixed
		return

	// Update our cache key and refresh or create our base icon.
	var/next_state = owner ? "[organ_tag][owner.get_overlay_state_modifier()]" : organ_tag
	update_limb_icon_file()
	if(icon_state != next_state)
		icon_state = next_state

	_icon_cache_key = jointext(get_icon_cache_key_components(), null)
	var/icon/mob_icon = global.organ_icon_cache[_icon_cache_key] || generate_mob_icon()
	if(icon != mob_icon)
		icon = mob_icon

	// We may have some overlays of our own (hair, glowing eyes, layered markings)
	var/list/additional_overlays = get_mob_overlays()
	if(length(additional_overlays))
		for(var/new_overlay in additional_overlays)
			add_overlay(new_overlay)

	// If we've been severed, we may contain child organs that should be rendered (feet on legs etc).
	if(!owner && length(contents))
		for(var/obj/item/organ/external/child in contents)
			child.update_icon()
			child.compile_overlays() // We need the appearance immediately.
			add_overlay(child)

// Global scope, used in code below.
var/global/list/flesh_hud_colours = list("#00ff00","#aaff00","#ffff00","#ffaa00","#ff0000","#aa0000","#660000")
var/global/list/robot_hud_colours = list("#ffffff","#cccccc","#aaaaaa","#888888","#666666","#444444","#222222","#000000")

// Returns an image for use by the human health dolly HUD element.
// If the limb is in pain, it will be used as a minimum damage
// amount to represent the obfuscation of being in agonizing pain.
/obj/item/organ/external/proc/get_damage_hud_image()

	if(skip_body_icon_draw)
		return null

	// Generate the greyscale base icon and cache it for later.
	// _icon_cache_key is set by any get_icon() calls that are made.
	// This looks convoluted, but it's this way to avoid icon proc calls.
	if(!hud_damage_image)
		update_icon()
		var/cache_key = "dambase-[_icon_cache_key]"
		if(!cache_key || !limb_icon_cache[cache_key])
			limb_icon_cache[cache_key] = icon(icon, null, SOUTH)
		var/image/temp = image(limb_icon_cache[cache_key])
		if(species)
			// Calculate the required colour matrix.
			var/r = 0.30 * bodytype.health_hud_intensity
			var/g = 0.59 * bodytype.health_hud_intensity
			var/b = 0.11 * bodytype.health_hud_intensity
			temp.color = list(r, r, r, g, g, g, b, b, b)
		temp.pixel_x = owner.default_pixel_x
		temp.pixel_y = owner.default_pixel_y
		hud_damage_image = image(null)
		hud_damage_image.overlays += temp

	// Calculate the required color index.
	var/dam_state = min(1,((brute_dam+burn_dam)/max(1,max_damage)))
	var/min_dam_state = min(1,(get_pain()/max(1,max_damage)))
	if(min_dam_state && dam_state < min_dam_state)
		dam_state = min_dam_state
	// Apply colour and return product.
	var/list/hud_colours = !BP_IS_PROSTHETIC(src) ? flesh_hud_colours : robot_hud_colours
	hud_damage_image.color = hud_colours[max(1,min(ceil(dam_state*hud_colours.len),hud_colours.len))]
	return hud_damage_image

/obj/item/organ/external/proc/bandage_level()
	if(damage_state_text() == "00")
		return 0
	if(!is_bandaged())
		return 0
	if(burn_dam + brute_dam == 0)
		. = 0
	else if (burn_dam + brute_dam < (max_damage * 0.25 / 2))
		. = 1
	else if (burn_dam + brute_dam < (max_damage * 0.75 / 2))
		. = 2
	else
		. = 3

/obj/item/organ/external/proc/resolve_accessory_to_decl(var/decl/sprite_accessory/accessory_style)
	if(ispath(accessory_style))
		accessory_style = GET_DECL(accessory_style)
	// Check if this style is permitted for this species, period.
	if(!istype(accessory_style) || !accessory_style?.accessory_is_available(owner, species, bodytype))
		return null
	// Check if we are concealed (long hair under a hat for example).
	if(accessory_style.is_hidden(src))
		return accessory_style.get_hidden_substitute()
	return accessory_style

/obj/item/organ/external/proc/sanitize_sprite_accessories(var/skip_update = FALSE)
	for(var/acc_cat in _sprite_accessories)
		for(var/accessory in _sprite_accessories[acc_cat])
			var/decl/sprite_accessory/accessory_style = GET_DECL(accessory)
			if(!istype(accessory_style) || !accessory_style?.accessory_is_available(owner, species, bodytype))
				_sprite_accessories[acc_cat] -= accessory
				. = TRUE
	if(.)
		_icon_cache_key = null
		if(!skip_update)
			update_icon()
