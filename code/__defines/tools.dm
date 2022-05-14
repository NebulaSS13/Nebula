// Engineering tools.
#define TOOL_WELDER      /decl/tool_archetype/welder
#define TOOL_CABLECOIL   /decl/tool_archetype/cable_coil
#define TOOL_WIRECUTTERS /decl/tool_archetype/wirecutters
#define TOOL_SCREWDRIVER /decl/tool_archetype/screwdriver
#define TOOL_MULTITOOL   /decl/tool_archetype/multitool
#define TOOL_CROWBAR     /decl/tool_archetype/crowbar
#define TOOL_HATCHET     /decl/tool_archetype/hatchet
#define TOOL_WRENCH      /decl/tool_archetype/wrench

// Surgical tools.
#define TOOL_SCALPEL       /decl/tool_archetype/scalpel
#define TOOL_RETRACTOR     /decl/tool_archetype/retractor
#define TOOL_HEMOSTAT      /decl/tool_archetype/hemostat
#define TOOL_SAW           /decl/tool_archetype/saw
#define TOOL_CAUTERY       /decl/tool_archetype/cautery
#define TOOL_SUTURES       /decl/tool_archetype/sutures
#define TOOL_BONE_GEL      /decl/tool_archetype/bone_gel
#define TOOL_BONE_SETTER   /decl/tool_archetype/bone_setter
#define TOOL_DRILL         /decl/tool_archetype/surgical_drill

// Tool qualities (positive multplier)
#define TOOL_QUALITY_WORST    0.1
#define TOOL_QUALITY_BAD      0.5
#define TOOL_QUALITY_MEDIOCRE 0.75
#define TOOL_QUALITY_DEFAULT  1
#define TOOL_QUALITY_DECENT   1.2
#define TOOL_QUALITY_GOOD     1.5
#define TOOL_QUALITY_BEST     2

// Tool speeds (smaller values mean a shorter delay)
#define TOOL_SPEED_WORST   3
#define TOOL_SPEED_DEFAULT 1
#define TOOL_SPEED_BEST  0.5

// Helper macros for interaction checks.
#define IS_TOOL(A, T)     (isatom(A) && A.get_tool_quality(T) > 0)
#define IS_SAW(A)         IS_TOOL(A, TOOL_SAW)
#define IS_WRENCH(A)      IS_TOOL(A, TOOL_WRENCH)
#define IS_WELDER(A)      IS_TOOL(A, TOOL_WELDER)
#define IS_COIL(A)        IS_TOOL(A, TOOL_CABLECOIL)
#define IS_WIRECUTTER(A)  IS_TOOL(A, TOOL_WIRECUTTERS)
#define IS_SCREWDRIVER(A) IS_TOOL(A, TOOL_SCREWDRIVER)
#define IS_MULTITOOL(A)   IS_TOOL(A, TOOL_MULTITOOL)
#define IS_CROWBAR(A)     IS_TOOL(A, TOOL_CROWBAR)
#define IS_HATCHET(A)     IS_TOOL(A, TOOL_HATCHET)

// Structure interaction flags
#define TOOL_INTERACTION_ANCHOR      BITFLAG(0)
#define TOOL_INTERACTION_DECONSTRUCT BITFLAG(1)
#define TOOL_INTERACTION_WIRING      BITFLAG(2)
#define TOOL_INTERACTION_ALL         (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT | TOOL_INTERACTION_WIRING)

// Codex strings for looking up tool information.
#define TOOL_CODEX_WRENCH       "wrench (tool)"
#define TOOL_CODEX_SCREWDRIVER  "screwdriver (tool)"
#define TOOL_CODEX_WIRECUTTERS  "wirecutters (tool)"
#define TOOL_CODEX_WELDER       "welder (tool)"
#define TOOL_CODEX_CROWBAR      "crowbar (tool)"
#define TOOL_CODEX_MULTITOOL    "multitool (tool)"