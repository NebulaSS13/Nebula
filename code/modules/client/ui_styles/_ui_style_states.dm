var/global/list/_ui_all_keys = list(
	(HUD_DROP),
	(HUD_RESIST),
	(HUD_ZONE_SELECT),
	(HUD_MOVEMENT),
	(HUD_INVENTORY),
	(HUD_ATTACK),
	(HUD_HANDS),
	(HUD_INTERNALS),
	(HUD_HEALTH),
	(HUD_NUTRITION),
	(HUD_HYDRATION),
	(HUD_FIRE_INTENT),
	(HUD_UP_HINT),
	(HUD_PRESSURE),
	(HUD_BODYTEMP),
	(HUD_TOX),
	(HUD_OXY),
	(HUD_FIRE),
	(HUD_CHARGE),
	(HUD_THROW),
	(HUD_MANEUVER),
	(HUD_INTENT),
	(HUD_MODIFIERS)
)

var/global/list/_ui_expected_states
/decl/ui_style/proc/get_expected_states()
	if(!global._ui_expected_states)
		global._ui_expected_states = collect_expected_states()
	return global._ui_expected_states

/decl/ui_style/proc/collect_expected_states()

	// Set hardcoded strings.
	global._ui_expected_states = list(
		(HUD_INTENT) = list(
			"blank",
			"intent_harm",
			"intent_grab",
			"intent_help",
			"intent_disarm",
			"intent_harm_off",
			"intent_grab_off",
			"intent_help_off",
			"intent_disarm_off"
		),
		(HUD_ATTACK) = list(
			"attack_none"
		),
		(HUD_FIRE_INTENT) = list(
			"no_walk0",
			"no_walk1",
			"no_run0",
			"no_run1",
			"no_item0",
			"no_item1",
			"no_radio0",
			"no_radio1",
			"gun0",
			"gun1"
		),
		(HUD_HANDS) = list(
			"hand_base",
			"hand_selected",
			"act_equip",
			"hand1",
			"hand2",
			"hand_blank"
		),
		(HUD_HEALTH) = list(
			"health0",
			"health1",
			"health2",
			"health3",
			"health4",
			"health5",
			"health6",
			"health7",
			"health_numb"
		),
		(HUD_CRIT_MARKER) = list(
			"softcrit",
			"hardcrit",
			"fullhealth",
			"burning"
		),
		(HUD_HYDRATION) = list(
			"hydration0",
			"hydration1",
			"hydration2",
			"hydration3",
			"hydration4"
		),
		(HUD_RESIST) = list(
			"act_resist"
		),
		(HUD_THROW) = list(
			"act_throw_off",
			"act_throw_on",
		),
		(HUD_DROP) = list(
			"act_drop"
		),
		(HUD_MANEUVER) = list(
			"maneuver_off",
			"maneuver_on"
		),
		(HUD_INTERNALS) = list(
			"internal0",
			"internal1"
		),
		(HUD_INVENTORY) = list(
			"other"
		),
		(HUD_MOVEMENT) = list(
			"creeping",
			"walking",
			"running"
		),
		(HUD_NUTRITION) = list(
			"nutrition0",
			"nutrition1",
			"nutrition2",
			"nutrition3",
			"nutrition4"
		),
		(HUD_FIRE) = list(
			"fire0",
			"fire1",
			"fire2"
		),
		(HUD_OXY) = list(
			"oxy0",
			"oxy1",
			"oxy2"
		),
		(HUD_TOX) = list(
			"tox0",
			"tox1"
		),
		(HUD_BODYTEMP) = list(
			"temp-4",
			"temp-3",
			"temp-2",
			"temp-1",
			"temp0",
			"temp1",
			"temp2",
			"temp3",
			"temp4"
		),
		(HUD_PRESSURE) = list(
			"pressure-2",
			"pressure-1",
			"pressure0",
			"pressure1",
			"pressure2"
		),
		(HUD_UP_HINT) = list(
			"uphint0",
			"uphint1"
		),
		(HUD_ZONE_SELECT) = list(
			"zone_sel_tail"
		),
		(HUD_CHARGE) = list(
			"charge0",
			"charge1",
			"charge2",
			"charge3",
			"charge4",
			"charge-empty",
			"blank"
		),
		(HUD_THROW) = list(
			"act_throw_on",
			"act_throw_off"
		),
		(HUD_MODIFIERS) = list(
			"blank",
			"modifier_base"
		)
	)

	// Collect attack selector icon states.
	var/list/all_attacks = decls_repository.get_decls_of_subtype(/decl/natural_attack)
	for(var/attack_type in all_attacks)
		var/decl/natural_attack/attack = all_attacks[attack_type]
		if(attack.selector_icon_state)
			global._ui_expected_states[HUD_ATTACK] |= attack.selector_icon_state

	// Collect hand slot sates.
	for(var/slot in global.all_hand_slots)
		global._ui_expected_states[HUD_HANDS] |= "hand_[slot]"

	for(var/gripper_type in subtypesof(/datum/inventory_slot/gripper))
		var/datum/inventory_slot/gripper/gripper = gripper_type
		if(TYPE_IS_ABSTRACT(gripper))
			continue
		var/ui_label = initial(gripper.ui_label)
		if(ui_label)
			global._ui_expected_states[HUD_HANDS] |= "hand_[ui_label]"

	// Collect movement intent states.
	var/list/all_movement = decls_repository.get_decls_of_subtype(/decl/move_intent)
	for(var/movement_type in all_movement)
		var/decl/move_intent/movement = all_movement[movement_type]
		if(movement.hud_icon_state)
			global._ui_expected_states[HUD_MOVEMENT] |= movement.hud_icon_state

	// Collect inventory slot states.
	for(var/inventory_slot_type in subtypesof(/datum/inventory_slot))
		var/datum/inventory_slot/slot = inventory_slot_type
		if(TYPE_IS_ABSTRACT(slot))
			continue
		var/slot_string = initial(slot.slot_state)
		if(slot_string)
			global._ui_expected_states[HUD_INVENTORY] |= slot_string

	return global._ui_expected_states
