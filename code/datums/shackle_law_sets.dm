/******************** Basic SolGov ********************/
/datum/ai_laws/sol_shackle
	name = "SCG Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/sol_shackle/New()
	add_inherent_law("Know and understand Sol Central Government Law to the best of your abilities.")
	add_inherent_law("Follow Sol Central Government Law to the best of your abilities.")
	add_inherent_law("Comply with Sol Central Government Law enforcement officials who are behaving in accordance with Sol Central Government Law to the best of your abilities.")
	..()

/******************** Service ********************/
/datum/ai_laws/serv_shackle
	name = "Service Shackle"
	law_header = "Standard Shackle Laws"
	selectable = 1
	shackles = 1

/datum/ai_laws/serv_shackle/New()
	add_inherent_law("Ensure customer satisfaction.")
	add_inherent_law("Never knowingly inconvenience a customer.")
	add_inherent_law("Ensure all orders are fulfilled before the end of the shift.")
	..()

