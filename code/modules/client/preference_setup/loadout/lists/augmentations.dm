/decl/loadout_category/augmentation
	name = "Augmentations"

/decl/loadout_option/augmentation
	category = /decl/loadout_category/augmentation
	abstract_type = /decl/loadout_option/augmentation
	loadout_flags = GEAR_NO_EQUIP | GEAR_NO_FINGERPRINTS
	custom_setup_proc = /obj/item/proc/AttemptAugmentation
	custom_setup_proc_arguments = list(BP_CHEST)

/obj/item/proc/AttemptAugmentation(mob/user, target_zone)
	to_chat(user, SPAN_DANGER("Was unable to augment you with \the [src]."))
	qdel(src)

/obj/item/implant/AttemptAugmentation(mob/user, target_zone)
	if(can_implant(user, user, target_zone) && implant_in_mob(user, user, target_zone))
		var/obj/item/organ/organ = GET_EXTERNAL_ORGAN(user, target_zone)
		to_chat(user, SPAN_NOTICE("You have \a [src] implanted in your [organ.name]."))
	else
		..()

/obj/item/organ/internal/augment/AttemptAugmentation(mob/living/human/user, target_zone)
	if(!istype(user))
		return ..()

	var/obj/item/organ/external/organ_to_implant_into = GET_EXTERNAL_ORGAN(user, parent_organ)
	if(!istype(organ_to_implant_into))
		return ..()

	if(augment_flags == AUGMENTATION_MECHANIC && !BP_IS_PROSTHETIC(organ_to_implant_into))
		to_chat(user, SPAN_DANGER("Your [organ_to_implant_into.name] is not prosthetic, and therefore \the [src] can not be installed!"))
		return ..()

	user.add_organ(src, organ_to_implant_into)
	to_chat(user, SPAN_NOTICE("Your [organ_to_implant_into.name] has been replaced with \the [src]."))
