#!/bin/bash

subdir=20k
epochs='10 20 30 latest'

for epoch in $epochs
do

python feedback.py \
    --dataroot ~/data/moto-gopro --name moto_pix2pix --model pix2pix \
    --which_model_netG unet_256 --which_direction AtoB --dataset_mode feedback \
    --norm batch --how_many 500 --subdir $subdir --which_epoch $epoch

ffmpeg -y -r 30 -f image2 -i ~/data/moto-gopro/feedback/$subdir/%04d.png \
    -vcodec libx264 -crf 25 -pix_fmt yuv420p \
    ~/data/moto-gopro/videos/moto_${subdir}_epoch_${epoch}.mp4

done
