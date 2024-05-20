/obj/item/stack/material/skin
	name = "skin"
	icon_state = "skin"
	plural_icon_state = "skin-mult"
	max_icon_state = "skin-max"
	singular_name = "length"
	plural_name = "lengths"
	stack_merge_type = /obj/item/stack/material/skin
	crafting_stack_type = /obj/item/stack/material/skin
	var/_cleaned = FALSE
	var/work_skill = SKILL_CONSTRUCTION

/obj/item/stack/material/skin/examine(mob/user, distance)
	. = ..()
	if(user && distance <= 1 && user.skill_check(work_skill, SKILL_BASIC) && material?.tans_to)
		if(_cleaned && drying_wetness)
			to_chat(user, SPAN_NOTICE("\The [src] is ready for tanning on a drying rack or in a drying oven."))
		else if(!_cleaned)
			to_chat(user, SPAN_NOTICE("\The [src] must be scraped clean with a knife or other sharp object before it can be tanned."))
		else if(!drying_wetness)
			to_chat(user, SPAN_NOTICE("\The [src] must be soaked in water before it can be tanned."))

/obj/item/stack/material/skin/proc/set_cleaned()
	if(_cleaned)
		return
	_cleaned = TRUE
	name_modifier = "cleaned"

/obj/item/stack/material/skin/attackby(obj/item/W, mob/user)
	if(IS_KNIFE(W) && !_cleaned)
		var/cleaned_sheets = 0
		while(W.do_tool_interaction(TOOL_KNIFE, user, src, 2 SECONDS, "scraping", "scraping", check_skill = work_skill, set_cooldown = TRUE))

			if(QDELETED(src) || _cleaned || get_amount() <= 0 || QDELETED(user) || (loc != user && !user.Adjacent(src)) || QDELETED(W) || user.get_active_held_item() != W)
				break

			var/sheets = min(5, get_amount())
			var/obj/item/stack/material/skin/product = (get_amount() <= sheets) ? src : split(sheets)
			if(product)
				product.set_cleaned()
				cleaned_sheets += product.get_amount()
				product.add_to_stacks(user, TRUE)

			if(QDELETED(src) || get_amount() <= 0 || QDELETED(user) || _cleaned)
				break

		if(cleaned_sheets > 0)
			to_chat(user, SPAN_NOTICE("You finish scraping, having cleaned [cleaned_sheets] [cleaned_sheets == 1 ? singular_name : plural_name]."))
		return TRUE

	return ..()

/obj/item/stack/material/skin/is_dryable()
	return _cleaned && ..()

/obj/item/stack/material/skin/can_merge_stacks(var/obj/item/stack/other)
	. = ..()
	if(.)
		if(!istype(other, /obj/item/stack/material/skin))
			return FALSE
		var/obj/item/stack/material/skin/skin = other
		return skin._cleaned == _cleaned

/obj/item/stack/material/skin/split(var/tamount, var/force=FALSE)
	var/is_cleaned = _cleaned
	var/obj/item/stack/material/skin/skin = ..()
	if(istype(skin) && is_cleaned)
		skin.set_cleaned()
	return skin

/obj/item/stack/material/skin/pelt
	name = "pelts"
	singular_name = "pelt"
	plural_name = "pelts"
	stack_merge_type = /obj/item/stack/material/skin/pelt

/obj/item/stack/material/skin/feathers
	name = "feathers"
	singular_name = "feather"
	plural_name = "feathers"
	stack_merge_type = /obj/item/stack/material/skin/feathers

/obj/item/stack/material/bone
	name = "bones"
	icon_state = "bone"
	plural_icon_state = "bone-mult"
	max_icon_state = "bone-max"
	singular_name = "length"
	plural_name = "lengths"
	stack_merge_type = /obj/item/stack/material/bone
	crafting_stack_type = /obj/item/stack/material/bone
	craft_verb = "carve"
	craft_verbing = "carving"
