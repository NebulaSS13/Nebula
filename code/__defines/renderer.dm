//-------------------- Rendering ---------------------
/// Semantics - The final compositor or a filter effect renderer
#define RENDER_GROUP_NONE null
/// Things to be drawn within the game context
#define RENDER_GROUP_SCENE 990
/// Things to be drawn within the screen context
#define RENDER_GROUP_SCREEN 995
/// The final render group, for compositing
#define RENDER_GROUP_FINAL 999

/// This plane masks out lighting, to create an "emissive" effect for e.g glowing screens in otherwise dark areas.
#define EMISSIVE_PLANE 10
#define EMISSIVE_LAYER 1
#define EMISSIVE_TARGET "*emissive"
/// The layer you should use when you -really- don't want an emissive overlay to be blocked.
#define EMISSIVE_LAYER_UNBLOCKABLE 9999

// Emissive blockers
/// For anything that shouldn't block emissives. Small objects or translucent objects primarily
#define EMISSIVE_BLOCK_NONE 0
/// For anything that doesn't change outline or opaque area much or at all.
#define EMISSIVE_BLOCK_GENERIC 1
/// Uses a dedicated render_target object to copy the entire appearance in real time to the blocking layer. For things that can change in appearance a lot from the base state, like humans.
#define EMISSIVE_BLOCK_UNIQUE 2
/// The color matrix applied to all emissive overlays. Should be solely dependent on alpha and not have RGB overlap with [EM_BLOCK_COLOR].
#define EMISSIVE_COLOR list(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 1,1,1,0)
/// The color matrix applied to all emissive blockers. Should be solely dependent on alpha and not have RGB overlap with [EMISSIVE_COLOR].
#define EM_BLOCK_COLOR list(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
/// The color matrix used to mask out emissive blockers on the emissive plane. Alpha should default to zero, be solely dependent on the RGB value of [EMISSIVE_COLOR], and be independant of the RGB value of [EM_BLOCK_COLOR].
#define EM_MASK_MATRIX list(0,0,0,1/3, 0,0,0,1/3, 0,0,0,1/3, 0,0,0,0, 1,1,1,0)
/// A set of appearance flags applied to all emissive and emissive blocker overlays.
#define EMISSIVE_APPEARANCE_FLAGS (KEEP_APART|KEEP_TOGETHER|RESET_COLOR|NO_CLIENT_COLOR)

/// A globally cached version of [EM_MASK_MATRIX] for quick access.
var/global/list/_em_mask_matrix = EM_MASK_MATRIX
/// A globaly cached version of [EMISSIVE_COLOR] for quick access.
var/global/list/_emissive_color = EMISSIVE_COLOR
/// A globaly cached version of [EM_BLOCK_COLOR] for quick access.
var/global/list/_em_block_color = EM_BLOCK_COLOR