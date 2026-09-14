#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEMO_SPEC="$REPO_ROOT/Demo/project.yml"
DEMO_PROJECT="$REPO_ROOT/Demo/PinterestSegmentDemo.xcodeproj"

if ! command -v xcodegen > /dev/null 2>&1; then
    echo "error: xcodegen is required to generate the demo project." >&2
    echo "Install it with: brew install xcodegen" >&2
    exit 1
fi

xcodegen generate --spec "$DEMO_SPEC"
open "$DEMO_PROJECT"
