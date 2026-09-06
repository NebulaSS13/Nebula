/mob/living
	var/list/hud_list = new(10)

/mob/living/proc/reset_hud_overlays()
	hud_list = new(10)
	hud_list[HEALTH_HUD]      = new /image/hud_overlay(global.using_map.med_hud_icons,     src, "blank")
	hud_list[STATUS_HUD]      = new /image/hud_overlay(global.using_map.hud_icons,         src, "hudhealthy")
	hud_list[LIFE_HUD]	      = new /image/hud_overlay(global.using_map.hud_icons,         src, "hudhealthy")
	hud_list[ID_HUD]          = new /image/hud_overlay(global.using_map.hud_icons,         src, "hudunknown")
	hud_list[WANTED_HUD]      = new /image/hud_overlay(global.using_map.hud_icons,         src, "hudblank")
	hud_list[IMPLOYAL_HUD]    = new /image/hud_overlay(global.using_map.implant_hud_icons, src, "hud_imp_blank")
	hud_list[IMPCHEM_HUD]     = new /image/hud_overlay(global.using_map.implant_hud_icons, src, "hud_imp_blank")
	hud_list[IMPTRACK_HUD]    = new /image/hud_overlay(global.using_map.implant_hud_icons, src, "hud_imp_blank")
	hud_list[SPECIALROLE_HUD] = new /image/hud_overlay(global.using_map.hud_icons,         src, "hudblank")
	hud_list[STATUS_HUD_OOC]  = new /image/hud_overlay(global.using_map.hud_icons,         src, "hudhealthy")

/datum/map
