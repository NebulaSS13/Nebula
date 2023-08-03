/obj/item/inducer
	name = "inducer"
	desc = "A tool for inductively charging internal power cells."
	icon = 'icons/obj/items/device/inducer.dmi'
	icon_state = "inducer-sci"
	item_state = "inducer-sci"
	force = 7
	origin_tech = "{'powerstorage':6,'engineering':4}"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	slot_flags = SLOT_LOWER_BODY

	var/powertransfer = 500
	var/coefficient = 0.9
	var/failsafe = 0
	cell = /obj/item/cell/high
	cell_allowed = /obj/item/cell
	cell_cover = TRUE
	var/recharging = FALSE

/obj/item/inducer/proc/induce(obj/item/cell/target)
	var/obj/item/cell/MyC = get_cell()
	var/missing = target.maxcharge - target.charge
	var/totransfer = min(min(MyC.charge,powertransfer), missing)
	target.give(totransfer*coefficient)
	MyC.use(totransfer)
	MyC.update_icon()
	target.update_icon()

/obj/item/inducer/get_cell()
	return cell

/obj/item/inducer/afterattack(obj/O, mob/living/carbon/user, var/proximity)
	if (!proximity || user.a_intent == I_HURT || CannotUse(user) || !recharge(O, user))
		return ..()

/obj/item/inducer/proc/CannotUse(mob/user)
	var/obj/item/cell/my_cell = get_cell()
	if(!istype(my_cell))
		to_chat(user, "<span class='warning'>\The [src] doesn't have a power cell installed!</span>")
		return TRUE
	if(my_cell.percent() <= 0)
		to_chat(user, "<span class='warning'>\The [src]'s battery is dead!</span>")
		return TRUE
	return FALSE

/obj/item/inducer/proc/recharge(atom/A, mob/user)
	if(!isturf(A) && user.loc == A)
		return FALSE
	if(recharging)
		return TRUE
	else
		recharging = TRUE
	var/obj/item/cell/MyC = get_cell()
	var/obj/item/cell/C = A.get_cell()
	var/obj/O
	if(istype(A, /obj))
		O = A
	if(C)
		var/charge_length = 10
		var/done_any = FALSE
		spark_at(user, amount = 1, cardinal_only = TRUE)
		if(C.charge >= C.maxcharge)
			to_chat(user, "<span class='notice'>\The [A] is fully charged!</span>")
			recharging = FALSE
			return TRUE
		user.visible_message("\The [user] starts recharging \the [A] with \the [src].","<span class='notice'>You start recharging \the [A] with \the [src].</span>")
		if (istype(A, /obj/item/gun/energy))
			charge_length = 30
			if (user.get_skill_value(SKILL_WEAPONS) <= SKILL_ADEPT)
				charge_length += rand(10, 30)
		if (user.get_skill_value(SKILL_ELECTRICAL) < SKILL_ADEPT)
			charge_length += rand(40, 60)
		while(C.charge < C.maxcharge)
			if(MyC.charge > max(0, MyC.charge*failsafe) && do_after(user, charge_length, target = user))
				if(CannotUse(user))
					return TRUE
				if(QDELETED(C))
					return TRUE
				spark_at(user, amount = 1, cardinal_only = TRUE)
				done_any = TRUE
				induce(C)
				if(O)
					O.update_icon()
			else
				break
		if(done_any) // Only show a message if we succeeded at least once
			user.visible_message("\The [user] recharged \the [A]!","<span class='notice'>You recharged \the [A]!</span>")
		recharging = FALSE
		return TRUE
	else
		to_chat(user, "<span class='warning'>No cell detected!</span>")
	recharging = FALSE

// used only on the borg one, but here in case we invent inducer guns idk
/obj/item/inducer/proc/safety()
	if (failsafe)
		return 1
	else
		return 0

/obj/item/inducer/attack(mob/M, mob/user)
	return

/obj/item/inducer/attack_self(mob/user)
	if(cell_cover && cell)
		remove_cell(user)

/obj/item/inducer/on_update_icon()
	. = ..()
	if(cell_cover)
		add_overlay("inducer-[get_cell()? "bat" : "nobat"]")

// module version

/obj/item/inducer/borg
	icon_state = "inducer-engi"
	item_state = "inducer-engi"
	failsafe = 0.2
	cell = null

/obj/item/inducer/borg/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W))
		return
	. = ..()

/obj/item/inducer/borg/on_update_icon()
	. = ..()
	add_overlay(overlay_image("icons/obj/guns/gui.dmi", "safety[safety()]"))

/obj/item/inducer/borg/verb/toggle_safety(var/mob/user)
	set src in usr
	set category = "Object"
	set name = "Toggle Inducer Safety"
	if (safety())
		failsafe = 0
	else
		failsafe = 0.2
	update_icon()
	if(user)
		to_chat(user, "<span class='notice'>You switch your battery output failsafe [safety() ? "on" : "off"	].</span>")

/obj/item/inducer/borg/get_cell()
	return loc ? loc.get_cell() : null