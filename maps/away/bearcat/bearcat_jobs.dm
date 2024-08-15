/datum/job/submap/bearcat_captain
	title = "Independant Captain"
	total_positions = 1
	outfit_type = /decl/outfit/job/bearcat/captain
	supervisors = "your bottom line"
	info = "Your ship has suffered a catastrophic amount of damage, leaving it dark and crippled in the depths of \
	unexplored space. The Captain is dead, leaving you, previously the First Mate in charge. Organize what's left of \
	your crew, and maybe you'll be able to survive long enough to be rescued."

/datum/job/submap/bearcat_crewman
	title = "Independant Crewman"
	supervisors = "the Captain"
	total_positions = 3
	outfit_type = /decl/outfit/job/bearcat/crew
	info = "Your ship has suffered a catastrophic amount of damage, leaving it dark and crippled in the depths of \
	unexplored space. Work together with the Acting Captain and what's left of the crew, and maybe you'll be able \
	to survive long enough to be rescued."

/decl/outfit/job/bearcat
	abstract_type = /decl/outfit/job/bearcat
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store_str
	r_pocket = /obj/item/radio
	l_ear = null
	r_ear = null

/decl/outfit/job/bearcat/crew
	name = "Bearcat - Job - FTU Crew"
	id_type = /obj/item/card/id/bearcat

/decl/outfit/job/bearcat/captain
	name = "Bearcat - Job - FTU Captain"
	uniform = /obj/item/clothing/pants/baggy/casual/classicjeans
	shoes = /obj/item/clothing/shoes/color/black
	pda_type = /obj/item/modular_computer/pda/heads/captain
	id_type = /obj/item/card/id/bearcat_captain

/decl/outfit/job/bearcat/captain/post_equip(var/mob/living/human/H)
	..()
	var/obj/item/clothing/uniform = H.get_equipped_item(slot_w_uniform_str)
	if(uniform)
		var/obj/item/clothing/shirt/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			qdel(eyegore)

/obj/abstract/submap_landmark/spawnpoint/captain
	name = "Independant Captain"

/obj/abstract/submap_landmark/spawnpoint/crewman
	name = "Independant Crewman"
