/obj/item/stick
	name = "stick"
	desc = "You feel the urge to poke someone with this."
	icon = 'icons/obj/items/stick.dmi'
	icon_state = "stick"
	item_state = "stickmat"
	material_force_multiplier = 0.1
	thrown_material_force_multiplier = 0.1
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/organic/wood
	attack_verb = list("poked", "jabbed")
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/stick/attack_self(mob/user)
	user.visible_message("<span class='warning'>\The [user] snaps [src].</span>", "<span class='warning'>You snap [src].</span>")
	shatter(0)

/obj/item/stick/attackby(obj/item/W, mob/user)

	if(W.sharp && W.edge && !sharp)
		user.visible_message("<span class='warning'>[user] sharpens [src] with [W].</span>", "<span class='warning'>You sharpen [src] using [W].</span>")
		sharp = 1 //Sharpen stick
		SetName("sharpened " + name)
		update_force()
		return TRUE

	if(!sharp && (istype(W, /obj/item/stack/material/bolt) || istype(W, /obj/item/stack/material/bundle)))

		// Ugly way to check for dried grass vs regular grass.
		var/obj/item/stack/material/fuel = W
		if(!fuel.special_crafting_check())
			return ..()

		if(fuel.get_amount() < 5)
			to_chat(user, SPAN_WARNING("You need at least five units of flammable material to create a torch."))
			return TRUE

		var/was_held = loc == user
		if(!was_held || user.try_unequip(src))
			var/obj/item/flame/torch/torch = new(get_turf(src), material?.type, W.material?.type)
			fuel.use(5)
			if(was_held)
				user.put_in_hands(torch)
			to_chat(user, SPAN_NOTICE("You fashion \the [src] into \a [torch]."))
			qdel(src)
		return TRUE

	return ..()

/obj/item/stick/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(user != target && user.a_intent == I_HELP)
		//Playful poking is its own thing
		user.visible_message(
			SPAN_NOTICE("\The [user] pokes \the [target] with \the [src]."),
			SPAN_NOTICE("You poke \the [target] with \the [src].")
		)
		//Consider adding a check to see if target is dead
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(target)
		return TRUE
	return ..()
