#define HUMAN_STRIP_DELAY        40   // Takes 40ds = 4s to strip someone.

#define CANDLE_LUM 3 // For how bright candles are.

#define ACCESSORY_SLOT_UTILITY  "Utility"
#define ACCESSORY_SLOT_HOLSTER	"Holster"
#define ACCESSORY_SLOT_ARMBAND  "Armband"
#define ACCESSORY_SLOT_RANK     "Rank"
#define ACCESSORY_SLOT_DEPT		"Department"
#define ACCESSORY_SLOT_DECOR    "Decor"
#define ACCESSORY_SLOT_MEDAL    "Medal"
#define ACCESSORY_SLOT_INSIGNIA "Insignia"
#define ACCESSORY_SLOT_ARMOR_C  "Chest armor"
#define ACCESSORY_SLOT_ARMOR_A  "Arm armor"
#define ACCESSORY_SLOT_ARMOR_L  "Leg armor"
#define ACCESSORY_SLOT_ARMOR_S  "Armor storage"
#define ACCESSORY_SLOT_ARMOR_M  "Misc armor"
#define ACCESSORY_SLOT_HELM_C	"Helmet cover"
#define ACCESSORY_SLOT_OVER     "Over"

// Bitmasks for the flags_inv variable. These determine when a piece of clothing hides another, i.e. a helmet hiding glasses.
// WARNING: The following flags apply only to the external suit!
#define HIDEGLOVES      BITFLAG(0)
#define HIDESUITSTORAGE BITFLAG(1)
#define HIDEJUMPSUIT    BITFLAG(2)
#define HIDESHOES       BITFLAG(3)
#define HIDETAIL        BITFLAG(4)

// WARNING: The following flags apply only to the helmets and masks!
#define HIDEMASK      BITFLAG(0)
#define HIDEEARS      BITFLAG(1) // Headsets and such.
#define HIDEEYES      BITFLAG(2) // Glasses.
#define HIDEFACE      BITFLAG(3) // Dictates whether we appear as "Unknown".
#define BLOCKHEADHAIR BITFLAG(4)    // Hides the user's hair overlay. Leaves facial hair.
#define BLOCKHAIR     BITFLAG(5)    // Hides the user's hair, facial and otherwise.

// Inventory slot strings.
// since numbers cannot be used as associative list keys.
//icon_back, icon_l_hand, etc would be much better names for these...
#define slot_back_str        "slot_back"
#define slot_w_uniform_str   "slot_w_uniform"
#define slot_head_str        "slot_head"
#define slot_wear_suit_str   "slot_suit"
#define slot_l_ear_str       "slot_l_ear"
#define slot_r_ear_str       "slot_r_ear"
#define slot_belt_str        "slot_belt"
#define slot_shoes_str       "slot_shoes"
#define slot_wear_mask_str   "slot_wear_mask"
#define slot_handcuffed_str  "slot_handcuffed"
#define slot_wear_id_str     "slot_wear_id"
#define slot_gloves_str      "slot_gloves"
#define slot_glasses_str     "slot_glasses"
#define slot_tie_str         "slot_tie"
#define slot_l_store_str     "slot_l_store"
#define slot_r_store_str     "slot_r_store"
#define slot_s_store_str     "slot_s_store"
#define slot_in_backpack_str "slot_s_store"

// Defined here for consistency, not actually used for slots, just for species clothing offsets.
#define slot_undershirt_str  "slot_undershirt"
#define slot_underpants_str  "slot_underpants"
#define slot_socks_str       "slot_socks"

// Bodypart coverage bitflags.
#define SLOT_UPPER_BODY  BITFLAG(0)
#define SLOT_LOWER_BODY  BITFLAG(1)
#define SLOT_OVER_BODY   BITFLAG(2)
#define SLOT_LEG_LEFT    BITFLAG(3)
#define SLOT_LEG_RIGHT   BITFLAG(4)
#define SLOT_FOOT_LEFT   BITFLAG(5)
#define SLOT_FOOT_RIGHT  BITFLAG(6)
#define SLOT_ARM_LEFT    BITFLAG(7)
#define SLOT_ARM_RIGHT   BITFLAG(8)
#define SLOT_HAND_LEFT   BITFLAG(9)
#define SLOT_HAND_RIGHT  BITFLAG(10)
#define SLOT_EYES        BITFLAG(11)
#define SLOT_EARS        BITFLAG(12)
#define SLOT_FACE        BITFLAG(13)
#define SLOT_HEAD        BITFLAG(14)
#define SLOT_ID          BITFLAG(15)
#define SLOT_BACK        BITFLAG(16)
#define SLOT_TIE         BITFLAG(17)
#define SLOT_HOLSTER     BITFLAG(18)
#define SLOT_POCKET      BITFLAG(19)
#define SLOT_LEGS        (SLOT_LEG_LEFT|SLOT_LEG_RIGHT)
#define SLOT_FEET        (SLOT_FOOT_LEFT|SLOT_FOOT_RIGHT)
#define SLOT_ARMS        (SLOT_ARM_LEFT|SLOT_ARM_RIGHT)
#define SLOT_HANDS       (SLOT_HAND_LEFT|SLOT_HAND_RIGHT)
#define SLOT_FULL_BODY   (SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_HEAD|SLOT_FACE|SLOT_EYES|SLOT_EARS|SLOT_UPPER_BODY|SLOT_LOWER_BODY)

// Bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection().
// The values here should add up to 1, e.g., the head has 30% protection.
#define THERMAL_PROTECTION_HEAD        0.3
#define THERMAL_PROTECTION_UPPER_TORSO 0.15
#define THERMAL_PROTECTION_LOWER_TORSO 0.15
#define THERMAL_PROTECTION_LEG_LEFT    0.075
#define THERMAL_PROTECTION_LEG_RIGHT   0.075
#define THERMAL_PROTECTION_FOOT_LEFT   0.025
#define THERMAL_PROTECTION_FOOT_RIGHT  0.025
#define THERMAL_PROTECTION_ARM_LEFT    0.075
#define THERMAL_PROTECTION_ARM_RIGHT   0.075
#define THERMAL_PROTECTION_HAND_LEFT   0.025
#define THERMAL_PROTECTION_HAND_RIGHT  0.025

// Pressure limits.
#define  HAZARD_HIGH_PRESSURE 550 // This determines at what pressure the ultra-high pressure red icon is displayed. (This one is set as a constant)
#define WARNING_HIGH_PRESSURE 325 // This determines when the orange pressure icon is displayed (it is 0.7 * HAZARD_HIGH_PRESSURE)
#define WARNING_LOW_PRESSURE  50  // This is when the gray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)
#define  HAZARD_LOW_PRESSURE  20  // This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)

#define TEMPERATURE_DAMAGE_COEFFICIENT  1.5 // This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define BODYTEMP_AUTORECOVERY_DIVISOR   12  // This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_MINIMUM   1   // Minimum amount of kelvin moved toward 310.15K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_COLD_DIVISOR           6   // Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR           6   // Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_COOLING_MAX           -30  // The maximum number of degrees that your body can cool down in 1 tick, when in a cold area.
#define BODYTEMP_HEATING_MAX            30  // The maximum number of degrees that your body can heat up in 1 tick,   when in a hot  area.

#define BODYTEMP_HEAT_DAMAGE_LIMIT 360.15 // The limit the human body can take before it starts taking damage from heat.
#define BODYTEMP_COLD_DAMAGE_LIMIT 260.15 // The limit the human body can take before it starts taking damage from coldness.

#define SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // What min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define   SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // What min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define       HELMET_MIN_COLD_PROTECTION_TEMPERATURE 160 // For normal helmets.
#define        ARMOR_MIN_COLD_PROTECTION_TEMPERATURE 160 // For armor.
#define       GLOVES_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // For some gloves.
#define         SHOE_MIN_COLD_PROTECTION_TEMPERATURE 2.0 // For shoes.

#define  SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE 5000  // These need better heat protect, but not as good heat protect as firesuits.
#define    FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE 30000 // What max_heat_protection_temperature is set to for firesuit quality headwear. MUST NOT BE 0.
#define FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 30000 // For fire-helmet quality items. (Red and white hardhats)
#define      HELMET_MAX_HEAT_PROTECTION_TEMPERATURE 600   // For normal helmets.
#define       ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE 600   // For armor.
#define      GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE 1500  // For some gloves.
#define        SHOE_MAX_HEAT_PROTECTION_TEMPERATURE 1500  // For shoes.

#define  FIRESUIT_MAX_PRESSURE 		100 * ONE_ATMOSPHERE   // Firesuis and atmos voidsuits
#define  RIG_MAX_PRESSURE 			50 * ONE_ATMOSPHERE   // Rigs
#define  LIGHT_RIG_MAX_PRESSURE 	25 * ONE_ATMOSPHERE   // Rigs
#define  ENG_VOIDSUIT_MAX_PRESSURE 	50 * ONE_ATMOSPHERE
#define  VOIDSUIT_MAX_PRESSURE 		25 * ONE_ATMOSPHERE
#define  SPACE_SUIT_MAX_PRESSURE 	5 * ONE_ATMOSPHERE

// Fire.
#define FIRE_MIN_STACKS          -20
#define FIRE_MAX_STACKS           25
#define FIRE_MAX_FIRESUIT_STACKS  20 // If the number of stacks goes above this firesuits won't protect you anymore. If not, you can walk around while on fire like a badass.

#define THROWFORCE_SPEED_DIVISOR    5  // The throwing speed value at which the throwforce multiplier is exactly 1.
#define THROWNOBJ_KNOCKBACK_SPEED   15 // The minumum speed of a w_class 2 thrown object that will cause living mobs it hits to be knocked back. Heavier objects can cause knockback at lower speeds.
#define THROWNOBJ_KNOCKBACK_DIVISOR 2  // Affects how much speed the mob is knocked back with.

// Suit sensor levels
#define SUIT_SENSOR_OFF      0
#define SUIT_SENSOR_BINARY   1
#define SUIT_SENSOR_VITAL    2
#define SUIT_SENSOR_TRACKING 3

#define SUIT_NO_SENSORS      0
#define SUIT_HAS_SENSORS     1
#define SUIT_LOCKED_SENSORS  2

// Hair Flags
#define VERY_SHORT           BITFLAG(0)
#define HAIR_TIEABLE         BITFLAG(1)
#define HAIR_BALD            BITFLAG(2)
#define HAIR_LOSS_VULNERABLE BITFLAG(3)

//flags to determine if an eyepiece is a hud.
#define HUD_SCIENCE  BITFLAG(0)
#define HUD_SECURITY BITFLAG(1)
#define HUD_MEDICAL  BITFLAG(2)
#define HUD_JANITOR  BITFLAG(3)

// Limbs.
#define BP_L_FOOT       "l_foot"
#define BP_R_FOOT       "r_foot"
#define BP_L_LEG        "l_leg"
#define BP_R_LEG        "r_leg"
#define BP_L_HAND       "l_hand"
#define BP_R_HAND       "r_hand"
#define BP_L_ARM        "l_arm"
#define BP_R_ARM        "r_arm"
#define BP_HEAD         "head"
#define BP_CHEST        "chest"
#define BP_GROIN        "groin"

var/list/all_limb_tags = list(BP_CHEST, BP_GROIN, BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
var/list/all_limb_tags_by_depth = list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_CHEST)

var/list/default_onmob_icons = list(
	BP_L_HAND =          'icons/mob/onmob/items/lefthand.dmi',
	BP_R_HAND =          'icons/mob/onmob/items/righthand.dmi'
)

var/list/all_inventory_slots = list(
	slot_back_str,
	BP_L_HAND,
	BP_R_HAND,
	slot_w_uniform_str,
	slot_head_str,
	slot_wear_suit_str,
	slot_l_ear_str,
	slot_r_ear_str,
	slot_belt_str,
	slot_shoes_str,
	slot_wear_mask_str,
	slot_handcuffed_str,
	slot_wear_id_str,
	slot_gloves_str,
	slot_glasses_str,
	slot_s_store_str,
	slot_tie_str,
	slot_l_store_str,
	slot_r_store_str
)

