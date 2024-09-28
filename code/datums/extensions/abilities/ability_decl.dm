/decl/ability
	abstract_type = /decl/ability
	/// A descriptive identifier string.
	var/name
	/// A descriptive string about the ability.
	var/desc
	/// An associated handler type, used in add_ability().
	var/associated_handler_type

	// Projectile created and used to propagate this ability, if it is a ranged ability.
	/// If set, this ability will create a projectile rather than applying the effect directly.
	var/projectile_type
	/// Sets the projectile step_delay.
	var/projectile_step_delay = 1
	/// Determines the lifetime of the projectile.
	var/projectile_duration   = 1 SECOND
	/// If not set, the ability will have documentation generated for the codex.
	var/hidden_from_codex     = FALSE
	/// If set, this ability will be silenced by null rod and similar mechanics.
	var/is_supernatural       = FALSE

	// Visual/audible state for the on-turf effect of casting the spell on something.
	/// If set, will attempt to draw from this icon on the turf where the ability is used.
	var/overlay_icon
	/// If set, will attempt to draw this icon_state on the turf where the ability is used.
	var/overlay_icon_state
	/// Will delete the overlay after this time.
	var/overlay_lifespan = 1 SECOND
	/// If set, will play a sound when used.
	var/use_sound
	/// Volume for above.
	var/use_sound_volume = 50

	// Visual state for the ability HUD element.
	/// Type of button to use for the UI. Should be /obj/screen/ability/button or subtype.
	var/ui_element_type = /obj/screen/ability/button
	/// Icon to draw on the ability HUD, if any.
	var/ability_icon
	/// Icon state to draw on the ability HUD, if any.
	var/ability_icon_state

	// Various restrictions on how and when the ability is used.
	/// A decl type that handles retrieving and validating targets.
	var/decl/ability_targeting/target_selector = /decl/ability_targeting
	/// If set to a numeric value, the ability cannot be used before the cooldown has expired.
	var/cooldown_time = 5 SECONDS
	/// If set, a do_after() will be applied to this spell.
	var/ability_use_channel
	/// Maximum charges that can be held of this item at a time. If unset, item does not accumulate charges.
	var/max_charge
	/// How long it takes between charges.
	var/charge_delay = 1 SECOND
	/// What flags to check before an ability can be used, if any.
	var/check_incapacitated   = (INCAPACITATION_STUNNED|INCAPACITATION_RESTRAINED|INCAPACITATION_BUCKLED_FULLY|INCAPACITATION_FORCELYING|INCAPACITATION_KNOCKOUT)
	/// What type of mob is required to use this ability.
	var/mob/expected_mob_type = /mob/living
	/// If set, this ability can only be used while standing on a turf (not in an atom's contents or null loc).
	var/requires_turf = TRUE
	/// If set, this ability cannot be used on the admin z-level.
	var/admin_blocked = TRUE

	// Various failure messages.
	/// Failed due to purged/null rod.
	var/cast_failed_purged_str     = "Another power interferes with your own!"
	/// Failed due to non-turf loc.
	var/cast_failed_no_turf        = "You must be standing on solid ground to use this ability."
	/// Failed due to being on admin level
	var/cast_failed_no_admin_level = "This ability cannot be used on the admin z-level."
	/// Failed due to being invalid mob type
	var/cast_failed_wrong_mob_type = "This ability may only be used by living creature."
	/// Failed due to being downed/buckled
	var/cast_failed_incapacitated  = "You are in no state to use that ability."
	/// Failed due to still being on cooldown from last use
	var/cast_failed_on_cooldown    = "You cannot use that ability again just yet."
	/// Failed due to still recharging
	var/cast_failed_no_charges     = "You are out of charges for that ability."
	/// Failed due to being silenced/disabled
	var/cast_failed_disabled_str   = "You are unable to use that ability for another $TIME$!"

/decl/ability/Initialize()
	target_selector = GET_DECL(target_selector)
	. = ..()

/decl/ability/validate()
	. = ..()

	if(!istype(target_selector, /decl/ability_targeting))
		. += "null or invalid target_selector: '[target_selector || "NULL"]'"

	if(!findtext(cast_failed_disabled_str, "$TIME$"))
		. += "missing $TIME$ token in cast_failed_disabled_str"

	if(!ispath(associated_handler_type, /datum/ability_handler))
		. += "null or invalid associated_handler_type '[associated_handler_type]'"

	if(!ability_icon)
		. += "null ability_icon"
	else if(!istext(ability_icon_state))
		. += "null or non-text ability_icon_state"
	else if(!check_state_in_icon(ability_icon, ability_icon_state))
		. += "missing ability_icon_state '[ability_icon_state]' in icon '[ability_icon]'"

/decl/ability/proc/get_cooldown_time(list/metadata)
	return cooldown_time

/decl/ability/proc/has_valid_targets(user, atom/target, list/metadata)
	// Projectiles just need something to shoot at.
	if(projectile_type)
		return isturf(target) || isturf(target.loc)
	// Abilities need at least one valid target.
	return target_selector.validate_initial_target(user, target, metadata)

// This is the main entrypoint for the ability use chain.
/decl/ability/proc/use_ability(mob/user, atom/target)

	if(!istype(user))
		return

	var/datum/ability_handler/handler = user.get_ability_handler(associated_handler_type, create_if_missing = FALSE)
	if(!istype(handler))
		CRASH("use_ability() called by mob with no handler of associated type!")

	var/list/metadata = handler.get_metadata(src)
	if(!islist(metadata))
		CRASH("use_ability() given null or non-list metadata!")

	if(!can_use_ability(user, metadata))
		return

	// Resolve our clicked target to the appropriate turf.
	target = target_selector.resolve_initial_target(target)
	if(!istype(target))
		return

	if(!has_valid_targets(user, target, metadata))
		return

	if(!prepare_to_cast(user, target, metadata))
		return

	if(projectile_type)
		// Fire a projectile if that is how this ability works.
		fire_projectile_at(user, target, metadata)
	else
		// Otherwise, just apply to the target directly.
		apply_effect(user, target, metadata)

/decl/ability/proc/fire_projectile_at(mob/user, atom/target, list/metadata)
	var/obj/item/projectile/projectile = new projectile_type(get_turf(user))
	if(istype(projectile, /obj/item/projectile/ability))
		var/obj/item/projectile/ability/ability_projectile = projectile
		ability_projectile.owner            = user
		ability_projectile.ability_metadata = metadata
		ability_projectile.carried_ability  = src
	projectile.original   = target
	projectile.starting   = get_turf(user)
	projectile.shot_from  = user
	projectile.current    = projectile.original
	projectile.yo         = target.y - user.y
	projectile.xo         = target.x - user.x
	projectile.life_span  = projectile_duration
	projectile.hitscan    = !projectile_step_delay
	projectile.step_delay = projectile_step_delay
	projectile.launch(target)
	return projectile

/decl/ability/proc/show_cast_channel_msg(mob/user, atom/target, list/metadata)
	user.visible_message(
		SPAN_NOTICE("\The [user] begins preparing to use an ability!"),
		SPAN_NOTICE("You begin preparing to use an ability.")
	)

/decl/ability/proc/show_ability_cast_msg(mob/user, list/targets, list/metadata)
	user.visible_message(
		SPAN_NOTICE("\The [user] casts an ability!"),
		SPAN_NOTICE("You cast an ability!")
	)

/decl/ability/proc/prepare_to_cast(mob/user, atom/target, list/metadata)
	if(ability_use_channel)
		show_cast_channel_msg(user, target, metadata)
		if(!do_after(user, ability_use_channel, target) || !can_use_ability(user, metadata))
			return FALSE
	var/use_cooldown_time = get_cooldown_time(metadata)
	if(use_cooldown_time > 0)
		metadata["next_cast"] = world.time + use_cooldown_time
	return TRUE

/decl/ability/proc/check_equipment(mob/user, list/metadata, silent = FALSE)
	return TRUE

/decl/ability/proc/get_metadata_for_user(mob/user)
	if(!user.has_ability(type))
		return null

	var/datum/ability_handler/handler = user.get_ability_handler(associated_handler_type, create_if_missing = FALSE)
	if(!istype(handler))
		CRASH("get_metadata_for_user() called by mob with no handler of associated type!")

	return handler.get_metadata(src)

/decl/ability/proc/can_use_ability(mob/user, list/metadata, silent = FALSE)

	if(!user.has_ability(type))
		error("\The [user] utilized the ability '[type]' without having access to it.")
		if(!silent)
			to_chat(user, SPAN_WARNING("You shouldn't have this ability! Please notify a developer or raise an issue ticket."))
		return FALSE

	var/turf/my_turf = get_turf(user)
	if(requires_turf)
		if(!istype(my_turf))
			if(!silent)
				to_chat(user, SPAN_WARNING(cast_failed_no_turf))
			return FALSE
		if(admin_blocked && isAdminLevel(my_turf.z))
			if(!silent)
				to_chat(user, SPAN_WARNING(cast_failed_no_admin_level))
			return FALSE

	if(!istype(user, expected_mob_type))
		if(!silent)
			to_chat(user, SPAN_WARNING(cast_failed_wrong_mob_type))
		return FALSE

	if(!isnull(check_incapacitated) && user.incapacitated(check_incapacitated))
		if(!silent)
			to_chat(user, SPAN_WARNING(cast_failed_incapacitated))
		return FALSE

	if(!check_equipment(user, metadata, silent))
		return FALSE

	if(cooldown_time && world.time < metadata["next_cast"])
		if(!silent)
			to_chat(user, SPAN_WARNING(cast_failed_on_cooldown))
		return FALSE

	if(max_charge && metadata["charges"] <= 0)
		if(!silent)
			to_chat(user, SPAN_WARNING(cast_failed_no_charges))
		return FALSE

	if(is_supernatural)

		var/is_purged = FALSE
		if(isanimal(user))
			var/mob/living/simple_animal/critter = user
			is_purged = !!critter.purge

		if(!is_purged)
			for(var/turf/turf in range(user, 1))
				if(turf.get_null_rod())
					is_purged = TRUE
					break

		if(is_purged)
			if(!silent)
				to_chat(user, SPAN_WARNING(cast_failed_purged_str))
			return FALSE

	var/disabled_time = metadata["disabled"]
	if(world.time < disabled_time)
		if(!silent)
			var/remaining_time = ceil((disabled_time - world.time) / 10)
			to_chat(user, SPAN_WARNING(replacetext(cast_failed_disabled_str, "$TIME$", "[remaining_time] second\s")))
		return FALSE

	return TRUE

/decl/ability/proc/apply_effect(mob/user, atom/hit_target, list/metadata, obj/item/projectile/ability/projectile)
	SHOULD_CALL_PARENT(TRUE)
	if(use_sound)
		playsound(get_turf(user), use_sound, use_sound_volume, 1)
	if(istype(projectile))
		projectile.expended = TRUE

	admin_attacker_log(user, "attempted to use ability [src] on [hit_target]")

	var/list/targets = target_selector.get_affected(user, hit_target, metadata, projectile)
	show_ability_cast_msg(user, targets, metadata)
	while(length(targets))
		var/target = targets[1]
		apply_effect_to(user, target, metadata)
		targets = prune_targets(user, target, targets, metadata)
	finish_casting(user, hit_target, metadata)

/decl/ability/proc/finish_casting(mob/user, atom/hit_target, list/metadata)
	return

/decl/ability/proc/prune_targets(user, previous_target, list/targets, list/metadata)
	if(!length(targets))
		return null
	if(previous_target)
		LAZYREMOVE(targets, previous_target)
	return targets

/decl/ability/proc/apply_visuals(mob/user, atom/target, list/metadata)
	if(!overlay_icon || !overlay_lifespan)
		return
	var/turf/overlay_loc = get_turf(target)
	if(!isturf(overlay_loc) || locate(/obj/effect/overlay) in overlay_loc)
		return
	var/obj/effect/overlay/ability_overlay = new(overlay_loc)
	ability_overlay.icon = overlay_icon
	ability_overlay.icon_state = overlay_icon_state
	ability_overlay.anchored = TRUE
	ability_overlay.set_density(FALSE)
	QDEL_IN(ability_overlay, overlay_lifespan)

/decl/ability/proc/apply_effect_to(mob/user, atom/target, list/metadata)
	SHOULD_CALL_PARENT(TRUE)
	apply_visuals(user, target, metadata)

/decl/ability/proc/get_default_metadata()
	. = list()
	if(cooldown_time)
		.["next_cast"]   = 0
	if(max_charge)
		.["charges"]     = max_charge
		.["next_charge"] = 0

/decl/ability/proc/recharge(mob/owner, list/metadata)
	if(max_charge <= 0 || metadata["charges"] >= max_charge)
		return FALSE
	if(world.time < metadata["next_charge"])
		return TRUE
	metadata["next_charge"] = world.time + charge_delay
	metadata["charges"]++
	return TRUE

/decl/ability/proc/get_stat_strings(list/metadata)
	var/use_name = metadata["ability_name"] || name
	if(cooldown_time)
		var/on_cooldown = metadata["next_cast"] - world.time
		if(on_cooldown > 0)
			return list(
				use_name,
				"[ceil(on_cooldown/10)]s"
			)
	if(max_charge)
		return list(
			use_name,
			"[metadata["charges"]]/[max_charge]"
		)

/decl/ability/ranged
	abstract_type = /decl/ability/ranged
	projectile_type = /obj/item/projectile/ability
