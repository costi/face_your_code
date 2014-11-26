#!/bin/bash

MONTH=$1
YEAR=2011

if [ -z $1 ]
then
  echo "Usage: $0 <month>"
  exit
fi

DIR=~/Pictures/projface/monthly/$YEAR-$(printf %02d $MONTH)

if [ -d $DIR ]
then
  echo "Directory $DIR exists, proceeding"
else
  echo "No such directory $DIR"
  exit
fi


TMPDIR=$(dirname $0)/tmp ./composite.rb \
  $DIR/screenshots \
  $DIR/webcam \
  $YEAR-$MONTH.avi
