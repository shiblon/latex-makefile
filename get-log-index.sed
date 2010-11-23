#(##defaults(target_files="TARGET_FILES")##)

# Look for missing index or glossary files.
s/^No file \(.*\.ind\)\.$/TARGETS=\1/
s/^No file \(.*\.[gn]ls\)\.$/TARGETS=\1/
# Escape spaces in file names
s/[[:space:]]/\\&/g

# If we have a target, rewrite it to be a make dependency rule
/^TARGETS=/{
  # Save it, rewrite to a make dependency
  h
  s!^TARGETS=!(##target_files##): !p
  # Get the old one back, add yet another make dependency
  g
  s!^TARGETS=\(.*\)!\1: (##stem##).tex!p
}
# Anything else is trash
d
