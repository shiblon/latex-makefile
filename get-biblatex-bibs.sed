#(##defaults(target_files="TARGET_FILES")##)

# Parses a .bcf file to find datasource tag
/^[[:space:]]*<bcf:datasource[[:space:]]/!d

# Extract text from datasouce tag
s/^.*>\(.*\)<.*$/\1,/

# Collapse comma sequences
s/,\{2,\}/,/g

# Escape spaces in file names
s/[[:space:]]/\\\\&/g

# Remove trailing comma
s/,/ /g

# Remove all trailing spaces
s/ \{1,\}$//

