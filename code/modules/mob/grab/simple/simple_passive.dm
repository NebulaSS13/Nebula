/datum/grab/simple
	shift =               8
	stop_move =           0
	reverse_facing =      0
	can_absorb =          0
	shield_assailant =    0
	point_blank_mult =    1
	same_tile =           0
	state_name =         SIMPLE_PASSIVE
	fancy_desc =         "holding"
	icon_state =         "reinforce"
	break_chance_table = list(15, 60, 100)

/datum/grab/simple/on_hit_disarm(var/obj/item/grab/normal/G)
	return 0

/datum/grab/simple/on_hit_grab(var/obj/item/grab/normal/G)
	return 0

/datum/grab/simple/on_hit_harm(var/obj/item/grab/normal/G)
	return 0

/datum/grab/simple/resolve_openhand_attack(var/obj/item/grab/G)
	return 0
