#!/bin/bash

SOURCE=$1
TARGET=$2

cat $SOURCE | sed s/"node id=\'-"/"node id=\'"/g | sed s/"nd ref=\'-"/"nd ref=\'"/g \
	| sed s/" action=\'modify\'"//g \
	| sed "/node/ s/ timestamp='[^']*'//" \
	| sed "/node/ s/ action='[^']*'//" \
	| sed "/node/ s/ version='[^']*'//" \
	| sed "/node/ s/ user='[^']*'//" \
	| sed "/node/ s/ id/ version='1' user='iero' timestamp='1970-01-01T12:00:00Z' id/" \
	| sed "/way/ s/ timestamp='[^']*'//" \
	| sed "/way/ s/ action='[^']*'//" \
	| sed "/way/ s/ version='[^']*'//" \
	| sed "/way/ s/ user='[^']*'//" \
	| sed "/way/ s/ id/ version='1' user='iero' timestamp='1970-01-01T12:00:00Z' id/" \
	| sed "/relation/ s/ timestamp='[^']*'//" \
	| sed "/relation/ s/ action='[^']*'//" \
	| sed "/relation/ s/ version='[^']*'//" \
	| sed "/relation/ s/ user='[^']*'//" \
	| sed "/relation/ s/ id/ version='1' user='iero' timestamp='1970-01-01T12:00:00Z' id/" \
	> $TARGET
