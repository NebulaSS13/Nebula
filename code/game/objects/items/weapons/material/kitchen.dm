/obj/item/kitchen
	icon = 'icons/obj/kitchen.dmi'
	material = /decl/material/solid/metal/aluminium
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

 /*
 * Rolling Pins
 */

/obj/item/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	material = /decl/material/solid/organic/wood
	material_force_multiplier = 0.7 // 10 when wielded with weight 15 (wood)
	thrown_material_force_multiplier = 1 // as above

/obj/item/kitchen/rollingpin/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if ((MUTATION_CLUMSY in user.mutations) && prob(50) && user.try_unequip(src))
		to_chat(user, SPAN_DANGER("\The [src] slips out of your hand and hits your head."))
		user.take_damage(10)
		SET_STATUS_MAX(user, STAT_PARA, 2)
		return TRUE
	return ..()
