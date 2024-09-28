/obj/screen/ability
	requires_ui_style = FALSE
	requires_owner    = FALSE
	icon = 'icons/mob/screen/abilities.dmi'
	icon_state = "ability"
	abstract_type = /obj/screen/ability

	var/ability_category_tag
	var/datum/ability_handler/owning_handler

/obj/screen/ability/Destroy()
	remove_from_handler()
	return ..()

/obj/screen/ability/proc/remove_from_handler()
	owning_handler = null

/obj/screen/ability/on_update_icon()
	if(!isnull(ability_category_tag) && owning_handler?.ability_category_tag == ability_category_tag)
		invisibility = owning_handler.showing_abilities ? 0 : INVISIBILITY_ABSTRACT
	else
		invisibility = 0

/obj/screen/ability/handle_click(mob/user, params)
	to_chat(user, "Click!")

/obj/screen/ability/button
	requires_owner = TRUE
	var/decl/ability/ability

/obj/screen/ability/button/remove_from_handler()
	owning_handler?.remove_screen_element(src, ability)
	return ..()

/obj/screen/ability/button/handle_click(mob/user, params)
	ability.use_ability(user, get_turf(user)) // tmp, needs better/multi-step target selection
	update_icon()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), ability.get_cooldown_time(ability.get_metadata_for_user(user)) + 1)

/obj/screen/ability/button/proc/set_ability(decl/ability/_ability)
	if(ability == _ability)
		return
	ability = _ability
	if(istype(ability))
		SetName(ability.name)
	else
		SetName(initial(name))
	update_icon()

/obj/screen/ability/button/on_update_icon()
	. = ..()
	cut_overlays()
	if(istype(ability) && ability.ability_icon && ability.ability_icon_state)
		add_overlay(overlay_image(ability.ability_icon, ability.ability_icon_state, COLOR_WHITE, (RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)))

/obj/screen/ability/category
	name = "toggle ability cateogry"
	icon_state = "category"

/obj/screen/ability/category/remove_from_handler()
	owning_handler?.remove_screen_element(src, "toggle")
	return ..()

/obj/screen/ability/category/Initialize(mapload, mob/_owner, decl/ui_style/ui_style, ui_color, ui_alpha, ui_cat)
	. = ..()
	update_icon()

/obj/screen/ability/category/handle_click(mob/user, params)
	owning_handler?.toggle_category_visibility()

/obj/screen/ability/category/on_update_icon()
	icon_state = owning_handler?.showing_abilities ? initial(icon_state) : "[initial(icon_state)]-off"
