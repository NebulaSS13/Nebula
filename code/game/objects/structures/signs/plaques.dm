////////////////////////////////////////////////////////////////////////
// Plaque
////////////////////////////////////////////////////////////////////////

/obj/structure/sign/plaque
	name       = "commemorative plaque"
	desc       = "A wall-mounted commemorative plaque."
	icon       = 'icons/obj/signs/plaques.dmi'
	icon_state = "lightplaque"
	material   = /decl/material/solid/metal/bronze

////////////////////////////////////////////////////////////////////////
// Plaques Definitions
////////////////////////////////////////////////////////////////////////

/obj/structure/sign/plaque/alternative
	icon_state = "lightplaquealt"

/obj/structure/sign/plaque/dark
	icon_state = "darkplaque"

/obj/structure/sign/plaque/golden
	name       = "The Most Robust Men Award for Robustness"
	desc       = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"
	material   = /decl/material/solid/metal/gold

/obj/structure/sign/plaque/golden/security
	name = "motivational plaque"
	desc = "A plaque engraved with a generic motivational quote and picture. ' Greater love hath no man than this, that a man lay down his life for his friends. John 15:13 "

/obj/structure/sign/plaque/golden/medical
	name = "medical certificate"
	desc = "A picture next to a long winded description of medical certifications and degrees."

/obj/structure/sign/plaque/ai_dev
	name       = "\improper AI developers plaque"
	desc       = "An extremely long list of names and job titles and a picture of the design team responsible for building this AI Core."
	icon_state = "kiddieplaque"

/obj/structure/sign/plaque/atmos
	name       = "\improper engineering memorial plaque"
	desc       = "This plaque memorializes those engineers and technicians who made the ultimate sacrifice to save their vessel and its crew."
	icon_state = "atmosplaque"

////////////////////////////////////////////////////////////////////////
// Plaque Items Templates
////////////////////////////////////////////////////////////////////////

/obj/item/sign/plaque
	name       = "commemorative plaque"
	desc       = "A wall-mountable commemorative plaque and some mounting screws."
	icon       = 'icons/obj/signs/plaques.dmi'
	icon_state = "lightplaque"
	material   = /decl/material/solid/metal/bronze
	sign_type  = /obj/structure/sign/plaque

/obj/item/sign/plaque/alternative
	icon_state = "lightplaquealt"
	sign_type  = /obj/structure/sign/plaque/alternative

/obj/item/sign/plaque/dark
	icon_state = "darkplaque"
	sign_type  = /obj/structure/sign/plaque/dark

/obj/item/sign/plaque/golden
	name       = "The Most Robust Men Award for Robustness"
	icon_state = "goldenplaque"
	sign_type  = /obj/structure/sign/plaque/golden

/obj/item/sign/plaque/golden/security
	name      = "motivational plaque"
	sign_type = /obj/structure/sign/plaque/golden/security

/obj/item/sign/plaque/golden/medical
	name      = "medical certificate"
	sign_type = /obj/structure/sign/plaque/golden/medical

/obj/item/sign/plaque/ai_dev
	name       = "\improper AI developers plaque"
	icon_state = "kiddieplaque"
	sign_type  = /obj/structure/sign/plaque/ai_dev

/obj/item/sign/plaque/atmos
	name       = "\improper engineering memorial plaque"
	icon_state = "atmosplaque"
	sign_type  = /obj/structure/sign/plaque/atmos
