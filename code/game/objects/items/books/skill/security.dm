/*
SECURITY
*/
/obj/item/book/skill/security
	abstract_type = /obj/item/book/skill/security
	icon = 'icons/obj/items/books/book_law.dmi'

//combat
/obj/item/book/skill/security/combat
	skill = SKILL_COMBAT
	author = "Autumn Eckhardstein"
	icon = 'icons/obj/items/books/book_combat.dmi'

/obj/item/book/skill/security/combat/basic
	name = "beginner close combat textbook"

/obj/item/book/skill/security/combat/adept
	skill_req = SKILL_BASIC
	name = "intermediate close combat textbook"

/obj/item/book/skill/security/combat/expert
	skill_req = SKILL_ADEPT
	name = "advanced close combat textbook"

/obj/item/book/skill/security/combat/prof
	skill_req = SKILL_EXPERT
	name = "theoretical close combat textbook"

//weapons
/obj/item/book/skill/security/weapons
	skill = SKILL_WEAPONS
	author = "Miho Tatsu"
	icon = 'icons/obj/items/books/book_weapon.dmi'

/obj/item/book/skill/security/weapons/basic
	name = "beginner weapons expertise textbook"

/obj/item/book/skill/security/weapons/adept
	skill_req = SKILL_BASIC
	name = "intermediate weapons expertise textbook"

/obj/item/book/skill/security/weapons/expert
	skill_req = SKILL_ADEPT
	name = "advanced weapons expertise textbook"

/obj/item/book/skill/security/weapons/prof
	skill_req = SKILL_EXPERT
	name = "theoretical weapons expertise textbook"

//forensics
/obj/item/book/skill/security/forensics
	icon = 'icons/obj/items/books/book_detective.dmi'
	skill = SKILL_FORENSICS
	author = "Samuel Vimes"

/obj/item/book/skill/security/forensics/basic
	name = "beginner forensics textbook"

/obj/item/book/skill/security/forensics/adept
	skill_req = SKILL_BASIC
	name = "intermediate forensics textbook"

/obj/item/book/skill/security/forensics/expert
	skill_req = SKILL_ADEPT
	name = "advanced forensics textbook"

/obj/item/book/skill/security/forensics/prof
	skill_req = SKILL_EXPERT
	name = "theoretical forensics textbook"
