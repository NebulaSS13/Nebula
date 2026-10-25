/datum/job/cynosure/trained_animal
	title = "Trained Drake"
	department_types = list(/decl/department/planetside)
	selection_color  = "#6085a8"
	total_positions  = 2
	spawn_positions  = 1
	supervisors      = "your conscience"
	economic_power   = 1
	access           = list()
	minimal_access   = list()
	outfit_type      = /decl/outfit/trained_drake // Have to have an outfit to pass job validation.
	description      = "A number of the bolder folks in Sif's anomalous region have partially domesticated some of the local wildlife as working animals."
	latejoin_at_spawnpoints = TRUE
	create_record = FALSE
	available_by_default = FALSE
	allowed_ranks = null
	allowed_branches = null
	account_allowed = FALSE
	announced = FALSE

	alt_titles = list(
		/decl/alt_title/explorer_drake,
		/decl/alt_title/wild_drake
	)

/decl/alt_title/explorer_drake
	name = "Expedition Drake"
	desc = "The Cynosure Xenobiology department has spearheaded an effort to train some of the intelligent local wildlife to assist with Exploration field operations."
	outfit = /decl/outfit/trained_drake/explorer

/decl/alt_title/wild_drake
	name = "Wild Drake"
	desc = "Several packs of wild grafadreka have been pushed into the Anomalous Region by changing climate and rough weather, and sometimes come into contact with the locals."
	outfit = /decl/outfit/naked
