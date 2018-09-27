list=""
n=1

for de in `cat <<-Desktop_Environments
    KDE
    GNOME
    Cinnamon
    XFCE
Desktop_Environments`; do
    list="$list $de $n off"
    n=`expr $n + 1`
done

chosen=`dialog --stdout --checklist \
'Choose desktops you like:' 11 36 4 $list`

if [ $? -eq 0 ]; then
	for choice in $chosen; do
		echo "You selected $choice"
	done
fi
