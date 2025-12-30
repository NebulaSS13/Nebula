/datum/hud/pai
	hud_elements_to_create = list(/decl/hud_element/health/robot)

/datum/hud/pai/New()
	hud_elements_to_create += subtypesof(/decl/hud_element/pai)
	..()
