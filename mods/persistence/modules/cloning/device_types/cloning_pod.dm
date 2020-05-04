#define TASK_SCAN_TIME 	60
#define TASK_CLONE_TIME	60

/datum/extension/network_device/cloning_pod
	var/occupied = FALSE
	var/scanning = FALSE
	var/cloning = FALSE
	var/task_started_on

	var/datum/file_transfer/scan

// Checks if this is a valid place for a mob to use as a cloning respawn point.
/datum/extension/network_device/cloning_pod/proc/is_valid_respawn(var/mind_id)
	if(!mind_id)
		return FALSE
	var/obj/machinery/cloning_pod/CP = holder
	if(!CP.operable() || CP.stat & (BROKEN|NOPOWER) || occupied)
		return FALSE
	var/datum/computer_network/network = get_network()
	if(!network)
		return FALSE
	return network.get_latest_clone_backup(mind_id)

/datum/extension/network_device/cloning_pod/proc/get_occupant()
	var/obj/machinery/cloning_pod/CP = holder
	return CP.occupant

/datum/extension/network_device/cloning_pod/proc/set_occupant(var/atom/movable/target, var/mob/user)
	var/obj/machinery/cloning_pod/CP = holder
	CP.occupant = target
	occupied = !!CP.occupant
	if(!target)
		cloning = FALSE
		scanning = FALSE
		return

	if(istype(target, /mob))
		var/mob/M = target
		M.forceMove(CP)
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = CP

	if(istype(target, /obj/item/organ/internal/stack))
		var/obj/item/organ/internal/stack/S = target
		if(user && !user.unEquip(S, CP))
			return FALSE
		if(S.stackmob && S.stackmob.client)
			S.stackmob.client.perspective = EYE_PERSPECTIVE
			S.stackmob.client.eye = CP

/datum/extension/network_device/cloning_pod/proc/create_character(var/datum/mind/mind, var/ckey, var/datum/computer_file/data/cloning/backup)
	var/datum/computer_network/network = get_network()
	if(!network)
		return
	var/obj/machinery/cloning_pod/CP = holder
	if(!istype(backup))
		backup = network.get_latest_clone_backup(mind.unique_id, TRUE)
	if(!istype(backup))
		return
	var/mob/living/carbon/human/new_character = new(CP, backup.dna.species)
	new_character.setDNA(backup.dna)
	new_character.fully_replace_character_name(backup.dna.real_name)
	new_character.UpdateAppearance()
	new_character.sync_organ_dna()

	mind.transfer_to(new_character)

	new_character.set_sdisability(BLINDED)

	to_chat(new_character, "Reality comes flooding back all at once, cushioned by a flurry of perfluorochemical bubbles.")
	to_chat(new_character, SPAN_NOTICE("OOC: Characters usually have memory loss about the details surrounding their death. Play responsibly."))

	set_occupant(new_character)
	cloning = TRUE
	task_started_on = world.time
	addtimer(CALLBACK(src, /datum/extension/network_device/cloning_pod/proc/eject_occupant), TASK_CLONE_TIME SECONDS)
	qdel(backup)
	return new_character

/datum/extension/network_device/cloning_pod/proc/eject_occupant(var/mob/user)
	var/atom/movable/occupant = get_occupant()
	if(!occupant)
		return
	if(scanning)
		to_chat(user, SPAN_NOTICE("Cannot eject [occupant] while scans are running."))
		return
	if(cloning)
		to_chat(user, SPAN_NOTICE("Cannot eject [occupant] while cloning process is active."))
		return

	var/obj/machinery/cloning_pod/CP = holder

	var/mob/M = occupant
	if(M && M.client)
		M.client.eye = M.client.mob
		M.client.perspective = MOB_PERSPECTIVE
		M.unset_sdisability(BLINDED)

	var/obj/item/organ/internal/stack/S = occupant
	if(istype(occupant, /obj/item/organ/internal/stack) && S && S.stackmob && S.stackmob.client)
		S.stackmob.client.eye = S.stackmob.client.mob
		S.stackmob.client.perspective = MOB_PERSPECTIVE

	occupant.dropInto(CP.loc)
	set_occupant(null)
	return TRUE

/datum/extension/network_device/cloning_pod/proc/begin_scan(var/mob/caller, var/filesource)
	var/atom/movable/occupant = get_occupant()
	if(!occupant)
		return

	if(istype(occupant, /obj/item/organ/internal/stack))
		to_chat(caller, SPAN_WARNING("Occupant is invalid for scan."))
		return

	scanning = TRUE
	task_started_on = world.time
	var/datum/computer_file/data/cloning/cloneFile = new()
	cloneFile.initialize_backup(occupant)
	scan = new(null, filesource, cloneFile)
	addtimer(CALLBACK(src, /datum/extension/network_device/cloning_pod/proc/finish_scan), TASK_SCAN_TIME SECONDS)
	to_chat(occupant, SPAN_NOTICE("Lights flash around you as a cortical scan begins."))

/datum/extension/network_device/cloning_pod/proc/finish_scan()
	var/atom/movable/occupant = get_occupant()
	if(!occupant)
		return

	scanning = FALSE
	if(!scan || !scan.copying_to)
		return
	scan.copying_to.store_file(scan.copying)

	qdel(scan)
	scan = null

/datum/extension/network_device/cloning_pod/proc/begin_clone()
	var/atom/movable/occupant = get_occupant()
	if(!occupant)
		return
	var/obj/item/organ/internal/stack/S = occupant
	if(!S)
		return
	return create_character(S.stackmob.mind, S.stackmob.mind.key, S.backup)