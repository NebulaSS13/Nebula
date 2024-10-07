/obj/item/projectile/ability
	name = "ability"
	// The projectile is functionally a tracer, the ability deals the damage.
	nodamage = TRUE
	penetrating = FALSE

	/// Default; can be set by the ability.
	life_span = 1 SECOND

	var/expended = FALSE
	var/mob/owner
	var/list/ability_metadata
	var/decl/ability/carried_ability

/obj/item/projectile/ability/Destroy()
	owner           = null
	carried_ability = null
	return ..()

/obj/item/projectile/ability/explosion_act()
	SHOULD_CALL_PARENT(FALSE)

/obj/item/projectile/ability/Bump(var/atom/A, forced=0)
	if(loc && carried_ability && !expended)
		carried_ability.apply_effect(owner, A, ability_metadata, src)
	return TRUE

/obj/item/projectile/ability/on_impact(var/atom/A)
	if(loc && carried_ability && !expended)
		carried_ability.apply_effect(owner, A, ability_metadata, src)
	return TRUE
