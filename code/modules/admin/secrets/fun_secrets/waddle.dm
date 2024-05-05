/datum/admin_secret_item/fun_secret/waddle
	name = "Toggle Waddling"
	var/waddling = FALSE

/datum/admin_secret_item/fun_secret/waddle/do_execute(var/mob/user)
	waddling = !waddling
	if(waddling)
		for(var/mob/living/living_mob in global.living_mob_list_)
			set_extension(living_mob, /datum/extension/waddle)
		events_repository.register_global(/decl/observ/life, src, PROC_REF(enroll_in_waddling))
		events_repository.register_global(/decl/observ/death, src, PROC_REF(cure_waddling))
	else
		for(var/mob/living/living_mob in global.living_mob_list_)
			cure_waddling(living_mob)
		events_repository.unregister_global(/decl/observ/life, src)
		events_repository.unregister_global(/decl/observ/death, src)

/datum/admin_secret_item/fun_secret/waddle/proc/enroll_in_waddling(mob/living/waddler)
	if(!istype(waddler))
		return
	set_extension(waddler, /datum/extension/waddle)

/datum/admin_secret_item/fun_secret/waddle/proc/cure_waddling(mob/living/patient)
	if(!istype(patient))
		return
	remove_extension(patient, /datum/extension/waddle)

/datum/extension/waddle
	base_type = /datum/extension/waddle
	expected_type = /mob
	flags = EXTENSION_FLAG_IMMEDIATE

/datum/extension/waddle/New(datum/holder)
	. = ..()
	events_repository.register(/decl/observ/moved, holder, src, PROC_REF(waddle))
	events_repository.register(/decl/observ/destroyed, holder, src, PROC_REF(qdel_self))

/datum/extension/event_registration/Destroy()
	events_repository.unregister(/decl/observ/destroyed, holder, src)
	events_repository.unregister(/decl/observ/moved, holder, src)
	return ..()

/datum/extension/waddle/proc/waddle()
	var/mob/living/L = holder
	if(!istype(L) || L.incapacitated() || L.current_posture.prone)
		return
	animate(L, pixel_z = 4, time = 0)
	animate(pixel_z = 0, transform = turn(matrix(), pick(-12, 0, 12)), time=2)
	animate(pixel_z = 0, transform = matrix(), time = 0)