/obj/item/stack/material/rods
	name = "rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "rod"
	plural_name = "rods"
	icon_state = "rod"
	plural_icon_state = "rod-mult"
	max_icon_state = "rod-max"
	w_class = ITEM_SIZE_LARGE
	attack_cooldown = 21
	melee_accuracy_bonus = -20
	throw_speed = 5
	throw_range = 20
	max_amount = 100
	attack_verb = list("hit", "bludgeoned", "whacked")
	lock_picking_level = 3
	matter_multiplier = 0.3
	material = /decl/material/solid/metal/steel

	pickup_sound = 'sound/foley/tooldrop3.ogg'
	drop_sound = 'sound/foley/tooldrop2.ogg'

/obj/item/stack/material/rods/get_autopsy_descriptors()
	. = ..()
	. += "narrow"

/obj/item/stack/material/rods/ten
	amount = 10

/obj/item/stack/material/rods/fifty
	amount = 50

/obj/item/stack/material/rods/cyborg
	name = "metal rod synthesizer"
	desc = "A device that makes metal rods."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)

/obj/item/stack/material/rods/Initialize()
	. = ..()
	update_icon()
	throwforce = round(0.25*material.get_edge_damage())
	force = round(0.5*material.get_blunt_damage())
	set_extension(src, /datum/extension/tool, list(TOOL_DRILL = TOOL_QUALITY_WORST))

/obj/item/stack/material/rods/update_state_from_amount()
	if(max_icon_state && amount > 0.5*max_amount)
		icon_state = max_icon_state
	else if(plural_icon_state && amount >= 2)
		icon_state = plural_icon_state
	else
		icon_state = base_state

/obj/item/stack/material/rods/attackby(obj/item/W, mob/user)
	if(isWelder(W))
		var/obj/item/weldingtool/WT = W

		if(!can_use(2))
			to_chat(user, "<span class='warning'>You need at least two rods to do this.</span>")
			return

		if(WT.remove_fuel(0,user))
			var/obj/item/stack/material/new_item = SSmaterials.create_object((material?.type || /decl/material/solid/metal/steel), usr.loc, 1)
			visible_message(SPAN_NOTICE("\The [src] is fused together by \the [user] with \the [WT]."), 3, SPAN_NOTICE("You hear welding."), 2)
			if(new_item)
				new_item.add_to_stacks(usr)
				if(user.is_holding_offhand(src))
					user.put_in_hands(new_item)
			use(2)
		return

	if (istype(W, /obj/item/tape_roll))
		var/obj/item/stack/medical/splint/ghetto/new_splint = new(user.loc)
		new_splint.dropInto(loc)
		new_splint.add_fingerprint(user)

		user.visible_message("<span class='notice'>\The [user] constructs \a [new_splint] out of a [singular_name].</span>", \
				"<span class='notice'>You use make \a [new_splint] out of a [singular_name].</span>")
		src.use(1)
		return

	..()

/obj/item/stack/material/rods/attack_self(mob/user)
	add_fingerprint(user)
	if(istype(user.loc, /turf))
		place_grille(user, user.loc, src)
