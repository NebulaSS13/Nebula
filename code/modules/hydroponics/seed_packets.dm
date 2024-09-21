//Seed packet object/procs.
/obj/item/seeds
	name = "packet of seeds"
	icon = 'icons/obj/seeds/seed_packets.dmi'
	icon_state = "seedy"
	w_class = ITEM_SIZE_SMALL
	abstract_type = /obj/item/seeds
	max_health = 10 //Can't set a material, otherwise extracting seeds would generate free materials
	material = /decl/material/solid/organic/plantmatter/pith

	var/seed_mask_icon = 'icons/obj/seeds/seed_masks.dmi'
	var/seed_base_name = "packet"
	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize(loc, material, _seed)
	if(isnull(seed) && !isnull(_seed))
		seed = _seed
	update_seed()
	initialize_reagents()
	. = ..()

/obj/item/seeds/initialize_reagents()
	create_reagents(3)
	. = ..()

/obj/item/seeds/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/plant_oil, 3)

/obj/item/seeds/get_single_monetary_worth()
	. = seed ? seed.get_monetary_value() : ..()

// Used for extracts/seed sampling purposes.
/obj/item/seeds/modified
	is_spawnable_type = FALSE

//Grabs the appropriate seed datum from the global list.
/obj/item/seeds/proc/update_seed()
	if(istext(seed) && SSplants.seeds[seed])
		seed = SSplants.seeds[seed]
	if(seed && !istype(seed))
		PRINT_STACK_TRACE("Seed packet was supplied invalid seed name '[seed]'!")
		seed = null
	if(seed?.scannable_result)
		set_extension(src, /datum/extension/scannable, seed.scannable_result)
	else if(has_extension(src, /datum/extension/scannable))
		remove_extension(src, /datum/extension/scannable)
	update_icon()

/obj/item/seeds/proc/get_seed_packet_state()
	return seed?.get_trait(TRAIT_PRODUCT_ICON)

//Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/on_update_icon()
	. = ..()
	if(!seed)
		return

	// Update icon.
	underlays.Cut()
	icon_state = get_seed_packet_state() || "unknown"
	color = seed.get_trait(TRAIT_PRODUCT_COLOUR)

	var/static/list/seed_nouns = list(
		SEED_NOUN_SEEDS,
		SEED_NOUN_PITS,
		SEED_NOUN_NODES
	)
	var/is_seeds = (seed.seed_noun in seed_nouns)
	if(seed_mask_icon)
		if(is_seeds)
			underlays += overlay_image(seed_mask_icon, "seed-mask", seed.get_trait(TRAIT_PLANT_COLOUR), RESET_COLOR)
		else
			add_overlay(overlay_image(seed_mask_icon, "spore-mask", null, RESET_COLOR))
	update_strings(is_seeds)

/obj/item/seeds/proc/update_strings(is_seeds)
	if(is_seeds)
		SetName("[seed_base_name] of [seed.product_name] [seed.seed_noun]")
		desc = "It has a picture of \a [seed.display_name] on the front."
	else
		SetName("sample of [seed.product_name] [seed.seed_noun]")
		desc = "It's labelled as coming from \a [seed.display_name]."

/obj/item/seeds/examine(mob/user)
	. = ..()
	if(seed && !seed.roundstart)
		to_chat(user, "It's tagged as variety #[seed.uid].")

/obj/item/seeds/extracted
	name = "handful of seeds"
	desc = "A handful of nondescript seeds."
	icon = 'icons/obj/seeds/seed_raw.dmi'
	icon_state = "seeds"
	seed_base_name = "handful"
	seed_mask_icon = null
	is_spawnable_type = FALSE

/obj/item/seeds/extracted/get_seed_packet_state()
	return seed.seed_noun

/obj/item/seeds/extracted/update_strings(is_seeds)
	if(is_seeds)
		SetName("[seed_base_name] of [seed.display_name] [seed.seed_noun]")
	else
		SetName("sample of [seed.display_name] [seed.seed_noun]")

/obj/item/seeds/extracted/cutting
	name = "cuttings"
	desc = "Some plant cuttings."

/obj/item/seeds/extracted/cutting/get_seed_packet_state()
	return SEED_NOUN_CUTTINGS

/obj/item/seeds/extracted/cutting/update_strings(is_seeds)
	SetName("[seed_base_name] of [seed.display_name] cuttings")

/obj/item/seeds/random
	seed = null

/obj/item/seeds/random/Initialize()
	seed = SSplants.create_random_seed()
	. = ..()

/obj/item/seeds/chiliseed
	seed = "chili"

/obj/item/seeds/plastiseed
	seed = "plastic"

/obj/item/seeds/grapeseed
	seed = "grapes"

/obj/item/seeds/greengrapeseed
	seed = "greengrapes"

/obj/item/seeds/peanutseed
	seed = "peanut"

/obj/item/seeds/cabbageseed
	seed = "cabbage"

/obj/item/seeds/shandseed
	seed = "shand"

/obj/item/seeds/mtearseed
	seed = "mtear"

/obj/item/seeds/berryseed
	seed = "berries"

/obj/item/seeds/blueberryseed
	seed = "blueberries"

/obj/item/seeds/glowberryseed
	seed = "glowberries"

/obj/item/seeds/bananaseed
	seed = "banana"

/obj/item/seeds/eggplantseed
	seed = "eggplant"

/obj/item/seeds/bloodtomatoseed
	seed = "bloodtomato"

/obj/item/seeds/tomatoseed
	seed = "tomato"

/obj/item/seeds/killertomatoseed
	seed = "killertomato"

/obj/item/seeds/bluetomatoseed
	seed = "bluetomato"

/obj/item/seeds/quantumatoseed
	seed = "quantumato"

/obj/item/seeds/cornseed
	seed = "corn"

/obj/item/seeds/poppyseed
	seed = "poppies"

/obj/item/seeds/potatoseed
	seed = "potato"

/obj/item/seeds/icepepperseed
	seed = "icechili"

/obj/item/seeds/soyaseed
	seed = "soybeans"

/obj/item/seeds/wheatseed
	seed = "wheat"

/obj/item/seeds/riceseed
	seed = "rice"

/obj/item/seeds/carrotseed
	seed = "carrot"

/obj/item/seeds/reishimycelium
	seed = "reishi"

/obj/item/seeds/amanitamycelium
	seed = "amanita"

/obj/item/seeds/angelmycelium
	seed = "destroyingangel"

/obj/item/seeds/libertymycelium
	seed = "libertycap"

/obj/item/seeds/chantermycelium
	seed = "mushrooms"

/obj/item/seeds/towercap
	seed = "towercap"

/obj/item/seeds/glowbell
	seed = "glowbell"

/obj/item/seeds/plumpmycelium
	seed = "plumphelmet"

/obj/item/seeds/walkingmushroommycelium
	seed = "walkingmushroom"

/obj/item/seeds/nettleseed
	seed = "nettle"

/obj/item/seeds/deathnettleseed
	seed = "deathnettle"

/obj/item/seeds/weeds
	seed = "weeds"

/obj/item/seeds/harebell
	seed = "harebells"

/obj/item/seeds/sunflowerseed
	seed = "sunflowers"

/obj/item/seeds/lavenderseed
	seed = "lavender"

/obj/item/seeds/brownmold
	seed = "mold"

/obj/item/seeds/appleseed
	seed = "apple"

/obj/item/seeds/poisonedappleseed
	seed = "poisonapple"

/obj/item/seeds/goldappleseed
	seed = "goldapple"

/obj/item/seeds/ambrosiavulgarisseed
	seed = "ambrosiavulgaris"

/obj/item/seeds/ambrosiadeusseed
	seed = "ambrosiadeus"

/obj/item/seeds/whitebeetseed
	seed = "whitebeet"

/obj/item/seeds/sugarcaneseed
	seed = "sugarcane"

/obj/item/seeds/watermelonseed
	seed = "watermelon"

/obj/item/seeds/pumpkinseed
	seed = "pumpkin"

/obj/item/seeds/limeseed
	seed = "lime"

/obj/item/seeds/lemonseed
	seed = "lemon"

/obj/item/seeds/orangeseed
	seed = "orange"

/obj/item/seeds/poisonberryseed
	seed = "poisonberries"

/obj/item/seeds/deathberryseed
	seed = "deathberries"

/obj/item/seeds/grassseed
	seed = "grass"

/obj/item/seeds/cocoapodseed
	seed = "cocoa"

/obj/item/seeds/cherryseed
	seed = "cherry"

/obj/item/seeds/tobaccoseed
	seed = "tobacco"

/obj/item/seeds/finetobaccoseed
	seed = "finetobacco"

/obj/item/seeds/puretobaccoseed
	seed = "puretobacco"

/obj/item/seeds/kudzuseed
	seed = "kudzu"

/obj/item/seeds/peppercornseed
	seed = "peppercorn"

/obj/item/seeds/garlicseed
	seed = "garlic"

/obj/item/seeds/onionseed
	seed = "onion"

/obj/item/seeds/algaeseed
	seed = "algae"

/obj/item/seeds/bamboo
	seed = "bamboo"

/obj/item/seeds/clam
	seed = "clam"

/obj/item/seeds/barnacle
	seed = "barnacle"

/obj/item/seeds/mollusc
	seed = "mollusc"

/obj/item/seeds/cotton
	seed = "cotton"

/obj/item/seeds/flax
	seed = "flax"

/obj/item/seeds/hemp
	seed = "hemp"

/obj/item/seeds/yarrow
	seed = "yarrow"

/obj/item/seeds/aloe
	seed = "aloe"

/obj/item/seeds/ginseng
	seed = "ginseng"

/obj/item/seeds/valerian
	seed = "valerian"

/obj/item/seeds/foxglove
	seed = "foxglove"

/obj/item/seeds/extracted/yarrow
	seed = "yarrow"

/obj/item/seeds/extracted/aloe
	seed = "aloe"

/obj/item/seeds/extracted/ginseng
	seed = "ginseng"

/obj/item/seeds/extracted/valerian
	seed = "valerian"

/obj/item/seeds/extracted/foxglove
	seed = "foxglove"

/obj/item/seeds/extracted/cabbage
	seed = "cabbage"

/obj/item/seeds/extracted/carrot
	seed = "carrot"

/obj/item/seeds/extracted/potato
	seed = "potato"

/obj/item/seeds/extracted/wheat
	seed = "wheat"

/obj/item/seeds/extracted/rice
	seed = "rice"
