/obj/item/projectile/drake_spit
	name = "drake spittle"
	icon_state = "ice_1"
	nodamage = TRUE
	damage = 0
	embed = 0
	atom_damage_type = BRUTE
	muzzle_type = null
	stun = 3
	weaken = 3
	eyeblur = 5
	fire_sound = 'mods/species/drakes/sounds/drake_spit.ogg'
	material = /decl/material/liquid/sifsap

/obj/item/projectile/drake_spit/on_hit(atom/target, blocked, def_zone)
	// Stun is needed to effectively hunt simplemobs, but it's OP against humans.
	var/apply_confuse = 0
	var/mob/living/human/victim = target
	if(istype(victim))
		apply_confuse = max(stun, weaken)
		stun = 0
		weaken = 0
	. = ..()
	if(. && apply_confuse && !blocked)
		SET_STATUS_MAX(victim, STAT_CONFUSE, apply_confuse)

/obj/item/projectile/drake_spit/weak
	stun = 1
	weaken = 1
	eyeblur = 2
	fire_sound = 'mods/species/drakes/sounds/hatchling_spit.ogg'
