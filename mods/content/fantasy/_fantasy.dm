#define BODYTYPE_KOBALOI "reptomammalian body"
#define BODYTYPE_HNOLL   "hyenoid body"
#define BODYTYPE_DVERGR  "small humanoid body"

#define BODY_EQUIP_FLAG_KOBALOI BITFLAG(9)
#define BODY_EQUIP_FLAG_HNOLL   BITFLAG(10)
#define BODY_EQUIP_FLAG_DVERGR  BITFLAG(11)

#define SKILL_CARPENTRY     /decl/skill/crafting/carpentry
#define SKILL_METALWORK     /decl/skill/crafting/metalwork
#define SKILL_TEXTILES      /decl/skill/crafting/textiles
#define SKILL_STONEMASONRY  /decl/skill/crafting/stonemasonry
#define SKILL_SCULPTING     /decl/skill/crafting/sculpting
#define SKILL_ARTIFICE      /decl/skill/crafting/artifice
#define SKILL_HUSBANDRY     /decl/skill/service/husbandry

/decl/modpack/fantasy
	name = "Fantasy Content"

/decl/modpack/fantasy/Initialize()
	. = ..()
	global._wall_chisel_skill = SKILL_STONEMASONRY
