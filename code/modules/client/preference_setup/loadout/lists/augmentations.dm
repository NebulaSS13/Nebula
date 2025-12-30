/decl/loadout_category/augmentation
	name = "Augmentations"

/decl/loadout_option/augmentation
	category = /decl/loadout_category/augmentation
	abstract_type = /decl/loadout_option/augmentation
	loadout_flags = GEAR_NO_EQUIP | GEAR_NO_FINGERPRINTS
	custom_setup_proc = /obj/item/proc/AttemptAugmentation
	custom_setup_proc_arguments = list(BP_CHEST)

/obj/item/proc/AttemptAugmentation(mob/living/user, target_zone)
	to_chat(user, SPAN_DANGER("Was unable to augment you with \the [src]."))
	qdel(src)

/obj/item/implant/AttemptAugmentation(mob/living/user, target_zone)
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

// Codex implant, only available if the codex is set to require it in config
/decl/loadout_option/augmentation/codex_implant
	name = "Codex Implant"
	uid = "gear_augmentation_codex"
	description = "A neural implant that provides access to the codex."
	path = /obj/item/implant/codex
	custom_setup_proc_arguments = list(BP_HEAD)
	cost = 0

/decl/loadout_option/augmentation/codex_implant/can_be_taken_by(mob/living/user)
	if(!get_config_value(/decl/config/toggle/codex_requires_implant))
		return FALSE
	return ..()