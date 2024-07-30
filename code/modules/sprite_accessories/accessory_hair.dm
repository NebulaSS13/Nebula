/decl/sprite_accessory_category/hair
	name                  = "Hair"
	base_accessory_type   = /decl/sprite_accessory/hair
	default_accessory     = /decl/sprite_accessory/hair/bald
	always_apply_defaults = TRUE
	uid                   = "acc_cat_hair"

/decl/sprite_accessory/hair
	abstract_type         = /decl/sprite_accessory/hair
	icon                  = 'icons/mob/human_races/species/human/hair.dmi'
	hidden_by_gear_slot   = slot_head_str
	hidden_by_gear_flag   = BLOCK_HEAD_HAIR
	body_parts            = list(BP_HEAD)
	sprite_overlay_layer  = FLOAT_LAYER
	is_heritable          = TRUE
	accessory_category    = SAC_HAIR
	accessory_flags       = HAIR_LOSS_VULNERABLE
	grooming_flags        = GROOMABLE_BRUSH | GROOMABLE_COMB

/decl/sprite_accessory/hair/get_grooming_descriptor(grooming_result, obj/item/organ/external/organ, obj/item/grooming/tool)
	return grooming_result == GROOMING_RESULT_PARTIAL ? "scalp" : "hair"

/decl/sprite_accessory/hair/can_be_groomed_with(obj/item/organ/external/organ, obj/item/grooming/tool)
	. = ..()
	if(. == GROOMING_RESULT_SUCCESS && (accessory_flags & HAIR_VERY_SHORT))
		return GROOMING_RESULT_PARTIAL

/decl/sprite_accessory/hair/get_hidden_substitute()
	if(accessory_flags & HAIR_VERY_SHORT)
		return src
	return GET_DECL(/decl/sprite_accessory/hair/short)

/decl/sprite_accessory/hair/refresh_mob(var/mob/living/subject)
	if(istype(subject))
		subject.update_hair()

/decl/sprite_accessory/hair/bald
	name                        = "Bald"
	icon_state                  = "bald"
	uid                         = "acc_hair_bald"
	accessory_flags             = HAIR_VERY_SHORT | HAIR_BALD
	bodytypes_allowed           = null
	bodytypes_denied            = null
	species_allowed             = null
	subspecies_allowed          = null
	bodytype_categories_allowed = null
	bodytype_categories_denied  = null
	body_flags_allowed          = null
	body_flags_denied           = null
	draw_accessory              = FALSE
	grooming_flags              = null

/decl/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_short"

/decl/sprite_accessory/hair/twintail
	name = "Twintail"
	icon_state = "hair_twintail"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_twintail"

/decl/sprite_accessory/hair/short2
	name = "Short Hair 2"
	icon_state = "hair_shorthair3"
	uid = "acc_hair_short2"

/decl/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "hair_c"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_cut"

/decl/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "hair_flair"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_flair"

/decl/sprite_accessory/hair/long
	name = "Shoulder-length Hair"
	icon_state = "hair_b"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_shoulder"

/decl/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "hair_vlong"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_long"

/decl/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "hair_longest"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_verylong"

/decl/sprite_accessory/hair/longfringe
	name = "Long Fringe"
	icon_state = "hair_longfringe"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_longfringe"

/decl/sprite_accessory/hair/longestalt
	name = "Longer Fringe"
	icon_state = "hair_vlongfringe"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_longestalt"

/decl/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "hair_halfbang"
	uid = "acc_hair_halfbang"

/decl/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair Alt"
	icon_state = "hair_halfbang_alt"
	uid = "acc_hair_halfbangalt"

/decl/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "hair_parted"
	uid = "acc_hair_parted"

/decl/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "hair_pompadour"
	uid = "acc_hair_pompadour"

/decl/sprite_accessory/hair/sleeze
	name = "Sleeze"
	icon_state = "hair_sleeze"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_sleeze"

/decl/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "hair_quiff"
	uid = "acc_hair_quiff"

/decl/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "hair_beehive"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_beehive"

/decl/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "hair_beehive2"
	uid = "acc_hair_beehive2"

/decl/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "hair_bobcurl"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_bobcurl"

/decl/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "hair_bobcut"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_bob"

/decl/sprite_accessory/hair/bobcutalt
	name = "Chin Length Bob"
	icon_state = "hair_bobcutalt"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_bobcutalt"

/decl/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "hair_bowlcut"
	uid = "acc_hair_bowl"

/decl/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "hair_buzzcut"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_buzz"

/decl/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "hair_crewcut"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_crew"

/decl/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "hair_combover"
	uid = "acc_hair_combover"

/decl/sprite_accessory/hair/father
	name = "Father"
	icon_state = "hair_father"
	uid = "acc_hair_father"

/decl/sprite_accessory/hair/reversemohawk
	name = "Reverse Mohawk"
	icon_state = "hair_reversemohawk"
	uid = "acc_hair_reversemohawk"

/decl/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "hair_devilock"
	uid = "acc_hair_devillock"

/decl/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "hair_dreads"
	uid = "acc_hair_deadlocks"

/decl/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "hair_curls"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_curls"

/decl/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "hair_afro"
	uid = "acc_hair_afro"

/decl/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "hair_afro2"
	uid = "acc_hair_afro2"

/decl/sprite_accessory/hair/afro_large
	name = "Big Afro"
	icon_state = "hair_bigafro"
	uid = "acc_hair_bigafro"

/decl/sprite_accessory/hair/rows
	name = "Rows"
	icon_state = "hair_rows1"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_rows"

/decl/sprite_accessory/hair/rows2
	name = "Rows 2"
	icon_state = "hair_rows2"
	accessory_flags = HAIR_VERY_SHORT | HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_rows2"

/decl/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "hair_sargeant"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_flattop"

/decl/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "hair_emo"
	uid = "acc_hair_emo"

/decl/sprite_accessory/hair/emo2
	name = "Emo Alt"
	icon_state = "hair_emo2"
	uid = "acc_hair_emo2"

/decl/sprite_accessory/hair/longemo
	name = "Long Emo"
	icon_state = "hair_emolong"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_longemo"

/decl/sprite_accessory/hair/shortovereye
	name = "Overeye Short"
	icon_state = "hair_shortovereye"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_overeye_short"

/decl/sprite_accessory/hair/longovereye
	name = "Overeye Long"
	icon_state = "hair_longovereye"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_overeye_long"

/decl/sprite_accessory/hair/flow
	name = "Flow Hair"
	icon_state = "hair_f"
	uid = "acc_hair_flow"

/decl/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "hair_feather"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_feather"

/decl/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hair_hitop"
	uid = "acc_hair_hitop"

/decl/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "hair_d"
	uid = "acc_hair_mohawk"

/decl/sprite_accessory/hair/jensen
	name = "Adam Jensen Hair"
	icon_state = "hair_jensen"
	uid = "acc_hair_jensen"

/decl/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "hair_gelled"
	uid = "acc_hair_gelled"

/decl/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "hair_gentle"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_gentle"

/decl/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "hair_spikey"
	uid = "acc_hair_spikey"

/decl/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	icon_state = "hair_kusanagi"
	uid = "acc_hair_kusanagi"

/decl/sprite_accessory/hair/kagami
	name = "Pigtails"
	icon_state = "hair_kagami"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_kagami"

/decl/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "hair_himecut"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_himecut"

/decl/sprite_accessory/hair/shorthime
	name = "Short Hime Cut"
	icon_state = "hair_shorthime"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_shorthime"

/decl/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "hair_odango"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_odango"

/decl/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "hair_ombre"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_ombre"

/decl/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "hair_updo"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_updo"

/decl/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "hair_skinhead"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_skinhead"

/decl/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "hair_e"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_balding"

/decl/sprite_accessory/hair/familyman
	name = "The Family Man"
	icon_state = "hair_thefamilyman"
	uid = "acc_hair_familyman"

/decl/sprite_accessory/hair/mahdrills
	name = "Drillruru"
	icon_state = "hair_drillruru"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_drillruru"

/decl/sprite_accessory/hair/fringetail
	name = "Fringetail"
	icon_state = "hair_fringetail"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_fringetail"

/decl/sprite_accessory/hair/dandypomp
	name = "Dandy Pompadour"
	icon_state = "hair_dandypompadour"
	uid = "acc_hair_dandypomp"

/decl/sprite_accessory/hair/poofy
	name = "Poofy"
	icon_state = "hair_poofy"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_poofy"

/decl/sprite_accessory/hair/poofy/two
	name = "Poofy 2"
	uid = "acc_hair_poofy2"
	icon_state = "hair_poofy2"

/decl/sprite_accessory/hair/crono
	name = "Chrono"
	icon_state = "hair_toriyama"
	uid = "acc_hair_chrono"

/decl/sprite_accessory/hair/vegeta
	name = "Vegeta"
	icon_state = "hair_toriyama2"
	uid = "acc_hair_vegeta"

/decl/sprite_accessory/hair/cia
	name = "CIA"
	icon_state = "hair_cia"
	uid = "acc_hair_cia"

/decl/sprite_accessory/hair/mulder
	name = "Mulder"
	icon_state = "hair_mulder"
	uid = "acc_hair_mulder"

/decl/sprite_accessory/hair/scully
	name = "Scully"
	icon_state = "hair_scully"
	uid = "acc_hair_scully"

/decl/sprite_accessory/hair/nitori
	name = "Nitori"
	icon_state = "hair_nitori"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_nitori"

/decl/sprite_accessory/hair/joestar
	name = "Joestar"
	icon_state = "hair_joestar"
	uid = "acc_hair_joestar"

/decl/sprite_accessory/hair/volaju
	name = "Volaju"
	icon_state = "hair_volaju"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_volaju"

/decl/sprite_accessory/hair/longeralt2
	name = "Long Hair Alt 2"
	icon_state = "hair_longeralt2"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_longeralt2"

/decl/sprite_accessory/hair/shortbangs
	name = "Short Bangs"
	icon_state = "hair_shortbangs"
	uid = "acc_hair_shortbangs"

/decl/sprite_accessory/hair/shavedbun
	name = "Shaved Bun"
	icon_state = "hair_shavedbun"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_shavedbun"

/decl/sprite_accessory/hair/halfshaved
	name = "Half-Shaved"
	icon_state = "hair_halfshaved"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_halfshaved"

/decl/sprite_accessory/hair/halfshavedemo
	name = "Half-Shaved Emo"
	icon_state = "hair_halfshavedemo"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_halfshavedemo"

/decl/sprite_accessory/hair/longsideemo
	name = "Long Side Emo"
	icon_state = "hair_longsideemo"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_longsideemo"

/decl/sprite_accessory/hair/bun
	name = "Low Bun"
	icon_state = "hair_bun"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_lowbun"

/decl/sprite_accessory/hair/bun2
	name = "High Bun"
	icon_state = "hair_bun2"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_highbun"

/decl/sprite_accessory/hair/doublebun
	name = "Double-Bun"
	icon_state = "hair_doublebun"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_doublebun"

/decl/sprite_accessory/hair/lowfade
	name = "Low Fade"
	icon_state = "hair_lowfade"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_lowfade"

/decl/sprite_accessory/hair/medfade
	name = "Medium Fade"
	icon_state = "hair_medfade"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_medfade"

/decl/sprite_accessory/hair/highfade
	name = "High Fade"
	icon_state = "hair_highfade"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_highfade"

/decl/sprite_accessory/hair/baldfade
	name = "Balding Fade"
	icon_state = "hair_baldfade"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_baldfade"

/decl/sprite_accessory/hair/nofade
	name = "Regulation Cut"
	icon_state = "hair_nofade"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_nofade"

/decl/sprite_accessory/hair/trimflat
	name = "Trimmed Flat Top"
	icon_state = "hair_trimflat"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_trimflat"

/decl/sprite_accessory/hair/shaved
	name = "Shaved"
	icon_state = "hair_shaved"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_shaved"

/decl/sprite_accessory/hair/trimmed
	name = "Trimmed"
	icon_state = "hair_trimmed"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_trimmed"

/decl/sprite_accessory/hair/tightbun
	name = "Tight Bun"
	icon_state = "hair_tightbun"
	accessory_flags = HAIR_VERY_SHORT | HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_tightbun"

/decl/sprite_accessory/hair/coffeehouse
	name = "Coffee House Cut"
	icon_state = "hair_coffeehouse"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_coffeehouse"

/decl/sprite_accessory/hair/partfade
	name = "Parted Fade"
	icon_state = "hair_shavedpart"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_partfade"

/decl/sprite_accessory/hair/hightight
	name = "High and Tight"
	icon_state = "hair_hightight"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_hightight"

/decl/sprite_accessory/hair/rowbun
	name = "Row Bun"
	icon_state = "hair_rowbun"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_rowbun"

/decl/sprite_accessory/hair/regulationmohawk
	name = "Regulation Mohawk"
	icon_state = "hair_shavedmohawk"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_regulationmohawk"

/decl/sprite_accessory/hair/topknot
	name = "Topknot"
	icon_state = "hair_topknot"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_topknot"

/decl/sprite_accessory/hair/ronin
	name = "Ronin"
	icon_state = "hair_ronin"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_ronin"

/decl/sprite_accessory/hair/bowlcut2
	name = "Bowl2"
	icon_state = "hair_bowlcut2"
	uid = "acc_hair_bowl2"

/decl/sprite_accessory/hair/thinning
	name = "Thinning"
	icon_state = "hair_thinning"
	accessory_flags = HAIR_VERY_SHORT
	uid = "acc_hair_thinning"

/decl/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	icon_state = "hair_thinningfront"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_thinningfront"

/decl/sprite_accessory/hair/thinningback
	name = "Thinning Back"
	icon_state = "hair_thinningrear"
	accessory_flags = HAIR_VERY_SHORT | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_thinningback"

/decl/sprite_accessory/hair/manbun
	name = "Manbun"
	icon_state = "hair_manbun"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_manbun"

/decl/sprite_accessory/hair/leftsidecut
	name = "Left Sidecut"
	icon_state = "hair_leftside"
	uid = "acc_hair_leftsidecut"

/decl/sprite_accessory/hair/rightsidecut
	name = "Right Sidecut"
	icon_state = "hair_rightside"
	uid = "acc_hair_rightsidecut"

/decl/sprite_accessory/hair/slick
	name = "Slick"
	icon_state = "hair_slick"
	uid = "acc_hair_slick"

/decl/sprite_accessory/hair/messyhair
	name = "Messy"
	icon_state = "hair_messyhair"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_messyhair"

/decl/sprite_accessory/hair/averagejoe
	name = "Average Joe"
	icon_state = "hair_averagejoe"
	uid = "acc_hair_averagejoe"

/decl/sprite_accessory/hair/sideswept
	name = "Sideswept Hair"
	icon_state = "hair_sideswept"
	uid = "acc_hair_sideswept"

/decl/sprite_accessory/hair/mohawkshaved
	name = "Shaved Mohawk"
	icon_state = "hair_mohawkshaved"
	uid = "acc_hair_mohawkshaved"

/decl/sprite_accessory/hair/mohawkshaved2
	name = "Tight Shaved Mohawk"
	icon_state = "hair_mohawkshaved2"
	uid = "acc_hair_mohawkshaved2"

/decl/sprite_accessory/hair/mohawkshavednaomi
	name = "Naomi Mohawk"
	icon_state = "hair_mohawkshavednaomi"
	uid = "acc_hair_naomimohawk"

/decl/sprite_accessory/hair/amazon
	name = "Amazon"
	icon_state = "hair_amazon"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_amazon"

/decl/sprite_accessory/hair/straightlong
	name = "Straight Long"
	icon_state = "hair_straightlong"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_straightlong"

/decl/sprite_accessory/hair/marysue
	name = "Mary Sue"
	icon_state = "hair_marysue"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_marysue"

/decl/sprite_accessory/hair/messyhair2
	name = "Messy Hair 2"
	icon_state = "hair_messyhair2"
	uid = "acc_hair_messyhair2"

/decl/sprite_accessory/hair/buzzcut2
	name = "Buzzcut 2"
	icon_state = "hair_buzzcut2"
	uid = "acc_hair_buzzcut2"

/decl/sprite_accessory/hair/bighawk
	name = "Big Mohawk"
	icon_state = "hair_bighawk"
	uid = "acc_hair_bighawk"

/decl/sprite_accessory/hair/donutbun
	name = "Donut Bun"
	icon_state = "hair_donutbun"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_donutbun"

/decl/sprite_accessory/hair/gentle2
	name = "Gentle 2"
	icon_state = "hair_gentle2"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_gentle2"

/decl/sprite_accessory/hair/gentle2long
	name = "Gentle 2 Long"
	icon_state = "hair_gentle2long"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_gentle2long"

/decl/sprite_accessory/hair/trimrsidecut
	name = "Trimmed Right Sidecut"
	icon_state = "hair_rightside_trim"
	accessory_flags = HAIR_TIEABLE | HAIR_LOSS_VULNERABLE
	uid = "acc_hair_trimrightsidecut"

/decl/sprite_accessory/hair/doll
	name = "Doll"
	uid = "acc_hair_doll"
	icon_state = "hair_doll"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/darcy
	name = "Darcy"
	uid = "acc_hair_darcy"
	icon_state = "hair_darcy"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_VERY_SHORT

/decl/sprite_accessory/hair/antonio
	name = "Antonio"
	uid = "acc_hair_antonio"
	icon_state = "hair_antonio"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_VERY_SHORT

/decl/sprite_accessory/hair/bigcurls
	name = "Big Curls"
	uid = "acc_hair_bigcurls"
	icon_state = "hair_bigcurls"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/sweptfringe
	name = "Swept Fringe"
	uid = "acc_hair_sweptfringe"
	icon_state = "hair_sweptfringe"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/mialong
	name = "Mia Long"
	uid = "acc_hair_mialong"
	icon_state = "hair_mialong"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/mia
	name = "Mia"
	uid = "acc_hair_mia"
	icon_state = "hair_mia"

/decl/sprite_accessory/hair/roxy
	name = "Roxy"
	uid = "acc_hair_roxy"
	icon_state = "hair_roxy"

/decl/sprite_accessory/hair/sabitsuki
	name = "Sabitsuki"
	uid = "acc_hair_sabitsuki"
	icon_state = "hair_sabitsuki"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_VERY_SHORT

/decl/sprite_accessory/hair/rockstarcurls
	name = "Rockstar Curls"
	uid = "acc_hair_rockstarcurls"
	icon_state = "hair_rockstarcurls"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/proper
	name = "Proper"
	uid = "acc_hair_proper"
	icon_state = "hair_proper"

/decl/sprite_accessory/hair/shortflip
	name = "Short Flip"
	uid = "acc_hair_shortflip"
	icon_state = "hair_shortflip"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_VERY_SHORT

/decl/sprite_accessory/hair/afropuffdouble
	name = "Afropuff, Double"
	uid = "acc_hair_afropuffdouble"
	icon_state = "hair_afropuffdouble"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/afropuffleft
	name = "Afropuff, Left"
	uid = "acc_hair_afropuffleft"
	icon_state = "hair_afropuffleft"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/afropuffright
	name = "Afropuff, Right"
	uid = "acc_hair_afropuffright"
	icon_state = "hair_afropuffright"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/antenna
	name = "Antenna"
	uid = "acc_hair_antenna"
	icon_state = "hair_antenna"

/decl/sprite_accessory/hair/aradia
	name = "Aradia"
	uid = "acc_hair_aradia"
	icon_state = "hair_aradia"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/beachwave
	name = "Beachwave"
	uid = "acc_hair_beachwave"
	icon_state = "hair_beachwave"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/nia
	name = "Nia"
	uid = "acc_hair_nia"
	icon_state = "hair_nia"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/belenkotied
	name = "Belenko Tied"
	uid = "acc_hair_belenkotied"
	icon_state = "hair_belenkotied"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/eighties
	name = "80's"
	uid = "acc_hair_80s"
	icon_state = "hair_80s"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/overeyebowl
	name = "Overeye Bowl Cut"
	uid = "acc_hair_overeyebowl"
	icon_state = "hair_overeyebowl"

/decl/sprite_accessory/hair/business
	name = "Business Hair"
	uid = "acc_hair_business3"
	icon_state = "hair_business3"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_VERY_SHORT

/decl/sprite_accessory/hair/businessalt
	name = "Business Hair Alt"
	uid = "acc_hair_business4"
	icon_state = "hair_business4"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_VERY_SHORT

/decl/sprite_accessory/hair/cornbun
	name = "Cornbun"
	uid = "acc_hair_cornbun"
	icon_state = "hair_cornbun"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/jessica
	name = "Jessica"
	uid = "acc_hair_jessica"
	icon_state = "hair_jessica"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/country
	name = "Country"
	uid = "acc_hair_country"
	icon_state = "hair_country"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/himeup
	name = "Hime Updo"
	uid = "acc_hair_himeup"
	icon_state = "hair_himeup"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/dreadlong
	name = "Long Dreadlocks"
	uid = "acc_hair_dreadslong"
	icon_state = "hair_dreadslong"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/dreadlongalt
	name = "Long Dreadlocks Alt"
	uid = "acc_hair_dreadlongalt"
	icon_state = "hair_dreadlongalt"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/elize
	name = "Elize"
	uid = "acc_hair_elize"
	icon_state = "hair_elize"

/decl/sprite_accessory/hair/emofringe
	name = "Emo Fringe"
	uid = "acc_hair_emofringe"
	icon_state = "hair_emofringe"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/emoright
	name = "Emo Mid-length"
	uid = "acc_hair_emoright"
	icon_state = "hair_emoright"

/decl/sprite_accessory/hair/wisp
	name = "Wisp"
	uid = "acc_hair_wisp"
	icon_state = "hair_wisp"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/vriska
	name = "Vriska"
	uid = "acc_hair_vriska"
	icon_state = "hair_vriska"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/flipped
	name = "Flipped"
	uid = "acc_hair_flipped"
	icon_state = "hair_flipped"

/decl/sprite_accessory/hair/froofy_long
	name = "Froofy Long"
	uid = "acc_hair_froofy_long"
	icon_state = "hair_froofy_long"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/glossy
	name = "Glossy"
	uid = "acc_hair_glossy"
	icon_state = "hair_glossy"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/longsidepart
	name = "Long Side Part"
	uid = "acc_hair_longsidepart"
	icon_state = "hair_longsidepart"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/miles
	name = "Miles"
	uid = "acc_hair_miles"
	icon_state = "hair_miles"

/decl/sprite_accessory/hair/modern
	name = "Modern"
	uid = "acc_hair_modern"
	icon_state = "hair_modern"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/newyou
	name = "New You"
	uid = "acc_hair_newyou"
	icon_state = "hair_newyou"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/oxton
	name = "Oxton"
	uid = "acc_hair_oxton"
	icon_state = "hair_oxton"

/decl/sprite_accessory/hair/veryshortovereye
	name = "Very Short Overeye"
	uid = "acc_hair_veryshortovereye"
	icon_state = "hair_veryshortovereye"

/decl/sprite_accessory/hair/veryshortovereyealternate
	name = "Very Short Overeye Alt"
	uid = "acc_hair_veryshortovereyealternate"
	icon_state = "hair_veryshortovereyealternate"

/decl/sprite_accessory/hair/pixie
	name = "Pixie Cut"
	uid = "acc_hair_pixie"
	icon_state = "hair_pixie"

/decl/sprite_accessory/hair/sweepshave
	name = "Sweep Shaved"
	uid = "acc_hair_sweepshave"
	icon_state = "hair_sweepshave"

/decl/sprite_accessory/hair/suave
	name = "Suave"
	uid = "acc_hair_suave"
	icon_state = "hair_suave"

/decl/sprite_accessory/hair/suave2
	name = "Suave Alt"
	uid = "acc_hair_suave2"
	icon_state = "hair_suave2"

/decl/sprite_accessory/hair/protagonist
	name = "Slightly Long"
	uid = "acc_hair_protagonist"
	icon_state = "hair_protagonist"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/shouldersweep
	name = "Swept Shoulder"
	uid = "acc_hair_shouldersweep"
	icon_state = "hair_shouldersweep"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE

/decl/sprite_accessory/hair/tresshoulder
	name = "Shoulder Tress"
	uid = "acc_hair_tresshoulder"
	icon_state = "hair_tressshoulder"
	accessory_flags = HAIR_LOSS_VULNERABLE | HAIR_TIEABLE
