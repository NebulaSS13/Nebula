/obj/structure/pit
	name           = "pit"
	desc           = "Watch your step, partner."
	icon           = 'icons/obj/structures/pit.dmi'
	icon_state     = "pit1"
	blend_mode     = BLEND_MULTIPLY
	density        = FALSE
	anchored       = TRUE
	current_health = -1     //You can't break a hole in the ground.
	var/open       = TRUE

/obj/structure/pit/attackby(obj/item/W, mob/user)
	if(IS_SHOVEL(W))
		var/dig_message = open ? "filling in" : "excavating"
		if(W.do_tool_interaction(TOOL_SHOVEL, user, src, 5 SECONDS, dig_message, dig_message))
			if(open)
				close(user)
			else
				open()
		else
			to_chat(user, SPAN_NOTICE("You stop digging."))
		return TRUE

	if (!open && istype(W, /obj/item/stack/material/plank) && istype(W.material, /decl/material/solid/organic/wood))
		if(locate(/obj/structure/gravemarker) in src.loc)
			to_chat(user, SPAN_WARNING("There's already a grave marker here."))
		else
			var/obj/item/stack/material/plank = W
			visible_message(SPAN_WARNING("\The [user] starts making a grave marker on top of \the [src]"))
			if(do_after(user, 5 SECONDS) && plank.use(1))
				visible_message(SPAN_NOTICE("\The [user] finishes the grave marker."))
				new /obj/structure/gravemarker(src.loc)
			else
				to_chat(user, SPAN_NOTICE("You stop making a grave marker."))
		return TRUE
	return ..()

/obj/structure/pit/on_update_icon()
	..()
	icon_state = "pit[open]"
	if(isturf(loc))
		var/turf/T = loc
		var/soil_color = T.get_soil_color()
		if(soil_color)
			color = soil_color

/obj/structure/pit/proc/open()
	name = initial(name)
	desc = initial(desc)
	open = TRUE
	for(var/atom/movable/A in src)
		A.dropInto(loc)
	update_icon()

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
	open()

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

/obj/structure/pit/closed/hidden/open()
	..()
	set_invisibility(INVISIBILITY_LEVEL_ONE)

/////////////////////////////////////////////
// Closed Grave
/////////////////////////////////////////////
/obj/structure/pit/closed/grave
	name       = "grave"
	icon_state = "pit0"

/obj/structure/pit/closed/grave/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		setup_contents()

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
	name        = "grave marker"
	desc        = "You're not the first."
	icon        = 'icons/obj/structures/gravestone.dmi'
	icon_state  = "wood"
	pixel_x     = 15
	pixel_y     = 8
	anchored    = TRUE
	material    = /decl/material/solid/organic/wood
	w_class     = ITEM_SIZE_NORMAL
	var/message = "Unknown."

/obj/structure/gravemarker/examine(mob/user)
	. = ..()
	to_chat(user, "It says: '[message]'")

/obj/structure/gravemarker/attackby(obj/item/W, mob/user)
	if(IS_HATCHET(W))
		if(W.do_tool_interaction(TOOL_HATCHET, user, src, 3 SECONDS, "hacking away at", "hacking at"))
			physically_destroyed(FALSE)
		return TRUE
	if(IS_PEN(W))
		var/msg = sanitize(input(user, "What should it say?", "Grave marker", message) as text|null)
		if(!CanPhysicallyInteract(user))
			to_chat(user, SPAN_WARNING("You must stay close to \the [src]!"))
			return
		if(msg && W.do_tool_interaction(TOOL_PEN, user, src, 1 SECOND, fuel_expenditure = 1))
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
