/obj/item/storage/pill_bottle/antitox
	name = "pill bottle (antitoxins)"
	desc = "Contains pills used to counter toxins."
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/antitox/WillContain()
	return list(/obj/item/chems/pill/antitox = 21)

/obj/item/storage/pill_bottle/brute_meds
	name = "pill bottle (styptic)"
	desc = "Contains pills used to stabilize the severely injured."
	wrapper_color = COLOR_MAROON

/obj/item/storage/pill_bottle/brute_meds/WillContain()
	return list(/obj/item/chems/pill/brute_meds = 21)

/obj/item/storage/pill_bottle/oxygen
	name = "pill bottle (oxygen)"
	desc = "Contains pills used to treat oxygen deprivation."
	wrapper_color = COLOR_LIGHT_CYAN

/obj/item/storage/pill_bottle/oxygen/WillContain()
	return list(/obj/item/chems/pill/oxygen = 21)

/obj/item/storage/pill_bottle/antitoxins
	name = "pill bottle (antitoxins)"
	desc = "Contains pills used to treat toxic substances in the blood."
	wrapper_color = COLOR_GREEN

/obj/item/storage/pill_bottle/antitoxins/WillContain()
	return list(/obj/item/chems/pill/antitoxins = 21)

/obj/item/storage/pill_bottle/stabilizer
	name = "pill bottle (stabilizer)"
	desc = "Contains pills used to stabilize patients."
	wrapper_color = COLOR_PALE_BLUE_GRAY

/obj/item/storage/pill_bottle/stabilizer/WillContain()
	return list(/obj/item/chems/pill/stabilizer = 21)

/obj/item/storage/pill_bottle/burn_meds
	name = "pill bottle (synthskin)"
	desc = "Contains pills used to treat burns."
	wrapper_color = COLOR_SUN

/obj/item/storage/pill_bottle/burn_meds/WillContain()
	return list(/obj/item/chems/pill/burn_meds = 21)

/obj/item/storage/pill_bottle/antibiotics
	name = "pill bottle (antibiotics)"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	wrapper_color = COLOR_PALE_GREEN_GRAY

/obj/item/storage/pill_bottle/antibiotics/WillContain()
	return list(/obj/item/chems/pill/antibiotics = 14)

/obj/item/storage/pill_bottle/painkillers
	name = "pill bottle (painkillers)"
	desc = "Contains pills used to relieve pain."
	wrapper_color = COLOR_PURPLE_GRAY

/obj/item/storage/pill_bottle/painkillers/WillContain()
	return list(/obj/item/chems/pill/painkillers = 14)

//Baycode specific Psychiatry pills.
/obj/item/storage/pill_bottle/antidepressants
	name = "pill bottle (antidepressants)"
	desc = "Mild antidepressant. For use in individuals suffering from depression or anxiety. 15u dose per pill."
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/antidepressants/WillContain()
	return list(/obj/item/chems/pill/antidepressants = 21)

/obj/item/storage/pill_bottle/stimulants
	name = "pill bottle (stimulants)"
	desc = "Mental stimulant. For use in individuals suffering from ADHD, or general concentration issues. 15u dose per pill."
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/stimulants/WillContain()
	return list(/obj/item/chems/pill/stimulants = 21)

/obj/item/storage/pill_bottle/assorted
	name = "pill bottle (assorted)"
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
