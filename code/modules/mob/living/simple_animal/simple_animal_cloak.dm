/mob/living/simple_animal
	var/can_use_cloak = FALSE
	var/cloaked_alpha = 45
	var/last_cloak
	var/next_cloak = 0
	var/cloak_anim_time = 1 SECOND
	var/cloak_delay = 10 SECONDS

/mob/living/simple_animal/Initialize()
	. = ..()
	if(can_use_cloak)
		verbs += /mob/living/simple_animal/proc/cloak_verb

/mob/living/simple_animal/proc/cloak_verb()
	set name = "Toggle Stealth"
	set category = "Abilities"
	set desc = "Enter or emerge from hiding."
	set src = usr

	var/cloaked = is_cloaked()
	if(!can_cloak())
		var/cloak_string = cloaked ? "emerge from" : "go into"
		to_chat(usr, SPAN_WARNING("You can't [cloak_string] hiding right now!"))
		return

	if(cloaked)
		remove_cloak()
	else
		apply_cloak()

/mob/living/simple_animal/can_cloak(ignore_timing = FALSE)
	return can_use_cloak && (ignore_timing || world.time >= next_cloak) && !incapacitated()

/mob/living/simple_animal/apply_cloak()
	if(is_cloaked())
		return
	last_cloak = world.time
	add_mob_modifier(/decl/mob_modifier/cloaked, source = src)
	update_icon()

/mob/living/simple_animal/remove_cloak()
	next_cloak = world.time + cloak_delay // Always reset the timer.
	if(!is_cloaked())
		return
	remove_mob_modifier(/decl/mob_modifier/cloaked, source = src)
	update_icon()

/mob/living/simple_animal/is_fully_cloaked()
	return ..() && world.time >= last_cloak + cloak_anim_time
