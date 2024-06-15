/decl/hierarchy/outfit/job/science
	abstract_type = /decl/hierarchy/outfit/job/science
	l_ear = /obj/item/radio/headset/headset_sci
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/color/white
	pda_type = /obj/item/modular_computer/pda/science

/decl/hierarchy/outfit/job/science/rd
	name = "Job - Chief Science Officer"
	l_ear = /obj/item/radio/headset/heads/rd
	pants = /obj/item/clothing/jumpsuit/research_director
	shoes = /obj/item/clothing/shoes/color/brown
	hands = list(/obj/item/clipboard)
	id_type = /obj/item/card/id/science/head
	pda_type = /obj/item/modular_computer/pda/heads

/decl/hierarchy/outfit/job/science/scientist
	name = "Job - Scientist"
	pants = /obj/item/clothing/jumpsuit/white
	id_type = /obj/item/card/id/science
	suit = /obj/item/clothing/suit/toggle/labcoat/science

/decl/hierarchy/outfit/job/science/roboticist
	name = "Job - Roboticist"
	pants = /obj/item/clothing/jumpsuit/white
	shoes = /obj/item/clothing/shoes/color/black
	belt = /obj/item/belt/utility/full
	id_type = /obj/item/card/id/science
	pda_slot = slot_r_store_str
	pda_type = /obj/item/modular_computer/pda/science

/decl/hierarchy/outfit/job/science/roboticist/Initialize()
	. = ..()
	backpack_overrides.Cut()
