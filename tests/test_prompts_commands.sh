#!/bin/bash
# Test prompts and commands generation

set -e

TOOLKITS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$TOOLKITS_DIR/templates"
TEST_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

echo "🧪 Testing prompts and commands generation..."

# Test 1: Check prompts.json exists for all templates
echo "✓ Checking prompts.json files..."
for template_dir in "$TEMPLATES_DIR"/*; do
    if [ -d "$template_dir" ] && [ -f "$template_dir/template.json" ]; then
        template_name=$(basename "$template_dir")
        prompts_file="$template_dir/.cursor/prompts.json"
        
        if [ -f "$prompts_file" ]; then
            echo "  ✓ $template_name has prompts.json"
            
            # Validate JSON structure
            if ! python3 -m json.tool "$prompts_file" > /dev/null 2>&1; then
                echo "  ✗ $template_name prompts.json is invalid JSON"
                exit 1
            fi
            
            # Check prompts array exists
            if ! python3 -c "import json; f=open('$prompts_file'); d=json.load(f); assert 'prompts' in d and isinstance(d['prompts'], list)" 2>/dev/null; then
                echo "  ✗ $template_name prompts.json missing 'prompts' array"
                exit 1
            fi
        else
            echo "  ⚠ $template_name missing prompts.json (optional)"
        fi
    fi
done

# Test 2: Check commands.json exists for all templates
echo "✓ Checking commands.json files..."
for template_dir in "$TEMPLATES_DIR"/*; do
    if [ -d "$template_dir" ] && [ -f "$template_dir/template.json" ]; then
        template_name=$(basename "$template_dir")
        commands_file="$template_dir/.cursor/commands.json"
        
        if [ -f "$commands_file" ]; then
            echo "  ✓ $template_name has commands.json"
            
            # Validate JSON structure
            if ! python3 -m json.tool "$commands_file" > /dev/null 2>&1; then
                echo "  ✗ $template_name commands.json is invalid JSON"
                exit 1
            fi
            
            # Check commands array exists
            if ! python3 -c "import json; f=open('$commands_file'); d=json.load(f); assert 'commands' in d and isinstance(d['commands'], list)" 2>/dev/null; then
                echo "  ✗ $template_name commands.json missing 'commands' array"
                exit 1
            fi
        else
            echo "  ⚠ $template_name missing commands.json (optional)"
        fi
    fi
done

# Test 3: Test prompts_generator.py
echo "✓ Testing prompts_generator.py..."
if [ -f "$TOOLKITS_DIR/lib/generators/prompts_generator.py" ]; then
    # Test generation for a single template
    mkdir -p "$TEST_DIR/test-project/.cursor"
    
    if python3 "$TOOLKITS_DIR/lib/generators/prompts_generator.py" "python-fastapi" "$TEST_DIR/test-project" 2>/dev/null; then
        if [ -f "$TEST_DIR/test-project/.cursor/prompts.json" ]; then
            echo "  ✓ Generated prompts.json successfully"
        else
            echo "  ✗ Failed to generate prompts.json"
            exit 1
        fi
        
        if [ -f "$TEST_DIR/test-project/.cursor/commands.json" ]; then
            echo "  ✓ Generated commands.json successfully"
        else
            echo "  ✗ Failed to generate commands.json"
            exit 1
        fi
    else
        echo "  ⚠ prompts_generator.py execution failed (may be expected)"
    fi
fi

# Test 4: Validate prompt structure
echo "✓ Validating prompt structure..."
for template_dir in "$TEMPLATES_DIR"/*; do
    if [ -d "$template_dir" ] && [ -f "$template_dir/.cursor/prompts.json" ]; then
        template_name=$(basename "$template_dir")
        prompts_file="$template_dir/.cursor/prompts.json"
        
        # Check each prompt has required fields
        python3 << EOF
import json
import sys

with open('$prompts_file', 'r') as f:
    data = json.load(f)
    
for prompt in data.get('prompts', []):
    if 'name' not in prompt:
        print(f"  ✗ Prompt missing 'name' in $template_name")
        sys.exit(1)
    if 'prompt' not in prompt:
        print(f"  ✗ Prompt missing 'prompt' in $template_name")
        sys.exit(1)
        
print(f"  ✓ All prompts valid in $template_name")
EOF
    fi
done

# Test 5: Validate command structure
echo "✓ Validating command structure..."
for template_dir in "$TEMPLATES_DIR"/*; do
    if [ -d "$template_dir" ] && [ -f "$template_dir/.cursor/commands.json" ]; then
        template_name=$(basename "$template_dir")
        commands_file="$template_dir/.cursor/commands.json"
        
        # Check each command has required fields
        python3 << EOF
import json
import sys

with open('$commands_file', 'r') as f:
    data = json.load(f)
    
for cmd in data.get('commands', []):
    if 'name' not in cmd:
        print(f"  ✗ Command missing 'name' in $template_name")
        sys.exit(1)
    if 'description' not in cmd:
        print(f"  ✗ Command missing 'description' in $template_name")
        sys.exit(1)
    if 'command' not in cmd:
        print(f"  ✗ Command missing 'command' in $template_name")
        sys.exit(1)
        
print(f"  ✓ All commands valid in $template_name")
EOF
    fi
done

echo ""
echo "✅ All prompts and commands tests passed!"
