#define SWISSKNF_CLOSED  "Close"
#define SWISSKNF_LBLADE  "Large Blade"
#define SWISSKNF_SBLADE  "Small Blade"
#define SWISSKNF_CLIFTER "Cap Lifter-Screwdriver"
#define SWISSKNF_COPENER "Can Opener-Screwdriver"
#define SWISSKNF_CSCREW  "Corkscrew"
#define SWISSKNF_GBLADE  "Glass Cutter"
#define SWISSKNF_WCUTTER "Wirecutters"
#define SWISSKNF_WBLADE  "Wood Saw"
#define SWISSKNF_CROWBAR "Pry Bar"

/obj/item/knife/folding/swiss
	name = "combi-knife"
	desc = "A small, colourable, multi-purpose folding knife."
	icon = 'icons/obj/items/weapon/knives/folding/swiss.dmi'
	valid_handle_colors = null
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

	var/active_tool = SWISSKNF_CLOSED
	var/can_use_tools = FALSE
	var/list/tools = list(SWISSKNF_LBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER)
	var/static/list/sharp_tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_GBLADE, SWISSKNF_WBLADE)

/obj/item/knife/folding/swiss/Initialize(ml, material_key)
	set_extension(src, /datum/extension/tool/variable/simple, list(
		TOOL_CROWBAR =     TOOL_QUALITY_MEDIOCRE,
		TOOL_SCREWDRIVER = TOOL_QUALITY_MEDIOCRE,
		TOOL_WIRECUTTERS = TOOL_QUALITY_MEDIOCRE,
		TOOL_HATCHET =     TOOL_QUALITY_MEDIOCRE
	))
	. = ..()

/obj/item/knife/folding/swiss/proc/get_tool_archetype()
	if(can_use_tools)
		if(active_tool == SWISSKNF_CROWBAR)
			return TOOL_CROWBAR
		if(active_tool == SWISSKNF_CLIFTER || active_tool == SWISSKNF_COPENER)
			return TOOL_SCREWDRIVER
		if(active_tool == SWISSKNF_WCUTTER)
			return TOOL_WIRECUTTERS
	if(active_tool == SWISSKNF_WBLADE)
		return TOOL_HATCHET

/obj/item/knife/folding/swiss/get_tool_speed(archetype)
	. = (archetype == get_tool_archetype()) ? ..() : 0

/obj/item/knife/folding/swiss/get_tool_quality(archetype)
	. = (archetype == get_tool_archetype()) ? ..() : 0

/obj/item/knife/folding/swiss/attack_self(mob/user)
	var/choice
	if(user.a_intent != I_HELP && ((SWISSKNF_LBLADE in tools) || (SWISSKNF_SBLADE in tools)) && active_tool == SWISSKNF_CLOSED)
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
		return
	if(choice == SWISSKNF_CLOSED)
		open = FALSE
		user.visible_message("<span class='notice'>\The [user] closes the [name].</span>")
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

/obj/item/knife/folding/swiss/examine(mob/user)
	. = ..()
	to_chat(user, active_tool == SWISSKNF_CLOSED ? "It is closed." : "Its [lowertext(active_tool)] is folded out.")

/obj/item/knife/folding/swiss/update_attack_force()
	..()
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
		edge = initial(edge)
		sharp = initial(sharp)
		attack_verb = closed_attack_verbs
		siemens_coefficient = initial(siemens_coefficient)

/obj/item/knife/folding/swiss/on_update_icon()
	..()
	if(active_tool != null)
		add_overlay(overlay_image(icon, active_tool, flags = RESET_COLOR))

/obj/item/knife/folding/swiss/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_adjustment = FALSE)
	. = (active_tool == SWISSKNF_LBLADE || active_tool == SWISSKNF_SBLADE) ? ..() : new /image

/obj/item/knife/folding/swiss/resolve_attackby(obj/target, mob/user)
	if((istype(target, /obj/structure/window) || istype(target, /obj/structure/grille)) && active_tool == SWISSKNF_GBLADE)
		var/force = get_base_attack_force()
		set_base_attack_force(force * 8)
		. = ..()
		set_base_attack_force(force)
		return
	if(istype(target, /obj/item))
		if(target.w_class <= ITEM_SIZE_NORMAL)
			can_use_tools = TRUE
			. = ..()
			can_use_tools = FALSE
			return
	return ..()

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

/obj/item/knife/folding/swiss/explorer
	name = "explorer's combi-knife"
	desc = "A small, purple, multi-purpose folding knife. This one adds a wood saw and pry bar."
	handle_color = COLOR_PURPLE
	tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_WBLADE, SWISSKNF_CROWBAR)

/obj/item/knife/folding/swiss/loot
	name = "black combi-knife"
	desc = "A small, silver, multi-purpose folding knife. This one adds a small blade and corkscrew."
	handle_color = COLOR_GRAY40
	tools = list(SWISSKNF_LBLADE, SWISSKNF_SBLADE, SWISSKNF_CLIFTER, SWISSKNF_COPENER, SWISSKNF_CSCREW)

#undef SWISSKNF_CLOSED
#undef SWISSKNF_LBLADE
#undef SWISSKNF_SBLADE
#undef SWISSKNF_CLIFTER
#undef SWISSKNF_COPENER
#undef SWISSKNF_CSCREW
#undef SWISSKNF_GBLADE
#undef SWISSKNF_WCUTTER
#undef SWISSKNF_WBLADE
#undef SWISSKNF_CROWBAR
