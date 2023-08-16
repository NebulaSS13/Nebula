//Credits: starlight, quardbreak
//for some reason icon flick just doesn't work, I have no idea why.

/obj/item/scanner/security
	name = "security scanner"
	desc = "A hand-held security scanner which identifies banned items."
	icon = 'icons/obj/items/scanner_security.dmi'
	icon_state = ICON_STATE_WORLD

	origin_tech = "{'magnets':2}"
	scan_sound = 'sound/machines/scanner_security.ogg'
	use_delay = 2 SECONDS
	var/scan_sound_detect = list(
		'sound/machines/scanner_security_detect_1.ogg',
		'sound/machines/scanner_security_detect_2.ogg'
	)

	//Materials used to detect.
	var/list/detect_materials = list(
		/decl/material/solid/metal/steel
	)

/obj/item/scanner/security/is_valid_scan_target(atom/A)
	return isliving(A) || isobj(A)

/obj/item/scanner/security/show_menu(mob/user)
	return

/obj/item/scanner/security/scan(atom/A, mob/user)
	var/list/scanned_objects = list(A)
	recursive_content_check(A, scanned_objects)
	var/maxbeep = 5
	for(var/obj/O in scanned_objects)
		for(var/M in O.matter)
			if(is_path_in_list(M, detect_materials))
				playsound(src, pick(scan_sound_detect), 30)
				maxbeep--
				break
		if(!maxbeep)
			break

/obj/item/scanner/security/fake
	detect_materials = list()