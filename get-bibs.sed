#(##defaults(target_files="TARGET_FILES")##)

# Parses a .aux file to find bibdata information
/^\\bibdata/!d

# Remove the \bibdata{} from around the pertinent information
s/\\bibdata{\([^}]*\)}/\1,/

# Collapse comma sequences
s/,\{2,\}/,/g

# Escape spaces in file names
s/[[:space:]]/\\&/g

# Change to a space-delimited list of .bib names
s/,/.bib /g

# Remove all trailing spaces
s/ \{1,\}$//

