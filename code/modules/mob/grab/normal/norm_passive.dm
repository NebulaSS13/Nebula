/decl/grab/normal/passive
	name = "passive hold"
	upgrab = /decl/grab/normal/struggle
	shift = 8
	stop_move = 0
	reverse_facing = 0
	shield_assailant = 0
	point_blank_mult = 1.1
	same_tile = 0
	icon_state = "reinforce"
	break_chance_table = list(15, 60, 100)

/decl/grab/normal/passive/on_hit_disarm(var/obj/item/grab/G, var/atom/A, var/proximity)
	if(proximity)
		to_chat(G.assailant, SPAN_WARNING("Your grip isn't strong enough to pin."))
	return FALSE

/decl/grab/normal/passive/on_hit_grab(var/obj/item/grab/G, var/atom/A, var/proximity)
	if(proximity)
		to_chat(G.assailant, SPAN_WARNING("Your grip isn't strong enough to jointlock."))
	return FALSE

/decl/grab/normal/passive/on_hit_harm(var/obj/item/grab/G, var/atom/A, var/proximity)
	if(proximity)
		to_chat(G.assailant, SPAN_WARNING("Your grip isn't strong enough to dislocate."))
	return FALSE

/decl/grab/normal/passive/resolve_openhand_attack(var/obj/item/grab/G)
	return FALSE
