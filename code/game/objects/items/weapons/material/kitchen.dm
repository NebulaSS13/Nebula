 /*
 * Rolling Pins
 */

/obj/item/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/obj/items/rolling_pin.dmi'
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	material = /decl/material/solid/organic/wood/oak
	material_alteration = MAT_FLAG_ALTERATION_ALL
	color = /decl/material/solid/organic/wood/oak::color

/obj/item/rollingpin/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if (user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50) && user.try_unequip(src))
		to_chat(user, SPAN_DANGER("\The [src] slips out of your hand and hits your head."))
		user.take_organ_damage(10)
		SET_STATUS_MAX(user, STAT_PARA, 2)
		return TRUE
	return ..()

/obj/item/kitchen/rollingpin/walnut
	material = /decl/material/solid/organic/wood/walnut
	color = /decl/material/solid/organic/wood/walnut::color