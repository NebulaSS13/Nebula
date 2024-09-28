/datum/ability_handler
	abstract_type = /datum/ability_handler
	var/showing_abilities = FALSE
	var/ability_category_tag
	var/mob/owner
	var/datum/extension/abilities/master
	var/list/ability_items
	var/list/screen_elements
	var/list/known_abilities
	var/list/recharging_abilities
	var/stat_panel_type = "Abilities"
	/// UI element for showing or hiding this ability category. Should be /obj/screen/ability/category or subtype.
	var/category_toggle_type = /obj/screen/ability/category

/datum/ability_handler/New(_master)
	master = _master
	if(!istype(master))
		CRASH("Ability handler received invalid master!")
	owner = master.holder
	if(!istype(owner))
		CRASH("Ability handler received invalid owner!")
	..()
	refresh_login()

/datum/ability_handler/Process()

	if(!length(recharging_abilities))
		return PROCESS_KILL

	for(var/decl/ability/ability as anything in recharging_abilities)
		if(!ability.recharge(owner, get_metadata(ability)))
			LAZYREMOVE(recharging_abilities, ability)

/datum/ability_handler/proc/get_metadata(decl/ability/ability, create_if_missing = TRUE)
	if(istype(ability))
		. = known_abilities[ability.type]
		if(!islist(.) && create_if_missing)
			. = ability.get_default_metadata()
			known_abilities[ability.type] = .
	else if(ispath(ability, /decl/ability))
		. = known_abilities[ability]
		if(!islist(.) && create_if_missing)
			ability = GET_DECL(ability)
			if(!istype(ability))
				return list()
			. = ability.get_default_metadata()
			known_abilities[ability] = .
	else if(create_if_missing)
		PRINT_STACK_TRACE("ability metadata retrieval passed invalid ability type: '[ability]'")
		. = list()

/datum/ability_handler/Destroy()
	recharging_abilities = null
	known_abilities = null
	QDEL_NULL_LIST(ability_items)

	for(var/ability in screen_elements)
		var/obj/element = screen_elements[ability]
		if(istype(element))
			qdel(element)
	screen_elements = null

	if(master)
		LAZYREMOVE(master.ability_handlers, src)
		master.update()
		master = null
	owner = null
	if(is_processing)
		STOP_PROCESSING(SSprocessing, src)
	return ..()

/datum/ability_handler/proc/add_ability(ability_type, list/metadata)
	if(provides_ability(ability_type))
		return FALSE
	var/decl/ability/ability = GET_DECL(ability_type)
	if(!istype(ability))
		return FALSE
	if(!islist(metadata))
		metadata = ability.get_default_metadata()

	if(ability.ui_element_type && !istype(LAZYACCESS(screen_elements, ability), ability.ui_element_type))
		var/existing = screen_elements[ability]
		if(existing)
			remove_screen_element(existing, ability, FALSE)
		var/obj/screen/ability/button/button = new ability.ui_element_type(null, null, null, null, null, null, null)
		button.set_ability(ability)
		add_screen_element(button, ability, TRUE)

	LAZYSET(known_abilities, ability_type, metadata)
	if(ability.max_charge)
		LAZYDISTINCTADD(recharging_abilities, ability_type)
		if(!is_processing)
			START_PROCESSING(SSprocessing, src)
	return TRUE

/datum/ability_handler/proc/remove_ability(ability_type)
	if(!provides_ability(ability_type))
		return FALSE
	LAZYREMOVE(known_abilities, ability_type)
	LAZYREMOVE(recharging_abilities, ability_type)

	var/decl/ability/ability = GET_DECL(ability_type)
	if(ability?.ui_element_type)
		var/obj/screen/existing_button = LAZYACCESS(screen_elements, ability)
		if(istype(existing_button))
			remove_screen_element(existing_button, ability)

	if(!LAZYLEN(recharging_abilities) && is_processing)
		STOP_PROCESSING(SSprocessing, src)
	return TRUE

/datum/ability_handler/proc/provides_ability(ability_type)
	return (ability_type in known_abilities)

/datum/ability_handler/proc/finalize_ability_handler()
	if(category_toggle_type)
		var/obj/screen/ability/category/category_toggle = new category_toggle_type(null, null, null, null, null, null, null)
		add_screen_element(category_toggle, "toggle", TRUE)
		toggle_category_visibility(TRUE)

/datum/ability_handler/proc/refresh_element_positioning(row = 1, col = 1)
	if(!LAZYLEN(screen_elements))
		return 0
	var/button_pos = col
	var/button_row = row
	. = 1
	for(var/ability in screen_elements)
		var/obj/screen/element = screen_elements[ability]
		if(istype(element, /obj/screen/ability/category))
			element.screen_loc = "RIGHT-[col],TOP-[row]"
		else if(!element.invisibility)
			button_pos++
			if((button_pos-col) > 5)
				button_row++
				.++
				button_pos = col+1
			element.screen_loc = "RIGHT-[button_pos],TOP-[button_row]"

/datum/ability_handler/proc/toggle_category_visibility(force_state)
	showing_abilities = isnull(force_state) ? !showing_abilities : force_state
	update_screen_elements()
	if(master)
		master.refresh_element_positioning()

/datum/ability_handler/proc/update_screen_elements()
	for(var/ability in screen_elements)
		var/obj/screen/ability/ability_button = screen_elements[ability]
		ability_button.update_icon()

/datum/ability_handler/proc/copy_abilities_to(mob/living/donor)
	return

/datum/ability_handler/proc/disable_abilities(amount)
	for(var/ability in known_abilities)
		var/list/metadata = get_metadata(ability)
		metadata["disabled"] = max(metadata["disabled"], (world.time + amount))

/datum/ability_handler/proc/enable_abilities(amount)
	for(var/ability in known_abilities)
		var/list/metadata = get_metadata(ability)
		metadata["disabled"] = 0

/datum/ability_handler/proc/add_screen_element(atom/element, decl/ability/ability, update_positions = TRUE)
	if(isnull(ability) || isnum(ability))
		return
	LAZYSET(screen_elements, ability, element)
	owner?.client?.screen |= element
	if(istype(element, /obj/screen/ability))
		var/obj/screen/ability/ability_button = element
		ability_button.owning_handler = src
	if(update_positions && master && length(screen_elements))
		master.refresh_element_positioning()

/datum/ability_handler/proc/remove_screen_element(atom/element, decl/ability/ability, update_positions = TRUE)
	if(isnull(ability) || isnum(ability))
		return
	LAZYREMOVE(screen_elements, ability)
	owner?.client?.screen -= element
	if(istype(element, /obj/screen/ability))
		var/obj/screen/ability/ability_button = element
		if(ability_button.owning_handler == src)
			ability_button.owning_handler = null
	if(update_positions && master && LAZYLEN(screen_elements))
		master.refresh_element_positioning()

/datum/ability_handler/proc/cancel()
	if(LAZYLEN(ability_items))
		for(var/thing in ability_items)
			owner?.drop_from_inventory(thing)
			qdel(thing)
		ability_items = null

/datum/ability_handler/proc/show_stat_string(mob/user)
	if(!stat_panel_type || !statpanel(stat_panel_type))
		return
	for(var/ability_type in known_abilities)
		var/decl/ability/ability = GET_DECL(ability_type)
		var/list/stat_strings = ability.get_stat_strings(get_metadata(ability))
		if(length(stat_strings) >= 2)
			stat(stat_strings[1], stat_strings[2])

/// Individual ability methods/disciplines (psioncs, etc.) so that mobs can have multiple.
/datum/ability_handler/proc/refresh_login()
	SHOULD_CALL_PARENT(TRUE)
	if(LAZYLEN(screen_elements))
		var/list/add_elements = list()
		for(var/ability in screen_elements)
			var/atom/element = screen_elements[ability]
			if(istype(element))
				add_elements |= element
		if(length(add_elements))
			owner?.client?.screen |= add_elements

/datum/ability_handler/proc/can_do_self_invocation(mob/user)
	return FALSE

/datum/ability_handler/proc/do_self_invocation(mob/user)
	return FALSE

/datum/ability_handler/proc/can_do_grabbed_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/do_grabbed_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/can_do_melee_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/do_melee_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/can_do_ranged_invocation(mob/user, atom/target)
	return FALSE

/datum/ability_handler/proc/do_ranged_invocation(mob/user, atom/target)
	return FALSE
