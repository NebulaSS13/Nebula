/decl/item_decoration/setting
	name                 = "set a gem"
	icon_state_modifier  = "setting"
	can_decorate_types   = list(
		/obj/item/clothing/gloves/ring,
		/obj/item/pendant/setting
	)
	can_decorate_with_types = list(
		/obj/item/gemstone
	)

/decl/item_decoration/setting/attempt_removal(mob/user, obj/item/target_item, obj/item/used_item)
	if(IS_SCREWDRIVER(used_item))
		var/list/decoration_data = target_item.decorations[src]
		var/obj/item/removing = decoration_data?["object"]
		if(istype(removing))
			user.visible_message(SPAN_DANGER("\The [user] levers \the [removing] out of \the [target_item] with \the [used_item]!"))
			removing.dropInto(user.loc)
			user.put_in_hands(removing)
			LAZYREMOVE(target_item.decorations, src)
			target_item.update_icon()
			target_item.update_name()
			return TRUE
	return FALSE

/decl/item_decoration/setting/show_work_start_message(mob/user, obj/item/thing, obj/item/decorating_with)
	user.visible_message(SPAN_NOTICE("\The [user] begins carefully setting \the [decorating_with] into \the [thing]."))

/decl/item_decoration/setting/show_work_end_message(mob/user, obj/item/thing, obj/item/decorating_with)
	user.visible_message(SPAN_NOTICE("\The [user] finishes setting \the [decorating_with] into \the [thing]."))
