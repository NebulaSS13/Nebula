/mob/living
	var/hiding

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(incapacitated())
		return

	hiding = !hiding
	if(hiding)
		to_chat(src, "<span class='notice'>You are now hiding.</span>")
	else
		to_chat(src, "<span class='notice'>You have stopped hiding.</span>")
	reset_layer()

/mob/living/proc/breath_death()
	set name = "Breath Death"
	set desc = "Infect others with your very breath."
	set category = "Abilities"

	if(is_on_special_ability_cooldown())
		to_chat(src, "<span class='warning'>You aren't ready to do that! Wait [get_seconds_until_next_special_ability_string()].</span>")
		return

	if (incapacitated())
		to_chat(src, "<span class='warning'>You can't do that while you're incapacitated!</span>")
		return

	set_special_ability_cooldown(60 SECONDS)

	var/turf/T = get_turf(src)
	var/obj/effect/effect/water/chempuff/chem = new(T)
	chem.create_reagents(10)
	chem.add_to_reagents(/decl/material/liquid/zombie, 2)
	chem.set_up(get_step(T, dir), 2, 10)
	playsound(T, 'sound/hallucinations/wail.ogg', 20, 1)

/mob/living/proc/consume()
	set name = "Consume"
	set desc = "Regain life by consuming it from others."
	set category = "Abilities"

	if (is_on_special_ability_cooldown())
		to_chat(src, "<span class='warning'>You aren't ready to do that! Wait [get_seconds_until_next_special_ability_string()].</span>")
		return

	if (incapacitated())
		to_chat(src, "<span class='warning'>You can't do that while you're incapacitated!</span>")
		return

	var/mob/living/target
	for (var/mob/living/L in get_turf(src))
		if (L != src && (L.current_posture.prone || L.stat == DEAD))
			target = L
			break
	if (!target)
		to_chat(src, "<span class='warning'>You aren't on top of a victim!</span>")
		return

	set_special_ability_cooldown(5 SECONDS)

	visible_message("<span class='danger'>\The [src] hunkers down over \the [target], tearing into their flesh.</span>")
	if(do_mob(src, target, 5 SECONDS))
		to_chat(target,"<span class='danger'>\The [src] scrapes your flesh from your bones!</span>")
		to_chat(src,"<span class='danger'>You feed hungrily off \the [target]'s flesh.</span>")
		target.take_damage(25)
		if(target.get_damage(BRUTE) < -target.get_max_health())
			target.gib()
		heal_damage(BRUTE, 25)

/**
 *  Attempt to devour victim
 *
 *  Returns TRUE on success, FALSE on failure
 */
/mob/living/proc/devour(atom/movable/victim)
	var/can_eat = can_devour(victim)
	if(!can_eat)
		return FALSE

	var/eat_speed = 100
	if(can_eat == DEVOUR_FAST)
		eat_speed = 30
	src.visible_message("<span class='danger'>\The [src] is attempting to devour \the [victim] whole!</span>")
	var/mob/target = victim
	if(isobj(victim))
		target = src
	if(!do_mob(src,target,eat_speed))
		return FALSE
	src.visible_message("<span class='danger'>\The [src] devours \the [victim] whole!</span>")
	if(ismob(victim))
		admin_attack_log(src, victim, "Devoured.", "Was devoured by.", "devoured")
	else
		src.drop_from_inventory(victim)
	move_to_stomach(victim)

	return TRUE

/mob/living/proc/move_to_stomach(atom/movable/victim)
	return

/**
 *  Return FALSE if victim can't be devoured, DEVOUR_FAST if they can be devoured quickly, DEVOUR_SLOW for slow devour
 */
/mob/living/proc/can_devour(atom/movable/victim, silent = FALSE)
	return FALSE

/mob/living/verb/sniff_verb()
	set name = "Sniff"
	set desc = "Smell the local area."
	set category = "IC"
	set src = usr

	var/decl/species/my_species = get_species()
	if(incapacitated())
		to_chat(src, SPAN_WARNING("You can't sniff right now."))
		return

	if(my_species && my_species.sniff_message_3p && my_species.sniff_message_1p)
		visible_message(SPAN_NOTICE("\The [src] [my_species.sniff_message_3p]."), SPAN_NOTICE(my_species.sniff_message_1p))
	else
		visible_message(SPAN_NOTICE("\The [src] sniffs the air."), SPAN_NOTICE("You sniff the air."))
	LAZYCLEARLIST(smell_cooldown)
