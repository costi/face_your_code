#!/bin/bash

for MONTH in 2011-03 2011-04 2011-05 2011-06 2011-07 2011-08 2011-09 2011-10 2011-11 2011-12
do
  mkdir ~/Pictures/projface/monthly/$MONTH
  mkdir ~/Pictures/projface/monthly/$MONTH/webcam
  mkdir ~/Pictures/projface/monthly/$MONTH/screenshots
  find ~/Pictures/projface/webcam-snaps -name "${MONTH}*" -exec mv -t ~/Pictures/projface/monthly/$MONTH/webcam/ {} +
  find ~/Pictures/projface/screenshots  -name "${MONTH}*" -exec mv -t ~/Pictures/projface/monthly/$MONTH/screenshots/ {} +
done

