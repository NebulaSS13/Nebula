/obj/item/organ/internal/brain
	name = "brain"
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	icon_state = "brain2"
	force = 1.0
	w_class = ITEM_SIZE_SMALL
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = "{'biotech':3}"
	attack_verb = list("attacked", "slapped", "whacked")
	relative_size = 85
	damage_reduction = 0

	var/can_use_brain_interface = TRUE
	var/mob/living/brainmob
	var/const/damage_threshold_count = 10
	var/damage_threshold_value
	var/healed_threshold = 1
	var/oxygen_reserve = 6

/obj/item/organ/internal/brain/Initialize()
	. = ..()
	if(species)
		set_max_damage(species.total_health)
	else
		set_max_damage(200)
	initialize_brain()

/obj/item/organ/internal/brain/proc/initialize_brain()
	if(istype(brainmob))
		return
	if(!ispath(brainmob))
		brainmob = initial(brainmob) || /mob/living/brain
	brainmob = new brainmob(src)

/obj/item/organ/internal/brain/robotic
	name = "computer intelligence module"
	desc = "An excitingly chunky computer system made for running a complex machine intelligence."
	icon_state = "brain-prosthetic"
	can_use_brain_interface = FALSE

/obj/item/organ/internal/brain/robotic/Initialize()
	. = ..()
	robotize()

/obj/item/organ/internal/brain/robotize(var/company = /decl/prosthetics_manufacturer, var/skip_prosthetics, var/keep_organs, var/apply_material = /decl/material/solid/metal/steel)
	replace_self_with(/obj/item/organ/internal/brain_holder/robotic)

/obj/item/organ/internal/brain/mechassist()
	replace_self_with(/obj/item/organ/internal/brain_holder/organic)

/obj/item/organ/internal/brain/getToxLoss()
	return 0

/obj/item/organ/internal/brain/proc/replace_self_with(replace_path)
	var/mob/living/carbon/human/tmp_owner = owner
	qdel(src)
	if(tmp_owner)
		tmp_owner.internal_organs_by_name[organ_tag] = new replace_path(tmp_owner, 1)
		tmp_owner = null

/obj/item/organ/internal/brain/robotize(var/company = /decl/prosthetics_manufacturer, var/skip_prosthetics, var/keep_organs, var/apply_material = /decl/material/solid/metal/steel)
	. = ..()
	icon_state = "brain-prosthetic"

/obj/item/organ/internal/brain/set_max_damage(var/ndamage)
	..()
	damage_threshold_value = round(max_damage / damage_threshold_count)

/obj/item/organ/internal/brain/Destroy()
	QDEL_NULL(brainmob)
	. = ..()

/obj/item/organ/internal/brain/proc/transfer_identity(var/mob/M, var/debrained = TRUE)

	var/initial_key = M.key
	if(M.mind)
		M.mind.transfer_to(brainmob)
	if(brainmob.key != initial_key)
		brainmob.key = initial_key

	if(debrained)
		brainmob.SetName(M.real_name)
		brainmob.real_name = M.real_name
		brainmob.dna = M.dna?.Clone()
		to_chat(brainmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just \a [initial(src.name)]."))
		callHook("debrain", list(brainmob))

/obj/item/organ/internal/brain/examine(mob/user)
	. = ..()
	if(brainmob?.client) //if thar be a brain inside... the brain.
		to_chat(user, "You can feel the small spark of life still left in this one.")
	else
		to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later..")

/obj/item/organ/internal/brain/removed(var/mob/living/user)
	if(istype(owner))
		if(name == initial(name))
			name = "\the [owner.real_name]'s [initial(name)]"
		transfer_identity(owner)
	..()

/obj/item/organ/internal/brain/replaced(var/mob/living/target)

	if(!..()) return 0

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key

	return 1

/obj/item/organ/internal/brain/can_recover()
	return ~status & ORGAN_DEAD

/obj/item/organ/internal/brain/proc/get_current_damage_threshold()
	return round(damage / damage_threshold_value)

/obj/item/organ/internal/brain/proc/past_damage_threshold(var/threshold)
	return (get_current_damage_threshold() > threshold)

/obj/item/organ/internal/brain/proc/handle_severe_brain_damage()
	set waitfor = FALSE
	healed_threshold = 0
	to_chat(owner, "<span class = 'notice' font size='10'><B>Where am I...?</B></span>")
	sleep(5 SECONDS)
	if(!owner)
		return
	to_chat(owner, "<span class = 'notice' font size='10'><B>What's going on...?</B></span>")
	sleep(10 SECONDS)
	if(!owner)
		return
	to_chat(owner, "<span class = 'notice' font size='10'><B>What happened...?</B></span>")
	alert(owner, "You have taken massive brain damage! You will not be able to remember the events leading up to your injury.", "Brain Damaged")

/obj/item/organ/internal/brain/Process()
	if(owner)
		if(damage > max_damage / 2 && healed_threshold)
			handle_severe_brain_damage()

		if(damage < (max_damage / 4))
			healed_threshold = 1

		handle_disabilities()
		handle_damage_effects()

		// Brain damage from low oxygenation or lack of blood.
		if(owner.should_have_organ(BP_HEART))

			// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
			var/blood_volume = owner.get_blood_oxygenation()
			if(blood_volume < BLOOD_VOLUME_SURVIVE)
				if(!owner.has_chemical_effect(CE_STABLE, 1) || prob(60))
					oxygen_reserve = max(0, oxygen_reserve-1)
			else
				oxygen_reserve = min(initial(oxygen_reserve), oxygen_reserve+1)
			if(!oxygen_reserve) //(hardcrit)
				SET_STATUS_MAX(owner, STAT_PARA, 3)
			var/can_heal = damage && damage < max_damage && (damage % damage_threshold_value || GET_CHEMICAL_EFFECT(owner, CE_BRAIN_REGEN) || (!past_damage_threshold(3) && GET_CHEMICAL_EFFECT(owner, CE_STABLE)))
			var/damprob
			//Effects of bloodloss
			var/stability_effect = GET_CHEMICAL_EFFECT(owner, CE_STABLE)
			switch(blood_volume)

				if(BLOOD_VOLUME_SAFE to INFINITY)
					if(can_heal)
						damage = max(damage-1, 0)
				if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
					if(prob(1))
						to_chat(owner, "<span class='warning'>You feel [pick("dizzy","woozy","faint")]...</span>")
					damprob = stability_effect ? 30 : 60
					if(!past_damage_threshold(2) && prob(damprob))
						take_internal_damage(1)
				if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
					SET_STATUS_MAX(owner, STAT_BLURRY, 6)
					damprob = stability_effect ? 40 : 80
					if(!past_damage_threshold(4) && prob(damprob))
						take_internal_damage(1)
					if(!HAS_STATUS(owner, STAT_PARA) && prob(10))
						SET_STATUS_MAX(owner, STAT_PARA, rand(1,3))
						to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
				if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
					SET_STATUS_MAX(owner, STAT_BLURRY, 6)
					damprob = stability_effect ? 60 : 100
					if(!past_damage_threshold(6) && prob(damprob))
						take_internal_damage(1)
					if(!HAS_STATUS(owner, STAT_PARA) && prob(15))
						SET_STATUS_MAX(owner, STAT_PARA, rand(3,5))
						to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
				if(-(INFINITY) to BLOOD_VOLUME_SURVIVE) // Also see heart.dm, being below this point puts you into cardiac arrest.
					SET_STATUS_MAX(owner, STAT_BLURRY, 6)
					damprob = stability_effect ? 80 : 100
					if(prob(damprob))
						take_internal_damage(1)
					if(prob(damprob))
						take_internal_damage(1)
	..()

/obj/item/organ/internal/brain/take_internal_damage(var/damage, var/silent)
	set waitfor = 0
	..()
	if(damage >= 10) //This probably won't be triggered by oxyloss or mercury. Probably.
		var/damage_secondary = damage * 0.20
		owner.flash_eyes()
		SET_STATUS_MAX(owner, STAT_BLURRY, damage_secondary)
		SET_STATUS_MAX(owner, STAT_CONFUSE, damage_secondary * 2)
		SET_STATUS_MAX(owner, STAT_PARA, damage_secondary)
		SET_STATUS_MAX(owner, STAT_WEAK, round(damage, 1))
		if(prob(30))
			addtimer(CALLBACK(src, .proc/brain_damage_callback, damage), rand(6, 20) SECONDS, TIMER_UNIQUE)

/obj/item/organ/internal/brain/proc/brain_damage_callback(var/damage) //Confuse them as a somewhat uncommon aftershock. Side note: Only here so a spawn isn't used. Also, for the sake of a unique timer.
	if(!QDELETED(owner))
		to_chat(owner, SPAN_NOTICE("<font size='10'><B>I can't remember which way is forward...</B></font>"))
		ADJ_STATUS(owner, STAT_CONFUSE, damage)

/obj/item/organ/internal/brain/proc/handle_disabilities()
	if(owner.stat)
		return
	if((owner.disabilities & EPILEPSY) && prob(1))
		owner.seizure()
	else if((owner.disabilities & TOURETTES) && prob(10))
		SET_STATUS_MAX(owner, STAT_STUN, 10)
		switch(rand(1, 3))
			if(1)
				owner.emote("twitch")
			if(2 to 3)
				owner.say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
		ADJ_STATUS(owner, STAT_JITTER, 100)
	else if((owner.disabilities & NERVOUS) && prob(10))
		SET_STATUS_MAX(owner, STAT_STUTTER, 10)

/obj/item/organ/internal/brain/proc/handle_damage_effects()
	if(owner.stat)
		return
	if(damage > 0 && prob(1))
		owner.custom_pain("Your head feels numb and painful.",10)
	if(is_bruised() && prob(1) && !HAS_STATUS(owner, STAT_BLURRY))
		to_chat(owner, "<span class='warning'>It becomes hard to see for some reason.</span>")
		owner.set_status(STAT_BLURRY, 10)
	var/held = owner.get_active_hand()
	if(damage >= 0.5*max_damage && prob(1) && held)
		to_chat(owner, "<span class='danger'>Your hand won't respond properly, and you drop what you are holding!</span>")
		owner.unEquip(held)
	if(damage >= 0.6*max_damage)
		SET_STATUS_MAX(owner, STAT_SLUR, 2)
	if(is_broken())
		if(!owner.lying)
			to_chat(owner, "<span class='danger'>You black out!</span>")
		SET_STATUS_MAX(owner, STAT_PARA, 10)

/obj/item/organ/internal/brain/surgical_fix(mob/user)
	var/blood_volume = owner.get_blood_oxygenation()
	if(blood_volume < BLOOD_VOLUME_SURVIVE)
		to_chat(user, SPAN_DANGER("Parts of \the [src] didn't survive the procedure due to lack of air supply!"))
		set_max_damage(Floor(max_damage - 0.25*damage))
	heal_damage(damage)

/obj/item/organ/internal/brain/get_scarring_level()
	. = (species.total_health - max_damage)/species.total_health

/obj/item/organ/internal/brain/get_mechanical_assisted_descriptor()
	return "machine-interface [name]"

/obj/item/organ/internal/brain/die()
	if(brainmob && brainmob.stat != DEAD)
		brainmob.death()
	..()

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/internal/brain_holder
	name = "brain interface"
	icon_state = "mmi-empty"
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	var/obj/item/brain_interface/stored_brain = /obj/item/brain_interface
	var/datum/mind/stored_mind //Mind that the organ will hold on to after being removed, used for transfer_and_delete
	var/stored_ckey // used in the event the owner is out of body

/obj/item/organ/internal/brain_holder/Destroy()
	stored_brain = null
	return ..()

/obj/item/organ/internal/brain_holder/Initialize(mapload, var/internal, var/obj/item/brain_interface/supplied)
	. = ..()
	if(istype(supplied))
		stored_brain = supplied
		stored_brain.forceMove(src)
	else if(ispath(stored_brain))
		stored_brain = new stored_brain(src)
	if(!istype(stored_brain))
		return INITIALIZE_HINT_QDEL
	update_from_mmi()
	stored_mind = owner.mind
	stored_ckey = owner.ckey

/obj/item/organ/internal/brain_holder/proc/update_from_mmi()

	if(!stored_brain.holding_brain || !owner)
		return

	name = stored_brain.name
	desc = stored_brain.desc
	appearance = stored_brain

	if(owner && owner.stat == DEAD)
		owner.set_stat(CONSCIOUS)
		owner.switch_from_dead_to_living_mob_list()
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/internal/brain_holder/cut_away(var/mob/living/user)
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent))
		removed(user, 0)
		parent.implants += transfer_and_delete()

/obj/item/organ/internal/brain_holder/removed()
	if(owner && owner.mind)
		stored_mind = owner.mind
		if(owner.ckey)
			stored_ckey = owner.ckey
	..()

/obj/item/organ/internal/brain_holder/proc/transfer_and_delete()
	. = stored_brain
	if(.)
		stored_brain.forceMove(src.loc)
		if(stored_brain.holding_brain?.brainmob && stored_mind)
			stored_mind.transfer_to(stored_brain.holding_brain.brainmob)
		stored_brain = null
	qdel(src)

/obj/item/organ/internal/brain_holder/robotic
	stored_brain = /obj/item/brain_interface/robotic

/obj/item/organ/internal/brain_holder/organic
	stored_brain = /obj/item/brain_interface/organic
