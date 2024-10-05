#!/bin/bash

# Check if correct number of arguments is passed
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <source_directory>"
  exit 1
fi

# Get source directory from argument
SOURCE_DIR=$1

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory does not exist: $SOURCE_DIR"
  exit 1
fi

# Create destination directory by appending '_pzstd' to the source directory name
DEST_DIR="${SOURCE_DIR}_pzstd"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Compress each file in the source directory using pzstd with 16 cores
for file in "$SOURCE_DIR"/*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    
    # Check if the file is metadata.yaml, if so just copy it
    if [ "$filename" == "metadata.yaml" ]; then
      cp "$file" "$DEST_DIR/$filename"
      echo "Copied: $file -> $DEST_DIR/$filename"
    else
      # Otherwise, compress it
      pzstd -p24 "$file" -o "$DEST_DIR/${filename}.zst "
      echo "Compressed: $file -> $DEST_DIR/${filename}.zst"
    fi
  fi
done

echo "Compression complete. Files are saved in $DEST_DIR."

