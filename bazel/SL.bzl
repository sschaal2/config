# general variables for faciliting builds for SL
SL_ROOT = "//third_party/SL/"
SL_ROOT_WS = "third_party/SL/"
SL_VISIBILITY = ["//third_party/SL:__subpackages__", "//experimental:__subpackages__"]
#SL_ROOT = "//"
#SL_ROOT_WS = ""
#SL_VISIBILITY = ["//:__subpackages__","//experimental:__subpackages__"]

FEATURES = [
    "-parse_headers",
    "-use_header_modules",
    "-layering_check",
]

DEFAULT_COPTS = [
]
