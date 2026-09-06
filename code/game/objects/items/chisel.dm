/obj/item/tool/chisel
	name             = "chisel"
	desc             = "A hard, sharpened tool used to chisel stone, wood or bone."
	icon_state       = ICON_STATE_WORLD
	icon             = 'icons/obj/items/tool/chisel.dmi'
	material         = /decl/material/solid/metal/steel
	handle_material  = /decl/material/solid/organic/plastic
	binding_material = null

/obj/item/tool/chisel/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_CHISEL = TOOL_QUALITY_DEFAULT
	)
	return tool_qualities

/obj/item/tool/chisel/forged
	handle_material  = null
