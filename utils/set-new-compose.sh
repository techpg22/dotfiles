#!/bin/bash

# ==============================================================================
# SCRIPT: setup-project.sh
# 
# DESCRIPTION:
#   Automates the creation of a new Docker project directory. It sets up the 
#   standard folder structure and populates it with template configuration files.
#
# USAGE:
#   ./setup-project.sh <new_project_name>
#
# EXAMPLE:
#   ./setup-project.sh my-web-app
# ==============================================================================

# Define default source file names
TEMPLATE_COMPOSE="template-docker-compose.yml"
TEMPLATE_ENV="template.env"

# Define default destination file names
COMPOSE_DEST="docker-compose.yml"
ENV_DEST=".env"
VOLUMES_DIR="volumes"

# Get the target directory from the first command-line argument
TARGET_DIR="$1"

# 1. VALIDATION: Check if the target directory name was provided
if [ -z "$TARGET_DIR" ]; then
  echo "Usage: $0 <target_directory>"
  echo "Example: $0 my-new-app"
  exit 1
fi

# 2. VALIDATION: Check if the target directory already exists to prevent overwriting
if [ -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' already exists."
  exit 1
fi

# 3. VALIDATION: Ensure source templates exist before proceeding
if [ ! -f "$TEMPLATE_COMPOSE" ]; then
  echo "Error: Template Docker Compose file '$TEMPLATE_COMPOSE' not found."
  exit 1
fi

if [ ! -f "$TEMPLATE_ENV" ]; then
  echo "Error: Template environment file '$TEMPLATE_ENV' not found."
  exit 1
fi

# --- EXECUTION ---

# Create the main target directory
echo "Creating directory '$TARGET_DIR'..."
mkdir "$TARGET_DIR"

# Create the volumes directory inside the target directory
echo "Creating volumes directory in '$TARGET_DIR/$VOLUMES_DIR'..."
mkdir "$TARGET_DIR/$VOLUMES_DIR"

# Copy and rename the template Docker Compose file
echo "Copying '$TEMPLATE_COMPOSE' -> '$TARGET_DIR/$COMPOSE_DEST'..."
cp "$TEMPLATE_COMPOSE" "$TARGET_DIR/$COMPOSE_DEST"

# Copy and rename the template environment file
echo "Copying '$TEMPLATE_ENV' -> '$TARGET_DIR/$ENV_DEST'..."
cp "$TEMPLATE_ENV" "$TARGET_DIR/$ENV_DEST"

echo "----------------------------------------------------------"
echo "Success! Project '$TARGET_DIR' is ready."
echo "Structure created:"
echo "  $TARGET_DIR/"
echo "  ├── $COMPOSE_DEST"
echo "  ├── $ENV_DEST"
echo "  └── $VOLUMES_DIR/"
echo "----------------------------------------------------------"