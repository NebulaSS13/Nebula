/obj/item/ancient_surgery
	abstract_type = /obj/item/ancient_surgery
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/metal/bronze
	color = /decl/material/solid/metal/bronze::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	matter = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"materials":1,"biotech":1}'
	drop_sound = 'sound/foley/knifedrop3.ogg'

/obj/item/ancient_surgery/proc/get_tool_properties()
	return

/obj/item/ancient_surgery/Initialize()
	. = ..()
	var/tool_properties = get_tool_properties()
	if(length(tool_properties))
		set_extension(src, /datum/extension/tool, tool_properties)

/obj/item/ancient_surgery/retractor
	name = "surgical lever"
	desc = "A surgical tool for widening incisions or adjusting bones."
	icon = 'icons/obj/items/surgery/bone_lever.dmi'

/obj/item/ancient_surgery/retractor/get_tool_properties()
	var/static/list/tool_properties = list(
		TOOL_BONE_GEL = TOOL_QUALITY_MEDIOCRE,
		TOOL_RETRACTOR = TOOL_QUALITY_MEDIOCRE
	)
	return tool_properties

/obj/item/ancient_surgery/cautery
	name = "tile cautery"
	desc = "A surgical tool for boring holes, preventing bleeding or closing incisions."
	icon = 'icons/obj/items/surgery/cautery.dmi'

/obj/item/ancient_surgery/cautery/get_tool_properties()
	var/static/list/tool_properties = list(
		TOOL_SURGICAL_DRILL = TOOL_QUALITY_MEDIOCRE,
		TOOL_CAUTERY = TOOL_QUALITY_MEDIOCRE
	)
	return tool_properties

/obj/item/ancient_surgery/bonesetter
	name = "bone setter"
	desc = "A surgical tool for manipulating and setting bones."
	icon = 'icons/obj/items/surgery/bone_setter.dmi'

/obj/item/ancient_surgery/bonesetter/get_tool_properties()
	var/static/list/tool_properties = list(TOOL_BONE_SETTER = TOOL_QUALITY_MEDIOCRE)
	return tool_properties

/obj/item/ancient_surgery/scalpel
	name = "scalpel"
	desc = "A short, wickedly sharp blade used for making incisions and cutting through flesh."
	icon = 'icons/obj/items/surgery/scalpel.dmi'
	sharp = TRUE
	_base_attack_force = 8

/obj/item/ancient_surgery/scalpel/get_tool_properties()
	var/static/list/tool_properties = list(TOOL_SCALPEL = TOOL_QUALITY_MEDIOCRE)
	return tool_properties

/obj/item/ancient_surgery/forceps
	name = "forceps"
	desc = "A pair of opposed levers used to grip and move objects within an incision."
	icon = 'icons/obj/items/surgery/forceps.dmi'

/obj/item/ancient_surgery/forceps/get_tool_properties()
	var/static/list/tool_properties = list(TOOL_HEMOSTAT = TOOL_QUALITY_MEDIOCRE)
	return tool_properties

/obj/item/ancient_surgery/sutures
	name = "sutures"
	desc = "Fine thread suitable for closing wounds or incisions."
	icon = 'icons/obj/items/surgery/sutures.dmi'
	material = /decl/material/solid/organic/meat/gut

/obj/item/ancient_surgery/sutures/get_tool_properties()
	var/static/list/tool_properties = list(TOOL_SUTURES = TOOL_QUALITY_MEDIOCRE)
	return tool_properties

/obj/item/ancient_surgery/bonesaw
	name = "bonesaw"
	desc = "A heavy saw for cutting through bones."
	icon = 'icons/obj/items/surgery/bonesaw.dmi'

/obj/item/ancient_surgery/bonesaw/get_tool_properties()
	var/static/list/tool_properties = list(TOOL_SAW = TOOL_QUALITY_MEDIOCRE)
	return tool_properties
