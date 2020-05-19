/mob/living/carbon/human
	var/obj/home_spawn		// The object we last safe-slept on. Used for moving characters to safe locations on loads.

/mob/living/carbon/human/after_deserialize()
	// This refreshes/rebuilds the UI.
	for(var/obj/item/I in contents)
		I.hud_layerise()
	. = ..()

// For granting cortical chat on character creation.
/mob/living/carbon/human/update_languages()	
	. = ..()
	var/obj/item/organ/internal/stack/stack = (locate() in internal_organs)
	if(stack)
		add_language(/decl/language/cortical)