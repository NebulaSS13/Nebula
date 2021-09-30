/// Current health for health processing. Use `get_current_health()`, `damage_health()`, or `restore_health()` for general health references.
/atom/var/health_current

/// Maximum health for simple health processing. Use `get_max_health()` or `set_max_health()` to reference/modify.
/atom/var/health_max

/**
 * LAZY List of damage type resistance or weakness multipliers, decimal form. Only applied to health reduction. Use `set_damage_resistance()`, `remove_damage_resistance()`, and `get_damage_resistance()` to reference/modify.
 *
 * Index should be one of the `DAMAGE_` flags.
 * Value should be a multiplier that is applied against damage. Values below 1 are a resistance, above 1 are a weakness.
 * Value of `0` is considered immunity.
 */
/atom/var/list/health_resistances

/// Minimum damage required to actually affect health in `can_damage_health()`.
/atom/var/health_min_damage = 0

/**
 * Retrieves the atom's current health, or `null` if not using health
 */
/atom/proc/get_current_health()
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	return health_current

/**
 * Retrieves the atom's maximum health.
 */
/atom/proc/get_max_health()
	SHOULD_CALL_PARENT(TRUE)
	return health_max

/**
 * Retrieves the atom's current damage, or `null` if not using health.
 * If `use_raw_values` is `TRUE`, uses the raw var values instead of the `get_*` proc results.
 */
/atom/proc/get_damage_value(use_raw_values)
	if (!health_max)
		return
	if (use_raw_values)
		return health_max - health_current
	else
		return get_max_health() - get_current_health()

/**
 * Retrieves the atom's current damage as a percentage where `100%` is `1.00`.
 * If `use_raw_values` is `TRUE`, uses the raw var values instead of the `get_*` proc results.
 */
/atom/proc/get_damage_percentage(use_raw_values)
	if (!health_max)
		return
	var/max_health = use_raw_values ? health_max : get_max_health()
	return round(get_damage_value(use_raw_values) / max_health, 0.01)

/**
 * Checks if the atom's health can be restored.
 * Called by `restore_health()`. Use `mod_health()` directly to skip this check.
 * Returns `null` if health is not in use.
 * NOTE: Does not include an `is_alive()` check to allow repairing/healing atoms back to life.
 */
/atom/proc/can_restore_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	if (!damage)
		return FALSE
	if (get_current_health() == get_max_health())
		return FALSE
	return TRUE

/**
 * Checks if the atom's health can be damaged.
 * Called by `damage_health()`. Use `mod_health()` directly to skip this check.
 * Returns `null` if health is not in use.
 */
/atom/proc/can_damage_health(damage, damage_type = null)
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	if (!is_alive())
		return FALSE
	if (!damage || damage < health_min_damage)
		return FALSE
	if (get_damage_resistance(damage_type) == 0)
		return FALSE
	return TRUE

/**
 * Checks if the atom is 'alive' or 'dead'.
 * Returns `null` if health is not in use.
 */
/atom/proc/is_alive()
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	return get_current_health() > 0

/**
 * Health modification for the health system. Applies `health_mod` directly to `simple_health` via addition and calls `handle_death_change` as needed.
 * Has no pre-modification checks, you should be using `damage_health()` or `restore_health()` instead of this unless you explicitly need to bypass those checks.
 * `skip_death_state_change` will skip calling `handle_death_change()` when applicable. Used for when the originally calling proc needs handle it in a unique way.
 * Returns `TRUE` if the death state changes, `null` if the atom is not using health, `FALSE` otherwise.
 */
/atom/proc/mod_health(health_mod, damage_type = null, skip_death_state_change = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if (!health_max)
		return
	var/death_state = is_alive()
	health_current = Clamp(health_current + health_mod, 0, get_max_health())
	post_health_change(health_mod, damage_type)
	var/new_death_state = is_alive()
	if (death_state == new_death_state)
		return FALSE
	if (!skip_death_state_change)
		handle_death_change(new_death_state)
	return TRUE

/**
 * Sets `health_current` to the new value, clamped between `0` and `health_max`.
 * Has no pre-modification checks.
 * Returns `TRUE` if the death state changes, `null` if the atom is not using health, `FALSE` otherwise.
 */
/atom/proc/set_health(new_health)
	SHOULD_CALL_PARENT(TRUE)
	var/health_mod = new_health - health_current
	return mod_health(health_mod)

/**
 * Restore's the atom's health by the given value. Returns `TRUE` if the restoration resulted in a death state change.
 */
/atom/proc/restore_health(damage, damage_type = null, skip_death_state_change = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if (!can_restore_health(damage, damage_type))
		return FALSE
	return mod_health(damage, damage_type = null)

/**
 * Damage's the atom's health by the given value. Returns `TRUE` if the damage resulted in a death state change.
 * Resistance and weakness modifiers are applied here.
 */
/atom/proc/damage_health(damage, damage_type = null, skip_death_state_change = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if (!can_damage_health(damage, damage_type))
		return FALSE

	// Apply resistance/weakness modifiers
	damage *= get_damage_resistance(damage_type)

	return mod_health(-damage, damage_type, skip_death_state_change)

/**
 * Proc called after any health changes made by the system. This is called before death state changes occur.
 */
/atom/proc/post_health_change(health_mod, damage_type = null)
	return

/**
 * Ease of use proc to immediately kill the atom.
 */
/atom/proc/kill_health()
	SHOULD_CALL_PARENT(TRUE)
	return mod_health(-1 * health_max)

/**
 * Ease of use proc to fully heal the atom.
 */
/atom/proc/revive_health()
	SHOULD_CALL_PARENT(TRUE)
	return mod_health(health_max)

/**
 * Proc called when the death state changes changes.
 * Provided for override use.
 */
/atom/proc/handle_death_change(new_death_state)
	return

/**
 * Sets the atoms maximum health to the new value.
 * If `set_current_health` is `TRUE`, also sets the current health to the new value.
 */
/atom/proc/set_max_health(new_max_health, set_current_health = TRUE)
	SHOULD_CALL_PARENT(TRUE)
	health_max = new_max_health
	health_current = set_current_health ? get_max_health() : min(health_current, get_max_health())

/**
 * Sets the atom's resistance/weakness to the given damage type.
 * Value should be a multiplier that is applied against damage. Values below 1 are a resistance, above 1 are a weakness.
 * Value of `0` is considered immunity.
 */
/atom/proc/set_damage_resistance(damage_type, resistance_value)
	SHOULD_CALL_PARENT(TRUE)
	if (resistance_value == 1)
		remove_damage_resistance(damage_type)
		return
	LAZYSET(health_resistances, damage_type, resistance_value)

/**
 * Removes the atom's resistance/weakness to the given damage type.
 */
/atom/proc/remove_damage_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	LAZYREMOVE(health_resistances, damage_type)

/**
 * Fetches the atom's current resistance value for the given damage type.
 */
/atom/proc/get_damage_resistance(damage_type)
	SHOULD_CALL_PARENT(TRUE)
	if (!damage_type)
		return 1
	var/resistance_value = LAZYACCESS(health_resistances, damage_type)
	return isnull(resistance_value) ? 1 : resistance_value

/**
 * Handles sending damage state to users on `examine()`.
 * Overrideable to allow for different messages, or restricting when the messages can or cannot appear.
 */
/atom/proc/examine_damage_state(mob/user)
	var/decl/pronouns/G = get_pronouns()
	var/message = "[G.He] appear[G.s] "
	if (!is_alive())
		to_chat(user, SPAN_DANGER("[message]broken."))
		return

	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if (0.00)
			to_chat(user, SPAN_NOTICE("[message]fully intact."))
		if (0.01 to 0.32)
			to_chat(user, SPAN_WARNING("[message]slightly damaged."))
		if (0.33 to 0.65)
			to_chat(user, SPAN_WARNING("[message]moderately damaged."))
		else
			to_chat(user, SPAN_DANGER("[message]severely damaged."))

/mob/examine_damage_state(mob/user)
	var/decl/pronouns/G = get_pronouns()
	var/message = "[G.He] appear[G.s] "
	if (!is_alive())
		to_chat(user, SPAN_DANGER("[message]severely hurt and [G.is] not moving or responding to anything around [G.him]."))
		return

	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if (0.00)
			to_chat(user, SPAN_NOTICE("[message]unhurt."))
		if (0.01 to 0.32)
			to_chat(user, SPAN_WARNING("[message]slightly hurt."))
		if (0.33 to 0.65)
			to_chat(user, SPAN_WARNING("[message]moderately hurt."))
		else
			to_chat(user, SPAN_DANGER("[message]severely hurt."))
