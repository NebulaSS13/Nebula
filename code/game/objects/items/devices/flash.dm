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
	icon_state = get_world_inventory_state()
	if(broken)
		icon_state = "[icon_state]-burnt"

/obj/item/flash/proc/clown_check(var/mob/user)
	if(user && (MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>\The [src] slips out of your hand.</span>")
		user.unEquip(src)
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

//attack_as_weapon
/obj/item/flash/attack(mob/living/M, mob/living/user, var/target_zone)
	if(!user || !M)	return 0 //sanity
	admin_attack_log(user, M, "flashed their victim using \a [src].", "Was flashed by \a [src].", "used \a [src] to flash")

	if(!clown_check(user))	return 0
	if(broken)
		to_chat(user, "<span class='warning'>\The [src] is broken.</span>")
		return 0

	flash_recharge()

	//spamming the flash before it's fully charged (60seconds) increases the chance of it breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			last_used = world.time
			if(prob(times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
				icon_state = "[initial(icon_state)]-burnt"
				return 0
			times_used++
		else	//can only use it 5 times a minute
			to_chat(user, "<span class='warning'>*click* *click*</span>")
			return 0

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	var/flashfail = 0
	var/flash_strength = (rand(str_min,str_max))

	if(iscarbon(M))
		if(M.stat!=DEAD)
			var/mob/living/carbon/C = M
			var/safety = C.eyecheck()
			if(safety < FLASH_PROTECTION_MODERATE)
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					flash_strength = round(H.getFlashMod() * flash_strength)
					if(safety > FLASH_PROTECTION_NONE)
						flash_strength = (flash_strength / 2)
				if(flash_strength > 0)
					M.flash_eyes(FLASH_PROTECTION_MODERATE - safety)
					M.Stun(flash_strength / 2)
					M.eye_blurry += flash_strength
					M.confused += (flash_strength + 2)
					if(flash_strength > 3)
						M.drop_held_items()
					if(flash_strength > 5)
						M.Weaken(2)
			else
				flashfail = 1

	else if(isanimal(M))
		var/mob/living/simple_animal/SA = M
		var/safety = SA.eyecheck()
		if(safety < FLASH_PROTECTION_MAJOR)
			SA.Weaken(2)
			if(safety < FLASH_PROTECTION_MODERATE)
				SA.Stun(flash_strength - 2)
				SA.flash_eyes(2)
				SA.eye_blurry += flash_strength
				SA.confused += flash_strength
		else 
			flashfail = 1

	else if(issilicon(M))
		M.Weaken(rand(str_min,6))

	else
		flashfail = 1

	if(isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user)
			animation.plane = user.plane
			animation.layer = user.layer + 0.01
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	if(!flashfail)
		flick("[initial(icon_state)]-on", src)
		if(!issilicon(M))
			user.visible_message("<span class='disarm'>[user] blinds [M] with \the [src]!</span>")
		else
			user.visible_message("<span class='notice'>[user] overloads [M]'s sensors with \the [src]!</span>")
	else
		user.visible_message("<span class='notice'>[user] fails to blind [M] with \the [src]!</span>")
	return 1




/obj/item/flash/attack_self(mob/living/carbon/user, flag = 0, emp = 0)
	if(!user || !clown_check(user)) 	return 0

	if(broken)
		user.show_message("<span class='warning'>The [src.name] is broken</span>", 2)
		return 0

	flash_recharge()

	//spamming the flash before it's fully charged (60seconds) increases the chance of it  breaking
	//It will never break on the first use.
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))	//if you use it 5 times in a minute it has a 10% chance to break!
				broken = 1
				to_chat(user, "<span class='warning'>The bulb has burnt out!</span>")
				icon_state = "[initial(icon_state)]-burnt"
				return 0
			times_used++
		else	//can only use it  5 times a minute
			user.show_message("<span class='warning'>*click* *click*</span>", 2)
			return 0
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	playsound(src.loc, 'sound/weapons/flash.ogg', 100, 1)
	flick("[initial(icon_state)]-on", src)
	if(user && isrobot(user))
		spawn(0)
			var/atom/movable/overlay/animation = new(user.loc)
			animation.plane = user.plane
			animation.layer = user.layer + 0.01
			animation.icon_state = "blank"
			animation.icon = 'icons/mob/mob.dmi'
			animation.master = user
			flick("blspell", animation)
			sleep(5)
			qdel(animation)

	for(var/mob/living/carbon/M in oviewers(3, null))
		var/safety = M.eyecheck()
		if(safety < FLASH_PROTECTION_MODERATE)
			if(!M.blinded)
				M.flash_eyes()
				M.eye_blurry += 2

	return 1

/obj/item/flash/emp_act(severity)
	if(broken)	return
	flash_recharge()
	switch(times_used)
		if(0 to 5)
			if(prob(2*times_used))
				broken = 1
				update_icon()
				return
			times_used++
			if(istype(loc, /mob/living/carbon))
				var/mob/living/carbon/M = loc
				var/safety = M.eyecheck()
				if(safety < FLASH_PROTECTION_MODERATE)
					M.Weaken(10)
					M.flash_eyes()
					for(var/mob/O in viewers(M, null))
						O.show_message("<span class='disarm'>[M] is blinded by the [name]!</span>")
	..()

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
