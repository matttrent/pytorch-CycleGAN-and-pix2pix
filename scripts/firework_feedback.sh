#!/bin/bash

# bail entirely on interrupt
trap 'exit 0' INT

# accepts a -f / --force flag to recompute existing videos
force=false
case $1 in
    -f | --force )  force=true ;;
esac

# config
project_root=$HOME/projects/cyclegan-pix2pix
dataset=fireworks

# feedback specific config
name=fireworks_b16
frames='950 1290 1520'

# extract list of epochs from the model checkpoints directory
epochs=$(ls ${project_root}/checkpoints/${name} | grep "[0-9]\{1,\}_net_G" | cut -d'_' -f 1)
epochs=$(echo $epochs | xargs printf '%03d\n' | sort)
echo $epochs

# for each epoch and frame
for epoch in $epochs
do
for frame in $frames
do

# zeropad the frame number
framez=$(printf '%06d' $frame)

# fullname of this run
fullname=${name}_f${framez}_e${epoch}

# output video path & file
outpath=~/data/${dataset}/videos/${name}
outfile=${outpath}/${fullname}.mp4

# if video doesn't exist or force
if [ ! -f $outfile ] || $force; then

    # frame dump path, seed file and non-padded epoch number
    fullpath=~/data/${dataset}/feedback/${framez}
    seedfile=$(printf "frame_%08d.png" ${frame})
    epp=$(echo $epoch | sed 's/^0*//')

    # make our directories and copy the seed frame
    mkdir -p $outpath
    mkdir -p $fullpath
    cp ~/data/${dataset}/train/${seedfile} ${fullpath}/0000.png

    echo $dataset $name
    echo $epoch $epp $frame $framez
    echo $fullname
    echo $fullpath
    echo ~/data/${dataset}/train/${seedfile}
    echo $outpath

    # run the feedback script
    python feedback.py \
        --dataroot ~/data/$dataset --name $name --model pix2pix \
        --which_model_netG unet_256 --which_direction AtoB \
        --dataset_mode feedback --norm batch --how_many 500 --subdir $framez \
        --which_epoch $epp \
    || { echo ${fullname} 'failed' ; exit 1; }

    # compress the frames to video
    ffmpeg -y -r 30 -f image2 -i $fullpath/%04d.png \
        -vcodec libx264 -crf 25 -pix_fmt yuv420p $outfile

else

    echo exists: $outfile

fi

done
done
