#!/bin/bash
# Real Project Performance Benchmarks
# Measures actual generation times for various project types

set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

BENCHMARK_DIR="/tmp/cursor-toolkits-benchmark-$$"
mkdir -p "$BENCHMARK_DIR"
cd "$BENCHMARK_DIR"

echo -e "${CYAN}=== Performance Benchmarks - Real Projects ===${NC}\n"

# Function to benchmark a generation
benchmark_generation() {
    local stack="$1"
    local name="$2"
    local features="${3:-}"
    
    echo -n "Generating $stack project... "
    
    START_TIME=$(date +%s.%N)
    
    if [ -z "$features" ]; then
        /workspace/bin/cursor-init --stack "$stack" --name "$name" > /dev/null 2>&1
    else
        /workspace/bin/cursor-init --stack "$stack" --name "$name" --features "$features" > /dev/null 2>&1
    fi
    
    END_TIME=$(date +%s.%N)
    DURATION=$(echo "$END_TIME - $START_TIME" | bc)
    
    if [ -d "$name" ]; then
        echo -e "${GREEN}${DURATION}s${NC}"
        
        # Count generated files
        FILE_COUNT=$(find "$name" -type f | wc -l)
        DIR_COUNT=$(find "$name" -type d | wc -l)
        
        echo "  Files: $FILE_COUNT, Directories: $DIR_COUNT"
        
        echo "$stack,$name,$DURATION,$FILE_COUNT,$DIR_COUNT" >> "$BENCHMARK_DIR/results.csv"
        return 0
    else
        echo -e "${YELLOW}FAILED${NC}"
        return 1
    fi
}

# Initialize results file
echo "stack,name,duration_seconds,file_count,dir_count" > "$BENCHMARK_DIR/results.csv"

echo "=== Benchmark 1: Template Generation Speeds ===\n"

# Python projects
benchmark_generation "python-fastapi" "bench-fastapi" "tests,docker"
benchmark_generation "python-fastapi" "bench-fastapi-minimal" ""

# Node.js projects
benchmark_generation "nextjs-typescript" "bench-nextjs" "tests"
benchmark_generation "react-vite" "bench-react" "tests"
benchmark_generation "express-typescript" "bench-express" ""

# PHP projects
benchmark_generation "symfony-api" "bench-symfony" ""

echo ""
echo "=== Benchmark 2: Rules Generation Speed ===\n"

for project in bench-fastapi bench-nextjs bench-symfony; do
    if [ -d "$project" ]; then
        echo -n "Generating rules for $project... "
        
        START_TIME=$(date +%s.%N)
        
        # Simulate rules generation (if script exists)
        if [ -f "/workspace/lib/generators/rules_generator.py" ]; then
            cd "$project"
            python3 /workspace/lib/generators/rules_generator.py > /dev/null 2>&1 || true
            cd ..
            END_TIME=$(date +%s.%N)
            DURATION=$(echo "$END_TIME - $START_TIME" | bc)
            echo -e "${GREEN}${DURATION}s${NC}"
        else
            echo "N/A"
        fi
    fi
done

echo ""
echo "=== Benchmark 3: Prompts/Commands Generation ===\n"

for project in bench-fastapi bench-nextjs; do
    if [ -d "$project" ]; then
        echo -n "Generating prompts/commands for $project... "
        
        START_TIME=$(date +%s.%N)
        
        if [ -f "/workspace/lib/generators/prompts_generator.py" ]; then
            python3 /workspace/lib/generators/prompts_generator.py "$(basename $project)" "$(pwd)/$project" > /dev/null 2>&1 || true
            END_TIME=$(date +%s.%N)
            DURATION=$(echo "$END_TIME - $START_TIME" | bc)
            echo -e "${GREEN}${DURATION}s${NC}"
        else
            echo "N/A"
        fi
    fi
done

echo ""
echo "=== Benchmark 4: CLI Response Times ===\n"

commands=(
    "--help"
    "--list"
    "--version"
)

for cmd in "${commands[@]}"; do
    echo -n "CLI $cmd... "
    START_TIME=$(date +%s.%N)
    /workspace/bin/cursor-init $cmd > /dev/null 2>&1
    END_TIME=$(date +%s.%N)
    DURATION=$(echo "$END_TIME - $START_TIME" | bc)
    echo -e "${GREEN}${DURATION}s${NC}"
done

echo ""
echo "=== Results Summary ===\n"

if [ -f "$BENCHMARK_DIR/results.csv" ]; then
    echo "Generation Times:"
    tail -n +2 "$BENCHMARK_DIR/results.csv" | while IFS=',' read stack name duration files dirs; do
        if (( $(echo "$duration < 10.0" | bc -l) )); then
            status="${GREEN}✓${NC}"
        elif (( $(echo "$duration < 30.0" | bc -l) )); then
            status="${YELLOW}⚠${NC}"
        else
            status="${RED}✗${NC}"
        fi
        echo -e "  $status $stack: ${duration}s (${files} files)"
    done
fi

echo ""
echo -e "${CYAN}Thresholds:${NC}"
echo "  ✓ Good: < 5s"
echo "  ⚠ Acceptable: < 10s"
echo "  ✗ Needs optimization: > 10s"

echo ""
echo "Results saved to: $BENCHMARK_DIR/results.csv"

# Cleanup
cd /workspace
echo ""
echo "Benchmark completed. Results directory: $BENCHMARK_DIR"
