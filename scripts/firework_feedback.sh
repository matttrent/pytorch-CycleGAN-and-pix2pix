#!/bin/bash

name=fireworks
subdirs='950 1290 1520'
epochs='10'

for epoch in $epochs
do

for subdir in $subdirs
do

python feedback.py \
    --dataroot ~/data/fireworks --name $name --model pix2pix \
    --which_model_netG unet_256 --which_direction AtoB --dataset_mode feedback \
    --norm batch --how_many 500 --subdir $subdir --which_epoch $epoch

ffmpeg -y -r 30 -f image2 -i ~/data/fireworks/feedback/$subdir/%04d.png \
    -vcodec libx264 -crf 25 -pix_fmt yuv420p \
    ~/data/fireworks/videos/${name}_${subdir}_epoch_${epoch}.mp4

done
done
