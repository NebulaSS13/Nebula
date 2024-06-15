/decl/hierarchy/outfit/job/service
	l_ear = /obj/item/radio/headset/headset_service
	abstract_type = /decl/hierarchy/outfit/job/service

/decl/hierarchy/outfit/job/service/bartender
	name = "Job - Bartender"
	pants = /obj/item/clothing/pants/formal/black
	uniform = /obj/item/clothing/shirt/button
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/service/chef
	name = "Job - Chef"
	pants = /obj/item/clothing/pants/slacks/white
	uniform = /obj/item/clothing/shirt/button
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/service/gardener
	name = "Job - Gardener"
	pants = /obj/item/clothing/jumpsuit/hydroponics
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/thick/botany
	r_pocket = /obj/item/scanner/plant
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/service/gardener/Initialize()
	. = ..()
	backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/backpack/hydroponics
	backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/backpack/satchel/hyd
	backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/backpack/messenger/hyd

/decl/hierarchy/outfit/job/service/janitor
	name = "Job - Janitor"
	pants = /obj/item/clothing/jumpsuit/janitor
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/librarian
	name     = "Job - Librarian"
	pants    = /obj/item/clothing/pants/slacks/red
	uniform  = /obj/item/clothing/shirt/button/navy_tie
	suit     = /obj/item/clothing/suit/jacket/charcoal
	id_type  = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/obj/item/radio/headset/heads/ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."

/decl/hierarchy/outfit/job/internal_affairs_agent
	name = "Job - Internal affairs agent"
	l_ear = /obj/item/radio/headset/heads/ia
	pants = /obj/item/clothing/pants/slacks/black
	uniform = /obj/item/clothing/shirt/button/black_tie
	suit = /obj/item/clothing/suit/jacket/black
	shoes = /obj/item/clothing/shoes/color/brown
	glasses = /obj/item/clothing/glasses/sunglasses/big
	hands = list(/obj/item/briefcase)
	id_type = /obj/item/card/id/civilian/internal_affairs_agent
	pda_type = /obj/item/modular_computer/pda/heads/paperpusher

/decl/hierarchy/outfit/job/chaplain
	name = "Job - Chaplain"
	pants = /obj/item/clothing/jumpsuit/chaplain
	hands = list(/obj/item/bible)
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda/medical
