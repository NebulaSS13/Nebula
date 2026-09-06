////////////////////////////////////////////////////////////////////
// Door Tape Barricade
////////////////////////////////////////////////////////////////////

//Barricade over a single door
/obj/structure/tape_barricade/door
	icon_state = "tape_door_0"
	layer      = ABOVE_DOOR_LAYER

/obj/structure/tape_barricade/door/update_neighbors()
	//We completely ignore neighbors
	neighbors = 0

/obj/structure/tape_barricade/door/icon_name_override()
	return "door" //Override the icon picking to pick this icon label instead

////////////////////////////////////////////////////////////////////
// Police Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/police
	tape_kind  = "police"
	tape_desc  = "A length of police tape.  Do not cross."
	roll_desc  = "A roll of police tape used to block off crime scenes from the public."
	tape_color = COLOR_RED
	req_access = list(access_security)

/obj/item/stack/tape_roll/barricade_tape/police
	tape_template = /decl/barricade_tape_template/police

//mapper type
/obj/structure/tape_barricade/police
	icon_state    = "tape_door_0"
	color         = COLOR_RED
	tape_template = /decl/barricade_tape_template/police

////////////////////////////////////////////////////////////////////
// Engineering Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/engineering
	tape_kind  = "engineering"
	tape_desc  = "A length of engineering tape. Better not cross it."
	roll_desc  = "A roll of engineering tape used to block off working areas from the public."
	tape_color = COLOR_ORANGE
	req_access = list(list(access_engine,access_atmospherics))

/obj/item/stack/tape_roll/barricade_tape/engineering
	tape_template = /decl/barricade_tape_template/engineering

//mapper type
/obj/structure/tape_barricade/engineering
	icon_state    = "stripetape_door_0"
	color         = COLOR_ORANGE
	tape_template = /decl/barricade_tape_template/engineering

////////////////////////////////////////////////////////////////////
// Atmospheric Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/atmos
	tape_kind       = "atmospherics"
	tape_desc       = "A length of atmospherics tape. Better not cross it."
	roll_desc       = "A roll of atmospherics tape used to block off working areas from the public."
	tape_color      = COLOR_BLUE_LIGHT
	req_access      = list(list(access_engine,access_atmospherics))
	base_icon_state = "stripetape"
	detail_overlay  = "stripes"
	detail_color    = COLOR_YELLOW

/obj/item/stack/tape_roll/barricade_tape/atmos
	tape_template = /decl/barricade_tape_template/atmos

//mapper type
/obj/structure/tape_barricade/atmos
	icon_state    = "stripetape_h_0"
	color         = COLOR_BLUE_LIGHT
	tape_template = /decl/barricade_tape_template/atmos

////////////////////////////////////////////////////////////////////
// Research Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/research
	tape_kind  = "research"
	tape_desc  = "A length of research tape. Better not cross it."
	roll_desc  = "A roll of research tape used to block off working areas from the public."
	tape_color = COLOR_WHITE
	req_access = list(access_research)

/obj/item/stack/tape_roll/barricade_tape/research
	tape_template = /decl/barricade_tape_template/research

//mapper type
/obj/structure/tape_barricade/research
	color         = COLOR_WHITE
	tape_template = /decl/barricade_tape_template/research

////////////////////////////////////////////////////////////////////
// Medical Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/medical
	tape_kind       = "medical"
	tape_desc       = "A length of medical tape. Better not cross it."
	roll_desc       = "A roll of medical tape used to block off working areas from the public."
	tape_color      = COLOR_PALE_BLUE_GRAY
	req_access      = list(access_medical)
	base_icon_state = "stripetape"
	detail_overlay  = "stripes"
	detail_color    = COLOR_PALE_BLUE_GRAY

/obj/item/stack/tape_roll/barricade_tape/medical
	tape_template = /decl/barricade_tape_template/medical

//mapper type
/obj/structure/tape_barricade/medical
	icon_state    = "stripetape_h_0"
	color         = COLOR_PALE_BLUE_GRAY
	tape_template = /decl/barricade_tape_template/medical

////////////////////////////////////////////////////////////////////
// Bureacratic Tape
////////////////////////////////////////////////////////////////////
/decl/barricade_tape_template/bureaucracy
	tape_kind       = "red"
	tape_desc       = "A length of bureaucratic red tape. Safely ignored, but darn obstructive sometimes."
	roll_desc       = "A roll of bureaucratic red tape used to block any meaningful work from being done."
	tape_color      = COLOR_RED
	base_icon_state = "stripetape"
	detail_overlay  = "stripes"
	detail_color    = COLOR_RED

/obj/item/stack/tape_roll/barricade_tape/bureaucracy
	tape_template = /decl/barricade_tape_template/bureaucracy

//mapper type
/obj/structure/tape_barricade/bureaucracy
	icon_state    = "stripetape_h_0"
	color         = COLOR_RED
	tape_template = /decl/barricade_tape_template/bureaucracy