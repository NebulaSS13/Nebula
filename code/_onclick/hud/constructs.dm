/mob/living/simple_animal/construct
	hud_used = /datum/hud/construct/wraith

/mob/living/simple_animal/construct/armoured
	hud_used = /datum/hud/construct/juggernaut

/mob/living/simple_animal/construct/behemoth
	hud_used = /datum/hud/construct/juggernaut

/mob/living/simple_animal/construct/builder
	hud_used = /datum/hud/construct/artificer

/mob/living/simple_animal/construct/harvester
	hud_used = /datum/hud/construct/harvester

/decl/hud_element/condition/fire/construct
	screen_loc = ui_construct_fire

/decl/hud_element/health/construct
	screen_loc = ui_construct_health
	abstract_type = /decl/hud_element/health/construct

/decl/hud_element/health/construct/artificer
	screen_icon = 'icons/mob/screen/health_construct_artificer.dmi'

/decl/hud_element/health/construct/wraith
	screen_icon = 'icons/mob/screen/health_construct_wraith.dmi'

/decl/hud_element/health/construct/juggernaut
	screen_icon = 'icons/mob/screen/health_construct_juggernaut.dmi'

/decl/hud_element/health/construct/harvester
	screen_icon = 'icons/mob/screen/health_construct_harvester.dmi'

/datum/hud/construct/get_ui_style()
	return 'icons/mob/screen/construct.dmi'

/datum/hud/construct/artificer
	health_hud_type = /decl/hud_element/health/construct/artificer
	hud_elements = list(
		/decl/hud_element/health/construct/artificer,
		/decl/hud_element/zone_selector,
		/decl/hud_element/action_intent,
		/decl/hud_element/condition/fire/construct
	)

/datum/hud/construct/wraith
	health_hud_type = /decl/hud_element/health/construct/wraith
	hud_elements = list(
		/decl/hud_element/health/construct/wraith,
		/decl/hud_element/zone_selector,
		/decl/hud_element/action_intent,
		/decl/hud_element/condition/fire/construct
	)

/datum/hud/construct/juggernaut
	health_hud_type = /decl/hud_element/health/construct/juggernaut
	hud_elements = list(
		/decl/hud_element/health/construct/juggernaut,
		/decl/hud_element/zone_selector,
		/decl/hud_element/action_intent,
		/decl/hud_element/condition/fire/construct
	)

/datum/hud/construct/harvester
	health_hud_type = /decl/hud_element/health/construct/harvester
	hud_elements = list(
		/decl/hud_element/health/construct/harvester,
		/decl/hud_element/zone_selector,
		/decl/hud_element/action_intent,
		/decl/hud_element/condition/fire/construct
	)
