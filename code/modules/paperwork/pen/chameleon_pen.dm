/obj/item/pen/chameleon/Initialize(ml, material_key)
	. = ..()
	set_tool_property(TOOL_PEN, TOOL_PROP_PEN_SIG, "Anonymous") //Always default to anonymous for this pen, since it should never uses the user's real_name

/obj/item/pen/chameleon/attack_self(mob/user)
	/*
	// Limit signatures to official crew members
	var/personnel_list[] = list()
	for(var/datum/data/record/t in data_core.locked) //Look in data core locked.
		personnel_list.Add(t.fields["name"])
	personnel_list.Add("Anonymous")

	var/new_signature = input("Enter new signature pattern.", "New Signature") as null|anything in personnel_list
	if(new_signature)
		signature = new_signature
	*/
	var/signature = sanitize(input("Enter new signature. Leave blank for 'Anonymous'", "New Signature", get_tool_property(TOOL_PEN, TOOL_PROP_PEN_SIG)))
	set_tool_property(TOOL_PEN, TOOL_PROP_PEN_SIG, signature ? signature : "Anonymous") 

/obj/item/pen/chameleon/verb/set_colour()
	set name = "Change Pen Colour"
	set category = "Object"

	var/list/possible_colours = list ("Yellow", "Green", "Pink", "Blue", "Orange", "Cyan", "Red", "Invisible", "Black")
	var/selected_type = input("Pick new colour.", "Pen Colour", null, null) as null|anything in possible_colours

	if(selected_type)
		switch(selected_type)
			if("Yellow")
				set_medium_color(COLOR_YELLOW, "yellow")
			if("Green")
				set_medium_color(COLOR_LIME,   "green")
			if("Pink")
				set_medium_color(COLOR_PINK,   "pink")
			if("Blue")
				set_medium_color(COLOR_BLUE,   "blue")
			if("Orange")
				set_medium_color(COLOR_ORANGE, "orange")
			if("Cyan")
				set_medium_color(COLOR_CYAN,   "cyan")
			if("Red")
				set_medium_color(COLOR_RED,    "red")
			if("Invisible")
				set_medium_color(COLOR_WHITE,  "transluscent")
			else
				set_medium_color(COLOR_BLACK,  "black")

		to_chat(usr, SPAN_INFO("You select the [lowertext(selected_type)] [medium_name] container."))