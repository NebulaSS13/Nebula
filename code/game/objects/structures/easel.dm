/obj/structure/easel
	name = "easel"
	desc = "Only for the finest of art!"
	icon = 'icons/obj/structures/easel.dmi'
	icon_state = "easel"
	density = TRUE
	var/obj/item/canvas/painting = null

/obj/structure/easel/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	events_repository.register(/decl/observ/moved, src, src, /obj/structure/easel/proc/move_painting)

/obj/structure/easel/Destroy()
	painting = null
	events_repository.unregister(/decl/observ/moved, src, src, /obj/structure/easel/proc/move_painting)
	return ..()

/** 
 * Adding canvases.
 */
/obj/structure/easel/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/canvas))
		var/obj/item/canvas/C = I
		if(user.unEquip(C))
			painting = C
			C.forceMove(get_turf(src))
			C.layer = layer + 0.1
			C.pixel_x = 0
			C.pixel_y = 0
			C.pixel_z = 0
			user.visible_message(
				SPAN_NOTICE("\The [user] puts \the [C] on \the [src]."),
				SPAN_NOTICE("You place \the [C] on \the [src]."))
		return
	else 
		return ..()

/** 
 * Stick to the easel like glue.
 */
/obj/structure/easel/proc/move_painting()
	if(painting && Adjacent(painting)) // Only move if it's near us.
		painting.forceMove(get_turf(src))
	else
		painting = null
