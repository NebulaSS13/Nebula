/obj/item/stack/material/rods
	name                 = "rod"
	desc                 = "Some rods. Can be used for building, or something."
	singular_name        = "rod"
	plural_name          = "rods"
	icon_state           = "rod"
	plural_icon_state    = "rod-mult"
	max_icon_state       = "rod-max"
	w_class              = ITEM_SIZE_LARGE
	attack_cooldown      = 21
	melee_accuracy_bonus = -20
	throw_speed          = 5
	throw_range          = 20
	max_amount           = 100
	attack_verb          = list("hit", "bludgeoned", "whacked")
	lock_picking_level   = 3
	matter_multiplier    = 0.3
	material             = /decl/material/solid/metal/steel
	crafting_stack_type  = /obj/item/stack/material/rods
	pickup_sound         = 'sound/foley/tooldrop3.ogg'
	drop_sound           = 'sound/foley/tooldrop2.ogg'

/obj/item/stack/material/rods/get_autopsy_descriptors()
	. = ..()
	. += "narrow"

/obj/item/stack/material/rods/cyborg
	name                 = "metal rod synthesizer"
	desc                 = "A device that makes metal rods."
	gender               = NEUTER
	matter               = null
	uses_charge          = 1
	charge_costs         = list(500)
	max_health           = ITEM_HEALTH_NO_DAMAGE

/obj/item/stack/material/rods/Initialize()
	. = ..()
	update_icon()
	set_extension(src, /datum/extension/tool, list(TOOL_SURGICAL_DRILL = TOOL_QUALITY_WORST))

/obj/item/stack/material/rods/update_state_from_amount()
	if(max_icon_state && amount > 0.5*max_amount)
		icon_state = max_icon_state
	else if(plural_icon_state && amount >= 2)
		icon_state = plural_icon_state
	else
		icon_state = base_state

// TODO: slapcrafting recipes to replace this block.
/obj/item/stack/material/rods/attackby(obj/item/used_item, mob/user)

	if(IS_WELDER(used_item))
		var/obj/item/weldingtool/welder = used_item

		if(!can_use(2))
			to_chat(user, SPAN_WARNING("You need at least two rods to do this."))
			return TRUE

		if(welder.weld(0,user))
			visible_message(SPAN_NOTICE("\The [src] is fused together by \the [user] with \the [welder]."), 3, SPAN_NOTICE("You hear welding."), 2)
			for(var/obj/item/stack/material/new_item in SSmaterials.create_object((material?.type || /decl/material/solid/metal/steel), usr.loc, 1))
				new_item.add_to_stacks(usr)
				if(user.is_holding_offhand(src))
					user.put_in_hands(new_item)
			use(2)
		return TRUE

	if (istype(used_item, /obj/item/stack/tape_roll/duct_tape))
		var/obj/item/stack/tape_roll/duct_tape/T = used_item
		if(!T.can_use(4))
			to_chat(user, SPAN_WARNING("You need 4 [T.plural_name] to make a splint!"))
			return TRUE
		T.use(4)

		var/obj/item/stack/medical/splint/improvised/new_splint = new(user.loc)
		new_splint.dropInto(loc)
		new_splint.add_fingerprint(user)
		playsound(user, 'sound/effects/tape.ogg', 50, TRUE)
		user.visible_message(SPAN_NOTICE("\The [user] constructs \a [new_splint] out of a [singular_name]."), \
				SPAN_NOTICE("You use make \a [new_splint] out of a [singular_name]."))
		src.use(1)
		return TRUE
	return ..()
