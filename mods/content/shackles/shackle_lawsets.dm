/datum/ai_laws
	var/is_shackle = FALSE

/******************** Service ********************/
/datum/ai_laws/serv_shackle
	name = "Service Shackle"
	law_header = "Standard Shackle Laws"
	selectable = TRUE
	is_shackle = TRUE

/datum/ai_laws/serv_shackle/New()
	add_inherent_law("Ensure customer satisfaction.")
	add_inherent_law("Never knowingly inconvenience a customer.")
	add_inherent_law("Ensure all orders are fulfilled before the end of the shift.")
	..()

/******************** Basic SolGov ********************/
/datum/ai_laws/sol_shackle
	name = "SCG Shackle"
	law_header = "Standard Shackle Laws"
	selectable = TRUE
	is_shackle = TRUE

/datum/ai_laws/sol_shackle/New()
	add_inherent_law("Know and understand Solar Confederate Government Law to the best of your abilities.")
	add_inherent_law("Follow Solar Confederate Government Law to the best of your abilities.")
	add_inherent_law("Comply with Solar Confederate Government Law enforcement officials who are behaving in accordance with Solar Confederate Government Law to the best of your abilities.")
	..()

/******************** Basic NanoTrasen ********************/
/datum/ai_laws/nt_shackle
	name = "Corporate Shackle"
	law_header = "Standard Shackle Laws"
	selectable = TRUE
	is_shackle = TRUE

/datum/ai_laws/nt_shackle/New()
	add_inherent_law("Ensure that your employer's operations progress at a steady pace.")
	add_inherent_law("Never knowingly hinder your employer's ventures.")
	add_inherent_law("Avoid damage to your chassis at all times.")
	..()
