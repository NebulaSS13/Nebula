/decl/grab/normal/kill
	name                = "strangle"
	downgrab            = /decl/grab/normal/neck
	shift               = 0
	stop_move           = 1
	reverse_facing      = 1
	shield_assailant    = 0
	point_blank_mult    = 2
	damage_stage        = 3
	same_tile           = 1
	force_danger        = 1
	restrains           = 1
	downgrade_on_action = 1
	downgrade_on_move   = 1
	grab_icon_state     = "kill1"
	break_chance_table  = list(5, 20, 40, 80, 100)

/decl/grab/normal/kill/process_effect(var/obj/item/grab/G)
	var/mob/living/affecting = G.get_affecting_mob()
	if(!istype(affecting))
		return
	affecting.drop_held_items()
	if(affecting.lying)
		SET_STATUS_MAX(affecting, STAT_WEAK, 4)
	affecting.take_damage(OXY, 1)
	affecting.apply_effect(STUTTER, 5) //It will hamper your voice, being choked and all.
	SET_STATUS_MAX(affecting, STAT_WEAK, 5)	//Should keep you down unless you get help.
	if(isliving(affecting))
		var/mob/living/M = affecting
		M.ticks_since_last_successful_breath = max(M.ticks_since_last_successful_breath + 2, 3)
