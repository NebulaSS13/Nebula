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

	if (isrobot(target))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = target
		if (R.get_damage(BRUTE) || R.get_damage(BURN) )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			R.heal_damage(BRUTE, 15, do_update_health = FALSE)
			R.heal_damage(BURN, 15)
			use(1)
			user.visible_message(
				SPAN_NOTICE("\The [user] applied some [src] on [R]'s damaged areas."),
				SPAN_NOTICE("You apply some [src] at [R]'s damaged areas.")
			)
		else
			to_chat(user, SPAN_NOTICE("All [R]'s systems are nominal."))
		return TRUE
	
	if (ishuman(target))		//Repairing robolimbs
		var/mob/living/human/H = target
		var/obj/item/organ/external/S = GET_EXTERNAL_ORGAN(H, user.get_target_zone())

		if(!S)
			to_chat(user, SPAN_WARNING("\The [target] is missing that body part."))
			return TRUE

		if(BP_IS_BRITTLE(S))
			to_chat(user, SPAN_WARNING("\The [target]'s [S.name] is hard and brittle - \the [src] cannot repair it."))
			return TRUE

		if(S && S.is_robotic() && S.hatch_state == HATCH_OPENED)
			if(!S.get_damage())
				to_chat(user, SPAN_NOTICE("Nothing to fix here."))
			else if(can_use(1))
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				S.heal_damage(15, 15, robo_repair = 1)
				use(1)
				user.visible_message(
					SPAN_NOTICE("\The [user] applies some nanite paste on [user != target ? "[target]'s [S.name]" : "[S]"] with [src]."),
					SPAN_NOTICE("You apply some nanite paste on [user == target ? "your" : "[target]'s"] [S.name].")
				)
			return TRUE

	return ..()
