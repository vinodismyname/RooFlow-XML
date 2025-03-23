#!/usr/bin/env bash

# ------------- Color definitions -------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

log_info()   { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn()   { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error()  { echo -e "${RED}[ERROR]${NC} $*"; }

# ------------- Check dependencies -------------
check_dependencies() {
  local missing_deps=()
  
  # Check for git if in remote mode
  if [[ -n "$REMOTE_URL" ]] && ! command -v git &>/dev/null; then
    missing_deps+=("git")
  fi
  
  # Check for yq
  if ! command -v yq &>/dev/null; then
    missing_deps+=("yq")
  fi
  
  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    log_error "Missing dependencies: ${missing_deps[*]}"
    log_error "Please install them before running this script."
    exit 1
  fi
}

# ------------- Simple usage -------------
usage() {
  echo "Usage:"
  echo "  Local mode: $0 [--override] [--xml]"
  echo "  Remote mode: $0 <REPO_URL> [--override] [--xml]"
  echo
  echo "Options:"
  echo "  --override    Override existing .roo folder if it exists"
  echo "  --xml         Convert YAML files to XML format before saving"
  exit 0
}

# ------------- Parse arguments -------------
REMOTE_URL=""
OVERRIDE=false
CONVERT_TO_XML=false

for arg in "$@"; do
  case "$arg" in
    --help|-h)
      usage
      ;;
    --override)
      OVERRIDE=true
      ;;
    --xml)
      CONVERT_TO_XML=true
      ;;
    --*)
      log_warn "Unknown option: $arg"
      ;;
    *)
      if [[ -z "$REMOTE_URL" ]]; then
        REMOTE_URL="$arg"
      fi
      ;;
  esac
done

# ------------- Workspace utilities -------------
get_workspace_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/packageInfo" ]]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1  # Return error code if no workspace root found
}

# ------------- Basic directory setup -------------
WORKSPACE_ROOT=$(get_workspace_root 2>/dev/null || echo "$PWD")
ROO_DIR="$WORKSPACE_ROOT/.roo"

# ------------- Determine OS and set sed options -------------
if [[ "$(uname)" == "Darwin" ]]; then
  SED_IN_PLACE=(-i "")
else
  SED_IN_PLACE=(-i)
fi

# -------------  Function to escape strings for sed ------------- 
escape_for_sed() {
  echo "$1" | sed 's/[\/&]/\\&/g'
}

# ------------- Convert YAML to XML -------------
convert_to_xml() {
  local file="$1"
  local temp_file="$(mktemp)"
  
  log_info "Converting $file to XML format..."
  # Convert YAML to XML using yq and save to a temporary file
  yq -o=xml "$file" > "$temp_file"
  
  if [[ $? -eq 0 ]]; then
    # Replace the original file with the XML content
    mv "$temp_file" "$file"
    log_info "Successfully converted $file to XML format"
    return 0
  else
    log_error "Failed to convert $file to XML format"
    rm "$temp_file"
    return 1
  fi
}

# ------------- Setup directories -------------
setup_directories() {
  # Handle .roo directory
  if [[ -d "$ROO_DIR" ]]; then
    if $OVERRIDE; then
      log_info "Overriding existing .roo directory..."
      rm -rf "$ROO_DIR"
      mkdir -p "$ROO_DIR"
    else
      log_info "Using existing .roo directory..."
    fi
  else
    log_info "Creating new .roo directory at $ROO_DIR..."
    mkdir -p "$ROO_DIR"
  fi
}

# ------------- Clone the repo if in remote mode -------------
clone_repo_if_needed() {
  [[ -z "$REMOTE_URL" ]] && { log_info "Local mode: Using existing local files."; return; }

  log_info "Remote mode: Fetching files from $REMOTE_URL ..."
  TEMP_DIR=$(mktemp -d)
  trap 'rm -rf "$TEMP_DIR"' EXIT
  
  git init "$TEMP_DIR"
  cd "$TEMP_DIR" || exit 1
  git remote add origin "$REMOTE_URL"
  git config core.sparseCheckout true
  
  mkdir -p .git/info
  cat > .git/info/sparse-checkout <<EOF
config/.roo
config/.rooignore
config/.roomodes
EOF
  
  git pull --depth=1 origin mainline || git pull --depth=1 origin main
  
  cd - >/dev/null || exit 1
  
  if [[ ! -d "$TEMP_DIR/config/.roo" ]]; then
    log_error "Required files not found in the cloned repository. Check paths."
    exit 1
  fi
  
  # Copy the files
  if [[ -d "$TEMP_DIR/config/.roo" ]]; then
    mkdir -p "$ROO_DIR"
    
    # Process each file
    for file in "$TEMP_DIR/config/.roo/"*; do
      local basename=$(basename "$file")
      local dest="$ROO_DIR/$basename"
      
      # Copy file to destination
      cp -f "$file" "$dest" 2>/dev/null || true
      log_info "Copied $basename to $dest"
    done
  fi
  
  [[ -f "$TEMP_DIR/config/.rooignore" ]] && cp -f "$TEMP_DIR/config/.rooignore" "$WORKSPACE_ROOT"/ || true
  [[ -f "$TEMP_DIR/config/.roomodes" ]] && cp -f "$TEMP_DIR/config/.roomodes" "$WORKSPACE_ROOT"/ || true
  
  log_info "Files extracted successfully."
}

# ------------- Replace placeholders in system prompts -------------
process_system_prompts() {
  # Global placeholders
  local GLOBAL_SETTINGS="$HOME/.vscode-server/data/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_custom_modes.json"
  local MCP_LOCATION="$HOME/.local/share/Roo-Code/MCP"
  local MCP_SETTINGS="$HOME/.vscode-server/data/User/globalStorage/rooveterinaryinc.roo-cline/settings/cline_mcp_settings.json"

  if [[ ! -d "$ROO_DIR" ]]; then
    log_error "ROO_DIR ($ROO_DIR) doesn't exist. Cannot process system prompts."
    return 1
  fi

  # Process prompt files
  find "$ROO_DIR" -type f -name "system-prompt-*" 2>/dev/null | while IFS= read -r file; do
    log_info "Processing system prompt: $file"
    
    # Replace other placeholders with sed
    sed "${SED_IN_PLACE[@]}" "s|WORKSPACE_PLACEHOLDER|$(escape_for_sed "$WORKSPACE_ROOT")|g" "$file"
    sed "${SED_IN_PLACE[@]}" "s|GLOBAL_SETTINGS_PLACEHOLDER|$(escape_for_sed "$GLOBAL_SETTINGS")|g" "$file"
    sed "${SED_IN_PLACE[@]}" "s|MCP_LOCATION_PLACEHOLDER|$(escape_for_sed "$MCP_LOCATION")|g" "$file"
    sed "${SED_IN_PLACE[@]}" "s|MCP_SETTINGS_PLACEHOLDER|$(escape_for_sed "$MCP_SETTINGS")|g" "$file"

    log_info "Completed: $file"
  done
  
  # If XML conversion is enabled, convert all files in .roo after all processing is done
  if $CONVERT_TO_XML; then
    log_info "Converting all files to XML format..."
    find "$ROO_DIR" -type f 2>/dev/null | while IFS= read -r file; do
      # Skip files that already appear to be in XML format
      if grep -q "<?xml" "$file" 2>/dev/null; then
        log_info "Skipping $file which appears to already be in XML format"
        continue
      fi
      convert_to_xml "$file"
    done
  fi
}

# ----------------- Main Flow -----------------
check_dependencies      # Check for required tools
setup_directories       # Ensure .roo exists, create/override as needed
clone_repo_if_needed    # If URL is passed, clone; else do nothing
process_system_prompts  # Replace placeholders and convert to XML if needed

log_info "All tasks completed successfully."