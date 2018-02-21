#!/bin/bash

python train.py \
    --dataroot ~/data/moto-gopro --name moto_pix2pix --model pix2pix \
    --which_model_netG unet_256 --which_direction AtoB --lambda_A 100 \
    --dataset_mode sequential --no_lsgan --norm batch --pool_size 0 --no_flip \
    --batchSize 32 --niter 25 --niter_decay 25
