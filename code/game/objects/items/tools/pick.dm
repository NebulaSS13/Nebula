/obj/item/pick
	icon_state    = ICON_STATE_WORLD
	obj_flags     = OBJ_FLAG_CONDUCTIBLE
	slot_flags    = SLOT_LOWER_BODY
	force         = 10
	throwforce    = 4
	w_class       = ITEM_SIZE_HUGE
	material      = /decl/material/solid/metal/steel
	origin_tech   = @'{"materials":1,"engineering":1}'
	attack_verb   = list("hit", "pierced", "sliced", "attacked")
	sharp         = 0
	abstract_type = /obj/item/pick

	var/excavation_verb
	var/excavation_sound
	var/excavation_amount = 200

/obj/item/pick/Initialize()

	var/list/tool_qualities = get_initial_tool_qualities()
	if(length(tool_qualities))
		var/datum/extension/tool/tool_data
		if(length(tool_qualities) == 1)
			tool_data = get_or_create_extension(src, /datum/extension/tool, tool_qualities)
		else
			tool_data = get_or_create_extension(src, /datum/extension/tool/variable, tool_qualities)
		if(tool_data && IS_PICK(src))
			if(excavation_verb)
				tool_data.set_tool_property(TOOL_PICK, TOOL_PROP_VERB, excavation_verb)
			if(excavation_sound)
				tool_data.set_tool_property(TOOL_PICK, TOOL_PROP_SOUND, excavation_sound)
			if(excavation_amount)
				tool_data.set_tool_property(TOOL_PICK, TOOL_PROP_EXCAVATION_DEPTH, excavation_amount)

	. = ..()

/obj/item/pick/proc/get_initial_tool_qualities()
	return list(
		TOOL_PICK   = TOOL_QUALITY_DEFAULT,
		TOOL_SHOVEL = TOOL_QUALITY_MEDIOCRE
	)
