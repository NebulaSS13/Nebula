#define MOB_BREATH_DELAY 2
/mob/living/should_breathe()
	return ((life_tick % MOB_BREATH_DELAY) == 0 || failed_last_breath || is_asystole())
