/decl/bodytype/quadruped
	abstract_type     = /decl/bodytype/quadruped
	rotate_on_prone   = FALSE
	bodytype_category = BODYTYPE_QUADRUPED
	bodytype_flag     = BODY_EQUIP_FLAG_QUADRUPED
	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/gripper),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/quadruped),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/quadruped),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/quadruped),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/quadruped),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/quadruped),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/quadruped),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/quadruped),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/quadruped)
	)
	var/rideable = TRUE
	var/riding_offset = @'{"x":0,"y":0,"z":8}'

/decl/bodytype/quadruped/apply_appearance(var/mob/living/human/H)
	. = ..()
	H.can_buckle         = rideable
	H.buckle_pixel_shift = riding_offset

/decl/bodytype/quadruped/get_ignited_icon_state(mob/living/victim)
	return "Generic_mob_burning"