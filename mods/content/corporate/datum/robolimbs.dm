/decl/bodytype/prosthetic/bishop
	name = "Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/bishop/bishop_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)

/decl/bodytype/prosthetic/bishop/rook
	name = "Bishop Rook"
	desc = "This limb has a polished metallic casing and a holographic face emitter."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/bishop/bishop_rook.dmi'
	has_eyes = FALSE
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/stainlesssteel = MATTER_AMOUNT_SECONDARY
	)

/decl/bodytype/prosthetic/hephaestus
	name = "Hephaestus Industries"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/hephaestus/hephaestus_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID

/decl/bodytype/prosthetic/hephaestus/titan
	name = "Hephaestus Titan"
	desc = "This limb has a casing of an olive drab finish, providing a reinforced housing look."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/hephaestus/hephaestus_titan.dmi'
	has_eyes = FALSE
	bodytype_category = BODYTYPE_HUMANOID

/decl/bodytype/prosthetic/zenghu/spirit
	name = "Zeng-Hu Spirit"
	desc = "This limb has a sleek black and white polymer finish."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/zenghu/zenghu_spirit.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)

/decl/bodytype/prosthetic/xion/econo
	name = "Xion Econ"
	desc = "This skeletal mechanical limb has a minimalist black and red casing."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/xion/xion_econo.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)

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

/decl/bodytype/prosthetic/morpheus
	name = "Morpheus"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/steel

/decl/bodytype/prosthetic/mantis
	name = "Morpheus Mantis"
	desc = "This limb has a casing of sleek black metal and repulsive insectile design."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/morpheus/morpheus_mantis.dmi'
	has_eyes = FALSE
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/steel

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

/decl/bodytype/prosthetic/veymed/masculine
	name = "Vey-Med (Masculine)"
	icon_base = 'mods/content/corporate/icons/cyberlimbs/veymed/veymed_male.dmi'
	bodytype_category = BODYTYPE_HUMANOID

/decl/bodytype/prosthetic/shellguard
	name = "Shellguard"
	desc = "This limb has a sturdy and heavy build to it."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/shellguard/shellguard_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID

/decl/bodytype/prosthetic/economy
	name = "Ward-Takahashi Econ."
	desc = "A simple robotic limb with retro design. Seems rather stiff."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/wardtakahashi/wardtakahashi_economy.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium

/decl/bodytype/prosthetic/xion
	name = "Xion"
	desc = "This limb has a minimalist black and red casing."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/xion/xion_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY
	)

/decl/bodytype/prosthetic/nanotrasen
	name = "NanoTrasen"
	desc = "This limb is made from a cheap polymer."
	icon_base = 'mods/content/corporate/icons/cyberlimbs/nanotrasen/nanotrasen_main.dmi'
	bodytype_category = BODYTYPE_HUMANOID
	material = /decl/material/solid/organic/plastic

DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/shellguard, shellguard)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/nanotrasen, nanotrasen)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/xion, xion)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/economy, wardtakahashi)
DEFINE_ROBOLIMB_DESIGNS(/decl/bodytype/prosthetic/bishop, bishop)

DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/shellguard, shellguard,    0)
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/nanotrasen, nanotrasen,    0)
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/xion,       xion,          0)
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/economy,    wardtakahashi, 0)
DEFINE_ROBOLIMB_MODEL_TRAITS(/decl/bodytype/prosthetic/bishop,     bishop,        0)
