/decl/grab/normal/neck
	name               = "chokehold"
	upgrab             = /decl/grab/normal/kill
	downgrab           = /decl/grab/normal/aggressive
	drop_headbutt      = 0
	shift              = -10
	stop_move          = 1
	reverse_facing     = 1
	shield_assailant   = 1
	point_blank_mult   = 2
	damage_stage       = 2
	same_tile          = 1
	can_throw          = 1
	force_danger       = 1
	restrains          = 1
	grab_icon_state    = "kill"
	break_chance_table = list(3, 18, 45, 100)

/decl/grab/normal/neck/process_effect(var/obj/item/grab/grab)
	var/mob/living/affecting = grab.get_affecting_mob()
	if(!istype(affecting))
		return
	affecting.drop_held_items()
	if(affecting.current_posture.prone)
		SET_STATUS_MAX(affecting, STAT_WEAK, 4)
	affecting.take_damage(1, OXY)
