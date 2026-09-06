/decl/mob_modifier/lying
	name                     = "Lying"
	desc                     = "You are lying down and may need to stand up before taking action."
	hud_icon_state           = "prone"
	show_indefinite_duration = FALSE

/decl/mob_modifier/lying/on_modifier_datum_click(mob/living/_owner, decl/mob_modifier/modifier, params)
	if(_owner.current_posture?.prone)
		_owner.lay_down()
	return TRUE
