#!/usr/bin/env bash
#	default color: 178984
oldglyph=#4f463e
newglyph=#373730

#	Front
#	default color: 36d7b7
oldfront=#8c7c6f
newfront=#67675c

#	Back
#	default color: 1ba39c
oldback=#60554c
newback=#47473f

sed -i "s/#524954/$oldglyph/g" $1
sed -i "s/#9b8aa0/$oldfront/g" $1
sed -i "s/#716475/$oldback/g" $1
sed -i "s/$oldglyph;/$newglyph;/g" $1
sed -i "s/$oldfront;/$newfront;/g" $1
sed -i "s/$oldback;/$newback;/g" $1
