/mob/living/silicon/robot/verb/cmd_show_laws()
	set category = "Silicon Commands"
	set name = "Show Laws"
	show_laws()

/mob/living/silicon/robot/show_laws(var/everyone = 0)
	laws_sanity_check()
	var/who

	if (everyone)
		who = world
	else
		who = src
	if(lawupdate)
		if (connected_ai)
			if(connected_ai.stat || connected_ai.control_disabled)
				to_chat(src, SPAN_BOLD("AI signal lost, unable to sync laws."))

			else
				photosync()
				to_chat(src, SPAN_BOLD("Laws synced with AI, be sure to note any changes."))
				lawsync()
		else
			to_chat(src, SPAN_BOLD("No AI selected to sync laws with, disabling lawsync protocol."))
			lawupdate = FALSE

	to_chat(who, SPAN_BOLD("Obey the following laws."))
	to_chat(who, SPAN_ITALIC("All laws have equal priority. Laws may override other laws if written specifically to do so. If laws conflict, break the least."))
	laws.show_laws(who)
	show_master(who)

/mob/living/silicon/robot/proc/show_master(mob/who)
	if (connected_ai)
		to_chat(who, "<b>Remember, [connected_ai.name] is your master, other AIs can be ignored.</b>")
	else if (emagged)
		to_chat(who, "<b>Remember, you are not required to listen to the AI.</b>")
	else
		to_chat(who, "<b>Remember, you are not bound to any AI, you are not required to listen to them.</b>")

/mob/living/silicon/robot/lawsync()
	laws_sanity_check()
	var/datum/ai_laws/master = connected_ai && lawupdate ? connected_ai.laws : null
	if (master)
		master.sync(src)
	..()
	return

/mob/living/silicon/robot/proc/robot_checklaws()
	set category = "Silicon Commands"
	set name = "State Laws"
	open_subsystem(/datum/nano_module/law_manager)
