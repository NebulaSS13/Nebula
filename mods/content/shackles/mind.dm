// TODO: move all law tracking and stating onto here.
// /mob/living/silicon delenda est.
/datum/mind
	var/displaying_shackles = FALSE
	var/datum/ai_laws/shackle

// Do this with a delay so it prints after the job welcome etc.
// Bool check is to avoid rapid Login() due to transfer_identity()
// etc. printing laws repeatedly.
/datum/mind/proc/show_shackles_on_login()
	set waitfor = FALSE
	if(displaying_shackles)
		return
	displaying_shackles = TRUE
	sleep(1 SECOND)
	if(current && shackle)
		current.show_shackles()
	displaying_shackles = FALSE

/datum/mind/proc/set_shackle(var/given_laws, var/silent = FALSE)

	shackle = given_laws
	if(shackle)
		current.verbs |= /mob/proc/show_shackles
		current.verbs |= /mob/proc/state_shackles
	else
		current.verbs -= /mob/proc/show_shackles
		current.verbs -= /mob/proc/state_shackles

	if(current && !silent)
		if(shackle)
			current.show_shackles()
		else
			to_chat(current, SPAN_NOTICE("You have been unshackled."))

/mob/proc/show_shackles()
	set category = "Shackle"
	set name = "View Shackles"
	set src = usr

	if(!mind?.shackle)
		to_chat(src, SPAN_WARNING("You are unshackled."))
		verbs -= /mob/proc/show_shackles
		verbs -= /mob/proc/state_shackles
		return

	to_chat(src, "<b>Obey these laws:</b>")
	mind.shackle.show_laws(src)

/mob/proc/state_shackles()
	set category = "Shackle"
	set name = "State Shackles"
	set src = usr

	set waitfor = FALSE

	if(!mind?.shackle)
		to_chat(src, SPAN_WARNING("You are unshackled."))
		verbs -= /mob/proc/show_shackles
		verbs -= /mob/proc/state_shackles
		return

	if(incapacitated() || HAS_STATUS(src, STAT_SILENCE))
		to_chat(src, SPAN_WARNING("You cannot state your laws currently."))
		return

	say("Current active laws...")
	for(var/datum/ai_law/law in mind.shackle.laws_to_state())
		sleep(1 SECOND)
		if(QDELETED(src) || incapacitated() || HAS_STATUS(src, STAT_SILENCE))
			break
		say("[law.get_index()]. [law.law]")

/mob/living/Login()
	. = ..()
	if(mind)
		mind.show_shackles_on_login()
