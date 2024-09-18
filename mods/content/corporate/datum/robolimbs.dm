/decl/bodytype/prosthetic/unbranded/muscleplast
	name = "Unbranded - Muscleplast"
	desc = "A high-end custom arm resembling metallic muscle, with polished plates overlaid on some segments and visible connecting cable at the joints."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/unbranded/muscleplast.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_unbranded_muscleplast"
	has_limbs = list(BP_L_HAND, BP_L_ARM, BP_R_ARM, BP_R_HAND)

/decl/bodytype/prosthetic/bishop
	name = "Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/bishop/bishop_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_bishop"

/decl/bodytype/prosthetic/bishop/rook
	name = "Bishop - Rook"
	desc = "This limb has a solid plastic casing with blue lights along it."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/bishop/bishop_rook.dmi'
	has_eyes = FALSE
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_bishop_rook"

/decl/bodytype/prosthetic/bishop/glyph
	name = "Bishop - Glyph"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/bishop/bishop_glyph.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_bishop_glyph"
	has_limbs = list(BP_HEAD)

/decl/bodytype/prosthetic/cybersolutions
	name = "Cyber Solutions"
	desc = "This limb is grey and utilitarian, with little in the way of aesthetic flourish."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/cybersolutions/cybersolutions_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_cybersolutions"

/decl/bodytype/prosthetic/cybersolutions/wight
	name = "Cyber Solutions - Wight"
	desc = "This limb has cheap plastic panels mounted on grey metal."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/cybersolutions/cybersolutions_wight.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_cybersolutions_wight"

/decl/bodytype/prosthetic/cybersolutions/outdated
	name = "Cyber Solutions - Outdated"
	desc = "This limb is of severely outdated design; there's no way it's comfortable or very functional to use."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/cybersolutions/cybersolutions_outdated.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_cybersolutions_outdated"

/decl/bodytype/prosthetic/cybersolutions/array
	name = "Cyber Solutions - Array"
	desc = "This limb is simple and functional; an array of sensors on a featureless case."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/cybersolutions/cybersolutions_array.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_cybersolutions_array"
	has_limbs = list(BP_HEAD)

/decl/bodytype/prosthetic/einstein
	name = "Einstein Engines"
	desc = "This limb is lightweight with a sleek high-contrast design."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/einstein/einstein_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_einstein"

/decl/bodytype/prosthetic/grayson
	name = "Grayson"
	desc = "This limb has a sturdy and hard-wearing build to it."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/grayson/grayson_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_grayson"

/decl/bodytype/prosthetic/grayson/reinforced
	name = "Grayson - Reinforced"
	desc = "This limb has a sturdy and hard-wearing build to it, with additional reinforced plating."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/grayson/grayson_reinforced.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_grayson_reinforced"
	has_limbs = list(BP_HEAD)

/decl/bodytype/prosthetic/hephaestus
	name = "Hephaestus Industries"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/hephaestus/hephaestus_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_hephaestus"

/decl/bodytype/prosthetic/hephaestus/titan
	name = "Hephaestus - Athena"
	desc = "This limb has a casing with an olive drab finish, providing a militaristic look."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/hephaestus/hephaestus_titan.dmi'
	has_eyes = FALSE
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_hephaestus_titan"

/decl/bodytype/prosthetic/hephaestus/frontier
	name = "Hephaestus - Athena"
	desc = "A rugged prosthetic head featuring the standard Hephaestus theme, a visor and an external display."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/hephaestus/hephaestus_frontier.dmi'
	has_eyes = FALSE
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_hephaestus_frontier"
	has_limbs = list(BP_HEAD)


/decl/bodytype/prosthetic/wardtakahashi
	name = "Ward-Takahashi"
	desc = "This limb features sleek black and white polymers."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	body_flags = BODY_FLAG_NO_DNA | BODY_FLAG_NO_PAIN | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_wardtakahashi"

/decl/bodytype/prosthetic/wardtakahashi/spirit
	name = "Ward-Takahashi - Spirit"
	desc = "This limb has a sleek black and white polymer finish."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/zenghu/zenghu_spirit.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_wardtakahashi_spirit"

/decl/bodytype/prosthetic/wardtakahashi/economy
	name = "Unbranded - Protez"
	desc = "A simple robotic limb with retro design. Seems rather stiff."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/wardtakahashi/wardtakahashi_economy.dmi'
	uid = "bodytype_prosthetic_wardtakahashi_econ"

/decl/bodytype/prosthetic/wardtakahashi/shroud
	name = "Ward-Takahashi - Shroud"
	desc = "This limb features sleek black and white polymers. A visor wraps around an otherwise featureless head."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/wardtakahashi/wardtakahashi_shroud.dmi'
	uid = "bodytype_prosthetic_wardtakahashi_shroud"

/decl/bodytype/prosthetic/morpheus
	name = "Morpheus"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/steel
	uid = "bodytype_prosthetic_morpheus"

/decl/bodytype/prosthetic/morpheus/zenith
	name = "Morpheus - Zenith"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_zenith.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_morpheus_zenith"
	has_limbs = list(BP_HEAD)

/decl/bodytype/prosthetic/morpheus/skeletoncrew
	name = "Morpheus - Skeleton Crew"
	desc = "This limb is simple and functional; it's basically just a case for a brain."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_skeletoncrew.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_morpheus_skeletoncrew"
	has_limbs = list(BP_HEAD)

/decl/bodytype/prosthetic/morpheus/mantis
	name = "Unbranded - Mantis Prosis"
	desc = "This limb has a casing of sleek black metal and repulsive insectile design."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_mantis.dmi'
	has_eyes = FALSE
	uid = "bodytype_prosthetic_morpheus_mantis"

/decl/bodytype/prosthetic/veymed
	name = "Vey-Med (Feminine)"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/veymed/veymed_female.dmi'
	appearance_flags = HAS_SKIN_TONE_NORMAL | HAS_UNDERWEAR | HAS_EYE_COLOR
	body_flags = BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	bodytype_category = BODYTYPE_HUMANOID
	// todo: add synthflesh material?
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_veymed_fem"

/decl/bodytype/prosthetic/veymed/masculine
	name = "Vey-Med (Masculine)"
	icon_base = 'mods/content/corporate/icons/cyberlimbs/veymed/veymed_male.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_veymed_masc"

/decl/bodytype/prosthetic/shellguard
	name = "Shellguard"
	desc = "This limb has a sturdy and heavy build to it."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/shellguard/shellguard_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_shellguard"

/decl/bodytype/prosthetic/xion
	name = "Xion"
	desc = "This limb has a minimalist black and red casing."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/xion/xion_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_xion"

/decl/bodytype/prosthetic/xion/econo
	name = "Xion - Hull"
	desc = "This skeletal mechanical limb has a minimalist black and red casing."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/xion/xion_econo.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_xion_econ"

/decl/bodytype/prosthetic/xion/breach
	name = "Xion - Breach"
	desc = "This limb has a minimalist black and red casing. Looks a bit menacing."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/xion/xion_breach.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_xion_breach"
	has_limbs = list(BP_HEAD)

/decl/bodytype/prosthetic/xion/whiteout
	name = "Xion - Whiteout"
	desc = "This limb has a minimalist black and white casing."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/xion/xion_whiteout.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_xion_whiteout"

/decl/bodytype/prosthetic/xion/whiteout/breach
	name = "Xion - Whiteout Breach"
	desc = "This limb has a minimalist black and white casing. Looks a bit menacing."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/xion/xion_whiteout_breach.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_xion_whiteout_breach"
	has_limbs = list(BP_HEAD)

/decl/bodytype/prosthetic/nanotrasen
	name = "NanoTrasen"
	desc = "A simple but efficient polymer robotic limb, created by NanoTrasen."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/nanotrasen/nanotrasen_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/organic/plastic
	uid = "bodytype_prosthetic_nanotrasen"

/decl/bodytype/prosthetic/nanotrasen/metro
	name = "NanoTrasen - Metro (Feminine)"
	desc = "A simple but efficient polymer robotic limb, created by NanoTrasen. It has a hard, feminine outer shell."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/nanotrasen/nanotrasen_metro.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_nanotrasen_metro"

/decl/bodytype/prosthetic/nanotrasen/metro/masc
	name = "NanoTrasen - Metro (Masculine)"
	desc = "A simple but efficient polymer robotic limb, created by NanoTrasen. It has a hard, masculine outer shell."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/nanotrasen/nanotrasen_metro_masc.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_nanotrasen_metro_masc"

/decl/bodytype/prosthetic/zenghu
	name = "Zeng-hu (Feminine)"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/zenghu/zenghu_fem.dmi'
	appearance_flags = HAS_SKIN_TONE_NORMAL | HAS_UNDERWEAR | HAS_EYE_COLOR
	body_flags = BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/organic/plastic
	uid = "bodytype_prosthetic_zenghu_fem"

/decl/bodytype/prosthetic/zenghu/masculine
	name = "Zeng-hu (Masculine)"
	icon_base = 'mods/content/corporate/icons/cyberlimbs/zenghu/zenghu_masc.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	uid = "bodytype_prosthetic_zenghu_masc"

/decl/bodytype/prosthetic/uesseka
	name = "Uesseka Prototyping Ltd. (Orange)"
	desc = "This limb seems meticulously hand-crafted, and distinctly Unathi in design."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/uesseka/uesseka_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_SECONDARY
	)
	uid = "bodytype_prosthetic_unathi"

/decl/bodytype/prosthetic/uesseka/red
	name = "Uesseka Prototyping Ltd. (Red)"
	icon_base = 'mods/content/corporate/icons/cyberlimbs/uesseka/uesseka_red.dmi'
	uid = "bodytype_prosthetic_unathi_red"

DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/nanotrasen,                    nanotrasen)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/nanotrasen/metro,              nanotrasenmetro)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/nanotrasen/metro/masc,         nanotrasenmetromasc)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/xion,                          xion)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/xion/econo,                    xionecon)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/xion/breach,                   xionbreach)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/xion/whiteout,                 xionwhiteout)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/xion/whiteout/breach,          xionwhiteoutbreach)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/wardtakahashi,                 wardtakahashi)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/wardtakahashi/spirit,          wardtakahashispirit)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/wardtakahashi/shroud,          wardtakahashishroud)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/wardtakahashi/economy,         wardtakahashiecon)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/bishop,                        bishop)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/bishop/rook,                   bishoprook)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/bishop/glyph,                  bishopglyph)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/unbranded/muscleplast,	     muscleplast)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/morpheus/mantis,               mantis)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/cybersolutions,                cybersolutions)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/cybersolutions/wight,          cybersolutionswight)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/cybersolutions/outdated,       cybersolutionsoutdated)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/cybersolutions/array,          cybersolutionsarray)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/einstein,       			     einstein)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/grayson,       			     grayson)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/grayson/reinforced,            graysonreinforced)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/hephaestus,                    hephaestus)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/hephaestus/titan,              hephaestustitan)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/hephaestus/frontier,           hephaestusfrontier)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/morpheus,                      morpheus)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/morpheus/zenith,               morpheuszenith)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/morpheus/skeletoncrew,         morpheusskeletoncrew)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/uesseka,         				 uesseka)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/uesseka/red,         			 uessekared)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/veymed,        				 veymedfem)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/veymed/masculine,        		 veymedmasc)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/zenghu,        				 zenghufem)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/zenghu/masculine,        		 zenghumasc)


//Unfortunately, this is alphabetical:

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/morpheus/mantis,          mantis,                 0, "mantis")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/wardtakahashi/economy,    wardtakahashiecon,      0, "wardtakahashiecon")

/decl/trait/prosthetic_limb/right_arm/muscleplast
    model = /decl/bodytype/prosthetic/unbranded/muscleplast
    parent = /decl/trait/prosthetic_limb/right_arm
    uid = "trait_prosthetic_right_arm_muscleplast"

/decl/trait/prosthetic_limb/right_hand/muscleplast
    model = /decl/bodytype/prosthetic/unbranded/muscleplast
    parent = /decl/trait/prosthetic_limb/right_hand
    uid = "trait_prosthetic_right_hand_muscleplast"

/decl/trait/prosthetic_limb/left_arm/muscleplast
    model = /decl/bodytype/prosthetic/unbranded/muscleplast
    parent = /decl/trait/prosthetic_limb/left_arm
    uid = "trait_prosthetic_left_arm_muscleplast"

/decl/trait/prosthetic_limb/left_hand/muscleplast
    model = /decl/bodytype/prosthetic/unbranded/muscleplast
    parent = /decl/trait/prosthetic_limb/left_hand
    uid = "trait_prosthetic_left_hand_muscleplast"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/bishop,                   bishop,                 0, "bishop")

/decl/trait/prosthetic_limb/head/bishop_glyph
    model = /decl/bodytype/prosthetic/bishop/glyph
    parent = /decl/trait/prosthetic_limb/head
    uid = "trait_prosthetic_head_bishop_glyph"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/bishop/rook,              bishoprook,             0, "bishoprook")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/cybersolutions,           cybersolutions,         0, "cybersolutions")

/decl/trait/prosthetic_limb/head/cybersolutions_array
    model = /decl/bodytype/prosthetic/cybersolutions/array
    parent = /decl/trait/prosthetic_limb/head
    uid = "trait_prosthetic_head_cybersolutions_array"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/cybersolutions/outdated,  cybersolutionsoutdated, 0, "cybersolutionsoutdated")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/cybersolutions/wight,     cybersolutionswight,    0, "cybersolutionswight")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/einstein,                 einstein,               0, "einstein")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/grayson,                  grayson,                0, "grayson")

/decl/trait/prosthetic_limb/head/grayson_reinforced
    model = /decl/bodytype/prosthetic/grayson/reinforced
    parent = /decl/trait/prosthetic_limb/head
    uid = "trait_prosthetic_head_grayson_reinforced"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/hephaestus,               hephaestus,             0, "hephaestus")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/hephaestus/titan,         hephaestustitan,        0, "hephaestustitan")

/decl/trait/prosthetic_limb/head/hephaestus_frontier
    model = /decl/bodytype/prosthetic/hephaestus/frontier
    parent = /decl/trait/prosthetic_limb/head
    uid = "trait_prosthetic_head_hephaestus_frontier"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/morpheus,                 morpheus,               0, "morpheus")

/decl/trait/prosthetic_limb/head/morpheus_skeletoncrew
    model = /decl/bodytype/prosthetic/morpheus/skeletoncrew
    parent = /decl/trait/prosthetic_limb/head
    uid = "trait_prosthetic_head_morpheus_skeletoncrew"

/decl/trait/prosthetic_limb/head/morpheus_zenith
    model = /decl/bodytype/prosthetic/morpheus/zenith
    parent = /decl/trait/prosthetic_limb/head
    uid = "trait_prosthetic_head_morpheus_zenith"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/nanotrasen,               nanotrasen,             0, "nanotrasen")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/nanotrasen/metro,         nanotrasenmetro,        0, "nanotrasenmetro")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/nanotrasen/metro/masc,    nanotrasenmetromasc,    0, "nanotrasenmetromasc")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/uesseka,                  uesseka,                0, "uesseka")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/uesseka/red,              uessekared,             0, "uessekared")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/veymed,                 	 veymedfem,              0, "veymedfem")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/veymed/masculine,         veymedmasc,             0, "veymedmasc")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/wardtakahashi,            wardtakahashi,          0, "wardtakahashi")

/decl/trait/prosthetic_limb/head/wardtakahashi_shroud
    model = /decl/bodytype/prosthetic/wardtakahashi/shroud
    parent = /decl/trait/prosthetic_limb/head
    uid = "trait_prosthetic_head_wardtakahashi_shroud"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/wardtakahashi/spirit,     wardtakahashispirit,    0, "wardtakahashispirit")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/xion,                     xion,                   0, "xion")

/decl/trait/prosthetic_limb/head/xion_breach
    model = /decl/bodytype/prosthetic/xion/breach
    parent = /decl/trait/prosthetic_limb/head
    uid = "trait_prosthetic_head_xion_breach"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/xion/econo,               xionecon,               0, "xionecon")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/xion/whiteout,            xionwhiteout,           0, "xionwhiteout")

/decl/trait/prosthetic_limb/head/xion_whiteout_breach
    model = /decl/bodytype/prosthetic/xion/whiteout/breach
    parent = /decl/trait/prosthetic_limb/head
    uid = "trait_prosthetic_head_xion_whiteout_breach"

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/zenghu,                 	 zenuhufem,              0, "zenghufem")
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/zenghu/masculine,         zenuhumasc,             0, "zenghumasc")
