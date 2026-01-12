/obj/item/projectile/energy/phase
	name = "phase wave"
	icon_state = "phase"
	fire_sound = 'sound/weapons/Gunshot_phase.ogg'
	range = 6
	damage = 5
	var/animal_bonus_damage = 45	// 50 total on animals

/obj/item/projectile/energy/phase/get_projectile_damage(mob/living/target)
	if(isanimal(target) && !target.isSynthetic())
		return damage + animal_bonus_damage
	return damage

/obj/item/projectile/energy/phase/light
	range = 4
	animal_bonus_damage = 35	// 40 total on animals

/obj/item/projectile/energy/phase/heavy
	range = 8
	animal_bonus_damage = 55	// 60 total on animals

/obj/item/projectile/energy/phase/heavy/cannon
	range = 10
	damage = 15
	animal_bonus_damage = 60	// 75 total on animals

/obj/item/projectile/energy/phase/tranq
	name = "tranquilizer wave"
	range = 10
	damage = 0
	nodamage = TRUE
	animal_bonus_damage = 0
	icon_state = "flight"
	fire_sound = 'sound/weapons/dartgun.ogg'
	fire_sound_vol_silenced = 5
	fire_sound_vol = 15
	var/tranq_delay = 6 SECONDS
	var/tranq_power = 20

/obj/item/projectile/energy/phase/tranq/on_hit(atom/target, blocked, def_zone)
	var/mob/living/victim = target
	// TODO: consider just making this apply a sedative reagent when metabolism is unified.
	if((. = ..()) && tranq_power && isanimal(victim) && !victim.isSynthetic())
		SET_STATUS_MAX(victim, STAT_DROWSY, ceil(tranq_delay / SSmobs.wait))
		addtimer(CALLBACK(victim, TYPE_PROC_REF(/mob/living, apply_delayed_tranq), tranq_power), tranq_delay)

/mob/living/proc/apply_delayed_tranq(tranq_power)
	if(!QDELETED(src) && stat != DEAD && !isSynthetic())
		SET_STATUS_MAX(src, STAT_ASLEEP, tranq_power)

/obj/item/projectile/energy/phase/tranq/weak
	range = 6
	tranq_power = 10
	fire_sound_vol_silenced = 5
	fire_sound_vol = 15
	tranq_delay = 9 SECONDS
