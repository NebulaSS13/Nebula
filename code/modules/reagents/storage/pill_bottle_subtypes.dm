/obj/item/storage/pill_bottle/antitox
	labeled_name = "antitoxins"
	desc = "Contains pills used to counter toxins."
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/antitox/WillContain()
	return list(/obj/item/chems/pill/antitox = 21)

/obj/item/storage/pill_bottle/brute_meds
	labeled_name = "styptic"
	desc = "Contains pills used to stabilize the severely injured."
	wrapper_color = COLOR_MAROON

/obj/item/storage/pill_bottle/brute_meds/WillContain()
	return list(/obj/item/chems/pill/brute_meds = 21)

/obj/item/storage/pill_bottle/oxygen
	labeled_name = "oxygen"
	desc = "Contains pills used to treat oxygen deprivation."
	wrapper_color = COLOR_LIGHT_CYAN

/obj/item/storage/pill_bottle/oxygen/WillContain()
	return list(/obj/item/chems/pill/oxygen = 21)

/obj/item/storage/pill_bottle/antitoxins
	labeled_name = "antitoxins"
	desc = "Contains pills used to treat toxic substances in the blood."
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/antitoxins/WillContain()
	return list(/obj/item/chems/pill/antitoxins = 21)

/obj/item/storage/pill_bottle/stabilizer
	labeled_name = "stabilizer"
	desc = "Contains pills used to stabilize patients."
	wrapper_color = COLOR_PALE_BLUE_GRAY

/obj/item/storage/pill_bottle/stabilizer/WillContain()
	return list(/obj/item/chems/pill/stabilizer = 21)

/obj/item/storage/pill_bottle/burn_meds
	labeled_name = "synthskin"
	desc = "Contains pills used to treat burns."
	wrapper_color = COLOR_SUN

/obj/item/storage/pill_bottle/burn_meds/WillContain()
	return list(/obj/item/chems/pill/burn_meds = 21)

/obj/item/storage/pill_bottle/antibiotics
	labeled_name = "antibiotics"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	wrapper_color = COLOR_PALE_GREEN_GRAY

/obj/item/storage/pill_bottle/antibiotics/WillContain()
	return list(/obj/item/chems/pill/antibiotics = 14)

/obj/item/storage/pill_bottle/painkillers
	labeled_name = "painkillers"
	desc = "Contains pills used to relieve pain."
	wrapper_color = COLOR_PURPLE_GRAY

/obj/item/storage/pill_bottle/painkillers/WillContain()
	return list(/obj/item/chems/pill/painkillers = 14)

/obj/item/storage/pill_bottle/strong_painkillers
	name = "pill bottle (strong painkillers)"
	desc = "Contains pills used to relieve pain. Do not mix with alcohol consumption."
	wrapper_color = COLOR_PURPLE_GRAY

/obj/item/storage/pill_bottle/strong_painkillers/WillContain()
	return list(/obj/item/chems/pill/strong_painkillers = 14)

//Baycode specific Psychiatry pills.
/obj/item/storage/pill_bottle/antidepressants
	labeled_name = "antidepressants"
	desc = "Mild antidepressant. For use in individuals suffering from depression or anxiety. 15u dose per pill."
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/antidepressants/WillContain()
	return list(/obj/item/chems/pill/antidepressants = 21)

/obj/item/storage/pill_bottle/stimulants
	labeled_name = "stimulants"
	desc = "Mental stimulant. For use in individuals suffering from ADHD, or general concentration issues. 15u dose per pill."
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/stimulants/WillContain()
	return list(/obj/item/chems/pill/stimulants = 21)

/obj/item/storage/pill_bottle/assorted
	labeled_name = "assorted"
	desc = "Commonly found on paramedics, these assorted pill bottles contain all the basics."

/obj/item/storage/pill_bottle/assorted/WillContain()
	return list(
			/obj/item/chems/pill/stabilizer = 6,
			/obj/item/chems/pill/antitoxins = 6,
			/obj/item/chems/pill/sugariron = 2,
			/obj/item/chems/pill/painkillers = 2,
			/obj/item/chems/pill/oxygen = 2,
			/obj/item/chems/pill/burn_meds = 2,
			/obj/item/chems/pill/antirads
		)
