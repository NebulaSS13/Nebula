/obj/item/pick/axe
	name                = "pickaxe"
	desc                = "A heavy tool with a pick head for prospecting for minerals, and an axe head for dealing with anyone with a prior claim."
	icon_state          = "preview"
	icon                = 'icons/obj/items/tool/drills/pickaxe.dmi'
	sharp               = TRUE
	edge                = TRUE
	force               = 15
	material            = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/handle_color    = COLOR_BEASTY_BROWN

/obj/item/pick/axe/on_update_icon()
	. = ..()
	var/image/I = image(icon, "[icon_state]-handle")
	I.color = handle_color
	I.appearance_flags |= RESET_COLOR
	add_overlay(I)

/obj/item/pick/axe/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay && check_state_in_icon("[overlay.icon_state]-handle", overlay.icon))
		var/image/handle = image(overlay.icon, "[overlay.icon_state]-handle")
		handle.color = handle_color
		handle.appearance_flags |= RESET_COLOR
		overlay.overlays += handle
	. = ..()

/obj/item/pick/axe/titanium
	origin_tech = @'{"materials":3}'
	material    = /decl/material/solid/metal/titanium

/obj/item/pick/axe/titanium/get_initial_tool_qualities()
	return list(
		TOOL_PICK   = TOOL_QUALITY_DECENT,
		TOOL_SHOVEL = TOOL_QUALITY_DEFAULT
	)

/obj/item/pick/axe/plasteel
	origin_tech = @'{"materials":4}'
	material    = /decl/material/solid/metal/plasteel

/obj/item/pick/axe/plasteel/get_initial_tool_qualities()
	return list(
		TOOL_PICK   = TOOL_QUALITY_GOOD,
		TOOL_SHOVEL = TOOL_QUALITY_DECENT
	)

/obj/item/pick/axe/ocp
	origin_tech = @'{"materials":6,"engineering":4}'
	material    = /decl/material/solid/metal/plasteel/ocp

/obj/item/pick/axe/ocp/get_initial_tool_qualities()
	return list(
		TOOL_PICK   = TOOL_QUALITY_BEST,
		TOOL_SHOVEL = TOOL_QUALITY_GOOD
	)
