// what is a sign, if not a wooden banner
/obj/structure/banner_frame/sign
	name                = "sign post"
	desc                = "A post for hanging a sign."
	icon                = 'icons/obj/structures/sign_post.dmi'
	desc                = "A post for hanging a sign."
	base_icon_state     = "sign"
	accepts_banner_type = /obj/item/banner/sign
	icon_state          = "sign_preview"
	density             = TRUE

/obj/structure/banner_frame/sign/wall
	base_icon_state     = "sign_hanging"
	icon_state          = "sign_hanging_preview"
	force_south_facing  = FALSE
	density             = FALSE

/obj/structure/banner_frame/sign/random/Initialize(ml, _mat, _reinf_mat)
	material = pick(decls_repository.get_decls_of_subtype(/decl/material/solid/organic/wood))
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/banner_frame/sign/random/LateInitialize()
	. = ..()
	var/obj/item/banner/new_banner = new /obj/item/banner/sign/random(src)
	if(new_banner)
		var/list/available_decals = new_banner.get_available_decals()
		if(length(available_decals))
			var/decal = pick(available_decals)
			LAZYSET(new_banner.decals, decal, COLOR_WHITE)
		new_banner.update_icon()
		set_banner(new_banner)
