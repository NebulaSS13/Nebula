/obj/item/knife/folding/swiss
	name = "combi-knife"
	desc = "A small, colourable, multi-purpose folding knife."
	icon = 'icons/obj/items/weapon/knives/folding/swiss.dmi'
	valid_handle_colors = null
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

	var/const/SWISSKNF_CLOSED  = "Close"
	var/const/SWISSKNF_LBLADE  = "Large Blade"
	var/const/SWISSKNF_SBLADE  = "Small Blade"
	var/const/SWISSKNF_CLIFTER = "Cap Lifter-Screwdriver"
	var/const/SWISSKNF_COPENER = "Can Opener-Screwdriver"
	var/const/SWISSKNF_CSCREW  = "Corkscrew"
	var/const/SWISSKNF_GBLADE  = "Glass Cutter"
	var/const/SWISSKNF_WCUTTER = "Wirecutters"
	var/const/SWISSKNF_WBLADE  = "Wood Saw"
	var/const/SWISSKNF_CROWBAR = "Pry Bar"

	var/active_tool = SWISSKNF_CLOSED
	var/list/tools = list(SWISSKNF_LBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER)
	var/static/list/sharp_tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_GBLADE, SWISSKNF_WBLADE)

/obj/item/knife/folding/swiss/Initialize(ml, material_key)
	// Variable tool qualities are handled by proc below.
	set_extension(src, /datum/extension/tool, list(
		TOOL_CROWBAR =     TOOL_QUALITY_MEDIOCRE,
		TOOL_SCREWDRIVER = TOOL_QUALITY_MEDIOCRE,
		TOOL_WIRECUTTERS = TOOL_QUALITY_MEDIOCRE,
		TOOL_HATCHET =     TOOL_QUALITY_MEDIOCRE
	))
	. = ..()

/obj/item/knife/folding/swiss/proc/get_tool_archetype()
	if(active_tool == SWISSKNF_CROWBAR)
		return TOOL_CROWBAR
	if(active_tool == SWISSKNF_CLIFTER || active_tool == SWISSKNF_COPENER)
		return TOOL_SCREWDRIVER
	if(active_tool == SWISSKNF_WCUTTER)
		return TOOL_WIRECUTTERS
	if(active_tool == SWISSKNF_WBLADE)
		return TOOL_HATCHET

/obj/item/knife/folding/swiss/get_tool_property(archetype, property)
	. = (archetype == get_tool_archetype()) ? ..() : null

/obj/item/knife/folding/swiss/get_tool_speed(archetype)
	. = (archetype == get_tool_archetype()) ? ..() : 0

/obj/item/knife/folding/swiss/get_tool_quality(archetype)
	. = (archetype == get_tool_archetype()) ? ..() : 0

/obj/item/knife/folding/swiss/attack_self(mob/user)

	var/choice
	if(!user.check_intent(I_FLAG_HELP) && ((SWISSKNF_LBLADE in tools) || (SWISSKNF_SBLADE in tools)) && active_tool == SWISSKNF_CLOSED)
		open = TRUE
		if(SWISSKNF_LBLADE in tools)
			choice = SWISSKNF_LBLADE
		else
			choice = SWISSKNF_SBLADE
	else
		if(active_tool == SWISSKNF_CLOSED)
			choice = input("Select a tool to open.","Knife") as null|anything in tools|SWISSKNF_CLOSED
		else
			choice = SWISSKNF_CLOSED
			open = FALSE

	if(!choice || !CanPhysicallyInteract(user))
		return TRUE

	if(choice == SWISSKNF_CLOSED)
		open = FALSE
		user.visible_message("<span class='notice'>\The [user] closes \the [src].</span>")
	else
		open = TRUE
		if(choice == SWISSKNF_LBLADE || choice == SWISSKNF_SBLADE)
			user.visible_message("<span class='warning'>\The [user] opens the [lowertext(choice)].</span>")
			playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
		else
			user.visible_message("<span class='notice'>\The [user] opens the [lowertext(choice)].</span>")

	active_tool = choice
	update_attack_force()
	update_icon()
	add_fingerprint(user)
	return TRUE

/obj/item/knife/folding/swiss/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(active_tool == SWISSKNF_CLOSED)
		. += "It is closed."
	else
		. += "Its [lowertext(active_tool)] is folded out."

/obj/item/knife/folding/swiss/update_attack_force()
	. = ..()
	if(active_tool == SWISSKNF_CLOSED)
		w_class = initial(w_class)
	else
		w_class = ITEM_SIZE_NORMAL
	if(active_tool in sharp_tools)
		if(active_tool == SWISSKNF_GBLADE)
			siemens_coefficient = 0
		else
			siemens_coefficient = initial(siemens_coefficient)
	else
		set_edge(initial(edge))
		set_sharp(initial(sharp))
		attack_verb = closed_attack_verbs
		siemens_coefficient = initial(siemens_coefficient)

/obj/item/knife/folding/swiss/on_update_icon()
	..()
	if(active_tool != null)
		add_overlay(overlay_image(icon, active_tool, flags = RESET_COLOR))

/obj/item/knife/folding/swiss/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_adjustment = FALSE)
	. = (active_tool == SWISSKNF_LBLADE || active_tool == SWISSKNF_SBLADE) ? ..() : new /image

/obj/item/knife/folding/swiss/resolve_attackby(obj/target, mob/user)
	var/force = get_base_attack_force()
	if((istype(target, /obj/structure/window) || istype(target, /obj/structure/grille)) && active_tool == SWISSKNF_GBLADE)
		set_base_attack_force(force * 8)
	else
		set_base_attack_force(force)
	. = ..()
	set_base_attack_force(force)

/obj/item/knife/folding/swiss/officer
	name = "officer's combi-knife"
	desc = "A small, blue, multi-purpose folding knife. This one adds a corkscrew."
	handle_color = COLOR_COMMAND_BLUE
	tools = list(SWISSKNF_LBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_CSCREW)

/obj/item/knife/folding/swiss/sec
	name = "Master-At-Arms' combi-knife"
	desc = "A small, red, multi-purpose folding knife. This one adds no special tools."
	handle_color = COLOR_NT_RED
	tools = list(SWISSKNF_LBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER)

/obj/item/knife/folding/swiss/medic
	name = "medic's combi-knife"
	desc = "A small, green, multi-purpose folding knife. This one adds a smaller blade in place of the large blade and a glass cutter."
	handle_color = COLOR_OFF_WHITE
	tools = list(SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_GBLADE)

/obj/item/knife/folding/swiss/engineer
	name = "engineer's combi-knife"
	desc = "A small, yellow, multi-purpose folding knife. This one adds a wood saw and wire cutters."
	handle_color = COLOR_AMBER
	tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_WBLADE, SWISSKNF_WCUTTER)

/obj/item/knife/folding/swiss/loot
	name = "black combi-knife"
	desc = "A small, silver, multi-purpose folding knife. This one adds a small blade and corkscrew."
	handle_color = COLOR_GRAY40
	tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_CSCREW)
