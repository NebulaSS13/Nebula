/datum/hud/construct/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct)

/datum/hud/construct/juggernaut/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct/juggernaut)

/datum/hud/construct/harvester/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct/harvester)

/datum/hud/construct/wraith/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct/wraith)

/datum/hud/construct/artificer/get_ui_style_data()
	return GET_DECL(/decl/ui_style/construct/artificer)

/datum/hud/construct/get_ui_color()
	return COLOR_WHITE

/datum/hud/construct/get_ui_alpha()
	return 255

/datum/hud/construct/FinalizeInstantiation()
	var/decl/ui_style/ui_style = get_ui_style_data()
	var/ui_color = get_ui_color()
	var/ui_alpha = get_ui_alpha()
	mymob.fire = new /obj/screen/construct_fire(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_STATUS_FIRE)
	mymob.healths = new /obj/screen/construct_health(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_HEALTH)
	mymob.zone_sel = new(null, mymob, ui_style, ui_color, ui_alpha, UI_ICON_ZONE_SELECT)
	adding += list(mymob.fire, mymob.healths, mymob.zone_sel)
	..()

/decl/ui_style/construct
	name = "Construct"
	restricted = TRUE
	override_icons = list(
		UI_ICON_STATUS_FIRE = 'icons/mob/screen/styles/constructs/status_fire.dmi',
		UI_ICON_ZONE_SELECT = 'icons/mob/screen/styles/constructs/zone_selector.dmi'
	)
	uid = "ui_style_construct"
/decl/ui_style/construct/juggernaut
	name = "Juggernaut"
	uid = "ui_style_construct_juggernaut"
/decl/ui_style/construct/juggernaut/Initialize()
	override_icons[UI_ICON_HEALTH] = 'icons/mob/screen/styles/constructs/juggernaut/health.dmi'
	return ..()
/decl/ui_style/construct/harvester
	name = "Harvester"
	uid = "ui_style_construct_harvester"
/decl/ui_style/construct/harvester/Initialize()
	override_icons[UI_ICON_HEALTH] = 'icons/mob/screen/styles/constructs/harvester/health.dmi'
	return ..()
/decl/ui_style/construct/wraith
	name = "Wraith"
	uid = "ui_style_construct_wraith"
/decl/ui_style/construct/wraith/Initialize()
	override_icons[UI_ICON_HEALTH] = 'icons/mob/screen/styles/constructs/wraith/health.dmi'
	return ..()
/decl/ui_style/construct/artificer
	name = "Artificer"
	uid = "ui_style_construct_artificer"
/decl/ui_style/construct/artificer/Initialize()
	override_icons[UI_ICON_HEALTH] = 'icons/mob/screen/styles/constructs/artificer/health.dmi'
	return ..()
