/obj/item/stack/medical/resin
	name = "resin patches"
	singular_name = "resin patch"
	desc = "A resin-based patching kit used to repair crystalline bodyparts. The label is written in a colourful, angular, unreadable script."
	icon_state = "resin-pack"
	heal_brute = 10
	heal_burn =  10

/obj/item/stack/medical/resin/drone
	amount = 25
	max_amount = 25

/obj/item/stack/medical/resin/crafted
	name = "resin globules"
	desc = "A lump of slick, shiny resin. Used to repair damage to crystalline bodyparts."
	singular_name = "resin globule"
	icon_state = "resin-lump"
	heal_brute = 5
	heal_burn =  5

/obj/item/stack/medical/resin/check_limb_state(var/mob/user, var/obj/item/organ/external/limb)
	if(!BP_IS_PROSTHETIC(limb) && !BP_IS_CRYSTAL(limb))
		to_chat(user, SPAN_WARNING("You cannot use \the [src] to treat an organic limb."))
		return FALSE
	return TRUE

/obj/item/stack/medical/resin/try_treat_limb(mob/living/target, mob/living/user, obj/item/organ/external/affecting)
	if((affecting.brute_dam + affecting.burn_dam) <= 0)
		to_chat(user, SPAN_WARNING("\The [target]'s [affecting.name] is undamaged."))
		return 0
	user.visible_message(
		SPAN_NOTICE("\The [user] starts patching fractures on \the [target]'s [affecting.name]."),
		SPAN_NOTICE("You start patching fractures on \the [target]'s [affecting.name].")
	)
	play_apply_sound()
	if(!do_mob(user, target, 1 SECOND))
		to_chat(user, SPAN_WARNING("You must stand still to patch fractures."))
		return 0
	user.visible_message(
		SPAN_NOTICE("\The [user] patches the fractures on \the [target]'s [affecting.name] with resin."),
		SPAN_NOTICE("You patch fractures on \the [target]'s [affecting.name] with resin.")
	)
	affecting.heal_damage(heal_brute, heal_burn, robo_repair = TRUE)
	return 1
