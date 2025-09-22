/obj/structure/attackby(obj/item/used_item, mob/user)
	if((. = ..()))
		return
	var/datum/extension/insect_hive/hive = get_extension(src, /datum/extension/insect_hive)
	if(istype(hive) && hive.handle_item_interaction(user, used_item))
		return TRUE

/obj/structure/attack_hand(mob/user)
	if(has_extension(src, /datum/extension/insect_hive))
		var/datum/extension/insect_hive/hive = get_extension(src, /datum/extension/insect_hive)
		if(hive.try_hand_harvest(user, src))
			return TRUE
	return ..()

/obj/structure/attackby(obj/item/used_item, mob/user)
	if(has_extension(src, /datum/extension/insect_hive))
		var/datum/extension/insect_hive/hive = get_extension(src, /datum/extension/insect_hive)
		if(hive.try_tool_harvest(user, used_item))
			return TRUE
	return ..()

/obj/structure/examined_by(mob/user, distance, infix, suffix)
	. = ..()
	var/datum/extension/insect_hive/hive = get_extension(src, /datum/extension/insect_hive)
	if(istype(hive))
		hive.examined(user, (distance <= 1))

/atom/physically_destroyed(var/skip_qdel)
	var/datum/extension/insect_hive/hive = get_extension(src, /datum/extension/insect_hive)
	hive?.drop_nest(loc)
	return ..()

/obj/structure/dismantle_structure(mob/user)
	var/datum/extension/insect_hive/hive = get_extension(src, /datum/extension/insect_hive)
	hive?.drop_nest(loc)
	return ..()

// 'proper' nest structure for building and mapping
/obj/structure/apiary
	name                   = "apiary"
	desc                   = "An artificial hive for raising insects, like bees, and harvesting products like honey."
	icon                   = 'mods/content/beekeeping/icons/apiary.dmi'
	icon_state             = ICON_STATE_WORLD
	density                = TRUE
	anchored               = TRUE
	storage                = /datum/storage/apiary
	material_alteration    = MAT_FLAG_ALTERATION_ALL
	material               = /decl/material/solid/organic/wood/oak
	color                  = /decl/material/solid/organic/wood/oak::color
	obj_flags              = OBJ_FLAG_ANCHORABLE
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)

/obj/structure/apiary/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return air_group || height == 0 || !density || (istype(mover) && mover.checkpass(PASS_FLAG_TABLE))

/obj/structure/apiary/attackby(obj/item/used_item, mob/user)

	if(istype(used_item, /obj/item/bee_pack))
		var/datum/extension/insect_hive/hive = get_extension(src, /datum/extension/insect_hive)
		if(istype(hive))
			to_chat(user, SPAN_WARNING("\The [src] already contains \a [hive.holding_species.nest_name]."))
			return TRUE
		var/obj/item/bee_pack/pack = used_item
		if(!pack.contains_insects)
			to_chat(user, SPAN_WARNING("\The [pack] is empty!"))
			return TRUE
		user.visible_message(SPAN_NOTICE("\The [user] transfers the contents of \the [pack] into \the [src]."))
		set_extension(src, /datum/extension/insect_hive, pack.contains_insects)
		pack.empty()
		return TRUE

	. = ..()

/datum/storage/apiary
	can_hold = list(/obj/item/hive_frame)
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = ITEM_SIZE_SMALL * 5 // Five regular frames.

/obj/structure/apiary/mapped/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	for(var/_ = 1 to 5)
		new /obj/item/hive_frame/crafted(src)

/obj/structure/apiary/mapped/bees/Initialize(ml, _mat, _reinf_mat)
	set_extension(src, /datum/extension/insect_hive, /decl/insect_species/honeybees)
	. = ..()
