/////////////////////////////////////////
//Seals and Signet Rings
/obj/item/clothing/gloves/ring/seal
	name = "signet ring"
	desc = "A ring with a heavy setting for pressing into hot wax to seal letters."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_seal.dmi'
	material = /decl/material/solid/metal/silver

/obj/item/clothing/gloves/ring/seal/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_STAMP = TOOL_QUALITY_DEFAULT))

/obj/item/clothing/gloves/ring/seal/mason
	name = "masonic ring"
	desc = "The Square and Compasses feature prominently on this Masonic ring."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_seal_masonic.dmi'
	material = /decl/material/solid/metal/brass
	use_material_name = FALSE

/obj/item/clothing/gloves/ring/seal/signet
	name = "signet ring"
	desc = "A signet ring, for when you're too sophisticated to sign letters."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_seal_signet.dmi'
	use_material_name = FALSE
	var/name_set = FALSE

/obj/item/clothing/gloves/ring/seal/signet/attack_self(mob/user)
	if(!user.check_intent(I_FLAG_HELP))
		return ..()
	if(name_set)
		to_chat(user, SPAN_NOTICE("\The [src] has already been claimed!"))
	else
		name_set = TRUE
		to_chat(user, SPAN_NOTICE("You claim \the [src] as your own!"))
		base_name = "\the [user]'s signet ring"
		desc = "A signet ring belonging to [user], for when they're too sophisticated to sign letters."
	return TRUE
