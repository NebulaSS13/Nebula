/decl/interaction_handler/extinguisher_cabinet_open
	name = "Open/Close"
	expected_target_type = /obj/structure/extinguisher_cabinet

/decl/interaction_handler/extinguisher_cabinet_open/invoked(var/atom/target, var/mob/user)
	var/obj/structure/extinguisher_cabinet/C = target
	C.opened = !C.opened
	C.update_icon()

/decl/interaction_handler/sealant_try_inject
	name = "Inject Sealant"
	expected_target_type = /obj/structure/sealant_injector

/decl/interaction_handler/sealant_try_inject/invoked(var/atom/target, var/mob/user)
	var/obj/structure/sealant_injector/SI = target
	SI.try_inject(user)

/decl/interaction_handler/ladder_fold
	name = "Fold Ladder"
	expected_target_type = /obj/structure/ladder/mobile

/decl/interaction_handler/ladder_fold/invoked(var/atom/target, var/mob/user)
	var/obj/structure/ladder/mobile/L
	L.fold(user)

/decl/interaction_handler/closet_lock_toggle
	name = "Toggle Lock"
	expected_target_type = /obj/structure/closet

/decl/interaction_handler/closet_lock_toggle/is_possible(atom/target, mob/user)
	. = ..()
	if(.)
		var/obj/structure/closet/C = target
		. = !C.opened && (C.setup & CLOSET_HAS_LOCK)
	
/decl/interaction_handler/closet_lock_toggle/invoked(atom/target, mob/user)
	var/obj/structure/closet/C = target
	C.togglelock(user)
