/obj/screen/ai_button
	icon = 'icons/mob/screen/ai.dmi'
	requires_ui_style = FALSE
	var/mob/living/silicon/ai/ai_verb
	var/list/input_procs
	var/list/input_args
	var/list/template_icon = list(null, "template")
	var/image/template_undelay

/obj/screen/ai_button/handle_click(mob/user, params)
	if(!isAI(usr))
		return TRUE
	var/mob/living/silicon/ai/A = usr
	if(!(ai_verb in A.verbs))
		return TRUE

	var/input_arguments = list()
	for(var/input_proc in input_procs)
		var/input_flags = input_procs[input_proc]
		var/input_arg
		if(input_flags & AI_BUTTON_PROC_BELONGS_TO_CALLER) // Does the called proc belong to the AI, or not?
			input_arg = call(A, input_proc)()
		else
			input_arg= call(input_proc)()

		if(input_flags & AI_BUTTON_INPUT_REQUIRES_SELECTION)
			input_arg = input("Make a selection.", "Make a selection.") as null|anything in input_arg
			if(!input_arg)
				return // We assume a null-input means the user cancelled

		if(!(ai_verb in A.verbs) || A.incapacitated())
			return

		input_arguments += input_arg

	if(length(input_args))
		input_arguments |= input_args

	call(A, ai_verb)(arglist(input_arguments))
	return TRUE

/obj/screen/ai_button/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, ui_cat, decl/ai_hud/ai_hud_data)
	. = ..()

	name        = ai_hud_data.name
	icon_state  = ai_hud_data.icon_state
	screen_loc  = ai_hud_data.screen_loc
	ai_verb     = ai_hud_data.proc_path
	input_procs = ai_hud_data.input_procs?.Copy()
	input_args  = ai_hud_data.input_args?.Copy()

	if(!LAZYLEN(template_icon))
		template_icon = list(icon)
	template_undelay = image(template_icon[1], template_icon[2])
	underlays += template_undelay
