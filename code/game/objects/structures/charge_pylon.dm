/obj/structure/charge_pylon
	name = "electron reservoir"
	desc = "A tall, crystalline pylon that pulses with electricity."
	icon = 'icons/obj/structures/charge_pylon.dmi'
	icon_state = "pedestal"
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	var/next_use

/obj/structure/charge_pylon/attack_ai(var/mob/user)
	return attack_hand_with_interaction_checks(user) || ..()

/obj/structure/charge_pylon/attack_hand(var/mob/user)
	SHOULD_CALL_PARENT(FALSE)
	charge_user(user)
	return TRUE

/obj/structure/charge_pylon/proc/charge_user(var/mob/living/user)
	if(next_use > world.time) return
	next_use = world.time + 10
	var/mob/living/carbon/human/H = user
	var/obj/item/cell/power_cell
	if(ishuman(user))
		var/obj/item/organ/internal/cell/cell = H.get_organ(BP_CELL, /obj/item/organ/internal/cell)
		if(cell && cell.cell)
			power_cell = cell.cell
	else if(isrobot(user))
		var/mob/living/silicon/robot/robot = user
		power_cell = robot.get_cell()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message(SPAN_WARNING("There is a loud crack and the smell of ozone as \the [user] touches \the [src]."))
	playsound(loc, 'sound/effects/snap.ogg', 50, 1)
	if(power_cell)
		power_cell.charge = power_cell.maxcharge
		to_chat(user, "<span class='notice'><b>Your [power_cell] has been charged to capacity.</b></span>")
	else if(isrobot(user))
		user.apply_damage(150, BURN, def_zone = BP_CHEST)
		visible_message("<span class='danger'>Electricity arcs off [user] as it touches \the [src]!</span>")
		to_chat(user, "<span class='danger'><b>You detect damage to your components!</b></span>")
		user.throw_at(get_step(user,get_dir(src,user)), 5, 10)
	else
		user.electrocute_act(100, src, def_zone = BP_CHEST)
		visible_message("<span class='danger'>\The [user] has been shocked by \the [src]!</span>")
		user.throw_at(get_step(user,get_dir(src,user)), 5, 10)

/obj/structure/charge_pylon/attackby(var/obj/item/grab/G, mob/user)
	if(!istype(G))
		return
	var/mob/M = G.get_affecting_mob()
	if(M)
		charge_user(M)

/obj/structure/charge_pylon/Bumped(atom/AM)
	if(ishuman(AM))
		charge_user(AM)

/obj/structure/charge_pylon/hitby(atom/AM)
	..()
	if(ishuman(AM))
		charge_user(AM)
