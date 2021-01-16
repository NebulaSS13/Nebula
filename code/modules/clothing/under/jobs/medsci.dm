/*
 * Science
 */

/obj/item/clothing/under/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Chief Science Officer\". Its fabric provides minor protection from biological contaminants."
	name = "chief science officer's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_rd.dmi'
	armor = list(
		bio = ARMOR_BIO_MINOR
	)
		
/obj/item/clothing/under/research_director/rdalt
	desc = "A dress suit and slacks stained with hard work and dedication to science. Perhaps other things as well, but mostly hard work and dedication."
	name = "head researcher uniform"
	icon = 'icons/clothing/under/uniform_rd_alt.dmi'
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/research_director/dress_rd
	name = "chief science officer dress uniform"
	desc = "Feminine fashion for the style concious CSO. Its fabric provides minor protection from biological contaminants."
	icon = 'icons/clothing/under/dresses/dress_rd.dmi'
	armor = list(
		bio = ARMOR_BIO_MINOR
	)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS

/obj/item/clothing/under/chemist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a chemist rank stripe on it."
	name = "pharmacist's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_chemist.dmi'
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
/*
 * Medical
 */
/obj/item/clothing/under/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_cmo.dmi'
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/geneticist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a genetics rank stripe on it."
	name = "geneticist's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_genetics.dmi'
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_virology.dmi'
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/nursesuit
	desc = "It's a jumpsuit commonly worn by nursing staff in the medical department."
	name = "nurse's suit"
	icon = 'icons/clothing/under/nurse.dmi'
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY

/obj/item/clothing/under/nurse
	desc = "A dress commonly worn by the nursing staff in the medical department."
	name = "nurse's dress"
	icon = 'icons/clothing/under/nurse.dmi'
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY

/obj/item/clothing/under/orderly
	desc = "A white suit to be worn by medical attendants."
	name = "orderly's uniform"
	icon = 'icons/clothing/under/uniform_orderly.dmi'
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/medical
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	name = "medical doctor's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_medical.dmi'
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
	)

/obj/item/clothing/under/medical/paramedic
	name = "short sleeve medical jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one has a cross on the chest denoting that the wearer is trained medical personnel."
	rolled_sleeves = TRUE

/obj/item/clothing/under/medical/scrubs
	name = "scrubs"
	desc = "A loose-fitting garment designed to provide minor protection against biohazards."
	icon = 'icons/clothing/under/uniform_scrubs.dmi'

/obj/item/clothing/under/medical/scrubs/blue
	name = "blue scrubs"
	color = "#4891e1"

/obj/item/clothing/under/medical/scrubs/green
	name = "green scrubs"
	color = "#255a3e"

/obj/item/clothing/under/medical/scrubs/purple
	name = "purple scrubs"
	color = "#7a1b3f"

/obj/item/clothing/under/medical/scrubs/black
	name = "black scrubs"
	color = "#242424"

/obj/item/clothing/under/medical/scrubs/navyblue
	name = "navy blue scrubs"
	color = "#1f3a69"

/obj/item/clothing/under/medical/scrubs/lilac
	name = "lilac scrubs"
	color = "#c8a2c8"

/obj/item/clothing/under/medical/scrubs/teal
	name = "teal scrubs"
	color = "#008080"

/obj/item/clothing/under/medical/scrubs/heliodor
	name = "heliodor scrubs"
	color = "#aad539"

/obj/item/clothing/under/psych
	desc = "A basic white jumpsuit. It has turqouise markings that denote the wearer as a psychiatrist."
	name = "psychiatrist's jumpsuit"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit_psych.dmi'

/obj/item/clothing/under/psych/turtleneck
	desc = "A turqouise sweater and a pair of dark blue slacks."
	name = "turqouise turtleneck"
	icon = 'icons/clothing/under/uniform_turtleneck_blue.dmi'
