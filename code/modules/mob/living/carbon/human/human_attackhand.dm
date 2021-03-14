/mob/living/carbon/human/proc/get_unarmed_attack(var/mob/target, var/hit_zone = null)
	if(!hit_zone)
		hit_zone = zone_sel.selecting
	var/list/available_attacks = get_natural_attacks()
	var/decl/natural_attack/use_attack = default_attack
	if(!use_attack || !use_attack.is_usable(src, target, hit_zone) || !(use_attack.type in available_attacks))
		use_attack = null
		var/list/other_attacks = list()
		for(var/u_attack_type in available_attacks)
			var/decl/natural_attack/u_attack = GET_DECL(u_attack_type)
			if(!u_attack.is_usable(src, target, hit_zone))
				continue
			if(u_attack.is_starting_default)
				use_attack = u_attack
				break
			other_attacks += u_attack
		if(!use_attack && length(other_attacks))
			use_attack = pick(other_attacks)
	. = use_attack?.resolve_to_soft_variant(src)

/mob/living/carbon/human/proc/get_natural_attacks()
	. = list()
	for(var/obj/item/organ/external/limb in organs)
		if(length(limb.unarmed_attacks) && limb.is_usable())
			. |= limb.unarmed_attacks

/mob/living/carbon/human/attack_hand(mob/user)

	remove_cloaking_source(species)

	// Grabs are handled at a lower level.
	if(user.a_intent == I_GRAB)
		return ..()

	// Should this all be in Touch()?
	var/mob/living/carbon/human/H = user
	if(istype(H))
		if(H != src && check_shields(0, null, H, H.zone_sel.selecting, H.name))
			H.do_attack_animation(src)
			return TRUE

		for (var/obj/item/grab/G in H)
			if (G.assailant == H && G.affecting == src)
				if(G.resolve_openhand_attack())
					return TRUE

	switch(user.a_intent)
		if(I_HELP)
			if(H != src && istype(H) && (is_asystole() || (status_flags & FAKEDEATH) || failed_last_breath) && !(H.zone_sel.selecting == BP_R_ARM || H.zone_sel.selecting == BP_L_ARM))
				if (!cpr_time)
					return TRUE

				var/pumping_skill = max(user.get_skill_value(SKILL_MEDICAL), user.get_skill_value(SKILL_ANATOMY))
				var/cpr_delay = 15 * user.skill_delay_mult(SKILL_ANATOMY, 0.2)
				cpr_time = 0

				H.visible_message("<span class='notice'>\The [H] is trying to perform CPR on \the [src].</span>")

				if(!do_after(H, cpr_delay, src))
					cpr_time = 1
					return TRUE
				cpr_time = 1

				H.visible_message("<span class='notice'>\The [H] performs CPR on \the [src]!</span>")

				if(is_asystole())
					if(prob(5 + 5 * (SKILL_EXPERT - pumping_skill)))
						var/obj/item/organ/external/chest = get_organ(BP_CHEST)
						if(chest)
							chest.fracture()

					var/obj/item/organ/internal/heart/heart = get_internal_organ(BP_HEART)
					if(heart)
						heart.external_pump = list(world.time, 0.4 + 0.1*pumping_skill + rand(-0.1,0.1))

					if(stat != DEAD && prob(10 + 5 * pumping_skill))
						resuscitate()

				if(!H.check_has_mouth())
					to_chat(H, "<span class='warning'>You don't have a mouth, you cannot do mouth-to-mouth resuscitation!</span>")
					return TRUE
				if(!check_has_mouth())
					to_chat(H, "<span class='warning'>They don't have a mouth, you cannot do mouth-to-mouth resuscitation!</span>")
					return TRUE
				if((H.head && (H.head.body_parts_covered & SLOT_FACE)) || (H.wear_mask && (H.wear_mask.body_parts_covered & SLOT_FACE)))
					to_chat(H, "<span class='warning'>You need to remove your mouth covering for mouth-to-mouth resuscitation!</span>")
					return TRUE
				if((head && (head.body_parts_covered & SLOT_FACE)) || (wear_mask && (wear_mask.body_parts_covered & SLOT_FACE)))
					to_chat(H, "<span class='warning'>You need to remove \the [src]'s mouth covering for mouth-to-mouth resuscitation!</span>")
					return TRUE
				if (!H.get_internal_organ(H.species.breathing_organ))
					to_chat(H, "<span class='danger'>You need lungs for mouth-to-mouth resuscitation!</span>")
					return TRUE
				if(!need_breathe())
					return TRUE
				var/obj/item/organ/internal/lungs/L = get_internal_organ(species.breathing_organ)
				if(L)
					var/datum/gas_mixture/breath = H.get_breath_from_environment()
					var/fail = L.handle_breath(breath, 1)
					if(!fail)
						if (!L.is_bruised())
							losebreath = 0
						to_chat(src, "<span class='notice'>You feel a breath of fresh air enter your lungs. It feels good.</span>")

			else if(!(user == src && apply_pressure(user, user.zone_sel.selecting)))
				help_shake_act(user)
			return TRUE

		if(I_HURT)
			if(H.incapacitated())
				to_chat(H, "<span class='notice'>You can't attack while incapacitated.</span>")
				return TRUE

			if(!istype(H))
				attack_generic(H,rand(1,3),"punched")
				return TRUE

			var/rand_damage = rand(1, 5)
			var/block = 0
			var/accurate = 0
			var/hit_zone = H.zone_sel.selecting
			var/obj/item/organ/external/affecting = get_organ(hit_zone)

			// See what attack they use
			var/decl/natural_attack/attack = H.get_unarmed_attack(src, hit_zone)
			if(!attack)
				return TRUE
			if(world.time < H.last_attack + attack.delay)
				to_chat(H, "<span class='notice'>You can't attack again so soon.</span>")
				return TRUE
			else
				last_handled_by_mob = weakref(H)
				H.last_attack = world.time

			if(!affecting || affecting.is_stump())
				to_chat(user, "<span class='danger'>They are missing that limb!</span>")
				return TRUE

			switch(src.a_intent)
				if(I_HELP)
					// We didn't see this coming, so we get the full blow
					rand_damage = 5
					accurate = 1
				if(I_HURT, I_GRAB)
					// We're in a fighting stance, there's a chance we block
					if(MayMove() && src!=H && prob(20))
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
					if(!src.lying)
						attack_message = "[H] attempted to strike [src], but missed!"
					else
						attack_message = "[H] attempted to strike [src], but \he rolled out of the way!"
						src.set_dir(pick(GLOB.cardinal))
					miss_type = 1

			if(!miss_type && block)
				attack_message = "[H] went for [src]'s [affecting.name] but was blocked!"
				miss_type = 2

			H.do_attack_animation(src)
			if(!attack_message)
				attack.show_attack(H, src, hit_zone, rand_damage)
			else
				H.visible_message("<span class='danger'>[attack_message]</span>")

			playsound(loc, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)
			admin_attack_log(H, src, "[miss_type ? (miss_type == 1 ? "Has missed" : "Was blocked by") : "Has [pick(attack.attack_verb)]"] their victim.", "[miss_type ? (miss_type == 1 ? "Missed" : "Blocked") : "[pick(attack.attack_verb)]"] their attacker", "[miss_type ? (miss_type == 1 ? "has missed" : "was blocked by") : "has [pick(attack.attack_verb)]"]")

			if(miss_type)
				return TRUE

			var/real_damage = rand_damage
			real_damage += attack.get_unarmed_damage(H)
			real_damage *= damage_multiplier
			rand_damage *= damage_multiplier
			if(MUTATION_HULK in H.mutations)
				real_damage *= 2 // Hulks do twice the damage
				rand_damage *= 2
			real_damage = max(1, real_damage)
			// Apply additional unarmed effects.
			attack.apply_effects(H, src, rand_damage, hit_zone)
			// Finally, apply damage to target
			apply_damage(real_damage, attack.get_damage_type(), hit_zone, damage_flags=attack.damage_flags())
			return TRUE

		if(I_DISARM)
			if(H.species)
				admin_attack_log(user, src, "Disarmed their victim.", "Was disarmed.", "disarmed")
				H.species.disarm_attackhand(H, src)
				return TRUE
	. = ..()

/mob/living/carbon/human/proc/afterattack(atom/target, mob/living/user, inrange, params)
	return

//Breaks all grips and pulls that the mob currently has.
/mob/living/carbon/human/proc/break_all_grabs(mob/living/carbon/user)
	. = FALSE
	for(var/obj/item/grab/grab in get_active_grabs())
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
/mob/living/carbon/human/proc/apply_pressure(mob/living/user, var/target_zone)
	var/obj/item/organ/external/organ = get_organ(target_zone)
	if(!organ || !(organ.status & ORGAN_BLEEDING) || BP_IS_PROSTHETIC(organ))
		return 0

	if(organ.applied_pressure)
		var/message = "<span class='warning'>[ismob(organ.applied_pressure)? "Someone" : "\A [organ.applied_pressure]"] is already applying pressure to [user == src? "your [organ.name]" : "[src]'s [organ.name]"].</span>"
		to_chat(user, message)
		return 0

	if(user == src)
		user.visible_message("\The [user] starts applying pressure to \his [organ.name]!", "You start applying pressure to your [organ.name]!")
	else
		user.visible_message("\The [user] starts applying pressure to [src]'s [organ.name]!", "You start applying pressure to [src]'s [organ.name]!")
	spawn(0)
		organ.applied_pressure = user

		//apply pressure as long as they stay still and keep grabbing
		do_mob(user, src, INFINITY, target_zone, progress = 0)

		organ.applied_pressure = null

		if(user == src)
			user.visible_message("\The [user] stops applying pressure to \his [organ.name]!", "You stop applying pressure to your [organ.name]!")
		else
			user.visible_message("\The [user] stops applying pressure to [src]'s [organ.name]!", "You stop applying pressure to [src]'s [organ.name]!")

	return 1

/mob/living/carbon/human/verb/set_default_unarmed_attack()
	set name = "Set Default Unarmed Attack"
	set category = "IC"
	set src = usr
	var/list/choices
	for(var/thing in get_natural_attacks())
		var/decl/natural_attack/u_attack = GET_DECL(thing)
		if(istype(u_attack))
			var/image/radial_button = new
			radial_button.name = capitalize(u_attack.name)
			LAZYSET(choices, u_attack, radial_button)
	var/decl/natural_attack/new_attack = show_radial_menu(src, src, choices, radius = 42, use_labels = TRUE)
	if(QDELETED(src) || !istype(new_attack) || !(new_attack.type in get_natural_attacks()))
		return
	default_attack = new_attack
	to_chat(src, SPAN_NOTICE("Your default unarmed attack is now <b>[default_attack?.name || "cleared"]</b>."))
	if(default_attack)
		var/summary = default_attack.summarize()
		if(summary)
			to_chat(src, SPAN_NOTICE(summary))
	attack_selector?.update_icon()