/obj/structure/diona_gestalt/attackby(var/obj/item/thing, var/mob/user)
	. = ..()
	if(thing.force) 
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/hitby()
	..()
	shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/bullet_act(var/obj/item/projectile/P, var/def_zone)
	. = ..()
	if(P && (P.damage_type == BRUTE || P.damage_type == BURN))
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	var/shed_count = rand(1,3)
	while(shed_count && nymphs && nymphs.len)
		shed_count--
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/proc/handle_member_click(var/mob/living/carbon/alien/diona/clicker)
	return
