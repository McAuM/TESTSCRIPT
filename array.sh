#!/bin/bash

array[@]=( 0 1 2 3 4 )

for (( i=0; i<5; i++))
{
	echo "${array[$i]}"
}