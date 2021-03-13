/*Typing indicators, when a mob uses the F3/F4 keys to bring the say/emote input boxes up this little buddy is
made and follows them around until they are done (or something bad happens), helps tell nearby people that 'hey!
I IS TYPIN'!'
*/

/mob
	var/atom/movable/overlay/typing_indicator/typing_indicator = null

/atom/movable/overlay/typing_indicator
	follow_proc = /atom/movable/proc/move_to_turf_or_null
	icon = 'icons/mob/talk.dmi'
	icon_state = "typing"

/atom/movable/overlay/typing_indicator/Initialize()
	. = ..()
	if(!istype(master, /mob))
		PRINT_STACK_TRACE("Master of typing_indicator has invalid type: [master.type].")

/atom/movable/overlay/typing_indicator/Destroy()
	var/mob/M = master
	M.typing_indicator = null
	. = ..()

/atom/movable/overlay/typing_indicator/SetInitLoc()
	forceMove(get_turf(master))

/mob/proc/create_typing_indicator()
	if(client && !stat && get_preference_value(/datum/client_preference/show_typing_indicator) == GLOB.PREF_SHOW && !src.is_cloaked() && isturf(src.loc))
		if(!typing_indicator)
			typing_indicator = new(src)
		typing_indicator.set_invisibility(0)

		var/matrix/M = matrix()
		M.Scale(0,0)
		typing_indicator.transform = M
		typing_indicator.alpha = 0
		animate(typing_indicator, transform = 0, alpha = 255, time = 0.2 SECONDS, easing = EASE_IN)

/mob/proc/remove_typing_indicator() // A bit excessive, but goes with the creation of the indicator I suppose
	if(typing_indicator)
		animate(typing_indicator, alpha = 0, time = 0.5 SECONDS, easing = EASE_IN)
		addtimer(CALLBACK(typing_indicator, /atom/proc/set_invisibility, INVISIBILITY_MAXIMUM), 0.5 SECONDS)

/mob/set_stat(new_stat)
	. = ..()
	if(.)
		remove_typing_indicator()

/mob/Logout()
	remove_typing_indicator()
	. = ..()

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	create_typing_indicator()
	var/message = input("","say (text)") as text|null
	remove_typing_indicator()
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	create_typing_indicator()
	var/message = input("","me (text)") as text|null
	remove_typing_indicator()
	if(message)
		me_verb(message)
