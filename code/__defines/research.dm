#define SHEET_MATERIAL_AMOUNT 2000
#define SHEET_UNIT "<small>cm<sup>3</sup></small>"

#define MATTER_AMOUNT_PRIMARY       SHEET_MATERIAL_AMOUNT
#define MATTER_AMOUNT_REINFORCEMENT (MATTER_AMOUNT_PRIMARY * 0.5)
#define MATTER_AMOUNT_TRACE         (MATTER_AMOUNT_PRIMARY * 0.1)

#define TECH_MATERIAL    "materials"
#define TECH_ENGINEERING "engineering"
#define TECH_PHORON      "phorontech"
#define TECH_POWER       "powerstorage"
#define TECH_BLUESPACE   "bluespace"
#define TECH_BIO         "biotech"
#define TECH_COMBAT      "combat"
#define TECH_MAGNET      "magnets"
#define TECH_DATA        "programming"
#define TECH_ESOTERIC    "esoteric"
#define ALL_TECH_LEVELS list(TECH_MATERIAL, TECH_ENGINEERING, TECH_PHORON, TECH_POWER, TECH_BLUESPACE, TECH_BIO, TECH_COMBAT, TECH_MAGNET, TECH_DATA, TECH_ESOTERIC)

#define IMPRINTER	0x1	//For circuits. Uses glass/chemicals.
#define PROTOLATHE	0x2	//New stuff. Uses glass/metal/chemicals
#define MECHFAB		0x4	//Mechfab
#define CHASSIS		0x8	//For protolathe, but differently

#define T_BOARD(name)	"circuit board (" + (name) + ")"