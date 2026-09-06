/obj/item/crutch
	abstract_type = /obj/item/crutch
	name = "crutch"
	desc = "A mobility aid for those with impaired use of their legs or feet, placed underneath the arm for support."
	icon = 'icons/obj/items/crutches.dmi'
	icon_state = ICON_STATE_WORLD
	base_parry_chance = 10
	material_alteration = MAT_FLAG_ALTERATION_ALL
	w_class = ITEM_SIZE_LARGE
	max_health = null // autoset from material
	/// The padding extension type for this item. If null, no extension is created and this item cannot be padded.
	var/padding_extension_type = /datum/extension/padding
	/// The initial material used when instantiating this item's padding extension.
	/// Should not be modified at runtime.
	var/decl/material/initial_padding_material
	/// The initial color used for the padding, representing paint or dye.
	/// If null, falls back to material color if we have MAT_FLAG_ALTERATION_COLOR.
	/// COLOR_WHITE is treated differently than null color is.
	var/initial_padding_color

/obj/item/crutch/Initialize(ml, material_key)
	. = ..()
	if(padding_extension_type && initial_padding_material)
		get_or_create_extension(src, padding_extension_type, initial_padding_material, initial_padding_color)

/obj/item/crutch/get_stance_support_value()
	return LIMB_UNUSABLE

/obj/item/crutch/get_autopsy_descriptors()
	. = ..() + "narrow"

/obj/item/crutch/on_update_icon()
	. = ..()
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		add_overlay(overlay_image(icon, "[icon_state]-padding", padding_extension.get_padding_color(material_alteration & MAT_FLAG_ALTERATION_COLOR), RESET_COLOR | RESET_ALPHA))

/obj/item/crutch/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		overlay.add_overlay(overlay_image(icon, "[overlay.icon_state]-padding", padding_extension.get_padding_color(material_alteration & MAT_FLAG_ALTERATION_COLOR), RESET_COLOR | RESET_ALPHA))
	. = ..()

/obj/item/crutch/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		var/padding_paint_color = padding_extension.get_padding_color(FALSE) // do not include material color
		. += "It has been padded with [padding_paint_color ? "<font color='[padding_paint_color]'>[padding_material.paint_verb]</font> " : null][padding_material.use_name]."

/obj/item/crutch/aluminum
	material = /decl/material/solid/metal/aluminium

/obj/item/crutch/aluminum/padded
	initial_padding_material = /decl/material/solid/organic/plastic/foam
	initial_padding_color = COLOR_GRAY20

/obj/item/crutch/wooden
	material = /decl/material/solid/organic/wood/oak

/obj/item/crutch/wooden/padded
	initial_padding_material = /decl/material/solid/organic/leather