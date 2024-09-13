var/global/list/_intolerances_by_flag = list()
/proc/get_intolerances_by_flag(allergen_flags, ingestion_method)

	var/flag_key
	if(ingestion_method)
		flag_key = "[allergen_flags]-[ingestion_method]"
	else
		flag_key = num2text(allergen_flags)

	. = global._intolerances_by_flag[flag_key]
	if(isnull(.))
		. = list()
		for(var/decl/trait/malus/intolerance/allergy in decls_repository.get_decls_of_type_unassociated(/decl/trait/malus/intolerance))
			if((!ingestion_method || (ingestion_method in allergy.ingested_types)) && (allergy.allergen_flags & allergen_flags))
				. += allergy
		global._intolerances_by_flag[flag_key] = .

/decl/trait/malus/intolerance
	abstract_type = /decl/trait/malus/intolerance
	levels = list(TRAIT_LEVEL_MINOR, TRAIT_LEVEL_MAJOR)
	var/list/ingested_types = list(CHEM_INGEST)
	var/allergen_flags = ALLERGEN_NONE

/decl/trait/malus/intolerance/protein
	name = "Protein Intolerance"
	description = "You are allergic to or intolerant of animal protein in any form, and can become very ill if you ingest it."
	allergen_flags = (ALLERGEN_MEAT | ALLERGEN_FISH | ALLERGEN_DAIRY | ALLERGEN_EGG)
	uid = "trait_allergy_protein"

/decl/trait/malus/intolerance/meat
	name = "Meat Intolerance"
	description = "You are allergic or intolerant of red and white meat, and can become very ill if you ingest it."
	allergen_flags = ALLERGEN_MEAT | ALLERGEN_FISH
	uid = "trait_allergy_meat"

/decl/trait/malus/intolerance/fish
	name = "Fish Intolerance"
	description = "You are allergic to or intolerant of fish meat, and can become very ill if you ingest it."
	allergen_flags = ALLERGEN_FISH
	uid = "trait_allergy_fish"

/decl/trait/malus/intolerance/vegetable
	name = "Vegetable Intolerance"
	description = "You are allergic to or intolerant of vegetables, and can become very ill if you ingest them."
	allergen_flags = ALLERGEN_VEGETABLE
	uid = "trait_allergy_vegetable"

/decl/trait/malus/intolerance/dairy
	name = "Dairy Intolerance"
	description = "You are allergic to or intolerant of milk solids or lactose - essentially dairy in any form - and can become very ill if you ingest it."
	allergen_flags = ALLERGEN_DAIRY
	uid = "trait_allergy_dairy"

/decl/trait/malus/intolerance/egg
	name = "Egg Intolerance"
	description = "You are allergic to or intolerant of eggs, and can become very ill if you ingest them."
	allergen_flags = ALLERGEN_EGG
	uid = "trait_allergy_egg"

/decl/trait/malus/intolerance/fruit
	name = "Fruit Intolerance"
	description = "You are allergic to or intolerant of fruit, and can become very ill if you ingest it."
	allergen_flags = ALLERGEN_FRUIT
	uid = "trait_allergy_fruit"

/decl/trait/malus/intolerance/gluten
	name = "Gluten Intolerance"
	description = "You are allergic to or intolerant of gluten, and can become very ill if you ingest it."
	allergen_flags = ALLERGEN_GLUTEN
	uid = "trait_allergy_gluten"

/decl/trait/malus/intolerance/soy
	name = "Soy Intolerance"
	description = "You are allergic to or intolerant of soy protein, and can become very ill if you ingest it."
	allergen_flags = ALLERGEN_SOY
	uid = "trait_allergy_soy"

/decl/trait/malus/intolerance/caffeine
	name = "Caffeine Intolerance"
	description = "You are allergic to or intolerant of caffeine, and can become very ill if you ingest it."
	allergen_flags = ALLERGEN_CAFFEINE
	uid = "trait_allergy_caffeine"

/decl/trait/malus/intolerance/fungi
	name = "Mushroom Intolerance"
	description = "You are allergic to or intolerant of mushrooms and fungi, and can become very ill if you ingest them."
	allergen_flags = ALLERGEN_FUNGI
	uid = "trait_allergy_fungi"

/decl/trait/malus/intolerance/nuts
	name = "Nut Intolerance"
	description = "You are allergic to or intolerant of nuts, and can become very ill if you ingest them."
	allergen_flags = ALLERGEN_NUTS
	uid = "trait_allergy_nuts"

/decl/trait/malus/intolerance/stimulant
	name = "Caffeine Intolerance"
	description = "You are allergic to or intolerant of caffeine, and can become very ill if you ingest it."
	allergen_flags = ALLERGEN_CAFFEINE
	uid = "trait_allergy_caffeine"

/decl/trait/malus/intolerance/stimulant
	name = "Stimulant Intolerance"
	description = "You are allergic to or intolerant of stimulants, and can become very ill if you ingest them."
	allergen_flags = ALLERGEN_STIMULANT | ALLERGEN_CAFFEINE
	uid = "trait_allergy_stimulant"
