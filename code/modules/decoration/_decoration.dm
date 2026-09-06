// Should return a linear list of /decl/item_decoration types that can apply to the target items.
/proc/get_decoration_types_for(mob/user, obj/item/target_item, obj/item/used_item)
	// TODO: consider caching this somewhere?
	for(var/decl/item_decoration/decoration as anything in decls_repository.get_decls_of_subtype_unassociated(/decl/item_decoration))
		if(decoration in target_item.decorations)
			continue
		if(!decoration.can_apply_to(user, target_item, used_item))
			continue
		LAZYADD(., decoration)

// Decl types for decorations below.
/decl/item_decoration
	abstract_type = /decl/item_decoration
	/// A descriptive named used to select this decoration.
	var/name
	/// State used when searching item icon files for world/inventory/onmob states to draw.
	var/icon_state_modifier
	/// A list of types that this decoration can be applied to. Must contain at least one entry.
	var/list/can_decorate_types
	/// A list of types that can be used to apply this decoration. Must contain at least one entry.
	var/list/can_decorate_with_types
	/// String used to describe this action.
	var/decoration_verb   = "decorate"
	/// String used to describe this action while underway.
	var/decoration_action = "decorating"
	/// What skill to use when applying this decoration. If null, defaults to the material.
	var/work_skill
	/// How long this work should take.
	var/work_time = 10 SECONDS
	/// Factor value supplied to do_skilled()
	var/work_factor = 1
	/// Additional monetary worth for the item, as a percentage of the base item value (ie. 0.1 = +10%)
	var/decoration_worth_factor = 0.1

/decl/item_decoration/validate()
	. = ..()
	if(!istext(name))
		. += "null or invalid name"
	if(!istext(icon_state_modifier))
		. += "null or invalid icon_state_modifier"
	if(!length(can_decorate_types))
		. += "no types in can_decorate_types"
	if(!length(can_decorate_with_types))
		. += "no types in can_decorate_with_types"

/decl/item_decoration/proc/can_apply_to(mob/user, obj/item/thing, obj/item/decorating_with)
	if(!istype(thing) || !is_type_in_list(thing, can_decorate_types))
		return FALSE
	if(!istype(decorating_with) || !is_type_in_list(decorating_with, can_decorate_with_types))
		return FALSE
	return TRUE

/decl/item_decoration/proc/show_work_start_message(mob/user, obj/item/thing, obj/item/decorating_with)
	user.visible_message(SPAN_NOTICE("\The [user] begins [decoration_action] \the [thing] with \the [decorating_with]."))

/decl/item_decoration/proc/show_work_end_message(mob/user, obj/item/thing, obj/item/decorating_with)
	user.visible_message(SPAN_NOTICE("\The [user] finishes [decoration_action] \the [thing] with \the [decorating_with]."))

/decl/item_decoration/proc/apply_to_item(mob/user, obj/item/thing, obj/item/decorating_with)
	var/stack_use = 0
	if(istype(decorating_with, /obj/item/stack))
		var/obj/item/stack/stack = decorating_with
		for(var/stack_type in can_decorate_with_types)
			if(istype(stack, stack_type))
				stack_use = can_decorate_with_types[stack_type]
				break
		if(stack.get_amount() < stack_use)
			to_chat(user, SPAN_WARNING("You need at least [stack_use] [stack_use == 1 ? stack.singular_name : stack.plural_name] to [decoration_verb] \the [thing]."))
			return FALSE
	show_work_start_message(user, thing, decorating_with)
	if(work_time && work_skill)
		if(!user.do_skilled(work_time, work_skill, thing, work_factor))
			return FALSE
		if(!QDELETED(user) || QDELETED(thing) || QDELETED(decorating_with) || user.get_active_held_item() != decorating_with)
			return FALSE
	if(stack_use && istype(decorating_with, /obj/item/stack))
		var/obj/item/stack/stack = decorating_with
		if(!stack.use(stack_use))
			return FALSE
	else if(!user.try_unequip(decorating_with, thing, FALSE))
		return FALSE
	show_work_end_message(user, thing, decorating_with)
	return TRUE

// This will need work down the track. Value will be added by the decorations
// in matter[] but the value of the labour isn't reflected. Needs thought.
/decl/item_decoration/proc/get_decoration_value(obj/item/thing, base_value)
	return max(1, round(base_value * decoration_worth_factor))

/decl/item_decoration/proc/attempt_removal(mob/user, obj/item/target_item, obj/item/used_item)
	return FALSE

/decl/item_decoration/proc/resolve_color(obj/item/thing)
	var/list/decoration_data = LAZYACCESS(thing.decorations, src)
	if(islist(decoration_data) && length(decoration_data))
		var/obj/item/decoration_object = decoration_data["object"]
		if(istype(decoration_object) && decoration_object.paint_color)
			return decoration_object.paint_color
		var/decl/material/decoration_material = decoration_data["material"]
		if(istype(decoration_material))
			return decoration_material.color
		if(istype(decoration_object))
			return decoration_object.color
	return COLOR_WHITE
