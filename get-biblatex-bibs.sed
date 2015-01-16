#(##defaults(target_files="TARGET_FILES")##)

# ???
/^[[:space:]]*<bcf:datasource[[:space:]]/!d

# ???
s/^.*>\(.*\)<.*$/\1,/

# ???
s/,\{2,\}/,/g

# ???
s/[[:space:]]/\\\\&/g

# ???
s/,/ /g

# ???
s/ \{1,\}$//

