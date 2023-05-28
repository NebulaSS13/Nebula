
/*
 * Cargo
 */

/obj/item/clothing/jumpsuit/cargo
	name = "quartermaster's jumpsuit"
	desc = "It's a jumpsuit worn by the quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	icon = 'icons/clothing/jumpsuits/jumpsuit_qm.dmi'

/obj/item/clothing/jumpsuit/cargotech
	name = "cargo technician's jumpsuit"
	desc = "Practical high-visibility workwear for lugging crates at the crack of dawn."
	icon = 'icons/clothing/jumpsuits/jumpsuit_cargo_alt.dmi'

/obj/item/clothing/jumpsuit/miner
	desc = "A branded high-vis jumpsuit for toiling in the mines. Somehow it's dirty already."
	name = "shaft miner's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_miner.dmi'

/obj/item/clothing/jumpsuit/miner/overalls
	desc = "It's a snappy purple shirt with a sturdy set of overalls. Very retro."
	name = "shaft miner's overalls"
	icon = 'icons/clothing/jumpsuits/jumpsuit_miner_overalls.dmi'


/obj/item/clothing/jumpsuit/cargoshort
	name = "cargo technician's jumpsuit"
	desc = "Shooooorts! They're comfy and easy to wear!"
	icon = 'icons/clothing/jumpsuits/jumpsuit_cargo.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS

/*
 * Civilian
 */

/obj/item/clothing/jumpsuit/chaplain
	desc = "It's a black jumpsuit, often worn by religious folk."
	name = "chaplain's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_chaplain.dmi'

/obj/item/clothing/jumpsuit/head_of_personnel
	desc = "It's a jumpsuit worn by someone who works in the position of \"Head of Personnel\"."
	name = "head of personnel's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_hop.dmi'

/obj/item/clothing/jumpsuit/hydroponics
	desc = "It's a jumpsuit designed to protect against minor plant-related hazards."
	name = "botanist's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_hydroponics.dmi'
	permeability_coefficient = 0.50

/obj/item/clothing/jumpsuit/janitor
	desc = "It's the official uniform of the janitor. It has minor protection from biohazards."
	name = "janitor's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_janitor.dmi'
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/*
 * Engineering
 */

/obj/item/clothing/jumpsuit/chief_engineer
	desc = "It's a high visibility jumpsuit given to those engineers insane enough to achieve the rank of \"Chief engineer\". It has minor radiation shielding."
	name = "chief engineer's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_ce.dmi'
	armor = list(
		ARMOR_RAD = ARMOR_RAD_MINOR
	)

/obj/item/clothing/jumpsuit/hazard
	name = "hazard jumpsuit"
	desc = "A high visibility jumpsuit made from heat and radiation resistant materials."
	icon = 'icons/clothing/jumpsuits/jumpsuit_hazard.dmi'
	siemens_coefficient = 0.8
	armor = list(
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE


/obj/item/clothing/jumpsuit/atmospheric_technician
	desc = "It's a jumpsuit worn by atmospheric technicians."
	name = "atmospheric technician's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_atmos.dmi'

/obj/item/clothing/jumpsuit/engineer
	desc = "It's an orange high visibility jumpsuit worn by engineers. It has minor radiation shielding."
	name = "engineer's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_engineer.dmi'
	armor = list(
		ARMOR_RAD = ARMOR_RAD_MINOR
		)

/*
 * Research / Science
 */

/obj/item/clothing/jumpsuit/roboticist
	desc = "It's a slimming black jumpsuit with reinforced seams; great for industrial work."
	name = "roboticist's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_robotics.dmi'

/obj/item/clothing/jumpsuit/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Chief Science Officer\". Its fabric provides minor protection from biological contaminants."
	name = "chief science officer's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_rd.dmi'
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/jumpsuit/chemist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a chemist rank stripe on it."
	name = "pharmacist's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_chemist.dmi'
	permeability_coefficient = 0.50
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
		)
/*
 * Medical
 */
/obj/item/clothing/jumpsuit/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_cmo.dmi'
	permeability_coefficient = 0.50
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
		)

/obj/item/clothing/jumpsuit/sterile
	name = "sterile jumpsuit"
	desc = "A sterile white jumpsuit with medical markings. Protects against all manner of biohazards."
	icon = 'icons/clothing/jumpsuits/jumpsuit_sterile.dmi'
	permeability_coefficient = 0.50
	armor = list(
		ARMOR_BIO = ARMOR_BIO_SMALL
	)

/obj/item/clothing/jumpsuit/geneticist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a genetics rank stripe on it."
	name = "geneticist's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_genetics.dmi'
	permeability_coefficient = 0.50
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
		)

/obj/item/clothing/jumpsuit/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_virology.dmi'
	permeability_coefficient = 0.50
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
		)

/obj/item/clothing/jumpsuit/psych
	desc = "A basic white jumpsuit. It has turquoise markings that denote the wearer as a psychiatrist."
	name = "psychiatrist's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_psych.dmi'

/obj/item/clothing/jumpsuit/medical
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	name = "medical doctor's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_medical.dmi'
	permeability_coefficient = 0.50
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
	)

/obj/item/clothing/jumpsuit/medical/paramedic
	name = "short sleeve medical jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one has a cross on the chest denoting that the wearer is trained medical personnel."

/obj/item/clothing/jumpsuit/medical/utility
	name = "medical utility jumpsuit"
	desc = "A hard-wearing version of the standard medical uniform, made with the same bioresistant lining. Designed for long term medical postings."
	icon = 'icons/clothing/jumpsuits/jumpsuit_utility_med.dmi'


/*
 * Security
 */

/obj/item/clothing/jumpsuit/head_of_security
	desc = "It's a jumpsuit worn by those few with the dedication to achieve the position of \"Head of Security\". It has additional armor to protect the wearer."
	name = "head of security's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_hos.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.8
	material = /decl/material/solid/organic/leather
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE)
	origin_tech = @'{"materials":1,"engineering":1, "combat":1}'

/obj/item/clothing/jumpsuit/head_of_security/corporate
	icon = 'icons/clothing/jumpsuits/jumpsuit_hos_corp.dmi'

/obj/item/clothing/jumpsuit/head_of_security/jensen
	desc = "You never asked for anything that stylish."
	name = "head of security's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_hos_alt.dmi'
	siemens_coefficient = 0.6
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE)
	origin_tech = @'{"materials":3,"engineering":1, "combat":2}'

/obj/item/clothing/jumpsuit/warden
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for more robust protection. It has the word \"Warden\" written on the shoulders."
	name = "warden's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_warden.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)

/obj/item/clothing/jumpsuit/warden/corporate
	icon = 'icons/clothing/jumpsuits/jumpsuit_warden_corp.dmi'

/obj/item/clothing/jumpsuit/security
	name = "security officer's jumpsuit"
	desc = "It's made of a slightly sturdier material than standard jumpsuits, to allow for robust protection."
	icon = 'icons/clothing/jumpsuits/jumpsuit_sec.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
	)
	siemens_coefficient = 0.9
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)

/obj/item/clothing/jumpsuit/security/corporate
	icon = 'icons/clothing/jumpsuits/jumpsuit_sec_corp.dmi'

/*
 * Command
*/

/obj/item/clothing/jumpsuit/captain //Alright, technically not a 'civilian' but its better then giving a .dm file for a single define.
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	name = "captain's jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit_captain.dmi'

/obj/item/clothing/jumpsuit/captainformal
	name = "captain's formal uniform"
	desc = "A captain's formal-wear, for special occasions."
	icon = 'icons/clothing/uniform_captain_formal.dmi'
