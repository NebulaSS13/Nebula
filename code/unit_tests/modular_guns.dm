
/datum/unit_test/modular_guns
	name = "GUNS: Modular Guns Shall Be Valid"
	var/list/frame_subtypes = list(
		/obj/item/gun/hand,
		/obj/item/gun/long,
		/obj/item/gun/staff,
		/obj/item/gun/cannon
	)

/datum/unit_test/modular_guns/start_test()
	var/list/failures = list()
	for(var/ftype in frame_subtypes)
		var/obj/item/gun/frame = ftype
		for(var/gtype in subtypesof(ftype))

			var/obj/item/gun/firearm = new gtype
			if(QDELETED(firearm))
				failures += "\the [firearm] ([gtype]) failed to initialize"
				continue

			// Check for valid base icons.
			if(!firearm.icon || !firearm.icon_state || !check_state_in_icon(firearm.icon_state, firearm.icon))
				failures += "\the [firearm] ([gtype]) had an invalid icon_state ([firearm.icon_state], [firearm.icon])"
				continue

			// Check for frame var overrides.
			if(initial(frame.w_class) != initial(firearm.w_class))
				failures += "\the [firearm] ([gtype]) overrode frame w_class"
			if(initial(frame.slot_flags) != initial(firearm.slot_flags))
				failures += "\the [firearm] ([gtype]) overrode frame slot_flags"
			if(initial(frame.force) != initial(firearm.force))
				failures += "\the [firearm] ([gtype]) overrode frame force"
			if(initial(frame.origin_tech) != initial(firearm.origin_tech))
				failures += "\the [firearm] ([gtype]) overrode frame origin_tech"

			// Check for valid components.
			var/list/firearm_components = firearm.get_modular_component_list()
			for(var/fcomp in firearm_components)
				var/obj/item/firearm_component/comp = firearm_components[fcomp]
				if(!istype(comp) || QDELETED(comp))
					failures += "\the [firearm] ([gtype]) is missing a valid [fcomp]"
				else if(!comp.icon || !check_state_in_icon(comp.icon_state, comp.icon))
					failures += "\the [firearm] ([gtype]) [fcomp] does not have a valid icon ([comp.icon_state], [comp.icon])"

				// compare calibers to make sure the gun can fire

	if(length(failures))
		fail("Some modular firearms were invalid:\n[jointext(failures, "\n")]")
	else
		pass("All modular firearms were valid.")
	return 1