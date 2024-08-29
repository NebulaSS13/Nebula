/obj/item/bladed/folding
	name                      = "folding knife"
	desc                      = "A small folding knife."
	icon                      = 'icons/obj/items/bladed/folding.dmi'
	w_class                   = ITEM_SIZE_SMALL
	sharp                     = FALSE
	pommel_material           = null
	guard_material            = null
	slot_flags                = null
	material                  = /decl/material/solid/metal/bronze
	hilt_material             = /decl/material/solid/organic/wood
	_base_attack_force        = 5

	var/open                  = FALSE
	var/closed_item_size      = ITEM_SIZE_SMALL
	var/open_item_size        = ITEM_SIZE_NORMAL
	var/open_attack_verbs     = list("slashed", "stabbed")
	var/closed_attack_verbs   = list("prodded", "tapped")

/obj/item/bladed/folding/iron
	material = /decl/material/solid/metal/iron

/obj/item/bladed/folding/Initialize()
	. = ..()
	update_attack_force()

/obj/item/bladed/folding/attack_self(mob/user)
	if(user.a_intent != I_HELP)
		set_open(!open, user)
		return TRUE
	var/decl/interaction_handler/folding_knife/interaction = GET_DECL(/decl/interaction_handler/folding_knife)
	if(!interaction.is_possible(src, user))
		return FALSE
	interaction.invoked(src, user)
	return TRUE

/obj/item/bladed/folding/proc/set_open(new_state, mob/user)
	open = new_state
	update_attack_force()
	update_icon()
	if(user)
		if(open)
			user.visible_message(SPAN_NOTICE("\The [user] opens \the [src]."))
			playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
		else
			user.visible_message(SPAN_NOTICE("\The [user] closes \the [src]."))
		add_fingerprint(user)

/obj/item/bladed/folding/update_base_icon_state()
	. = ..()
	if(!open)
		icon_state = "[icon_state]-closed"

/obj/item/bladed/folding/update_attack_force()
	..()
	// TODO: check sharp/edge.
	edge  = open
	sharp = open
	if(open)
		w_class     = open_item_size
		attack_verb = open_attack_verbs
	else
		w_class     = closed_item_size
		attack_verb = closed_attack_verbs

// Only show the inhand sprite when open.
/obj/item/bladed/folding/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_adjustment = FALSE)
	. = open ? ..() : new /image

// TODO: Select hilt, guard, etc. as striking material based on dynamic intents
/obj/item/bladed/folding/get_striking_material(mob/user, atom/target)
	. = open ? ..() : hilt_material

/obj/item/bladed/folding/get_tool_speed(archetype)
	return open ? ..() : 0

/obj/item/bladed/folding/get_tool_quality(archetype)
	if(open && archetype == TOOL_HATCHET)
		// If this were an `/obj/item/tool` subtype, we could get away with just doing this based on
		// `open_item_size` in `get_initial_tool_qualities()`.
		switch(w_class)
			if(0 to ITEM_SIZE_SMALL)
				return TOOL_QUALITY_NONE
			if(ITEM_SIZE_SMALL to ITEM_SIZE_NORMAL) // Since ITEM_SIZE_SMALL was already covered, this is just ITEM_SIZE_NORMAL.
				return TOOL_QUALITY_WORST
			if(ITEM_SIZE_NORMAL to ITEM_SIZE_LARGE)
				return TOOL_QUALITY_BAD
			else
				return TOOL_QUALITY_MEDIOCRE
	return open ? ..() : 0

//Interactions
/obj/item/bladed/folding/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/folding_knife)

/decl/interaction_handler/folding_knife
	name = "Adjust Folding Knife"
	expected_target_type = /obj/item/bladed/folding
	interaction_flags = INTERACTION_NEEDS_INVENTORY | INTERACTION_NEEDS_PHYSICAL_INTERACTION

/decl/interaction_handler/folding_knife/is_possible(atom/target, mob/user)
	. = ..()
	if(.)
		var/datum/extension/tool/tool_extension = get_extension(target, /datum/extension/tool)
		return istype(tool_extension, /datum/extension/tool/variable) && user.check_dexterity(DEXTERITY_COMPLEX_TOOLS)

/decl/interaction_handler/folding_knife/proc/get_radial_choices(atom/target)
	// - toggle open/closed
	// - each tool
	. = list()
	var/obj/item/bladed/folding/folding_knife = target
	// should always be in the inventory so we can assume get_world_inventory_state is inventory if it exists
	var/open_close_state = "[folding_knife.get_world_inventory_state()]"
	if(folding_knife.open)
		open_close_state += "-closed"
	var/image/open_close_image = new /image
	open_close_image.name = folding_knife.open ? "Close blade" : "Open blade"
	open_close_image.underlays = list(
		overlay_image(folding_knife.icon, "[open_close_state]-hilt", folding_knife.hilt_material.color, RESET_COLOR),
		overlay_image(folding_knife.icon, open_close_state, folding_knife.material.color, RESET_COLOR)
	)
	.["Toggle"] = open_close_image
/* 	if(!folding_knife.open) // Can only switch mode with the knife open, because we assume all tool interactions use the blade currently
		return . */
	var/datum/extension/tool/variable/tool = get_extension(target, /datum/extension/tool)
	for(var/tool_mode in tool.tool_values)
		if(tool_mode == tool.current_tool)
			continue
		var/decl/tool_archetype/tool_archetype = GET_DECL(tool_mode)
		// This blank image fuckery is done so that we can actually have a usable return value from show_radial_menu AND have a maptext label.
		var/image/I = new /image
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		var/tool_name = tool_archetype.name
		if(tool_archetype.article)
			tool_name = "\a [tool_name]"
		var/image/underlay = new /image
		underlay.appearance = folding_knife
		// reset a bunch of appearance vars we don't need
		underlay.pixel_x = 0
		underlay.pixel_y = 0
		underlay.layer = FLOAT_LAYER
		underlay.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		I.underlays = list(underlay) // don't fuck with the base object's name or color please
		I.name = "Use as [tool_name]"
		.[tool_mode] = I

/decl/interaction_handler/folding_knife/invoked(atom/target, mob/user)
	var/obj/item/bladed/folding/folding_knife = target
	var/chosen_option = show_radial_menu(user, user, get_radial_choices(folding_knife), radius = 42, use_labels = TRUE)
	if(!chosen_option)
		return
	if(chosen_option == "Toggle")
		folding_knife.set_open(!folding_knife.open, user)
		return
	var/datum/extension/tool/variable/tool = get_extension(folding_knife, /datum/extension/tool)
	if(ispath(chosen_option, /decl/tool_archetype))
		tool.switch_tool(chosen_option, user)
		return
	CRASH("Invalid option '[json_encode(chosen_option)]' selected in [folding_knife]'s [type]")