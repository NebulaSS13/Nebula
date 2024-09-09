/*
MEDICAL
*/
/obj/item/book/skill/medical
	abstract_type = /obj/item/book/skill/medical
	icon = 'icons/obj/items/books/book_medical.dmi'

//chemistry
/obj/item/book/skill/medical/chemistry
	icon = 'icons/obj/items/books/book_chemistry.dmi'
	author = "Dr. Shinula Nyekundujicho"
	skill = SKILL_CHEMISTRY

/obj/item/book/skill/medical/chemistry/basic
	name = "beginner chemistry textbook"

/obj/item/book/skill/medical/chemistry/adept
	skill_req = SKILL_BASIC
	name = "intermediate chemistry textbook"

/obj/item/book/skill/medical/chemistry/expert
	skill_req = SKILL_ADEPT
	name = "advanced chemistry textbook"

/obj/item/book/skill/medical/chemistry/prof
	skill_req = SKILL_EXPERT
	name = "theoretical chemistry textbook"

//medicine
/obj/item/book/skill/medical/medicine
	author = "Dr. Nagarjuna Siddha"
	skill = SKILL_MEDICAL

/obj/item/book/skill/medical/medicine/basic
	name = "beginner medicine textbook"
	title = "\"Instructional Guide on How Rubbing Dirt In Wounds Might Not Be The Right Approach To Stopping Bleeding Anymore\""
	desc = "A copy of \"Instructional Guide on How Rubbing Dirt In Wounds Might Not Be The Right Approach To Stopping Bleeding Anymore\" by Dr. Merrs. Despite the information density of this heavy book, it lacks any and all teachings regarding bedside manner."
	author = "Dr. Merrs"
	custom = TRUE

/obj/item/book/skill/medical/medicine/adept
	skill_req = SKILL_BASIC
	name = "intermediate medicine textbook"

/obj/item/book/skill/medical/medicine/expert
	skill_req = SKILL_ADEPT
	name = "advanced medicine textbook"

/obj/item/book/skill/medical/medicine/prof
	skill_req = SKILL_EXPERT
	name = "theoretical medicine textbook"

//anatomy
/obj/item/book/skill/medical/anatomy
	author = "Dr. Basil Cartwright"
	skill = SKILL_ANATOMY

/obj/item/book/skill/medical/anatomy/basic
	name = "beginner anatomy textbook"

/obj/item/book/skill/medical/anatomy/adept
	skill_req = SKILL_BASIC
	name = "intermediate anatomy textbook"

/obj/item/book/skill/medical/anatomy/expert
	skill_req = SKILL_ADEPT
	name = "advanced anatomy textbook"

/obj/item/book/skill/medical/anatomy/prof
	skill_req = SKILL_EXPERT
	name = "theoretical anatomy textbook"