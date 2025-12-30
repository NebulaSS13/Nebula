#!/bin/bash

set -euo pipefail
python tools/od_annotator/__main__.py "$@"
