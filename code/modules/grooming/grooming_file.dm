/obj/item/grooming/file
	name     = "nail file"
	desc     = "A rugged file suitable for smoothing down unruly nails or horns."
	icon     = 'icons/obj/items/grooming/file.dmi'
	material = /decl/material/solid/metal/steel

	message_target_other_generic = "$USER$ uses $TOOL$ to neaten $TARGET$ up."
	message_target_self_generic  = "$USER$ uses $TOOL$ to neaten $USER_SELF$ up."
	message_target_other         = "$USER$ carefully files down $TARGET$'s $DESCRIPTOR$ with $TOOL$."
	message_target_self          = "$USER$ carefully files down $USER_HIS$ $DESCRIPTOR$ with $TOOL$."
	grooming_flags               = GROOMABLE_FILE

/obj/item/grooming/file/colorable
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
