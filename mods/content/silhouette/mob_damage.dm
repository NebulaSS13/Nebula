/mob/living
	var/obj/effect/silhouette/silhouette

/mob/living/Initialize()
	silhouette = new(src)
	return ..()

/mob/living/Destroy()
	QDEL_NULL(silhouette)
	return ..()

/mob/living/proc/flash_silhouette(flash_time = 2, flash_color = COLOR_WHITE)
	update_appearance_flags(add_flags = KEEP_TOGETHER)
	if(QDELETED(silhouette))
		return
	silhouette.alpha = 255
	silhouette.color = flash_color
	if(!silhouette.is_processing)
		START_PROCESSING(SSfastprocess, silhouette)
	addtimer(CALLBACK(src, PROC_REF(hide_silhouette)), flash_time, (TIMER_OVERRIDE | TIMER_UNIQUE | TIMER_NO_HASH_WAIT))

/mob/living/proc/hide_silhouette()
	update_appearance_flags(remove_flags = KEEP_TOGETHER)
	if(QDELETED(silhouette))
		return
	silhouette.alpha = 0
	if(silhouette.is_processing)
		STOP_PROCESSING(SSfastprocess, silhouette)

/mob/living/proc/flash_damage(damage_type)
	var/flash_color
	switch(damage_type)
		if(BRUTE)
			flash_color = COLOR_RED
		if(BURN)
			flash_color = COLOR_ORANGE
		if(TOX)
			flash_color = COLOR_LIME
		if(CLONE)
			flash_color = COLOR_PURPLE
		if(OXY)
			flash_color = COLOR_BLUE
	if(flash_color)
		flash_silhouette(flash_color = flash_color)

/mob/living/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	. = ..()
	if(damage >= 3)
		flash_damage(damage_type)

// These do not use the standard take_damage() proc so need to be overridden specifically.
/mob/living/human/take_overall_damage(var/brute, var/burn, var/sharp = 0, var/edge = 0, var/used_weapon = null)
	. = ..()
	if(brute >= 3)
		flash_damage(BRUTE)
	else if(burn >= 3)
		flash_damage(BURN)

/mob/living/human/take_organ_damage(var/brute = 0, var/burn = 0, var/bypass_armour = FALSE, var/override_droplimb)
	. = ..()
	if(brute >= 3)
		flash_damage(BRUTE)
	else if(burn >= 3)
		flash_damage(BURN)

/mob/living/silicon/robot/take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/used_weapon = null)
	. = ..()
	if(brute >= 3)
		flash_damage(BRUTE)
	else if(burn >= 3)
		flash_damage(BURN)

/mob/living/silicon/robot/take_organ_damage(var/brute = 0, var/burn = 0, var/bypass_armour = FALSE, var/override_droplimb)
	. = ..()
	if(brute >= 3)
		flash_damage(BRUTE)
	else if(burn >= 3)
		flash_damage(BURN)
