// Anchoring or unanchoring with a hammer or a wrench.
/decl/interaction_handler/structure
	abstract_type = /decl/interaction_handler/structure
	expected_target_type = /obj/structure

/decl/interaction_handler/structure/unanchor
	name = "Toggle Anchoring"
	examine_desc = "anchor or unanchor $TARGET_THEM$"

/decl/interaction_handler/structure/unanchor/is_possible(atom/target, mob/user, obj/item/prop)
	if(!(. = ..()))
		return
	var/obj/structure/struct = target
	if(!(struct.tool_interaction_flags & TOOL_INTERACTION_ANCHOR) || !struct.can_unanchor(user))
		return FALSE
	return istype(prop) && (IS_WRENCH(prop) || IS_HAMMER(prop))

/decl/interaction_handler/structure/unanchor/invoked(atom/target, mob/user, obj/item/prop)
	. = ..()
	var/obj/structure/struct = target
	return struct.tool_toggle_anchors(user, prop)

// Removing wiring with wirecutters or installing it with a cable coil.
/decl/interaction_handler/structure/wiring
	name = "Modify Wiring"
	examine_desc = "strip or install wiring"

/decl/interaction_handler/structure/wiring/is_possible(atom/target, mob/user, obj/item/prop)
	if(!(. = ..()))
		return
	var/obj/structure/struct = target
	if(!(struct.tool_interaction_flags & TOOL_INTERACTION_WIRING))
		return FALSE
	if(struct.wired)
		return IS_WIRECUTTER(prop)
	return IS_COIL(prop)

/decl/interaction_handler/structure/wiring/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/structure/struct = target
	if(struct.wired)
		return struct.strip_wiring(user, prop)
	return struct.install_wiring(user, prop)

// Dismantling a structure.
/decl/interaction_handler/structure/dismantle
	name = "Dismantle Structure"
	examine_desc = "dismantle $TARGET_THEM$"

/decl/interaction_handler/structure/dismantle/is_possible(atom/target, mob/user, obj/item/prop)
	if(!(. = ..()))
		return
	var/obj/structure/struct = target
	if(!(struct.tool_interaction_flags & TOOL_INTERACTION_DECONSTRUCT) || !struct.can_dismantle(user))
		return FALSE
	return IS_WELDER(prop) || IS_CROWBAR(prop) || IS_HAMMER(prop)

/decl/interaction_handler/structure/dismantle/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/structure/struct = target
	if(IS_WELDER(prop))
		return struct.welder_dismantle(user, prop)
	return struct.tool_dismantle(user, prop)

/decl/interaction_handler/put_in_storage
	name = "Put In Storage"

/decl/interaction_handler/put_in_storage/is_possible(atom/target, mob/user, obj/item/prop)
	return ..() && istype(prop) && target.storage

// Boilerplate from /atom/proc/attackby(), replicated here so tool interactions can be bypassed.
/decl/interaction_handler/put_in_storage/invoked(atom/target, mob/user, obj/item/prop)
	if((isrobot(user) && (prop == user.get_active_held_item())) || !target.storage.can_be_inserted(prop, user))
		return FALSE
	prop.add_fingerprint(user)
	return target.storage.handle_item_insertion(user, prop)
