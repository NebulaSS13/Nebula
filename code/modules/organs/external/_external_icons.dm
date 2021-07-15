var/global/list/limb_icon_cache = list()

/obj/item/organ/external
	var/tmp/icon_cache_key

/obj/item/organ/external/set_dir(var/direction, var/forced)
	SHOULD_CALL_PARENT(FALSE)
	if(forced)
		return ..(direction)
	return FALSE

/obj/item/organ/external/proc/compile_icon()
	overlays.Cut()
	 // This is a kludge, only one icon has more than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				overlays += child.mob_icon
		overlays += organ.mob_icon

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/carbon/human/human)
	skin_tone = null
	skin_colour = null
	hair_colour = human.hair_colour
	bodytype = human.bodytype
	if(BP_IS_PROSTHETIC(src) && model)
		var/decl/prosthetics_manufacturer/franchise = GET_DECL(model)
		if(!(franchise && franchise.skintone))
			return
		skin_blend = franchise.limb_blend
	if(species && human.species && species.name != human.species.name)
		return
	if(!isnull(human.skin_tone) && (human.species.appearance_flags & HAS_A_SKIN_TONE))
		skin_tone = human.skin_tone
	if(human.species.appearance_flags & HAS_SKIN_COLOR)
		skin_colour = human.skin_colour

/obj/item/organ/external/proc/sync_colour_to_dna()
	skin_tone = null
	skin_colour = null
	hair_colour = rgb(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))
	if(BP_IS_PROSTHETIC(src) && model)
		var/decl/prosthetics_manufacturer/franchise = GET_DECL(model)
		if(!(franchise && franchise.skintone))
			return
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (species.appearance_flags & HAS_A_SKIN_TONE))
		skin_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if(species.appearance_flags & HAS_SKIN_COLOR)
		skin_colour = rgb(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	var/obj/item/organ/internal/eyes/eyes = owner.get_internal_organ(BP_EYES)
	if(eyes) eyes.update_colour()

/obj/item/organ/external/head/removed()
	update_icon(1)
	if(owner)
		SetName("[owner.real_name]'s head")
		addtimer(CALLBACK(owner, /mob/living/carbon/human/proc/update_hair), 1, TIMER_UNIQUE)
	..()
	//Head markings, duplicated (sadly) below.
	for(var/M in markings)
		var/datum/sprite_accessory/marking/mark_style = markings[M]["datum"]
		if (mark_style.draw_target == MARKING_TARGET_SKIN)
			var/icon/mark_s = new/icon("icon" = mark_style.icon, "icon_state" = "[mark_style.icon_state]-[organ_tag]")
			mark_s.Blend(markings[M]["color"], mark_style.blend)
			overlays |= mark_s //So when it's not on your body, it has icons
			mob_icon.Blend(mark_s, mark_style.layer_blend) //So when it's on your body, it has icons
			icon_cache_key += "[M][markings[M]["color"]]"

/obj/item/organ/external/proc/update_limb_icon_file()
	if (BP_IS_PROSTHETIC(src))
		if(!model)
			icon = 'icons/mob/human_races/cyberlimbs/robotic.dmi'
		else
			var/decl/prosthetics_manufacturer/R = GET_DECL(model)
			icon = R.icon
	else if(status & ORGAN_MUTATED)
		icon = bodytype.get_base_icon(owner, get_deform = TRUE)
	else if(owner && (MUTATION_SKELETON in owner.mutations))
		icon = bodytype.get_skeletal_icon(owner)
	else
		icon = bodytype.get_base_icon(owner)

/obj/item/organ/external/on_update_icon(var/regenerate = 0)

	icon_state = "[icon_name]"
	icon_cache_key = "[icon_state]_[species ? species.name : "unknown"]"
	if(model)
		icon_cache_key += "_model_[model]"

	update_limb_icon_file()
	mob_icon = apply_colouration(new/icon(icon, icon_state))

	//Body markings, does not include head, duplicated (sadly) above.
	for(var/M in markings)
		var/datum/sprite_accessory/marking/mark_style = markings[M]["datum"]
		if (mark_style.draw_target == MARKING_TARGET_SKIN)
			var/icon/mark_s = new/icon("icon" = mark_style.icon, "icon_state" = "[mark_style.icon_state]-[organ_tag]")
			mark_s.Blend(markings[M]["color"], mark_style.blend)
			overlays |= mark_s //So when it's not on your body, it has icons
			mob_icon.Blend(mark_s, mark_style.layer_blend) //So when it's on your body, it has icons
			icon_cache_key += "[M][markings[M]["color"]]"

	set_dir(EAST, TRUE)
	icon = mob_icon

/obj/item/organ/external/proc/get_icon()
	update_icon()
	return mob_icon

// Returns an image for use by the human health dolly HUD element.
// If the limb is in pain, it will be used as a minimum damage
// amount to represent the obfuscation of being in agonizing pain.

// Global scope, used in code below.
var/global/list/flesh_hud_colours = list("#00ff00","#aaff00","#ffff00","#ffaa00","#ff0000","#aa0000","#660000")
var/global/list/robot_hud_colours = list("#ffffff","#cccccc","#aaaaaa","#888888","#666666","#444444","#222222","#000000")

/obj/item/organ/external/proc/get_damage_hud_image()

	// Generate the greyscale base icon and cache it for later.
	// icon_cache_key is set by any get_icon() calls that are made.
	// This looks convoluted, but it's this way to avoid icon proc calls.
	if(!hud_damage_image)
		var/cache_key = "dambase-[icon_cache_key]"
		if(!icon_cache_key || !limb_icon_cache[cache_key])
			limb_icon_cache[cache_key] = icon(get_icon(), null, SOUTH)
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

/obj/item/organ/external/proc/apply_colouration(var/icon/applying)

	applying = bodytype.apply_limb_colouration(src, applying)
	if(status & ORGAN_DEAD)
		icon_cache_key += "_dead"
		applying.ColorTone(rgb(10,50,0))
		applying.SetIntensity(0.7)

	if(skin_tone)
		if(skin_tone >= 0)
			applying.Blend(rgb(skin_tone, skin_tone, skin_tone), ICON_ADD)
		else
			applying.Blend(rgb(-skin_tone,  -skin_tone,  -skin_tone), ICON_SUBTRACT)
		icon_cache_key += "_tone_[skin_tone]"
	if(species.appearance_flags & HAS_SKIN_COLOR)
		if(skin_colour)
			applying.Blend(skin_colour, skin_blend)
			icon_cache_key += "_color_[skin_colour]_[skin_blend]"

	return applying

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