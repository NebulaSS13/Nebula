/obj/item/chems
	name = "container"
	desc = "..."
	icon = 'icons/obj/items/chem/container.dmi'
	icon_state = null
	w_class = ITEM_SIZE_SMALL

	var/base_name
	var/base_desc
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = @"[5,10,15,25,30]"
	var/volume = 30
	var/label_text
	var/presentation_flags = 0

/obj/item/chems/proc/cannot_interact(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(usr, SPAN_WARNING("You're in no condition to do that!"))
		return TRUE
	if(ismob(loc) && loc != user)
		to_chat(usr, SPAN_WARNING("You can't set transfer amounts while \the [src] is being held by someone else."))
		return TRUE
	return FALSE

/obj/item/chems/proc/get_base_name()
	if(!base_name)
		base_name = initial(name)
	. = base_name

/obj/item/chems/proc/update_container_name()
	var/newname = get_base_name()
	if(presentation_flags & PRESENTATION_FLAG_NAME)
		var/decl/material/R = reagents?.get_primary_reagent()
		if(R)
			newname += " of [R.get_presentation_name(src)]"
	if(length(label_text))
		newname += " ([label_text])"
	if(newname != name)
		SetName(newname)

/obj/item/chems/proc/get_base_desc()
	if(!base_desc)
		base_desc = initial(desc)
	. = base_desc

/obj/item/chems/proc/update_container_desc()
	var/list/new_desc_list = list(get_base_desc())
	if(presentation_flags & PRESENTATION_FLAG_DESC)
		var/decl/material/R = reagents?.get_primary_reagent()
		if(R)
			new_desc_list += R.get_presentation_desc(src)
	desc = new_desc_list.Join("\n")

/obj/item/chems/on_reagent_change()
	update_container_name()
	update_container_desc()
	update_icon()

/obj/item/chems/verb/set_amount_per_transfer_from_this()
	set name = "Set Transfer Amount"
	set category = "Object"
	set src in range(1)
	if(cannot_interact(usr))
		return
	var/N = input("How much do you wish to transfer per use?", "Set Transfer Amount") as null|anything in cached_json_decode(possible_transfer_amounts)
	if(N && !cannot_interact(usr))
		amount_per_transfer_from_this = N

/obj/item/chems/Initialize()
	. = ..()
	create_reagents(volume)
	if(!possible_transfer_amounts)
		src.verbs -= /obj/item/chems/verb/set_amount_per_transfer_from_this

/obj/item/chems/attack_self(mob/user)
	return

/obj/item/chems/afterattack(atom/target, mob/user, flag)
	return

/obj/item/chems/attackby(obj/item/W, mob/user)
	if(IS_PEN(W))
		var/tmp_label = sanitize_safe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>The label can be at most 10 characters long.</span>")
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_container_name()
	else
		return ..()

/obj/item/chems/proc/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target) // This goes into afterattack
	if(!istype(target))
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		to_chat(user, "<span class='notice'>[target] is empty.</span>")
		return 1

	if(reagents && !REAGENTS_FREE_SPACE(reagents))
		to_chat(user, "<span class='notice'>[src] is full.</span>")
		return 1

	var/trans = target.reagents.trans_to_obj(src, target:amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>You fill [src] with [trans] units of the contents of [target].</span>")
	return 1

/obj/item/chems/proc/standard_splash_mob(var/mob/user, var/mob/target) // This goes into afterattack
	if(!istype(target))
		return

	if(user.a_intent == I_HELP)
		to_chat(user, "<span class='notice'>You can't splash people on help intent.</span>")
		return 1

	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return 1

	if(target.reagents && !REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return 1

	var/contained = REAGENT_LIST(src)

	admin_attack_log(user, target, "Used \the [name] containing [contained] to splash the victim.", "Was splashed by \the [name] containing [contained].", "used \the [name] containing [contained] to splash")
	user.visible_message( \
		SPAN_DANGER("\The [target] has been splashed with the contents of \the [src] by \the [user]!"), \
		SPAN_DANGER("You splash \the [target] with the contents of \the [src]."))

	reagents.splash(target, reagents.total_volume)
	return 1

/obj/item/chems/proc/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You eat \the [src]</span>")

/obj/item/chems/proc/other_feed_message_start(var/mob/user, var/mob/target)
	user.visible_message("<span class='warning'>[user] is trying to feed [target] \the [src]!</span>")

/obj/item/chems/proc/other_feed_message_finish(var/mob/user, var/mob/target)
	user.visible_message("<span class='warning'>[user] has fed [target] \the [src]!</span>")

/obj/item/chems/proc/feed_sound(var/mob/user)
	return

/obj/item/chems/proc/standard_feed_mob(var/mob/user, var/mob/target) // This goes into attack
	if(!istype(target))
		return 0

	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='notice'>\The [src] is empty.</span>")
		return 1

	// only carbons can eat
	if(istype(target, /mob/living/carbon))
		if(target == user)
			if(istype(user, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = user
				if(!H.check_has_mouth())
					to_chat(user, "Where do you intend to put \the [src]? You don't have a mouth!")
					return
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
					return

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //puts a limit on how fast people can eat/drink things
			self_feed_message(user)
			reagents.trans_to_mob(user, issmall(user) ? CEILING(amount_per_transfer_from_this/2) : amount_per_transfer_from_this, CHEM_INGEST)
			feed_sound(user)
			add_trace_DNA(user)
			return 1


		else
			if(!user.can_force_feed(target, src))
				return

			other_feed_message_start(user, target)

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			if(!do_mob(user, target))
				return

			other_feed_message_finish(user, target)

			var/contained = REAGENT_LIST(src)
			admin_attack_log(user, target, "Fed the victim with [name] (Reagents: [contained])", "Was fed [src] (Reagents: [contained])", "used [src] (Reagents: [contained]) to feed")

			reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INGEST)
			feed_sound(user)
			add_trace_DNA(target)
			return 1

	return 0

/obj/item/chems/proc/standard_pour_into(var/mob/user, var/atom/target) // This goes into afterattack and yes, it's atom-level
	if(!target.reagents)
		return 0

	// Ensure we don't splash beakers and similar containers.
	if(!ATOM_IS_OPEN_CONTAINER(target) && istype(target, /obj/item/chems))
		to_chat(user, "<span class='notice'>\The [target] is closed.</span>")
		return 1
	// Otherwise don't care about splashing.
	else if(!ATOM_IS_OPEN_CONTAINER(target))
		return 0

	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='notice'>[src] is empty.</span>")
		return 1

	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return 1

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	playsound(src, 'sound/effects/pour.ogg', 25, 1)
	to_chat(user, "<span class='notice'>You transfer [trans] unit\s of the solution to \the [target].  \The [src] now contains [src.reagents.total_volume] units.</span>")
	return 1

/obj/item/chems/do_surgery(mob/living/carbon/M, mob/living/user)
	if(user.zone_sel.selecting != BP_MOUTH) //in case it is ever used as a surgery tool
		return ..()

/obj/item/chems/examine(mob/user)
	. = ..()
	if(!reagents)
		return
	if(hasHUD(user, HUD_SCIENCE))
		var/prec = user.skill_fail_chance(SKILL_CHEMISTRY, 10)
		to_chat(user, "<span class='notice'>The [src] contains: [reagents.get_reagents(precision = prec)].</span>")
	else if((loc == user) && user.skill_check(SKILL_CHEMISTRY, SKILL_EXPERT))
		to_chat(user, "<span class='notice'>Using your chemistry knowledge, you identify the following reagents in \the [src]: [reagents.get_reagents(!user.skill_check(SKILL_CHEMISTRY, SKILL_PROF), 5)].</span>")

/obj/item/chems/shatter(consumed)
	reagents.splash(get_turf(src), reagents.total_volume)
	. = ..()

/obj/item/chems/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/set_transfer/chems)

/decl/interaction_handler/set_transfer/chems
	expected_target_type = /obj/item/chems

/decl/interaction_handler/set_transfer/chems/is_possible(var/atom/target, var/mob/user)
	. = ..()
	if(.)
		var/obj/item/chems/C = target
		return !!C.possible_transfer_amounts

/decl/interaction_handler/set_transfer/chems/invoked(var/atom/target, var/mob/user)
	var/obj/item/chems/C = target
	C.set_amount_per_transfer_from_this()
