/decl/posture
	abstract_type = /decl/posture
	/// Identifier for choosing from posture input().
	var/name
	/// Whether or not this posture is considered lying down.
	var/prone = FALSE
	/// Whether or not this posture is deliberate, ie. if you should automatically try to stand up from it.
	var/deliberate = FALSE
	/// Whether or not this posture should show up in Change Posture.
	var/is_user_selectable = FALSE
	/// Whether or not this posture should supply a string value to get_overlay_state_modifier().
	var/overlay_modifier
	/// An override for use when determining selectable postures.
	var/selectable_type
	/// String to use in Change Posture.
	var/posture_change_message

/decl/posture/proc/can_be_selected_by(mob/mob)
	return is_user_selectable
