var/global/list/_tool_quality_cache    = list()
var/global/list/_tool_properties_cache = list()

/obj/item/tool_component/head
	name = "tool head"
	icon                     = 'icons/obj/items/tool/components/tool_head.dmi'
	abstract_type            = /obj/item/tool_component/head

	var/tool_type
	var/list/tool_qualities
	var/list/tool_properties

/obj/item/tool_component/head/Initialize(ml, material_key)
	if(tool_type)
		tool_qualities  = tool_qualities  || global._tool_quality_cache[tool_type]
		tool_properties = tool_properties || global._tool_properties_cache[tool_type]
		if(!tool_qualities || !tool_properties)
			var/obj/item/tool/thing = new tool_type
			if(!tool_qualities)
				tool_qualities = thing.get_initial_tool_qualities()
				global._tool_quality_cache[tool_type] = tool_qualities
			if(!tool_properties)
				tool_properties = thing.get_initial_tool_properties()
				global._tool_properties_cache[tool_type] = tool_properties
			// qdel(thing) //do we need to do this? are we allowed to do it during Initialize()?
	return ..()

/obj/item/tool_component/head/hammer
	name                 = "hammer head"
	desc                 = "The head of a hammer."
	icon_state           = "hammer"

/obj/item/tool_component/head/shovel
	name                 = "shovel head"
	desc                 = "The head of a shovel."
	icon_state           = "shovel"

/obj/item/tool_component/head/hoe
	name                 = "hoe head"
	desc                 = "The head of a hoe."
	icon_state           = "hoe"

/obj/item/tool_component/head/handaxe
	name                 = "hand axe head"
	desc                 = "The head of a hand axe."
	icon_state           = "handaxe"
	tool_type            = /obj/item/tool/axe

/obj/item/tool_component/head/pickaxe
	name                 = "pickaxe head"
	desc                 = "The head of a pickaxe."
	icon_state           = "pickaxe"
	w_class              = ITEM_SIZE_NORMAL

/obj/item/tool_component/head/sledgehammer
	name                 = "sledgehammer head"
	desc                 = "The head of a sledgehammer."
	icon_state           = "sledgehammer"
	w_class              = ITEM_SIZE_NORMAL

