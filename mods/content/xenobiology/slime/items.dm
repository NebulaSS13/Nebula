/obj/item/slime_extract
	name = "slime core extract"
	desc = "Goo extracted from a slime. Legends claim these to have \"magical powers\"."
	icon = 'mods/content/xenobiology/icons/slimes/slime_extract.dmi'
	icon_state = ICON_STATE_WORLD
	force = 1.0
	w_class = ITEM_SIZE_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6
	origin_tech = "{'biotech':4}"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	material = /decl/material/liquid/slimejelly
	var/slime_type = /decl/slime_colour/grey
	var/Uses = 1 // uses before it goes inert
	var/enhanced = 0 //has it been enhanced before?

/obj/item/slime_extract/get_base_value()
	. = ..() * Uses

/obj/item/slime_extract/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/slime_extract_enhancer))
		if(enhanced == 1)
			to_chat(user, "<span class='warning'> This extract has already been enhanced!</span>")
			return ..()
		if(Uses == 0)
			to_chat(user, "<span class='warning'> You can't enhance a used extract!</span>")
			return ..()
		to_chat(user, "You apply the enhancer. It now has triple the amount of uses.")
		Uses = 3
		enhanced = 1
		qdel(O)
		return TRUE
	. = ..()

/obj/item/slime_extract/Initialize(var/ml, var/material, var/_stype = /decl/slime_colour/grey)
	. = ..(ml, material)
	slime_type = _stype
	if(!ispath(slime_type, /decl/slime_colour))
		PRINT_STACK_TRACE("Slime extract initialized with non-decl slime colour: [slime_type || "NULL"].")
	SSstatistics.extracted_slime_cores_amount++
	initialize_reagents()
	update_icon()

/obj/item/slime_extract/initialize_reagents(populate)
	create_reagents(100)
	. = ..()

/obj/item/slime_extract/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/slimejelly, 30)

/obj/item/slime_extract/on_reagent_change()
	. = ..()
	if(reagents?.total_volume)
		var/decl/slime_colour/slime_data = GET_DECL(slime_type)
		slime_data.handle_reaction(reagents)

/obj/item/slime_extract/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	var/decl/slime_colour/slime_data = GET_DECL(slime_type)
	icon = slime_data.extract_icon

/obj/effect/golemrune
	anchored = 1
	desc = "a strange rune used to create golems. It glows when it can be activated."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	unacidable = 1
	layer = RUNE_LAYER

/obj/effect/golemrune/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/golemrune/Process()
	var/mob/observer/ghost/ghost
	for(var/mob/observer/ghost/O in src.loc)
		if(!O.client || (O.mind && O.mind.current && O.mind.current.stat != DEAD))
			continue
		ghost = O
		break
	if(ghost)
		icon_state = "golem2"
	else
		icon_state = "golem"

/obj/effect/golemrune/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	var/mob/observer/ghost/ghost
	for(var/mob/observer/ghost/O in src.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break
	if(!ghost)
		to_chat(user, SPAN_WARNING("The rune fizzles uselessly."))
		return TRUE
	visible_message(SPAN_WARNING("A craggy humanoid figure coalesces into being!"))

	var/mob/living/carbon/human/G = new(src.loc)
	G.set_species(SPECIES_GOLEM)
	G.key = ghost.key

	var/obj/item/implant/translator/natural/I = new()
	I.implant_in_mob(G, BP_HEAD)
	if (user.languages.len)
		var/decl/language/lang = user.languages[1]
		G.add_language(lang.name)
		G.set_default_language(lang)
		I.languages[lang.name] = 1

	to_chat(G, FONT_LARGE(SPAN_BOLD("You are a golem. Serve [user] and assist them at any cost.")))
	to_chat(G, SPAN_ITALIC("You move slowly and are vulnerable to trauma, but are resistant to heat and cold."))
	qdel(src)
	return TRUE

/obj/effect/golemrune/proc/announce_to_ghosts()
	for(var/mob/observer/ghost/G in global.player_list)
		if(G.client)
			var/area/A = get_area(src)
			if(A)
				to_chat(G, "Golem rune created in [A.proper_name].")

