/decl/grab/simple
	name = "simple grab"
	shift =               8
	stop_move =           0
	reverse_facing =      0
	shield_assailant =    0
	point_blank_mult =    1
	same_tile =           0
	icon_state =         "reinforce"
	break_chance_table = list(15, 60, 100)

/decl/grab/simple/upgrade(obj/item/grab/G)
	return

/decl/grab/simple/on_hit_disarm(var/obj/item/grab/G, var/atom/A, var/proximity)
	return FALSE

/decl/grab/simple/on_hit_grab(var/obj/item/grab/G, var/atom/A, var/proximity)
	return FALSE

/decl/grab/simple/on_hit_harm(var/obj/item/grab/G, var/atom/A, var/proximity)
	return FALSE

/decl/grab/simple/resolve_openhand_attack(var/obj/item/grab/G)
	return FALSE
