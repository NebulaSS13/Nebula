/obj/item/flash
	name = "flash"
	desc = "A device that produces a bright flash of light, designed to stun and disorient an attacker."
	icon = 'icons/obj/items/device/flash.dmi'
	icon_state = ICON_STATE_WORLD
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 10
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	origin_tech = "{'magnets':2,'combat':1}"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

	var/times_used = 0 //Number of times it's been used.
	var/broken = 0     //Is the flash burnt out?
	var/last_used = 0 //last world.time it was used.
	var/str_min = 2 //how weak the effect CAN be
	var/str_max = 7 //how powerful the effect COULD be

/obj/item/flash/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(broken)
		icon_state = "[icon_state]-burnt"

/obj/item/flash/proc/clown_check(var/mob/user)
	if(user && (MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>\The [src] slips out of your hand.</span>")
		user.try_unequip(src)
		return 0
	return 1

/obj/item/flash/proc/flash_recharge()
	//capacitor recharges over time
	for(var/i=0, i<3, i++)
		if(last_used+600 > world.time)
			break
		last_used += 600
		times_used -= 2
	last_used = world.time
	times_used = max(0,round(times_used)) //sanity

/obj/item/flash/proc/do_flash_animation(var/mob/user, var/mob/target)
	if(user)
		if(target)
			user.do_attack_animation(target)
		user.do_flash_animation()
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("[initial(icon_state)]-on", src)

/obj/item/flash/proc/check_usability(var/mob/user)

	if(times_used > 5)
		if(user)
			to_chat(user, SPAN_WARNING("*click* *click*"))
		return FALSE

	last_used = world.time
	times_used++
	if(times_used > 1 && prob(times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
		broken = TRUE
		if(user)
			to_chat(user, SPAN_WARNING("The bulb has burnt out!"))
		icon_state = "[initial(icon_state)]-burnt"
		return FALSE

	return TRUE

/obj/item/flash/proc/general_flash_check(var/mob/user)
	if(!clown_check(user))
		return FALSE
	if(broken)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] is broken."))
		return FALSE
	flash_recharge()
	if(!check_usability(user))
		return FALSE
	return TRUE

//attack_as_weapon
/obj/item/flash/attack(mob/living/M, mob/living/user, var/target_zone)

	if(!user || !M || !general_flash_check(user))
		return FALSE

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	do_flash_animation(user, M)

	if(M.stat != DEAD && M.handle_flashed(src, rand(str_min,str_max)))
		admin_attack_log(user, M, "flashed their victim using \a [src].", "Was flashed by \a [src].", "used \a [src] to flash")
		if(!M.isSynthetic())
			user.visible_message(SPAN_DANGER("[user] blinds [M] with \the [src]!"))
		else
			user.visible_message(SPAN_DANGER("[user] overloads [M]'s sensors with \the [src]!"))
	else
		user.visible_message(SPAN_WARNING("[user] fails to blind [M] with \the [src]!"))
	return TRUE

/obj/item/flash/attack_self(mob/user, flag = 0, emp = 0)
	if(!user || !general_flash_check(user))
		return FALSE

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	do_flash_animation(user)
	for(var/mob/living/carbon/M in oviewers(3, null))
		M.handle_flashed(src, rand(str_min,str_max))
	return TRUE

/obj/item/flash/emp_act(severity)
	if(broken || !general_flash_check())
		return FALSE
	do_flash_animation()
	for(var/mob/living/carbon/M in oviewers(3, null))
		M.handle_flashed(src, rand(str_min,str_max))

/obj/item/flash/synthetic //not for regular use, weaker effects
	name = "modified flash"
	desc = "A device that produces a bright flash of light. This is a specialized version designed specifically for use in camera systems."
	icon = 'icons/obj/items/device/flash_synthetic.dmi'
	str_min = 1
	str_max = 4

/obj/item/flash/advanced
	name = "advanced flash"
	desc = "A device that produces a very bright flash of light. This is an advanced and expensive version often issued to VIPs."
	icon = 'icons/obj/items/device/flash_advanced.dmi'
	origin_tech = "{'combat':2,'magnets':2}"
	str_min = 3
	str_max = 8
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
