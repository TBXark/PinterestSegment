SIMULATOR ?= iPhone 16

.PHONY: demo demo-build build test format lint ci

demo:
	./Scripts/demo.sh

demo-build:
	xcodegen generate --spec Demo/project.yml
	xcodebuild -project Demo/PinterestSegmentDemo.xcodeproj \
		-scheme PinterestSegmentDemo \
		-destination 'generic/platform=iOS Simulator' \
		build

build:
	xcodebuild -scheme PinterestSegment \
		-destination 'generic/platform=iOS Simulator' \
		build

test:
	xcodebuild test -scheme PinterestSegment \
		-destination 'platform=iOS Simulator,name=$(SIMULATOR)'

format:
	swift format --in-place --recursive Sources Tests Demo/Sources

lint:
	swift format lint --recursive --strict Sources Tests Demo/Sources

ci: build test lint demo-build
