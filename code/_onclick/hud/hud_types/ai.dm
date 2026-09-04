/mob/living/silicon/ai
	hud_used = /datum/hud/ai

/datum/hud/ai
	omit_hud_elements = list(
		/decl/hud_element/intent,
		/decl/hud_element/health,
		/decl/hud_element/charge,
		/decl/hud_element/bodytemp,
		/decl/hud_element/oxygen,
		/decl/hud_element/toxins,
		/decl/hud_element/pressure,
		/decl/hud_element/nutrition,
		/decl/hud_element/hydration,
		/decl/hud_element/maneuver,
		/decl/hud_element/movement,
		/decl/hud_element/resist,
		/decl/hud_element/drop,
		/decl/hud_element/throw_toggle,
		/decl/hud_element/internals
	)

/datum/hud/ai/New()
	additional_hud_elements = subtypesof(/decl/hud_element/ai)
	..()
