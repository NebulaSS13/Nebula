/mob/living/simple_animal/construct
	hud_type = /datum/hud/construct

/mob/living/simple_animal/construct
	var/hud_construct_type

/mob/living/simple_animal/construct/armoured
	hud_construct_type = "juggernaut"

/mob/living/simple_animal/construct/behemoth
	hud_construct_type = "juggernaut"

/mob/living/simple_animal/construct/builder
	hud_construct_type = "artificer"

/mob/living/simple_animal/construct/wraith
	hud_construct_type = "wraith"

/mob/living/simple_animal/construct/harvester
	hud_construct_type = "harvester"

/datum/hud/construct/FinalizeInstantiation()
	var/constructtype
	if(isconstruct(mymob))
		var/mob/living/simple_animal/construct/construct = mymob
		constructtype = construct.hud_construct_type
	if(constructtype)
		mymob.fire = new /obj/screen()
		mymob.fire.icon = 'icons/mob/screen1_construct.dmi'
		mymob.fire.icon_state = "fire0"
		mymob.fire.SetName("fire")
		mymob.fire.screen_loc = ui_construct_fire
		mymob.healths = new /obj/screen()
		mymob.healths.icon = 'icons/mob/screen1_construct.dmi'
		mymob.healths.icon_state = "[constructtype]_health0"
		mymob.healths.SetName("health")
		mymob.healths.screen_loc = ui_construct_health
		mymob.zone_sel = new
		mymob.zone_sel.icon = 'icons/mob/screen1_construct.dmi'
		mymob.zone_sel.update_icon()
	adding += list(mymob.fire, mymob.healths, mymob.zone_sel)
	..()
