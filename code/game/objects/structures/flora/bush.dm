////////////////////////////////////////
// bushes
////////////////////////////////////////
/obj/structure/flora/bush
	name       = "bush"
	icon       = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	w_class    = ITEM_SIZE_HUGE

/obj/structure/flora/bush/get_material_health_modifier()
	return 0.5

/obj/structure/flora/bush/init_appearance()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/bush/snow
	icon       = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"

/obj/structure/flora/bush/snow/init_appearance()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/bush/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/bush/reedbush/init_appearance()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/bush/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/bush/leafybush/init_appearance()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/bush/palebush
	icon_state = "palebush_1"

/obj/structure/flora/bush/palebush/init_appearance()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/bush/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/bush/stalkybush/init_appearance()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/bush/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/bush/grassybush/init_appearance()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/bush/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/bush/fernybush/init_appearance()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/bush/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/bush/sunnybush/init_appearance()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/bush/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/bush/genericbush/init_appearance()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/bush/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/bush/pointybush/init_appearance()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/bush/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/bush/lavendergrass/init_appearance()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/bush/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/bush/ywflowers/init_appearance()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/bush/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/bush/brflowers/init_appearance()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/bush/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/bush/ppflowers/init_appearance()
	icon_state = "ppflowers_[rand(1, 4)]"

/obj/structure/flora/bush/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/bush/sparsegrass/init_appearance()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/bush/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/bush/fullgrass/init_appearance()
	icon_state = "fullgrass_[rand(1, 3)]"