
/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	icon_vend = "nutri-vend"
	vend_delay = 26
	base_type = /obj/machinery/vending/hydronutrients
	products = list(
		/obj/item/chems/glass/bottle/eznutrient = 6,
		/obj/item/chems/glass/bottle/left4zed = 4,
		/obj/item/chems/glass/bottle/robustharvest = 3,
		/obj/item/plantspray/pests = 20,
		/obj/item/chems/syringe = 5,
		/obj/item/plants = 5,
		/obj/item/chems/glass/bottle/ammonia = 10
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	markup = 0

/obj/machinery/vending/hydronutrients/generic
	icon_state = "nutri_generic"
	icon_vend = "nutri_generic-vend"
	icon_deny = "nutri_generic-deny"

/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection this half of the galaxy!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = "seeds"
	icon_vend = "seeds-vend"
	icon_deny = "seeds-deny"
	vend_delay = 13
	base_type = /obj/machinery/vending/hydroseeds
	markup = 0
	products = list(
		/obj/item/seeds/bananaseed = 3,
		/obj/item/seeds/berryseed = 3,
		/obj/item/seeds/carrotseed = 3,
		/obj/item/seeds/chantermycelium = 3,
		/obj/item/seeds/chiliseed = 3,
		/obj/item/seeds/cornseed = 3,
		/obj/item/seeds/eggplantseed = 3,
		/obj/item/seeds/potatoseed = 3,
		/obj/item/seeds/soyaseed = 3,
		/obj/item/seeds/sunflowerseed = 3,
		/obj/item/seeds/tomatoseed = 3,
		/obj/item/seeds/towercap = 3,
		/obj/item/seeds/wheatseed = 3,
		/obj/item/seeds/appleseed = 3,
		/obj/item/seeds/poppyseed = 3,
		/obj/item/seeds/sugarcaneseed = 3,
		/obj/item/seeds/ambrosiavulgarisseed = 3,
		/obj/item/seeds/peanutseed = 3,
		/obj/item/seeds/whitebeetseed = 3,
		/obj/item/seeds/watermelonseed = 3,
		/obj/item/seeds/limeseed = 3,
		/obj/item/seeds/lemonseed = 3,
		/obj/item/seeds/orangeseed = 3,
		/obj/item/seeds/grassseed = 3,
		/obj/item/seeds/cocoapodseed = 3,
		/obj/item/seeds/plumpmycelium = 2,
		/obj/item/seeds/cabbageseed = 3,
		/obj/item/seeds/grapeseed = 3,
		/obj/item/seeds/pumpkinseed = 3,
		/obj/item/seeds/cherryseed = 3,
		/obj/item/seeds/plastiseed = 3,
		/obj/item/seeds/riceseed = 3,
		/obj/item/seeds/lavenderseed = 3
	)
	contraband = list(
		/obj/item/seeds/amanitamycelium = 2,
		/obj/item/seeds/glowbell = 2,
		/obj/item/seeds/libertymycelium = 2,
		/obj/item/seeds/mtearseed = 2,
		/obj/item/seeds/nettleseed = 2,
		/obj/item/seeds/reishimycelium = 2,
		/obj/item/seeds/reishimycelium = 2,
		/obj/item/seeds/shandseed = 2,
		/obj/item/chems/spray/waterflower = 1
	)

/obj/machinery/vending/hydroseeds/generic
	icon_state = "seeds_generic"
	icon_vend = "seeds_generic-vend"
	icon_deny = "seeds_generic-deny"
