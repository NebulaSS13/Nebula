// Specimen tag itself.
/obj/item/gps/specimen_tag
	name = "xenofauna tracker"
	gps_tag = "FAUNA0"
	icon = 'mods/content/exploration/icons/specimen_tag.dmi'
	decal_icon = 'mods/content/exploration/icons/specimen_tag_overlays.dmi'
	w_class = ITEM_SIZE_TINY
	tag_category = "XENOFAUNA"

	var/age = 0
	var/mob/living/implanted_in
	var/implanted_by
	var/physical_info = "No notes recorded."
	var/behavioral_info = "No notes recorded."

/obj/item/gps/specimen_tag/Initialize(mapload, _age, _implanted_by, _specimen_id, _specimen_gender, _physical_info, _behavioral_info, _specimen_type)
	// If we have a specimen, set up our data.
	if(_specimen_type)
		var/mob/living/critter = new _specimen_type(get_turf(src))
		implant(critter, TRUE)
		if(_specimen_gender)
			critter.gender = _specimen_gender
		if(_age)
			age = _age
		if(_specimen_id)
			gps_tag = _specimen_id
		if(_physical_info)
			physical_info = _physical_info
		if(_behavioral_info)
			behavioral_info = _behavioral_info
		if(_implanted_by)
			implanted_by = _implanted_by
	. = ..()
	if(!tracking)
		toggle_tracking()

/obj/item/gps/specimen_tag/Destroy()
	clear_implanted()
	. = ..()

/obj/item/gps/specimen_tag/Move()
	. = ..()
	if(implanted_in && loc != implanted_in)
		clear_implanted()

// Specimen tags are just for tracking, they don't work as held GPS.
/obj/item/gps/specimen_tag/attack_hand(mob/living/user)
	SHOULD_CALL_PARENT(FALSE)
	toggle_tracking(user)
	return TRUE
/obj/item/gps/specimen_tag/check_visible_to_holder()
	return FALSE
/obj/item/gps/specimen_tag/create_compass()
	return
/obj/item/gps/specimen_tag/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, master_ui, datum/topic_state/state)
	return

/obj/item/gps/specimen_tag/proc/has_been_implanted()
	return !QDELETED(implanted_in) && istype(implanted_in) && loc == implanted_in

/obj/item/gps/specimen_tag/proc/implant(var/mob/target, var/implanted_in_init = FALSE)
	forceMove(target)
	implanted_in = target
	events_repository.register(/decl/observ/destroyed, implanted_in, src, /obj/item/gps/specimen_tag/proc/clear_implanted)
	if(!implanted_in_init)
		generate_critter_info()

/obj/item/gps/specimen_tag/proc/generate_critter_info()

	var/list/possible_physical_info
	var/list/possible_behavioral_info
	var/datum/codex_entry/catalogue_data = SScodex.get_codex_entry(implanted_in.get_codex_value())
	if(istype(catalogue_data))
		var/notes = catalogue_data.get_fauna_physical_notes()
		if(!isnull(notes))
			LAZYDISTINCTADD(possible_physical_info, notes)
		notes = catalogue_data.get_fauna_behavior_notes()
		if(!isnull(notes))
			LAZYDISTINCTADD(possible_behavioral_info, notes)

	if(LAZYLEN(possible_physical_info))
		physical_info = pick(possible_physical_info)
	else
		physical_info = "No notes recorded."

	if(LAZYLEN(possible_behavioral_info))
		behavioral_info = pick(possible_behavioral_info)
	else
		behavioral_info = "No notes recorded."

/obj/item/gps/specimen_tag/proc/clear_implanted()
	if(implanted_in)
		events_repository.unregister(/decl/observ/destroyed, implanted_in, src)
		implanted_in = null

/obj/item/gps/specimen_tag/proc/update_from_animal()
	return

