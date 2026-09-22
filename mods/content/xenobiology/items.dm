/obj/item/gun/energy/taser/xeno
	name = "xeno taser gun"
	desc = "Straight out of NT's testing laboratories, this small gun is used to subdue non-humanoid xeno life forms. \
	While marketed towards handling slimes, it may be useful for other creatures."
	charge_cost = 120 // Twice as many shots.
	projectile_type = /obj/item/projectile/beam/stun/xeno
	accuracy = 30 // Make it a bit easier to hit the slimes.

/obj/item/projectile/beam/stun/xeno
	nodamage = TRUE
	icon_state = "laser"
	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue
	var/slime_weaken = 4

/obj/item/projectile/beam/stun/xeno/weak //Weaker variant for non-research equipment, turrets, or rapid fire types.
	slime_weaken = 3

/obj/item/projectile/beam/stun/xeno/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(isslime(target) && slime_weaken)
		var/mob/living/victim = target
		SET_STATUS_MAX(victim, STAT_WEAK, slime_weaken)
	return ..()

/obj/item/baton/slime
	name = "slime baton"
	desc = "A modified stun baton designed to stun slimes and other lesser slimy xeno lifeforms for handling."

/obj/item/baton/slime/loaded/Initialize(var/ml, var/material_key, var/loaded_cell_type)
	return ..(ml, material_key, loaded_cell_type = /obj/item/cell/device/high)

/obj/item/baton/slime/apply_baton_effects(mob/living/target, mob/living/user, stun, agony, obj/item/organ/external/affecting, hit_zone)
	if(!isslime(target)) // Add check for prometheans here if added.
		return
	msg_admin_attack("[key_name(user)] stunned [key_name(target)] with \the [src].")
	deductcharge(hitcost)
	SET_STATUS_MAX(target, STAT_WEAK, 5)
