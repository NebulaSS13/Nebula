/*
RESEARCH
*/
/obj/item/book/skill/research
	abstract_type = /obj/item/book/skill/research
	icon = 'icons/obj/items/books/book_analysis.dmi'

//devices
/obj/item/book/skill/research/devices
	author = "Nilva Plosinjak"
	skill = SKILL_DEVICES

/obj/item/book/skill/research/devices/basic
	name = "beginner complex devices textbook"

/obj/item/book/skill/research/devices/adept
	skill_req = SKILL_BASIC
	name = "intermediate complex devices textbook"

/obj/item/book/skill/research/devices/expert
	skill_req = SKILL_ADEPT
	name = "advanced complex devices textbook"

/obj/item/book/skill/research/devices/prof
	skill_req = SKILL_EXPERT
	name = "theoretical complex devices textbook"

//science
/obj/item/book/skill/research/science
	author = "Hui Ying Ch'ien"
	skill = SKILL_SCIENCE

/obj/item/book/skill/research/science/basic
	name = "beginner science textbook"

/obj/item/book/skill/research/science/adept
	skill_req = SKILL_BASIC
	name = "intermediate science textbook"

/obj/item/book/skill/research/science/expert
	skill_req = SKILL_ADEPT
	name = "advanced science textbook"

/obj/item/book/skill/research/science/prof
	skill_req = SKILL_EXPERT
	name = "theoretical science textbook"
