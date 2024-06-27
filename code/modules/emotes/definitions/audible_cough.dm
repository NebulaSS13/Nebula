/decl/emote/audible/cough
	key = "cough"
	emote_message_1p = "You cough!"
	emote_message_1p_target = "You cough on $TARGET$!"
	emote_message_3p = "$USER$ coughs!"
	emote_message_3p_target = "$USER$ coughs on $TARGET$!"
	emote_message_synthetic_1p_target = "You emit a robotic cough towards $TARGET$."
	emote_message_synthetic_1p = "You emit a robotic cough."
	emote_message_synthetic_3p_target = "$USER$ emits a robotic cough towards $TARGET$."
	emote_message_synthetic_3p = "$USER$ emits a robotic cough."
	emote_volume = 120
	emote_volume_synthetic = 50
	conscious = FALSE
	bodytype_emote_sound = "cough"

/decl/emote/audible/cough/mob_can_use(mob/living/user, assume_available = FALSE)
	. = ..()
	if(. && !user.isSynthetic())
		var/obj/item/organ/internal/lungs/lung = user.get_organ(BP_LUNGS)
		. = lung?.active_breathing

/decl/emote/audible/cough/do_emote(var/mob/living/user, var/extra_params)
	. = ..()
	if(. && istype(user))
		user.cough(silent = TRUE, deliberate = TRUE)
		return TRUE
	to_chat(src, SPAN_WARNING("You are unable to cough."))
	return FALSE
