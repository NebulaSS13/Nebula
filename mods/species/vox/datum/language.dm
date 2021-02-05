/decl/language/vox
	name = "Vox-Pidgin"
	desc = "The common tongue of the various Vox ships making up the Shoal. It sounds like chaotic shrieking to everyone else."
	speech_verb = "shrieks"
	ask_verb = "creels"
	exclaim_verb = "SHRIEKS"
	colour = "vox"
	key = "x"
	flags = WHITELISTED
	syllables = list("ti","ti","ti","hi","hi","ki","ki","ki","ki","ya","ta","ha","ka","ya","chi","cha","kah", \
	"SKRE","AHK","EHK","RAWK","KRA","AAA","EEE","KI","II","KRI","KA")
	machine_understands = 0
	shorthand = "Vox"

/decl/language/vox/can_speak_special(var/mob/speaker)
	if(!ishuman(speaker))
		return FALSE
	var/mob/living/carbon/human/H = speaker
	var/obj/item/organ/internal/hindtongue/tongue = H.get_internal_organ(BP_HINDTONGUE)
	if(!istype(tongue) || !tongue.is_usable())
		to_chat(speaker, SPAN_WARNING("You are not capable of speaking [name]!"))
		return FALSE
	return TRUE

/decl/language/vox/get_random_name()
	return ..(FEMALE,1,6)
