/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "An antibacterial ointment used to treat burns and prevent infections."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	heal_burn = 1
	origin_tech = @'{"biotech":1}'
	animal_heal = 4

/obj/item/stack/medical/ointment/get_apply_sounds()
	var/static/list/apply_sounds = list(
		'sound/effects/ointment.ogg'
	)
	return apply_sounds

/obj/item/stack/medical/ointment/try_treat_limb(mob/living/target, mob/living/user, obj/item/organ/external/affecting)
	if(affecting.is_salved())
		to_chat(user, SPAN_WARNING("The wounds on [target]'s [affecting.name] have already been salved."))
		return 0
	user.visible_message(
		SPAN_NOTICE("\The [user] starts salving wounds on [target]'s [affecting.name]."),
		SPAN_NOTICE("You start salving the wounds on [target]'s [affecting.name].")
	)
	play_apply_sound()
	if(!do_mob(user, target, 1 SECOND))
		to_chat(user, SPAN_WARNING("You must stand still to salve wounds."))
		return 0
	show_limb_salve_message(user, target, affecting)
	use(1)
	affecting.salve()
	affecting.disinfect()
	return 1

/obj/item/stack/medical/ointment/proc/show_limb_salve_message(mob/living/user, mob/living/target, obj/item/organ/external/affecting)
	user.visible_message(
		SPAN_NOTICE("\The [user] salves the wounds on \the [target]'s [affecting.name]."),
	    SPAN_NOTICE("You salve the wounds on \the [target]'s [affecting.name].")
	)

/obj/item/stack/medical/ointment/crafted
	name = "poultice"
	gender = NEUTER
	singular_name = "poultice"
	plural_name = "poultices"
	icon_state = "poultice"
	desc = "A bandage soaked in a medicinal herbal mixture, good for treating burns and preventing infections."
	animal_heal = 3

/obj/item/stack/medical/ointment/crafted/five
	amount = 5

/obj/item/stack/medical/ointment/crafted/ten
	amount = 10

/obj/item/stack/medical/ointment/advanced
	name = "advanced burn kit"
	singular_name = "advanced burn kit"
	desc = "An advanced treatment kit for severe burns."
	icon_state = "burnkit"
	heal_burn = 5
	origin_tech = @'{"biotech":1}'
	animal_heal = 7

/obj/item/stack/medical/ointment/advanced/get_apply_sounds()
	var/static/list/apply_sounds = list('sound/effects/ointment.ogg')
	return apply_sounds

/obj/item/stack/medical/ointment/advanced/show_limb_salve_message(mob/living/user, mob/living/target, obj/item/organ/external/affecting)
	user.visible_message(
		SPAN_NOTICE("[user] covers wounds on [target]'s [affecting.name] with regenerative membrane."),
		SPAN_NOTICE("You cover wounds on [target]'s [affecting.name] with regenerative membrane.")
	)
