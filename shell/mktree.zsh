#
#  mktree -- create a tree of folders specified via command-line arguments
#
#  Usage:
#  [mkdir_mode=<mode>] mktree dir [dir dir ...]
#
#  Processes the list of dir arguments as follows -
#  1. If the argument is an ancestor directory reference comprising of dots (.)
#     or forward-slashes (/), changes to that ancestor directory
#  2. If not, creates a new directory named as the argument value in the current
#     working directory, if one does not already exist
#  3. If the argument's value ends with a forward-slash (/), also changes to the
#     newly created directory
#
#  If mkdir_mode env var is set, passes it's value to mkdir's -m option while
#  creating a directory
#
#  Example -
#
#  mktree `<<eof
#      foo/
#          foo1
#          foo2
#          ..
#      bar
#      baz/
#          baz0
#          ..
#  eof`
#
#  creates the following directory tree -
#
#  .
#  ├── bar
#  ├── baz
#  │   └── baz0
#  └── foo
#      ├── foo1
#      └── foo2
#

function mktree { (
    startDir="$PWD"
    [ -n "$mkdir_mode" ] && mkdir_mode=("-m" "$mkdir_mode")
    ancestorRefPtrn='^[\.\/]+$'

    for dir in "$@"
    do
        if [[ "$dir" =~ $ancestorRefPtrn ]]; then
            cd $dir
            continue
        fi

        absDirPath=${PWD}/"${dir%/}"
        relDirPath=${absDirPath#"$startDir/"}
        if [ -d "$dir" ]; then
            >&2 echo "exists: $relDirPath"
        else
            if [ `mkdir -p ${mkdir_mode} "$dir"; echo $?` -ne 0 ]; then
                >&2 echo "failed to create: $relDirPath"
                >&2 echo "exiting"
                return 1
            fi
            >&2 echo "created: $relDirPath"
        fi

        [[ "$dir" == */ ]] && cd "$dir"
    done
) }
