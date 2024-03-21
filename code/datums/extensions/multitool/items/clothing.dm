/datum/extension/interactive/multitool/items/clothing/interact(var/obj/item/multitool/M, var/mob/user)
	if(extension_status(user) != STATUS_INTERACTIVE)
		return
	var/obj/item/clothing/uniform = holder
	if(!istype(uniform))
		to_chat(user, SPAN_WARNING("\The [user] is not wearing an appropriate uniform."))
		return
	var/obj/item/clothing/sensor/vitals/sensor = locate() in uniform.accessories
	if(!sensor)
		to_chat(user, SPAN_WARNING("\The [uniform] doesn't have a vitals sensors attached."))
		return
	sensor.toggle_sensors_locked()
	user.visible_message(SPAN_NOTICE("\The [user] [sensor.get_sensors_locked() ? "" : "un"]locks \the [user]'s suit sensor controls."), range = 2)
