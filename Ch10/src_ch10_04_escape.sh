escape()
{
    out=`echo $1 | sed 's|\\\\|\\\\\\\\|g'`     #  \ becomes \\
    out=`echo $out | sed 's|/|\\\\/|g'`         #  / becomes \/
    echo $out
}
