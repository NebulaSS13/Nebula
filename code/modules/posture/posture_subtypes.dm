/decl/posture/standing
	name = "standing"
	posture_change_message = "standing up"
	is_user_selectable = TRUE
	deliberate = TRUE

/decl/posture/lying
	name = "lying"
	prone = TRUE
	posture_change_message = "lying down"
	selectable_type = /decl/posture/lying/deliberate

/decl/posture/lying/deliberate
	name = "resting"
	is_user_selectable = TRUE
	deliberate = TRUE

/decl/posture/sitting
	name = "sitting"
	posture_change_message = "sitting down"
	is_user_selectable = TRUE
	deliberate = TRUE
	prone = TRUE
