/decl/blood_type/octopus
	name = "hemocyanin"
	splatter_colour = "#68a6dd"
	splatter_name =   "hemocyanin"
	splatter_desc =   "It's some hemocyanin. That's not supposed to be there."
	antigens = list("Hc")
	antigen_category = "cephalopod"

/decl/butchery_data/octopus
	meat_type = /obj/item/food/butchery/meat/fish/octopus

/decl/species/octopus
	name = "Octopus"
	uid = "octopus"
	name_plural = "Octopodes"
	description = "Octopus uplifts have been a relatively common sight in aquatic environments since the early days of \
	Sol expansion. The are renowned as excellent engineers, bartenders, and massage therapists."
	available_bodytypes = list(/decl/bodytype/octopus)
	butchery_data = /decl/butchery_data/octopus

	blood_types = list(/decl/blood_type/octopus)
	flesh_color = "#dd7b68"

	species_flags = SPECIES_FLAG_NO_SLIP
	spawn_flags = SPECIES_CAN_JOIN

	species_hud = /datum/hud_data/octopus

	var/list/camo_last_move_by_mob = list()
	var/list/camo_last_alpha_by_mob = list()
	var/const/camo_delay = 10 SECONDS
	var/const/camo_alpha_step = 10
	var/const/camo_min_alpha = 40

/decl/species/octopus/handle_death(var/mob/living/human/H)
	update_mob_alpha(H, 255)

// TODO: either do this without icon ops, or precache the states to
// avoid mob flickering the first time they change camo state.
/decl/species/octopus/proc/update_mob_alpha(var/mob/living/human/H, var/newval = 255)
	if(camo_last_alpha_by_mob[H] == newval)
		return
	camo_last_alpha_by_mob[H] = newval
	var/need_update
	for(var/thing in H.get_external_organs())
		var/obj/item/organ/external/limb = thing
		if(!BP_IS_PROSTHETIC(limb) && limb.species == src && limb.render_alpha != newval)
			limb.render_alpha = newval
			limb.update_icon()
			need_update = TRUE
	if(need_update)
		H.update_body()

/decl/species/octopus/handle_post_spawn(var/mob/living/H)
	. = ..()
	camo_last_alpha_by_mob[H] = 255
	camo_last_move_by_mob[H] = world.time

/decl/species/octopus/handle_post_move(var/mob/living/human/H, exertion = TRUE)
	..()
	camo_last_move_by_mob[H] = world.time
	update_mob_alpha(H, min(camo_last_alpha_by_mob[H] + camo_min_alpha, 255))

/decl/species/octopus/handle_environment_special(var/mob/living/human/H)
	var/last_alpha = camo_last_alpha_by_mob[H]
	if(world.time >= camo_last_move_by_mob[H]+camo_delay && last_alpha > camo_min_alpha)
		update_mob_alpha(H, max(camo_min_alpha, last_alpha-camo_alpha_step))

/datum/hud_data/octopus
	inventory_slots = list(
		/datum/inventory_slot/uniform,
		/datum/inventory_slot/mask,
		/datum/inventory_slot/glasses,
		/datum/inventory_slot/head,
		/datum/inventory_slot/suit_storage,
		/datum/inventory_slot/back,
		/datum/inventory_slot/id,
		/datum/inventory_slot/pocket,
		/datum/inventory_slot/pocket/right,
		/datum/inventory_slot/belt
	)
