/////////////////////////////////////////////////////////////////////////////////
// Sign Item
/////////////////////////////////////////////////////////////////////////////////

///Item form of the sign structure. Stores a sign structure type, and creates that structure upon install.
/// Takes on the appearence and properties of whatever sign structure type it contains.
/obj/item/sign
	name     = "sign"
	w_class  = ITEM_SIZE_NORMAL
	material = /decl/material/solid/plastic
	///The type of the sign this item will turn into upon installation
	var/sign_type

/obj/item/sign/Initialize(ml, material_key)
	. = ..()
	if(ispath(sign_type))
		set_sign(sign_type)
	update_icon()

/obj/item/sign/afterattack(turf/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(proximity_flag && isturf(target) && target.is_wall())
		try_install(target, user)
		return TRUE

/obj/item/sign/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W) && W.CanUseTopic(user, global.inventory_topic_state) && isturf(user.loc))
		return try_install(W, user)
	return ..()

/obj/item/sign/on_update_icon()
	. = ..()
	//Make us look smaller than the actual sign icon
	transform = transform.Scale(0.8, 0.8)

///Set the sign this sign item will contain from an sign structure instance.
/obj/item/sign/proc/set_sign(var/obj/structure/sign/S)
	sign_type = ispath(S)? S : S.type
	desc      = ispath(S)? initial(S.desc) : S.desc
	icon      = ispath(S)? initial(S.icon) : S.icon
	SetName(ispath(S)? initial(S.name) : S.name)
	var/sign_mat = ispath(S)? initial(S.material) : S.material
	if(sign_mat)
		set_material(sign_mat)

	//Make sure we have the same matter contents as the sign
	matter = atom_info_repository.get_matter_for(sign_type)
	matter = matter.Copy()

	//Do this last, so icon update is last
	set_icon_state(ispath(S)? initial(S.icon_state) : S.icon_state)
	update_held_icon()

///Actually creates and places the sign structure. Override to add to sign init.
/obj/item/sign/proc/place_sign(var/turf/T, var/direction)
	var/obj/structure/sign/S = new sign_type(T)
	S.set_dir(direction)
	copy_extension(src, S, /datum/extension/labels)
	copy_extension(src, S, /datum/extension/forensic_evidence)
	copy_extension(src, S, /datum/extension/scent)
	transfer_fingerprints_to(S)
	sign_type = null
	return S

///Attempts installing the sign and ask the user for direction and etc..
/obj/item/sign/proc/try_install(var/turf/targeted_turf, var/mob/user)
	var/facing      = get_cardinal_dir(user, targeted_turf) || user.dir
	var/install_dir = global.reverse_dir[facing]
	//If we used the screwdriver on the panel, it'll be in the active hand
	var/obj/item/screwdriver/S = user.get_active_hand()
	if(!istype(S))
		//Otherwise it should be in one of the offhand slots
		for(S in user.get_inactive_held_items())
			if(istype(S))
				break
	if(!istype(S))
		to_chat(user, SPAN_WARNING("You must hold a screwdriver in your other hand to install this!"))
	else if(S.do_tool_interaction(TOOL_SCREWDRIVER, user, src, 3 SECONDS, "fastening", "fastening"))
		place_sign(get_turf(user), install_dir)
		qdel(src)
	return FALSE

/////////////////////////////////////////////////////////////////////////////////
// Sign Structure
/////////////////////////////////////////////////////////////////////////////////

///A wall mountable sign structure
/obj/structure/sign
	name               = "sign"
	icon               = 'icons/obj/decals.dmi'
	anchored           = TRUE
	opacity            = FALSE
	density            = FALSE
	layer              = ABOVE_WINDOW_LAYER
	w_class            = ITEM_SIZE_NORMAL
	obj_flags          = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = "{'NORTH':{'y':-32}, 'SOUTH':{'y':32}, 'WEST':{'x':32}, 'EAST':{'x':-32}}"
	abstract_type      = /obj/structure/sign
	parts_type         = /obj/item/sign
	parts_amount       = 1

/obj/structure/sign/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	update_description()

///Proc for signs that must initialize their names or description at runtime.
/obj/structure/sign/proc/update_description()
	return

/obj/structure/sign/handle_default_screwdriver_attackby(mob/user, obj/item/screwdriver)
	if(QDELETED(src))
		return TRUE
	if(screwdriver.do_tool_interaction(TOOL_SCREWDRIVER, user, src, 3 SECONDS, "taking down", "taking down"))
		dismantle()
	return TRUE

/obj/structure/sign/hide()
	return //Signs should no longer hide in walls.

/obj/structure/sign/create_dismantled_products(turf/T)
	SHOULD_CALL_PARENT(FALSE)
	if(parts_type && !ispath(parts_type, /obj/item/stack))
		var/obj/item/sign/S = new parts_type(T, (material && material.type), (reinf_material && reinf_material.type))
		S.set_sign(src)
		//Copy our stuff over
		copy_extension(src, S, /datum/extension/labels)
		copy_extension(src, S, /datum/extension/forensic_evidence)
		copy_extension(src, S, /datum/extension/scent)
		transfer_fingerprints_to(S)
	matter = null
	material = null
	reinf_material = null

/obj/structure/sign/double/handle_default_screwdriver_attackby(mob/user, obj/item/screwdriver)
	return FALSE
