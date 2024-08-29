/obj/item/tool/pickaxe
	name               = "pickaxe"
	desc               = "A heavy tool with a pick head for prospecting for minerals, and an axe head for dealing with anyone with a prior claim."
	icon_state         = "preview"
	icon               = 'icons/obj/items/tool/pickaxe.dmi'
	sharp              = TRUE
	edge               = TRUE
	handle_material    = /decl/material/solid/organic/wood
	_base_attack_force = 15

/obj/item/tool/pickaxe/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_PICK   = TOOL_QUALITY_DEFAULT,
		TOOL_SHOVEL = TOOL_QUALITY_MEDIOCRE,
		TOOL_HAMMER = TOOL_QUALITY_MEDIOCRE
	)
	return tool_qualities

/obj/item/tool/pickaxe/get_initial_tool_properties()
	var/static/list/tool_properties = list(
		TOOL_PICK = list(
			TOOL_PROP_EXCAVATION_DEPTH = 200
		)
	)
	return tool_properties

// Using these mainly for debugging.
/obj/item/tool/pickaxe/wood
	material           = /decl/material/solid/organic/wood

/obj/item/tool/pickaxe/stone
	material           = /decl/material/solid/stone/flint

/obj/item/tool/pickaxe/titanium
	origin_tech        = @'{"materials":3}'
	material           = /decl/material/solid/metal/titanium

/obj/item/tool/pickaxe/titanium/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_PICK   = TOOL_QUALITY_DECENT,
		TOOL_SHOVEL = TOOL_QUALITY_DEFAULT,
		TOOL_HAMMER = TOOL_QUALITY_MEDIOCRE
	)
	return tool_qualities

/obj/item/tool/pickaxe/plasteel
	origin_tech        = @'{"materials":4}'
	material           = /decl/material/solid/metal/plasteel

/obj/item/tool/pickaxe/plasteel/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_PICK   = TOOL_QUALITY_GOOD,
		TOOL_SHOVEL = TOOL_QUALITY_DECENT,
		TOOL_HAMMER = TOOL_QUALITY_MEDIOCRE
	)
	return tool_qualities

/obj/item/tool/pickaxe/ocp
	origin_tech        = @'{"materials":6,"engineering":4}'
	material           = /decl/material/solid/metal/plasteel/ocp

/obj/item/tool/pickaxe/ocp/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_PICK   = TOOL_QUALITY_BEST,
		TOOL_SHOVEL = TOOL_QUALITY_GOOD,
		TOOL_HAMMER = TOOL_QUALITY_MEDIOCRE
	)
	return tool_qualities

/obj/item/tool/pickaxe/iron
	material           = /decl/material/solid/metal/iron
	handle_material    = /decl/material/solid/organic/wood/ebony
