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

/obj/item/stack/nanopaste/attack(mob/living/M, mob/user)

	if (!istype(M))
		to_chat(user, SPAN_WARNING("\The [src] cannot be applied to \the [M]!"))
		return TRUE

	if (!ishuman(user) && !issilicon(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE

	if (isrobot(M))	//Repairing cyborgs
		var/mob/living/silicon/robot/R = M
		if (R.getBruteLoss() || R.getFireLoss() )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			R.adjustBruteLoss(-15, do_update_health = FALSE)
			R.adjustFireLoss(-15)
			use(1)
			user.visible_message(
				SPAN_NOTICE("\The [user] applied some [name] to \the [R]'s damaged areas."),
				SPAN_NOTICE("You apply some [name] to \the [R]'s damaged areas.")
			)
		else
			to_chat(user, SPAN_NOTICE("\The [R]'s systems are all nominal."))
		return TRUE

	if(!ishuman(M))
		return FALSE

	//Repairing robolimbs
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/S = GET_EXTERNAL_ORGAN(H, user.get_target_zone())

	if(!S)
		to_chat(user, SPAN_WARNING("\The [M] is missing that body part."))
		return TRUE

	if(BP_IS_BRITTLE(S))
		to_chat(user, SPAN_WARNING("\The [M]'s [S.name] is hard and brittle - \the [src] cannot repair it."))
		return TRUE

	if(!S.is_robotic())
		to_chat(user, SPAN_WARNING("\The [M]'s [S.name] is flesh and blood, and cannot be repaired with \the [src]."))
		return TRUE

	if(S.damage >= 30 && S.hatch_state != HATCH_OPENED)
		to_chat(user, SPAN_WARNING("The damage to \the [S] is too severe to repair without an open maintenance hatch."))
		return TRUE

	if(!S.get_damage())
		to_chat(user, SPAN_NOTICE("Nothing to fix here."))
		return TRUE

	if(can_use(1))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		S.heal_damage(15, 15, robo_repair = 1)
		use(1)
		user.visible_message(
			SPAN_NOTICE("\The [user] applies some [name] to \the [user != M ? "[M]'s [S.name]" : "[S]"] with [src]."),
			SPAN_NOTICE("You apply some [name] to [user == M ? "your" : "\the [M]'s"] [S.name].")
		)
		return TRUE
	return FALSE
