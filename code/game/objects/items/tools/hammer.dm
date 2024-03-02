/obj/item/pick/hammer
	name            = "hammer"
	desc            = "A simple hammer. Ancient technology once thought lost."
	icon            = 'icons/obj/items/tool/drills/hammer.dmi'
	excavation_verb = "hammering"
	sharp           = 0
	edge            = 0

/obj/item/pick/hammer
	return list(TOOL_HAMMER = TOOL_QUALITY_DEFAULT)

/obj/item/pick/hammer/sledge
	name            = "sledgehammer"
	desc            = "A heavy two-handed construction hammer. Great for smashing your boss right in the face."
	icon            = 'icons/obj/items/tool/drills/sledgehammer.dmi'

/obj/item/pick/hammer/sledge/get_initial_tool_qualities()
	return list(
		TOOL_HAMMER = TOOL_QUALITY_DEFAULT,
		TOOL_PICK   = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL = TOOL_QUALITY_MEDIOCRE
	)

/obj/item/pick/hammer/jack
	name            = "sonic jackhammer"
	desc            = "A hefty tool that cracks rocks with sonic blasts, perfect for killing cave lizards."
	icon            = 'icons/obj/items/tool/drills/jackhammer.dmi'
	origin_tech     = @'{"materials":3,"powerstorage":2,"engineering":2}'

/obj/item/pick/hammer/jack/get_initial_tool_qualities()
	return list(
		TOOL_HAMMER         = TOOL_QUALITY_DEFAULT,
		TOOL_PICK           = TOOL_QUALITY_DEFAULT,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL         = TOOL_QUALITY_DECENT
	)
