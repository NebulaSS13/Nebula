/obj/screen/ability_master
	name              = "Abilities"
	icon              = 'icons/mob/screen/spells.dmi'
	icon_state        = "grey_spell_ready"
	screen_loc        = ui_ability_master
	requires_ui_style = FALSE
	var/list/obj/screen/ability/ability_objects = list()
	var/list/obj/screen/ability/spell_objects = list()
	var/showing = FALSE // If we're 'open' or not.
	var/const/abilities_per_row = 7
	var/open_state = "master_open"		// What the button looks like when it's 'open', showing the other buttons.
	var/closed_state = "master_closed"	// Button when it's 'closed', hiding everything else.

/obj/screen/ability_master/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, ui_cat)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		update_abilities(0, _owner)

/obj/screen/ability_master/Destroy()
	// Get rid of the ability objects.
	remove_all_abilities()
	ability_objects.Cut()
	// After that, remove ourselves from the mob seeing us, so we can qdel cleanly.
	var/mob/owner = owner_ref?.resolve()
	if(istype(owner) && owner.ability_master == src)
		owner.ability_master = null
	return ..()

/obj/screen/ability_master/handle_mouse_drop(atom/over, mob/user, params)
	if(showing)
		return FALSE
	. = ..()

/obj/screen/ability_master/handle_click(mob/user, params)
	if(length(ability_objects)) // If we're empty for some reason.
		toggle_open()

/obj/screen/ability_master/proc/toggle_open(var/forced_state = 0)
	var/mob/owner = owner_ref?.resolve()
	if(!istype(owner) || QDELETED(owner))
		return
	if(showing && (forced_state != 2)) // We are closing the ability master, hide the abilities.
		if(owner?.client)
			for(var/obj/screen/ability/O in ability_objects)
				owner.client.screen -= O
//			O.handle_icon_updates = 0
		showing = 0
		overlays.len = 0
		overlays.Add(closed_state)
	else if(forced_state != 1) // We're opening it, show the icons.
		open_ability_master()
		update_abilities(1)
		showing = 1
		overlays.len = 0
		overlays.Add(open_state)
	update_icon()

/obj/screen/ability_master/proc/open_ability_master()

	var/client/owner_client
	var/mob/owner = owner_ref?.resolve()
	if(istype(owner) && !QDELETED(owner))
		owner_client = owner.client

	for(var/i = 1 to length(ability_objects))
		var/obj/screen/ability/A = ability_objects[i]
		var/row = round(i/abilities_per_row)
		A.screen_loc = "RIGHT-[(i-(row*abilities_per_row))+2]:16,TOP-[row+1]:16"
		if(owner_client)
			owner_client.screen += A

/obj/screen/ability_master/proc/update_abilities(forced = 0, mob/user)
	update_icon()
	if(user && user.client)
		if(!(src in user.client.screen))
			user.client.screen += src
	var/i = 1
	for(var/obj/screen/ability/ability in ability_objects)
		ability.update_icon(forced)
		ability.maptext = "[i]" // Slot number
		i++

/obj/screen/ability_master/on_update_icon()
	if(ability_objects.len)
		set_invisibility(INVISIBILITY_NONE)
	else
		set_invisibility(INVISIBILITY_ABSTRACT)

/obj/screen/ability_master/proc/add_ability(var/name_given)
	if(!name_given)
		return
	var/obj/screen/ability/new_button = new /obj/screen/ability
	new_button.ability_master = src
	new_button.SetName(name_given)
	new_button.ability_icon_state = name_given
	new_button.update_icon(1)
	ability_objects.Add(new_button)
	var/mob/living/owner = owner_ref?.resolve()
	if(istype(owner) && !QDELETED(owner) && owner.client)
		toggle_open(2) //forces the icons to refresh on screen

/obj/screen/ability_master/proc/remove_ability(var/obj/screen/ability/ability)
	if(!ability)
		return
	ability_objects.Remove(ability)
	if(istype(ability,/obj/screen/ability/spell))
		spell_objects.Remove(ability)
	qdel(ability)


	if(ability_objects.len)
		toggle_open(showing + 1)
	update_icon()
//	else
//		qdel(src)

/obj/screen/ability_master/proc/remove_all_abilities()
	for(var/obj/screen/ability/A in ability_objects)
		remove_ability(A)

/obj/screen/ability_master/proc/get_ability_by_name(name_to_search)
	for(var/obj/screen/ability/A in ability_objects)
		if(A.name == name_to_search)
			return A
	return null

/obj/screen/ability_master/proc/get_ability_by_instance(var/obj/instance/)
	for(var/obj/screen/ability/obj_based/O in ability_objects)
		if(O.object == instance)
			return O
	return null

/obj/screen/ability_master/proc/get_ability_by_spell(var/spell/s)
	for(var/screen in spell_objects)
		var/obj/screen/ability/spell/S = screen
		if(S.spell == s)
			return S
	return null

/obj/screen/ability_master/proc/synch_spells_to_mind(var/datum/mind/M)
	if(!M)
		return
	LAZYINITLIST(M.learned_spells)
	for(var/obj/screen/ability/spell/screen in spell_objects)
		var/spell/S = screen.spell
		M.learned_spells |= S

///////////ACTUAL ABILITIES////////////
//This is what you click to do things//
///////////////////////////////////////
/obj/screen/ability
	icon = 'icons/mob/screen/spells.dmi'
	icon_state = "grey_spell_base"
	maptext_x = 3
	requires_owner = FALSE
	requires_ui_style = FALSE
	var/background_base_state = "grey"
	var/ability_icon_state = null
	var/obj/screen/ability_master/ability_master

/obj/screen/ability/Destroy()
	if(ability_master)
		ability_master.ability_objects -= src
		var/mob/owner = ability_master.owner_ref?.resolve()
		if(istype(owner) && owner.client)
			owner.client.screen -= src
	if(ability_master && !ability_master.ability_objects.len)
		ability_master.update_icon()
//		qdel(ability_master)
	ability_master = null
	return ..()

/obj/screen/ability/on_update_icon()
	overlays.Cut()
	icon_state = "[background_base_state]_spell_base"

	overlays += ability_icon_state

/obj/screen/ability/handle_click(mob/user, params)
	activate()

// Makes the ability be triggered.  The subclasses of this are responsible for carrying it out in whatever way it needs to.
/obj/screen/ability/proc/activate()
	to_world("[src] had activate() called.")
	return

/////////Obj Abilities////////
//Buttons to trigger objects//
//////////////////////////////

/obj/screen/ability/obj_based
	var/obj/object = null

/obj/screen/ability/obj_based/activate()
	if(object)
		object.Click()

// Wizard
/obj/screen/ability/spell
	var/spell/spell
	var/spell_base
	var/last_charge = 0
	var/icon/last_charged_icon

/obj/screen/ability/spell/Destroy()
	if(spell)
		spell.connected_button = null
		spell = null
	return ..()

/obj/screen/ability_master/proc/add_spell(var/spell/spell)
	if(!spell) return

	if(spell.spell_flags & NO_BUTTON) //no button to add if we don't get one
		return

	if(get_ability_by_spell(spell))
		return

	var/obj/screen/ability/spell/A = new(null)
	A.ability_master = src
	A.spell = spell
	A.SetName(spell.name)

	if(!spell.override_base) //if it's not set, we do basic checks
		if(spell.spell_flags & CONSTRUCT_CHECK)
			A.spell_base = "const" //construct spells
		else
			A.spell_base = "wiz" //wizard spells
	else
		A.spell_base = spell.override_base
	A.update_charge(1)
	spell_objects.Add(A)
	ability_objects.Add(A)
	var/mob/owner = owner_ref?.resolve()
	if(istype(owner) && !QDELETED(owner) && owner.client)
		toggle_open(2) //forces the icons to refresh on screen

/obj/screen/ability_master/proc/update_spells(var/forced = 0)
	for(var/obj/screen/ability/spell/spell in spell_objects)
		spell.update_charge(forced)

/obj/screen/ability/spell/proc/update_charge(var/forced_update = 0)
	if(!spell)
		qdel(src)
		return

	if(last_charge == spell.charge_counter && !forced_update)
		return //nothing to see here

	overlays -= spell.hud_state

	if(spell.charge_type == Sp_RECHARGE || spell.charge_type == Sp_CHARGES)
		if(spell.charge_counter < spell.charge_max)
			icon_state = "[spell_base]_spell_base"
			if(spell.charge_counter > 0)
				var/icon/partial_charge = icon(src.icon, "[spell_base]_spell_ready")
				partial_charge.Crop(1, 1, partial_charge.Width(), round(partial_charge.Height() * spell.charge_counter / spell.charge_max))
				overlays += partial_charge
				if(last_charged_icon)
					overlays -= last_charged_icon
				last_charged_icon = partial_charge
			else if(last_charged_icon)
				overlays -= last_charged_icon
				last_charged_icon = null
		else
			icon_state = "[spell_base]_spell_ready"
			if(last_charged_icon)
				overlays -= last_charged_icon
	else
		icon_state = "[spell_base]_spell_ready"

	overlays += spell.hud_state

	last_charge = spell.charge_counter

	overlays -= "silence"
	if(spell.silenced)
		overlays += "silence"

/obj/screen/ability/spell/on_update_icon(var/forced = 0)
	update_charge(forced)
	return

/obj/screen/ability/spell/activate()
	spell.perform(usr)

/obj/screen/ability_master/proc/silence_spells(var/amount)
	for(var/obj/screen/ability/spell/spell in spell_objects)
		spell.spell.silenced = amount
		spell.spell.process()
		spell.update_charge(1)
