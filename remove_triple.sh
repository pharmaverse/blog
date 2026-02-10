#!/bin/bash

# This script renames files and directories by REMOVING ALL periods ('.')
# EXCEPT for the period that marks the file extension (e.g., .qmd, .R).
# It uses only standard Linux utilities (find, mv, basename, dirname, sed)
# and does NOT require installing any new software.

# Define the starting directory (e.g., current directory or /path/to/your/repo)
START_DIR="/cloud/project/posts"

# The character to remove
CHAR_TO_REMOVE="."

echo "DRY RUN: This will show you what would be renamed."
echo "----------------------------------------------------------------------"

# Process both files and directories, deepest first.
# Using -depth ensures we rename contents before their parent directories.
# We're looking for any name containing a period to process.
find "$START_DIR" -depth -name "*$CHAR_TO_REMOVE*" -print0 | while IFS= read -r -d $'\0' old_path; do
    original_name=$(basename "$old_path")
    parent_dir=$(dirname "$old_path")
    new_name=""

    # Check if the path points to a file or a directory
    if [ -f "$old_path" ]; then
        # --- Handle Files ---
        local_filename_base=""
        local_extension=""

        # Check for a "real" extension (i.e., there's text before the last dot, and text after it)
        # This handles cases like "file.txt" (extension .txt) and ".bashrc" (no extension, entire name is base)
        if [[ "$original_name" == *.* && "${original_name%.*}" != "" ]]; then
            local_extension=".${original_name##*.}"
            local_filename_base="${original_name%.*}"
        else
            # No discernible extension, or it's a hidden file like '.bashrc'
            # Treat the entire name as the base filename
            local_filename_base="$original_name"
        fi

        # Remove all periods from the filename base part
        # Note: CHAR_TO_REMOVE ('.') is a special regex character, so it must be escaped in sed.
        modified_filename_base=$(echo "$local_filename_base" | sed "s/\\$CHAR_TO_REMOVE//g") # Changed here

        # Reconstruct the new file name by combining the modified base with the original extension
        new_name="${modified_filename_base}${local_extension}"

    elif [ -d "$old_path" ]; then
        # --- Handle Directories ---
        # For directories, remove all periods
        new_name=$(echo "$original_name" | sed "s/\\$CHAR_TO_REMOVE//g") # Changed here
    fi

    # Only perform a rename if the name actually changed and is not empty
    if [ -n "$new_name" ] && [ "$original_name" != "$new_name" ]; then
        full_new_path="$parent_dir/$new_name"
        echo "mv \"$old_path\" \"$full_new_path\""
        # Uncomment the line below to actually rename
        mv "$old_path" "$full_new_path"
    fi
done

echo "----------------------------------------------------------------------"
echo "Dry run complete."
echo "If the output looks correct, edit this script, remove 'echo' before the 'mv' commands, and run it again to perform the actual renaming."
