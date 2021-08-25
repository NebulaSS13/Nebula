/decl/prosthetics_manufacturer/bishop
	name = "Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'mods/content/corporate/icons/cyberlimbs/bishop/bishop_main.dmi'

/decl/prosthetics_manufacturer/bishop/rook
	name = "Bishop Rook"
	desc = "This limb has a polished metallic casing and a holographic face emitter."
	icon = 'mods/content/corporate/icons/cyberlimbs/bishop/bishop_rook.dmi'
	has_eyes = FALSE

/decl/prosthetics_manufacturer/hephaestus
	name = "Hephaestus Industries"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	icon = 'mods/content/corporate/icons/cyberlimbs/hephaestus/hephaestus_main.dmi'

/decl/prosthetics_manufacturer/hephaestus/titan
	name = "Hephaestus Titan"
	desc = "This limb has a casing of an olive drab finish, providing a reinforced housing look."
	icon = 'mods/content/corporate/icons/cyberlimbs/hephaestus/hephaestus_titan.dmi'
	has_eyes = FALSE

/decl/prosthetics_manufacturer/zenghu/spirit
	name = "Zeng-Hu Spirit"
	desc = "This limb has a sleek black and white polymer finish."
	icon = 'mods/content/corporate/icons/cyberlimbs/zenghu/zenghu_spirit.dmi'

/decl/prosthetics_manufacturer/xion/econo
	name = "Xion Econ"
	desc = "This skeletal mechanical limb has a minimalist black and red casing."
	icon = 'mods/content/corporate/icons/cyberlimbs/xion/xion_econo.dmi'

/decl/prosthetics_manufacturer/wardtakahashi
	name = "Ward-Takahashi"
	desc = "This limb features sleek black and white polymers."
	icon = 'mods/content/corporate/icons/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	can_eat = 1

/decl/prosthetics_manufacturer/morpheus
	name = "Morpheus"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_main.dmi'

/decl/prosthetics_manufacturer/mantis
	name = "Morpheus Mantis"
	desc = "This limb has a casing of sleek black metal and repulsive insectile design."
	icon = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_mantis.dmi'
	has_eyes = FALSE

/decl/prosthetics_manufacturer/veymed
	name = "Vey-Med (Feminine)"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon = 'mods/content/corporate/icons/cyberlimbs/veymed/veymed_female.dmi'
	can_eat = 1
	skintone = 1

/decl/prosthetics_manufacturer/veymed/masculine
	name = "Vey-Med (Masculine)"
	icon = 'mods/content/corporate/icons/cyberlimbs/veymed/veymed_male.dmi'

/decl/prosthetics_manufacturer/shellguard
	name = "Shellguard"
	desc = "This limb has a sturdy and heavy build to it."
	icon = 'mods/content/corporate/icons/cyberlimbs/shellguard/shellguard_main.dmi'

/decl/prosthetics_manufacturer/economy
	name = "Ward-Takahashi Econ."
	desc = "A simple robotic limb with retro design. Seems rather stiff."
	icon = 'mods/content/corporate/icons/cyberlimbs/wardtakahashi/wardtakahashi_economy.dmi'

/decl/prosthetics_manufacturer/xion
	name = "Xion"
	desc = "This limb has a minimalist black and red casing."
	icon = 'mods/content/corporate/icons/cyberlimbs/xion/xion_main.dmi'

/decl/prosthetics_manufacturer/nanotrasen
	name = "NanoTrasen"
	desc = "This limb is made from a cheap polymer."
	icon = 'mods/content/corporate/icons/cyberlimbs/nanotrasen/nanotrasen_main.dmi'

DEFINE_ROBOLIMB_DESIGNS(/decl/prosthetics_manufacturer/shellguard, shellguard)
DEFINE_ROBOLIMB_DESIGNS(/decl/prosthetics_manufacturer/nanotrasen, nanotrasen)
DEFINE_ROBOLIMB_DESIGNS(/decl/prosthetics_manufacturer/xion, xion)
DEFINE_ROBOLIMB_DESIGNS(/decl/prosthetics_manufacturer/economy, wardtakahashi)
DEFINE_ROBOLIMB_DESIGNS(/decl/prosthetics_manufacturer/bishop, bishop)

DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/prosthetics_manufacturer/shellguard, shellguard,    0)
DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/prosthetics_manufacturer/nanotrasen, nanotrasen,    0)
DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/prosthetics_manufacturer/xion,       xion,          0)
DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/prosthetics_manufacturer/economy,    wardtakahashi, 0)
DEFINE_ROBOLIMB_MODEL_ASPECTS(/decl/prosthetics_manufacturer/bishop,     bishop,        0)
