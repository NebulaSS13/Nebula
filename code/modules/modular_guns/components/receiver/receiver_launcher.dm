/obj/item/firearm_component/receiver/launcher
	var/release_force = 0
	var/throw_distance = 10

/*
/obj/item/gun/launcher
	name = "launcher"
	desc = "A device that launches things."
	icon = 'icons/obj/guns/launcher/grenade.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	fire_sound_text = "a launcher firing"
	barrel = /obj/item/firearm_component/barrel/launcher
	receiver = /obj/item/firearm_component/receiver/launcher

//This normally uses a proc on projectiles and our ammo is not strictly speaking a projectile.
/obj/item/gun/can_hit(var/mob/living/target, var/mob/living/user)
	return 1

//Override this to avoid a runtime with suicide handling.
/obj/item/gun/handle_suicide(mob/living/user)
	to_chat(user, "<span class='warning'>Shooting yourself with \a [src] is pretty tricky. You can't seem to manage it.</span>")
	return

/obj/item/gun/proc/update_release_force(obj/item/projectile)
	return 0

/obj/item/gun/process_projectile(obj/item/projectile, mob/user, atom/target, var/target_zone, var/params=null, var/pointblank=0, var/reflex=0)
	update_release_force(projectile)
	projectile.dropInto(user.loc)
	projectile.throw_at(target, throw_distance, release_force, user)
	play_fire_sound(user,projectile)
	return 1
*/

/obj/item/firearm_component/receiver/launcher/crossbow
	has_safety = FALSE
	var/obj/item/bolt
	var/tension = 0                         // Current draw on the bow.
	var/max_tension = 3                     // Highest possible tension.
	var/release_speed = 10                  // Speed per unit of tension.
	var/obj/item/cell/cell = null    // Used for firing superheated rods.
	var/current_user                        // Used to check if the crossbow has changed hands since being drawn.
	var/draw_time = 20						// Time needed to draw the bow back by one "tension"

/*
/obj/item/gun/long/crossbow/update_release_force()
	release_force = tension*release_speed

/obj/item/gun/long/crossbow/consume_next_projectile(mob/user=null)
	if(tension <= 0)
		to_chat(user, "<span class='warning'>\The [src] is not drawn back!</span>")
		return null
	return bolt

/obj/item/gun/long/crossbow/handle_post_fire(mob/user, atom/target)
	bolt = null
	tension = 0
	update_icon()
	..()

/obj/item/gun/long/crossbow/proc/draw(var/mob/user)

	if(!bolt)
		to_chat(user, "You don't have anything nocked to [src].")
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("[user] begins to draw back the string of [src].","<span class='notice'>You begin to draw back the string of [src].</span>")
	tension = 1

	while(bolt && tension && loc == current_user)
		if(!do_after(user, draw_time, src)) //crossbow strings don't just magically pull back on their own.
			user.visible_message("[usr] stops drawing and relaxes the string of [src].","<span class='warning'>You stop drawing back and relax the string of [src].</span>")
			tension = 0
			update_icon()
			return

		//double check that the user hasn't removed the bolt in the meantime
		if(!(bolt && tension && loc == current_user))
			return

		tension++
		update_icon()

		if(tension >= max_tension)
			tension = max_tension
			to_chat(usr, "[src] clunks as you draw the string to its maximum tension!")
			return

		user.visible_message("[usr] draws back the string of [src]!","<span class='notice'>You continue drawing back the string of [src]!</span>")

/obj/item/gun/long/crossbow/proc/increase_tension(var/mob/user)

	if(!bolt || !tension || current_user != user) //Arrow has been fired, bow has been relaxed or user has changed.
		return

/obj/item/gun/long/crossbow/proc/superheat_rod(var/mob/user)
	if(!user || !cell || !bolt) return
	if(cell.charge < 500) return
	if(bolt.throwforce >= 15) return
	if(!istype(bolt,/obj/item/arrow/rod)) return

	to_chat(user, "<span class='notice'>[bolt] plinks and crackles as it begins to glow red-hot.</span>")
	bolt.throwforce = 15
	bolt.icon_state = "metal-rod-superheated"
	cell.use(500)

/obj/item/gun/long/crossbow/on_update_icon()
	if(tension > 1)
		icon_state = "[get_world_inventory_state()]-drawn"
	else if(bolt)
		icon_state = "[get_world_inventory_state()]-nocked"
	else
		icon_state = "[get_world_inventory_state()]"
*/

/obj/item/firearm_component/receiver/launcher/sealantgun
	has_safety = FALSE
	release_force = 5

/obj/item/firearm_component/receiver/launcher/grenade
	throw_distance = 7
	release_force = 5

/obj/item/firearm_component/receiver/launcher/rocket
	release_force = 15
	throw_distance = 30
	var/max_rockets = 1
	var/list/rockets = new/list()
/*
/obj/item/gun/cannon/rocket/examine(mob/user, distance)
	. = ..()
	if(distance <= 2)
		to_chat(user, "<span class='notice'>[rockets.len] / [max_rockets] rockets.</span>")

/obj/item/gun/cannon/rocket/consume_next_projectile()
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		var/obj/item/missile/M = new (src)
		M.primed = 1
		rockets -= I
		return M
	return null

/obj/item/gun/cannon/rocket/handle_post_fire(mob/user, atom/target)
	log_and_message_admins("fired a rocket from a rocket launcher ([src.name]) at [target].")
	..()
*/

/obj/item/firearm_component/receiver/launcher/syringe
	screen_shake = 0
/*
	release_force = 10
	throw_distance = 10

	var/list/darts = list()
	var/max_darts = 1
	var/obj/item/syringe_cartridge/next

/obj/item/gun/long/syringe/consume_next_projectile()
	if(next)
		next.prime()
		return next
	return null

/obj/item/gun/long/syringe/handle_post_fire()
	..()
	darts -= next
	next = null
*/

/obj/item/firearm_component/receiver/launcher/syringe/large
	//max_darts = 5


/obj/item/firearm_component/receiver/launcher/syringe/hidden
/*
	force = 3
	throw_distance = 7
	release_force = 10

/obj/item/gun/hand/syringe_disguised/on_update_icon()
	cut_overlays()
	add_overlay("[icon_state]-loaded")

/obj/item/gun/hand/syringe_disguised/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The button is a little stiff.")
*/


/obj/item/firearm_component/receiver/launcher/crossbow/matter
	draw_time = 10
	var/stored_matter = 0
	var/max_stored_matter = 120
	var/boltcost = 30
/*
/obj/item/gun/long/crossbow/rapidcrossbowdevice/proc/generate_bolt(var/mob/user)
	if(stored_matter >= boltcost && !bolt)
		bolt = new/obj/item/arrow/rapidcrossbowdevice(src)
		stored_matter -= boltcost
		to_chat(user, "<span class='notice'>The RCD flashforges a new bolt!</span>")
		queue_icon_update()
	else
		to_chat(user, "<span class='warning'>The \'Low Ammo\' light on the device blinks yellow.</span>")
		flick("[icon_state]-empty", src)

/obj/item/gun/long/crossbow/rapidcrossbowdevice/on_update_icon()
	overlays.Cut()

	if(bolt)
		overlays += "[get_world_inventory_state()]-bolt"

	var/ratio = 0
	if(stored_matter < boltcost)
		ratio = 0
	else
		ratio = stored_matter / max_stored_matter
		ratio = max(round(ratio, 0.25) * 100, 25)
	overlays += "[get_world_inventory_state()][ratio]"

	if(tension > 1)
		icon_state = "[get_world_inventory_state()]-drawn"
	else
		icon_state = "[get_world_inventory_state()]"

/obj/item/gun/long/crossbow/rapidcrossbowdevice/examine(mob/user)
	. = ..()
	to_chat(user, "It currently holds [stored_matter]/[max_stored_matter] matter-units.")
*/


/obj/item/firearm_component/receiver/launcher/foam
	release_force = 1.5
	throw_distance = 6
	var/max_darts = 1
	var/list/darts = new/list()

/*
/obj/item/gun/hand/foam/consume_next_projectile()
	if(darts.len)
		var/obj/item/I = darts[1]
		darts -= I
		return I
	return null

/obj/item/gun/hand/foam/CtrlAltClick(mob/user)
	if(darts.len && src.loc == user)
		to_chat(user, "You empty \the [src].")
		for(var/obj/item/foam_dart/D in darts)
			darts -= D
			D.dropInto(user.loc)
			D.mix_up()
*/

/obj/item/firearm_component/receiver/launcher/foam/smg
	max_darts = 4


/obj/item/firearm_component/receiver/launcher/foam/revolver
	max_darts = 6

/obj/item/firearm_component/receiver/launcher/foam/revolver/tampered
	release_force = 3
	throw_distance = 12

/*
/obj/item/gun/hand/foam/revolver/tampered/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The hammer is a lot more resistant than you'd expect.")
*/


/obj/item/firearm_component/receiver/launcher/pneumatic
	var/fire_pressure                           // Used in fire checks/pressure checks.
	var/max_w_class = ITEM_SIZE_NORMAL          // Hopper intake size.
	var/max_storage_space = DEFAULT_BOX_STORAGE // Total internal storage size.
	var/obj/item/tank/tank = null               // Tank of gas for use in firing the cannon.

	var/obj/item/storage/item_storage
	var/possible_pressure_amounts = list(5,10,20,25,50) // Possible pressure settings.
	var/pressure_setting = 10                   // Percentage of the gas in the tank used to fire the projectile.
	var/force_divisor = 400                     // Force equates to speed. Speed/5 equates to a damage multiplier for whoever you hit.
	                                            // For reference, a fully pressurized oxy tank at 50% gas release firing a health
	                                            // analyzer with a force_divisor of 10 hit with a damage multiplier of 3000+.
/*
/obj/item/gun/long/pneumatic/Initialize()
	. = ..()
	item_storage = new(src)
	item_storage.SetName("hopper")
	item_storage.max_w_class = max_w_class
	item_storage.max_storage_space = max_storage_space
	item_storage.use_sound = null

/obj/item/gun/long/pneumatic/verb/set_pressure() //set amount of tank pressure.
	set name = "Set Valve Pressure"
	set category = "Object"
	set src in range(0)
	var/N = input("Percentage of tank used per shot:","[src]") as null|anything in possible_pressure_amounts
	if (N)
		pressure_setting = N
		to_chat(usr, "You dial the pressure valve to [pressure_setting]%.")

/obj/item/gun/long/pneumatic/proc/eject_tank(mob/user) //Remove the tank.
	if(!tank)
		to_chat(user, "There's no tank in [src].")
		return

	to_chat(user, "You twist the valve and pop the tank out of [src].")
	user.put_in_hands(tank)
	tank = null
	update_icon()

/obj/item/gun/long/pneumatic/proc/unload_hopper(mob/user)
	if(item_storage.contents.len > 0)
		var/obj/item/removing = item_storage.contents[item_storage.contents.len]
		item_storage.remove_from_storage(removing, src.loc)
		user.put_in_hands(removing)
		to_chat(user, "You remove [removing] from the hopper.")
	else
		to_chat(user, "There is nothing to remove in \the [src].")

/obj/item/gun/long/pneumatic/consume_next_projectile(mob/user=null)
	if(!item_storage.contents.len)
		return null
	if (!tank)
		to_chat(user, "There is no gas tank in [src]!")
		return null

	var/environment_pressure = 10
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		if(environment)
			environment_pressure = environment.return_pressure()

	fire_pressure = (tank.air_contents.return_pressure() - environment_pressure)*pressure_setting/100
	if(fire_pressure < 10)
		to_chat(user, "There isn't enough gas in the tank to fire [src].")
		return null

	var/obj/item/launched = item_storage.contents[1]
	item_storage.remove_from_storage(launched, src)
	return launched

/obj/item/gun/long/pneumatic/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return
	to_chat(user, "The valve is dialed to [pressure_setting]%.")
	if(tank)
		to_chat(user, "The tank dial reads [tank.air_contents.return_pressure()] kPa.")
	else
		to_chat(user, "Nothing is attached to the tank valve!")

/obj/item/gun/long/pneumatic/update_release_force(obj/item/projectile)
	if(tank)
		release_force = ((fire_pressure*tank.volume)/projectile.w_class)/force_divisor //projectile speed.
		if(release_force > 80) release_force = 80 //damage cap.
	else
		release_force = 0

/obj/item/gun/long/pneumatic/handle_post_fire()
	if(tank)
		var/lost_gas_amount = tank.air_contents.total_moles*(pressure_setting/100)
		var/datum/gas_mixture/removed = tank.remove_air(lost_gas_amount)

		var/turf/T = get_turf(src.loc)
		if(T) T.assume_air(removed)
	..()

/obj/item/gun/long/pneumatic/on_update_icon()
	if(tank)
		icon_state = "[get_world_inventory_state()]-tank"
	else
		icon_state = get_world_inventory_state()

	update_held_icon()

/obj/item/gun/long/pneumatic/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/I = ..()
	if(tank)
		I.icon_state += "-tank" 
	return I
*/

/obj/item/firearm_component/receiver/launcher/pneumatic/small
	max_w_class = ITEM_SIZE_TINY

/obj/item/firearm_component/receiver/launcher/money
	release_force = 80
	var/emagged = 0
	var/receptacle_value = 0
	var/dispensing = 20

/obj/item/firearm_component/receiver/launcher/money/hacked
	emagged = TRUE

/*

/obj/item/gun/hand/money/proc/vomit_cash(var/mob/vomit_onto, var/projectile_vomit)
	var/bundle_worth = Floor(receptacle_value / 10)
	var/turf/T = get_turf(vomit_onto)
	for(var/i = 1 to 10)
		var/nv = bundle_worth
		if (i <= (receptacle_value - 10 * bundle_worth))
			nv++
		if (!nv)
			break
		var/obj/item/cash/bling = new(T)
		bling.adjust_worth(nv)
		if(projectile_vomit)
			for(var/j = 1, j <= rand(2, 4), j++)
				step(bling, pick(GLOB.cardinal))

	if(projectile_vomit)
		vomit_onto.AdjustStunned(3)
		vomit_onto.AdjustWeakened(3)
		vomit_onto.visible_message("<span class='danger'>\The [vomit_onto] blasts themselves full in the face with \the [src]!</span>")
		playsound(T, "sound/weapons/gunshot/money_launcher_jackpot.ogg", 100, 1)
	else
		var/decl/currency/cur = decls_repository.get_decl(GLOB.using_map.default_currency)
		vomit_onto.visible_message("<span class='danger'>\The [vomit_onto] ejects a few [cur.name] into their face.</span>")
		playsound(T, 'sound/weapons/gunshot/money_launcher.ogg', 100, 1)

	receptacle_value = 0

/obj/item/gun/hand/money/proc/make_it_rain(var/mob/user)
	vomit_cash(user, receptacle_value >= 10)

/obj/item/gun/hand/money/update_release_force()
	if(!emagged)
		release_force = 0
		return

	// Must launch at least $100 to incur damage.
	release_force = dispensing / 100

/obj/item/gun/hand/money/proc/unload_receptacle(mob/user)
	if(receptacle_value < 1)
		to_chat(user, "<span class='warning'>There's no money in [src].</span>")
		return

	var/obj/item/cash/bling = new
	bling.adjust_worth(receptacle_value)
	user.put_in_hands(bling)
	var/decl/currency/cur = decls_repository.get_decl(GLOB.using_map.default_currency)
	to_chat(user, "<span class='notice'>You eject [receptacle_value] [cur.name_singular] from [src]'s receptacle.</span>")
	receptacle_value = 0

/obj/item/gun/hand/money/proc/absorb_cash(var/obj/item/cash/bling, mob/user)
	if(!istype(bling) || !bling.absolute_worth || bling.absolute_worth < 1)
		to_chat(user, "<span class='warning'>[src] refuses to pick up [bling].</span>")
		return

	src.receptacle_value += bling.absolute_worth
	to_chat(user, "<span class='notice'>You load [bling] into [src].</span>")
	qdel(bling)

/obj/item/gun/hand/money/consume_next_projectile(mob/user=null)
	if(!receptacle_value || receptacle_value < 1)
		return null

	var/obj/item/cash/bling = new /obj/item/cash()
	if(receptacle_value >= dispensing)
		bling.adjust_worth(dispensing)
		receptacle_value -= dispensing
	else
		bling.adjust_worth(receptacle_value)
		receptacle_value = 0

	bling.update_icon()
	update_release_force(bling.absolute_worth)
	if(release_force >= 1)
		var/datum/effect/effect/system/spark_spread/s = new()
		s.set_up(3, 1, src)
		s.start()

	return bling

/obj/item/gun/hand/money/examine(mob/user)
	. = ..(user)
	var/decl/currency/cur = decls_repository.get_decl(GLOB.using_map.default_currency)
	to_chat(user, "It is configured to dispense [dispensing] [cur.name_singular] at a time.")

	if(receptacle_value >= 1)
		to_chat(user, "The receptacle is loaded with [receptacle_value] [cur.name_singular].")

	else
		to_chat(user, "The receptacle is empty.")

	if(emagged)
		to_chat(user, "<span class='notice'>Its motors are severely overloaded.</span>")

/obj/item/gun/hand/money/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/M = user
	M.visible_message("<span class='danger'>[user] sticks [src] in their mouth, ready to pull the trigger...</span>")

	if(!do_after(user, 40, progress = 0))
		M.visible_message("<span class='notice'>[user] decided life was worth living.</span>")
		return

	src.make_it_rain(user)

/obj/item/gun/hand/money/emag_act(var/remaining_charges, var/mob/user)
	// Overloads the motors, causing it to shoot money harder and do harm.
	if(!emagged)
		emagged = 1
		to_chat(user, "<span class='notice'>You slide the sequencer into [src]... only for it to spit it back out and emit a motorized squeal!</span>")
		var/datum/effect/effect/system/spark_spread/s = new()
		s.set_up(3, 1, src)
		s.start()
	else
		to_chat(user, "<span class='notice'>[src] seems to have been tampered with already.</span>")
*/