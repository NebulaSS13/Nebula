/mob/living/simple_animal/hostile/aquatic
	icon = 'icons/mob/simple_animal/fish_content.dmi'
	meat_type = /obj/item/chems/food/fish
	turns_per_move = 5
	natural_weapon = /obj/item/natural_weapon/bite
	speed = 4
	mob_size = MOB_SIZE_MEDIUM
	emote_see = list("gnashes")
	base_animal_type = /mob/living/simple_animal/aquatic // used for language, ignore actual type

	// They only really care if there's water around them or not.
	max_gas = list()
	min_gas = list()
	minbodytemp = 0

/mob/living/simple_animal/hostile/aquatic/Life()
	if(!submerged())
		walk(src, 0)
		SET_STATUS_MAX(src, STAT_PARA, 3)
	. = ..()
	update_icon()

/mob/living/simple_animal/hostile/aquatic/on_update_icon()
	. = ..()
	if(stat != DEAD && HAS_STATUS(src, STAT_PARA))
		icon_state += "-dying"

/mob/living/simple_animal/hostile/aquatic/handle_atmos(var/atmos_suitable = 1)
	. = ..(atmos_suitable = submerged())

/mob/living/simple_animal/hostile/aquatic/can_act()
	. = ..() && submerged()
