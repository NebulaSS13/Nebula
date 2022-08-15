/decl/bodytype/prosthetic/bishop
	name = "Bishop"
	prosthetic_limb_desc = "This limb has a white polymer casing with blue holo-displays."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/bishop/bishop_main.dmi'

/decl/bodytype/prosthetic/bishop/rook
	name = "Bishop Rook"
	prosthetic_limb_desc = "This limb has a polished metallic casing and a holographic face emitter."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/bishop/bishop_rook.dmi'
	vision_organ = null

/decl/bodytype/prosthetic/hephaestus
	name = "Hephaestus Industries"
	prosthetic_limb_desc = "This limb has a militaristic black and green casing with gold stripes."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/hephaestus/hephaestus_main.dmi'

/decl/bodytype/prosthetic/hephaestus/titan
	name = "Hephaestus Titan"
	prosthetic_limb_desc = "This limb has a casing of an olive drab finish, providing a reinforced housing look."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/hephaestus/hephaestus_titan.dmi'
	vision_organ = null

/decl/bodytype/prosthetic/zenghu/spirit
	name = "Zeng-Hu Spirit"
	prosthetic_limb_desc = "This limb has a sleek black and white polymer finish."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/zenghu/zenghu_spirit.dmi'

/decl/bodytype/prosthetic/xion/econo
	name = "Xion Econ"
	prosthetic_limb_desc = "This skeletal mechanical limb has a minimalist black and red casing."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/xion/xion_econo.dmi'

/decl/bodytype/prosthetic/wardtakahashi
	name = "Ward-Takahashi"
	prosthetic_limb_desc = "This limb features sleek black and white polymers."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	body_flags = BODY_FLAG_NO_PAIN | BODY_FLAG_CAN_INGEST_REAGENTS

/decl/bodytype/prosthetic/morpheus
	name = "Morpheus"
	prosthetic_limb_desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_main.dmi'

/decl/bodytype/prosthetic/mantis
	name = "Morpheus Mantis"
	prosthetic_limb_desc = "This limb has a casing of sleek black metal and repulsive insectile design."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_mantis.dmi'
	vision_organ = null

/decl/bodytype/prosthetic/veymed
	name = "Vey-Med (Feminine)"
	prosthetic_limb_desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/veymed/veymed_female.dmi'
	body_flags = BODY_FLAG_NO_PAIN | BODY_FLAG_CAN_INGEST_REAGENTS
	body_appearance_flags = HAS_SKIN_TONE

/decl/bodytype/prosthetic/veymed/masculine
	name = "Vey-Med (Masculine)"
	icon_base = 'mods/content/corporate/icons/cyberlimbs/veymed/veymed_male.dmi'

/decl/bodytype/prosthetic/shellguard
	name = "Shellguard"
	prosthetic_limb_desc = "This limb has a sturdy and heavy build to it."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/shellguard/shellguard_main.dmi'

/decl/bodytype/prosthetic/economy
	name = "Ward-Takahashi Econ."
	prosthetic_limb_desc = "A simple robotic limb with retro design. Seems rather stiff."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/wardtakahashi/wardtakahashi_economy.dmi'

/decl/bodytype/prosthetic/xion
	name = "Xion"
	prosthetic_limb_desc = "This limb has a minimalist black and red casing."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/xion/xion_main.dmi'

/decl/bodytype/prosthetic/nanotrasen
	name = "NanoTrasen"
	prosthetic_limb_desc = "This limb is made from a cheap polymer."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/nanotrasen/nanotrasen_main.dmi'

DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/shellguard, shellguard)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/nanotrasen, nanotrasen)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/xion, xion)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/economy, wardtakahashi)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/bishop, bishop)

DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/bodytype/prosthetic/shellguard, shellguard,    0)
DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/bodytype/prosthetic/nanotrasen, nanotrasen,    0)
DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/bodytype/prosthetic/xion,       xion,          0)
DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/bodytype/prosthetic/economy,    wardtakahashi, 0)
DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/bodytype/prosthetic/bishop,     bishop,        0)
