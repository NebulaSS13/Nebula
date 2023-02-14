/mob/living/alien
	name = "alien"
	desc = "What IS that?"
	pass_flags = PASS_FLAG_TABLE
	health = 100
	maxHealth = 100
	mob_size = MOB_SIZE_TINY
	mob_sort_value = 8
	var/dead_icon
	var/language
	var/death_msg = "lets out a waning guttural screech, green blood bubbling from its maw."
	var/instance_num

/mob/living/alien/Initialize()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	instance_num = rand(1, 1000)
	name = "[initial(name)] ([instance_num])"
	real_name = name
	update_icon()

	if(language)
		add_language(language)

	gender = NEUTER
	. = ..()

/mob/living/alien/u_equip(obj/item/W)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/mob/living/alien/restrained()
	return 0

/mob/living/alien/show_inv(mob/user)
	return //Consider adding cuffs and hats to this, for the sake of fun.

/mob/living/alien/get_admin_job_string()
	return "Alien"
