/obj/screen/movable/ability_master
	var/list/spell_objects = list()

/obj/screen/movable/ability_master/proc/get_ability_by_spell(var/spell/s)
	for(var/screen in spell_objects)
		var/obj/screen/ability/spell/S = screen
		if(S.spell == s)
			return S
	return null

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

/obj/screen/movable/ability_master/proc/add_spell(var/spell/spell)
	if(!spell) return

	if(spell.spell_flags & NO_BUTTON) //no button to add if we don't get one
		return

	if(get_ability_by_spell(spell))
		return

	var/obj/screen/ability/spell/A = new()
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
	if(my_mob.client)
		toggle_open(2) //forces the icons to refresh on screen

/mob/Life()
	UNLINT(..())
	if(ability_master)
		ability_master.update_spells(0)

/obj/screen/movable/ability_master/proc/update_spells(var/forced = 0)
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

/obj/screen/movable/ability_master/proc/silence_spells(var/amount)
	for(var/obj/screen/ability/spell/spell in spell_objects)
		spell.spell.silenced = amount
		spell.spell.process()
		spell.update_charge(1)

/obj/screen/movable/ability_master/remove_ability(var/obj/screen/ability/ability)
	. = ..()
	if(ability && istype(ability,/obj/screen/ability/spell))
		spell_objects.Remove(ability)
