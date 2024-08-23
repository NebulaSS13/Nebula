/mob
	var/decl/posture/current_posture

/mob/Initialize()
	var/list/postures = get_available_postures()
	if(length(postures))
		set_posture(postures[1])
	return ..()

/mob/proc/set_posture(decl/posture/posture, skip_buckled_update = FALSE)
	current_posture = GET_DECL(/decl/posture/standing)

/mob/proc/get_available_postures()
	var/static/list/available_postures = list(
		/decl/posture/standing
	)
	return available_postures

/mob/living/proc/get_selectable_postures()
	for(var/posture_type in get_available_postures())
		if(posture_type == current_posture.type || posture_type == current_posture.selectable_type)
			continue
		var/decl/posture/posture = GET_DECL(posture_type)
		if(posture.can_be_selected_by(src))
			LAZYDISTINCTADD(., posture)

/mob/living/get_available_postures()
	var/decl/bodytype/my_bodytype = get_bodytype()
	if(my_bodytype)
		return my_bodytype.available_mob_postures
	return ..()

/mob/living/set_posture(decl/posture/posture, skip_buckled_update = FALSE)

	if(ispath(posture))
		if(!(posture in get_available_postures()))
			posture = get_bodytype()?.get_equivalent_posture_type(posture)
		posture = GET_DECL(posture)
	else if(istype(posture) && !(posture.type in get_available_postures()))
		posture = GET_DECL(get_bodytype()?.get_equivalent_posture_type(posture.type))

	if(!istype(posture) || posture == current_posture)
		return FALSE

	current_posture = posture
	if(current_posture.prone)
		set_density(FALSE)
		drop_held_items()
		stop_aiming(no_message=1)
		if(buckled_mob)
			unbuckle_mob()
	else
		set_density(initial(density))

	if(skip_buckled_update)
		reset_layer()
		update_icon()
		update_transform()
	else
		update_posture(force_update = TRUE)

	return TRUE
