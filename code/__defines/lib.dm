// byhttp

#ifndef WINDOWS_HTTP_POST_DLL_LOCATION
	#define WINDOWS_HTTP_POST_DLL_LOCATION "lib/byhttp.dll"
#endif

#ifndef UNIX_HTTP_POST_DLL_LOCATION
	#define UNIX_HTTP_POST_DLL_LOCATION "lib/libbyhttp.so"
#endif

#ifndef HTTP_POST_DLL_LOCATION
	#define HTTP_POST_DLL_LOCATION (world.system_type == MS_WINDOWS ? WINDOWS_HTTP_POST_DLL_LOCATION : UNIX_HTTP_POST_DLL_LOCATION)
#endif

// rust-g

#ifndef WINDOWS_RUST_G_DLL_LOCATION
	#define WINDOWS_RUST_G_DLL_LOCATION "lib/rust_g.dll"
#endif

#ifndef UNIX_RUST_G_DLL_LOCATION
	#define UNIX_RUST_G_DLL_LOCATION "lib/librust_g.so"
#endif

#ifndef RUST_G_LOCATION
	#define RUST_G_LOCATION (world.system_type == MS_WINDOWS ? WINDOWS_RUST_G_DLL_LOCATION : UNIX_RUST_G_DLL_LOCATION)
#endif
