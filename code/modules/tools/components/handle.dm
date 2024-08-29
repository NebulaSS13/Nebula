/obj/item/tool_component/handle
	name               = "tool handle"
	icon               = 'icons/obj/items/tool/components/tool_handle.dmi'
	material           = /decl/material/solid/organic/wood
	abstract_type      = /obj/item/tool_component/handle

/obj/item/tool_component/handle/short
	name               = "short tool handle"
	desc               = "A short, straight rod suitable for use as the handle of a tool."
	icon_state         = "handle_short"

/obj/item/tool_component/handle/long
	name               = "long tool handle"
	desc               = "A long, hefty rod suitable for use as the handle of a heavy tool."
	icon_state         = "handle_long"
	_base_attack_force = 8 // bonk
	w_class            = ITEM_SIZE_NORMAL
