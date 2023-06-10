/obj/random/medical
	name = "Random Medical equipment"
	desc = "This is a random medical item."
	icon = 'icons/obj/items/random_spawn.dmi'
	icon_state = "medrandom"

/obj/random/medical/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/medical/lite =                        21,
		/obj/item/bodybag =                                2,
		/obj/item/chems/glass/bottle/stabilizer =          2,
		/obj/item/chems/glass/bottle/antitoxin =           2,
		/obj/item/storage/pill_bottle =                    2,
		/obj/item/storage/pill_bottle/painkillers =        2,
		/obj/item/storage/pill_bottle/strong_painkillers = 1,
		/obj/item/storage/pill_bottle/antidepressants =    2,
		/obj/item/storage/pill_bottle/oxygen =             1,
		/obj/item/storage/pill_bottle/burn_meds =          1,
		/obj/item/storage/pill_bottle/brute_meds =         1,
		/obj/item/chems/syringe/antitoxin =                2,
		/obj/item/chems/syringe/antibiotic =               1,
		/obj/item/chems/syringe/stabilizer =               2,
		/obj/item/storage/box/freezer =                    1,
		/obj/item/stack/nanopaste =                        1
	)
	return spawnable_choices

/obj/random/medical/lite
	name = "Random Medicine"
	desc = "This is a random simple medical item."
	icon = 'icons/obj/items/random_spawn.dmi'
	icon_state = "medrandom"
	spawn_nothing_percentage = 25

/obj/random/medical/lite/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/stack/medical/bruise_pack =              4,
		/obj/item/stack/medical/ointment =                 4,
		/obj/item/storage/pill_bottle/antibiotics =        2,
		/obj/item/storage/pill_bottle/painkillers =        2,
		/obj/item/storage/pill_bottle/strong_painkillers = 1,
		/obj/item/stack/medical/advanced/bruise_pack =     2,
		/obj/item/stack/medical/advanced/ointment =        2,
		/obj/item/stack/medical/splint =                   1,
		/obj/item/chems/hypospray/autoinjector =           3,
		/obj/item/storage/pill_bottle/burn_meds =          2,
		/obj/item/storage/pill_bottle/antitox =            2,
		/obj/item/storage/med_pouch/trauma =               2,
		/obj/item/storage/med_pouch/burn =                 2,
		/obj/item/storage/med_pouch/toxin =                2,
		/obj/item/storage/med_pouch/radiation =            2,
		/obj/item/storage/med_pouch/oxyloss =              2
	)
	return spawnable_choices

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/items/storage/firstaid.dmi'
	icon_state = "firstaid"

/obj/random/firstaid/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/storage/firstaid/regular = 4,
		/obj/item/storage/firstaid/trauma =  3,
		/obj/item/storage/firstaid/toxin =   3,
		/obj/item/storage/firstaid/o2 =      3,
		/obj/item/storage/firstaid/stab =    2,
		/obj/item/storage/firstaid/adv =     2,
		/obj/item/storage/firstaid/combat =  1,
		/obj/item/storage/firstaid/empty =   2,
		/obj/item/storage/firstaid/fire =    3
	)
	return spawnable_choices
