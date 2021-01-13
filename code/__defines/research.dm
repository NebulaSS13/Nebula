#define SHEET_MATERIAL_AMOUNT 2000
#define SHEET_UNIT "<small>cm<sup>3</sup></small>"

#define REAGENT_UNITS_PER_MATERIAL_UNIT (REAGENT_UNITS_PER_MATERIAL_SHEET / SHEET_MATERIAL_AMOUNT)
#define REAGENT_UNITS_PER_MATERIAL_SHEET 20
#define REAGENT_UNITS_PER_GAS_MOLE 10

#define MATTER_AMOUNT_PRIMARY       SHEET_MATERIAL_AMOUNT
#define MATTER_AMOUNT_SECONDARY     (MATTER_AMOUNT_PRIMARY * 0.75)
#define MATTER_AMOUNT_REINFORCEMENT (MATTER_AMOUNT_PRIMARY * 0.5)
#define MATTER_AMOUNT_TRACE         (MATTER_AMOUNT_PRIMARY * 0.1)

#define GENERIC_SMELTING_HEAT_POINT 5000
#define HIGH_SMELTING_HEAT_POINT 10000
#define TECH_MATERIAL      "materials"
#define TECH_ENGINEERING   "engineering"
#define TECH_EXOTIC_MATTER "exoticmatter"
#define TECH_POWER         "powerstorage"
#define TECH_WORMHOLES     "wormholes"
#define TECH_BIO           "biotech"
#define TECH_COMBAT        "combat"
#define TECH_MAGNET        "magnets"
#define TECH_DATA          "programming"
#define TECH_ESOTERIC      "esoteric"

#define T_BOARD(name)	"circuit board (" + (name) + ")"