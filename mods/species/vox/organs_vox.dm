//vox got different organs within. This will also help with regular surgeons knowing the organs within an alien as alien as vox.
/obj/item/organ/internal/heart/vox
	icon_state = "vox heart"
	dead_icon = null
	parent_organ = BP_GROIN

/obj/item/organ/internal/lungs/vox
	name = "air capillary sack" //Like birds, Vox absorb gas via air capillaries.
	icon_state = "vox lung"

/obj/item/organ/internal/kidneys/vox
	name = "filtration bladder"
	icon_state = "lungs" //wow are vox kidneys fat.
	color = "#99ccff"
	parent_organ = BP_CHEST

/obj/item/organ/internal/liver/vox
	name = "waste tract"
	parent_organ = BP_CHEST
	color = "#0033cc"

/obj/item/organ/internal/eyes/vox
	color = "#0033cc"

/obj/item/organ/internal/stomach/vox
	name = "gizzard"
	color = "#0033cc"
	var/static/list/gains_nutriment_from_inedible_reagents = list(
		/decl/material/solid/organic/wood          = 3,
		/decl/material/liquid/cleaner              = 1,
		/decl/material/liquid/foaming_agent        = 1,
		/decl/material/liquid/surfactant           = 1,
		/decl/material/liquid/paint                = 1
	)
	var/static/list/can_digest_matter = list(
		/decl/material/solid/organic/wood          = TRUE,
		/decl/material/solid/organic/wood/mahogany = TRUE,
		/decl/material/solid/organic/wood/maple    = TRUE,
		/decl/material/solid/organic/wood/ebony    = TRUE,
		/decl/material/solid/organic/wood/walnut   = TRUE,
		/decl/material/solid/organic/leather       = TRUE,
		/decl/material/solid/organic/plastic       = TRUE,
		/decl/material/solid/organic/cardboard     = TRUE,
		/decl/material/solid/organic/paper         = TRUE,
		/decl/material/solid/organic/cloth         = TRUE,
		/decl/material/solid/slag                  = TRUE,
		/decl/material/solid/sodiumchloride        = TRUE
	)
	var/static/list/can_process_matter = list(
		/decl/material/solid/glass                 = TRUE,
		/decl/material/solid/gemstone/diamond      = TRUE,
		/decl/material/solid/stone/sandstone       = TRUE,
		/decl/material/solid/stone/marble          = TRUE,
		/decl/material/solid/metal/steel           = TRUE,
		/decl/material/solid/metal/gold            = TRUE,
		/decl/material/solid/metal/silver          = TRUE,
		/decl/material/solid/metal/uranium         = TRUE,
		/decl/material/solid/metal/iron            = TRUE,
		/decl/material/solid/metal/platinum        = TRUE,
		/decl/material/solid/metal/bronze          = TRUE,
		/decl/material/solid/metal/titanium        = TRUE,
		/decl/material/solid/metal/osmium          = TRUE,
		/decl/material/solid/metal/copper          = TRUE,
		/decl/material/solid/metal/aluminium       = TRUE,
		/decl/material/solid/sand                  = TRUE,
		/decl/material/solid/clay                  = TRUE,
		/decl/material/solid/graphite              = TRUE,
		/decl/material/solid/pitchblende           = TRUE,
		/decl/material/solid/hematite              = TRUE,
		/decl/material/solid/quartz                = TRUE,
		/decl/material/solid/pyrite                = TRUE,
		/decl/material/solid/spodumene             = TRUE,
		/decl/material/solid/cinnabar              = TRUE,
		/decl/material/solid/phosphorite           = TRUE,
		/decl/material/solid/potash                = TRUE,
		/decl/material/solid/bauxite               = TRUE,
		/decl/material/solid/rutile                = TRUE
	)
	var/list/stored_matter = list()

/obj/item/organ/internal/stomach/vox/Process()
	. = ..()
	if(is_usable())

		// Handle some post-metabolism reagent processing for generally inedible foods.
		if(ingested.total_volume > 0)
			for(var/rtype in ingested.reagent_volumes)
				var/decl/material/R = GET_DECL(rtype)
				var/inedible_nutriment_amount = gains_nutriment_from_inedible_reagents[R]
				if(inedible_nutriment_amount > 0)
					owner.adjust_nutrition(inedible_nutriment_amount)

		// Do we have any objects to digest?
		var/list/check_materials
		var/updated_stacks
		for(var/obj/item/food in contents)
			for(var/mat in food.matter)
				if(!can_digest_matter[mat] && !can_process_matter[mat])
					continue

				// Grab a chunk out of the object.
				var/digested = min(food.matter[mat], rand(200,500))
				food.matter[mat] -= digested
				digested *= 0.75
				if(food.matter[mat] <= 0)
					food.matter -= mat
				if(!food.matter.len)
					qdel(food)

				// Process it.
				if(can_digest_matter[mat])
					owner.adjust_nutrition(max(1, floor(digested/100)))
					updated_stacks = TRUE
				else if(can_process_matter[mat])
					LAZYDISTINCTADD(check_materials, mat)
					stored_matter[mat] += digested

		// Convert stored matter into sheets.
		for(var/mat in check_materials)
			var/decl/material/M = GET_DECL(mat)
			if(M && stored_matter[mat] >= SHEET_MATERIAL_AMOUNT)

				// Remove as many sheets as possible from the gizzard.
				var/sheets = floor(stored_matter[mat]/SHEET_MATERIAL_AMOUNT)
				stored_matter[mat] -= SHEET_MATERIAL_AMOUNT * sheets
				if(stored_matter[mat] <= 0)
					stored_matter -= mat

				// Merge them into other stacks.
				for(var/obj/item/stack/material/mat_stack in contents)
					if(mat_stack.material == M && mat_stack.amount < mat_stack.max_amount)
						var/taking_sheets = min(sheets, mat_stack.get_max_amount() - mat_stack.amount)
						mat_stack.add(taking_sheets)
						sheets -= taking_sheets
						updated_stacks = TRUE

				// Create new stacks if needed.
				if(sheets)
					M.create_object(src, sheets)
					updated_stacks = TRUE

		if(updated_stacks && prob(5))
			to_chat(owner, SPAN_NOTICE("Your [name] churns as it digests some material into a usable form."))

/obj/item/organ/internal/hindtongue
	name = "hindtongue"
	desc = "Some kind of severed bird tongue."
	parent_organ = BP_HEAD
	icon_state = "hindtongue"
	organ_tag = BP_HINDTONGUE

/obj/item/organ/internal/voxstack
	name = "cortical stack"
	parent_organ = BP_HEAD
	icon_state = "cortical-stack"
	organ_tag = BP_STACK
	organ_properties = ORGAN_PROP_PROSTHETIC
	origin_tech = @'{"biotech":4,"materials":4,"magnets":2,"programming":3}'
	relative_size = 10

	var/stored_ckey
	var/default_language
	var/list/languages = list()
	var/datum/mind/backup
	var/prompting = FALSE // Are we waiting for a user prompt?

/obj/item/organ/internal/voxstack/Initialize(mapload, material_key, datum/mob_snapshot/supplied_appearance, decl/bodytype/new_bodytype)
	var/decl/species/dna_species = supplied_appearance && supplied_appearance.root_species
	. = ..(mapload, material_key, supplied_appearance, dna_species?.base_internal_prosthetics_model)
	do_backup()

/obj/item/organ/internal/voxstack/examine(mob/user)
	. = ..()

	var/user_vox = user.get_species_name() == SPECIES_VOX // TODO use bodytype flags instead so subspecies are included
	if (istype(backup))
		var/owner_viable = find_dead_player(stored_ckey, TRUE)
		if (user_vox)
			to_chat(user, SPAN_NOTICE("The integrity light on [src] blinks [owner_viable ? "rapidly. It can be implanted." : "slowly. It is dormant."]"))
		else
			to_chat(user, SPAN_NOTICE("A light on [src] blinks [owner_viable ? "rapidly" : "slowly"]."))
	else if (user_vox)
		to_chat(user, SPAN_NOTICE("The integrity light on [src] is off. It is empty and lifeless."))

/obj/item/organ/internal/voxstack/emp_act()
	return

/obj/item/organ/internal/voxstack/getToxLoss()
	return 0

/obj/item/organ/internal/voxstack/proc/do_backup()
	if(owner && owner.stat != DEAD && !is_broken() && owner.mind)
		languages = owner.languages.Copy()
		backup = owner.mind
		default_language = owner.default_language
		if(owner.ckey)
			stored_ckey = owner.ckey

/obj/item/organ/internal/voxstack/proc/backup_inviable()
	return 	(!istype(backup) || backup == owner.mind || (backup.current && backup.current.stat != DEAD))

/obj/item/organ/internal/voxstack/on_add_effects()
	. = ..()
	if(prompting) // Don't spam the player with twenty dialogs because someone doesn't know what they're doing or panicking.
		return FALSE
	//Need spawn here so that this interactive bit doesn't lock up init
	if(owner && !backup_inviable())
		prompt_revive_callback(owner)
	return TRUE

/obj/item/organ/internal/voxstack/proc/prompt_revive_callback(var/mob/living/target)
	set waitfor = FALSE
	if(istype(target) && !backup_inviable())
		prompting = TRUE
		var/response = alert(find_dead_player(stored_ckey, 1), "Your neural backup has been placed into a new body. Do you wish to return to life as the mind of [backup.name]?", "Resleeving", "Yes", "No")
		prompting = FALSE
		if(src && response == "Yes" && owner == target)
			overwrite()
	sleep(-1)
	do_backup()

/obj/item/organ/internal/voxstack/on_remove_effects(mob/living/last_owner)
	var/obj/item/organ/external/head = GET_EXTERNAL_ORGAN(last_owner, parent_organ)
	last_owner.visible_message(SPAN_DANGER("\The [src] rips gaping holes in \the [last_owner]'s [head.name] as it is torn loose!"))
	head.take_external_damage(rand(15,20))
	for(var/obj/item/organ/internal/O in head.contents)
		O.take_internal_damage(rand(30,70))
	do_backup()
	..()

/obj/item/organ/internal/voxstack/proc/overwrite()
	if(owner.mind && owner.ckey) //Someone is already in this body!
		if(owner.mind == backup) // Oh, it's the same mind in the backup. Someone must've spammed the 'Start Procedure' button in a panic.
			return
		owner.visible_message(SPAN_DANGER("\The [owner] spasms violently!"))
		if(prob(66))
			to_chat(owner, SPAN_DANGER("You fight off the invading tendrils of another mind, holding onto your own body!"))
			return
		owner.ghostize()
	backup.active = 1
	backup.transfer_to(owner)
	if (default_language)
		owner.default_language = default_language
	owner.languages = languages.Copy()
	to_chat(owner, SPAN_NOTICE("Consciousness slowly creeps over you as your new body awakens."))

/obj/item/organ/external/groin/vox //vox have an extended ribcage for extra protection.
	encased = "lower ribcage"
