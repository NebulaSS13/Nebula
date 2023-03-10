/obj
	layer = OBJ_LAYER
	animate_movement = 2
	is_spawnable_type = TRUE
	abstract_type = /obj

	///Properties of this object.
	var/obj_flags = 0
	///Required access to interact with this object.
	var/list/req_access
	///Used to store information about the contents of the object.
	var/list/matter
	/// Size of the object.
	var/w_class
	///Damage dealt when this object is thrown and hits something
	var/throwforce = 1
	///Whether this object cuts
	var/sharp = FALSE
	///Whether this object is more likely to dismember
	var/edge = FALSE
	///If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/in_use = FALSE
	///Damage type getting hit by this object will cause.
	var/damtype = BRUTE
	///Amount of armor resistance this obj will bypass if it inflicts damage to something with armor.
	var/armor_penetration = 0
	///Prevents the object from falling to the lower z-level if it ends up in open space
	var/anchor_fall = FALSE
	///if the obj is a holographic object spawned by the holodeck
	var/holographic = FALSE
	///JSON list of directions to x,y offsets to be applied to the object depending on its direction EX: {'NORTH':{'x':12,'y':5}, 'EAST':{'x':10,'y':50}}
	var/tmp/directional_offset

	///Only positive values.
	var/health
	///Only positive values. Use OBJ_HEALTH_NO_DAMAGE to make the object invulnerable.
	var/max_health
	/// Reference to material decl. If set to a string corresponding to a material ID, will init the item with that material.
	var/decl/material/material
	///Will apply the flagged modifications to the object
	var/material_alteration = MAT_FLAG_ALTERATION_NONE
	/// if set, obj will use material's armor values multiplied by this.
	var/material_armor_multiplier
	///Type of armor to use for this object
	var/armor_type = /datum/extension/armor
	///list of all the defensive damage types to the amount of resistance it provides.
	var/list/armor
	///How fast armor will degrade, multiplier to blocked damage to get armor damage value.
	var/armor_degradation_speed
	///Sound to make when hit
	var/hitsound = 'sound/weapons/smash.ogg'
	///Sound to make when destroyed through brute damage
	var/sound_break = 'sound/effects/metal_smash1.ogg'

/obj/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/proc/get_matter_amount_modifier()
	. = CEILING(w_class * BASE_OBJECT_MATTER_MULTPLIER)

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src) | usr
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				if(CanUseTopic(M, DefaultTopicState()) > STATUS_CLOSE)
					is_in_use = 1
					interact(M)
				else
					M.unset_machine()
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				if(CanUseTopic(M, DefaultTopicState()) > STATUS_CLOSE)
					is_in_use = 1
					interact(M)
				else
					M.unset_machine()
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	ui_interact(user)
	..()

/obj/proc/interact(mob/user)
	return

/obj/proc/hide(var/hide)
	set_invisibility(hide ? INVISIBILITY_MAXIMUM : initial(invisibility))

/obj/proc/hides_under_flooring()
	return level == 1

/obj/proc/hear_talk(mob/M, text, verb, decl/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return

/obj/proc/see_emote(mob/M, text, var/emote_type)
	return

/obj/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/obj/attackby(obj/item/O, mob/user)
	if(obj_flags & OBJ_FLAG_ANCHORABLE)
		if(IS_WRENCH(O))
			wrench_floor_bolts(user)
			update_icon()
			return
	return ..()

/obj/proc/wrench_floor_bolts(mob/user, delay=20)
	playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
	if(anchored)
		user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
	else
		user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
	if(do_after(user, delay, src))
		if(!src) return
		to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
		anchored = !anchored
	return 1

/obj/attack_hand(mob/user)
	if(Adjacent(user))
		add_fingerprint(user)
	..()

/obj/is_fluid_pushable(var/amt)
	return ..() && w_class <= round(amt/20)

/obj/proc/can_embed()
	return is_sharp(src)

/obj/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance < 3)
		var/damage_desc = get_examined_damage_string(health / max_health)
		if(length(damage_desc))
			to_chat(user, damage_desc)
	if((obj_flags & OBJ_FLAG_ROTATABLE))
		to_chat(user, SPAN_SUBTLE("\The [src] can be rotated with alt-click."))
	if((obj_flags & OBJ_FLAG_ANCHORABLE))
		to_chat(user, SPAN_SUBTLE("\The [src] can be anchored or unanchored with a wrench."))

/obj/proc/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	if(anchored)
		to_chat(user, SPAN_NOTICE("\The [src] is secured to the floor!"))
		return

	set_dir(turn(dir, 90))
	update_icon()

//For things to apply special effects after damaging an organ, called by organ's take_damage
/obj/proc/after_wounding(obj/item/organ/external/organ, datum/wound)
	return

/obj/can_be_injected_by(var/atom/injector)
	. = ATOM_IS_OPEN_CONTAINER(src) && ..()

/obj/get_mass()
	return min(2**(w_class-1), 100)

/obj/get_object_size()
	return w_class

/obj/get_mob()
	return buckled_mob

/obj/set_dir(ndir)
	. = ..()
	if(directional_offset)
		update_directional_offset()

/obj/Move()
	. = ..()
	if(directional_offset)
		update_directional_offset()

/obj/forceMove(atom/dest)
	. = ..()
	if(directional_offset)
		update_directional_offset()

/**
 * Applies the offset stored in the directional_offset json list depending on the current direction.
 * force will force the default offset to be 0 if there are no directional_offset string.
 */
/obj/proc/update_directional_offset(var/force = FALSE)
	if(!force && !length(directional_offset))
		return

	default_pixel_x = 0
	default_pixel_y = 0
	default_pixel_w = 0
	default_pixel_z = 0

	var/list/diroff = cached_json_decode(directional_offset)
	var/list/curoff = diroff["[uppertext(dir2text(dir))]"]
	if(length(curoff))
		default_pixel_x = curoff["x"] || 0
		default_pixel_y = curoff["y"] || 0
		default_pixel_w = curoff["w"] || 0
		default_pixel_z = curoff["z"] || 0
	reset_offsets(0)

/**
 * Returns whether the object should be considered as hanging off a wall.
 * This is userful because wall-mounted things are actually on the adjacent floor tile offset towards the wall.
 * Which means we have to deal with directional offsets differently. Such as with buttons mounted on a table, or on a wall.
 */
/obj/proc/is_wall_mounted()
	//If this flag is on, and we have an offset, we're most likely wall mounted
	if(obj_flags & OBJ_FLAG_MOVES_UNSUPPORTED || anchor_fall)
		var/turf/forward = get_step(get_turf(src), dir)
		var/turf/reverse = get_step(get_turf(src), global.reverse_dir[dir])
		//If we're wall mounted and don't have a wall either facing us, or in the opposite direction, don't apply the offset.
		// This is mainly for things that can be both wall mounted and floor mounted. Like buttons, which mappers seem to really like putting on tables.
		// Its sort of a hack for now. But objects don't handle being on a wall or not. (They don't change their flags, layer, etc when on a wall or anything)
		if(!forward?.is_wall() && !reverse?.is_wall())
			return
	return TRUE

/**
 * Init starting reagents and/or reagent var. Not called at the /obj level.
 * populate: If set to true, we expect map load/admin spawned reagents to be set.
 */
/obj/proc/initialize_reagents(var/populate = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	if(reagents?.total_volume > 0)
		log_warning("\The [src] possibly is initializing its reagents more than once!")
	if(populate)
		populate_reagents()

/**
 * Actually populates the reagents.
 * Can be easily nulled out or fully overriden without having to rewrite the complete reagent init logic.
 * An alternative to using a list for defining our starting reagents since apparently overriding the value of a list creates an (init) proc each time.
 * Also cuts down on A LOT of duplicate list instances for each item instances in the world.
 */
/obj/proc/populate_reagents()
	return

/**
 * Returns a list with the contents that may be spawned in this object.
 * This shouldn't include things that are necessary for the object to operate, like machine components.
 * Its mainly for populating storage and the like.
 */
/obj/proc/WillContain()
	return

////////////////////////////////////////////////////////////////
// Interactions
////////////////////////////////////////////////////////////////
/obj/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/rotate)

/decl/interaction_handler/rotate
	name = "Rotate"
	expected_target_type = /obj

/decl/interaction_handler/rotate/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(.)
		var/obj/O = target
		. = !!(O.obj_flags & OBJ_FLAG_ROTATABLE)

/decl/interaction_handler/rotate/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/O = target
	O.rotate(user)
