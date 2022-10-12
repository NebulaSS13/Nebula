////////////////////////////////////////
// Base Flora
////////////////////////////////////////
/obj/structure/flora
	desc                   = "A form of vegetation."
	anchored               = TRUE
	density                = FALSE                                  //Plants usually have no collisions
	w_class                = ITEM_SIZE_NORMAL                       //Size determines material yield
	material               = /decl/material/solid/plantmatter       //Generic plantstuff
	tool_interaction_flags = 0
	hitsound               = 'sound/effects/hit_bush.ogg'
	var/tmp/snd_cut        = 'sound/effects/plants/brush_leaves.ogg' //Sound to play when cutting the plant down
	var/remains_type       = /obj/effect/decal/cleanable/plant_bits //What does the plant leaves behind in addition to the materials its made out of. (part_type is like this, but it drops instead of materials)

/obj/structure/flora/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	init_appearance()

/**Picks and sets the appearance exactly once for the plant if randomly picked. */
/obj/structure/flora/proc/init_appearance()
	return

/obj/structure/flora/attackby(obj/item/O, mob/user)
	if(can_cut_down(O, user))
		return cut_down(O, user)
	. = ..()

/**Whether the item used by user can cause cut_down to be called. Used to bypass default attack proc for some specific items/tools. */
/obj/structure/flora/proc/can_cut_down(var/obj/item/I, var/mob/user)
	return (I.force >= 5) && I.sharp //Anything sharp and relatively strong can cut us instantly

/**What to do when the can_cut_down check returns true. Normally simply calls dismantle. */
/obj/structure/flora/proc/cut_down(var/obj/item/I, var/mob/user)
	if(snd_cut)
		playsound(src, snd_cut, 40, TRUE)
	dismantle()
	return TRUE

//Drop some bits when destroyed
/obj/structure/flora/physically_destroyed(skip_qdel)
	if(!..(TRUE)) //Tell parents we'll delete ourselves
		return
	var/turf/T = get_turf(src)
	if(T)
		. = !isnull(create_remains())
		if(snd_cut)
			playsound(src, snd_cut, 60, TRUE)
	//qdel only after we do our thing, since we have to access members
	if(!skip_qdel)
		qdel(src)

/**Returns an instance of the object the plant leaves behind when destroyed. Null means it leaves nothing. */
/obj/structure/flora/proc/create_remains()
	return new remains_type(get_turf(src), material, reinf_material)

////////////////////////////////////////
// Floral Remains
////////////////////////////////////////
/obj/effect/decal/cleanable/plant_bits
	name            = "plant remains"
	icon            = 'icons/effects/decals/plant_remains.dmi'
	icon_state      = "leafy_bits"
	cleanable_scent = "freshly cut plants"
