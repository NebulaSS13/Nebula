/obj/screen/health
	name = "health"
	icon_state = "health0"
	screen_loc = ui_health

/obj/screen/health/handle_click(mob/user, params)
	if(ishuman(user))
		var/mob/living/human/human_user = user
		human_user.check_self_injuries()
	return TRUE

/obj/screen/health/on_update_icon()
	. = ..()
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner) || owner.stat == DEAD)
		icon_state = "health7"
	else
		icon_state = "health[round(((100-owner.get_health_percent())/100) * 6, 1)]"

/obj/screen/health/organs/on_update_icon()

	var/mob/living/human/owner = owner_ref?.resolve()
	if(!istype(owner))
		return

	cut_overlays()

	// We don't check can_feel_pain() here, otherwise FBP don't get variable health indicators.
	if(owner.has_chemical_effect(CE_PAINKILLER, 100))
		icon_state = "health_numb"
		compile_overlays()
		return

	icon_state = "blank"

	// Generate a by-limb health display.
	var/no_damage = 1
	var/trauma_val = 0 // Used in calculating softcrit/hardcrit indicators.

	var/decl/species/my_species = owner.get_species()
	trauma_val = max(owner.shock_stage, owner.get_shock())/ (my_species.total_health-100)

	for(var/obj/item/organ/external/E in owner.get_external_organs())
		if(no_damage && (E.brute_dam || E.burn_dam))
			no_damage = 0
		var/damage_image = E.get_damage_hud_image()
		if(damage_image)
			add_overlay(damage_image)

	// Apply a fire overlay if we're burning.
	var/crit_markers = get_ui_icon(owner.client?.prefs?.UI_style, HUD_CRIT_MARKER)
	if(crit_markers)
		if(owner.is_on_fire())
			add_overlay(image(crit_markers, "burning"))
		// Show a general pain/crit indicator if needed.
		if(owner.is_asystole())
			add_overlay(image(crit_markers, "hardcrit"))
		else if(trauma_val)
			if(trauma_val > 0.7)
				add_overlay(image(crit_markers, "softcrit"))
			if(trauma_val >= 1)
				add_overlay(image(crit_markers, "hardcrit"))
		else if(no_damage)
			add_overlay(image(crit_markers, "fullhealth"))

	compile_overlays()
