var/global/list/limb_icon_cache = list()

/obj/item/organ/external/set_dir()
	return ..(SOUTH)

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

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/carbon/human/human)
	_icon_cache_key = null
	skin_tone = null
	skin_colour = null
	hair_colour = human.get_hair_colour()
	// This used to do a bodytype set but that was *really really bad.* Things that need that should do it themselves.
	skin_blend = bodytype.limb_blend
	if(!isnull(human.skin_tone) && bodytype?.appearance_flags & HAS_A_SKIN_TONE)
		skin_tone = human.skin_tone
	if(bodytype.appearance_flags & HAS_SKIN_COLOR)
		skin_colour = human.get_skin_colour()

/obj/item/organ/external/proc/sync_colour_to_dna()
	_icon_cache_key = null
	skin_tone = null
	skin_colour = null
	hair_colour = rgb(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (bodytype.appearance_flags & HAS_A_SKIN_TONE))
		skin_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if(bodytype.appearance_flags & HAS_SKIN_COLOR)
		skin_colour = rgb(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
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
	if(!BP_IS_PROSTHETIC(src) && (status & ORGAN_MUTATED))
		icon = bodytype.get_base_icon(owner, get_deform = TRUE)
	else if(owner && (limb_flags & ORGAN_FLAG_SKELETAL))
		icon = bodytype.get_skeletal_icon(owner)
	else
		icon = bodytype.get_base_icon(owner)

var/global/list/organ_icon_cache = list()
/obj/item/organ/external/proc/generate_mob_icon()

	// Generate base icon with colour and tone.
	var/icon/ret = bodytype.apply_limb_colouration(src, new /icon(icon, icon_state))
	if(status & ORGAN_DEAD)
		ret.ColorTone(rgb(10,50,0))
		ret.SetIntensity(0.7)
	if(skin_tone)
		if(skin_tone >= 0)
			ret.Blend(rgb(skin_tone, skin_tone, skin_tone), ICON_ADD)
		else
			ret.Blend(rgb(-skin_tone,  -skin_tone,  -skin_tone), ICON_SUBTRACT)
	if((bodytype.appearance_flags & HAS_SKIN_COLOR) && skin_colour)
		ret.Blend(skin_colour, skin_blend)

	//Body markings.
	for(var/M in markings)
		var/decl/sprite_accessory/marking/mark_style = resolve_accessory_to_decl(M)
		if(mark_style && !mark_style.sprite_overlay_layer)
			ret.Blend(mark_style.get_cached_accessory_icon(src, markings[M]), mark_style.layer_blend)
	if(render_alpha < 255)
		ret += rgb(,,,render_alpha)
	global.organ_icon_cache[_icon_cache_key] = ret
	return ret

/obj/item/organ/external/proc/get_mob_overlays()
	for(var/M in markings)
		var/decl/sprite_accessory/marking/mark_style = resolve_accessory_to_decl(M)
		if(mark_style?.sprite_overlay_layer)
			var/image/mark_image = image(mark_style.get_cached_accessory_icon(src, markings[M]))
			mark_image.layer = mark_style.sprite_overlay_layer
			LAZYADD(., mark_image)

/obj/item/organ/external/proc/get_icon_cache_key_components()
	. = list("[icon_state]_[species.name]_[bodytype.name]_[render_alpha]_[icon]")
	for(var/M in markings)
		var/decl/sprite_accessory/marking/mark_style = GET_DECL(M)
		if(!mark_style.sprite_overlay_layer)
			. += "_[M][markings[M]]"
	if(status & ORGAN_DEAD)
		. += "_dead"
	. += "_tone_[skin_tone]_color_[skin_colour]_[skin_blend]"

/obj/item/organ/external/on_update_icon()
	. = ..()

	// Update our cache key and refresh or create our base icon.
	update_limb_icon_file()
	if(icon_state != organ_tag)
		icon_state = organ_tag
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

	// Generate the greyscale base icon and cache it for later.
	// icon_cache_key is set by any get_icon() calls that are made.
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
	hud_damage_image.color = hud_colours[max(1,min(CEILING(dam_state*hud_colours.len),hud_colours.len))]
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
	if(!accessory_style.accessory_is_available(owner, species, bodytype))
		return null
	// Check if we are concealed (long hair under a hat for example).
	if(accessory_style.is_hidden(src))
		return accessory_style.get_hidden_substitute()
	return accessory_style
