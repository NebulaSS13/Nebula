/obj/item/tool/Serialize()
	. = ..()
	SERIALIZE_DECL_IF_MODIFIED(handle_material, /obj/item/tool)
	SERIALIZE_DECL_IF_MODIFIED(binding_material, /obj/item/tool)

/obj/item/tool/Deserialize(list/instance_map)
	. = ..()
	DESERIALIZE_DECL_TO_TYPE(handle_material)
	DESERIALIZE_DECL_TO_TYPE(binding_material)
