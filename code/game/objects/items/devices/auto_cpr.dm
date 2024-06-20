/obj/item/auto_cpr
	name = "auto-compressor"
	desc = "A device that gives regular compression to the victim's ribcage, used in case of urgent heart issues."
	icon = 'icons/obj/items/device/auto_cpr.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = @'{"magnets":2,"biotech":2}'
	slot_flags = SLOT_OVER_BODY
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon         = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium   = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_TRACE,
	)
	var/last_pump
	var/skilled_setup

/obj/item/auto_cpr/mob_can_equip(mob/user, slot, disable_warning = FALSE, force = FALSE, ignore_equipped = FALSE)
	. = ..()
	if(. && slot == slot_wear_suit_str)
		. = user?.get_bodytype_category() == BODYTYPE_HUMANOID

/obj/item/auto_cpr/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(ishuman(target) && user.a_intent == I_HELP)
		var/obj/item/suit = target.get_equipped_item(slot_wear_suit_str)
		if(suit)
			to_chat(user, SPAN_WARNING("Their [suit] is in the way, remove it first!"))
			return TRUE
		user.visible_message(SPAN_NOTICE("[user] starts fitting [src] onto \the [target]'s chest."))
		if(!do_mob(user, target, 2 SECONDS))
			return TRUE
		if(user.try_unequip(src))
			if(!target.equip_to_slot_if_possible(src, slot_wear_suit_str, del_on_fail=0, disable_warning=1, redraw_mob=1))
				user.put_in_active_hand(src)
		return TRUE

	return ..()

/obj/item/auto_cpr/equipped(mob/user, slot)
	..()
	START_PROCESSING(SSobj,src)

/obj/item/auto_cpr/attack_hand(mob/user)
	skilled_setup = user.skill_check(SKILL_ANATOMY, SKILL_BASIC) && user.skill_check(SKILL_MEDICAL, SKILL_BASIC)
	return ..()

/obj/item/auto_cpr/dropped(mob/user)
	STOP_PROCESSING(SSobj,src)
	..()

/obj/item/auto_cpr/Process()
	if(!ishuman(loc))
		return PROCESS_KILL

	var/mob/living/human/H = loc
	if(H.get_equipped_slot_for_item(src) != slot_wear_suit_str)
		return PROCESS_KILL

	if(world.time > last_pump + 15 SECONDS)
		last_pump = world.time
		playsound(src, 'sound/machines/pump.ogg', 25)
		if(!skilled_setup && prob(20))
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(H, BP_CHEST)
			E.add_pain(15)
			to_chat(H, "<span class='danger'>Your [E] is compressed painfully!</span>")
			if(prob(5))
				E.fracture()
		else
			var/obj/item/organ/internal/heart/heart = H.get_organ(BP_HEART, /obj/item/organ/internal/heart)
			if(heart)
				heart.external_pump = list(world.time, 0.6)

