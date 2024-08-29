/obj/item/tool/shovel
	name               = "shovel"
	desc               = "A large tool for digging and moving dirt."
	icon               = 'icons/obj/items/tool/shovels/shovel.dmi'
	icon_state         = ICON_STATE_WORLD
	slot_flags         = SLOT_LOWER_BODY
	w_class            = ITEM_SIZE_HUGE
	edge               = TRUE
	sharp              = TRUE
	attack_verb        = list("bashed", "bludgeoned", "thrashed", "whacked")
	handle_material    = /decl/material/solid/organic/wood
	_base_attack_force = 8

/obj/item/tool/shovel/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_SHOVEL = TOOL_QUALITY_DEFAULT,
		TOOL_HOE    = TOOL_QUALITY_BAD
	)
	return tool_qualities

/obj/item/tool/shovel/wood
	material = /decl/material/solid/organic/wood

/obj/item/tool/shovel/one_material/Initialize(ml, material_key, _handle_material, _binding_material, override_tool_qualities, override_tool_properties)
	return ..(ml, material_key, material_key, _binding_material, override_tool_qualities, override_tool_properties)

/obj/item/tool/spade
	name                = "spade"
	desc                = "A small tool for digging and moving dirt."
	icon                = 'icons/obj/items/tool/shovels/spade.dmi'
	icon_state          = ICON_STATE_WORLD
	w_class             = ITEM_SIZE_SMALL
	edge                = FALSE
	sharp               = FALSE
	slot_flags          = SLOT_LOWER_BODY
	attack_verb         = list("bashed", "bludgeoned", "thrashed", "whacked")
	material_alteration = 0
	handle_material     = /decl/material/solid/organic/plastic
	_base_attack_force  = 5

/obj/item/tool/spade/get_handle_color()
	return null

/obj/item/tool/spade/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_SHOVEL = TOOL_QUALITY_BAD,
		TOOL_HOE    = TOOL_QUALITY_MEDIOCRE

	)
	return tool_qualities
