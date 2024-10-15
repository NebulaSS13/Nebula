/obj/item/tool/drill
	name                = "mining drill"
	desc                = "The most basic of mining drills, for short excavations and small mineral extractions."
	icon                = 'icons/obj/items/tool/drills/drill.dmi'
	material_alteration = 0
	w_class             = ITEM_SIZE_HUGE

/obj/item/tool/drill/Initialize(ml, material_key, _handle_material, _binding_material, override_tool_qualities, override_tool_properties)
	. = ..()
	set_extension(src, /datum/extension/demolisher/pick)

/obj/item/tool/drill/get_handle_color()
	return null

/obj/item/tool/drill/get_initial_tool_properties()
	var/static/list/tool_properties = list(
		TOOL_PICK = list(
			TOOL_PROP_EXCAVATION_DEPTH = 200,
			TOOL_PROP_VERB             = "drilling"
		)
	)
	return tool_properties

// TODO: cell extension?
/obj/item/tool/drill/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_PICK           = TOOL_QUALITY_DECENT,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE
	)
	return tool_qualities

/obj/item/tool/drill/advanced
	name            = "advanced mining drill" // Can dig sand as well!
	desc            = "Yours is the drill that will pierce through the rock walls."
	icon            = 'icons/obj/items/tool/drills/drill_advanced.dmi'
	origin_tech     = @'{"materials":2,"powerstorage":3,"engineering":2}'
	matter          = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/tool/drill/advanced/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_PICK           = TOOL_QUALITY_GOOD,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL         = TOOL_QUALITY_MEDIOCRE
	)
	return tool_qualities

/obj/item/tool/drill/diamond //When people ask about the badass leader of the mining tools, they are talking about ME!
	name            = "diamond mining drill"
	desc            = "Yours is the drill that will pierce the heavens!"
	icon            = 'icons/obj/items/tool/drills/drill_diamond.dmi'
	origin_tech     = @'{"materials":6,"powerstorage":4,"engineering":5}'
	material        = /decl/material/solid/metal/steel
	matter          = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

/obj/item/tool/drill/diamond/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_PICK           = TOOL_QUALITY_BEST,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL         = TOOL_QUALITY_MEDIOCRE
	)
	return tool_qualities