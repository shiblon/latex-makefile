#(##defaults(target_files="TARGET_FILES") ##)

# Skip any line that doesn't say "datasource".
/datasource/!d

# Remove everything up to and including the next >.
s/^[^>]*>//g

# Remove everything after < to the end.
s/<.*$//g

# Add .bib extension if not present.
/\.bib$/!s/$/.bib/

# Convert into a dependency line by adding dependent targets.
s!^!(##target_files##): !
