#!/bin/bash

python feedback.py \
    --dataroot ./datasets/moto-gopro --name moto_pix2pix --model pix2pix \
    --which_model_netG unet_256 --which_direction AtoB --dataset_mode feedback \
    --norm batch --how_many 1000
