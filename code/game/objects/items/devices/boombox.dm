/obj/item/music_player/boombox
	name = "boombox"
	desc = "A device used to emit rhythmic sounds, colloquially referred to as a 'boombox'. It's in a retro style (massive), and absolutely unwieldy."
	origin_tech = @'{"magnets":2,"combat":1}'
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon         = MATTER_AMOUNT_TRACE,
	)
	player_name = "BOOMTASTIC 3000"
	interact_sound = "switch"
	icon = 'icons/obj/items/device/boombox.dmi'

	var/break_chance = 3
	var/broken
	var/panel = TRUE

/obj/item/music_player/boombox/emp_act(severity)
	boombox_break()

/obj/item/music_player/boombox/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(!panel)
		. += SPAN_NOTICE("The front panel is unhinged.")
	if(broken)
		. += SPAN_WARNING("It's broken.")

/obj/item/music_player/boombox/attackby(var/obj/item/used_item, var/mob/user)
	if(IS_SCREWDRIVER(used_item))
		if(!panel)
			user.visible_message(SPAN_NOTICE("\The [user] re-attaches \the [src]'s front panel with \the [used_item]."), SPAN_NOTICE("You re-attach \the [src]'s front panel."))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			panel = TRUE
			return TRUE
		if(!broken)
			AdjustFrequency(used_item, user)
			return TRUE
		else if(panel)
			user.visible_message(SPAN_NOTICE("\The [user] unhinges \the [src]'s front panel with \the [used_item]."), SPAN_NOTICE("You unhinge \the [src]'s front panel."))
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			panel = FALSE
	if(istype(used_item,/obj/item/stack/nanopaste))
		var/obj/item/stack/S = used_item
		if(broken && !panel)
			if(S.use(1))
				user.visible_message(SPAN_NOTICE("\The [user] pours some of \the [S] onto \the [src]."), SPAN_NOTICE("You pour some of \the [S] over \the [src]'s internals and watch as it retraces and resolders paths."))
				broken = FALSE
			else
				to_chat(user, SPAN_NOTICE("\The [S] is empty."))
	else
		. = ..()

/obj/item/music_player/boombox/proc/AdjustFrequency(var/obj/item/used_item, var/mob/user)
	var/const/MIN_FREQUENCY = 0.5
	var/const/MAX_FREQUENCY = 1.5

	if(!MayAdjust(user))
		return FALSE

	var/list/options = list()
	var/tighten = "Tighten (play slower)"
	var/loosen  = "Loosen (play faster)"

	if(music_frequency > MIN_FREQUENCY)
		options += tighten
	if(music_frequency < MAX_FREQUENCY)
		options += loosen

	var/operation = input(user, "How do you wish to adjust the player head?", "Adjust player", options[1]) as null|anything in options
	if(!operation)
		return FALSE
	if(!MayAdjust(user))
		return FALSE
	if(used_item != user.get_active_held_item())
		return FALSE

	if(!CanPhysicallyInteract(user))
		return FALSE

	if(operation == loosen)
		music_frequency += 0.1
	else if(operation == tighten)
		music_frequency -= 0.1
	music_frequency = clamp(music_frequency, MIN_FREQUENCY, MAX_FREQUENCY)

	user.visible_message(SPAN_NOTICE("\The [user] adjusts \the [src]'s player head."), SPAN_NOTICE("You adjust \the [src]'s player head."))
	playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)

	if(music_frequency > 1.0)
		to_chat(user, SPAN_NOTICE("\The [src] should be playing faster than usual."))
	else if(music_frequency < 1.0)
		to_chat(user, SPAN_NOTICE("\The [src] should be playing slower than usual."))
	else
		to_chat(user, SPAN_NOTICE("\The [src] should be playing as fast as usual."))

	return TRUE

/obj/item/music_player/boombox/proc/MayAdjust(var/mob/user)
	if(playing)
		to_chat(user, "<span class='warning'>You can only adjust \the [src] when it's not playing.</span>")
		return FALSE
	return TRUE

/obj/item/music_player/boombox/proc/boombox_break()
	audible_message(SPAN_WARNING("\The [src]'s speakers pop with a sharp crack!"))
	playsound(src.loc, 'sound/effects/snap.ogg', 100, 1)
	broken = TRUE
	stop()

/obj/item/music_player/boombox/start()
	if(broken)
		return
	. = ..()
	if(prob(break_chance))
		boombox_break()

/obj/random_multi/single_item/boombox
	name = "boombox spawnpoint"
	id = "boomtastic"
	item_path = /obj/item/music_player/boombox
