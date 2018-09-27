#!/bin/sh


#the first version of say:
say()
{
	v1="Veni Vidi Vici"
	echo $v1
}

say
exit 0


#the second version of say:
say()
{
	echo $1
}

v1="Veni Vidi Vici"

say "$v1"
# Quiz: What would happen if we don't double-quote $v1 above?
exit 0


#the third version of say:
say()
{
	set "Adios Amigos!"
	echo $1
}

v1="Veni Vidi Vici"
say "$v1"
exit 0


#the fourth version of say:
say()
{
	echo "Starting for quoted $*  ..."
	for arg in "$*"; do
		echo "$arg"
	done

	echo	# produce an artificial empty line

	echo "Starting for quoted $@  ..."
	for arg in "$@"; do
		echo "$arg"
	done
}

v1="Bourne Identity"
v2="Bourne Supremacy"
say "$v1" $v2
exit 0
