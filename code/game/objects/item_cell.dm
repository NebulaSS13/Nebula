//generalized item power system (mainly power cell insertion/ejection)
/obj/item
	var/obj/item/cell/cell = null //current cell
	var/obj/item/cell/cell_allowed = null //allowed cell type

	var/cell_cover = FALSE //true = need cover to change cell
	var/cell_indicator = TRUE
	var/cell_crowbar = FALSE //do you need a crowbar to remove the cell?
	var/power_usage //default power usage for power_check()

	var/cell_foreign = FALSE //disable cell insertion/ejection

/obj/item/get_cell()
	return cell

/obj/item/Destroy()
	. = ..()
	if(!ispath(cell))
		QDEL_NULL(cell)

/obj/item/Initialize()
	if(ispath(cell))
		cell = new cell(src)
	if(cell_allowed) //for items with unremovable cells
		verbs += /obj/item/proc/remove_cell
	if(cell_cover) cell_cover = FALSE
	. = ..()

/obj/item/proc/cell_cover_open()
	return initial(cell_cover) && cell_cover && cell_allowed || !initial(cell_cover)

//try to use amount/power_usage joules from cell
/obj/item/proc/power_check(var/mob/user,var/amount) //amount is in joules since its an item thus probably a small device
	. = TRUE
	if(!amount)
		amount = power_usage
	if(!amount) //no amount supplied, no power usage
		return TRUE
	if(!initial(cell) && !initial(cell_allowed)) //no starting cell and can't insert one
		return TRUE
	if(!get_cell()?.checked_use(amount * CELLRATE))
		if(user) to_chat(user,SPAN_WARNING("\The [src] doesn't have enough power."))
		return FALSE

/obj/item/examine(var/mob/user,var/distance)
	. = ..()
	if(distance >= 2)
		return
	if(cell_indicator && (initial(cell) || cell_allowed))
		if(cell)
			to_chat(user,"Its charge indicator reads: [round(cell.percent())]%")
		else
			to_chat(user,"Its charge indicator is dark.")
	if(cell_cover_open() && initial(cell_cover))
		to_chat(user,SPAN_NOTICE("Its battery compartment is open."))

//oh shit this egun code copypaste..
/obj/item/attackby(obj/item/W, mob/user)
	if(cell_foreign)
		return ..()
	if(IS_SCREWDRIVER(W) && initial(cell_cover))
		playsound(get_turf(src), 'sound/items/Screwdriver.ogg', 20, 1)
		cell_cover = !cell_cover
		to_chat(user, SPAN_NOTICE("You [cell_cover ? "open" : "close"] \the [src] battery compartment."))
		update_icon()
		return TRUE
	if(IS_CROWBAR(W) && cell_crowbar && cell_cover_open())
		remove_cell(user,TRUE)
	if(cell_allowed && istype(W,/obj/item/cell))
		if(!cell_cover_open())
			to_chat(user, SPAN_WARNING("\The [src]'s battery compartment is closed."))
			return TRUE
		else if(cell)
			to_chat(user, SPAN_NOTICE("\The [src] already has \a [cell] inside."))
			return TRUE
		else if(!istype(W, cell_allowed))
			var/obj/cell_dummy = cell_allowed
			to_chat(user, SPAN_WARNING("\The [src] can only accept \a [initial(cell_dummy.name)]."))
			return TRUE
		else if(user.try_unequip(W, target = src))
			to_chat(user, SPAN_NOTICE("You slot \the [W] into \the [src]."))
			cell = W
			update_icon()
			return FALSE
	. = ..()

/obj/item/emp_act(severity)
	. = ..()
	if(cell)
		cell.emp_act(severity)

/obj/item/proc/remove_cell(var/mob/user,var/crowbar)
	set category = "Object"
	set name = "Remove cell"
	set desc = "Remove cell from an item."

	if(crowbar && cell)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/items/Crowbar.ogg', 20, 1)
		cell.dropInto(T)
		cell = null
		to_chat(user, SPAN_NOTICE("You pry \the [cell] out of \the [src]."))
		update_icon()
		return

	if(!cell_cover_open())
		to_chat(user,SPAN_WARNING("\The [src]'s battery compartment is closed."))
		return
	if(!cell)
		to_chat(user,SPAN_WARNING("\The [src] has no cell inside."))
		return
	if(cell_crowbar)
		to_chat(user,SPAN_WARNING("You need a crowbar to take out \the [src]'s cell."))
		return
	user.put_in_hands(cell)
	to_chat(user, SPAN_NOTICE("You remove [cell] from \the [src]."))
	cell = null
	update_icon()

/obj/item/get_alt_interactions(var/mob/user)
	. = ..()
	if(cell_allowed)
		LAZYADD(., /decl/interaction_handler/item_remove_cell)

/decl/interaction_handler/item_remove_cell
	name = "Remove cell"
	icon = 'icons/screen/radial.dmi'
	icon_state = "cable_invalid"
	expected_target_type = /obj/item

/decl/interaction_handler/item_remove_cell/invoked(var/obj/item/target, var/mob/user)
	target.remove_cell(user)