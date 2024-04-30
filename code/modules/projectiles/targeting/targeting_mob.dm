/mob/living
	var/obj/aiming_overlay/aiming
	var/list/aimed_at_by

/mob/verb/toggle_gun_mode()
	set name = "Toggle Gun Mode"
	set desc = "Begin or stop aiming."
	set category = "IC"

	if(isliving(src)) //Needs to be a mob verb to prevent error messages when using hotkeys
		var/mob/living/M = src
		if(!M.aiming)
			M.aiming = new(src)
		M.aiming.toggle_active()
	else
		to_chat(src, "<span class='warning'>This verb may only be used by living mobs, sorry.</span>")
	return

/mob/living/proc/stop_aiming(var/obj/item/thing, var/no_message = 0)
	if(!aiming)
		aiming = new(src)
	if(thing && aiming.aiming_with != thing)
		return
	aiming.cancel_aiming(no_message)
