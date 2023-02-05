// Returns the lowest turf available on a given Z-level

/proc/get_base_turf(var/z_num)
	if(!SSmapping.base_turf_by_z[z_num])
		SSmapping.base_turf_by_z[z_num] = world.turf
	return SSmapping.base_turf_by_z[z_num]

//An area can override the z-level base turf, so our solar array areas etc. can be space-based.
/proc/get_base_turf_by_area(var/turf/T)
	var/area/A = T.loc
	if(HasBelow(T.z))
		if(istype(A) && A.open_turf)
			return A.open_turf
		if(T.open_turf_type)
			return T.open_turf_type
	if(istype(A) && A.base_turf)
		return A.base_turf
	return get_base_turf(T.z)

/client/proc/set_base_turf()
	set category = "Debug"
	set name = "Set Base Turf"
	set desc = "Set the base turf for a z-level."

	if(!check_rights(R_DEBUG)) return

	var/choice = clamp(input("Which Z-level do you wish to set the base turf for?") as num|null, 0, length(SSmapping.base_turf_by_z))
	if(!choice)
		return

	var/new_base_path = input("Please select a turf path (cancel to reset to /turf/space).") as null|anything in typesof(/turf)
	if(!new_base_path)
		new_base_path = /turf/space
	SSmapping.base_turf_by_z[choice] = new_base_path
	message_admins("[key_name_admin(usr)] has set the base turf for z-level [choice] to [get_base_turf(choice)].")
	log_admin("[key_name(usr)] has set the base turf for z-level [choice] to [get_base_turf(choice)].")
