/mob/living/human/proc/get_unarmed_attack(var/mob/target, var/hit_zone = null)
	if(!hit_zone)
		hit_zone = get_target_zone()
	var/list/available_attacks = get_mob_natural_attacks()
	var/decl/natural_attack/use_attack = default_attack
	if(!use_attack || !use_attack.attack_is_usable(src, target, hit_zone) || !(use_attack in available_attacks))
		var/alert_non_default_attack = use_attack?.name
		use_attack = null
		var/list/other_attacks = list()
		for(var/decl/natural_attack/u_attack as anything in available_attacks)
			if(!u_attack.attack_is_usable(src, target, hit_zone))
				continue
			if(u_attack.is_starting_default)
				use_attack = u_attack
				break
			other_attacks += u_attack
		if(!use_attack && length(other_attacks))
			use_attack = pick(other_attacks)
		if(use_attack && alert_non_default_attack)
			to_chat(src, SPAN_WARNING("You cannot [alert_non_default_attack] \the [target] currently, so you switch attacks."))

	. = use_attack?.resolve_to_soft_variant(src)

/obj/item/organ/external/proc/get_natural_attacks()
	return null

/obj/item/organ/external/proc/get_injury_status(include_pain = TRUE, include_visible = TRUE)
	. = list()
	if(include_pain && can_feel_pain())
		var/feels = 1 + round(get_pain()/100, 0.1)
		var/feels_brute = brute_dam * feels
		if(feels_brute > 0)
			switch(feels_brute / max_damage)
				if(0 to 0.35)
					. += "slightly sore"
				if(0.35 to 0.65)
					. += "very sore"
				if(0.65 to INFINITY)
					. += "throbbing with agony"

		var/feels_burn = burn_dam * feels
		if(feels_burn > 0)
			switch(feels_burn / max_damage)
				if(0 to 0.35)
					. += "tingling"
				if(0.35 to 0.65)
					. += "stinging"
				if(0.65 to INFINITY)
					. += "burning fiercely"

		if(status & ORGAN_BROKEN)
			. += "painful to the touch"

	if(include_visible && !owner?.is_blind())
		if(status & ORGAN_MUTATED)
			. += "misshapen"
		if(status & ORGAN_BLEEDING)
			. += "<b>bleeding</b>"
		if(is_dislocated())
			. += "dislocated"
		if(status & ORGAN_DEAD)
			if(BP_IS_PROSTHETIC(src) || BP_IS_CRYSTAL(src))
				. += "irrecoverably damaged"
			else
				. += "grey and necrotic"
		else if((brute_dam + burn_dam) >= max_damage && germ_level >= INFECTION_LEVEL_TWO)
			. += "likely beyond saving and decay has set in"

	if(!is_usable() || is_dislocated()) // This one is special and has a different message for visible/pain modes.
		. += (!include_visible || owner?.is_blind()) ? "completely limp" : "dangling uselessly"

/mob/living/human/proc/check_self_injuries(include_pain = TRUE, include_visible = TRUE)
	if(include_visible)
		var/decl/pronouns/pronouns = get_pronouns()
		visible_message(
			SPAN_NOTICE("\The [src] examines [pronouns.self]."),
			SPAN_NOTICE("You check yourself for injuries.")
		)
	else if(include_pain)
		to_chat(src, SPAN_NOTICE("You take note of how your body feels..."))
	else
		return // This should never happen, we should always check pain, visible status, or both.

	// TODO: move status strings onto the bodytype and handle crystal/prosthetic limbs.
	for(var/obj/item/organ/external/org in get_external_organs())
		var/list/status = org.get_injury_status(include_pain, include_visible)
		if(length(status))
			to_chat(src, "Your [org.name] is <span class='warning'>[english_list(status)].</span>")
		else if(is_blind() || !include_visible)
			to_chat(src, "You <span class='notice'>can't feel anything wrong</span> with your [org.name].")
		else if(!include_pain)
			to_chat(src, "You <span class='notice'>can't see anything wrong</span> with your [org.name].")
		else
			to_chat(src, "Your [org.name] is <span class='notice'>OK.</span>")

/mob/living/human/default_help_interaction(mob/user)
	if(apply_pressure(user, user.get_target_zone()))
		return TRUE
	if(user == src)
		check_self_injuries()
		return TRUE
	if(ishuman(user) && (is_asystole() || (status_flags & FAKEDEATH) || failed_last_breath) && !is_on_fire() && !(user.get_target_zone() == BP_R_ARM || user.get_target_zone() == BP_L_ARM))
		if (performing_cpr)
			performing_cpr = FALSE
		else
			performing_cpr = TRUE
			start_compressions(user, TRUE)
		return TRUE
	return ..()

/mob/living/human/default_disarm_interaction(mob/user)
	var/decl/species/user_species = user.get_species()
	if(user_species)
		admin_attack_log(user, src, "Disarmed their victim.", "Was disarmed.", "disarmed")
		user_species.disarm_attackhand(user, src)
		return TRUE
	. = ..()

/mob/living/human/default_hurt_interaction(mob/user)
	. = ..()
	if(.)
		return TRUE

	if(user.incapacitated())
		to_chat(user, SPAN_WARNING("You can't attack while incapacitated."))
		return TRUE

	if(!ishuman(user))
		attack_generic(user, rand(1,3), "punched")
		return TRUE

	var/mob/living/human/H = user
	var/rand_damage = rand(1, 5)
	var/block = 0
	var/accurate = 0
	var/hit_zone = H.get_target_zone()
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(src, hit_zone)

	// See what attack they use
	var/decl/natural_attack/attack = H.get_unarmed_attack(src, hit_zone)
	if(!attack)
		return TRUE

	if(world.time < H.last_attack + attack.delay)
		to_chat(H, SPAN_NOTICE("You can't attack again so soon."))
		return TRUE

	last_handled_by_mob = weakref(H)
	H.last_attack = world.time

	if(!affecting)
		to_chat(user, SPAN_DANGER("They are missing that limb!"))
		return TRUE

	// We didn't see this coming, so we get the full blow
	if(check_intent(I_FLAG_HELP))
		rand_damage = 5
		accurate = 1
	// We're in a fighting stance, there's a chance we block
	else if(check_intent(I_FLAG_HARM|I_FLAG_GRAB) && MayMove() && src != H && prob(20))
		block = 1

	if (LAZYLEN(user.grabbed_by))
		// Someone got a good grip on them, they won't be able to do much damage
		rand_damage = max(1, rand_damage - 2)

	if(LAZYLEN(grabbed_by) || !src.MayMove() || src==H || H.species.species_flags & SPECIES_FLAG_NO_BLOCK)
		accurate = 1 // certain circumstances make it impossible for us to evade punches
		rand_damage = 5

	// Process evasion and blocking
	var/miss_type = 0
	var/attack_message
	if(!accurate)
		/* ~Hubblenaut
			This place is kind of convoluted and will need some explaining.
			ran_zone() will pick out of 11 zones, thus the chance for hitting
			our target where we want to hit them is circa 9.1%.
			Now since we want to statistically hit our target organ a bit more
			often than other organs, we add a base chance of 20% for hitting it.
			This leaves us with the following chances:
			If aiming for chest:
				27.3% chance you hit your target organ
				70.5% chance you hit a random other organ
				 2.2% chance you miss
			If aiming for something else:
				23.2% chance you hit your target organ
				56.8% chance you hit a random other organ
				15.0% chance you miss
			Note: We don't use get_zone_with_miss_chance() here since the chances
				  were made for projectiles.
			TODO: proc for melee combat miss chances depending on organ?
		*/
		if(prob(80))
			hit_zone = ran_zone(hit_zone, target = src)
		if(prob(15) && hit_zone != BP_CHEST) // Missed!
			if(!src.current_posture.prone)
				attack_message = "\The [H] attempted to strike \the [src], but missed!"
			else
				var/decl/pronouns/pronouns = get_pronouns()
				attack_message = "\The [H] attempted to strike \the [src], but [pronouns.he] rolled out of the way!"
				src.set_dir(pick(global.cardinal))
			miss_type = 1

	if(!miss_type && block)
		attack_message = "[H] went for [src]'s [affecting.name] but was blocked!"
		miss_type = 2

	H.do_attack_animation(src)
	if(!attack_message)
		attack.show_attack(H, src, hit_zone, rand_damage)
	else
		H.visible_message(SPAN_DANGER("[attack_message]"))

	playsound(loc, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)
	admin_attack_log(H, src, "[miss_type ? (miss_type == 1 ? "Has missed" : "Was blocked by") : "Has [pick(attack.attack_verb)]"] their victim.", "[miss_type ? (miss_type == 1 ? "Missed" : "Blocked") : "[pick(attack.attack_verb)]"] their attacker", "[miss_type ? (miss_type == 1 ? "has missed" : "was blocked by") : "has [pick(attack.attack_verb)]"]")

	if(miss_type)
		return TRUE

	var/real_damage = rand_damage
	real_damage += attack.get_unarmed_damage(H, src)
	real_damage *= damage_multiplier
	rand_damage *= damage_multiplier
	real_damage = max(1, real_damage)
	// Apply additional unarmed effects.
	attack.apply_attack_effects(H, src, rand_damage, hit_zone)
	// Finally, apply damage to target
	apply_damage(real_damage, attack.get_damage_type(), hit_zone, damage_flags=attack.damage_flags())
	if(attack.apply_cooldown)
		H.setClickCooldown(attack.apply_cooldown)

	if(istype(ai))
		ai.retaliate(user)
	return TRUE

/mob/living/human/attack_hand(mob/user)

	remove_mob_modifier(/decl/mob_modifier/cloaked, source = species)
	if(!user.check_intent(I_FLAG_GRAB))
		for (var/obj/item/grab/grab as anything in user.get_active_grabs())
			if(grab.assailant == user && grab.affecting == src && grab.resolve_openhand_attack())
				return TRUE
	// Should this all be in Touch()?
		if(ishuman(user) && user != src && check_shields(0, null, user, user.get_target_zone(), user))
			user.do_attack_animation(src)
			return TRUE

	return ..()

/mob/living/human/proc/start_compressions(mob/living/human/H, starting = FALSE, cpr_mode)
	if(length(H.get_held_items()))
		performing_cpr = FALSE
		to_chat(H, SPAN_WARNING("You cannot perform CPR with anything in your hands."))
		return

	//Keeps doing CPR unless cancelled, or the target recovers
	if(!(performing_cpr && H.Adjacent(src) && (is_asystole() || (status_flags & FAKEDEATH) || failed_last_breath)))
		performing_cpr = FALSE
		to_chat(H, SPAN_NOTICE("You stop performing CPR on \the [src]."))
		return

	else if (starting)
		var/list/options = list(
			"Compressions" = image('icons/screen/radial.dmi', "cpr"),
			"Mouth-to-Mouth" = image('icons/screen/radial.dmi', "cpr_o2")
		)
		cpr_mode = show_radial_menu(H, src, options, require_near = TRUE, tooltips = TRUE, no_repeat_close = TRUE)
		if(!cpr_mode)
			performing_cpr = FALSE
			return

		if(length(H.get_held_items()))
			performing_cpr = FALSE
			to_chat(H, SPAN_WARNING("You cannot perform CPR with anything in your hands."))
			return

		H.visible_message(SPAN_NOTICE("\The [H] is trying to perform CPR on \the [src]."))

	var/pumping_skill = max(H.get_skill_value(SKILL_MEDICAL), H.get_skill_value(SKILL_ANATOMY))
	var/cpr_delay = 15 * H.skill_delay_mult(SKILL_ANATOMY, 0.2)

	H.visible_message(SPAN_NOTICE("\The [H] performs CPR on \the [src]!"))

	H.do_attack_animation(src, null)
	var/starting_pixel_y = pixel_y
	animate(src, pixel_y = starting_pixel_y + 4, time = 2)
	animate(src, pixel_y = starting_pixel_y, time = 2)

	if(is_asystole())
		if(prob(5 + 5 * (SKILL_EXPERT - pumping_skill)))
			var/obj/item/organ/external/chest = GET_EXTERNAL_ORGAN(src, BP_CHEST)
			if(chest)
				chest.fracture()

		var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
		if(heart)
			heart.external_pump = list(world.time, 0.4 + 0.1*pumping_skill + rand(-0.1,0.1))

		if(stat != DEAD && prob(10 + 5 * pumping_skill))
			resuscitate()

	if(!do_after(H, cpr_delay, FALSE)) //Chest compresssions are fast, need to wait for the loading bar to do mouth to mouth
		to_chat(H, SPAN_NOTICE("You stop performing CPR on \the [src]."))
		performing_cpr = FALSE //If it cancelled, cancel it. Simple.
		return

	if(cpr_mode == "Mouth-to-Mouth")
		if(!H.check_has_mouth())
			to_chat(H, SPAN_WARNING("You don't have a mouth, you cannot do mouth-to-mouth resuscitation!"))
			return TRUE

		if(!check_has_mouth())
			to_chat(H, SPAN_WARNING("They don't have a mouth, you cannot do mouth-to-mouth resuscitation!"))
			return TRUE

		for(var/slot in global.airtight_slots)
			var/obj/item/gear = H.get_equipped_item(slot)
			if(gear && (gear.body_parts_covered & SLOT_FACE))
				to_chat(H, SPAN_WARNING("You need to remove your mouth covering for mouth-to-mouth resuscitation!"))
				return TRUE

		for(var/slot in global.airtight_slots)
			var/obj/item/gear = get_equipped_item(slot)
			if(gear && (gear.body_parts_covered & SLOT_FACE))
				to_chat(H, SPAN_WARNING("You need to remove \the [src]'s mouth covering for mouth-to-mouth resuscitation!"))
				return TRUE

		var/decl/bodytype/root_bodytype = H.get_bodytype()
		if(!GET_INTERNAL_ORGAN(H, root_bodytype.breathing_organ))
			to_chat(H, SPAN_WARNING("You need lungs for mouth-to-mouth resuscitation!"))
			return TRUE

		if(!need_breathe())
			return TRUE

		var/obj/item/organ/internal/lungs/lungs = get_organ(root_bodytype.breathing_organ, /obj/item/organ/internal/lungs)
		if(!lungs)
			return

		if(!lungs.handle_owner_breath(H.get_breath_from_environment(), 1))
			if(!lungs.is_bruised())
				suffocation_counter = 0
			to_chat(src, SPAN_NOTICE("You feel a breath of fresh air enter your lungs. It feels good."))

	// Again.
	start_compressions(H, FALSE, cpr_mode)

//Breaks all grips and pulls that the mob currently has.
/mob/living/human/proc/break_all_grabs(mob/living/user)
	. = FALSE
	for(var/obj/item/grab/grab as anything in get_active_grabs())
		if(grab.affecting)
			visible_message(SPAN_DANGER("\The [user] has broken \the [src]'s grip on [grab.affecting]!"))
			. = TRUE
		drop_from_inventory(grab)

/*
	We want to ensure that a mob may only apply pressure to one organ of one mob at any given time. Currently this is done mostly implicitly through
	the behaviour of do_after() and the fact that applying pressure to someone else requires a grab:

	If you are applying pressure to yourself and attempt to grab someone else, you'll change what you are holding in your active hand which will stop do_mob()
	If you are applying pressure to another and attempt to apply pressure to yourself, you'll have to switch to an empty hand which will also stop do_mob()
	Changing targeted zones should also stop do_mob(), preventing you from applying pressure to more than one body part at once.
*/
/mob/living/human/proc/apply_pressure(mob/living/user, var/target_zone)
	var/obj/item/organ/external/organ = GET_EXTERNAL_ORGAN(src, target_zone)
	if(!organ || !(organ.status & (ORGAN_BLEEDING|ORGAN_ARTERY_CUT)) || BP_IS_PROSTHETIC(organ))
		return 0

	if(organ.applied_pressure)
		var/message = "<span class='warning'>[ismob(organ.applied_pressure)? "Someone" : "\A [organ.applied_pressure]"] is already applying pressure to [user == src? "your [organ.name]" : "[src]'s [organ.name]"].</span>"
		to_chat(user, message)
		return 0

	if(user == src)
		var/decl/pronouns/pronouns = user.get_pronouns()
		user.visible_message( \
			SPAN_NOTICE("\The [user] starts applying pressure to [pronouns.his] [organ.name]!"), \
			SPAN_NOTICE("You start applying pressure to your [organ.name]!"))
	else
		user.visible_message( \
			SPAN_NOTICE("\The [user] starts applying pressure to \the [src]'s [organ.name]!"), \
			SPAN_NOTICE("You start applying pressure to \the [src]'s [organ.name]!"))
	// TODO: refactor applying pressure to use grabs instead? would probably require making grabs locked to the zone they were started on
	spawn(0)
		organ.applied_pressure = user

		//apply pressure as long as they stay still and keep grabbing
		do_mob(user, src, INFINITY, target_zone, progress = 0)

		organ.applied_pressure = null

		if(user == src)
			var/decl/pronouns/pronouns = user.get_pronouns()
			user.visible_message( \
				SPAN_NOTICE("\The [user] stops applying pressure to [pronouns.his] [organ.name]!"), \
				SPAN_NOTICE("You stop applying pressure to your [organ.name]!"))
		else
			user.visible_message( \
				SPAN_NOTICE("\The [user] stops applying pressure to \the [src]'s [organ.name]!"), \
				SPAN_NOTICE("You stop applying pressure to \the [src]'s [organ.name]!"))

	return 1

/mob/living/human/verb/set_default_unarmed_attack()

	set name = "Set Default Unarmed Attack"
	set category = "IC"
	set src = usr

	var/list/choices
	for(var/decl/natural_attack/u_attack as anything in get_mob_natural_attacks())
		var/image/radial_button = new
		radial_button.name = capitalize(u_attack.name)
		LAZYSET(choices, u_attack, radial_button)
	var/decl/natural_attack/new_attack = show_radial_menu(src, src, choices, radius = 42, use_labels = RADIAL_LABELS_OFFSET)
	if(QDELETED(src) || !istype(new_attack) || !(new_attack in get_mob_natural_attacks()))
		return
	default_attack = new_attack
	to_chat(src, SPAN_NOTICE("Your default unarmed attack is now <b>[default_attack?.name || "cleared"]</b>."))
	if(default_attack)
		var/summary = default_attack.summarize()
		if(summary)
			to_chat(src, SPAN_NOTICE(summary))
	refresh_hud_element(HUD_ATTACK)

/mob/living/human/ResolveUnarmedAttack(atom/A)
	// Hackfix for humans trying to attack someone without hands.
	// Dexterity ect. should be checked in these procs regardless,
	// but unarmed attacks that don't require hands should still
	// have the ability to be used.
	if(!(. = ..()) && !get_active_held_item_slot() && check_intent(I_FLAG_HARM) && isliving(A))
		var/mob/living/victim = A
		return victim.default_hurt_interaction(src)
