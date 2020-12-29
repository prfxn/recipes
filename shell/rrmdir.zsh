#
#  rrmdir -- recursive rmdir
#
#  Traverses a tree of directories "depth-first", to call rmdir on all directories
#  encountered during the traversal.
#
#  Example -
#  Given a tree of files and directories -
#  foo
#  ├── bar
#  │   └── baz
#  └── boo
#      └── .keep
#      └── baa
#          └── bloo
#  where .keep is a file,
#
#  rrmdir foo
#
#  removes the following paths -
#    foo/bar/baz
#    foo/bar
#    foo/boo/baa/bloo
#    foo/boo/baa
#
#  The filepath foo/boo/.keep is left untouched
#

function rrmdir { (
    find "$@" -type d |
    tail -r |
    while read dirpath
    do
        $(rmdir "$dirpath" 2>/dev/null) && >&2 echo "removed: $dirpath"
    done
) }
