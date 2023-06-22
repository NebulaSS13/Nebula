/mob/living/silicon/ai
	hud_type = /datum/hud/ai

/datum/hud/ai/FinalizeInstantiation()
	var/list/ai_hud_data = decls_repository.get_decls_of_subtype(/decl/ai_hud)
	for(var/elem_type in ai_hud_data)
		var/decl/ai_hud/ai_hud = ai_hud_data[elem_type]
		adding += new /obj/screen/ai_button(null,
			ai_hud.screen_loc,
			ai_hud.name,
			ai_hud.icon_state,
			ai_hud.proc_path,
			ai_hud.input_procs,
			ai_hud.input_args
		)
	if(mymob?.client)
		mymob.client.screen = list(adding)
