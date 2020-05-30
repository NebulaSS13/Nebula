#define HOLDER_TARGET	 0
#define EYE_TARGET		 1
#define EXTENSION_TARGET 2

/datum/extension/eye
	base_type = /datum/extension/eye
	var/mob/observer/eye/extension_eye
	var/eye_type = /mob/observer/eye
	var/mob/current_looker

	// Actions used to pass commands from the eye to the holder. Must be subtype of /datum/action/eye.
	var/action_type
	var/list/actions = list()

/datum/extension/eye/Destroy()
	unlook()
	QDEL_NULL_LIST(actions)
	. = ..()

// Create the eye object and give control to the given mob.
/datum/extension/eye/proc/look(var/mob/new_looker, var/list/eye_args)
	if(new_looker.eyeobj || current_looker)
		return FALSE
	
	LAZYINSERT(eye_args, get_turf(new_looker), 1) // Make sure that a loc is provided to the eye.

	if(!extension_eye)
		extension_eye = new eye_type(arglist(eye_args))

	current_looker = new_looker

	extension_eye.possess(current_looker)

	if(action_type)
		for(var/atype in subtypesof(action_type))
			var/datum/action/eye/action = new atype(src) // Eye actions determine their target based off their own target_type var.
			actions += action
			action.Grant(current_looker)

	// Manual unlooking for the looker.
	var/datum/action/eye/unlook/unlook_action = new(src)
	actions += unlook_action
	unlook_action.Grant(current_looker)

	// Checks for removing the user from the eye outside of unlook actions.
	GLOB.moved_event.register(holder, src, /datum/extension/eye/proc/unlook)
	GLOB.moved_event.register(current_looker, src, /datum/extension/eye/proc/unlook)

	GLOB.destroyed_event.register(current_looker, src, /datum/extension/eye/proc/unlook)
	GLOB.destroyed_event.register(extension_eye, src, /datum/extension/eye/proc/unlook)

	GLOB.stat_set_event.register(current_looker, src, /datum/extension/eye/proc/unlook)
	GLOB.logged_out_event.register(current_looker, src, /datum/extension/eye/proc/unlook)

	return TRUE

/datum/extension/eye/proc/unlook()

	GLOB.moved_event.unregister(holder, src, /datum/extension/eye/proc/unlook)
	GLOB.moved_event.unregister(current_looker, src, /datum/extension/eye/proc/unlook)
	
	GLOB.destroyed_event.unregister(current_looker, src, /datum/extension/eye/proc/unlook)
	GLOB.destroyed_event.unregister(extension_eye, src, /datum/extension/eye/proc/unlook)

	GLOB.stat_set_event.unregister(current_looker, src, /datum/extension/eye/proc/unlook)
	GLOB.logged_out_event.unregister(current_looker, src, /datum/extension/eye/proc/unlook)

	QDEL_NULL(extension_eye)

	if(current_looker)
		for(var/datum/action/A in actions)
			A.Remove(current_looker)

	current_looker = null

/datum/extension/eye/proc/get_eye_turf()
	return get_turf(extension_eye)

/datum/action/eye
	action_type = AB_GENERIC
	check_flags = AB_CHECK_STUNNED|AB_CHECK_LYING
	var/eye_type = /mob/observer/eye/
	var/target_type = HOLDER_TARGET // The relevant owner of the proc to be called by the action.

/datum/action/eye/New(var/datum/extension/eye/eye_extension)
	switch(target_type)
		if(HOLDER_TARGET)
			return ..(eye_extension.holder)
		if(EYE_TARGET)
			return ..(eye_extension.extension_eye)
		if(EXTENSION_TARGET)
			return ..(eye_extension)
		else
			CRASH("Attempted to generate eye action [src] but an improper target_type ([target_type]) was defined.")

/datum/action/eye/CheckRemoval(mob/living/user)
	if(!user.eyeobj || !istype(user.eyeobj, eye_type))
		return TRUE

// Every eye created using a subtype of this extension will have this action added for manual unlooking.
/datum/action/eye/unlook
	name = "Stop looking"
	procname = "unlook"
	button_icon_state = "cancel"
	target_type = EXTENSION_TARGET
