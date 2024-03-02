/obj/item/pick/hammer
	name            = "sledgehammer"
	desc            = "A mining hammer made of reinforced metal. Great for smashing your boss right in the face."
	icon            = 'icons/obj/items/tool/drills/sledgehammer.dmi'
	excavation_verb = "hammering"
	sharp           = 0
	edge            = 0

/obj/item/pick/hammer/jack
	name            = "sonic jackhammer"
	desc            = "A hefty tool that cracks rocks with sonic blasts, perfect for killing cave lizards."
	icon            = 'icons/obj/items/tool/drills/jackhammer.dmi'
	origin_tech     = @'{"materials":3,"powerstorage":2,"engineering":2}'

/obj/item/pick/hammer/jack/get_initial_tool_qualities()
	return list(
		TOOL_PICK           = TOOL_QUALITY_DEFAULT,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL         = TOOL_QUALITY_DECENT
	)
