/obj/item/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items/handcuffs.dmi'
	icon_state = ICON_STATE_WORLD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	throw_speed = 2
	throw_range = 5
	origin_tech = @'{"materials":1}'
	material = /decl/material/solid/metal/steel
	max_health = ITEM_HEALTH_NO_DAMAGE //#TODO: Once we can work out something different for handling cuff breakout, change this. Since it relies on cuffs health to tell if you can actually breakout.
	var/elastic
	var/dispenser = 0
	var/breakouttime = 2 MINUTES //Deciseconds = 120s = 2 minutes
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'
	var/cuff_type = "handcuffs"

/obj/item/handcuffs/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/resistable/handcuffs)

/obj/item/handcuffs/Destroy()
	var/obj/item/clothing/shoes/attached_shoes = loc
	if(istype(attached_shoes))
		attached_shoes.remove_cuffs()
	. = ..()

/obj/item/handcuffs/physically_destroyed(skip_qdel)
	if(istype(loc, /obj/item/clothing/shoes))
		loc.visible_message(SPAN_WARNING("\The [src] attached to \the [loc] snap and fall away!"), range = 1)
	. = ..()

/obj/item/handcuffs/examine(mob/user)
	. = ..()
	if (current_health > 0 && get_max_health() > 0)
		var display = get_percent_health()
		if (display > 66)
			return
		to_chat(user, SPAN_WARNING("They look [display < 33 ? "badly ": ""]damaged."))

/obj/item/handcuffs/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)

	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS))
		return ..()

	if (user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))
		to_chat(user, SPAN_WARNING("You can't figure out how to work \the [src]..."))
		place_handcuffs(user, user)
		return TRUE

	// only humans can be cuffed for now
	if(ishuman(target))
		var/mob/living/human/H = target
		if(!H.get_equipped_item(slot_handcuffed_str))
			if (H == user)
				place_handcuffs(user, user)
				return TRUE

			//check for an aggressive grab (or robutts)
			if(H.has_danger_grab(user))
				place_handcuffs(H, user)
			else
				to_chat(user, SPAN_WARNING("You need to have a firm grip on \the [H] before you can put \the [src] on!"))
		else
			to_chat(user, SPAN_WARNING("\The [H] is already handcuffed!"))
		return TRUE

	return ..()

/obj/item/handcuffs/proc/place_handcuffs(var/mob/living/target, var/mob/user)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	var/mob/living/human/H = target
	if(!istype(H))
		return 0

	if (!H.has_organ_for_slot(slot_handcuffed_str))
		to_chat(user, SPAN_WARNING("\The [H] needs at least two wrists before you can cuff them together!"))
		return 0

	var/obj/item/gloves = H.get_equipped_item(slot_gloves_str)
	if((gloves && (gloves.item_flags & ITEM_FLAG_NOCUFFS)) && !elastic)
		to_chat(user, SPAN_WARNING("\The [src] won't fit around \the [gloves]!"))
		return 0

	user.visible_message(SPAN_DANGER("\The [user] is attempting to put [cuff_type] on \the [H]!"))

	if(!do_after(user,30, target))
		return 0

	if(!target.has_danger_grab(user)) // victim may have resisted out of the grab in the meantime
		return 0

	var/obj/item/handcuffs/cuffs = src
	if(dispenser)
		cuffs = new(get_turf(user))
	else if(!user.try_unequip(cuffs))
		return 0

	admin_attack_log(user, H, "Attempted to handcuff the victim", "Was target of an attempted handcuff", "attempted to handcuff")
	SSstatistics.add_field_details("handcuffs","H")

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(H)

	user.visible_message("<span class='danger'>\The [user] has put [cuff_type] on \the [H]!</span>")

	// Apply cuffs.
	target.equip_to_slot(cuffs, slot_handcuffed_str)
	return 1

/obj/item/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon = 'icons/obj/items/handcuffs_cable.dmi'
	breakouttime = 300 //Deciseconds = 30s
	cuff_sound = 'sound/weapons/cablecuff.ogg'
	cuff_type = "cable restraints"
	elastic = 1
	max_health = 75
	material = /decl/material/solid/organic/plastic

/obj/item/handcuffs/cable/red
	color = COLOR_MAROON

/obj/item/handcuffs/cable/yellow
	color = COLOR_AMBER

/obj/item/handcuffs/cable/blue
	color = COLOR_CYAN_BLUE

/obj/item/handcuffs/cable/green
	color = COLOR_GREEN

/obj/item/handcuffs/cable/pink
	color = COLOR_PURPLE

/obj/item/handcuffs/cable/orange
	color = COLOR_ORANGE

/obj/item/handcuffs/cable/cyan
	color = COLOR_SKY_BLUE

/obj/item/handcuffs/cable/white
	color = COLOR_SILVER

/obj/item/handcuffs/cyborg
	dispenser = 1

/obj/item/handcuffs/cable/tape
	name = "tape restraints"
	desc = "DIY!"
	icon_state = "tape_cross"
	item_state = null
	icon = 'icons/obj/bureaucracy.dmi'
	breakouttime = 200
	cuff_type = "duct tape"
	max_health = 50
	material = /decl/material/solid/organic/plastic
