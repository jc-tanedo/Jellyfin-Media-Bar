#!/bin/bash

# bump - A script to bump version tags in git
# Usage: ./bump [patch|minor|major]

set -e

BUMP_TYPE="${1:-patch}"

if [[ ! "$BUMP_TYPE" =~ ^(patch|minor|major)$ ]]; then
    echo "Usage: $0 [patch|minor|major]"
    exit 1
fi

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
VERSION=${LATEST_TAG#v}

if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    VERSION="0.0.0"
fi

IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

case $BUMP_TYPE in
    patch) NEW_TAG="v${MAJOR}.${MINOR}.$((PATCH + 1))" ;;
    minor) NEW_TAG="v${MAJOR}.$((MINOR + 1)).0" ;;
    major) NEW_TAG="v$((MAJOR + 1)).0.0" ;;
esac

git tag -a "$NEW_TAG" -m "Bump $BUMP_TYPE version to $NEW_TAG"
echo "$NEW_TAG"
