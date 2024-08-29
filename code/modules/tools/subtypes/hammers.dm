/obj/item/tool/hammer
	name                = "hammer"
	desc                = "A simple hammer. Ancient technology once thought lost."
	icon                = 'icons/obj/items/tool/hammers/hammer.dmi'
	sharp               = 0
	edge                = 0

/obj/item/tool/hammer/get_initial_tool_properties()
	var/static/list/tool_properties = list(
		TOOL_PICK = list(
			TOOL_PROP_EXCAVATION_DEPTH = 200,
			TOOL_PROP_VERB             = "hammering"
		)
	)
	return tool_properties

/obj/item/tool/hammer/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(TOOL_HAMMER = TOOL_QUALITY_DEFAULT)
	return tool_qualities

/obj/item/tool/hammer/sledge
	name                = "sledgehammer"
	desc                = "A heavy two-handed construction hammer. Great for smashing your boss right in the face."
	icon                = 'icons/obj/items/tool/hammers/sledgehammer.dmi'

/obj/item/tool/hammer/sledge/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_HAMMER = TOOL_QUALITY_DEFAULT,
		TOOL_PICK   = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL = TOOL_QUALITY_MEDIOCRE
	)
	return tool_qualities

/obj/item/tool/hammer/jack
	name                = "sonic jackhammer"
	desc                = "A hefty tool that cracks rocks with sonic blasts, perfect for killing cave lizards."
	icon                = 'icons/obj/items/tool/hammers/jackhammer.dmi'
	origin_tech         = @'{"materials":3,"powerstorage":2,"engineering":2}'
	material_alteration = 0

/obj/item/tool/hammer/jack/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_HAMMER         = TOOL_QUALITY_DEFAULT,
		TOOL_PICK           = TOOL_QUALITY_DEFAULT,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL         = TOOL_QUALITY_DECENT
	)
	return tool_qualities
