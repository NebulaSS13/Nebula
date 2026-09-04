/obj/item/tool/hammer
	name                = "hammer"
	desc                = "A simple hammer. Ancient technology once thought lost."
	icon                = 'icons/obj/items/tool/hammers/hammer.dmi'
	attack_verb         = list(
		"bludgeons",
		"slaps",
		"beats",
		"strikes",
		"bashes",
		"hammers"
	)
	var/demolisher_type = /datum/extension/demolisher/delicate

/obj/item/tool/hammer/Initialize(ml, material_key, _handle_material, _binding_material, override_tool_qualities, override_tool_properties)
	. = ..()
	if(demolisher_type)
		set_extension(src, demolisher_type, null, "demolishing", 'sound/effects/bang.ogg')

/obj/item/tool/hammer/get_initial_tool_properties()
	var/static/list/tool_properties = list(
		TOOL_PICK = list(
			TOOL_PROP_EXCAVATION_DEPTH = 200,
			TOOL_PROP_VERB             = "hammering"
		)
	)
	return tool_properties

/obj/item/tool/hammer/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_HAMMER  = TOOL_QUALITY_DEFAULT,
		TOOL_CROWBAR = TOOL_QUALITY_WORST
	)
	return tool_qualities

/obj/item/tool/hammer/sledge
	name                = "sledgehammer"
	desc                = "A heavy two-handed construction hammer. Great for smashing your boss right in the face."
	icon                = 'icons/obj/items/tool/hammers/sledgehammer.dmi'
	can_be_twohanded    = TRUE
	_base_attack_force  = 17
	attack_verb         = list(
		"brutalizes",
		"bludgeons",
		"beats",
		"crushes",
		"strikes",
		"bashes",
		"hammers"
	)
	demolisher_type = /datum/extension/demolisher
	w_class             = ITEM_SIZE_HUGE

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
	can_be_twohanded    = TRUE
	_base_attack_force  = 15
	w_class             = ITEM_SIZE_HUGE

/obj/item/tool/hammer/jack/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_HAMMER         = TOOL_QUALITY_DEFAULT,
		TOOL_PICK           = TOOL_QUALITY_DEFAULT,
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE,
		TOOL_SHOVEL         = TOOL_QUALITY_DECENT
	)
	return tool_qualities

/obj/item/tool/hammer/forge
	name        = "forging hammer"
	desc        = "A heavy hammer, used to forge hot metal at an anvil."
	icon        = 'icons/obj/items/tool/hammers/forge.dmi'
	w_class     = ITEM_SIZE_NORMAL

/obj/item/tool/hammer/forge/iron
	material        = /decl/material/solid/metal/iron
	color           = /decl/material/solid/metal/iron::color
	handle_material = /decl/material/solid/organic/wood/mahogany

// Forging hammers are not great at general hammer tasks (too heavy I guess),
// and also don't work as crowbars due to missing the nail ripper/flange,
// but will be more effective at forging when blacksmithy is merged.
/obj/item/tool/hammer/forge/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_HAMMER  = TOOL_QUALITY_MEDIOCRE
	)
	return tool_qualities
