#define MODE_INACTIVE  		0
#define MODE_HARVESTING  	1
#define MODE_DRAINING  		2

/obj/machinery/artifact_harvester
	name = "exotic particle harvester"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "xenoarchaeology_harvester"
	anchored = 1
	density = 1
	idle_power_usage = 50
	active_power_usage = 750
	var/mode = MODE_INACTIVE
	var/obj/item/anobattery/inserted_battery
	var/obj/structure/artifact/cur_artifact
	var/obj/machinery/artifact_scanpad/owned_scanner = null
	var/charge_per_tick = 10

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/artifact_harvester

/obj/machinery/artifact_harvester/Initialize()
	. = ..()
	reconnect_scanner()

/obj/machinery/artifact_harvester/proc/reconnect_scanner()
	clear_scanner()
	owned_scanner = locate(/obj/machinery/artifact_scanpad) in get_step(src, dir)
	if(!owned_scanner)
		owned_scanner = locate(/obj/machinery/artifact_scanpad) in orange(1, src)
	if(owned_scanner)
		events_repository.register(/decl/observ/destroyed, owned_scanner, src, /obj/machinery/artifact_analyser/proc/clear_scanner)

/obj/machinery/artifact_harvester/Destroy()
	clear_scanner()
	inserted_battery = null
	. = ..()

/obj/machinery/artifact_harvester/proc/clear_scanner()
	if(owned_scanner)
		events_repository.unregister(/decl/observ/destroyed, owned_scanner, src)
		owned_scanner = null
		clear_artifact() // It was probably on the scanner; if not deleted, still want to clear it.

/obj/machinery/artifact_harvester/proc/clear_artifact()
	if(cur_artifact)
		events_repository.unregister(/decl/observ/destroyed, cur_artifact, src)
		cur_artifact = null

/obj/machinery/artifact_harvester/proc/set_artifact(var/obj/structure/artifact/new_artifact)
	if(cur_artifact == new_artifact || !new_artifact)
		return
	clear_artifact()
	events_repository.register(/decl/observ/destroyed, new_artifact, src, /obj/machinery/artifact_harvester/proc/clear_artifact)
	cur_artifact = new_artifact

/obj/machinery/artifact_harvester/attackby(var/obj/I, var/mob/user)
	if(istype(I,/obj/item/anobattery))
		if(!inserted_battery)
			if(!user.try_unequip(I, src))
				return
			to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")
			inserted_battery = I
			updateDialog()
		else
			to_chat(user, "<span class='warning'>There is already a battery in [src].</span>")
	else
		return..()

/obj/machinery/artifact_harvester/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/artifact_harvester/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	if(!owned_scanner)
		reconnect_scanner()
	if(!owned_scanner)
		data["error"] = "Unable to locate the scanner pad."
	else
		if(inserted_battery)
			data["battery"] = inserted_battery.name
			data["stored_charge"] = inserted_battery.stored_charge
			data["capacity"] = inserted_battery.capacity
			data["signature"] = inserted_battery.battery_effect?.artifact_id
		data["harvesting"] = mode == MODE_HARVESTING
		data["draining"] = mode == MODE_DRAINING

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "anomaly_harvester.tmpl", "Exotic Particle Harvester", 430, 315)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/artifact_harvester/on_update_icon()
	if(inserted_battery)
		icon_state = "xenoarchaeology_harvester"
	else
		icon_state = "xenoarchaeology_harvester_battery"

/obj/machinery/artifact_harvester/proc/set_mode(new_mode)
	mode = new_mode
	if(mode == MODE_INACTIVE)
		update_use_power(POWER_USE_IDLE)
	else
		update_use_power(POWER_USE_ACTIVE)

/obj/machinery/artifact_harvester/Process()
	if(!operable())
		return

	if(mode == MODE_HARVESTING)
		inserted_battery.add_charge(charge_per_tick)

		if(inserted_battery.stored_charge >= inserted_battery.capacity)
			clear_artifact()
			ping("Battery is full.")
			set_mode(MODE_INACTIVE)

	else if(mode == MODE_DRAINING)
		//dump some charge
		inserted_battery.use_power(charge_per_tick)

		//do the effect
		if(inserted_battery.battery_effect)
			inserted_battery.battery_effect.process()

			//if the effect works by touch, activate it on anyone near the console
			if(inserted_battery.battery_effect.operation_type == EFFECT_TOUCH)
				for(var/mob/M in hearers(1, src))
					inserted_battery.battery_effect.DoEffectTouch(M)

		//if there's no charge left, finish
		if(inserted_battery.stored_charge <= 0)
			inserted_battery.stored_charge = 0
			if(inserted_battery.battery_effect && inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate()
			ping("Battery dump completed.")
			set_mode(MODE_INACTIVE)

/obj/machinery/artifact_harvester/OnTopic(user, href_list)
	if(..())
		return TOPIC_HANDLED

	if (href_list["harvest"])
		if(!owned_scanner)
			reconnect_scanner()
		if(!owned_scanner)
			state("Cannot harvest. No scanner pad detected.")
			return TOPIC_HANDLED
		if(!inserted_battery)
			state("Cannot harvest. No battery inserted.")
			return TOPIC_HANDLED

		if(inserted_battery.stored_charge >= inserted_battery.capacity)
			state("Cannot harvest. battery is full.")
			return TOPIC_HANDLED

		//locate an active artifact on analysis pad
		clear_artifact()
		var/obj/structure/artifact/analysed
		for(var/obj/structure/artifact/A in get_turf(owned_scanner))
			if(A.my_effect.activated || (A.secondary_effect && A.secondary_effect.activated))
				analysed = A
				break

		if(!analysed)
			state("Cannot harvest. No noteworthy energy signature isolated.")
			return TOPIC_HANDLED

		set_artifact(analysed)

		//see if we can clear out an old effect
		//delete it when the ids match to account for duplicate ids having different effects
		if(inserted_battery.battery_effect && inserted_battery.stored_charge <= 0)
			qdel(inserted_battery.battery_effect)

		var/datum/artifact_effect/source_effect

		//if we already have charge in the battery, we can only recharge it from the source artifact
		if(inserted_battery.stored_charge > 0)
			var/battery_matches_primary_id = 0
			if(inserted_battery.battery_effect && inserted_battery.battery_effect.artifact_id == cur_artifact.my_effect.artifact_id)
				battery_matches_primary_id = 1

			var/battery_matches_secondary_id = 0
			if(inserted_battery.battery_effect && inserted_battery.battery_effect.artifact_id == cur_artifact.secondary_effect.artifact_id)
				battery_matches_secondary_id = 1

			if(!battery_matches_secondary_id && !battery_matches_primary_id)
				state("Cannot harvest. Battery is charged with a different energy signature.")
				return TOPIC_HANDLED

		if(cur_artifact.my_effect.activated)
			source_effect = cur_artifact.my_effect

		else if(cur_artifact.secondary_effect.activated)
			source_effect = cur_artifact.secondary_effect

		if(source_effect)
			set_mode(MODE_HARVESTING)
			state("Beginning harvesting mode.")

			//duplicate the artifact's effect datum
			if(!inserted_battery.battery_effect)
				inserted_battery.battery_effect = source_effect.copy()
				inserted_battery.battery_effect.holder = inserted_battery
				inserted_battery.stored_charge = 0

		. = TOPIC_REFRESH

	else if (href_list["stopharvest"])
		if(mode)
			if(mode == MODE_DRAINING && inserted_battery.battery_effect && inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate()
			clear_artifact()
			state("Energy mode interrupted.")
			set_mode(MODE_INACTIVE)
		. = TOPIC_REFRESH

	else if (href_list["ejectbattery"])
		inserted_battery.dropInto(loc)
		inserted_battery = null
		set_mode(MODE_INACTIVE)
		. = TOPIC_REFRESH

	else if (href_list["drainbattery"])
		if(inserted_battery)
			if(inserted_battery.battery_effect && inserted_battery.stored_charge > 0)
				state("Warning, battery charge dump commencing")
				if(!inserted_battery.battery_effect.activated)
					inserted_battery.battery_effect.ToggleActivate(1)
				set_mode(MODE_DRAINING)
			else
				state("Cannot dump energy. Battery is drained of charge already.")
		else
			state("Cannot dump energy. No battery inserted.")
		. = TOPIC_REFRESH


#undef	MODE_DRAINING
#undef 	MODE_INACTIVE
#undef 	MODE_HARVESTING