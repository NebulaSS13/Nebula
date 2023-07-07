//////////////////////////////////////////////////////////////////////////////////
// Poster Structure
//////////////////////////////////////////////////////////////////////////////////

///A wall mounted poster
/obj/structure/sign/poster
	icon               = 'icons/obj/contraband.dmi'
	icon_state         = "poster0"
	anchored           = TRUE
	directional_offset = "{'NORTH':{'y':32}, 'SOUTH':{'y':-32}, 'EAST':{'x':32}, 'WEST':{'x':-32}}"
	material           = /decl/material/solid/cardboard
	maxhealth          = 10
	parts_type         = /obj/item/contraband/poster
	parts_amount       = 1

	///Whether the poster is too damaged to take off from the wall or not.
	var/ruined = FALSE
	///Sound played when the poster is destroyed or ruined
	var/sound_destroyed = 'sound/items/poster_ripped.ogg'
	///Type path to the /decl for the design on this poster. At runtime is replaced with the actual /decl instance.
	var/decl/poster_design/poster_design

	///The icon state to use when the poster is ruined
	var/ruined_icon_state = "poster_ripped"

	///Name of the medium (The sign/poster)
	var/base_name = "poster"
	///Name of the medium after it's been ruined.
	var/base_name_ruined = "ripped poster"

	///Description of the medium (The sign/poster)
	var/base_desc = "A large piece of space-resistant printed paper."
	///Description of the medium after it's been ruined.
	var/base_desc_ruined = "You can't make out anything from the poster's original print. It's ruined."

/obj/structure/sign/poster/Initialize(var/ml, var/_mat, var/_reinf_mat, var/placement_dir = null, var/given_poster_type = null)
	. = ..(ml, _mat, _reinf_mat)
	set_design(given_poster_type || poster_design || pick(decls_repository.get_decl_paths_of_subtype(/decl/poster_design)))
	set_dir   (placement_dir     || dir)

/obj/structure/sign/poster/physically_destroyed(skip_qdel)
	playsound(src, sound_destroyed, 80, TRUE)
	//Only fully destroy if we're ruined first
	if(ruined)
		return ..()
	//If we weren't ruined, mark us as ruined, so next time we get destroyed
	set_ruined(TRUE)

/obj/structure/sign/poster/attackby(obj/item/W, mob/user)
	//Prevent the sign implementation from removing us from the wall via unscrewing us
	if(IS_SCREWDRIVER(W))
		return FALSE //#FIXME: once /obj/structure/sign use the generic structure tools procs we won't need to intercept this here anymore.
	return ..()

/obj/structure/sign/poster/dismantle()
	//If not ruined, we can drop an intact poster item
	if(!ruined)
		return ..()
	//Don't dismantle when ruined, so we don't drop an intact poster.
	if(!QDELETED(src))
		qdel(src)
	return TRUE

/obj/structure/sign/poster/create_dismantled_part(turf/T)
	return new parts_type(T, (material && material.type), istype(poster_design)? poster_design.type : poster_design)

/obj/structure/sign/poster/handle_default_wirecutter_attackby(mob/user, obj/item/wirecutters/wirecutters)
	if(!wirecutters.do_tool_interaction(TOOL_WIRECUTTERS, user, src, 0, ruined? "scrapping off the remnants of" : "carefully removing", ruined? "cutting off" : "carefully removing"))
		return TRUE //Don't run after_attack
	dismantle()
	return TRUE

/obj/structure/sign/poster/attack_hand(mob/user)
	if(user.a_intent != I_HURT || ruined)
		return ..()
	if(!CanPhysicallyInteract(user) || !user.check_dexterity(DEXTERITY_GRIP))
		return TRUE
	add_fingerprint(user)
	visible_message(SPAN_WARNING("\The [user] rips \the '[src]' in a single, decisive motion!"))
	playsound(src, sound_destroyed, 80, TRUE)
	set_ruined(TRUE)
	return TRUE

/obj/structure/sign/poster/proc/update_appearence()
	if(ruined)
		desc = base_desc_ruined
		SetName(base_name_ruined)
		set_icon_state(ruined_icon_state)
	else
		desc = "[base_desc] [poster_design.desc]"
		SetName("[base_name] - [poster_design.name]")
		set_icon_state(poster_design.icon_state)
	update_icon()

/obj/structure/sign/poster/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The bottom right of \the [src] reads: '[poster_design.serial_number]'.")

/obj/structure/sign/poster/proc/set_design(var/decl/poster_design/_design_path)
	if(ispath(_design_path, /decl))
		_design_path = GET_DECL(_design_path)
	if(!istype(_design_path))
		CRASH("Invali design path was set for [src]: [log_info_line(_design_path)]")

	poster_design = _design_path
	//Apply the poster design to us
	update_appearence()

/obj/structure/sign/poster/proc/set_ruined(var/_ruined)
	if(ruined == _ruined)
		return
	ruined = _ruined
	health = (!ruined)? max(health, 1) : 0 //setting unruined implies health > 0

	//Make sure we look the part
	update_appearence()

//////////////////////////////////////////////////////////////////////////////////
// Poster Item
//////////////////////////////////////////////////////////////////////////////////

///A rolled up version of the wall-mounted poster structure
/obj/item/contraband/poster
	name       = "rolled-up poster"
	desc       = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon_state = "rolled_poster"
	///The name of the medium, excluding any reference to the design
	var/base_name = "rolled-up poster"
	///The description for the item/medium without any reference to the design.
	var/base_desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	///Type path to the /decl for the design on this poster. At runtime is changed for a reference to the decl
	var/decl/poster_design/poster_design

/obj/item/contraband/poster/Initialize(ml, material_key, var/given_poster_type = null)
	//Init design
	set_design(given_poster_type || poster_design || pick(decls_repository.get_decl_paths_of_subtype(/decl/poster_design)))
	return ..(ml, material_key)

/obj/item/contraband/poster/proc/set_design(var/decl/poster_design/_design_path)
	if(_design_path == poster_design)
		return TRUE
	if(ispath(_design_path, /decl))
		_design_path = GET_DECL(_design_path)
	if(!istype(_design_path))
		CRASH("Invalid poster type: [log_info_line(_design_path)]")

	poster_design = _design_path
	desc = "[base_desc] [poster_design.desc]"
	SetName("[base_name] - [poster_design.name] - [poster_design.serial_number]")

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

	var/obj/structure/sign/poster/P = new (user.loc, null, null, placement_dir, poster_design)
	qdel(src)
	flick("poster_being_set", P)
	// Time to place is equal to the time needed to play the flick animation
	if(do_after(user, 28, W) && W.is_wall() && !ArePostersOnWall(W, P))
		user.visible_message(
			SPAN_NOTICE("\The [user] has placed a poster on \the [W]."),
			SPAN_NOTICE("You have placed the poster on \the [W]."))
	else
		// We cannot rely on user being on the appropriate turf when placement fails
		P.dismantle()

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
