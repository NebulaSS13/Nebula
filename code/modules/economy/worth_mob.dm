#define MOB_BASE_VALUE 20
/mob/get_base_value()
	. = MOB_BASE_VALUE * mob_size
	if(stat != DEAD)
		. *= 1.5
	. = max(round(.), mob_size)

/mob/living/carbon/human/get_base_value()
	. = round(..() * species.rarity_value)
#undef MOB_BASE_VALUE
