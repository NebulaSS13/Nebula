/decl/outfit/job/service
	l_ear = /obj/item/radio/headset/headset_service
	abstract_type = /decl/outfit/job/service

/decl/outfit/job/service/bartender
	name = "Job - Bartender"
	uniform = /obj/item/clothing/pants/formal/black/outfit
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/decl/outfit/job/service/chef
	name = "Job - Chef"
	uniform = /obj/item/clothing/pants/slacks/outfit_chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/decl/outfit/job/service/gardener
	name = "Job - Gardener"
	uniform = /obj/item/clothing/jumpsuit/hydroponics
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/thick/botany
	r_pocket = /obj/item/scanner/plant
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/decl/outfit/job/service/gardener/Initialize()
	. = ..()
	backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/backpack/hydroponics
	backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/backpack/satchel/hyd
	backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/backpack/messenger/hyd

/decl/outfit/job/service/janitor
	name = "Job - Janitor"
	uniform = /obj/item/clothing/jumpsuit/janitor
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/decl/outfit/job/librarian
	name = "Job - Librarian"
	uniform = /obj/item/clothing/pants/slacks/red/outfit
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda

/obj/item/radio/headset/heads/ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."

/decl/outfit/job/internal_affairs_agent
	name = "Job - Internal affairs agent"
	l_ear = /obj/item/radio/headset/heads/ia
	uniform = /obj/item/clothing/pants/slacks/black/outfit/internal_affairs
	suit = /obj/item/clothing/suit/jacket/black
	shoes = /obj/item/clothing/shoes/color/brown
	glasses = /obj/item/clothing/glasses/sunglasses/big
	hands = list(/obj/item/briefcase)
	id_type = /obj/item/card/id/civilian/internal_affairs_agent
	pda_type = /obj/item/modular_computer/pda/heads/paperpusher

/decl/outfit/job/chaplain
	name = "Job - Chaplain"
	uniform = /obj/item/clothing/jumpsuit/chaplain
	hands = list(/obj/item/bible)
	id_type = /obj/item/card/id/civilian
	pda_type = /obj/item/modular_computer/pda/medical
