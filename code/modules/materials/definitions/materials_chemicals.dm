/decl/material/fuel
	name = "welding fuel"
	lore_text = "A stable hydrazine-based compound whose exact manufacturing specifications are a closely-guarded secret. One of the most common fuels in human space. Extremely flammable."
	taste_description = "gross metal"
	icon_colour = "#660000"
	touch_met = 5
	fuel_value = 1
	glass_name = "welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."
	value = 1.5

/decl/material/hydrazine
	name = "hydrazine"
	lore_text = "A toxic, colorless, flammable liquid with a strong ammonia-like odor, in hydrate form."
	taste_description = "sweet tasting metal"
	icon_colour = "#808080"
	metabolism = REM * 0.2
	touch_met = 5
	value = 1.2
	fuel_value = 1.2

#define MAT_ACID_SULPHURIC    /decl/material/acid
#define MAT_ACID_POLYTRINIC   /decl/material/polyacid
#define MAT_ACID_HYDROCHLORIC /decl/material/hydroacid
#define MAT_ACID_STOMACH      /decl/material/stomachacid

/decl/material/acid
	name = "sulphuric acid"
	lore_text = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	icon_colour = "#db5008"
	metabolism = REM * 2
	touch_met = 50
	value = 1.2
	pH = 2

/decl/material/hydroacid
	name = "hydrochloric acid"
	lore_text = "A very corrosive mineral acid with the molecular formula HCl."
	taste_description = "stomach acid"
	icon_colour = "#808080"
	metabolism = REM * 2
	touch_met = 50
	pH = 3
	value = 1.5

/decl/material/polyacid
	name = "polytrinic acid"
	lore_text = "Polytrinic acid is a an extremely corrosive chemical substance."
	taste_description = "acid"
	icon_colour = "#8e18a9"
	metabolism = REM * 2
	touch_met = 50
	pH = 1
	value = 1.8

/decl/material/stomachacid
	name = "stomach acid"
	taste_description = "coppery foulness"
	metabolism = REM * 2
	touch_met = 50
	icon_colour = "#d8ff00"
	hidden_from_codex = TRUE
	pH = 3
	value = 0
