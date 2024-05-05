/obj/item/tool_component
	name = "tool component"
	abstract_type = /obj/item/tool_component
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	w_class = ITEM_SIZE_SMALL

/obj/item/tool_component/get_mould_difficulty()
	return SKILL_NONE
