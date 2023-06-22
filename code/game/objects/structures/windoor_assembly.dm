/* Windoor (window door) assembly -Nodrak
 * Step 1: Create a windoor out of rglass
 * Step 2: Add r-glass to the assembly to make a secure windoor (Optional)
 * Step 3: Rotate or Flip the assembly to face and open the way you want
 * Step 4: Wrench the assembly in place
 * Step 5: Add cables to the assembly
 * Step 6: Set access for the door.
 * Step 7: Crowbar the door to complete
 */

/obj/structure/windoor_assembly
	name = "windoor assembly"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "l_windoor_assembly01"
	anchored = 0
	density = 0
	dir = NORTH
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/glass
	tool_interaction_flags = TOOL_INTERACTION_ALL

	var/obj/item/stock_parts/circuitboard/airlock_electronics/windoor/electronics = null

	//Vars to help with the icon's name
	var/facing_left           //Does the windoor open to the left?
	var/secure                //Whether or not this creates a secure windoor

/obj/structure/windoor_assembly/Initialize()
	. = ..()
	update_nearby_tiles(need_rebuild=1)

/obj/structure/windoor_assembly/Destroy()
	set_density(0)
	update_nearby_tiles()
	return ..()

/obj/structure/windoor_assembly/on_update_icon()
	..()
	icon_state = "[facing_left ? "l" : "r"]_[secure ? "_secure" : ""]windoor_assembly[anchored && wired ? "02" : "01"]"

/obj/structure/windoor_assembly/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group) return 0
		return !density
	else
		return 1

/obj/structure/windoor_assembly/CheckExit(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/structure/windoor_assembly/can_unanchor(var/mob/user)
	if(electronics)
		to_chat(user, SPAN_WARNING("You will need to dismantle more of \the [src] before you can [anchored ? "unsecure it from" : "secure it to"] the floor."))
		return FALSE
	. = ..()

/obj/structure/windoor_assembly/can_dismantle(var/mob/user)
	if(electronics)
		to_chat(user, SPAN_WARNING("You will need to dismantle more of \the [src] before you can take it apart completely."))
		return FALSE
	. = ..()

/obj/structure/windoor_assembly/proc/update_name()
	. = initial(name)
	if(electronics)
		. = "nearly complete [.]"
	else
		if(wired)
			. = "wired [.]"
		if(anchored)
			. = "anchored [.]"
		if(secure)
			. = "secure [.]"
	if(name != .)
		SetName(.)

/obj/structure/windoor_assembly/handle_default_crowbar_attackby(var/mob/user, var/obj/item/crowbar)
	if(anchored && wired)
		if(!electronics)
			to_chat(user, SPAN_WARNING("\The [src] has no electronics installed."))
			return TRUE
		close_browser(user, "window=windoor_access")
		playsound(loc, 'sound/items/Crowbar.ogg', 100, 1)
		visible_message(SPAN_NOTICE("\The [user] begins prying the windoor into its frame with \the [crowbar]."))
		if(do_after(user, 4 SECONDS, src))
			var/obj/machinery/door/window/windoor
			if(secure)
				windoor = new /obj/machinery/door/window/brigdoor(loc, dir, FALSE, src)
				windoor.base_state = "[facing_left ? "left" : "right"]secure"
			else
				windoor = new (loc, dir, FALSE, src)
				windoor.base_state = facing_left ? "left" : "right"
			windoor.icon_state = "[windoor.base_state]open"
			visible_message(SPAN_NOTICE("\The [user] finishes \the [windoor]!"))
			windoor.construct_state.post_construct(windoor)
			qdel(src)
		return TRUE
	. = ..()

/obj/structure/windoor_assembly/handle_default_screwdriver_attackby(var/mob/user, var/obj/item/screwdriver)
	if(anchored && wired && electronics)
		playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
		visible_message(SPAN_NOTICE("\The [user] begins removing \the [electronics] from \the [src] with \the [screwdriver]."))
		if(do_after(user, 4 SECONDS, src) && !QDELETED(src) && anchored && wired && electronics)
			visible_message(SPAN_NOTICE("\The [user] finishes removing \the [electronics] from \the [src] with \the [screwdriver]."))
			electronics.dropInto(loc)
			electronics = null
		return TRUE
	return FALSE

/obj/structure/windoor_assembly/attackby(obj/item/W, mob/user)
	. = ..()
	if(!. && anchored)
		if(!secure && istype(W, /obj/item/stack/material/rods))
			var/obj/item/stack/material/rods/R = W
			if(R.get_amount() < 4)
				to_chat(user, SPAN_WARNING("You need more rods to do this."))
				return TRUE
			visible_message(SPAN_NOTICE("\The [user] begins reinforcing \the [src] with \the [R]."))
			if(do_after(user,4 SECONDS, src) && !secure && !QDELETED(src) && anchored && R.use(4))
				visible_message(SPAN_NOTICE("\The [user] finishes reinforcing \the [src]."))
				secure = TRUE
			. = TRUE
		else if(wired && !electronics && istype(W, /obj/item/stock_parts/circuitboard/airlock_electronics/windoor))
			playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
			visible_message(SPAN_NOTICE("\The [user] starts installing \the [W] into \the [src]."))
			if(do_after(user, 4 SECONDS, src) && wired && !electronics && anchored && !QDELETED(src) && user.try_unequip(W, src))
				visible_message(SPAN_NOTICE("\The [user] finishes installing \the [W] into \the [src]."))
				electronics = W
			else
				W.dropInto(loc)
			. = TRUE
	update_icon()
	update_name()

//Rotates the windoor assembly clockwise
/obj/structure/windoor_assembly/verb/revrotate()
	set name = "Rotate Windoor Assembly"
	set category = "Object"
	set src in oview(1)
	if(anchored)
		to_chat(usr, "It is fastened to the floor; therefore, you can't rotate it!")
		return 0
	set_dir(turn(dir, 270))
	update_nearby_tiles(need_rebuild=1)
	update_icon()

//Flips the windoor assembly, determines whather the door opens to the left or the right
/obj/structure/windoor_assembly/verb/flip()
	set name = "Flip Windoor Assembly"
	set category = "Object"
	set src in oview(1)

	facing_left = !facing_left
	if(!facing_left)
		to_chat(usr, "The windoor will now slide to the right.")
	else
		to_chat(usr, "The windoor will now slide to the left.")
	update_icon()
