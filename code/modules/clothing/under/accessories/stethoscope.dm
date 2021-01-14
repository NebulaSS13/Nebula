/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon = 'icons/clothing/accessories/stethoscope.dmi'
	high_visibility = 1

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user) && user.a_intent == I_HELP)
		var/obj/item/organ/organ = M.get_organ(user.zone_sel.selecting)
		if(organ)
			user.visible_message("[user] places [src] against [M]'s [organ.name] and listens attentively.", 
								 "You place [src] against [M]'s [organ.name]. You hear [english_list(organ.listen())].")
			return TRUE
	return ..(M,user)