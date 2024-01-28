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
		mymob.fire = new /obj/screen/construct_fire(null, mymob)
		mymob.healths = new /obj/screen/construct_health(null, mymob)
		mymob.healths.icon_state = "[constructtype]_health0"
		mymob.zone_sel = new(null, mymob, 'icons/mob/screen1_construct.dmi')

	adding += list(mymob.fire, mymob.healths, mymob.zone_sel)
	..()
