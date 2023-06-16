//	Observer Pattern Implementation: Zone Selected
//		Registration type: /obj/screen/zone_selector
//
//		Raised when: A /obj/screen/zone_selector had its selected zone modified.
//
//		Arguments that the called proc should expect:
//			/obj/screen/zone_selector: the
//			old_zone: the previously selected zone
//          new_zone: the newly selected zone
//

/decl/observ/zone_selected
	name = "Zone Selected"
	expected_type = /obj/screen/zone_selector

/*******************
* Zone Selected Handling *
*******************/

/obj/screen/zone_selector/set_selected_zone(bodypart)
	var/old_selecting = selecting
	if((. = ..()))
		RAISE_EVENT(/decl/observ/zone_selected, src, old_selecting, selecting)