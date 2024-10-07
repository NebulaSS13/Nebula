/spell/targeted/exude_pleasantness
	name = "Exhude Pleasantness"
	desc = "A simple spell used to make friends with people. Be warned, this spell only has a subtle effect"
	feedback = "AP"
	school = "Illusion"
	requires_wizard_garb = FALSE
	range = 5
	max_targets = 0
	charge_max = 100
	var/list/possible_messages = list("seems pretty trustworthy!", "makes you feel appreciated.", "looks pretty cool.", "feels like the only decent person here!", "makes you feel safe.")
	ability_icon_state = "friendly"

/spell/targeted/exude_pleasantness/cast(var/list/targets, var/mob/user)
	for(var/m in targets)
		var/mob/living/L = m
		if(L.mind && L.mind.assigned_special_role == "Spellbound Servant")
			to_chat(m, SPAN_NOTICE("\The [user] seems relatively harmless."))
		else
			to_chat(m, FONT_LARGE(SPAN_NOTICE("\The [user] [pick(possible_messages)]")))