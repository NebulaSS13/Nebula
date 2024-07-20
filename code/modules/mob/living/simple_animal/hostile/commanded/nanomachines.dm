/mob/living/simple_animal/hostile/commanded/nanomachine
	name = "swarm"
	desc = "a cloud of tiny, tiny robots."
	icon = 'icons/mob/simple_animal/nanomachines.dmi'
	natural_weapon = /obj/item/natural_weapon/nanomachine
	max_health = 10
	gene_damage = -1
	response_help_1p = "You wave your hand through $TARGET$."
	response_help_3p = "$USER$ waves $USER_THEIR$ hand through $TARGET$."
	response_harm =    "agitates"
	response_disarm =  "fans at"
	ai = /datum/mob_controller/aggressive/commanded/nanomachines
	var/regen_time = 0

/datum/mob_controller/aggressive/commanded/nanomachines
	expected_type = /mob/living/simple_animal/hostile/commanded/nanomachine
	known_commands = list("stay", "stop", "attack", "follow", "heal", "emergency protocol")
	can_escape_buckles = TRUE
	var/emergency_protocols = 0

/obj/item/natural_weapon/nanomachine
	name = "decompilers"
	attack_verb = list("swarmed")
	_base_attack_force = 2
	sharp = TRUE

/datum/mob_controller/aggressive/commanded/nanomachines/do_process(time_elapsed)

	if(!(. = ..()) || body.stat)
		return

	switch(stance)
		if(STANCE_COMMANDED_HEAL)
			if(!get_target())
				set_target(find_target(STANCE_COMMANDED_HEAL))
			if(get_target())
				move_to_heal()
		if(STANCE_COMMANDED_HEALING)
			heal()

/datum/mob_controller/aggressive/commanded/nanomachines/misc_command(var/mob/speaker,var/text)
	var/stance = get_stance()
	if(stance != STANCE_COMMANDED_HEAL || stance != STANCE_COMMANDED_HEALING) //dont want attack to bleed into heal.
		LAZYCLEARLIST(_allowed_targets)
		set_target(null)
	if(findtext(text,"heal")) //heal shit pls
		if(findtext(text,"me")) //assumed want heals on master.
			set_target(speaker)
			set_stance(STANCE_COMMANDED_HEAL)
			return 1
		var/list/targets = get_targets_by_name(text)
		if(LAZYLEN(targets) != 1)
			body.say("ERROR. TARGET COULD NOT BE PARSED.")
			return 0
		var/weakref/target_ref = targets[1]
		set_target(target_ref.resolve())
		set_stance(STANCE_COMMANDED_HEAL)
		return 1
	if(findtext(text,"emergency protocol"))
		if(findtext(text,"deactivate"))
			if(emergency_protocols)
				body.say("EMERGENCY PROTOCOLS DEACTIVATED.")
			emergency_protocols = 0
			return 1
		if(findtext(text,"activate"))
			if(!emergency_protocols)
				body.say("EMERGENCY PROTOCOLS ACTIVATED.")
			emergency_protocols = 1
			return 1
		if(findtext(text,"check"))
			body.say("EMERGENCY PROTOCOLS [emergency_protocols ? "ACTIVATED" : "DEACTIVATED"].")
			return 1
	return 0

/datum/mob_controller/aggressive/commanded/nanomachines/proc/move_to_heal()
	var/atom/target = get_target()
	if(!istype(target))
		return 0
	body.start_automove(target)
	if(body.Adjacent(target))
		set_stance(STANCE_COMMANDED_HEALING)

/datum/mob_controller/aggressive/commanded/nanomachines/proc/heal()
	if(body.current_health <= 3 && !emergency_protocols) //dont die doing this.
		return 0
	var/mob/living/target = get_target()
	if(!istype(target))
		return 0
	if(!body.Adjacent(target) || attackable(target))
		set_stance(STANCE_COMMANDED_HEAL)
		return 0
	if(target.stat || target.current_health >= target.get_max_health()) //he's either dead or healthy, move along.
		LAZYREMOVE(_allowed_targets, weakref(target))
		set_target(null)
		set_stance(STANCE_COMMANDED_HEAL)
		return 0
	body.visible_message("\The [body] glows green for a moment, healing \the [target]'s wounds.")
	body.take_damage(3)
	target.heal_damage(BRUTE, 5, do_update_health = FALSE)
	target.heal_damage(BURN, 5)

/mob/living/simple_animal/hostile/commanded/nanomachine/get_death_message(gibbed)
	return "dissipates into thin air."

/mob/living/simple_animal/hostile/commanded/nanomachine/get_self_death_message(gibbed)
	return "You have been destroyed."

/mob/living/simple_animal/hostile/commanded/nanomachine/death(gibbed)
	. = ..()
	if(. && !gibbed)
		qdel(src)

/mob/living/simple_animal/hostile/commanded/nanomachine/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE
	regen_time++
	if(regen_time == 2 && current_health < get_max_health()) //slow regen
		regen_time = 0
		heal_overall_damage(1)
