/mob/living/silicon/ai
	hud_used = /datum/hud/ai

/datum/hud/ai/FinalizeInstantiation()
	var/list/ai_hud_data = decls_repository.get_decls_of_subtype(/decl/ai_hud)
	for(var/elem_type in ai_hud_data)
		adding += new /obj/screen/ai_button(null, mymob, null, null, null, null, ai_hud_data[elem_type])
	..()
