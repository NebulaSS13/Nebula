////////////////////////////////////////////////////////////////////
// Barricade Tape Template
////////////////////////////////////////////////////////////////////
//Singletons with data on the various templates of barricade tape
/decl/barricade_tape_template
	var/tape_kind         = "barricade"                   //Used as a prefix to the word "tape" when refering to the tape and roll
	var/tape_desc         = "A tape barricade."           //Description for the tape barricade
	var/roll_desc         = "A roll of barricade tape."   //Description for the tape roll
	var/icon_file         = 'icons/policetape.dmi'        //Icon file used for both the tape and roll
	var/base_icon_state   = "tape"                        //For the barricade. Icon state used to fetch the applied tape directional icons for various states
	var/list/req_access                                   //Access required to automatically pass through tape barricades
	var/tape_color                                        //Color of the tape
	var/detail_overlay                                    //Overlay for the applied tape
	var/detail_color                                      //Color for the detail overlay

/decl/barricade_tape_template/proc/make_line_barricade(var/mob/user, var/turf/T, var/pdir)
	var/obj/structure/tape_barricade/bar = new(T,,,src)
	bar.add_fingerprint(user)
	return bar

/decl/barricade_tape_template/proc/make_door_barricade(var/mob/user, var/obj/door)
	var/obj/structure/tape_barricade/door/bar = new(get_turf(door))
	bar.set_tape_template(src)
	bar.set_dir(door.dir)
	bar.add_fingerprint(user)
	return bar