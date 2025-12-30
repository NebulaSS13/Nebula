// Beds... get your mind out of the gutter, they're for sleeping!
/obj/structure/bed
	name = "bed"
	desc = "A raised, padded platform for sleeping on. This one has straps for ensuring restful snoozing in microgravity."
	icon = 'icons/obj/structures/furniture/bed.dmi'
	icon_state = ICON_STATE_WORLD
	anchored = TRUE
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_lying = TRUE
	buckle_sound = 'sound/effects/buckle.ogg'
	material = DEFAULT_FURNITURE_MATERIAL
	material_alteration = MAT_FLAG_ALTERATION_ALL
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	parts_amount = 2
	parts_type = /obj/item/stack/material/rods
	user_comfort = 1
	obj_flags = OBJ_FLAG_SUPPORT_MOB
	monetary_worth_multiplier = 2.5 // Utility structures should be worth more than their matter (wheelchairs, rollers, etc).
	/// The padding extension type for this bed. If null, no extension is created and this bed cannot be padded.
	var/padding_extension_type = /datum/extension/padding
	var/decl/material/initial_padding_material
	var/initial_padding_color

/obj/structure/bed/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	if(padding_extension_type && initial_padding_material)
		get_or_create_extension(src, padding_extension_type, initial_padding_material, initial_padding_color)

/obj/structure/bed/user_can_mousedrop_onto(mob/user, atom/being_dropped, incapacitation_flags, params)
	if(user == being_dropped)
		return user.Adjacent(src) && !user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT)
	return ..()

/obj/structure/bed/get_surgery_surface_quality(mob/living/victim, mob/living/user)
	return OPERATE_PASSABLE

/obj/structure/bed/get_surgery_success_modifier(delicate)
	return delicate ? -5 : 0

/obj/structure/bed/update_material_name(override_name)
	var/base_name = override_name || initial(name)
	var/new_name = base_name
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		SetName("[padding_material.adjective_name] [base_name]")
	else if(material)
		new_name = "[material.adjective_name] [base_name]"
	if(name_prefix)
		new_name = "[name_prefix] [new_name]"
	SetName(new_name)

/obj/structure/bed/update_material_desc(override_desc)
	var/base_desc = override_desc || initial(desc)
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		desc = "[base_desc] It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		desc = "[base_desc] It's made of [material.use_name]."

/obj/structure/bed/on_update_icon()
	..()
	icon_state = ICON_STATE_WORLD
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		add_overlay(overlay_image(icon, "[icon_state]_padding", material_alteration & MAT_FLAG_ALTERATION_COLOR ? padding_extension.get_padding_color() : null, RESET_COLOR|RESET_ALPHA))

// Used to allow things to pass over dense beds, e.g. rollerbeds, ironing boards
/obj/structure/bed/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return TRUE
	return ..()

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon = 'icons/obj/structures/furniture/bed_psych.dmi'
	material = /decl/material/solid/organic/wood/walnut

/obj/structure/bed/psych/leather
	initial_padding_material = /decl/material/solid/organic/leather

/obj/structure/bed/padded
	material = /decl/material/solid/metal/aluminium
	initial_padding_material = /decl/material/solid/organic/cloth
