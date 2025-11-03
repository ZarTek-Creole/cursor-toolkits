#!/usr/bin/env bash
# Logging functions

readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=2
readonly LOG_LEVEL_ERROR=3

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_debug() {
    [[ "${LOG_LEVEL:-$LOG_LEVEL_INFO}" -le $LOG_LEVEL_DEBUG ]] && \
        echo -e "${BLUE}[DEBUG]${NC} $*" >&2
}

log_info() {
    [[ "${LOG_LEVEL:-$LOG_LEVEL_INFO}" -le $LOG_LEVEL_INFO ]] && \
        echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    [[ "${LOG_LEVEL:-$LOG_LEVEL_INFO}" -le $LOG_LEVEL_WARN ]] && \
        echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    [[ "${LOG_LEVEL:-$LOG_LEVEL_INFO}" -le $LOG_LEVEL_ERROR ]] && \
        echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}
