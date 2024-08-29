/mob/living
	var/butchery_data = /decl/butchery_data/animal

/obj/structure
	var/can_support_butchery = FALSE

/mob/living/proc/try_butcher_in_place(mob/user, obj/item/tool)

	if(!IS_KNIFE(tool) || !butchery_data || stat != DEAD)
		return FALSE

	if(!tool.user_can_attack_with(user))
		return TRUE // skip other interactions

	var/decl/butchery_data/butchery_decl = GET_DECL(butchery_data)
	if(!istype(butchery_decl))
		return FALSE

	if(butchery_decl.must_use_hook)
		to_chat(user, SPAN_WARNING("\The [src] is too large to butcher effectively without a meat hook."))
		return TRUE

	if(butchery_decl.needs_surface)
		var/found_surface = FALSE
		for(var/obj/structure/surface in get_turf(src))
			if(surface.can_support_butchery)
				found_surface = TRUE
				break
		if(!found_surface)
			to_chat(user, SPAN_WARNING("You need to place \the [src] on a table or other suitable surface before you can butcher it."))
			return TRUE

	var/butchered = tool.do_tool_interaction(TOOL_KNIFE, user, src, 5 SECONDS, start_message = "butchering", success_message = "butchering", check_skill = SKILL_COOKING)
	if(butchered && !QDELETED(src) && user.Adjacent(src) && butchery_decl.type == butchery_data)
		butchery_decl.get_all_products(src)
		dump_contents()
		qdel(src)

	return TRUE
