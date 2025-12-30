/obj/item/banner
	name                 = "banner"
	base_name            = "banner" // necessary for premapped subtypes
	desc                 = "A furled-up banner."
	icon                 = 'icons/obj/items/banners/banner.dmi'
	icon_state           = ICON_STATE_WORLD
	material             = /decl/material/solid/organic/cloth
	color                = /decl/material/solid/organic/cloth::color
	max_health           = 20
	material_alteration  = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	w_class              = ITEM_SIZE_NORMAL
	var/colourise_decal  = TRUE
	var/hung_desc        = "The banner is rather unremarkable."
	var/banner_type      = /obj/item/banner
	var/embroiderable    = TRUE
	var/list/decals
	var/trim_color

/obj/item/banner/Initialize(ml, material_key)
	for(var/decal in decals)
		if(ispath(decal))
			var/decl/banner_symbol/decal_decl = GET_DECL(decal)
			decals[decal_decl] = decals[decal]
			decals -= decal
	. = ..()

var/global/list/banner_type_to_symbols = list()
/obj/item/banner/proc/get_available_decals()
	. = global.banner_type_to_symbols[banner_type]
	if(!.)
		. = list()
		for(var/decl/banner_symbol/symbol in decls_repository.get_decls_of_type_unassociated(/decl/banner_symbol))
			if(banner_type in symbol.usable_by_banner_type)
				. += symbol
		global.banner_type_to_symbols[banner_type] = .

// TODO: PROPER EMBROIDERY AND ITEM DECORATION.
/obj/item/banner/attackby(obj/item/used_item, mob/user)

	if(embroiderable && istype(used_item, /obj/item/stack/material/thread))

		// TODO: check material crafting skill and do a do_after()

		if((!length(get_available_decals()) || length(decals)) && trim_color)
			to_chat(user, SPAN_WARNING("\The [src] is already as decorated as it can be."))
			return TRUE

		var/obj/item/stack/material/thread/used_stack = used_item
		if(used_stack.get_amount() < 5)
			to_chat(user, SPAN_WARNING("You need at least five lengths of thread to embroider a banner."))
			return TRUE

		if(!trim_color)
			user.visible_message("\The [user] sews a trim onto \the [src].")
			trim_color = used_item.color
			used_stack.use(5)
			return TRUE

		if(length(get_available_decals()) && !length(decals))
			var/list/available_decals = get_available_decals()
			var/decal_color = used_item.color
			var/decal_to_sew = input(user, "Which symbol do you wish to add to \the [src]?", "Banner Symbol") as null|anything in available_decals
			if(decal_to_sew && CanPhysicallyInteract(user) && !length(decals) && user.get_active_held_item() == used_item && used_stack.use(5))
				decals[decal_to_sew] = decal_color
			return TRUE

	. = ..()

/obj/item/banner/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/decorations = get_decal_string()
	if(decorations)
		. += "\The [src] is decorated with [decorations]."

/obj/item/banner/proc/get_decal_string()
	for(var/decl/banner_symbol/decal in decals)
		if(colourise_decal)
			LAZYADD(., "\a <font color='[decals[decal]]'>[decal.name]</font>")
		else
			LAZYADD(., "\a [decal.name]")
	if(trim_color)
		// This is weak but I'm not sure how else to phrase it without a color-to-string system.
		LAZYADD(., "a <font color='[trim_color]'>trim</font>")
	if(.)
		return english_list(.)

/obj/item/banner/forked
	name_prefix         = "forked"
	hung_desc           = "The banner splits into two tails at the bottom."
	icon                = 'icons/obj/items/banners/banner_forked.dmi'

/obj/item/banner/forked/get_available_decals()
	return null // Current decals do not work nicely with the fork

/obj/item/banner/pointed
	name_prefix         = "pointed"
	hung_desc           = "The banner narrows to a point at the bottom."
	icon                = 'icons/obj/items/banners/banner_pointed.dmi'

/obj/item/banner/rounded
	name_prefix         = "rounded"
	hung_desc           = "The banner has a rounded lower edge."
	icon                = 'icons/obj/items/banners/banner_rounded.dmi'

/obj/item/banner/square
	name_prefix         = "square"
	hung_desc           = "The banner has a squared-off lower edge."
	icon                = 'icons/obj/items/banners/banner_square.dmi'

/obj/item/banner/tasselled
	name_prefix         = "tasselled"
	hung_desc           = "The banner has several dangling tassels at the bottom."
	icon                = 'icons/obj/items/banners/banner_tasselled.dmi'

/obj/item/banner/woven
	name_prefix         = "woven"
	icon                = 'icons/obj/items/banners/banner_woven.dmi'
	material            = /decl/material/solid/organic/plantmatter/grass/dry
	color               = /decl/material/solid/organic/plantmatter/grass/dry::color
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	hung_desc           = "The woven banner is rustic and uneven."

/obj/item/banner/green
	name        = "green banner"
	paint_color = COLOR_GREEN
	color       = COLOR_GREEN

/obj/item/banner/red
	name        = "red banner"
	paint_color = COLOR_RED
	color       = COLOR_RED

/obj/item/banner/blue
	name        = "blue banner"
	paint_color = COLOR_BLUE
	color       = COLOR_BLUE
