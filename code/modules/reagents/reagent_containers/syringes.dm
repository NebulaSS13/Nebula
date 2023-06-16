////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/chems/syringe
	name = "syringe"
	base_name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/syringe.dmi'
	item_state = "rg0"
	icon_state = "rg"
	material = /decl/material/solid/glass
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = @"[1,2,5]"
	volume = 15
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	sharp = 1
	unacidable = 1 //glass
	item_flags = ITEM_FLAG_NO_BLUDGEON
	var/mode = SYRINGE_DRAW
	var/image/filling //holds a reference to the current filling overlay
	var/visible_name = "a syringe"
	var/time = 30

/obj/item/chems/syringe/Initialize(var/mapload)
	. = ..()
	update_icon()

/obj/item/chems/syringe/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/chems/syringe/on_picked_up(mob/user)
	. = ..()
	update_icon()

/obj/item/chems/syringe/dropped(mob/user)
	. = ..()
	update_icon()

/obj/item/chems/syringe/attack_self(mob/user)
	switch(mode)
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/chems/syringe/attack_hand()
	. = ..()
	update_icon()

/obj/item/chems/syringe/attackby(obj/item/I, mob/user)
	return

/obj/item/chems/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, SPAN_WARNING("This syringe is broken."))
		return

	if(istype(target, /obj/structure/closet/body_bag))
		handleBodyBag(target, user)
		return

	if(!target.reagents)
		return

	if((user.a_intent == I_HURT) && ismob(target))
		syringestab(target, user)
		return

	handleTarget(target, user)

/obj/item/chems/syringe/on_update_icon()
	. = ..()
	underlays.Cut()

	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return

	var/rounded_vol = clamp(round((reagents.total_volume / volume * 15),5), 5, 15)
	if (reagents.total_volume == 0)
		rounded_vol = 0
	if(ismob(loc))
		add_overlay((mode == SYRINGE_DRAW)? "draw" : "inject")
	icon_state = "[initial(icon_state)][rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		filling = image('icons/obj/reagentfillings.dmi', src, "syringe10")

		filling.icon_state = "syringe[rounded_vol]"

		filling.color = reagents.get_color()
		underlays += filling

/obj/item/chems/syringe/proc/handleTarget(var/atom/target, var/mob/user)
	switch(mode)
		if(SYRINGE_DRAW)
			drawReagents(target, user)

		if(SYRINGE_INJECT)
			injectReagents(target, user)

/obj/item/chems/syringe/proc/drawReagents(var/atom/target, var/mob/user)
	if(!REAGENTS_FREE_SPACE(reagents))
		to_chat(user, SPAN_WARNING("The syringe is full."))
		mode = SYRINGE_INJECT
		return

	if(ismob(target))//Blood!
		if(reagents.total_volume)
			to_chat(user, SPAN_NOTICE("There is already a blood sample in this syringe."))
			return
		if(istype(target, /mob/living/carbon))
			var/amount = REAGENTS_FREE_SPACE(reagents)
			var/mob/living/carbon/T = target
			if(!T.dna)
				to_chat(user, SPAN_WARNING("You are unable to locate any blood."))
				if(istype(target, /mob/living/carbon/human))
					CRASH("[T] \[[T.type]\] was missing their dna datum!")
				return

			var/allow = T.can_inject(user, check_zone(user.get_target_zone(), T))
			if(!allow)
				return

			if(allow == INJECTION_PORT) // Taking a blood sample through a hardsuit takes longer due to needing to find a port first.
				if(target != user)
					user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [target]'s suit!"))
				else
					to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
				if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, target))
					return

			if(target != user)
				user.visible_message(SPAN_WARNING("\The [user] is trying to take a blood sample from \the [target]."))
			else
				to_chat(user, SPAN_NOTICE("You start trying to take a blood sample from yourself."))

			if(prob(user.skill_fail_chance(SKILL_MEDICAL, 60, SKILL_BASIC)))
				to_chat(user, SPAN_WARNING("You miss the vein!"))
				var/target_zone = check_zone(user.get_target_zone(), T)
				T.apply_damage(3, BRUTE, target_zone, damage_flags=DAM_SHARP)
				return

			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(target)

			if(!user.do_skilled(time, SKILL_MEDICAL, target))
				return

			T.take_blood(src, amount)
			user.visible_message(SPAN_NOTICE("\The [user] takes a blood sample from \the [target]."))

	else //if not mob
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[target] is empty."))
			return

		if(!ATOM_IS_OPEN_CONTAINER(target) && !istype(target, /obj/structure/reagent_dispensers))
			to_chat(user, SPAN_NOTICE("You cannot directly remove reagents from this object."))
			return

		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You fill the syringe with [trans] units of the solution."))
		update_icon()

	if(!REAGENTS_FREE_SPACE(reagents))
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/chems/syringe/proc/injectReagents(var/atom/target, var/mob/user)

	if(ismob(target) && !user.skill_check(SKILL_MEDICAL, SKILL_BASIC))
		syringestab(target, user)
		return

	if(!reagents.total_volume)
		to_chat(user, SPAN_NOTICE("The syringe is empty."))
		mode = SYRINGE_DRAW
		return
	if(istype(target, /obj/item/implantcase/chem))
		return

	if(!ATOM_IS_OPEN_CONTAINER(target) && !ismob(target) && !istype(target, /obj/item/chems/food) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/storage/fancy/cigarettes))
		to_chat(user, SPAN_NOTICE("You cannot directly fill this object."))
		return
	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return

	if(isliving(target))
		injectMob(target, user)
		return

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	to_chat(user, SPAN_NOTICE("You inject \the [target] with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."))
	if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
		mode = SYRINGE_DRAW
		update_icon()

/obj/item/chems/syringe/proc/handleBodyBag(var/obj/structure/closet/body_bag/bag, var/mob/living/carbon/user)
	if(bag.opened || !bag.contains_body)
		return

	var/mob/living/L = locate() in bag
	if(L)
		injectMob(L, user, bag)

/obj/item/chems/syringe/proc/injectMob(var/mob/living/carbon/target, var/mob/living/carbon/user, var/atom/trackTarget)
	if(!trackTarget)
		trackTarget = target

	var/allow = target.can_inject(user, check_zone(user.get_target_zone(), target))
	if(!allow)
		return

	if(allow == INJECTION_PORT) // Injecting through a hardsuit takes longer due to needing to find a port first.
		if(target != user)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [target]'s suit!"))
		else
			to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
		if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, trackTarget))
			return

	if(target != user)
		user.visible_message(SPAN_WARNING("\The [user] is trying to inject \the [target] with [visible_name]!"))
	else
		to_chat(user, SPAN_NOTICE("You begin injecting yourself with [visible_name]."))

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(trackTarget)

	if(!user.do_skilled(time, SKILL_MEDICAL, trackTarget))
		return

	if(target != user && target != trackTarget && target.loc != trackTarget)
		return
	admin_inject_log(user, target, src, reagents.get_reagents(), amount_per_transfer_from_this)
	var/trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INJECT)

	if(target != user)
		user.visible_message(SPAN_WARNING("\the [user] injects \the [target] with [visible_name]!"), SPAN_NOTICE("You inject \the [target] with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."))
	else
		to_chat(user, SPAN_NOTICE("You inject yourself with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units."))

	if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
		mode = SYRINGE_DRAW
		update_icon()

/obj/item/chems/syringe/proc/syringestab(var/mob/living/carbon/target, var/mob/living/carbon/user)

	if(istype(target, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = target

		var/target_zone = check_zone(user.get_target_zone(), H)
		var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, target_zone)

		if (!affecting)
			to_chat(user, SPAN_DANGER("They are missing that limb!"))
			return

		var/hit_area = affecting.name

		if((user != target) && H.check_shields(7, src, user, "\the [src]"))
			return

		if (target != user && H.get_blocked_ratio(target_zone, BRUTE, damage_flags=DAM_SHARP) > 0.1 && prob(50))
			user.visible_message(SPAN_WARNING("\The [user] tries to stab \the [target] in \the [hit_area] with \the [src], but the attack is deflected by armor!"))
			qdel(src)

			admin_attack_log(user, target, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")
			return

		user.visible_message(SPAN_DANGER("[user] stabs [target] in \the [hit_area] with [src.name]!"))
		target.apply_damage(3, BRUTE, target_zone, damage_flags=DAM_SHARP)

	else
		user.visible_message(SPAN_DANGER("[user] stabs [target] with [src.name]!"))
		target.apply_damage(3, BRUTE)

	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	var/contained_reagents = reagents.get_reagents()
	var/trans = reagents.trans_to_mob(target, syringestab_amount_transferred, CHEM_INJECT)
	if(isnull(trans)) trans = 0
	admin_inject_log(user, target, src, contained_reagents, trans, violent=1)
	break_syringe(target, user)

/obj/item/chems/syringe/proc/break_syringe(mob/living/carbon/target, mob/living/carbon/user)
	desc += " It is broken."
	mode = SYRINGE_BROKEN
	if(target)
		add_blood(target)
	if(user)
		add_fingerprint(user)
	update_icon()

/obj/item/chems/syringe/ld50_syringe
	name = "lethal injection syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 60
	volume = 60
	visible_name = "a giant syringe"
	time = 300
	mode = SYRINGE_INJECT

/obj/item/chems/syringe/ld50_syringe/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/heartstopper, reagents.maximum_volume)

/obj/item/chems/syringe/ld50_syringe/syringestab(var/mob/living/carbon/target, var/mob/living/carbon/user)
	to_chat(user, SPAN_NOTICE("This syringe is too big to stab someone with it."))
	return // No instant injecting

/obj/item/chems/syringe/ld50_syringe/drawReagents(var/target, var/mob/user)
	if(ismob(target)) // No drawing 60 units of blood at once
		to_chat(user, SPAN_NOTICE("This needle isn't designed for drawing blood."))
		return
	..()

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/chems/syringe/stabilizer
	name = "syringe (stabilizer)"
	desc = "Contains stabilizer - for patients in danger of brain damage."
	mode = SYRINGE_INJECT

/obj/item/chems/syringe/stabilizer/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/stabilizer, reagents.maximum_volume)

/obj/item/chems/syringe/antitoxin
	name = "syringe (anti-toxin)"
	desc = "Contains anti-toxins."
	mode = SYRINGE_INJECT

/obj/item/chems/syringe/antitoxin/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antitoxins, reagents.maximum_volume)

/obj/item/chems/syringe/antibiotic
	name = "syringe (antibiotics)"
	desc = "Contains antibiotic agents."
	mode = SYRINGE_INJECT

/obj/item/chems/syringe/antibiotic/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/antibiotics, reagents.maximum_volume)

/obj/item/chems/syringe/drugs
	name = "syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."
	mode = SYRINGE_INJECT

/obj/item/chems/syringe/drugs/populate_reagents()
	var/vol_each = round(reagents.maximum_volume / 3)
	reagents.add_reagent(/decl/material/liquid/psychoactives,   vol_each)
	reagents.add_reagent(/decl/material/liquid/hallucinogenics, vol_each)
	reagents.add_reagent(/decl/material/liquid/presyncopics,    vol_each)

/obj/item/chems/syringe/steroid
	name = "syringe (anabolic steroids)"
	desc = "Contains drugs for muscle growth."
	mode = SYRINGE_INJECT

/obj/item/chems/syringe/steroid/populate_reagents()
	var/vol_third = round(reagents.maximum_volume/3)
	reagents.add_reagent(/decl/material/liquid/adrenaline,   vol_third)
	reagents.add_reagent(/decl/material/liquid/amphetamines, 2 * vol_third)

// TG ports

/obj/item/chems/syringe/advanced
	name = "advanced syringe"
	desc = "An advanced syringe that can hold 60 units of chemicals."
	amount_per_transfer_from_this = 20
	volume = 60
	icon_state = "bs"
	material = /decl/material/solid/glass
	matter = list(
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	origin_tech = "{'biotech':3,'materials':4,'exoticmatter':2}"

/obj/item/chems/syringe/noreact
	name = "cryostasis syringe"
	desc = "An advanced syringe that stops reagents inside from reacting. It can hold up to 20 units."
	volume = 20
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT
	icon_state = "cs"
	material = /decl/material/solid/glass
	matter = list(
		/decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic = MATTER_AMOUNT_TRACE
	)
	origin_tech = "{'biotech':4,'materials':4}"
