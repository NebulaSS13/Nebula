/obj/item/organ/internal/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon_state = "cell"
	dead_icon = "cell_bork"
	organ_tag = BP_CELL
	parent_organ = BP_CHEST
	var/open
	var/obj/item/cell/cell = /obj/item/cell/hyper
	//at 0.8 completely depleted after 60ish minutes of constant walking or 130 minutes of standing still
	var/servo_cost = 0.8

/obj/item/organ/internal/cell/Initialize()
	if(ispath(cell))
		cell = new cell(src)
	. = ..()

/obj/item/organ/internal/cell/proc/percent()
	if(!cell)
		return 0
	return get_charge()/cell.maxcharge * 100

/obj/item/organ/internal/cell/proc/get_charge()
	if(!cell)
		return 0
	if(status & ORGAN_DEAD)
		return 0
	return round(cell.charge*(1 - damage/max_damage))

/obj/item/organ/internal/cell/proc/checked_use(var/amount)
	if(!is_usable())
		return FALSE
	return cell && cell.checked_use(amount)

/obj/item/organ/internal/cell/proc/use(var/amount)
	if(!is_usable())
		return 0
	return cell && cell.use(amount)

/obj/item/organ/internal/cell/proc/get_power_drain()
	var/damage_factor = 1 + 10 * damage/max_damage
	return servo_cost * damage_factor

/obj/item/organ/internal/cell/Process()
	..()
	if(!owner)
		return
	if(owner.stat == DEAD)	//not a drain anymore
		return
	var/cost = get_power_drain()
	if(world.time - owner.l_move_time < 15)
		cost *= 2
	if(!checked_use(cost) && owner.isSynthetic())
		if(!owner.current_posture.prone && !owner.buckled)
			to_chat(owner, SPAN_WARNING("You don't have enough energy to function!"))
		SET_STATUS_MAX(owner, STAT_PARA, 3)

/obj/item/organ/internal/cell/emp_act(severity)
	..()
	if(cell)
		cell.emp_act(severity)

/obj/item/organ/internal/cell/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W))
		if(open)
			open = 0
			to_chat(user, SPAN_NOTICE("You screw the battery panel in place."))
		else
			open = 1
			to_chat(user, SPAN_NOTICE("You unscrew the battery panel."))

	if(IS_CROWBAR(W))
		if(open)
			if(cell)
				user.put_in_hands(cell)
				to_chat(user, SPAN_NOTICE("You remove \the [cell] from \the [src]."))
				cell = null

	if (istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, SPAN_WARNING("There is a power cell already installed."))
			else if(user.try_unequip(W, src))
				cell = W
				to_chat(user, SPAN_NOTICE("You insert \the [cell]."))

/obj/item/organ/internal/cell/on_add_effects()
	. = ..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.set_stat(CONSCIOUS)
		owner.visible_message(SPAN_NOTICE("\The [owner] twitches visibly!"))

/obj/item/organ/internal/cell/listen()
	if(get_charge())
		return "faint hum of the power bank"
