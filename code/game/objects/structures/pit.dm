/obj/structure/pit
	name           = "pit"
	desc           = "Watch your step, partner."
	icon           = 'icons/obj/structures/pit.dmi'
	icon_state     = "pit1"
	blend_mode     = BLEND_MULTIPLY
	density        = FALSE
	anchored       = TRUE
	current_health = ITEM_HEALTH_NO_DAMAGE //You can't break a hole in the ground.
	var/open       = TRUE

/obj/structure/pit/attackby(obj/item/used_item, mob/user)
	if(IS_SHOVEL(used_item))
		var/dig_message = open ? "filling in" : "excavating"
		if(used_item.do_tool_interaction(TOOL_SHOVEL, user, src, 5 SECONDS, dig_message, dig_message))
			if(open)
				close(user)
			else
				open(user)
		else
			to_chat(user, SPAN_NOTICE("You stop digging."))
		return TRUE

	if (!open && istype(used_item, /obj/item/gravemarker))
		var/competitor = locate(/obj/structure/gravemarker) in src.loc
		if(competitor)
			to_chat(user, SPAN_WARNING("There's already \a [competitor] here."))
			return TRUE
		user.visible_message(SPAN_NOTICE("\The [user] starts planting \a [used_item] on \the [src]."), SPAN_NOTICE("You start planting \a [used_item] on \the [src]."), SPAN_NOTICE("You hear soil shifting."))
		if(!do_after(user, 5 SECONDS, src))
			user.visible_message(SPAN_NOTICE("\The [user] stops planting \a [used_item] on \the [src]."), SPAN_NOTICE("You stop planting \a [used_item] on \the [src]."), SPAN_NOTICE("You hear the soil become still once more."))
			return TRUE
		var/obj/item/gravemarker/gravemarker = used_item
		if(gravemarker.bury(src, user))
			user.visible_message(SPAN_NOTICE("\The [user] plants a grave marker on \the [src]."), SPAN_NOTICE("You plant a grave marker on \the [src]."))
		return TRUE
	return ..()

/obj/structure/pit/on_update_icon()
	..()
	icon_state = "pit[open]"

/obj/structure/pit/proc/open(mob/user)
	name = initial(name)
	desc = initial(desc)
	open = TRUE
	for(var/atom/movable/A in src)
		A.dropInto(loc)
	update_icon()
	for(var/obj/structure/gravemarker/marker in get_turf(src))
		marker.unbury(user, place_in_hands = FALSE) // a grave disturbed!!

/obj/structure/pit/proc/close(var/user)
	name = "mound"
	desc = "Some things are better left buried."
	open = FALSE

	//If we close the pit without anything inside, just leave the soil undisturbed
	if(isturf(loc))
		for(var/atom/movable/A in loc)
			if(A != src && !A.anchored && A != user && A.simulated)
				A.forceMove(src)
	if(!length(contents))
		qdel(src)
	else
		update_icon()

/obj/structure/pit/return_air()
	return open && loc?.return_air()

/obj/structure/pit/proc/digout(mob/escapee)
	var/breakout_time = 1 //2 minutes by default

	if(open)
		return

	if(escapee.stat || escapee.restrained())
		return

	escapee.setClickCooldown(100)
	to_chat(escapee, SPAN_WARNING("You start digging your way out of \the [src] (this will take about [breakout_time] minute\s)"))
	visible_message(SPAN_DANGER("Something is scratching its way out of \the [src]!"))

	for(var/i in 1 to (6*breakout_time * 2)) //minutes * 6 * 5seconds * 2
		playsound(src.loc, 'sound/weapons/bite.ogg', 80, TRUE)

		if(!do_after(escapee, 5 SECONDS))
			to_chat(escapee, SPAN_WARNING("You have stopped digging."))
			return
		if(open)
			return

		if(i == 6*breakout_time)
			to_chat(escapee, SPAN_WARNING("Halfway there..."))

	to_chat(escapee, SPAN_NOTICE("You successfuly dig yourself out!"))
	visible_message(SPAN_DANGER("\The [escapee] emerges from \the [src]!"))
	playsound(src.loc, 'sound/effects/squelch1.ogg', 100, TRUE)
	open(escapee)

/obj/structure/pit/explosion_act(severity)
	//Pop open and throw the stuff out
	if(!open && severity > 2)
		open()
	. = ..()

/////////////////////////////////////////////
// Closed Pit
/////////////////////////////////////////////
/obj/structure/pit/closed
	name           = "mound"
	desc           = "Some things are better left buried."
	current_health = ITEM_HEALTH_NO_DAMAGE //Can't break a hole in the ground...

/obj/structure/pit/closed/Initialize()
	. = ..()
	close()

/////////////////////////////////////////////
// Hidden Closed Pit
/////////////////////////////////////////////
//invisible until unearthed first
/obj/structure/pit/closed/hidden
	invisibility = INVISIBILITY_OBSERVER

/obj/structure/pit/closed/hidden/open(mob/user)
	..()
	set_invisibility(INVISIBILITY_LEVEL_ONE)

/////////////////////////////////////////////
// Closed Grave
/////////////////////////////////////////////
/obj/structure/pit/closed/grave
	name       = "grave"
	icon_state = "pit0"

/obj/structure/pit/closed/grave/Initialize()
	setup_contents() // must run before parent call or close() will delete us
	. = ..()

/obj/structure/pit/closed/grave/proc/setup_contents()
	var/obj/structure/closet/coffin/C = new(src.loc)
	var/obj/item/remains/human/bones = new(C)
	bones.layer = LYING_MOB_LAYER
	var/obj/structure/gravemarker/random/R = new(src.loc)
	R.generate()

/////////////////////////////////////////////
// Grave Markers
/////////////////////////////////////////////
/obj/structure/gravemarker
	name                           = "grave marker"
	desc                           = "You're not the first."
	icon                           = 'icons/obj/structures/gravestone.dmi'
	icon_state                     = "wood"
	pixel_x                        = 15
	pixel_y                        = 8
	anchored                       = TRUE
	material                       = /decl/material/solid/organic/wood
	w_class                        = ITEM_SIZE_NORMAL
	material_alteration            = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC // todo: greyscale and add MAT_FLAG_ALTERATION_COLOR
	var/message                    = "Unknown."
	var/destruction_skill          = SKILL_HAULING // just brute force
	var/destruction_tool           = TOOL_HATCHET
	var/destruction_start_message  = "hacking away at"
	var/destruction_finish_message = "hacking at"
	var/gravemarker_type           = /obj/item/gravemarker

/obj/structure/gravemarker/examine(mob/user, distance)
	. = ..()
	if(distance < 2)
		var/processed_message = user.handle_reading_literacy(user, message)
		if(processed_message)
			to_chat(user, "It says: '[processed_message]'")
	else if(message)
		to_chat(user, "You can't read the inscription from here.")

/obj/structure/gravemarker/attackby(obj/item/used_item, mob/user)
	// we can dig it up with a shovel if the destruction tool is not a shovel, or if we're not on harm intent
	var/digging = IS_SHOVEL(used_item) && (destruction_tool != TOOL_SHOVEL || user?.a_intent != I_HURT)
	if(digging && used_item.do_tool_interaction(TOOL_SHOVEL, user, src, 2 SECONDS, "digging up", "digging up", check_skill = SKILL_HAULING))
		unbury(user, place_in_hands = TRUE) // deletes the grave marker and spawns an item in its place
		return TRUE
	if(IS_TOOL(used_item, destruction_tool))
		if(used_item.do_tool_interaction(destruction_tool, user, src, 3 SECONDS, destruction_start_message, destruction_finish_message, check_skill = destruction_skill))
			physically_destroyed(FALSE)
		return TRUE
	if(IS_PEN(used_item))
		var/msg = sanitize(input(user, "What should it say?", "Grave marker", html_decode(message)) as text|null)
		if(!CanPhysicallyInteract(user))
			to_chat(user, SPAN_WARNING("You must stay close to \the [src]!"))
			return
		if(msg && used_item.do_tool_interaction(TOOL_PEN, user, src, 1 SECOND, fuel_expenditure = 1))
			message = msg
		return TRUE
	. = ..()

// Cross Marker
/obj/structure/gravemarker/cross
	icon_state = "cross"

// Random Grave Marker
/obj/structure/gravemarker/random/Initialize()
	generate()
	. = ..()

/obj/structure/gravemarker/random/proc/generate()
	icon_state = pick("wood","cross")

	var/decl/cultural_info/S = GET_DECL(/decl/cultural_info/culture/human)
	var/nam = S.get_random_name(null, pick(MALE,FEMALE))
	var/cur_year = global.using_map.game_year
	var/born = cur_year - rand(5,150)
	var/died = max(cur_year - rand(0,70),born)

	message = "Here lies [nam], [born] - [died]."

// Gravestone
/obj/structure/gravemarker/gravestone
	name = "gravestone"
	icon_state = "stone"
	destruction_tool = TOOL_HAMMER
	destruction_start_message = "smashing"
	destruction_finish_message = "smashing"

// Gravemarker items.
// TODO: unify with signs somehow? some of this behaviour is similar...
/obj/item/gravemarker
	name                = "grave marker"
	desc                = "You're not the first."
	icon                = 'icons/obj/structures/gravestone.dmi'
	icon_state          = "wood"
	material            = /decl/material/solid/organic/wood
	w_class             = ITEM_SIZE_NORMAL
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC // todo: greyscale and add MAT_FLAG_ALTERATION_COLOR
	var/gravemarker_type = /obj/structure/gravemarker
	var/message         = "Unknown."

/obj/item/gravemarker/gravestone
	name = "gravestone"
	icon_state = "stone"
	material = /decl/material/solid/stone/granite
	gravemarker_type = /obj/structure/gravemarker/gravestone

/obj/item/gravemarker/examine(mob/user, distance)
	. = ..()
	if(distance < 2)
		var/processed_message = user.handle_reading_literacy(user, message)
		if(processed_message)
			to_chat(user, "It says: '[processed_message]'")
	else if(message)
		to_chat(user, "You can't read the inscription from here.")

// use on a pit to bury it in the ground
/obj/item/gravemarker/proc/bury(obj/structure/pit/grave, mob/user)
	if(!istype(grave))
		to_chat(user, SPAN_WARNING("You can't plant \the [src] here."))
		return FALSE
	if(grave.open)
		to_chat(user, SPAN_WARNING("You can't plant \the [src] here, it's an open pit!"))
		return FALSE
	var/obj/structure/gravemarker/gravemarker = new gravemarker_type(grave.loc, material.type)
	gravemarker.message = message
	gravemarker.icon_state = icon_state
	qdel(src)
	return TRUE

/obj/structure/gravemarker/proc/unbury(mob/user, place_in_hands = FALSE)
	var/turf/target_turf = get_turf(src)
	var/obj/item/gravemarker/gravemarker = new gravemarker_type(target_turf, material.type)
	gravemarker.dropInto(target_turf) // start by dropping it into the turf as a fallback
	if(place_in_hands)
		user.put_in_hands(gravemarker) // then, if possible, put it in the user's hands instead
	gravemarker.message = message
	gravemarker.icon_state = icon_state
	qdel(src)
	return TRUE

/obj/item/gravemarker/attackby(obj/item/used_item, mob/user)
	if(IS_PEN(used_item))
		var/msg = sanitize(input(user, "What should it say?", "Grave marker", html_decode(message)) as text|null)
		if(!CanPhysicallyInteract(user))
			to_chat(user, SPAN_WARNING("You must stay close to \the [src]!"))
			return
		if(msg && used_item.do_tool_interaction(TOOL_PEN, user, src, 1 SECOND, fuel_expenditure = 1))
			message = msg
		return TRUE
	. = ..()