/datum/admin_secret_item/fun_secret/waddle
	name = "Toggle Waddling"
	var/waddling = FALSE

/datum/admin_secret_item/fun_secret/waddle/do_execute(var/mob/user)
	waddling = !waddling
	if(waddling)
		events_repository.register_global(/decl/observ/moved, src, .proc/waddle)
	else
		events_repository.unregister_global(/decl/observ/moved, src, .proc/waddle)

/datum/admin_secret_item/fun_secret/waddle/proc/waddle(atom/movable/AM)
	var/mob/living/L = AM
	if(!istype(L) || L.incapacitated() || L.lying)
		return
	animate(L, pixel_z = 4, time = 0)
	animate(pixel_z = 0, transform = turn(matrix(), pick(-12, 0, 12)), time=2)
	animate(pixel_z = 0, transform = matrix(), time = 0)