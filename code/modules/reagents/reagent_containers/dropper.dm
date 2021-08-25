////////////////////////////////////////////////////////////////////////////////
/// Droppers.
////////////////////////////////////////////////////////////////////////////////
/obj/item/chems/dropper
	name = "Dropper"
	desc = "A small glass tube with a bulbous rubber blister on one end. Used to drop very precise amounts of reagents between vessels."
	icon = 'icons/obj/items/chem/dropper.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = @"[1,2,3,4,5]"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	volume = 5
	item_flags = ITEM_FLAG_NO_BLUDGEON

/obj/item/chems/dropper/afterattack(var/obj/target, var/mob/user, var/proximity)

	if(!target.reagents || !proximity)
		return

	if(reagents.total_volume)

		if(!REAGENTS_FREE_SPACE(target.reagents))
			to_chat(user, SPAN_WARNING("\The [target] is full."))
			return

		if(!ATOM_IS_OPEN_CONTAINER(target) && !ismob(target) && !istype(target, /obj/item/chems/food) && !istype(target, /obj/item/clothing/mask/smokable/cigarette)) //You can inject humans and food but you cant remove the shit.
			to_chat(user, SPAN_WARNING("You cannot directly fill this object."))
			return

		var/trans = 0
		if(ismob(target))
			if(user.a_intent == I_HELP)
				return

			var/time = 20 //2/3rds the time of a syringe
			user.visible_message(SPAN_DANGER("\The [user] is trying to squirt something into \the [target]'s eyes!"))

			if(!do_mob(user, target, time))
				return

			if(istype(target, /mob/living/carbon/human))
				var/mob/living/carbon/human/victim = target

				var/obj/item/safe_thing = null
				if(victim.wear_mask)
					if (victim.wear_mask.body_parts_covered & SLOT_EYES)
						safe_thing = victim.wear_mask
				if(victim.head)
					if (victim.head.body_parts_covered & SLOT_EYES)
						safe_thing = victim.head
				if(victim.glasses)
					if (victim.glasses.body_parts_covered & SLOT_EYES)
						safe_thing = victim.glasses
				if(safe_thing)
					trans = reagents.splash(safe_thing, amount_per_transfer_from_this, max_spill=30)
					user.visible_message(SPAN_DANGER("\The [user] tries to squirt something into [target]'s eyes, but fails!"), SPAN_DANGER("You squirt [trans] unit\s at \the [target]'s eyes, but fail!"))
					return

			var/mob/living/M = target
			var/contained = REAGENT_LIST(src)
			admin_attack_log(user, M, "Squirted their victim with \a [src] (Reagents: [contained])", "Were squirted with \a [src] (Reagents: [contained])", "used \a [src] (Reagents: [contained]) to squirt at")

			var/spill_amt = M.incapacitated()? 0 : 30
			trans += reagents.splash(target, reagents.total_volume/2, max_spill = spill_amt)
			trans += reagents.trans_to_mob(target, reagents.total_volume/2, CHEM_INJECT) //I guess it gets into the bloodstream through the eyes or something
			user.visible_message(SPAN_DANGER("[user] squirts something into \the [target]'s eyes!"), SPAN_DANGER("You squirt [trans] unit\s into \the [target]'s eyes!"))
			return
		else
			trans = reagents.splash(target, amount_per_transfer_from_this, max_spill=0) //sprinkling reagents on generic non-mobs. Droppers are very precise
			to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution."))

	else // Taking from something

		if(!ATOM_IS_OPEN_CONTAINER(target) && !istype(target,/obj/structure/reagent_dispensers))
			to_chat(user, SPAN_NOTICE("You cannot directly remove reagents from [target]."))
			return

		if(!target.reagents || !target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[target] is empty."))
			return

		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)

		to_chat(user, SPAN_NOTICE("You fill the dropper with [trans] units of the solution."))


/obj/item/chems/dropper/on_reagent_change()
	update_icon()

/obj/item/chems/dropper/on_update_icon()
	if(reagents.total_volume)
		icon_state = "dropper1"
	else
		icon_state = "dropper0"

/obj/item/chems/dropper/industrial
	name = "industrial dropper"
	desc = "A larger dropper. Transfers 10 units."
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[1,2,3,4,5,6,7,8,9,10]"
	volume = 10

////////////////////////////////////////////////////////////////////////////////
/// Droppers. END
////////////////////////////////////////////////////////////////////////////////
