#!/bin/sh

OUTPUT_FILE="config_dump.txt"

# Clear the output file if it exists
> "$OUTPUT_FILE"

echo "==== DIRECTORY TREE ====" >> "$OUTPUT_FILE"

if command -v git >/dev/null 2>&1 && [ -d .git ]; then
  # Use git to get all files not ignored by .gitignore
  # Print a tree-like structure from the list
  git ls-files --cached --others --exclude-standard | \
    grep -v -e "^$OUTPUT_FILE\$" -e "^dump_config.sh\$" | \
    awk '{
      n=split($0,a,"/");
      path="";
      for(i=1;i<n;i++) {
        path=path a[i];
        print path "/";
        path=path "/";
      }
      print $0;
    }' | sort -u | sed 's/^/./' >> "$OUTPUT_FILE"
else
  # Fallback: Attempt to display the directory tree, excluding .git directory
  tree --prune -I '.git' . >> "$OUTPUT_FILE" 2>&1 || echo "INFO: 'tree' command not found or failed, or doesn't support --prune/-I. Skipping directory tree output." >> "$OUTPUT_FILE"
fi

echo "==== END OF DIRECTORY TREE ====\n" >> "$OUTPUT_FILE"

echo "==== FILE CONTENTS ====" >> "$OUTPUT_FILE"

if command -v git >/dev/null 2>&1 && [ -d .git ]; then
  # Use git to get all files not ignored by .gitignore
  git ls-files --cached --others --exclude-standard | \
    grep -v -e "^$OUTPUT_FILE\$" -e "^dump_config.sh\$" | \
    while read -r file; do
      # Print the file path to the output file
      echo "\n==== FILE: $file ====" >> "$OUTPUT_FILE"
      # Print the file content to the output file
      cat "$file" >> "$OUTPUT_FILE"
      # Print a separator to the output file
      echo "\n==== END OF FILE: $file ====" >> "$OUTPUT_FILE"
    done
else
  # Fallback: Find all files, excluding specified paths and the .git directory
  find . -type d -name '.git' -prune -o -type f \
    -not -path "./$OUTPUT_FILE" \
    -not -path "./dump_config.sh" \
    -not -path "./.gitignore" \
    -print | while read -r file; do
      # Print the file path to the output file
      echo "\n==== FILE: $file ====" >> "$OUTPUT_FILE"
      # Print the file content to the output file
      cat "$file" >> "$OUTPUT_FILE"
      # Print a separator to the output file
      echo "\n==== END OF FILE: $file ====" >> "$OUTPUT_FILE"
    done
fi

echo "\n==== END OF FILE CONTENTS ====" >> "$OUTPUT_FILE"

# Count lines and words in the output file
LINE_COUNT=$(wc -l < "$OUTPUT_FILE")
WORD_COUNT=$(wc -w < "$OUTPUT_FILE")

# Report the counts to the terminal
echo "\nConfiguration dump written to $OUTPUT_FILE (excluding .gitignore, script, output file, and respecting .gitignore if possible)"
echo "Total lines: $LINE_COUNT"
echo "Total words: $WORD_COUNT"
