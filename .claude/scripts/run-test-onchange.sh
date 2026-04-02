#!/bin/bash

HOOK_INPUT=$(cat)
FILE_PATH=$(echo "$HOOK_INPUT" | jq -r '.tool_input.path' 2>/dev/null)

# Only for C# changes
if [[ ! "$FILE_PATH" =~ \.cs$ ]]; then
    exit 0
fi

echo "[HOOK] Running relevant tests for: $FILE_PATH" >&2

# Don't run tests for test files themselves
if [[ "$FILE_PATH" =~ \.Test\.cs$|\.Tests\.cs$ ]]; then
    echo "[HOOK] File is a test file, skipping auto-test" >&2
    exit 0
fi

# Extract the class name and find matching tests
CLASS_NAME=$(basename "$FILE_PATH" .cs)
TEST_PATTERN="${CLASS_NAME}Tests"

echo "[HOOK] Looking for tests matching: $TEST_PATTERN" >&2

# Find and run tests
if command -v dotnet &> /dev/null; then
    # Run specific test class if it exists
    dotnet test --filter "FullyQualifiedName~$TEST_PATTERN" \
        --no-build \
        --logger "console;verbosity=minimal" \
        2>/dev/null
    
    TEST_RESULT=$?
    
    if [ $TEST_RESULT -eq 0 ]; then
        echo "[HOOK] ✓ Tests passed" >&2
        exit 0
    else
        echo "[HOOK] ⚠️  Tests failed - review changes" >&2
        exit 1  # Warning
    fi
fi

exit 0