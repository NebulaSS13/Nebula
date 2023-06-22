// All variables here use double quotes to able load information on every startup.

var/global/list/ai_names =           file2list("config/names/ai.txt")
var/global/list/wizard_first =       file2list("config/names/wizardfirst.txt")
var/global/list/wizard_second =      file2list("config/names/wizardsecond.txt")
var/global/list/ninja_titles =       file2list("config/names/ninjatitle.txt")
var/global/list/ninja_names =        file2list("config/names/ninjaname.txt")
var/global/list/commando_names =     file2list("config/names/death_commando.txt")
var/global/list/first_names_male =   file2list("config/names/first_male.txt")
var/global/list/first_names_female = file2list("config/names/first_female.txt")
var/global/list/last_names =         file2list("config/names/last.txt")
var/global/list/clown_names =        file2list("config/names/clown.txt")

var/global/list/verbs =              file2list("config/names/verbs.txt")
var/global/list/adjectives =         file2list("config/names/adjectives.txt")

var/global/list/descriptive_slot_names = list(
	slot_back_str        = "Back",
	slot_w_uniform_str   = "Uniform",
	slot_head_str        = "Head",
	slot_wear_suit_str   = "Suit",
	slot_l_ear_str       = "Left Ear",
	slot_r_ear_str       = "Right Ear",
	slot_belt_str        = "Belt",
	slot_shoes_str       = "Shoes",
	slot_wear_mask_str   = "Mask",
	slot_handcuffed_str  = "Handcuffs",
	slot_wear_id_str     = "ID",
	slot_gloves_str      = "Gloves",
	slot_glasses_str     = "Glasses",
	slot_tie_str         = "Accessory",
	slot_l_store_str     = "Left Pocket",
	slot_r_store_str     = "Right Pocket",
	slot_s_store_str     = "Suit Storage",
	slot_in_backpack_str = "In Backpack"
)
