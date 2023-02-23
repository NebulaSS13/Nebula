/obj/structure/iv_drip
	name = "\improper IV drip"
	icon = 'icons/obj/structures/iv_drip.dmi'
	anchored = FALSE
	density = FALSE

	var/obj/item/organ/external/attached_limb
	var/mode = 1 // 1 is injecting, 0 is taking blood.
	var/obj/item/chems/beaker
	var/list/transfer_amounts = list(REM, 1, 2)
	var/transfer_amount = 1

/obj/structure/iv_drip/Initialize()
	. = ..()
	update_icon()

/obj/structure/iv_drip/verb/set_amount_per_transfer_from_this()
	set name = "Set IV transfer amount"
	set category = "Object"
	set src in range(1)

	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_WARNING("You're in no condition to do that!"))
		return

	var/N = input("Amount per transfer from this:","[src]") as null|anything in transfer_amounts
	if(!CanPhysicallyInteract(usr)) // because input takes time and the situation can change
		to_chat(usr, SPAN_WARNING("You're in no condition to do that!"))
		return
	if(N)
		transfer_amount = N

/obj/structure/iv_drip/on_update_icon()
	..()

	var/mutable_appearance/base = mutable_appearance(icon, "nothing")
	base.icon_state = "[beaker ? "beaker" : "nothing"][attached_limb ? "_hooked" : ""]"
	add_overlay(base)

	if(beaker)
		var/datum/reagents/reagents = beaker.reagents
		var/percent = round((reagents.total_volume / beaker.volume) * 100)
		if(reagents.total_volume)
			var/mutable_appearance/filling = mutable_appearance(icon, "reagent")
			switch(percent)
				if(0)
					filling.icon_state = "reagentempty"
				if(1 to 9)
					filling.icon_state = "reagent0"
				if(10 to 24)
					filling.icon_state = "reagent10"
				if(25 to 49)
					filling.icon_state = "reagent25"
				if(50 to 74)
					filling.icon_state = "reagent50"
				if(75 to 79)
					filling.icon_state = "reagent75"
				if(80 to 90)
					filling.icon_state = "reagent80"
				if(91 to INFINITY)
					filling.icon_state = "reagent100"
			filling.color = reagents.get_color()
			add_overlay(filling)

		if(istype(beaker, /obj/item/chems/ivbag))
			var/mutable_appearance/ivbaglabel = mutable_appearance(icon, "ivbag_label")
			add_overlay(ivbaglabel)

		if(attached_limb)
			var/mutable_appearance/light = mutable_appearance(icon, "light_full")
			if(percent < 15)
				light.icon_state = "light_low"
			else if(percent < 60)
				light.icon_state = "light_mid"

			add_overlay(light)

/obj/structure/iv_drip/handle_mouse_drop(atom/over, mob/user)
	if(attached_limb)
		drip_detach()
		return TRUE
	if(ishuman(over))
		hook_up(over, user)
		return TRUE
	. = ..()

/obj/structure/iv_drip/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/chems))
		if(!isnull(src.beaker))
			to_chat(user, "There is already a reagent container loaded!")
			return
		if(!user.unEquip(W, src))
			return
		beaker = W
		to_chat(user, "You attach \the [W] to \the [src].")
		queue_icon_update()
	else
		return ..()

/obj/structure/iv_drip/Destroy()
	STOP_PROCESSING(SSobj,src)
	attached_limb = null
	QDEL_NULL(beaker)
	return ..()

/obj/structure/iv_drip/Process()
	if(attached_limb)
		if(!attached_limb.owner || !Adjacent(attached_limb.owner))
			rip_out()
			return PROCESS_KILL
	else
		return PROCESS_KILL

	if(!beaker)
		return

	//SSObj fires twice as fast as SSMobs, so gotta slow down to not OD our victims.
	if(SSobj.times_fired % 2)
		return

	var/mob/living/carbon/human/attached = attached_limb.owner

	if(mode) // Give blood
		if(beaker.volume > 0)
			attached.inject_external_organ(attached_limb, beaker.reagents, transfer_amount)
			queue_icon_update()
	else // Take blood
		var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		amount = min(amount, 4)

		if(amount == 0) // If the beaker is full, ping
			if(prob(5)) visible_message("\The [src] pings.")
			return

		if(!attached.should_have_organ(BP_HEART))
			return

		// If the human is losing too much blood, beep.
		if(attached.get_blood_volume() < BLOOD_VOLUME_SAFE * 1.05)
			visible_message("\The [src] beeps loudly.")

		if(attached.take_blood(beaker,amount))
			queue_icon_update()

/obj/structure/iv_drip/attack_hand(mob/user)
	if(attached_limb)
		drip_detach()
	else if(beaker)
		beaker.dropInto(loc)
		beaker = null
		queue_icon_update()
	else
		return ..()

/obj/structure/iv_drip/attack_robot(var/mob/user)
	if(CanPhysicallyInteract(user))
		return attack_hand(user)

/obj/structure/iv_drip/verb/drip_detach()
	set category = "Object"
	set name = "Detach IV Drip"
	set src in range(1)

	if(!attached_limb)
		return

	if(!CanPhysicallyInteractWith(usr, src))
		to_chat(usr, SPAN_WARNING("You're in no condition to do that!"))
		return

	if(!usr.skill_check(SKILL_MEDICAL, SKILL_BASIC))
		rip_out()
	else
		if(attached_limb.owner) // don't give a message without an owner
			visible_message("\The [attached_limb.owner] is taken off \the [src].")
		attached_limb = null

	queue_icon_update()
	STOP_PROCESSING(SSobj,src)

/obj/structure/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle IV Mode"
	set src in view(1)
	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_WARNING("You're in no condition to do that!"))
		return
	mode = !mode
	to_chat(usr, "The IV drip is now [mode ? "injecting" : "taking blood"].")

/obj/structure/iv_drip/examine(mob/user, distance)
	. = ..()

	if (distance >= 2)
		return

	to_chat(user, "The IV drip is [mode ? "injecting" : "taking blood"].")
	to_chat(user, "It is set to transfer [transfer_amount]u of chemicals per cycle.")

	if(beaker)
		if(beaker.reagents && beaker.reagents.total_volume)
			to_chat(usr, SPAN_NOTICE("Attached is \a [beaker] with [beaker.reagents.total_volume] units of liquid."))
		else
			to_chat(usr, SPAN_NOTICE("Attached is an empty [beaker]."))
	else
		to_chat(usr, SPAN_NOTICE("No chemicals are attached."))

	to_chat(usr, SPAN_NOTICE("[attached_limb?.owner || "No one"] is hooked up to it."))

/obj/structure/iv_drip/proc/rip_out()
	var/mob/living/attached = attached_limb.owner
	if(attached)
		visible_message("The needle is ripped out of [attached]'s [attached_limb.name], doesn't that hurt?")
		attached.apply_damage(1, BRUTE, pick(BP_R_ARM, BP_L_ARM), damage_flags=DAM_SHARP)
	attached_limb = null

/obj/structure/iv_drip/proc/hook_up(mob/living/carbon/human/target, mob/user)
	var/target_zone = check_zone(user.zone_sel.selecting, target) // deterministic, so we do it here and in do_IV_hookup
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(target, target_zone)
	if(do_IV_hookup(target, user, src))
		attached_limb = affecting
		START_PROCESSING(SSobj,src)

/proc/do_IV_hookup(mob/living/carbon/human/target, mob/user, obj/IV)
	var/decl/pronouns/target_pronouns = target.get_visible_pronouns(target.get_equipment_visibility())
	var/target_zone = check_zone(user.zone_sel.selecting, target)
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(target, target_zone)
	var/injection_status = target.can_inject(user, target_zone)
	if(!injection_status)
		return
	to_chat(user, SPAN_NOTICE("You start to hook up \the [target]'s [affecting.name] to \the [IV]."))
	var/delay = 2 SECONDS
	if(injection_status == INJECTION_PORT)
		delay += INJECTION_PORT_DELAY
	if(!user.do_skilled(delay, SKILL_MEDICAL, target))
		return FALSE

	if(prob(user.skill_fail_chance(SKILL_MEDICAL, 80, SKILL_BASIC)))
		user.visible_message("\The [user] fails to find a vein in \the [target]'s [affecting.name] while hooking [target_pronouns.him] up to \the [IV], stabbing [target_pronouns.him] instead!")
		target.apply_damage(2, BRUTE, target_zone, damage_flags=DAM_SHARP)
		return FALSE

	user.visible_message("\The [user] hooks \the [target]'s [affecting.name] up to \the [IV].")
	return TRUE
