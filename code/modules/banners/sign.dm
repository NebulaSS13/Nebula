/obj/item/banner/sign
	name                = "sign"
	banner_type         = /obj/item/banner/sign
	embroiderable       = FALSE
	icon                = 'icons/obj/items/banners/sign.dmi'
	material            = /decl/material/solid/organic/wood/oak
	color               = /decl/material/solid/organic/wood/oak::color
	hung_desc           = "The sign is unadorned."
	colourise_decal     = FALSE

/obj/item/banner/sign/attackby(obj/item/used_item, mob/user)
	if(IS_KNIFE(used_item) && user.check_intent(I_FLAG_HELP))
		var/available_decals = get_available_decals()
		if(!length(available_decals) || length(decals))
			to_chat(user, SPAN_WARNING("\The [src] is already as decorated as it can be."))
			return TRUE
		var/decal_to_add = input(user, "Which symbol do you wish to add to \the [src]?", "Sign Symbol") as null|anything in available_decals
		if(decal_to_add && CanPhysicallyInteract(user) && !length(decals) && user.get_active_held_item() == used_item)
			decals[decal_to_add] = COLOR_WHITE
		return TRUE
	. = ..()

/obj/item/banner/sign/random/Initialize(ml, material_key)
	material = pick(decls_repository.get_decls_of_subtype(/decl/material/solid/organic/wood))
	. = ..()
