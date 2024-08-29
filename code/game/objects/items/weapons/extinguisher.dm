/obj/item/chems/spray/extinguisher
	name                          = "fire extinguisher"
	desc                          = "A traditional red fire extinguisher."
	icon                          = 'icons/obj/items/fire_extinguisher.dmi'
	icon_state                    = "fire_extinguisher0"
	item_state                    = "fire_extinguisher"
	hitsound                      = 'sound/weapons/smash.ogg'
	atom_flags                    = ATOM_FLAG_OPEN_CONTAINER
	obj_flags                     = OBJ_FLAG_CONDUCTIBLE | OBJ_FLAG_HOLLOW
	w_class                       = ITEM_SIZE_NORMAL
	throw_speed                   = 2
	throw_range                   = 10
	material                      = /decl/material/solid/metal/steel
	matter                        = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT)
	attack_verb                   = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	possible_transfer_amounts     = @"[30,60,120]" //units of liquid per spray - 120 -> same as splashing them with a bucket per spray
	possible_particle_amounts     = @"[1,2,3]"     //Amount of chempuff particles to spawn on spray
	amount_per_transfer_from_this = 120
	volume                        = 2000
	spray_particles               = 3                    //Amount of liquid particles to spawn on spray
	particle_move_delay           = 5                    //Spray effect move delay
	safety                        = TRUE
	sound_spray                   = 'sound/effects/extinguish.ogg'
	_base_attack_force            = 10
	var/sprite_name               = "fire_extinguisher"

/obj/item/chems/spray/extinguisher/mini
	name                          = "mini fire extinguisher"
	desc                          = "A light and compact fiberglass-framed model fire extinguisher."
	icon_state                    = "miniFE0"
	item_state                    = "miniFE"
	sprite_name                   = "miniFE"
	w_class                       = ITEM_SIZE_SMALL
	hitsound                      = null
	possible_transfer_amounts     = @"[40,80]" //units of liquid per spray - 120 -> same as splashing them with a bucket per spray
	possible_particle_amounts     = @"[1,2]"
	amount_per_transfer_from_this = 80
	spray_particles               = 2
	volume                        = 1000
	material                      = /decl/material/solid/organic/plastic
	matter                        = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE,
		/decl/material/solid/fiberglass  = MATTER_AMOUNT_REINFORCEMENT
	)
	_base_attack_force            = 3

/obj/item/chems/spray/extinguisher/populate_reagents()
	add_to_reagents(/decl/material/liquid/water, reagents.maximum_volume)

/obj/item/chems/spray/extinguisher/has_safety()
	return TRUE

/obj/item/chems/spray/extinguisher/on_update_icon()
	. = ..()
	icon_state = "[sprite_name][!safety]"

/obj/item/chems/spray/extinguisher/Spray_at(atom/movable/A, mob/user, proximity)
	. = ..()
	if(!.)
		return
	if(user.buckled && isobj(user.buckled))
		addtimer(CALLBACK(src, PROC_REF(propel_object), user.buckled, user, get_dir(A, user)), 0)
	else if(!user.check_space_footing())
		var/old_dir = user.dir
		step(user, get_dir(A, user))
		user.set_dir(old_dir)

/obj/item/chems/spray/extinguisher/proc/propel_object(var/obj/O, mob/user, movementdirection)
	if(O.anchored || !(O.movable_flags & MOVABLE_FLAG_WHEELED))
		return

	var/obj/structure/bed/chair/C = istype(O, /obj/structure/bed/chair)? O : null
	//#TODO: That could definitely be improved. Would suggest to use process_momentum but its only for thrownthing
	var/list/move_speed = list(1, 1, 1, 2, 2, 3)
	for(var/i in 1 to 6)
		if(C)
			C.propelled = (6-i)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(move_speed[i])

	//additional movement
	for(var/i in 1 to 3)
		O.Move(get_step(user,movementdirection), movementdirection)
		sleep(3)

/obj/item/chems/spray/extinguisher/toggle_safety()
	. = ..()
	update_icon()
	update_held_icon()

/obj/item/chems/spray/extinguisher/get_alt_interactions(mob/user)
	. = ..()
	LAZYREMOVE(., /decl/interaction_handler/set_transfer/chems)

//Template types
/obj/item/chems/spray/extinguisher/empty/populate_reagents()
	return

/obj/item/chems/spray/extinguisher/mini/empty/populate_reagents()
	return