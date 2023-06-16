/decl/hud_element/health
	screen_name = "health"
	screen_icon = 'icons/mob/screen/health_human.dmi'
	screen_icon_state = "health0"
	apply_hud_icon =  FALSE
	apply_hud_alpha = FALSE
	apply_hud_color = FALSE
	var/health_states = 6
	var/death_state = 7
	var/numb_state = "_numb"

/decl/hud_element/health/refresh_screen_object(datum/hud/hud, obj/screen/elem, datum/gas_mixture/environment)
	if(!isliving(hud?.mymob))
		return
	var/mob/living/user = hud.mymob
	reset_health_overlays(user, elem)
	if(user.stat == DEAD)
		elem.icon_state = "health[death_state]"
	else if(user.has_chemical_effect(CE_PAINKILLER, 100))
		elem.icon_state = "health[numb_state]"
	else
		update_health_overlays(user, elem)

/decl/hud_element/health/proc/reset_health_overlays(mob/living/user, obj/screen/elem)
	return

/decl/hud_element/health/proc/update_health_overlays(mob/living/user, obj/screen/elem)
	elem.icon_state = "health[health_states - round(user.get_health_ratio() * health_states)]"

/decl/hud_element/health/human
	screen_icon_state = "blank"
	var/health_icon = 'icons/mob/screen/health_human.dmi'
	var/burning_image
	var/softcrit_image
	var/hardcrit_image
	var/fullhealth_image

/decl/hud_element/health/human/Initialize()
	. = ..()
	burning_image    = image(health_icon, "burning")
	softcrit_image   = image(health_icon, "softcrit")
	hardcrit_image   = image(health_icon, "hardcrit")
	fullhealth_image = image(health_icon, "fullhealth")

/decl/hud_element/health/human/reset_health_overlays(mob/living/user, obj/screen/elem)
	elem.cut_overlays()
	elem.icon_state = "blank"

/decl/hud_element/health/human/update_health_overlays(mob/living/user, obj/screen/elem)

	// Generate a by-limb health display.
	// Pain modifies the effective pain level used to colour the limb.
	var/no_damage = 1
	var/trauma_val = 0 // Used in calculating softcrit/hardcrit indicators.
	if(user.can_feel_pain() && ishuman(user))
		var/mob/living/carbon/human/human = user
		trauma_val = max(human.shock_stage, human.get_shock()) / (user.get_max_health()-100) // TODO: where is this 100 coming from?

	for(var/obj/item/organ/external/E in user.get_external_organs())
		if(no_damage && (E.brute_dam || E.burn_dam))
			no_damage = 0
		var/organ_image = E.get_damage_hud_image()
		if(organ_image)
			elem.add_overlay(organ_image)

	// Apply a fire overlay if we're burning.
	if(user.on_fire)
		elem.add_overlay(burning_image)

	// Show a general pain/crit indicator if needed.
	if(user.is_asystole())
		elem.add_overlay(hardcrit_image)
	else if(trauma_val)
		if(user.can_feel_pain())
			if(trauma_val > 0.7)
				elem.add_overlay(softcrit_image)
			if(trauma_val >= 1)
				elem.add_overlay(hardcrit_image)
	else if(no_damage)
		elem.add_overlay(fullhealth_image)
	elem.compile_overlays()
