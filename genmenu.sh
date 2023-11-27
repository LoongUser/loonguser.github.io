#!/bin/bash
cd content
menu=content.zh/menu/index.md
destdir=content.zh/
sed -i '5,$ d' $menu


kinds=$(grep "categories:" -r $destdir | awk '{print $2" "$3}' | sed 's/ //g' | sort | uniq)
for i in ${kinds[@]}
do
	g=$(echo $i | sed 's/\(^[0-9]\+\.\)\(.*\)/\2/g')
	echo $g
	path=$(grep "categories:.*$g" -rn $destdir | awk -F ":" '{print $1}' | cut -d / -f 2- | sed 's/[^\/]*$//g' | uniq)
	echo /$path
	echo "- [**$g**]({{< relref \"/${path}\" >}})" >> $menu
	files=$(grep "categories:.*$g" -r $destdir | awk -F ":" '{print $1}')
	for f in ${files[@]}
	do
		path=$(echo ${f:0:-3} | cut -d / -f 2-)
		title=$(grep "title:" -r $f | awk '{print $2}')
		# echo $title
		echo "  - [$title]({{< relref \"/${path}\" >}})" >> $menu
	done
	echo >> $menu
done
