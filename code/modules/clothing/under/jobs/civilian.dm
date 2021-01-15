//Alphabetical order of civilian jobs.

/obj/item/clothing/under/bartender
	desc = "It looks like it could use some more flair."
	name = "bartender's uniform"
	icon = 'icons/clothing/under/uniform_bartender.dmi'

/obj/item/clothing/under/captain //Alright, technically not a 'civilian' but its better then giving a .dm file for a single define.
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	name = "captain's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_captain.dmi'

/obj/item/clothing/under/cargo
	name = "quartermaster's jumpsuit"
	desc = "It's a jumpsuit worn by the quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_qm.dmi'


/obj/item/clothing/under/cargotech
	name = "cargo technician's jumpsuit"
	desc = "Shooooorts! They're comfy and easy to wear!"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_cargo.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS


/obj/item/clothing/under/chaplain
	desc = "It's a black jumpsuit, often worn by religious folk."
	name = "chaplain's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_chaplain.dmi'

/obj/item/clothing/under/chef
	desc = "It's an apron which is given only to the most <b>hardcore</b> chefs in space."
	name = "chef's uniform"
	icon = 'icons/clothing/under/uniform_chef.dmi'

/obj/item/clothing/under/clown
	name = "clown suit"
	desc = "<i>'HONK!'</i>"
	icon = 'icons/clothing/under/uniform_clown.dmi'

/obj/item/clothing/under/head_of_personnel
	desc = "It's a jumpsuit worn by someone who works in the position of \"Head of Personnel\"."
	name = "head of personnel's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_hop.dmi'

/obj/item/clothing/under/head_of_personnel_whimsy
	desc = "A blue jacket and red tie, with matching red cuffs! Snazzy. Wearing this makes you feel more important than your job title does."
	name = "head of personnel's suit"
	icon = 'icons/clothing/under/uniform_hop_whimsy.dmi'

/obj/item/clothing/under/hydroponics
	desc = "It's a jumpsuit designed to protect against minor plant-related hazards."
	name = "botanist's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_hydroponics.dmi'
	permeability_coefficient = 0.50

/obj/item/clothing/under/internalaffairs
	desc = "The plain, professional attire of an Internal Affairs Agent. The collar is <i>immaculately</i> starched."
	name = "Internal Affairs uniform"
	icon = 'icons/clothing/under/uniform_internalaffairs.dmi'
	starting_accessories = list(/obj/item/clothing/accessory/black)

/obj/item/clothing/under/internalaffairs/plain
	desc = "A plain shirt and pair of pressed black pants."
	name = "formal outfit"
	starting_accessories = null

/obj/item/clothing/under/internalaffairs/plain/nt
	desc = "A plain shirt and pair of pressed black pants."
	name = "formal outfit"
	starting_accessories = list(/obj/item/clothing/accessory/red_long)

/obj/item/clothing/under/janitor
	desc = "It's the official uniform of the janitor. It has minor protection from biohazards."
	name = "janitor's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_janitor.dmi'
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/lawyer
	name = "black lawyer suit"
	desc = "Slick threads."
	icon = 'icons/clothing/under/uniform_lawyer_black.dmi'

/obj/item/clothing/under/lawyer/female
	name = "black lawyer suit"
	icon = 'icons/clothing/under/uniform_lawyer_black_female.dmi'

/obj/item/clothing/under/lawyer/red
	name = "red Lawyer suit"
	icon = 'icons/clothing/under/uniform_lawyer_red.dmi'

/obj/item/clothing/under/lawyer/blue
	name = "blue Lawyer suit"
	icon = 'icons/clothing/under/uniform_lawyer_blue.dmi'

/obj/item/clothing/under/lawyer/bluesuit
	name = "blue suit"
	desc = "A classy suit."
	icon = 'icons/clothing/under/uniform_lawyer_black.dmi'
	starting_accessories = list(/obj/item/clothing/accessory/red)

/obj/item/clothing/under/lawyer/purpsuit
	name = "purple suit"
	icon = 'icons/clothing/under/uniform_lawyer_purple.dmi'

/obj/item/clothing/under/lawyer/oldman
	name = "Old Man's Suit"
	desc = "A classic suit for the older gentleman with built in back support."
	icon = 'icons/clothing/under/uniform_lawyer_old.dmi'

/obj/item/clothing/under/librarian
	name = "sensible suit"
	desc = "It's very... sensible."
	icon = 'icons/clothing/under/uniform_lawyer_red.dmi'

/obj/item/clothing/under/mime
	name = "mime's outfit"
	desc = "It's not very colourful."
	icon = 'icons/clothing/under/uniform_mime.dmi'

/obj/item/clothing/under/miner
	desc = "It's a snappy jumpsuit with a sturdy set of overalls. It is very dirty."
	name = "shaft miner's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_miner.dmi'
