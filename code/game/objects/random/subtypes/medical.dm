/obj/random/medical
	name = "Random Medical equipment"
	desc = "This is a random medical item."
	icon = 'icons/obj/items/random_spawn.dmi'
	icon_state = "medrandom"

/obj/random/medical/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/medical/lite                 = 21,
		/obj/item/bodybag                        =  2,
		/obj/item/chems/glass/bottle/stabilizer  =  2,
		/obj/item/chems/glass/bottle/antitoxin   =  2,
		/obj/item/pill_bottle                    =  2,
		/obj/item/pill_bottle/painkillers        =  2,
		/obj/item/pill_bottle/strong_painkillers =  1,
		/obj/item/pill_bottle/antidepressants    =  2,
		/obj/item/pill_bottle/oxygen             =  1,
		/obj/item/pill_bottle/burn_meds          =  1,
		/obj/item/pill_bottle/brute_meds         =  1,
		/obj/item/chems/syringe/antitoxin        =  2,
		/obj/item/chems/syringe/antibiotic       =  1,
		/obj/item/chems/syringe/stabilizer       =  2,
		/obj/item/box/freezer                    =  1,
		/obj/item/stack/nanopaste                =  1
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
		/obj/item/stack/medical/bandage               = 4,
		/obj/item/stack/medical/ointment                  = 4,
		/obj/item/pill_bottle/antibiotics                 = 2,
		/obj/item/pill_bottle/painkillers                 = 2,
		/obj/item/pill_bottle/strong_painkillers          = 1,
		/obj/item/stack/medical/bandage/advanced      = 2,
		/obj/item/stack/medical/ointment/advanced         = 2,
		/obj/item/stack/medical/splint                    = 1,
		/obj/item/chems/hypospray/autoinjector/stabilizer = 3,
		/obj/item/pill_bottle/burn_meds                   = 2,
		/obj/item/pill_bottle/antitoxins                  = 2,
		/obj/item/med_pouch/trauma                        = 2,
		/obj/item/med_pouch/burn                          = 2,
		/obj/item/med_pouch/toxin                         = 2,
		/obj/item/med_pouch/radiation                     = 2,
		/obj/item/med_pouch/oxyloss                       = 2
	)
	return spawnable_choices

/obj/random/medical/pillbottle
	name = "Random Pill Bottle"
	desc = "This is a random pill bottle."

/obj/random/medical/pillbottle/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/pill_bottle/antibiotics,
		/obj/item/pill_bottle/oxygen,
		/obj/item/pill_bottle/brute_meds,
		/obj/item/pill_bottle/sugariron
	)
	return spawnable_choices

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/items/storage/firstaid.dmi'
	icon_state = "firstaid"

/obj/random/firstaid/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/firstaid/regular = 4,
		/obj/item/firstaid/trauma  = 3,
		/obj/item/firstaid/toxin   = 3,
		/obj/item/firstaid/o2      = 3,
		/obj/item/firstaid/stab    = 2,
		/obj/item/firstaid/adv     = 2,
		/obj/item/firstaid/combat  = 1,
		/obj/item/firstaid/empty   = 2,
		/obj/item/firstaid/fire    = 3
	)
	return spawnable_choices
