#define HEX_RED(COLOUR)   hex2num(copytext(COLOUR,2,4))
#define HEX_GREEN(COLOUR) hex2num(copytext(COLOUR,4,6))
#define HEX_BLUE(COLOUR)  hex2num(copytext(COLOUR,6,8))
#define HEX_ALPHA(COLOUR) hex2num(copytext(COLOUR,8,10))

// BYOND lower-cases color values, and thus we do so as well to ensure atom.color == COLOR_X will work correctly
#define COLOR_BLACK            "#000000"
#define COLOR_NAVY_BLUE        "#000080"
#define COLOR_GREEN            "#008000"
#define COLOR_DARK_GRAY        "#404040"
#define COLOR_MAROON           "#800000"
#define COLOR_PURPLE           "#800080"
#define COLOR_VIOLET           "#9933ff"
#define COLOR_OLIVE            "#808000"
#define COLOR_BROWN_ORANGE     "#824b28"
#define COLOR_DARK_ORANGE      "#b95a00"
#define COLOR_GRAY40           "#666666"
#define COLOR_GRAY20           "#333333"
#define COLOR_GRAY15           "#151515"
#define COLOR_SEDONA           "#cc6600"
#define COLOR_DARK_BROWN       "#917448"
#define COLOR_BLUE             "#0000ff"
#define COLOR_DEEP_SKY_BLUE    "#00e1ff"
#define COLOR_LIME             "#00ff00"
#define COLOR_CYAN             "#00ffff"
#define COLOR_TEAL             "#33cccc"
#define COLOR_RED              "#ff0000"
#define COLOR_DARK_RED         "#aa0000"
#define COLOR_PINK             "#ff00ff"
#define COLOR_PALE_PINK        "#bf89ba"
#define COLOR_ORANGE           "#ff9900"
#define COLOR_YELLOW           "#ffff00"
#define COLOR_YELLOW_GRAY      "#c9a344"
#define COLOR_PALE_YELLOW      "#c1bb7a"
#define COLOR_WARM_YELLOW      "#b3863c"
#define COLOR_GRAY             "#808080"
#define COLOR_RED_GRAY         "#aa5f61"
#define COLOR_BROWN            "#b19664"
#define COLOR_GREEN_GRAY       "#8daf6a"
#define COLOR_DARK_GREEN_GRAY  "#54654c"
#define COLOR_BLUE_GRAY        "#6a97b0"
#define COLOR_DARK_BLUE_GRAY   "#3e4855"
#define COLOR_SURGERY_BLUE     "#e0f2f6"
#define COLOR_SUN              "#ec8b2f"
#define COLOR_PURPLE_GRAY      "#a2819e"
#define COLOR_BLUE_LIGHT       "#33ccff"
#define COLOR_RED_LIGHT        "#ff3333"
#define COLOR_BEIGE            "#ceb689"
#define COLOR_BABY_BLUE        "#89cff0"
#define COLOR_PALE_GREEN_GRAY  "#aed18b"
#define COLOR_PALE_RED_GRAY    "#cc9090"
#define COLOR_PALE_PURPLE_GRAY "#bda2ba"
#define COLOR_PALE_BLUE_GRAY   "#8bbbd5"
#define COLOR_LUMINOL          "#66ffff"
#define COLOR_ACID_CYAN        "#00ffc8"
#define COLOR_SILVER           "#c0c0c0"
#define COLOR_GRAY80           "#cccccc"
#define COLOR_OFF_WHITE        "#eeeeee"
#define COLOR_WHITE            "#ffffff"
#define COLOR_EGGSHELL         "#e4e0d2"
#define COLOR_GOLD             "#ffcc33"
#define COLOR_CLOSET_GOLD      "#6d6133"
#define COLOR_NT_RED           "#9d2300"
#define COLOR_BOTTLE_GREEN     "#1f6b4f"
#define COLOR_PALE_BTL_GREEN   "#57967f"
#define COLOR_GUNMETAL         "#545c68"
#define COLOR_WALL_GUNMETAL    "#353a42"
#define COLOR_STEEL            "#a8b0b2"
#define COLOR_MUZZLE_FLASH     "#ffffb2"
#define COLOR_CHESTNUT         "#996633"
#define COLOR_COPPER           "#b87333"
#define COLOR_BEASTY_BROWN     "#663300"
#define COLOR_WHEAT            "#ffff99"
#define COLOR_CYAN_BLUE        "#3366cc"
#define COLOR_LIGHT_CYAN       "#66ccff"
#define COLOR_PAKISTAN_GREEN   "#006600"
#define COLOR_HULL             "#436b8e"
#define COLOR_AMBER            "#ffbf00"
#define COLOR_COMMAND_BLUE     "#46698c"
#define COLOR_SKY_BLUE         "#5ca1cc"
#define COLOR_FONT_ORANGE      "#e67300"
#define COLOR_PALE_ORANGE      "#b88a3b"
#define COLOR_CIVIE_GREEN      "#b7f27d"
#define COLOR_TITANIUM         "#d1e6e3"
#define COLOR_DARK_GUNMETAL    "#4c535b"
#define COLOR_BRONZE           "#8c7853"
#define COLOR_TAN			   "#a39682"
#define COLOR_BRASS            "#b99d71"
#define COLOR_POLISHED_BRASS   "#fdef6e"
#define COLOR_INDIGO           "#4b0082"
#define COLOR_ALUMINIUM        "#bbbbbb"
#define COLOR_CRYSTAL          "#00c8a5"
#define COLOR_ASTEROID_ROCK    "#735555"
#define COLOR_DIAMOND          "#d8d4ea"

#define	PIPE_COLOR_GREY        "#808080"
#define	PIPE_COLOR_RED         "#ff0000"
#define	PIPE_COLOR_BLUE        "#0000ff"
#define	PIPE_COLOR_CYAN        "#00ffff"
#define	PIPE_COLOR_GREEN       "#00ff00"
#define	PIPE_COLOR_YELLOW      "#ffcc00"
#define	PIPE_COLOR_BLACK       "#444444"
#define	PIPE_COLOR_ORANGE      "#b95a00"
#define PIPE_COLOR_WHITE       "#ffffff"

#define	COMMS_COLOR_DEFAULT    "#ff00ff"
#define	COMMS_COLOR_ENTERTAIN  "#666666"
#define	COMMS_COLOR_AI         "#ff00ff"
#define	COMMS_COLOR_COMMON     "#408010"
#define	COMMS_COLOR_SERVICE    "#709b00"
#define	COMMS_COLOR_SUPPLY     "#7f6539"
#define	COMMS_COLOR_SCIENCE    "#993399"
#define	COMMS_COLOR_MEDICAL    "#009190"
#define	COMMS_COLOR_EXPLORER   "#929820"
#define	COMMS_COLOR_ENGINEER   "#a66300"
#define	COMMS_COLOR_SECURITY   "#930000"
#define	COMMS_COLOR_COMMAND    "#204090"
#define	COMMS_COLOR_CENTCOMM   "#5c5c7c"
#define	COMMS_COLOR_SYNDICATE  "#6d3f40"

#define WOOD_COLOR_GENERIC     "#d5a66e"
#define WOOD_COLOR_RICH        "#792f27"
#define WOOD_COLOR_PALE        "#d2bc9d"
#define WOOD_COLOR_PALE2       "#e6d2ba"
#define WOOD_COLOR_BLACK       "#332521"
#define WOOD_COLOR_CHOCOLATE   "#543c30"
#define WOOD_COLOR_YELLOW      "#e3994e"

#define GLASS_COLOR            "#aaccff"
#define GLASS_COLOR_SILICATE   "#7c3a9a"
#define GLASS_COLOR_TINTED     "#222222"
#define GLASS_COLOR_FROSTED    "#eeeeee"

#define COLOR_BLOOD_HUMAN      "#a10808"

//Color defines used by the assembly detailer.
#define COLOR_ASSEMBLY_BLACK   "#545454"
#define COLOR_ASSEMBLY_BGRAY   "#9497ab"
#define COLOR_ASSEMBLY_WHITE   "#e2e2e2"
#define COLOR_ASSEMBLY_RED     "#cc4242"
#define COLOR_ASSEMBLY_ORANGE  "#e39751"
#define COLOR_ASSEMBLY_BEIGE   "#af9366"
#define COLOR_ASSEMBLY_BROWN   "#97670e"
#define COLOR_ASSEMBLY_GOLD    "#aa9100"
#define COLOR_ASSEMBLY_YELLOW  "#ceca2b"
#define COLOR_ASSEMBLY_GURKHA  "#999875"
#define COLOR_ASSEMBLY_LGREEN  "#789876"
#define COLOR_ASSEMBLY_GREEN   "#44843c"
#define COLOR_ASSEMBLY_LBLUE   "#5d99be"
#define COLOR_ASSEMBLY_BLUE    "#38559e"
#define COLOR_ASSEMBLY_PURPLE  "#6f6192"

//Colors defines used by e-sword lighting
#define COLOR_SABER_BLUE       "#40ceff"
#define COLOR_SABER_RED        "#ff0000"	//In case someone wants to tweak COLOR_RED, since COLOR_GREEN is not #00ff00
#define COLOR_SABER_GREEN      "#00ff00"
#define COLOR_SABER_PURPLE     "#6800f4"
#define COLOR_SABER_AXE        "#00ccff"
#define COLOR_SABER_CUTLASS    "#ff0033"

//  Light colors from Aurora
//Important note on colors. Colors can end up significantly different from the basic html picture, especially when saturated
#define LIGHT_COLOR_RED        "#fa8282" //Warm but extremely diluted red. rgb(250, 130, 130)
#define LIGHT_COLOR_GREEN      "#64c864" //Bright but quickly dissipating neon green. rgb(100, 200, 100)
#define LIGHT_COLOR_BLUE       "#6496fa" //Cold, diluted blue. rgb(100, 150, 250)

#define LIGHT_COLOR_CYAN       "#7de1e1" //Diluted cyan. rgb(125, 225, 225)
#define LIGHT_COLOR_PINK       "#e17de1" //Diluted, mid-warmth pink. rgb(225, 125, 225)
#define LIGHT_COLOR_YELLOW     "#e1e17d" //Dimmed yellow, leaning kaki. rgb(225, 225, 125)
#define LIGHT_COLOR_LYELLOW    "#fffee0" //Mostly used today in regular lamps. rgb(255, 254, 224)
#define LIGHT_COLOR_BROWN      "#966432" //Clear brown, mostly dim. rgb(150, 100, 50)
#define LIGHT_COLOR_ORANGE     "#fa9632" //Mostly pure orange. rgb(250, 150, 50)
#define LIGHT_COLOR_PURPLE     "#a97faa" //Soft purple. rgb(169, 127, 170)
#define LIGHT_COLOR_VIOLET     "#b43cb8" //Deep purple. rgb(180, 60, 184)
#define LIGHT_COLOR_SCARLET    "#e85656" //Light red. rgb(232, 86, 86)

//These ones aren't a direct colour like the ones above, because nothing would fit
#define LIGHT_COLOR_FIRE       "#faa019" //Warm orange color, leaning strongly towards yellow. rgb(250, 160, 25)
#define LIGHT_COLOR_LAVA       "#c48a18" //Very warm yellow, leaning slightly towards orange. rgb(196, 138, 24)
#define LIGHT_COLOR_FLARE      "#fa644b" //Bright, non-saturated red. Leaning slightly towards pink for visibility. rgb(250, 100, 75)
#define LIGHT_COLOR_SLIME_LAMP "#afc84b" //Weird color, between yellow and green, very slimy. rgb(175, 200, 75)
#define LIGHT_COLOR_TUNGSTEN   "#fae1af" //Extremely diluted yellow, close to skin color (for some reason). rgb(250, 225, 175)
#define LIGHT_COLOR_HALOGEN    "#f0fafa" //Barely visible cyan-ish hue, as the doctor prescribed. rgb(240, 250, 250)
#define LIGHT_COLOR_EMERGENCY  "#ff3232" //Red color used by emergency lighting. rgb(255, 50, 50)

// Used by fluid system.
#define COLOR_OCEAN "#99f5ff"

// Used to easily change research colour in case of ???
#define COLOR_RESEARCH COLOR_PURPLE_GRAY

//Blob colors
#define BLOB_COLOR_CORE      "#c96e28"
#define BLOB_COLOR_SHIELD    "#9ed659"
#define BLOB_COLOR_RAV       "#d65f42"
#define BLOB_COLOR_PULS      "#b5ff5b"

#define RANDOM_RGB rgb(rand(0,255), rand(0,255), rand(0,255))

// Codex category colours.
#define CODEX_COLOR_LORE      "#abdb9b"
#define CODEX_COLOR_MECHANICS "#9ebcd8"
#define CODEX_COLOR_ANTAG     "#e5a2a2"

#define COLOR_WEBHOOK_DEFAULT 0x8bbbd5

// Colors for input/hotkey panel.
#define COLOR_INPUT_DISABLED "#f0f0f0"
#define COLOR_INPUT_ENABLED "#d3b5b5"
