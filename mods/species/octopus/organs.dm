/decl/natural_attack/punch/tentacle
	attack_verb = list("smacked", "slapped", "swiped")
	attack_noun = list("tentacle")
	eye_attack_text = "tentacle"
	eye_attack_text_victim = "tentacle"

/obj/item/organ/internal/heart/octopus
	name = "hearts"
	gender = PLURAL

/obj/item/organ/internal/lungs/gills/octopus
	name = "funnel"
	gender = NEUTER

/obj/item/organ/external/groin/unbreakable/octopus
	organ_categories = @"['" + ORGAN_CATEGORY_STANCE_ROOT + "']"
	encased = null

/obj/item/organ/external/head/unbreakable/octopus
	joint = "spine"
	amputation_point = "neck"
	encased = null

/obj/item/organ/external/chest/unbreakable/octopus
	encased = null

/obj/item/organ/external/octopus_limb
	abstract_type = /obj/item/organ/external/octopus_limb
	joint = "base"
	amputation_point = "base"
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_FINGERPRINT | ORGAN_FLAG_HAS_TENDON | ORGAN_FLAG_CAN_STAND
	parent_organ = BP_GROIN
	organ_categories = @"['" + ORGAN_CATEGORY_STANCE + "', '" + ORGAN_CATEGORY_MANIPLE + "']"
	var/gripper_type

/obj/item/organ/external/octopus_limb/do_install(mob/living/human/target, affected, in_place, update_icon, detached)
	. = ..()
	if(. && owner && gripper_type)
		owner.add_held_item_slot(new gripper_type)

/obj/item/organ/external/octopus_limb/do_uninstall(in_place, detach, ignore_children, update_icon)
	if(gripper_type)
		owner?.remove_held_item_slot(organ_tag)
	. = ..()

/obj/item/organ/external/octopus_limb/get_natural_attacks()
	var/static/list/natural_attacks = list(
		/decl/natural_attack/punch/tentacle
	)
	return natural_attacks

/obj/item/organ/external/octopus_limb/first
	name = "first tentacle"
	gripper_type = /datum/inventory_slot/gripper/tentacle/first
	organ_tag = BP_TENTACLE_1
	icon_position = LEFT

/obj/item/organ/external/octopus_limb/second
	name = "second tentacle"
	gripper_type = /datum/inventory_slot/gripper/tentacle/second
	organ_tag = BP_TENTACLE_2
	icon_position = RIGHT

/obj/item/organ/external/octopus_limb/third
	name = "third tentacle"
	gripper_type = /datum/inventory_slot/gripper/tentacle/third
	organ_tag = BP_TENTACLE_3
	icon_position = LEFT

/obj/item/organ/external/octopus_limb/fourth
	name = "fourth tentacle"
	gripper_type = /datum/inventory_slot/gripper/tentacle/fourth
	organ_tag = BP_TENTACLE_4
	icon_position = RIGHT

/obj/item/organ/external/octopus_limb/fifth
	name = "fifth tentacle"
	gripper_type = /datum/inventory_slot/gripper/tentacle/fifth
	organ_tag = BP_TENTACLE_5
	icon_position = LEFT

/obj/item/organ/external/octopus_limb/sixth
	name = "sixth tentacle"
	gripper_type = /datum/inventory_slot/gripper/tentacle/sixth
	organ_tag = BP_TENTACLE_6
	icon_position = RIGHT

/obj/item/organ/external/octopus_limb/seventh
	name = "seventh tentacle"
	gripper_type = /datum/inventory_slot/gripper/tentacle/seventh
	organ_tag = BP_TENTACLE_7
	icon_position = LEFT

/obj/item/organ/external/octopus_limb/eighth
	name = "eighth tentacle"
	gripper_type = /datum/inventory_slot/gripper/tentacle/eighth
	organ_tag = BP_TENTACLE_8
	icon_position = RIGHT
