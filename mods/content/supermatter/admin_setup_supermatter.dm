#define ENERGY_NITROGEN 115			// Roughly 8 emitter shots.
#define ENERGY_CARBONDIOXIDE 150	// Roughly 10 emitter shots.
#define ENERGY_HYDROGEN 300			// Roughly 20 emitter shots.

/datum/admins/proc/setup_supermatter()
	set category = "Debug"
	set name = "Setup Supermatter"
	set desc = "Allows you to start the Supermatter engine."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/response = input(usr, "Are you sure? This will start up the engine with selected gas as coolant.", "Engine setup") as null|anything in list("N2", "CO2", "H2", "Abort")
	if(!response || response == "Abort")
		return

	var/errors = 0
	var/warnings = 0
	var/success = 0

	log_and_message_admins("## SUPERMATTER SETUP - Setup initiated by [usr] using coolant type [response].")

	// CONFIGURATION PHASE
	// Coolant canisters, set types according to response.
	for(var/obj/effect/engine_setup/coolant_canister/C in global.engine_setup_markers)
		switch(response)
			if("N2")
				C.canister_type = /obj/machinery/portable_atmospherics/canister/nitrogen/engine_setup/
				continue
			if("CO2")
				C.canister_type = /obj/machinery/portable_atmospherics/canister/carbon_dioxide/engine_setup/
				continue
			if("H2")
				C.canister_type = /obj/machinery/portable_atmospherics/canister/hydrogen/engine_setup/
				continue

	for(var/obj/effect/engine_setup/core/C in global.engine_setup_markers)
		switch(response)
			if("N2")
				C.energy_setting = ENERGY_NITROGEN
				continue
			if("CO2")
				C.energy_setting = ENERGY_CARBONDIOXIDE
				continue
			if("H2")
				C.energy_setting = ENERGY_HYDROGEN
				continue

	for(var/obj/effect/engine_setup/filter/F in global.engine_setup_markers)
		F.coolant = response

	var/list/delayed_objects = list()
	// SETUP PHASE
	for(var/obj/effect/engine_setup/S in global.engine_setup_markers)
		var/result = S.activate(0)
		switch(result)
			if(ENGINE_SETUP_OK)
				success++
				continue
			if(ENGINE_SETUP_WARNING)
				warnings++
				continue
			if(ENGINE_SETUP_ERROR)
				errors++
				log_and_message_admins("## SUPERMATTER SETUP - Error encountered! Aborting.")
				break
			if(ENGINE_SETUP_DELAYED)
				delayed_objects.Add(S)
				continue

	if(!errors)
		for(var/obj/effect/engine_setup/S in delayed_objects)
			var/result = S.activate(1)
			switch(result)
				if(ENGINE_SETUP_OK)
					success++
					continue
				if(ENGINE_SETUP_WARNING)
					warnings++
					continue
				if(ENGINE_SETUP_ERROR)
					errors++
					log_and_message_admins("## SUPERMATTER SETUP - Error encountered! Aborting.")
					break

	log_and_message_admins("## SUPERMATTER SETUP - Setup completed with [errors] errors, [warnings] warnings and [success] successful steps.")

	return



// Energises the supermatter. Errors when unable to locate supermatter.
/obj/effect/engine_setup/core
	name = "Supermatter Core Marker"
	var/energy_setting = 0

/obj/effect/engine_setup/core/activate(var/last = 0)
	if(!last)
		return ENGINE_SETUP_DELAYED
	..()
	var/obj/structure/supermatter/SM = locate() in get_turf(src)
	if(!SM)
		log_and_message_admins("## ERROR: Unable to locate supermatter core at [x] [y] [z]!")
		return ENGINE_SETUP_ERROR
	if(!energy_setting)
		log_and_message_admins("## ERROR: Energy setting unset at [x] [y] [z]!")
		return ENGINE_SETUP_ERROR
	SM.power = energy_setting
	return ENGINE_SETUP_OK

#undef ENERGY_NITROGEN
#undef ENERGY_CARBONDIOXIDE
#undef ENERGY_HYDROGEN
