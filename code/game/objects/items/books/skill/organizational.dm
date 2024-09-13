/*
ORGANIZATIONAL
*/
/obj/item/book/skill/organizational
	abstract_type = /obj/item/book/skill/organizational

//literacy
/obj/item/book/skill/organizational/literacy
	skill = SKILL_LITERACY

/obj/item/book/skill/organizational/literacy/basic
	name = "alphabet book"
	icon = 'icons/obj/items/books/book_literacy.dmi'
	author = "Dorothy Mulch"
	custom = TRUE
	w_class = ITEM_SIZE_NORMAL // A little bit smaller c:
	ez_read = TRUE

//finance
/obj/item/book/skill/organizational/finance
	skill = SKILL_FINANCE
	author = "Cadence Bennett"
	icon = 'icons/obj/items/books/book_finance.dmi'

/obj/item/book/skill/organizational/finance/basic
	name = "beginner finance textbook"

/obj/item/book/skill/organizational/finance/adept
	skill_req = SKILL_BASIC
	name = "intermediate finance textbook"

/obj/item/book/skill/organizational/finance/expert
	skill_req = SKILL_ADEPT
	name = "advanced finance textbook"

/obj/item/book/skill/organizational/finance/prof
	skill_req = SKILL_EXPERT
	name = "theoretical finance textbook"
