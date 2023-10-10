/mob/living/simple_animal/construct
	hud_type = /datum/hud/construct

/datum/hud/construct/FinalizeInstantiation()
	var/constructtype

	if(istype(mymob,/mob/living/simple_animal/construct/armoured) || istype(mymob,/mob/living/simple_animal/construct/behemoth))
		constructtype = "juggernaut"
	else if(istype(mymob,/mob/living/simple_animal/construct/builder))
		constructtype = "artificer"
	else if(istype(mymob,/mob/living/simple_animal/construct/wraith))
		constructtype = "wraith"
	else if(istype(mymob,/mob/living/simple_animal/construct/harvester))
		constructtype = "harvester"

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

	mymob.client.screen = list()
	mymob.client.screen += list(mymob.fire, mymob.healths, mymob.zone_sel)
