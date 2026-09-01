/obj/random/unidentified_medicine
	name = "unidentified medicine"
	desc = "This will make a random hypo."
	icon = /obj/item/chems/hypospray/autoinjector::icon
	icon_state = /obj/item/chems/hypospray/autoinjector::icon_state

/obj/random/unidentified_medicine/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/hypospray/autoinjector/clonemed/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/brute/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/burn/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/toxin/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/oxy/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/purity/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/pain/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/clotting/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/combat/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/stimm/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/gleam/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/expired/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/psychotropics/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/hallucinogenics/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/soporific/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/cyanide/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/psychotropics/unidentified,
		/obj/item/chems/hypospray/autoinjector/large/mutagen/unidentified
	)
	return spawnable_choices

/obj/random/unidentified_medicine/old_medicine/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/hypospray/autoinjector/large/brute/unidentified   = 5,
		/obj/item/chems/hypospray/autoinjector/large/burn/unidentified    = 5,
		/obj/item/chems/hypospray/autoinjector/large/toxin/unidentified   = 5,
		/obj/item/chems/hypospray/autoinjector/large/oxy/unidentified     = 5,
		/obj/item/chems/hypospray/autoinjector/large/purity/unidentified  = 5,
		/obj/item/chems/hypospray/autoinjector/large/pain/unidentified    = 5,
		/obj/item/chems/hypospray/autoinjector/large/expired/unidentified = 65
	)
	return spawnable_choices

/obj/random/unidentified_medicine/fresh_medicine/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/hypospray/autoinjector/clonemed/unidentified       = 5,
		/obj/item/chems/hypospray/autoinjector/large/brute/unidentified    = 10,
		/obj/item/chems/hypospray/autoinjector/large/burn/unidentified     = 10,
		/obj/item/chems/hypospray/autoinjector/large/toxin/unidentified    = 10,
		/obj/item/chems/hypospray/autoinjector/large/oxy/unidentified      = 10,
		/obj/item/chems/hypospray/autoinjector/large/purity/unidentified   = 10,
		/obj/item/chems/hypospray/autoinjector/large/pain/unidentified     = 10,
		/obj/item/chems/hypospray/autoinjector/large/clotting/unidentified = 5,
		/obj/item/chems/hypospray/autoinjector/large/expired/unidentified  = 25
	)
	return spawnable_choices

/obj/random/unidentified_medicine/combat_medicine/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/hypospray/autoinjector/clonemed/unidentified        = 5,
		/obj/item/chems/hypospray/autoinjector/large/brute/unidentified     = 5,
		/obj/item/chems/hypospray/autoinjector/large/burn/unidentified      = 5,
		/obj/item/chems/hypospray/autoinjector/large/pain/unidentified      = 5,
		/obj/item/chems/hypospray/autoinjector/large/clotting/unidentified  = 10,
		/obj/item/chems/hypospray/autoinjector/large/combat/unidentified    = 30,
		/obj/item/chems/hypospray/autoinjector/large/soporific/unidentified = 10,
		/obj/item/chems/hypospray/autoinjector/large/cyanide/unidentified   = 30
	)
	return spawnable_choices

/obj/random/unidentified_medicine/drug_den/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/hypospray/autoinjector/clonemed/unidentified              = 5,
		/obj/item/chems/hypospray/autoinjector/large/pain/unidentified            = 10,
		/obj/item/chems/hypospray/autoinjector/large/clotting/unidentified        = 5,
		/obj/item/chems/hypospray/autoinjector/large/combat/unidentified          = 40,
		/obj/item/chems/hypospray/autoinjector/large/stimm/unidentified           = 20,
		/obj/item/chems/hypospray/autoinjector/large/gleam/unidentified           = 20,
		/obj/item/chems/hypospray/autoinjector/large/psychotropics/unidentified   = 20,
		/obj/item/chems/hypospray/autoinjector/large/hallucinogenics/unidentified = 20,
		/obj/item/chems/hypospray/autoinjector/large/soporific/unidentified       = 20,
		/obj/item/chems/hypospray/autoinjector/large/psychotropics/unidentified   = 10,
		/obj/item/chems/hypospray/autoinjector/large/cyanide/unidentified         = 5
	)
	return spawnable_choices

/obj/random/unidentified_medicine/scientific/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/hypospray/autoinjector/clonemed/unidentified       = 5,
		/obj/item/chems/hypospray/autoinjector/large/clotting/unidentified = 10,
		/obj/item/chems/hypospray/autoinjector/large/combat/unidentified   = 10,
		/obj/item/chems/hypospray/autoinjector/large/cyanide/unidentified  = 10,
		/obj/item/chems/hypospray/autoinjector/large/mutagen/unidentified  = 10,
	)
	return spawnable_choices

/obj/random/unidentified_medicine/viral/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/chems/hypospray/autoinjector/large/purity/unidentified  = 30,
		/obj/item/chems/hypospray/autoinjector/large/expired/unidentified = 40,
		/obj/item/chems/hypospray/autoinjector/large/mutagen/unidentified = 10
	)
	return spawnable_choices
