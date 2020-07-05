var/list/cag_card_text_lists = list()

// This is a parody of Cards Against Humanity (https://en.wikipedia.org/wiki/Cards_Against_Humanity)
// which is licensed under CC BY-NC-SA 2.0, the full text of which can be found at the following URL:
// https://creativecommons.org/licenses/by-nc-sa/2.0/legalcode

/obj/item/deck/cag
	var/load_text_from_file

/obj/item/deck/cag/Initialize()
	. = ..()

	if(!load_text_from_file || !fexists(load_text_from_file))
		return INITIALIZE_HINT_QDEL

	if(!global.cag_card_text_lists[load_text_from_file])
		global.cag_card_text_lists[load_text_from_file] = file2list(load_text_from_file)

	if(!length(global.cag_card_text_lists[load_text_from_file]))
		return INITIALIZE_HINT_QDEL

	var/datum/playingcard/P
	for(var/cardtext in global.cag_card_text_lists[load_text_from_file])
		P = new()
		P.name = "[cardtext]"
		P.card_icon = "[icon_state]_card"
		P.back_icon = "[icon_state]_card_back"
		cards += P

/obj/item/deck/cag/black
	name = "\improper CAG deck (black)"
	desc = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the black deck."
	icon_state = "cag_black"
	load_text_from_file = "config/cag_card_text_black.txt"

/obj/item/deck/cag/white
	name = "\improper CAG deck (white)"
	desc = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the white deck."
	icon_state = "cag_white"
	load_text_from_file = "config/cag_card_text_white.txt"

/obj/item/deck/cag/white/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		var/datum/playingcard/P
		for(var/x = 1 to 5)
			P = new()
			P.name = "blank card"
			P.card_icon = "[icon_state]_card"
			P.back_icon = "[icon_state]_card_back"
			cards += P
