/decl/grab
	var/name                    = "generic grab"
	/// Whether or not the grabbed person can move out of the grab
	var/stop_move               = 0
	/// Whether the person being grabbed is facing forwards or backwards.
	var/reverse_facing          = 0
	/// Whether the person you're grabbing will shield you from bullets.,,
	var/shield_assailant        = 0
	/// How much the grab increases point blank damage.
	var/point_blank_mult        = 1
	/// Affects how much damage is being dealt using certain actions.
	var/damage_stage            = 1
	/// If the grabbed person and the grabbing person are on the same tile.
	var/same_tile               = 0
	/// If the grabber can throw the person grabbed.
	var/can_throw               = 0
	/// If the grab needs to be downgraded when the grabber does stuff.
	var/downgrade_on_action     = 0
	/// If the grab needs to be downgraded when the grabber moves.
	var/downgrade_on_move       = 0
	/// If the grab is strong enough to be able to force someone to do something harmful to them.
	var/force_danger            = 0
	/// If the grab acts like cuffs and prevents action from the victim.
	var/restrains               = 0
	/// Multiplier for the object size (w_class or mob_size) of the grabbed atom, applied as slowdown.
	var/grab_slowdown           = 0.15
	/// Whether or not this grab causes atoms to adjust their pixel offsets according to grabber dir.
	var/shift                   = 0
	/// Whether or not this grab causes atoms to adjust their plane/layer according to grabber dir.
	var/adjust_plane            = TRUE
	// This grab will adjust the victim's layering.
	var/adjust_layer            = TRUE

	var/success_up              = "You get a better grip on $rep_affecting$."
	var/success_down            = "You adjust your grip on $rep_affecting$."
	var/fail_up                 = "You can't get a better grip on $rep_affecting$!"
	var/fail_down               = "You can't seem to relax your grip on $rep_affecting$!"
	var/grab_icon               = 'icons/mob/screen/grabs.dmi'
	var/grab_icon_state         = "reinforce"
	var/upgrade_cooldown        = 40
	var/action_cooldown         = 40
	var/can_downgrade_on_resist = 1
	var/list/break_chance_table = list(100)
	var/breakability            = 2
	/// The names of different intents for use in attack logs
	var/help_action             = "help intent"
	var/disarm_action           = "disarm intent"
	var/grab_action             = "grab intent"
	var/harm_action             = "harm intent"
	/// The grab that this will upgrade to if it upgrades, null means no upgrade
	var/decl/grab/upgrab
	/// The grab that this will downgrade to if it downgrades, null means break grab on downgrade
	var/decl/grab/downgrab


/decl/grab/Initialize()
	if(ispath(upgrab, /decl/grab))
		upgrab = GET_DECL(upgrab)
	if(ispath(downgrab, /decl/grab))
		downgrab = GET_DECL(downgrab)
	. = ..()

/decl/grab/proc/string_process(var/obj/item/grab/grab, var/to_write, var/obj/item/used_item)
	to_write = replacetext(to_write, "$rep_affecting$", grab.affecting)
	to_write = replacetext(to_write, "$rep_assailant$", grab.assailant)
	if(used_item)
		to_write = replacetext(to_write, "$rep_item$", used_item)
	return to_write

/decl/grab/proc/upgrade(var/obj/item/grab/grab)
	if(can_upgrade(grab) && upgrade_effect(grab))
		to_chat(grab.assailant, SPAN_WARNING("[string_process(grab, success_up)]"))
		return upgrab
	to_chat(grab.assailant, SPAN_WARNING("[string_process(grab, fail_up)]"))

/decl/grab/proc/downgrade(var/obj/item/grab/grab)
	// If we have no downgrab at all, assume we just drop the grab.
	if(!downgrab)
		let_go(grab)
		return
	if(can_downgrade(grab) && downgrade_effect(grab))
		to_chat(grab.assailant, SPAN_NOTICE("[string_process(grab, success_down)]"))
		return downgrab
	to_chat(grab.assailant, SPAN_WARNING("[string_process(grab, fail_down)]"))

/decl/grab/proc/let_go(var/obj/item/grab/grab)
	if(grab.assailant && grab.affecting)
		to_chat(grab.assailant, SPAN_NOTICE("You release \the [grab.affecting]."))
	let_go_effect(grab)
	grab.force_drop()

/decl/grab/proc/on_target_change(var/obj/item/grab/grab, old_zone, new_zone)
	grab.special_target_functional = check_special_target(grab)
	if(grab.special_target_functional)
		special_target_change(grab, old_zone, new_zone)
		special_target_effect(grab)

/decl/grab/proc/process(var/obj/item/grab/grab)
	special_target_effect(grab)
	process_effect(grab)

/decl/grab/proc/throw_held(var/obj/item/grab/grab)
	if(grab.assailant == grab.affecting)
		return
	if(can_throw)
		. = grab.affecting
		var/mob/thrower = grab.loc
		qdel(grab)
		// check if we're grabbing with our inactive hand
		for(var/obj/item/grab/inactive_grab as anything in thrower.get_inactive_held_items())
			qdel(inactive_grab)

/decl/grab/proc/hit_with_grab(var/obj/item/grab/grab, var/atom/A, var/P = TRUE)

	if(QDELETED(grab) || !istype(grab))
		return FALSE

	if(!grab.check_action_cooldown() || grab.is_currently_resolving_hit)
		to_chat(grab.assailant, SPAN_WARNING("You must wait before you can do that."))
		return FALSE

	grab.is_currently_resolving_hit = TRUE

	var/intent_flags = grab.assailant.get_intent().intent_flags
	if((intent_flags & I_FLAG_HELP) && on_hit_help(grab, A, P))
		. = help_action || TRUE
	if(!. && (intent_flags & I_FLAG_DISARM) && on_hit_disarm(grab, A, P))
		. = disarm_action || TRUE
	if(!. && (intent_flags & I_FLAG_GRAB) && on_hit_grab(grab, A, P))
		. = grab_action || TRUE
	if(!. && (intent_flags & I_FLAG_HARM) && on_hit_harm(grab, A, P))
		. = harm_action || TRUE

	if(!QDELETED(grab))
		grab.is_currently_resolving_hit = FALSE
		if(.)
			grab.action_used()
			if(grab.assailant)
				grab.assailant.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				if(istext(.) && grab.affecting)
					admin_attack_log(grab.assailant, grab.affecting, "[.]s their victim", "was [.]ed", "used [.] on")
			if(downgrade_on_action)
				grab.downgrade()

// This is called whenever the assailant moves.
/decl/grab/proc/assailant_moved(var/obj/item/grab/grab)
	grab.adjust_position()
	moved_effect(grab)
	if(downgrade_on_move)
		grab.downgrade()

/*
	Override these procs to set how the grab state will work. Some of them are best
	overriden in the parent of the grab set (for example, the behaviour for on_hit_intent()
	procs is determined in /decl/grab/normal and then inherited by each intent).
*/

// What happens when you upgrade from one grab state to the next.
/decl/grab/proc/upgrade_effect(var/obj/item/grab/grab)
	admin_attack_log(grab.assailant, grab.affecting, "upgraded grab on their victim to [upgrab]", "was grabbed more tightly to [upgrab]", "upgraded grab to [upgrab] on")
	return TRUE

// Conditions to see if upgrading is possible
// Only works on mobs.
/decl/grab/proc/can_upgrade(var/obj/item/grab/grab)
	return !!upgrab && !!grab.get_affecting_mob()

// What happens when you downgrade from one grab state to the next.
/decl/grab/proc/downgrade_effect(var/obj/item/grab/grab)
	return TRUE

// Conditions to see if downgrading is possible
/decl/grab/proc/can_downgrade(var/obj/item/grab/grab)
	return !!downgrab

// What happens when you let go of someone by either dropping the grab
// or by downgrading from the lowest grab state.
/decl/grab/proc/let_go_effect(var/obj/item/grab/grab)

// What happens each tic when process is called.
/decl/grab/proc/process_effect(var/obj/item/grab/grab)

// Handles special targeting like eyes and mouth being covered.
/decl/grab/proc/special_target_effect(var/obj/item/grab/grab)

// Handles when they change targeted areas and something is supposed to happen.
/decl/grab/proc/special_target_change(var/obj/item/grab/grab, var/diff_zone)

// Checks if the special target works on the grabbed humanoid.
/decl/grab/proc/check_special_target(var/obj/item/grab/grab)

// What happens when you a target with the grab on help intent.
/decl/grab/proc/on_hit_help(var/obj/item/grab/grab, var/atom/A, var/proximity)
	return TRUE

// What happens when you a target with the grab on disarm intent.
/decl/grab/proc/on_hit_disarm(var/obj/item/grab/grab, var/atom/A, var/proximity)
	return TRUE

// What happens when you a target with the grab on grab intent.
/decl/grab/proc/on_hit_grab(var/obj/item/grab/grab, var/atom/A, var/proximity)
	return TRUE

// What happens when you a target with the grab on harm intent.
/decl/grab/proc/on_hit_harm(var/obj/item/grab/grab, var/atom/A, var/proximity)
	return TRUE

// What happens when you hit a target with an open hand and you want it
// to do some special snowflake action based on some other factor such as
// intent.
/decl/grab/proc/resolve_openhand_attack(var/obj/item/grab/grab)
	return 0

// Used when you want an effect to happen when the grab enters this state as an upgrade
/decl/grab/proc/enter_as_up(var/obj/item/grab/grab)

/decl/grab/proc/item_attack(var/obj/item/grab/grab, var/obj/item)
	return FALSE

/decl/grab/proc/resolve_item_attack(var/obj/item/grab/grab, var/mob/living/human/user, var/obj/item/I, var/target_zone)
	return FALSE

/decl/grab/proc/handle_resist(var/obj/item/grab/grab)
	var/mob/living/affecting = grab.get_affecting_mob()
	var/mob/living/assailant = grab.assailant
	if(!affecting)
		return
	if(affecting.incapacitated(INCAPACITATION_KNOCKOUT | INCAPACITATION_STUNNED))
		to_chat(grab.affecting, SPAN_WARNING("You can't resist in your current state!"))
	var/skill_mod = clamp(affecting.get_skill_difference(SKILL_COMBAT, assailant), -1, 1)
	var/break_strength = breakability + size_difference(affecting, assailant) + skill_mod

	if(affecting.incapacitated(INCAPACITATION_ALL))
		break_strength--
	if(HAS_STATUS(affecting, STAT_CONFUSE))
		break_strength--

	if(break_strength < 1)
		to_chat(grab.affecting, SPAN_WARNING("You try to break free but feel that unless something changes, you'll never escape!"))
		return

	var/break_chance = break_chance_table[clamp(break_strength, 1, break_chance_table.len)]
	if(prob(break_chance))
		if(can_downgrade_on_resist && !prob((break_chance+100)/2))
			affecting.visible_message(SPAN_WARNING("\The [affecting] has loosened \the [assailant]'s grip!"))
			grab.downgrade()
			return
		else
			affecting.visible_message(SPAN_WARNING("\The [affecting] has broken free of \the [assailant]'s grip!"))
			let_go(grab)

/decl/grab/proc/size_difference(mob/A, mob/B)
	return mob_size_difference(A.mob_size, B.mob_size)

/decl/grab/proc/moved_effect(var/obj/item/grab/grab)
	return