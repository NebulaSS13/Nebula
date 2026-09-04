/datum/hud/animal/construct
	omit_hud_elements = list(/decl/hud_element/health)
	additional_hud_elements = list(/decl/hud_element/health/construct)

/decl/hud_element/health/construct
	elem_reference_type = /decl/hud_element/health
	elem_type = /obj/screen/health/construct

/datum/hud/animal/construct/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct)

/datum/hud/animal/construct/juggernaut/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct/juggernaut)

/datum/hud/animal/construct/harvester/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct/harvester)

/datum/hud/animal/construct/wraith/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct/wraith)

/datum/hud/animal/construct/artificer/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct/artificer)

/datum/hud/animal/construct/get_ui_color()
	return COLOR_WHITE

/datum/hud/animal/construct/get_ui_alpha()
	return 255

/decl/ui_style/construct
	name = "Construct"
	restricted = TRUE
	override_icons = list(
		(HUD_FIRE)        = 'icons/mob/screen/styles/constructs/status_fire.dmi',
		(HUD_ZONE_SELECT) = 'icons/mob/screen/styles/constructs/zone_selector.dmi'
	)
	uid = "ui_style_construct"
/decl/ui_style/construct/juggernaut
	name = "Juggernaut"
	uid = "ui_style_construct_juggernaut"
/decl/ui_style/construct/juggernaut/Initialize()
	override_icons[HUD_HEALTH] = 'icons/mob/screen/styles/constructs/juggernaut/health.dmi'
	return ..()
/decl/ui_style/construct/harvester
	name = "Harvester"
	uid = "ui_style_construct_harvester"
/decl/ui_style/construct/harvester/Initialize()
	override_icons[HUD_HEALTH] = 'icons/mob/screen/styles/constructs/harvester/health.dmi'
	return ..()
/decl/ui_style/construct/wraith
	name = "Wraith"
	uid = "ui_style_construct_wraith"
/decl/ui_style/construct/wraith/Initialize()
	override_icons[HUD_HEALTH] = 'icons/mob/screen/styles/constructs/wraith/health.dmi'
	return ..()
/decl/ui_style/construct/artificer
	name = "Artificer"
	uid = "ui_style_construct_artificer"
/decl/ui_style/construct/artificer/Initialize()
	override_icons[HUD_HEALTH] = 'icons/mob/screen/styles/constructs/artificer/health.dmi'
	return ..()
