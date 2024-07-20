/obj/item/tool/hydraulic_cutter
	name                      = "hydraulic cutter"
	desc                      = "A universal, miniturized hydraulic tool with interchangable heads for either prying or cutting. But not both at the same time."
	icon                      = 'icons/obj/items/tool/cutter.dmi'
	icon_state                = ICON_STATE_WORLD
	slot_flags                = SLOT_LOWER_BODY
	w_class                   = ITEM_SIZE_SMALL
	origin_tech               = @'{"materials":3,"engineering":3}'
	material                  = /decl/material/solid/metal/steel
	center_of_mass            = @'{"x":17,"y":16}'
	attack_verb               = list("bashed", "battered", "bludgeoned", "whacked")
	drop_sound                = 'sound/foley/bardrop1.ogg'

/obj/item/tool/hydraulic_cutter/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(IS_CROWBAR(src))
		add_overlay("[icon_state]-pry")
	else if(IS_WIRECUTTER(src))
		add_overlay("[icon_state]-cut")

/obj/item/tool/hydraulic_cutter/Initialize()
	. = ..()
	var/datum/extension/tool/variable/tool = get_extension(src, /datum/extension/tool)
	tool?.set_sound_overrides('sound/items/jaws_pry.ogg', 'sound/items/change_jaws.ogg')

/obj/item/tool/hydraulic_cutter/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_CROWBAR     = TOOL_QUALITY_GOOD,
		TOOL_WIRECUTTERS = TOOL_QUALITY_GOOD
	)
	return tool_qualities

/obj/item/tool/power_drill
	name                      = "power drill"
	desc                      = "A universal power drill, with heads for most common screw and bolt types."
	icon                      = 'icons/obj/items/tool/powerdrill.dmi'
	icon_state                = ICON_STATE_WORLD
	slot_flags                = SLOT_LOWER_BODY
	w_class                   = ITEM_SIZE_SMALL
	origin_tech               = @'{"materials":3,"engineering":3}'
	material                  = /decl/material/solid/metal/steel
	center_of_mass            = @'{"x":17,"y":16}'
	attack_verb               = list("bashed", "battered", "bludgeoned", "whacked")
	drop_sound                = 'sound/foley/bardrop1.ogg'

/obj/item/tool/power_drill/Initialize()
	. = ..()
	var/datum/extension/tool/tool = get_extension(src, /datum/extension/tool)
	tool?.set_sound_overrides('sound/items/airwrench.ogg', 'sound/items/change_drill.ogg')

/obj/item/tool/power_drill/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_WRENCH      = TOOL_QUALITY_GOOD,
		TOOL_SCREWDRIVER = TOOL_QUALITY_GOOD
	)
	return tool_qualities

/obj/item/tool/power_drill/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(IS_SCREWDRIVER(src))
		add_overlay("[icon_state]-screw")
	else if(IS_WRENCH(src))
		add_overlay("[icon_state]-bolt")
