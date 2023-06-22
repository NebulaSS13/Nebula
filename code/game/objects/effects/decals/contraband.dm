
//########################## CONTRABAND ;3333333333333333333 -Agouri ###################################################

/obj/item/contraband
	name = "contraband item"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/contraband.dmi'
	force = 0
	material = /decl/material/solid/cardboard //#TODO: Change to paper or something

/obj/item/contraband/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon_state = "rolled_poster"
	var/poster_type

/obj/item/contraband/poster/Initialize(var/ml, var/material_key, var/given_poster_type)
	if(given_poster_type && !ispath(given_poster_type, /decl/poster))
		. = INITIALIZE_HINT_QDEL
		CRASH("Invalid poster type: [log_info_line(given_poster_type)]")
	var/list/posters = decls_repository.get_decl_paths_of_subtype(/decl/poster)
	poster_type = given_poster_type || poster_type
	if(!poster_type)
		poster_type = pick(posters)
	var/serial_number = posters.Find(poster_type)
	name += " - No. [serial_number]"
	return ..(ml, material_key)

//Places the poster on a wall
/obj/item/contraband/poster/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if (!adjacent)
		return

	//must place on a wall and user must not be inside a closet/exosuit/whatever
	var/turf/W = get_turf(A)
	if(!istype(W) || !W.is_wall() || !isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in global.cardinal))
		to_chat(user, SPAN_WARNING("You must stand directly in front of the wall you wish to place that on."))
		return

	if (ArePostersOnWall(W))
		to_chat(user, SPAN_WARNING("There is already a poster there!"))
		return

	user.visible_message(
		SPAN_NOTICE("\The [user] starts placing a poster on \the [W]."),
		SPAN_NOTICE("You start placing the poster on \the [W]."))

	var/obj/structure/sign/poster/P = new (user.loc, null, null, placement_dir, poster_type)
	qdel(src)
	flick("poster_being_set", P)
	// Time to place is equal to the time needed to play the flick animation
	if(do_after(user, 28, W) && W.is_wall() && !ArePostersOnWall(W, P))
		user.visible_message(
			SPAN_NOTICE("\The [user] has placed a poster on \the [W]."),
			SPAN_NOTICE("You have placed the poster on \the [W]."))
	else
		// We cannot rely on user being on the appropriate turf when placement fails
		P.roll_and_drop(get_step(W, turn(placement_dir, 180)))

/obj/item/contraband/poster/proc/ArePostersOnWall(var/turf/W, var/placed_poster)
	//just check if there is a poster on or adjacent to the wall
	if (locate(/obj/structure/sign/poster) in W)
		return TRUE

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in global.cardinal)
		var/turf/T = get_step(W, dir)
		var/poster = locate(/obj/structure/sign/poster) in T
		if (poster && placed_poster != poster)
			return TRUE

	return FALSE

//############################## THE ACTUAL DECALS ###########################

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper."
	icon = 'icons/obj/contraband.dmi'
	anchored = TRUE
	directional_offset = "{'NORTH':{'y':32}, 'SOUTH':{'y':-32}, 'EAST':{'x':32}, 'WEST':{'x':-32}}"
	var/poster_type
	var/ruined = 0

/obj/structure/sign/poster/bay_9
	poster_type = /decl/poster/bay_9

/obj/structure/sign/poster/bay_50
	poster_type = /decl/poster/bay_50

/obj/structure/sign/poster/Initialize(var/ml, var/_mat, var/_reinf_mat, var/placement_dir = null, var/give_poster_type = null)
	. = ..(ml, _mat, _reinf_mat)
	if(!poster_type)
		if(give_poster_type)
			poster_type = give_poster_type
		else
			poster_type = pick(decls_repository.get_decl_paths_of_subtype(/decl/poster))
	set_poster(poster_type)

/obj/structure/sign/poster/proc/set_poster(var/poster_type)
	var/decl/poster/design = GET_DECL(poster_type)
	SetName("[initial(name)] - [design.name]")
	desc = "[initial(desc)] [design.desc]"
	icon_state = design.icon_state

/obj/structure/sign/poster/attackby(obj/item/W, mob/user)
	if(IS_WIRECUTTER(W))
		playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		if(ruined)
			to_chat(user, "<span class='notice'>You remove the remnants of the poster.</span>")
			qdel(src)
		else
			to_chat(user, "<span class='notice'>You carefully remove the poster from the wall.</span>")
			roll_and_drop(user.loc)
		return


/obj/structure/sign/poster/attack_hand(mob/user)
	if(ruined || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	if(!alert("Do I want to rip the poster from the wall?","You think...","Yes","No") == "Yes")
		return TRUE
	if(ruined || !CanPhysicallyInteract(user) || !user.check_dexterity(DEXTERITY_GRIP))
		return TRUE
	visible_message("<span class='warning'>\The [user] rips \the [src] in a single, decisive motion!</span>" )
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
	ruined = TRUE
	icon_state = "poster_ripped"
	SetName("ripped poster")
	desc = "You can't make out anything from the poster's original print. It's ruined."
	add_fingerprint(user)
	return TRUE

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	new /obj/item/contraband/poster(newloc, null, poster_type)
	qdel(src)

/decl/poster
	// Name suffix. Poster - [name]
	var/name=""
	// Description suffix
	var/desc=""
	var/icon_state=""
