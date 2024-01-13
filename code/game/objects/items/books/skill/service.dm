/*
SERVICE
*/
/obj/item/book/skill/service
	abstract_type = /obj/item/book/skill/service

//botany
/obj/item/book/skill/service/botany
	icon_state = "bookHydroponicsPodPeople"
	skill = SKILL_BOTANY
	author = "Mai Dong Chat"

/obj/item/book/skill/service/botany/basic
	name = "beginner botany textbook"

/obj/item/book/skill/service/botany/adept
	skill_req = SKILL_BASIC
	name = "intermediate botany textbook"

/obj/item/book/skill/service/botany/expert
	skill_req = SKILL_ADEPT
	name = "advanced botany textbook"

/obj/item/book/skill/service/botany/prof
	skill_req = SKILL_EXPERT
	name = "theoretical botany textbook"

//cooking
/obj/item/book/skill/service/cooking
	icon_state = "barbook"
	skill = SKILL_COOKING
	author = "Lavinia Burrows"

/obj/item/book/skill/service/cooking/basic
	name = "beginner cooking textbook"

/obj/item/book/skill/service/cooking/adept
	skill_req = SKILL_BASIC
	name = "intermediate cooking textbook"

/obj/item/book/skill/service/cooking/expert
	skill_req = SKILL_ADEPT
	name = "advanced cooking textbook"

/obj/item/book/skill/service/cooking/prof
	skill_req = SKILL_EXPERT
	name = "theoretical cooking textbook"
