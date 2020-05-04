/obj/item/material/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/material/kitchen/utensil
	w_class = ITEM_SIZE_TINY
	thrown_material_force_multiplier = 1
	origin_tech = "{'materials':1}"
	attack_verb = list("attacked", "stabbed", "poked")
	sharp = 0
	edge = 0
	material_force_multiplier = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_material_force_multiplier = 0.1
	material = MAT_ALUMINIUM

	var/loaded      //Descriptive string for currently loaded food object.
	var/scoop_food = 1

/obj/item/material/kitchen/utensil/Initialize()
	. = ..()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	create_reagents(5)

/obj/item/material/kitchen/utensil/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(user.zone_sel.selecting == BP_HEAD || user.zone_sel.selecting == BP_EYES)
			if((MUTATION_CLUMSY in user.mutations) && prob(50))
				M = user
			return eyestab(M,user)
		else
			return ..()

	if (reagents.total_volume > 0)
		reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		if(M == user)
			if(!M.can_eat(loaded))
				return
			M.visible_message("<span class='notice'>\The [user] eats some [loaded] from \the [src].</span>")
		else
			user.visible_message("<span class='warning'>\The [user] begins to feed \the [M]!</span>")
			if(!(M.can_force_feed(user, loaded) && do_mob(user, M, 5 SECONDS)))
				return
			M.visible_message("<span class='notice'>\The [user] feeds some [loaded] to \the [M] with \the [src].</span>")
		playsound(M.loc,'sound/items/eatfood.ogg', rand(10,40), 1)
		overlays.Cut()
		return
	else
		to_chat(user, "<span class='warning'>You don't have anything on \the [src].</span>")//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK
		return

/obj/item/material/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"

/obj/item/material/kitchen/utensil/fork/plastic
	material = MAT_PLASTIC

/obj/item/material/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")
	material_force_multiplier = 0.1 //2 when wielded with weight 20 (steel)

/obj/item/material/kitchen/utensil/spoon/plastic
	material = MAT_PLASTIC

/obj/item/material/kitchen/utensil/spork
	name = "spork"
	desc = "It's a spork. It's much like a fork, but much blunter."
	icon_state = "spork"

/obj/item/material/kitchen/utensil/spork/plastic
	material = MAT_PLASTIC

/obj/item/material/kitchen/utensil/foon
	name = "foon"
	desc = "It's a foon. It's much like a spoon, but much sharper."
	icon_state = "foon"

/obj/item/material/kitchen/utensil/foon/plastic
	material = MAT_PLASTIC

 /*
 * Rolling Pins
 */

/obj/item/material/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	material = MAT_WOOD
	material_force_multiplier = 0.7 // 10 when wielded with weight 15 (wood)
	thrown_material_force_multiplier = 1 // as above

/obj/item/material/kitchen/rollingpin/attack(mob/living/M, mob/living/user)
	if ((MUTATION_CLUMSY in user.mutations) && prob(50) && user.unEquip(src))
		to_chat(user, "<span class='warning'>\The [src] slips out of your hand and hits your head.</span>")
		user.take_organ_damage(10)
		user.Paralyse(2)
		return
	return ..()
