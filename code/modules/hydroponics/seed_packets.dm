var/global/list/plant_seed_sprites = list()

//Seed packet object/procs.
/obj/item/seeds
	name = "packet of seeds"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "seedy"
	w_class = ITEM_SIZE_SMALL
	abstract_type = /obj/item/seeds
	max_health = 10 //Can't set a material, otherwise extracting seeds would generate free materials

	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize(loc, material, _seed)
	if(isnull(seed) && !isnull(_seed))
		seed = _seed
	update_seed()
	. = ..()

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
	update_appearance()

//Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/proc/update_appearance()
	if(!seed) return

	// Update icon.
	overlays.Cut()
	var/is_seeds = ((seed.seed_noun in list(SEED_NOUN_SEEDS, SEED_NOUN_PITS, SEED_NOUN_NODES)) ? 1 : 0)
	var/image/seed_mask
	var/seed_base_key = "base-[is_seeds ? seed.get_trait(TRAIT_PLANT_COLOUR) : "spores"]"
	if(plant_seed_sprites[seed_base_key])
		seed_mask = plant_seed_sprites[seed_base_key]
	else
		seed_mask = image('icons/obj/seeds.dmi',"[is_seeds ? "seed" : "spore"]-mask")
		if(is_seeds) // Spore glass bits aren't coloured.
			seed_mask.color = seed.get_trait(TRAIT_PLANT_COLOUR)
		plant_seed_sprites[seed_base_key] = seed_mask

	var/image/seed_overlay
	var/seed_overlay_key = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-[seed.get_trait(TRAIT_PRODUCT_COLOUR)]"
	if(plant_seed_sprites[seed_overlay_key])
		seed_overlay = plant_seed_sprites[seed_overlay_key]
	else
		seed_overlay = image('icons/obj/seeds.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]")
		seed_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		plant_seed_sprites[seed_overlay_key] = seed_overlay

	overlays |= seed_mask
	overlays |= seed_overlay

	if(is_seeds)
		src.SetName("packet of [seed.seed_name] [seed.seed_noun]")
		src.desc = "It has a picture of \a [seed.display_name] on the front."
	else
		src.SetName("sample of [seed.seed_name] [seed.seed_noun]")
		src.desc = "It's labelled as coming from \a [seed.display_name]."

/obj/item/seeds/examine(mob/user)
	. = ..()
	if(seed && !seed.roundstart)
		to_chat(user, "It's tagged as variety #[seed.uid].")

/obj/item/seeds/cutting
	name = "cuttings"
	desc = "Some plant cuttings."
	is_spawnable_type = FALSE

/obj/item/seeds/cutting/update_appearance()
	..()
	src.SetName("packet of [seed.seed_name] cuttings")

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
	seed = "soybean"

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
