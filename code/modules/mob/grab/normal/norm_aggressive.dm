/decl/grab/normal/aggressive
	name = "aggressive grab"
	upgrab =   /decl/grab/normal/neck
	downgrab = /decl/grab/normal/passive
	shift = 12
	stop_move = 1
	reverse_facing = 0
	shield_assailant = 0
	point_blank_mult = 1.5
	damage_stage = 1
	same_tile = 0
	can_throw = 1
	force_danger = 1
	breakability = 3
	icon_state = "reinforce1"
	break_chance_table = list(5, 20, 40, 80, 100)

/decl/grab/normal/aggressive/process_effect(var/obj/item/grab/G)
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(istype(affecting_mob))
		if(G.target_zone in list(BP_L_HAND, BP_R_HAND))
			affecting_mob.drop_held_items()
		// Keeps those who are on the ground down
		if(affecting_mob.lying)
			SET_STATUS_MAX(affecting_mob, STAT_WEAK, 4)

/decl/grab/normal/aggressive/can_upgrade(var/obj/item/grab/G)
	. = ..()
	if(.)
		if(!ishuman(G.affecting))
			to_chat(G.assailant, SPAN_WARNING("You can only upgrade an aggressive grab when grappling a human!"))
			return FALSE
		if(!(G.target_zone in list(BP_CHEST, BP_HEAD)))
			to_chat(G.assailant, SPAN_WARNING("You need to be grabbing their torso or head for this!"))
			return FALSE
		var/mob/living/carbon/human/affecting_mob = G.get_affecting_mob()
		if(istype(affecting_mob))
			var/obj/item/clothing/C = affecting_mob.get_equipped_item(slot_head_str)
			if(istype(C)) //hardsuit helmets etc
				if((C.max_pressure_protection) && C.armor[ARMOR_MELEE] > 20)
					to_chat(G.assailant, SPAN_WARNING("\The [C] is in the way!"))
					return FALSE
