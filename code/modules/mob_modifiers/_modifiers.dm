// Notes on mob modifiers:
// - added/removed from mob with add_mob_modifier(/decl/mob_modifier/foo, DURATION IN DS, source = SOME ATOM)
// - decl will generate a decl/mob_modifier based on the source of the modifier
// - decl heartbeat logic (actual modifier) will run once per life tick regardless of number of sources, if you want
//   stacking modifiers it has to be implemented within the decl.

/// Instanced 'modifiers' that sit on top of a mob and can expire over time or linger until dispelled.
/// Some are purely visual, others have associated modifiers.
/decl/mob_modifier
	abstract_type = /decl/mob_modifier
	/// Tooltip name of this modifier.
	var/name
	/// Tooltip description of this modifier.
	var/desc
	/// Icon to use for the HUD element.
	var/hud_icon = 'icons/screen/mob_modifiers.dmi'
	/// State to use for the HUD element.
	var/hud_icon_state
	/// Icon to draw from for the mob overlay modifier is present.
	var/mob_overlay_icon
	/// State to draw over the mob when modifier is present.
	var/mob_overlay_state
	/// Metadata type to create for this status modifier.
	var/modifier_type = /datum/mob_modifier
	/// Message shown to the target when modifier begins.
	var/on_add_message_1p
	/// Message shown to the audience when modifier begins.
	var/on_add_message_3p
	/// Message shown to the target when modifier ends.
	var/on_end_message_1p
	/// Message shown to the audience when modifier ends.
	var/on_end_message_3p
	/// Whether or not this modifier can be granted by admin (source-ambivalent)
	var/can_be_admin_granted = FALSE
	/// Whether or not this modifier shows a lemniscate when set to indefinite duration.
	var/show_indefinite_duration = TRUE
	/// Whether or not this modifier shows remaining time before expiry.
	var/hide_expiry= FALSE

/decl/mob_modifier/validate()
	. = ..()
	if(!hud_icon)
		. += "no hud_icon set"
	if(!istext(hud_icon_state))
		. += "null or invalid hud_icon_state"
	if(hud_icon && hud_icon_state && !check_state_in_icon(hud_icon_state, hud_icon))
		. += "hud_icon '[hud_icon]' missing hud_icon_state '[hud_icon_state]'"

	if(mob_overlay_icon)
		if(istext(mob_overlay_state))
			if(!check_state_in_icon(mob_overlay_state, mob_overlay_icon))
				. += "mob_overlay_icon '[mob_overlay_icon]' missing mob_overlay_state '[mob_overlay_state]'"
		else
			. += "null or invalid mob_overlay_state"
	else if(mob_overlay_state)
		. += "mob_overlay_state set but mob_overlay_icon not set"

/decl/mob_modifier/proc/replace_tokens(message, mob/user)
	return capitalize_proper_html(emote_replace_user_tokens(message, user))

/decl/mob_modifier/proc/on_modifier_datum_added(mob/living/_owner, datum/mob_modifier/modifier)
	if(on_add_message_3p)
		_owner.visible_message(replace_tokens(on_add_message_3p, _owner), replace_tokens((on_add_message_3p || on_add_message_1p), _owner))
	else if(on_add_message_1p)
		to_chat(_owner, replace_tokens(on_add_message_1p, _owner))
	return TRUE

/decl/mob_modifier/proc/on_modifier_datum_removed(mob/living/_owner, datum/mob_modifier/modifier)
	if(on_end_message_3p)
		_owner.visible_message(replace_tokens(on_end_message_3p, _owner), replace_tokens((on_end_message_3p || on_end_message_1p), _owner))
	else if(on_end_message_1p)
		to_chat(_owner, replace_tokens(on_end_message_1p, _owner))
	return TRUE

/decl/mob_modifier/proc/on_modifier_datum_expiry(mob/living/_owner, datum/mob_modifier/modifier)
	return TRUE

/decl/mob_modifier/proc/on_modifier_datum_mob_life(mob/living/_owner, list/modifiers)
	SHOULD_CALL_PARENT(TRUE)
	. = FALSE
	for(var/datum/mob_modifier/modifier in modifiers)
		if(modifier.on_modifier_mob_life())
			. = TRUE

/decl/mob_modifier/proc/on_modifier_datum_click(mob/living/_owner, datum/mob_modifier/modifier, params)
	return FALSE

/decl/mob_modifier/proc/check_modifiers_block_attack(mob/living/_owner, list/modifiers, attack_type, atom/movable/attacker, additional_data)
	return FALSE
