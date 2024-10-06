/obj/item/stack/nanopaste
	name = "nanopaste"
	singular_name = "nanite swarm"
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	icon = 'icons/obj/nanopaste.dmi'
	icon_state = "tube"
	origin_tech = @'{"materials":4,"engineering":3}'
	max_amount = 10
	amount = 10
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/stack/nanopaste/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if (!istype(target))
		to_chat(user, SPAN_WARNING("\The [src] cannot be applied to \the [target]!"))
		return TRUE

	if (!ishuman(user) && !issilicon(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE

	if (isrobot(target))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = target
		if (R.getBruteLoss() || R.getFireLoss() )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			R.heal_damage(BRUTE, 15, do_update_health = FALSE)
			R.heal_damage(BURN, 15)
			use(1)
			user.visible_message(
				SPAN_NOTICE("\The [user] applied some [name] to \the [R]'s damaged areas."),
				SPAN_NOTICE("You apply some [name] to \the [R]'s damaged areas.")
			)
		else
			to_chat(user, SPAN_NOTICE("\The [R]'s systems are all nominal."))
		return TRUE

	//Repairing robolimbs
	var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(target, user.get_target_zone())

	if(!affecting)
		to_chat(user, SPAN_WARNING("\The [target] is missing that body part."))
		return TRUE

	if(BP_IS_BRITTLE(affecting))
		to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is hard and brittle - \the [src] cannot repair it."))
		return TRUE

	if(!affecting.is_robotic())
		to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is flesh and blood, and cannot be repaired with \the [src]."))
		return TRUE

	if(affecting.damage >= 30 && affecting.hatch_state != HATCH_OPENED)
		to_chat(user, SPAN_WARNING("The damage to \the [affecting] is too severe to repair without an open maintenance hatch."))
		return TRUE

	if(!affecting.get_damage())
		to_chat(user, SPAN_NOTICE("Nothing to fix here."))
		return TRUE

	if(can_use(1))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		affecting.heal_damage(15, 15, robo_repair = 1)
		use(1)
		user.visible_message(
			SPAN_NOTICE("\The [user] applies some [name] to \the [user != target ? "[target]'s [affecting.name]" : "[affecting]"] with [src]."),
			SPAN_NOTICE("You apply some [name] to [user == target ? "your" : "\the [target]'s"] [affecting.name].")
		)
		return TRUE
	return ..()
