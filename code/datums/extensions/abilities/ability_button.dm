/obj/screen/ability
	requires_ui_style = FALSE
	requires_owner    = FALSE
	icon_state        = "ability"
	icon              = 'icons/mob/screen/abilities.dmi'
	abstract_type     = /obj/screen/ability
	var/datum/ability_handler/owning_handler

/obj/screen/ability/Destroy()
	remove_from_handler()
	return ..()

/obj/screen/ability/proc/remove_from_handler()
	owning_handler = null

/obj/screen/ability/on_update_icon()
	invisibility = (isnull(owning_handler) || owning_handler.showing_abilities) ? 0 : INVISIBILITY_ABSTRACT

/obj/screen/ability/handle_click(mob/user, params)
	to_chat(user, "Click!")

/obj/screen/ability/button
	icon_state        = "button"
	requires_owner    = TRUE
	maptext_y         = -3
	var/decl/ability/ability

/obj/screen/ability/button/Initialize(mapload, mob/_owner, decl/ui_style/ui_style, ui_color, ui_alpha, ui_cat)
	. = ..()
	START_PROCESSING(SSfastprocess, src)
	on_update_icon()

/obj/screen/ability/button/Destroy()
	if(is_processing)
		STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/screen/ability/button/Process()
	// We've been broken or deleted.
	if(QDELETED(src) || !ability || !owning_handler)
		return PROCESS_KILL
	// No reason to run periodic updates.
	if(!ability.ability_cooldown_time && !ability.max_charge)
		return PROCESS_KILL
	// Something is broken.
	var/list/metadata = owning_handler.get_metadata(ability.type, create_if_missing = FALSE)
	if(!metadata)
		return PROCESS_KILL
	maptext = ""
	if(ability.ability_cooldown_time)
		var/next_cast = metadata["next_cast"]
		if(world.time < next_cast)
			maptext = ticks2shortreadable(next_cast - world.time)
			if(ability.max_charge)
				maptext += "<br/>"
	if(ability.max_charge)
		maptext += "x[max(0, metadata["charges"])]"
	if(maptext)
		maptext = STYLE_SMALLFONTS_OUTLINE("<center>[maptext]</center>", 7, COLOR_WHITE, COLOR_BLACK)

/obj/screen/ability/button/remove_from_handler()
	owning_handler?.remove_screen_element(src, ability)
	return ..()

/obj/screen/ability/button/handle_click(mob/user, params)
	if(owning_handler.prepared_ability == ability)
		owning_handler.cancel_prepared_ability()
	else if(ability.use_ability(user, get_turf(user), owning_handler)) // tmp, needs better/multi-step target selection
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
	icon_state = initial(icon_state)
	cut_overlays()
	if(istype(ability))
		if(owning_handler && owning_handler.prepared_ability == ability)
			icon_state = "[icon_state]-active"
		if(ability.ability_icon && ability.ability_icon_state)
			add_overlay(overlay_image(ability.ability_icon, ability.ability_icon_state, COLOR_WHITE, (RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)))

/obj/screen/ability/category
	name = "Toggle Ability Category"
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
