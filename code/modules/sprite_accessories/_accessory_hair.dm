/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/decl/sprite_accessory/hair
	abstract_type = /decl/sprite_accessory/hair
	icon = 'icons/mob/human_races/species/human/hair.dmi'
	hidden_by_gear_slot = slot_head_str
	hidden_by_gear_flag = BLOCK_HEAD_HAIR
	body_parts          = list(BP_HEAD)

/decl/sprite_accessory/hair/get_hidden_substitute()
	if(flags & VERY_SHORT)
		return src
	return GET_DECL(/decl/sprite_accessory/hair/short)

/decl/sprite_accessory/hair/bald
	name = "Bald"
	icon_state = "bald"
	flags = VERY_SHORT | HAIR_BALD
	bodytypes_allowed = null
	bodytypes_denied = null
	species_allowed = null
	subspecies_allowed = null
	bodytype_categories_allowed = null
	bodytype_categories_denied = null
	body_flags_allowed = null
	body_flags_denied = null
	uid = "acc_hair_bald"

/decl/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you
	flags = VERY_SHORT
	uid = "acc_hair_short"

/decl/sprite_accessory/hair/twintail
	name = "Twintail"
	icon_state = "hair_twintail"
	flags = HAIR_TIEABLE
	uid = "acc_hair_twintail"

/decl/sprite_accessory/hair/short2
	name = "Short Hair 2"
	icon_state = "hair_shorthair3"
	uid = "acc_hair_short2"

/decl/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "hair_c"
	flags = VERY_SHORT
	uid = "acc_hair_cut"

/decl/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "hair_flair"
	flags = HAIR_TIEABLE
	uid = "acc_hair_flair"

/decl/sprite_accessory/hair/long
	name = "Shoulder-length Hair"
	icon_state = "hair_b"
	flags = HAIR_TIEABLE
	uid = "acc_hair_shoulder"

/decl/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "hair_vlong"
	flags = HAIR_TIEABLE
	uid = "acc_hair_long"

/decl/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "hair_longest"
	flags = HAIR_TIEABLE
	uid = "acc_hair_verylong"

/decl/sprite_accessory/hair/longfringe
	name = "Long Fringe"
	icon_state = "hair_longfringe"
	flags = HAIR_TIEABLE
	uid = "acc_hair_longfringe"

/decl/sprite_accessory/hair/longestalt
	name = "Longer Fringe"
	icon_state = "hair_vlongfringe"
	flags = HAIR_TIEABLE
	uid = "acc_hair_longestalt"

/decl/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "hair_halfbang"
	uid = "acc_hair_halfbang"

/decl/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair Alt"
	icon_state = "hair_halfbang_alt"
	uid = "acc_hair_halfbangalt"

/decl/sprite_accessory/hair/ponytail1
	name = "Ponytail 1"
	icon_state = "hair_ponytail"
	flags = HAIR_TIEABLE
	uid = "acc_hair_ponytail1"

/decl/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "hair_pa"
	flags = HAIR_TIEABLE
	uid = "acc_hair_ponytail2"

/decl/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "hair_ponytail3"
	flags = HAIR_TIEABLE
	uid = "acc_hair_ponytail3"

/decl/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	icon_state = "hair_ponytail4"
	flags = HAIR_TIEABLE
	uid = "acc_hair_ponytail4"

/decl/sprite_accessory/hair/ponytail5
	name = "Ponytail 5"
	icon_state = "hair_ponytail5"
	flags = HAIR_TIEABLE
	uid = "acc_hair_ponytail5"

/decl/sprite_accessory/hair/ponytail6
	name = "Ponytail 6"
	icon_state = "hair_ponytail6"
	flags = HAIR_TIEABLE
	uid = "acc_hair_ponytail6"

/decl/sprite_accessory/hair/sideponytail
	name = "Side Ponytail"
	icon_state = "hair_stail"
	flags = HAIR_TIEABLE
	uid = "acc_hair_sideponytail"

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
	flags = VERY_SHORT
	uid = "acc_hair_sleeze"

/decl/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "hair_quiff"
	uid = "acc_hair_quiff"

/decl/sprite_accessory/hair/bedhead
	name = "Bedhead"
	icon_state = "hair_bedhead"
	uid = "acc_hair_bedhead"

/decl/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	icon_state = "hair_bedheadv2"
	uid = "acc_hair_bedhead2"

/decl/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	icon_state = "hair_bedheadv3"
	flags = HAIR_TIEABLE
	uid = "acc_hair_bedhead3"

/decl/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "hair_beehive"
	flags = HAIR_TIEABLE
	uid = "acc_hair_beehive"

/decl/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "hair_beehive2"
	uid = "acc_hair_beehive2"

/decl/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "hair_bobcurl"
	flags = HAIR_TIEABLE
	uid = "acc_hair_bobcurl"

/decl/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "hair_bobcut"
	flags = HAIR_TIEABLE
	uid = "acc_hair_bob"

/decl/sprite_accessory/hair/bobcutalt
	name = "Chin Length Bob"
	icon_state = "hair_bobcutalt"
	flags = HAIR_TIEABLE
	uid = "acc_hair_bobcutalt"

/decl/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "hair_bowlcut"
	uid = "acc_hair_bowl"

/decl/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "hair_buzzcut"
	flags = VERY_SHORT
	uid = "acc_hair_buzz"

/decl/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "hair_crewcut"
	flags = VERY_SHORT
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
	flags = HAIR_TIEABLE
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
	flags = VERY_SHORT
	uid = "acc_hair_rows"

/decl/sprite_accessory/hair/rows2
	name = "Rows 2"
	icon_state = "hair_rows2"
	flags = VERY_SHORT | HAIR_TIEABLE
	uid = "acc_hair_rows2"

/decl/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "hair_sargeant"
	flags = VERY_SHORT
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
	flags = HAIR_TIEABLE
	uid = "acc_hair_longemo"

/decl/sprite_accessory/hair/shortovereye
	name = "Overeye Short"
	icon_state = "hair_shortovereye"
	flags = HAIR_TIEABLE
	uid = "acc_hair_overeye_short"

/decl/sprite_accessory/hair/longovereye
	name = "Overeye Long"
	icon_state = "hair_longovereye"
	flags = HAIR_TIEABLE
	uid = "acc_hair_overeye_long"

/decl/sprite_accessory/hair/flow
	name = "Flow Hair"
	icon_state = "hair_f"
	uid = "acc_hair_flow"

/decl/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "hair_feather"
	flags = HAIR_TIEABLE
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
	flags = HAIR_TIEABLE
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
	flags = HAIR_TIEABLE
	uid = "acc_hair_kagami"

/decl/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "hair_himecut"
	flags = HAIR_TIEABLE
	uid = "acc_hair_himecut"

/decl/sprite_accessory/hair/shorthime
	name = "Short Hime Cut"
	icon_state = "hair_shorthime"
	flags = HAIR_TIEABLE
	uid = "acc_hair_shorthime"

/decl/sprite_accessory/hair/grandebraid
	name = "Grande Braid"
	icon_state = "hair_grande"
	flags = HAIR_TIEABLE
	uid = "acc_hair_grande"

/decl/sprite_accessory/hair/mbraid
	name = "Medium Braid"
	icon_state = "hair_shortbraid"
	flags = HAIR_TIEABLE
	uid = "acc_hair_mbraid"

/decl/sprite_accessory/hair/braid2
	name = "Long Braid"
	icon_state = "hair_hbraid"
	flags = HAIR_TIEABLE
	uid = "acc_hair_braid2"

/decl/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "hair_odango"
	flags = HAIR_TIEABLE
	uid = "acc_hair_odango"

/decl/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "hair_ombre"
	flags = HAIR_TIEABLE
	uid = "acc_hair_ombre"

/decl/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "hair_updo"
	flags = HAIR_TIEABLE
	uid = "acc_hair_updo"

/decl/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "hair_skinhead"
	flags = VERY_SHORT
	uid = "acc_hair_skinhead"

/decl/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "hair_e"
	flags = VERY_SHORT
	uid = "acc_hair_balding"

/decl/sprite_accessory/hair/familyman
	name = "The Family Man"
	icon_state = "hair_thefamilyman"
	uid = "acc_hair_familyman"

/decl/sprite_accessory/hair/mahdrills
	name = "Drillruru"
	icon_state = "hair_drillruru"
	flags = HAIR_TIEABLE
	uid = "acc_hair_drillruru"

/decl/sprite_accessory/hair/fringetail
	name = "Fringetail"
	icon_state = "hair_fringetail"
	flags = HAIR_TIEABLE
	uid = "acc_hair_fringetail"

/decl/sprite_accessory/hair/dandypomp
	name = "Dandy Pompadour"
	icon_state = "hair_dandypompadour"
	uid = "acc_hair_dandypomp"

/decl/sprite_accessory/hair/poofy
	name = "Poofy"
	icon_state = "hair_poofy"
	flags = HAIR_TIEABLE
	uid = "acc_hair_poofy"

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
	flags = HAIR_TIEABLE
	uid = "acc_hair_nitori"

/decl/sprite_accessory/hair/joestar
	name = "Joestar"
	icon_state = "hair_joestar"
	uid = "acc_hair_joestar"

/decl/sprite_accessory/hair/volaju
	name = "Volaju"
	icon_state = "hair_volaju"
	flags = HAIR_TIEABLE
	uid = "acc_hair_volaju"

/decl/sprite_accessory/hair/longeralt2
	name = "Long Hair Alt 2"
	icon_state = "hair_longeralt2"
	flags = HAIR_TIEABLE
	uid = "acc_hair_longeralt2"

/decl/sprite_accessory/hair/shortbangs
	name = "Short Bangs"
	icon_state = "hair_shortbangs"
	uid = "acc_hair_shortbangs"

/decl/sprite_accessory/hair/shavedbun
	name = "Shaved Bun"
	icon_state = "hair_shavedbun"
	flags = HAIR_TIEABLE
	uid = "acc_hair_shavedbun"

/decl/sprite_accessory/hair/halfshaved
	name = "Half-Shaved"
	icon_state = "hair_halfshaved"
	flags = HAIR_TIEABLE
	uid = "acc_hair_halfshaved"

/decl/sprite_accessory/hair/halfshavedemo
	name = "Half-Shaved Emo"
	icon_state = "hair_halfshavedemo"
	flags = HAIR_TIEABLE
	uid = "acc_hair_halfshavedemo"

/decl/sprite_accessory/hair/longsideemo
	name = "Long Side Emo"
	icon_state = "hair_longsideemo"
	flags = HAIR_TIEABLE
	uid = "acc_hair_longsideemo"

/decl/sprite_accessory/hair/bun
	name = "Low Bun"
	icon_state = "hair_bun"
	flags = HAIR_TIEABLE
	uid = "acc_hair_lowbun"

/decl/sprite_accessory/hair/bun2
	name = "High Bun"
	icon_state = "hair_bun2"
	flags = HAIR_TIEABLE
	uid = "acc_hair_highbun"

/decl/sprite_accessory/hair/doublebun
	name = "Double-Bun"
	icon_state = "hair_doublebun"
	flags = HAIR_TIEABLE
	uid = "acc_hair_doublebun"

/decl/sprite_accessory/hair/lowfade
	name = "Low Fade"
	icon_state = "hair_lowfade"
	flags = VERY_SHORT
	uid = "acc_hair_lowfade"

/decl/sprite_accessory/hair/medfade
	name = "Medium Fade"
	icon_state = "hair_medfade"
	flags = VERY_SHORT
	uid = "acc_hair_medfade"

/decl/sprite_accessory/hair/highfade
	name = "High Fade"
	icon_state = "hair_highfade"
	flags = VERY_SHORT
	uid = "acc_hair_highfade"

/decl/sprite_accessory/hair/baldfade
	name = "Balding Fade"
	icon_state = "hair_baldfade"
	flags = VERY_SHORT
	uid = "acc_hair_baldfade"

/decl/sprite_accessory/hair/nofade
	name = "Regulation Cut"
	icon_state = "hair_nofade"
	flags = VERY_SHORT
	uid = "acc_hair_nofade"

/decl/sprite_accessory/hair/trimflat
	name = "Trimmed Flat Top"
	icon_state = "hair_trimflat"
	flags = VERY_SHORT
	uid = "acc_hair_trimflat"

/decl/sprite_accessory/hair/shaved
	name = "Shaved"
	icon_state = "hair_shaved"
	flags = VERY_SHORT
	uid = "acc_hair_shaved"

/decl/sprite_accessory/hair/trimmed
	name = "Trimmed"
	icon_state = "hair_trimmed"
	flags = VERY_SHORT
	uid = "acc_hair_trimmed"

/decl/sprite_accessory/hair/tightbun
	name = "Tight Bun"
	icon_state = "hair_tightbun"
	flags = VERY_SHORT | HAIR_TIEABLE
	uid = "acc_hair_tightbun"

/decl/sprite_accessory/hair/coffeehouse
	name = "Coffee House Cut"
	icon_state = "hair_coffeehouse"
	flags = VERY_SHORT
	uid = "acc_hair_coffeehouse"

/decl/sprite_accessory/hair/undercut
	name = "Undercut"
	icon_state = "hair_undercut"
	flags = VERY_SHORT
	uid = "acc_hair_undercut"

/decl/sprite_accessory/hair/partfade
	name = "Parted Fade"
	icon_state = "hair_shavedpart"
	flags = VERY_SHORT
	uid = "acc_hair_partfade"

/decl/sprite_accessory/hair/hightight
	name = "High and Tight"
	icon_state = "hair_hightight"
	flags = VERY_SHORT
	uid = "acc_hair_hightight"

/decl/sprite_accessory/hair/rowbun
	name = "Row Bun"
	icon_state = "hair_rowbun"
	flags = HAIR_TIEABLE
	uid = "acc_hair_rowbun"

/decl/sprite_accessory/hair/rowdualbraid
	name = "Row Dual Braid"
	icon_state = "hair_rowdualtail"
	flags = HAIR_TIEABLE
	uid = "acc_hair_rowdualbraid"

/decl/sprite_accessory/hair/rowbraid
	name = "Row Braid"
	icon_state = "hair_rowbraid"
	flags = HAIR_TIEABLE
	uid = "acc_hair_rowbraid"

/decl/sprite_accessory/hair/regulationmohawk
	name = "Regulation Mohawk"
	icon_state = "hair_shavedmohawk"
	flags = VERY_SHORT
	uid = "acc_hair_regulationmohawk"

/decl/sprite_accessory/hair/topknot
	name = "Topknot"
	icon_state = "hair_topknot"
	flags = HAIR_TIEABLE
	uid = "acc_hair_topknot"

/decl/sprite_accessory/hair/ronin
	name = "Ronin"
	icon_state = "hair_ronin"
	flags = HAIR_TIEABLE
	uid = "acc_hair_ronin"

/decl/sprite_accessory/hair/bowlcut2
	name = "Bowl2"
	icon_state = "hair_bowlcut2"
	uid = "acc_hair_bowl2"

/decl/sprite_accessory/hair/thinning
	name = "Thinning"
	icon_state = "hair_thinning"
	flags = VERY_SHORT
	uid = "acc_hair_thinning"

/decl/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	icon_state = "hair_thinningfront"
	flags = VERY_SHORT
	uid = "acc_hair_thinningfront"

/decl/sprite_accessory/hair/thinningback
	name = "Thinning Back"
	icon_state = "hair_thinningrear"
	flags = VERY_SHORT
	uid = "acc_hair_thinningback"

/decl/sprite_accessory/hair/manbun
	name = "Manbun"
	icon_state = "hair_manbun"
	flags = HAIR_TIEABLE
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
	flags = HAIR_TIEABLE
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
	flags = HAIR_TIEABLE
	uid = "acc_hair_amazon"

/decl/sprite_accessory/hair/straightlong
	name = "Straight Long"
	icon_state = "hair_straightlong"
	flags = HAIR_TIEABLE
	uid = "acc_hair_straightlong"

/decl/sprite_accessory/hair/marysue
	name = "Mary Sue"
	icon_state = "hair_marysue"
	flags = HAIR_TIEABLE
	uid = "acc_hair_marysue"

/decl/sprite_accessory/hair/messyhair2
	name = "Messy Hair 2"
	icon_state = "hair_messyhair2"
	uid = "acc_hair_messyhair2"

/decl/sprite_accessory/hair/buzzcut2
	name = "Buzzcut 2"
	icon_state = "hair_buzzcut2"
	uid = "acc_hair_buzzcut2"

/decl/sprite_accessory/hair/sideundercut
	name = "Side Undercut"
	icon_state = "hair_sideundercut"
	flags = VERY_SHORT
	uid = "acc_hair_sideundercut"

/decl/sprite_accessory/hair/bighawk
	name = "Big Mohawk"
	icon_state = "hair_bighawk"
	uid = "acc_hair_bighawk"

/decl/sprite_accessory/hair/donutbun
	name = "Donut Bun"
	icon_state = "hair_donutbun"
	flags = HAIR_TIEABLE
	uid = "acc_hair_donutbun"

/decl/sprite_accessory/hair/gentle2
	name = "Gentle 2"
	icon_state = "hair_gentle2"
	flags = HAIR_TIEABLE
	uid = "acc_hair_gentle2"

/decl/sprite_accessory/hair/gentle2long
	name = "Gentle 2 Long"
	icon_state = "hair_gentle2long"
	flags = HAIR_TIEABLE
	uid = "acc_hair_gentle2long"

/decl/sprite_accessory/hair/trimrsidecut
	name = "Trimmed Right Sidecut"
	icon_state = "hair_rightside_trim"
	flags = HAIR_TIEABLE
	uid = "acc_hair_trimrightsidecut"
