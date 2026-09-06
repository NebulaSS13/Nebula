// Mapping helpers below.
/obj/structure/banner_frame/blue
	banner = /obj/item/banner/blue
	color  = /obj/item/banner/blue::color // Mapping preview colour.

/obj/structure/banner_frame/red
	banner = /obj/item/banner/red
	color  = /obj/item/banner/red::color

/obj/structure/banner_frame/green
	banner = /obj/item/banner/green
	color  = /obj/item/banner/green::color

/obj/structure/banner_frame/wall/ebony
	material = /decl/material/solid/organic/wood/ebony
	color    = /decl/material/solid/organic/wood/ebony::color

/obj/structure/banner_frame/wall/ebony/red
	banner   = /obj/item/banner/red
	color    = /obj/item/banner/red::color // Mapping preview colour.

/obj/structure/banner_frame/wall/ebony/blue
	banner   = /obj/item/banner/blue
	color    = /obj/item/banner/blue::color

/obj/structure/banner_frame/wall/ebony/green
	banner   = /obj/item/banner/green
	color    = /obj/item/banner/green::color

/obj/structure/banner_frame/wall/ebony/woven
	banner   = /obj/item/banner/woven
	color    = /obj/item/banner/woven::color

// Debug item.
/obj/structure/banner_frame/random/Initialize(ml, _mat, _reinf_mat)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/banner_frame/random/LateInitialize()
	..()
	var/banner_type = pick(list(
		/obj/item/banner/pointed,
		/obj/item/banner/rounded,
		/obj/item/banner/square,
		/obj/item/banner/tasselled,
		/obj/item/banner/woven
	))
	var/obj/item/banner/new_banner = new banner_type(src)
	new_banner.set_color(get_random_colour())
	new_banner.trim_color = get_random_colour()
	var/list/available_decals = new_banner.get_available_decals()
	if(length(available_decals))
		var/decal = pick(available_decals)
		var/decal_color = get_random_colour()
		LAZYSET(new_banner.decals, decal, decal_color)
	new_banner.update_icon()
	set_banner(new_banner)
