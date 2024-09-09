/*
ENGINEERING
*/
/obj/item/book/skill/engineering
	abstract_type = /obj/item/book/skill/engineering
	icon = 'icons/obj/items/books/book_engineering.dmi'

//construction
/obj/item/book/skill/engineering/construction/
	author = "Robert Bildar"
	skill = SKILL_CONSTRUCTION

/obj/item/book/skill/engineering/construction/basic
	name = "beginner construction textbook"

/obj/item/book/skill/engineering/construction/adept
	skill_req = SKILL_BASIC
	name = "intermediate construction textbook"

/obj/item/book/skill/engineering/construction/expert
	skill_req = SKILL_ADEPT
	name = "advanced construction textbook"

/obj/item/book/skill/engineering/construction/prof
	skill_req = SKILL_EXPERT
	name = "theoretical construction textbook"

//electrical
/obj/item/book/skill/engineering/electrical
	skill = SKILL_ELECTRICAL
	author = "Ariana Vanderbalt"

/obj/item/book/skill/engineering/electrical/basic
	name = "beginner electrical engineering textbook"

/obj/item/book/skill/engineering/electrical/adept
	skill_req = SKILL_BASIC
	name = "intermediate electrical engineering textbook"

/obj/item/book/skill/engineering/electrical/expert
	skill_req = SKILL_ADEPT
	name = "advanced electrical engineering textbook"

/obj/item/book/skill/engineering/electrical/prof
	skill_req = SKILL_EXPERT
	name = "theoretical electrical engineering textbook"

//engines
/obj/item/book/skill/engineering/engines
	skill = SKILL_ENGINES
	author = "Gilgamesh Scholz"

/obj/item/book/skill/engineering/engines/basic
	name = "beginner engines textbook"

/obj/item/book/skill/engineering/engines/adept
	skill_req = SKILL_BASIC
	name = "intermediate engines textbook"

/obj/item/book/skill/engineering/engines/expert
	skill_req = SKILL_ADEPT
	name = "advanced engines textbook"

/obj/item/book/skill/engineering/engines/prof
	skill_req = SKILL_EXPERT
	name = "theoretical engines textbook"

/obj/item/book/skill/engineering/engines/prof/magazine
	name = "theoretical engines magazine"
	title = "\improper WetSkrell magazine"
	icon_state = "bookMagazine"
	custom = TRUE
	author = "Unknown"
	desc = "Sure, it includes highly detailed information on extremely advanced engine and power generator systems... but why is it written in marker on a tentacle porn magazine?"
	w_class = ITEM_SIZE_NORMAL

//atmos
/obj/item/book/skill/engineering/atmos
	skill = SKILL_ATMOS
	author = "Maria Crash"
	icon = 'icons/obj/items/books/book_piping.dmi'

/obj/item/book/skill/engineering/atmos/basic
	name = "beginner atmospherics textbook"

/obj/item/book/skill/engineering/atmos/adept
	skill_req = SKILL_BASIC
	name = "intermediate atmospherics textbook"

/obj/item/book/skill/engineering/atmos/expert
	skill_req = SKILL_ADEPT
	name = "advanced atmospherics textbook"

/obj/item/book/skill/engineering/atmos/prof
	skill_req = SKILL_EXPERT
	name = "theoretical atmospherics textbook"
