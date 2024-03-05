var/global/list/_tool_quality_cache    = list()
var/global/list/_tool_properties_cache = list()

/obj/item/tool_component/head
	icon                     = 'icons/obj/items/tool/components/tool_head.dmi'
	abstract_type            = /obj/item/tool_component/head
	var/requires_handle_type = /obj/item/tool_component/handle/short

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

/obj/item/tool_component/head/attackby(obj/item/W, mob/user)
	if(tool_type && istype(W, /obj/item/tool_component/handle))
		if(!istype(W, requires_handle_type))
			var/obj/handle_ref = requires_handle_type
			var/obj/tool_ref   = tool_type
			to_chat(user, SPAN_WARNING("You need \a [initial(handle_ref.name)] to craft \a [initial(tool_ref.name)]."))
			return TRUE
		if(ismob(loc))
			var/mob/M = loc
			M.drop_from_inventory(src)
		if(ismob(W.loc))
			var/mob/M = W.loc
			M.drop_from_inventory(W)
		var/obj/item/crafted = new tool_type(get_turf(user), material?.type, W.material?.type, tool_qualities, tool_properties)
		if(crafted)
			user?.put_in_hands(crafted)
		to_chat(user, SPAN_NOTICE("You assemble \the [W] and \the [src] into \a [crafted]!"))
		qdel(W)
		qdel(src)
		return TRUE
	return ..()

/obj/item/tool_component/head/proc/try_craft_tool(mob/user, obj/item/tool_component/head/head)
	return FALSE

/obj/item/tool_component/head/hammer
	name                 = "hammer head"
	desc                 = "The head of a claw hammer."
	icon_state           = "hammer"
	tool_type            = /obj/item/tool/hammer

/obj/item/tool_component/head/shovel
	name                 = "shovel head"
	desc                 = "The head of a shovel."
	icon_state           = "shovel"
	tool_type            = /obj/item/tool/shovel

/obj/item/tool_component/head/pickaxe
	name                 = "pickaxe head"
	desc                 = "The head of a pickaxe."
	icon_state           = "pickaxe"
	tool_type            = /obj/item/tool/pickaxe
	requires_handle_type = /obj/item/tool_component/handle/long
	w_class              = ITEM_SIZE_NORMAL

/obj/item/tool_component/head/sledgehammer
	name                 = "sledgehammer head"
	desc                 = "The head of a sledgehammer."
	icon_state           = "sledgehammer"
	tool_type            = /obj/item/tool/hammer/sledge
	requires_handle_type = /obj/item/tool_component/handle/long
	w_class              = ITEM_SIZE_NORMAL
