/obj/item/pick/drill
	name            = "mining drill"
	desc            = "The most basic of mining drills, for short excavations and small mineral extractions."
	icon            = 'icons/obj/items/tool/drills/drill.dmi'
	excavation_verb = "drilling"

// TODO: cell extension?
/obj/item/pick/drill/get_initial_tool_qualities()
	return list(
		TOOL_PICK           = TOOL_QUALITY_DECENT,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE
	)

/obj/item/pick/drill/advanced
	name            = "advanced mining drill" // Can dig sand as well!
	desc            = "Yours is the drill that will pierce through the rock walls."
	icon            = 'icons/obj/items/tool/drills/drill_advanced.dmi'
	origin_tech     = @'{"materials":2,"powerstorage":3,"engineering":2}'
	matter          = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/pick/drill/advanced/get_initial_tool_qualities()
	return list(
		TOOL_PICK           = TOOL_QUALITY_GOOD,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL         = TOOL_QUALITY_MEDIOCRE
	)

/obj/item/pick/drill/diamond //When people ask about the badass leader of the mining tools, they are talking about ME!
	name            = "diamond mining drill"
	desc            = "Yours is the drill that will pierce the heavens!"
	icon            = 'icons/obj/items/tool/drills/drill_diamond.dmi'
	origin_tech     = @'{"materials":6,"powerstorage":4,"engineering":5}'
	material        = /decl/material/solid/metal/steel
	matter          = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

/obj/item/pick/drill/diamond/get_initial_tool_qualities()
	return list(
		TOOL_PICK           = TOOL_QUALITY_BEST,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL         = TOOL_QUALITY_MEDIOCRE
	)
