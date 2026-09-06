/mob/living/human
	hud_used = /datum/hud/human

/datum/hud/human
	gun_mode_toggle_type    = /obj/screen/gun/mode
	omit_hud_elements       = list(/decl/hud_element/health)
	additional_hud_elements = list(
		/decl/hud_element/health/organs,
		/decl/hud_element/attack
	)
