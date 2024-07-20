//
//Robotic Component Analyser, basically a health analyser for robots
//
/obj/item/robotanalyzer
	name = "robot analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	icon = 'icons/obj/items/device/robot_analyzer.dmi'
	icon_state = ICON_STATE_WORLD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	throw_speed = 5
	throw_range = 10
	origin_tech = @'{"magnets":2,"biotech":1,"engineering":2}'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)

/obj/item/robotanalyzer/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))
		user.visible_message(
			SPAN_WARNING("\The [user] has analyzed the floor's vitals!"),
			self_message = SPAN_WARNING("You try to analyze the floor's vitals!"))
		user.show_message(SPAN_NOTICE("Analyzing Results for The floor:\n\t Overall Status: Healthy"))
		user.show_message(SPAN_NOTICE("\t Damage Specifics: [0]-[0]-[0]-[0]"))
		user.show_message(SPAN_NOTICE("Key: Suffocation/Toxin/Burns/Brute"))
		user.show_message(SPAN_NOTICE("Body Temperature: ???"))
		return TRUE

	var/scan_type
	if(isrobot(target))
		scan_type = "robot"
	else if(ishuman(target))
		scan_type = "prosthetics"
	else
		to_chat(user, "<span class='warning'>You can't analyze non-robotic things!</span>")
		return TRUE

	user.visible_message("<span class='notice'>\The [user] has analyzed [target]'s components.</span>","<span class='notice'>You have analyzed [target]'s components.</span>")
	switch(scan_type)
		if("robot")
			var/BU = target.get_damage(BURN)  > 50 ? "<b>[target.get_damage(BURN)]</b>"  : target.get_damage(BURN)
			var/BR = target.get_damage(BRUTE) > 50 ? "<b>[target.get_damage(BRUTE)]</b>" : target.get_damage(BRUTE)
			user.show_message("<span class='notice'>Analyzing Results for [target]:\n\t Overall Status: [target.stat > 1 ? "fully disabled" : "[target.current_health - target.get_damage(PAIN)]% functional"]</span>")
			user.show_message("\t Key: <font color='#ffa500'>Electronics</font>/<font color='red'>Brute</font>", 1)
			user.show_message("\t Damage Specifics: <font color='#ffa500'>[BU]</font> - <font color='red'>[BR]</font>")
			if(target.stat == DEAD)
				user.show_message("<span class='notice'>Time of Failure: [time2text(worldtime2stationtime(target.timeofdeath))]</span>")
			var/mob/living/silicon/robot/H = target
			var/list/damaged = H.get_damaged_components(1,1,1)
			user.show_message("<span class='notice'>Localized Damage:</span>",1)
			if(length(damaged)>0)
				for(var/datum/robot_component/org in damaged)
					user.show_message(text("<span class='notice'>\t []: [][] - [] - [] - []</span>",	\
					capitalize(org.name),					\
					(org.installed == -1)	?	"<font color='red'><b>DESTROYED</b></font> "							:"",\
					(org.electronics_damage > 0)	?	"<font color='#ffa500'>[org.electronics_damage]</font>"	:0,	\
					(org.brute_damage > 0)	?	"<font color='red'>[org.brute_damage]</font>"							:0,		\
					(org.toggled)	?	"Toggled ON"	:	"<font color='red'>Toggled OFF</font>",\
					(org.powered)	?	"Power ON"		:	"<font color='red'>Power OFF</font>"),1)
			else
				user.show_message("<span class='notice'>\t Components are OK.</span>",1)
			if(H.emagged && prob(5))
				user.show_message("<span class='warning'>\t ERROR: INTERNAL SYSTEMS COMPROMISED</span>",1)
			user.show_message("<span class='notice'>Operating Temperature: [target.bodytemperature-T0C]&deg;C ([target.bodytemperature*1.8-459.67]&deg;F)</span>", 1)

		if("prosthetics")

			var/mob/living/human/H = target
			to_chat(user, SPAN_NOTICE("Analyzing Results for \the [H]:"))
			to_chat(user, "Key: [SPAN_ORANGE("Electronics")]/[SPAN_RED("Brute")]")
			var/obj/item/organ/internal/cell/C = H.get_organ(BP_CELL, /obj/item/organ/internal/cell)
			if(C)
				to_chat(user, SPAN_NOTICE("Cell charge: [C.percent()] %"))
			else
				to_chat(user, SPAN_NOTICE("Cell charge: ERROR - Cell not present"))
			to_chat(user, SPAN_NOTICE("External prosthetics:"))
			var/organ_found
			for(var/obj/item/organ/external/E in H.get_external_organs())
				if(!BP_IS_PROSTHETIC(E))
					continue
				organ_found = 1
				to_chat(user, "[E.name]: [SPAN_RED(E.brute_dam)] [SPAN_ORANGE(E.burn_dam)]")
			if(!organ_found)
				to_chat(user, "No prosthetics located.")
			to_chat(user, "<hr>")
			to_chat(user, SPAN_NOTICE("Internal prosthetics:"))
			organ_found = null
			for(var/obj/item/organ/O in H.get_internal_organs())
				if(!BP_IS_PROSTHETIC(O))
					continue
				organ_found = 1
				to_chat(user, "[O.name]: [SPAN_RED(O.damage)]")
			if(!organ_found)
				to_chat(user, "No prosthetics located.")

	src.add_fingerprint(user)
	return TRUE
