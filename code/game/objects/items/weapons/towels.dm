/obj/item/towel
	name = "towel"
	desc = "A soft cotton towel."
	icon = 'icons/obj/items/towel.dmi'
	icon_state = ICON_STATE_WORLD
	item_flags = ITEM_FLAG_IS_BELT
	slot_flags = SLOT_HEAD | SLOT_LOWER_BODY | SLOT_OVER_BODY
	_base_attack_force = 1
	w_class = ITEM_SIZE_NORMAL
	attack_verb = "whipped"
	hitsound = 'sound/weapons/towelwhip.ogg'
	material = /decl/material/solid/organic/cloth
	material_alteration = MAT_FLAG_ALTERATION_ALL
	/// Are we currently laying flat on the ground, or are we rolled up?
	var/laid_out = FALSE
	/// A string added to the end of the material description, e.g. "used to dry yourself off". Optional, used by doormats.
	var/additional_description

/obj/item/towel/Initialize()
	chem_volume = round(50 * (w_class / ITEM_SIZE_NORMAL)) // larger towels have more room, smaller ones have less
	. = ..()

/obj/item/towel/Destroy()
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

// Does not rely on ATOM_IS_OPEN_CONTAINER because we want to be able to pour in but not out.
/obj/item/towel/can_be_poured_into(atom/source)
	return (reagents?.maximum_volume > 0)

/obj/item/towel/proc/update_material_description()
	if(!istype(material) || !(material_alteration & MAT_FLAG_ALTERATION_DESC))
		return
	var/is_soft = material.hardness < (MAT_VALUE_RIGID + MAT_VALUE_FLEXIBLE) / 2 // if we're closer to being flexible than rigid, we're considered soft
	// todo: 'roughness' var to go along with hardness? sand is soft but rough, and maybe some sort of future plastic or rubber is hard but lush
	// would this have any use aside from fluff strings? sandpaper grit maybe?
	desc = "A [is_soft ? "soft" : "rugged"] [material.adjective_name] [base_name][additional_description ? " [additional_description]" : null]." // 'a soft cotton towel' by default. also supports 'a rugged leather doormat used to blah blah' etc

/obj/item/towel/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(reagents?.total_volume && distance <= 1)
		var/liquid_adjective = "damp"
		switch(reagents.total_volume / reagents.maximum_volume)
			if(0 to 0.1)
				return // not enough to even bother worrying about
			if(0.4 to 0.6)
				liquid_adjective = "wet"
			if(0.6 to 0.8)
				liquid_adjective = "drenched"
			if(0.8 to 1)
				liquid_adjective = "soaked through"
			if(1)
				liquid_adjective = "entirely saturated"
		. += "It is [liquid_adjective] with [reagents.get_coated_name()]."

/obj/item/towel/set_material(new_material)
	. = ..()
	if(istype(material))
		update_material_description()

// Slowly dry out.
/obj/item/towel/Process()
	if(reagents?.total_volume)
		reagents.remove_any(max(MINIMUM_CHEMICAL_VOLUME, CHEMS_QUANTIZE(reagents.total_volume * 0.05)))
	if(!reagents?.total_volume)
		return PROCESS_KILL

/obj/item/towel/update_name()
	if(reagents?.total_volume)
		if(!REAGENTS_FREE_SPACE(reagents))
			name_prefix = "waterlogged"
		else
			name_prefix = "damp"
	else
		name_prefix = null
	return ..()

/obj/item/towel/on_reagent_change()
	if(!(. = ..()))
		return
	update_name()
	if(reagents?.total_volume)
		if(!is_processing)
			START_PROCESSING(SSobj, src)
	else if(is_processing)
		STOP_PROCESSING(SSobj, src)

/obj/item/towel/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(!user.check_intent(I_FLAG_HARM) && dry_mob(target, user))
		return TRUE
	return ..()

/obj/item/towel/proc/dry_mob(mob/living/target, mob/living/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/reagent_space = reagents.maximum_volume - reagents.total_volume
	if(reagent_space <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is too saturated to dry [user == target ? "yourself" : "\the [target]"] off effectively."))
	else
		var/decl/pronouns/pronouns = target.get_pronouns()
		var/datum/reagents/touching_reagents = target.get_contact_reagents()
		if(!touching_reagents?.total_volume)
			to_chat(user, SPAN_WARNING("[user == target ? "You are" : "\The [target] [pronouns.is]"] already dry."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] uses \the [src] to towel [user == target ? pronouns.self : "\the [target]"] dry."))
			touching_reagents.trans_to(src, min(touching_reagents.total_volume, reagent_space))
			playsound(user, 'sound/weapons/towelwipe.ogg', 25, 1)
	return TRUE

/obj/item/towel/attack_self(mob/user)
	if(user.check_intent(I_FLAG_GRAB))
		lay_out(user)
		return TRUE
	if(!user.check_intent(I_FLAG_HARM))
		return use_on_mob(user, user)
	return ..()

/obj/item/towel/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(laid_out)
		icon_state = "[ICON_STATE_WORLD]-flat" // 'inventory-flat' is nonsensical

// walking on a towel gets it dirty, so watch your step
// this is a good thing for doormats though.
/obj/item/towel/Crossed(atom/movable/crosser)
	. = ..()
	if(!isliving(crosser))
		return
	var/mob/living/crossy_mob = crosser
	var/list/obj/item/targets = crossy_mob.get_walking_contaminant_targets()
	if(!LAZYLEN(targets) || !REAGENTS_FREE_SPACE(reagents))
		return
	// i didn't wanna use process() to make it so that you can stand on it longer to clean your feet more
	// and clicking on it picks it up, so i went with this overcomplicated garbage instead!
	// basically: your move intent (creeping, walking, running) determines how much is cleaned
	// if you walk slowly you'll always get totally cleaned
	var/variability = 20 // by default cleans 80-120% (clamped 0-100) of reagents when walking normally
	if(MOVING_DELIBERATELY(crossy_mob)) // always 100% cleaned when moving slowly
		variability = 0
	else if(MOVING_QUICKLY(crossy_mob))
		variability = 70 // 30-170%, clamped to be 30-100%
	for(var/obj/item/target in targets)
		var/datum/reagents/target_coating = target.coating
		if(!target_coating?.total_volume)
			continue
		var/fraction_cleaned = clamp(CHEMS_QUANTIZE(rand(100 - variability, 100 + variability) / 100), 0, 100)
		target.transfer_coating_to(src, fraction_cleaned * target_coating.total_volume)
		if(!REAGENTS_FREE_SPACE(reagents))
			break

/obj/item/towel/random/Initialize()
	. = ..()
	set_color(get_random_colour())

/obj/item/towel/gold
	paint_color = "#ffd700"

/obj/item/towel/red
	paint_color = "#ff0000"

/obj/item/towel/purple
	paint_color = "#800080"

/obj/item/towel/cyan
	paint_color = "#00ffff"

/obj/item/towel/orange
	paint_color = "#ff8c00"

/obj/item/towel/pink
	paint_color = "#ff6666"

/obj/item/towel/light_blue
	paint_color = "#3fc0ea"

/obj/item/towel/black
	paint_color = "#222222"

/obj/item/towel/brown
	paint_color = "#854636"

/obj/item/towel/fleece // loot from the king of goats. it's a golden towel
	name = "fleece" // sets its name to 'golden fleece' due to material
	desc = "The legendary Golden Fleece of Jason made real."
	_base_attack_force = 1
	attack_verb = "smote"
	material = /decl/material/solid/metal/gold

/obj/item/towel/fleece/update_material_description()
	return FALSE

/obj/item/towel/proc/lay_out(mob/user)
	if(laid_out)
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!user.drop_from_inventory(src))
		return FALSE
	user.visible_message(
		SPAN_NOTICE("[user] lays out \the [src] on the ground."),
		SPAN_NOTICE("You lay out \the [src] on the ground."))
	laid_out = TRUE
	set_dir(user.dir)
	reset_offsets()
	update_icon()
	return TRUE

/obj/item/towel/on_picked_up(mob/user, atom/old_loc)
	..()
	if(laid_out)
		laid_out = FALSE
		reset_offsets(0)
		update_icon()
		user.visible_message(
			SPAN_NOTICE("[user] rolls up \the [src]."),
			SPAN_NOTICE("You pick up and fold \the [src]."))

/obj/item/towel/doormat
	name = "doormat"
	icon = 'icons/obj/items/doormat.dmi'
	w_class = ITEM_SIZE_LARGE
	item_flags = ITEM_FLAG_NO_BLUDGEON // you can't towel whip someone with a doormat, it's too unwieldy
	slot_flags = SLOT_NONE
	additional_description = "used to wipe your feet when entering a building"
	material = /decl/material/solid/organic/skin/fur
	color = /decl/material/solid/organic/skin/fur::color
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/item/towel/doormat/Crossed(atom/movable/crosser)
	var/had_space = REAGENTS_FREE_SPACE(reagents)
	. = ..()
	if(isliving(crosser) && had_space && !REAGENTS_FREE_SPACE(reagents))
		// this sucks, ideally we'd have a 'dirty' or 'wet' overlay to use for it, but i'm no spriter
		visible_message(SPAN_WARNING("\The [src] is completely waterlogged!"))

/// A mapping subtype for a doormat that's already been laid out.
/obj/item/towel/doormat/flat
	laid_out = TRUE
	icon_state = ICON_STATE_WORLD + "-flat"

/obj/item/towel/doormat/flat/Initialize()
	. = ..()
	reset_offsets() // we don't want to overwrite randpixel but we don't want it to have a random offset either