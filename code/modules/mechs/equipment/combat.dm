/obj/item/mech_equipment/mounted_system/taser
	name = "mounted electrolaser carbine"
	desc = "A dual fire mode electrolaser system connected to the exosuit's targetting system."
	icon_state = "mech_taser"
	origin_tech = @'{"combat":1,"magnets":1,"engineering":1}'
	holding = /obj/item/gun/energy/taser/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)

/obj/item/mech_equipment/mounted_system/taser/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mech_ionrifle"
	holding = /obj/item/gun/energy/ionrifle/mounted/mech
	origin_tech = @'{"combat":2,"powerstorage":2,"magnets":4,"engineering":2}'

/obj/item/mech_equipment/mounted_system/taser/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mech_lasercarbine"
	holding = /obj/item/gun/energy/laser/mounted/mech
	origin_tech = @'{"combat":3,"magnets":2,"engineering":2}'

/obj/item/gun/energy/taser/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE
	projectile_type = /obj/item/projectile/beam/stun/heavy

/obj/item/gun/energy/ionrifle/mounted/mech
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/gun/energy/laser/mounted/mech
	name = "\improper CH-PS \"Immolator\" laser"
	use_external_power = TRUE
	has_safety = FALSE
	self_recharge = TRUE

/obj/item/gun/energy/get_hardpoint_maptext()
	var/obj/item/cell/power_supply = get_cell()
	if(!power_supply)
		return 0
	return "[round(power_supply.charge / charge_cost)]/[max_shots]"

/obj/item/gun/energy/get_hardpoint_status_value()
	var/obj/item/cell/cell = get_cell()
	if(istype(cell))
		return cell.charge/cell.maxcharge
	return null

/obj/item/mech_equipment/shields
	name = "exosuit shield droid"
	desc = "The Armature system is a well-liked energy deflector designed to stop any projectile before it has a chance to become a threat."
	icon_state = "shield_droid"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	material = /decl/material/solid/metal/steel
	origin_tech = @'{"magnets":3,"powerstorage":4,"materials":2,"engineering":2}'
	matter = list(
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE
	)
	var/max_charge = 150
	var/charge = 150
	var/last_recharge = 0
	var/charging_rate = 7500 * CELLRATE
	var/cooldown = 3.5 SECONDS //Time until we can recharge again after a blocked impact

/obj/item/mech_equipment/shields/installed(var/mob/living/exosuit/_owner)
	. = ..()
	if(owner)
		owner.add_mob_modifier(/decl/mob_modifier/mechshield, source = src)

/obj/item/mech_equipment/shields/uninstalled()
	if(owner)
		owner.remove_mob_modifier(/decl/mob_modifier/mechshield, source = src)
	. = ..()

/obj/item/mech_equipment/shields/attack_self(var/mob/user)
	. = ..()
	if(.)
		toggle()

/obj/item/mech_equipment/shields/proc/stop_damage(var/damage)
	var/difference = damage - charge
	charge = clamp(charge - damage, 0, max_charge)

	last_recharge = world.time

	if(difference > 0)
		for(var/mob/pilot in owner.pilots)
			to_chat(pilot, SPAN_DANGER("Warning: Deflector shield failure detected, shutting down!"))
		toggle()
		playsound(owner.loc,'sound/mecha/internaldmgalarm.ogg',35,1)
		return difference
	else return 0

/obj/item/mech_equipment/shields/proc/toggle()

	if(owner?.has_mob_modifier(/decl/mob_modifier/mechshield, source = src))
		owner.remove_mob_modifier(/decl/mob_modifier/mechshield, source = src)
	else if(owner)
		owner.add_mob_modifier(/decl/mob_modifier/mechshield, source = src)

	active = owner?.has_mob_modifier(/decl/mob_modifier/mechshield, source = src)

	playsound(owner,'sound/weapons/flash.ogg',35,1)
	update_icon()
	if(active)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	passive_power_use = active ? 1 KILOWATTS : 0
	owner.update_icon()

/obj/item/mech_equipment/shields/deactivate()
	if(active)
		toggle()
	..()

/obj/item/mech_equipment/shields/on_update_icon()
	. = ..()
	if(owner?.has_mob_modifier(/decl/mob_modifier/mechshield, source = src))
		icon_state = "shield_droid_a"
	else
		icon_state = "shield_droid"

/obj/item/mech_equipment/shields/Process()
	if(charge >= max_charge)
		return
	if((world.time - last_recharge) < cooldown)
		return
	var/obj/item/cell/cell = owner.get_cell()

	var/actual_required_power = clamp(max_charge - charge, 0, charging_rate)

	if(cell)
		charge += cell.use(actual_required_power)

/obj/item/mech_equipment/shields/get_hardpoint_status_value()
	return charge / max_charge

/obj/item/mech_equipment/shields/get_hardpoint_maptext()
	return "[owner?.has_mob_modifier(/decl/mob_modifier/mechshield, source = src) ? "ONLINE" : "OFFLINE"]: [round((charge / max_charge) * 100)]%"

//Melee! As a general rule I would recommend using regular objects and putting logic in them.
/obj/item/mech_equipment/mounted_system/melee
	abstract_type = /obj/item/mech_equipment/mounted_system/melee
	origin_tech = @'{"combat":1,"materials":1,"engineering":1}'
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/tool/machete/mech
	name = "mechete"
	desc = "That thing is too big to be called a machete. Too big, too thick, too heavy, and too rough, it is more like a large hunk of iron."
	w_class = ITEM_SIZE_GARGANTUAN
	slot_flags = 0
	base_parry_chance = 0 //Irrelevant for exosuits, revise if this changes
	max_health = ITEM_HEALTH_NO_DAMAGE //Else we need a whole system for replacement blades
	_base_attack_force = 25

/obj/item/tool/machete/mech/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	. = ..()
	if (.)
		do_attack_effect(target, "smash")
		if (target.mob_size < user.mob_size) //Damaging attacks overwhelm smaller mobs
			target.throw_at(get_edge_target_turf(target,get_dir(user, target)),1, 1)

/obj/item/tool/machete/mech/resolve_attackby(atom/A, mob/user, click_params)
	//Case 1: Default, you are hitting something that isn't a mob. Just do whatever, this isn't dangerous or op.
	if (!isliving(A))
		return ..()

	if (user.check_intent(I_FLAG_HARM))
		user.visible_message(SPAN_DANGER("\The [user] swings \the [src] at \the [A]!"))
		playsound(user, 'sound/mecha/mechmove03.ogg', 35, 1)
		return ..()

/obj/item/tool/machete/mech/attack_self(mob/living/user)
	. = ..()
	if (!user.check_intent(I_FLAG_HARM))
		return
	var/obj/item/mech_equipment/mounted_system/melee/machete/MC = loc
	if (istype(MC))
		//SPIN BLADE ATTACK GO!
		var/mob/living/exosuit/E = MC.owner
		if (E)
			E.setClickCooldown(1.35 SECONDS)
			E.visible_message(SPAN_DANGER("\The [E] swings \the [src] back, preparing for an attack!"), blind_message = SPAN_DANGER("You hear the loud hissing of hydraulics!"))
			playsound(E, 'sound/mecha/mechmove03.ogg', 35, 1)
			if (do_after(E, 1.2 SECONDS, get_turf(user)) && E && MC)
				for (var/mob/living/M in orange(1, E))
					use_on_mob(M, E, animate = FALSE)
				E.spin(0.65 SECONDS, 0.125 SECONDS)
				playsound(E, 'sound/mecha/mechturn.ogg', 40, 1)

/obj/item/mech_equipment/mounted_system/melee/machete
	icon_state = "mech_blade"
	holding = /obj/item/tool/machete/mech


//Ballistic shield
/obj/item/mech_equipment/ballistic_shield
	name = "exosuit ballistic shield"
	desc = "This formidable line of defense, sees widespread use in planetary peacekeeping operations and military formations alike."
	icon_state = "mech_shield"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = @'{"materials":2,"engineering":2}'
	var/last_push = 0
	var/chance = 60 //For attacks from the front, diminishing returns
	var/last_max_block = 0 //Blocking during a perfect block window resets this, else there is an anti spam
	var/max_block = 60 // Should block most things
	var/blocking = FALSE

/obj/item/mech_equipment/ballistic_shield/installed(mob/living/exosuit/_owner)
	. = ..()
	owner?.add_mob_modifier(/decl/mob_modifier/mech_ballistic, source = src)

/obj/item/mech_equipment/ballistic_shield/uninstalled()
	owner?.remove_mob_modifier(/decl/mob_modifier/mech_ballistic, source = src)
	. = ..()

/obj/item/mech_equipment/ballistic_shield/afterattack(atom/target, mob/living/user, inrange, params)
	. = ..()
	if (. && user.check_intent(I_FLAG_HARM) && (last_push + 1.6 SECONDS < world.time))
		owner.visible_message(SPAN_WARNING("\The [owner] retracts \the [src], preparing to push with it!"), blind_message = SPAN_WARNING("You hear the whine of hydraulics and feel a rush of air!"))
		owner.setClickCooldown(0.7 SECONDS)
		last_push = world.time
		if (do_after(owner, 0.5 SECONDS, get_turf(owner)) && owner)
			owner.visible_message(SPAN_WARNING("\The [owner] slams the area in front \the [src]!"), blind_message = SPAN_WARNING("You hear a loud hiss and feel a strong gust of wind!"))
			playsound(src ,'sound/effects/bang.ogg',35,1)
			var/list/turfs = list()
			var/front = get_step(get_turf(owner), owner.dir)
			turfs += front
			turfs += get_step(front, turn(owner.dir, -90))
			turfs += get_step(front, turn(owner.dir,  90))
			for(var/turf/T in turfs)
				for(var/mob/living/M in T)
					if (!M.Adjacent(owner))
						continue
					M.attack_generic(owner, (owner.arms ? owner.arms.melee_damage * 1.2 : 0), "slammed")
					M.throw_at(get_edge_target_turf(owner ,owner.dir),5, 2)
				do_attack_effect(T, "smash")

/obj/item/mech_equipment/ballistic_shield/attack_self(mob/user)
	. = ..()
	if (.) //FORM A SHIELD WALL!
		if (last_max_block + 2 SECONDS < world.time)
			owner.visible_message(SPAN_WARNING("\The [owner] raises \the [src], locking it in place!"), blind_message = SPAN_WARNING("You hear the whir of motors and scratching metal!"))
			playsound(src ,'sound/effects/bamf.ogg',35,1)
			owner.setClickCooldown(0.8 SECONDS)
			blocking = TRUE
			last_max_block = world.time
			do_after(owner, 0.75 SECONDS, get_turf(user))
			blocking = FALSE
		else
			to_chat(user, SPAN_WARNING("You are not ready to block again!"))

/obj/item/mech_equipment/ballistic_shield/proc/block_chance(damage, pen, atom/source, mob/attacker)
	if (damage > max_block || pen > max_block)
		return 0

	var/effective_block = blocking ? chance * 1.5 : chance

	var/conscious_pilot_exists = FALSE
	for (var/mob/living/pilot in owner.pilots)
		if (!pilot.incapacitated())
			conscious_pilot_exists = TRUE
			break

	if (!conscious_pilot_exists)
		effective_block *= 0.5 //Who is going to block anything?

	//Bit copypasta but I am doing something different from normal shields
	var/attack_dir = 0
	if (istype(source, /obj/item/projectile))
		var/obj/item/projectile/P = source
		attack_dir = get_dir(get_turf(src), P.starting)
	else if (attacker)
		attack_dir = get_dir(get_turf(src), get_turf(attacker))
	else if (source)
		attack_dir = get_dir(get_turf(src), get_turf(source))

	if (attack_dir == turn(owner.dir, -90) || attack_dir == turn(owner.dir, 90))
		effective_block *= 0.8
	else if (attack_dir == turn(owner.dir, 180))
		effective_block = 0

	return effective_block

/obj/item/mech_equipment/ballistic_shield/proc/on_block_attack()
	if (blocking)
		//Reset timer for maximum chainblocks
		last_max_block = 0

/obj/item/mech_equipment/flash
	name = "exosuit flash"
	icon_state = "mech_flash"
	var/flash_min = 7
	var/flash_max = 9
	var/flash_range = 3
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	active_power_use = 7 KILOWATTS
	var/next_use = 0
	origin_tech = @'{"magnets":2,"combat":3}'

/obj/item/mech_equipment/flash/proc/area_flash()
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	var/flash_time = (rand(flash_min,flash_max) - 1)

	var/obj/item/cell/cell = owner.get_cell()
	cell.use(active_power_use * CELLRATE)

	for (var/mob/living/O in oviewers(flash_range, owner))
		if(istype(O))
			O.handle_flashed(flash_time, do_stun = FALSE)

/obj/item/mech_equipment/flash/attack_self(mob/user)
	. = ..()
	if(.)
		if(world.time < next_use)
			to_chat(user, SPAN_WARNING("\The [src] is recharging!"))
			return
		next_use = world.time + 20
		area_flash()
		owner.setClickCooldown(5)

/obj/item/mech_equipment/flash/afterattack(atom/target, mob/living/user, inrange, params)
	. = ..()
	if(.)
		if(world.time < next_use)
			to_chat(user, SPAN_WARNING("\The [src] is recharging!"))
			return
		var/mob/living/O = target
		owner.setClickCooldown(5)
		next_use = world.time + 15

		if(istype(O))

			playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
			var/flash_time = (rand(flash_min,flash_max))

			var/obj/item/cell/cell = owner.get_cell()
			cell.use(active_power_use * CELLRATE)

			O.handle_flashed(flash_time)
