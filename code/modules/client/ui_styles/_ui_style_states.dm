var/global/list/_ui_all_keys = list(
	UI_ICON_INTERACTION,
	UI_ICON_ZONE_SELECT,
	UI_ICON_MOVEMENT,
	UI_ICON_INVENTORY,
	UI_ICON_ATTACK,
	UI_ICON_HANDS,
	UI_ICON_INTERNALS,
	UI_ICON_HEALTH,
	UI_ICON_NUTRITION,
	UI_ICON_HYDRATION,
	UI_ICON_FIRE_INTENT,
	UI_ICON_INTENT,
	UI_ICON_UP_HINT,
	UI_ICON_STATUS,
	UI_ICON_STATUS_FIRE,
	UI_ICON_CHARGE
)

var/global/list/_ui_expected_states
/decl/ui_style/proc/get_expected_states()
	if(!global._ui_expected_states)
		global._ui_expected_states = collect_expected_states()
	return global._ui_expected_states

/decl/ui_style/proc/collect_expected_states()

	// Set hardcoded strings.
	global._ui_expected_states = list(
		UI_ICON_ATTACK = list(
			"attack_none"
		),
		UI_ICON_FIRE_INTENT = list(
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
		UI_ICON_HANDS = list(
			"hand_base",
			"hand_selected",
			"act_equip",
			"hand1",
			"hand2"
		),
		UI_ICON_HEALTH = list(
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
		UI_ICON_CRIT_MARKER = list(
			"softcrit",
			"hardcrit",
			"fullhealth",
			"burning"
		),
		UI_ICON_HYDRATION = list(
			"hydration0",
			"hydration1",
			"hydration2",
			"hydration3",
			"hydration4"
		),
		UI_ICON_INTENT = list(
			"intent_all",
			"intent_help",
			"intent_disarm",
			"intent_grab",
			"intent_harm",
			"intent_none"
		),
		UI_ICON_INTERACTION = list(
			"act_resist",
			"act_throw_off",
			"act_throw_on",
			"act_drop",
			"maneuver_off",
			"maneuver_on"
		),
		UI_ICON_INTERNALS = list(
			"internal0",
			"internal1"
		),
		UI_ICON_INVENTORY = list(
			"other"
		),
		UI_ICON_MOVEMENT = list(),
		UI_ICON_NUTRITION = list(
			"nutrition0",
			"nutrition1",
			"nutrition2",
			"nutrition3",
			"nutrition4"
		),
		UI_ICON_STATUS_FIRE = list(
			"fire0",
			"fire1",
			"fire2"
		),
		UI_ICON_STATUS = list(
			"temp-4",
			"temp-3",
			"temp-2",
			"temp-1",
			"temp0",
			"temp1",
			"temp2",
			"temp3",
			"temp4",
			"tox0",
			"tox1",
			"oxy0",
			"oxy1",
			"oxy2",
			"pressure-2",
			"pressure-1",
			"pressure0",
			"pressure1",
			"pressure2"
		),
		UI_ICON_UP_HINT = list(
			"uphint0",
			"uphint1"
		),
		UI_ICON_ZONE_SELECT = list(
			"zone_sel_tail"
		),
		UI_ICON_CHARGE = list(
			"charge0",
			"charge1",
			"charge2",
			"charge3",
			"charge4",
			"charge-empty"
		)
	)

	// Collect attack selector icon states.
	var/list/all_attacks = decls_repository.get_decls_of_subtype(/decl/natural_attack)
	for(var/attack_type in all_attacks)
		var/decl/natural_attack/attack = all_attacks[attack_type]
		if(attack.selector_icon_state)
			global._ui_expected_states[UI_ICON_ATTACK] |= attack.selector_icon_state

	// Collect hand slot sates.
	for(var/slot in global.all_hand_slots)
		global._ui_expected_states[UI_ICON_HANDS] |= "hand_[slot]"
	for(var/gripper_type in subtypesof(/datum/inventory_slot/gripper))
		var/datum/inventory_slot/gripper/gripper = gripper_type
		if(TYPE_IS_ABSTRACT(gripper))
			continue
		var/ui_label = initial(gripper.ui_label)
		if(ui_label)
			global._ui_expected_states[UI_ICON_HANDS] |= "hand_[ui_label]"

	// Collect movement intent states.
	var/list/all_movement = decls_repository.get_decls_of_subtype(/decl/move_intent)
	for(var/movement_type in all_movement)
		var/decl/move_intent/movement = all_movement[movement_type]
		if(movement.hud_icon_state)
			global._ui_expected_states[UI_ICON_MOVEMENT] |= movement.hud_icon_state

	// Collect inventory slot states.
	for(var/inventory_slot_type in subtypesof(/datum/inventory_slot))
		var/datum/inventory_slot/slot = inventory_slot_type
		if(TYPE_IS_ABSTRACT(slot))
			continue
		var/slot_string = initial(slot.slot_state)
		if(slot_string)
			global._ui_expected_states[UI_ICON_INVENTORY] |= slot_string

	return global._ui_expected_states
