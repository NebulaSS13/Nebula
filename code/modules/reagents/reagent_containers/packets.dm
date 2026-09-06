/obj/item/chems/packet
	name = "packet"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/obj/food/condiments/packets/packet_small.dmi'
	w_class = ITEM_SIZE_TINY
	possible_transfer_amounts = @"[1,2,5,10]"
	amount_per_transfer_from_this = 1
	chem_volume = 10

/obj/item/chems/packet/attack_self(mob/user)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		to_chat(user, SPAN_NOTICE("You tear \the [src] open."))
		return TRUE
	return ..()

/obj/item/chems/packet/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return ..()
	if(standard_dispenser_refill(user, target))
		return TRUE
	if(standard_pour_into(user, target))
		return TRUE
	return ..()

/obj/item/chems/packet/salt
	name = "salt packet"
	desc = "Contains 5u of table salt."
	icon = 'icons/obj/food/condiments/packets/packet_white.dmi'

/obj/item/chems/packet/salt/populate_reagents()
	add_to_reagents(/decl/material/solid/sodiumchloride, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/pepper
	name = "pepper packet"
	desc = "Contains 5u of black pepper."
	icon = 'icons/obj/food/condiments/packets/packet_black.dmi'

/obj/item/chems/packet/pepper/populate_reagents()
	add_to_reagents(/decl/material/solid/blackpepper, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/sugar
	name = "sugar packet"
	desc = "Contains 5u of refined sugar."
	icon = 'icons/obj/food/condiments/packets/packet_white.dmi'

/obj/item/chems/packet/sugar/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/sugar, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/jelly
	name = "jelly packet"
	desc = "Contains 10u of cherry jelly. Best used for spreading on crackers."
	icon = 'icons/obj/food/condiments/packets/packet_medium.dmi'

/obj/item/chems/packet/jelly/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/cherryjelly, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/honey
	name = "honey packet"
	desc = "Contains 10u of honey."
	icon = 'icons/obj/food/condiments/packets/packet_medium.dmi'

/obj/item/chems/packet/honey/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/honey, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/honey_fake
	name = "'honey' packet"
	desc = "Contains 10u of allergen-free non-GMO 'honey'."
	icon = 'icons/obj/food/condiments/packets/packet_medium.dmi'

/obj/item/chems/packet/honey_fake/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/sugar, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/capsaicin
	name = "hot sauce packet"
	desc = "Contains 5u of hot sauce. Enjoy in moderation."
	icon = 'icons/obj/food/condiments/packets/packet_red.dmi'

/obj/item/chems/packet/capsaicin/populate_reagents()
	add_to_reagents(/decl/material/liquid/capsaicin, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/ketchup
	name = "ketchup packet"
	desc = "Contains 5u of ketchup."
	icon = 'icons/obj/food/condiments/packets/packet_red.dmi'

/obj/item/chems/packet/ketchup/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/ketchup, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/mayo
	name = "mayonnaise packet"
	desc = "Contains 5u of mayonnaise."
	icon = 'icons/obj/food/condiments/packets/packet_white.dmi'

/obj/item/chems/packet/mayo/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/mayo, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/soy
	name = "soy sauce packet"
	desc = "Contains 5u of soy sauce."
	icon = 'icons/obj/food/condiments/packets/packet_black.dmi'

/obj/item/chems/packet/soy/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/soysauce, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/coffee
	name = "instant coffee powder packet"
	desc = "Contains 5u of instant coffee powder. Mix with 25u of water."

/obj/item/chems/packet/coffee/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/coffee/instant, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/tea
	name = "instant tea powder packet"
	desc = "Contains 5u of instant black tea powder. Mix with 25u of water."

/obj/item/chems/packet/tea/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/tea/instant, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/cocoa
	name = "cocoa powder packet"
	desc = "Contains 5u of cocoa powder. Mix with 25u of water and heat."

/obj/item/chems/packet/cocoa/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/coco, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/grape
	name = "grape juice powder packet"
	desc = "Contains 5u of powdered grape juice. Mix with 15u of water."

/obj/item/chems/packet/grape/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/instantjuice/grape, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/orange
	name = "orange juice powder packet"
	desc = "Contains 5u of powdered orange juice. Mix with 15u of water."

/obj/item/chems/packet/orange/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/instantjuice/orange, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/watermelon
	name = "watermelon juice powder packet"
	desc = "Contains 5u of powdered watermelon juice. Mix with 15u of water."

/obj/item/chems/packet/watermelon/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/instantjuice/watermelon, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/apple
	name = "apple juice powder packet"
	desc = "Contains 5u of powdered apple juice. Mix with 15u of water."

/obj/item/chems/packet/apple/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment/instantjuice/apple, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/protein
	name = "protein powder packet"
	desc = "Contains 10u of powdered protein. Mix with 20u of water."
	icon = 'icons/obj/food/condiments/packets/packet_medium.dmi'

/obj/item/chems/packet/protein/populate_reagents()
	add_to_reagents(/decl/material/solid/organic/meat, REAGENT_MAXIMUM_VOLUME(reagents)/2)

/obj/item/chems/packet/crayon
	name = "crayon powder packet"
	desc = "Contains 10u of powdered crayon. Mix with 30u of water."

/obj/item/chems/packet/crayon/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/crayon/red/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/red, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/crayon/orange/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/orange, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/crayon/yellow/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/yellow, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/crayon/green/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/green, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/crayon/blue/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/blue, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/crayon/purple/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/purple, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/crayon/grey/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/grey, REAGENT_MAXIMUM_VOLUME(reagents))

/obj/item/chems/packet/crayon/brown/populate_reagents()
	add_to_reagents(/decl/material/liquid/pigment/brown, REAGENT_MAXIMUM_VOLUME(reagents))
