/obj/structure/diona_gestalt/attackby(var/obj/item/thing, var/mob/user)
	. = ..()
	if(thing.get_attack_force(user))
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/hitby()
	. = ..()
	if(.)
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/bullet_act(var/obj/item/projectile/P, var/def_zone)
	. = ..()
	if(P && (P.atom_damage_type == BRUTE || P.atom_damage_type == BURN))
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	var/shed_count = rand(1,3)
	while(shed_count && nymphs && nymphs.len)
		shed_count--
		shed_atom(forcefully = TRUE)

/obj/structure/diona_gestalt/proc/handle_member_click(var/mob/living/simple_animal/alien/diona/clicker)
	return FALSE
