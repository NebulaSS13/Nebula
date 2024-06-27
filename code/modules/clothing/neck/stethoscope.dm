/obj/item/clothing/neck/stethoscope
	name = "stethoscope"
	desc = "A medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon = 'icons/clothing/accessories/stethoscope.dmi'
	accessory_visibility = ACCESSORY_VISIBILITY_ATTACHMENT

/obj/item/clothing/neck/stethoscope/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(ishuman(target) && isliving(user) && user.a_intent == I_HELP)
		var/obj/item/organ/organ = GET_EXTERNAL_ORGAN(target, user.get_target_zone())
		if(organ)
			user.visible_message(
				"\The [user] places [src] against \the [target]'s [organ.name] and listens attentively.",
				"You place \the [src] against \the [target]'s [organ.name]. You hear [english_list(organ.listen())]."
			)
			return TRUE
	return ..()
