
/datum/unit_test/modular_guns
	name = "GUNS: Modular Guns Shall Have Valid Components"

/datum/unit_test/modular_guns/start_test()
	var/list/failures = list()
	for(var/gtype in subtypesof(/obj/item/gun))

		var/obj/item/gun/firearm = new gtype
		if(QDELETED(firearm))
			failures += "\the [firearm] ([gtype]) failed to initialize"
			continue

		if(!firearm.icon || !firearm.icon_state || !check_state_in_icon(firearm.icon_state, firearm.icon))
			failures += "\the [firearm] ([gtype]) had an invalid icon_state ([firearm.icon_state], [firearm.icon])"
			continue

		var/list/firearm_components = firearm.get_modular_component_list()
		for(var/fcomp in firearm_components)
			var/obj/item/firearm_component/comp = firearm_components[fcomp]
			if(!istype(comp) || QDELETED(comp))
				failures += "\the [firearm] ([gtype]) is missing a valid [fcomp]"
			else if(!comp.icon || !check_state_in_icon(comp.icon_state, comp.icon))
				failures += "\the [firearm] ([gtype]) [fcomp] does not have a valid icon ([comp.icon_state], [comp.icon])"

			// compare calibers to make sure the gun can fire

	if(length(failures))
		fail("Some modular firearms had invalid components:\n[jointext(failures, "\n")]")
	else
		pass("All modular firearms had valid components.")
	return 1