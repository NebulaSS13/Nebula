/*
GENERAL
*/
/obj/item/book/skill/general
	abstract_type = /obj/item/book/skill/general

//eva
/obj/item/book/skill/general/eva
	icon = 'icons/obj/items/books/book_eva.dmi'
	skill = SKILL_EVA
	author = "Big Dark"

/obj/item/book/skill/general/eva/basic
	name = "beginner extra-vehicular activity textbook"

/obj/item/book/skill/general/eva/adept
	skill_req = SKILL_BASIC
	name = "intermediate extra-vehicular activity textbook"

/obj/item/book/skill/general/eva/expert
	skill_req = SKILL_ADEPT
	name = "advanced extra-vehicular activity textbook"

/obj/item/book/skill/general/eva/prof
	skill_req = SKILL_EXPERT
	name = "theoretical extra-vehicular activity textbook"

//mech
/obj/item/book/skill/general/mech
	icon = 'icons/obj/items/books/book_mech.dmi'
	skill = SKILL_MECH
	author = "J.T. Marsh"

/obj/item/book/skill/general/mech/basic
	name = "beginner exosuit operation textbook"

/obj/item/book/skill/general/mech/adept
	skill_req = SKILL_BASIC
	name = "intermediate exosuit operation textbook"

/obj/item/book/skill/general/mech/expert
	skill_req = SKILL_ADEPT
	name = "advanced exosuit operation textbook"

/obj/item/book/skill/general/mech/prof
	skill_req = SKILL_EXPERT
	name = "theoretical exosuit operation textbook"

//piloting
/obj/item/book/skill/general/pilot
	skill = SKILL_PILOT
	author = "Sumi Shimamoto"
	icon = 'icons/obj/items/books/book_pilot.dmi'

/obj/item/book/skill/general/pilot/basic
	name = "beginner piloting textbook"

/obj/item/book/skill/general/pilot/adept
	skill_req = SKILL_BASIC
	name = "intermediate piloting textbook"

/obj/item/book/skill/general/pilot/expert
	skill_req = SKILL_ADEPT
	name = "advanced piloting textbook"

/obj/item/book/skill/general/pilot/prof
	skill_req = SKILL_EXPERT
	name = "theoretical piloting textbook"

//hauling
/obj/item/book/skill/general/hauling
	skill = SKILL_HAULING
	author = "Chiel Brunt"
	icon = 'icons/obj/items/books/book_hauling.dmi'

/obj/item/book/skill/general/hauling/basic
	name = "beginner athletics textbook"

/obj/item/book/skill/general/hauling/adept
	skill_req = SKILL_BASIC
	name = "intermediate athletics textbook"

/obj/item/book/skill/general/hauling/expert
	skill_req = SKILL_ADEPT
	name = "advanced athletics textbook"

/obj/item/book/skill/general/hauling/prof
	skill_req = SKILL_EXPERT
	name = "theoretical athletics textbook"

//computer
/obj/item/book/skill/general/computer
	skill = SKILL_COMPUTER
	author = "Simona Castiglione"
	icon = 'icons/obj/items/books/book_nuclear.dmi'

/obj/item/book/skill/general/computer/basic
	name = "beginner information technology textbook"

/obj/item/book/skill/general/computer/adept
	skill_req = SKILL_BASIC
	name = "intermediate information technology textbook"

/obj/item/book/skill/general/computer/expert
	skill_req = SKILL_ADEPT
	name = "advanced information technology textbook"

/obj/item/book/skill/general/computer/prof
	skill_req = SKILL_EXPERT
	name = "theoretical information technology textbook"
