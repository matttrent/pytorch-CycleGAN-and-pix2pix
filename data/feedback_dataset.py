import os.path
import pathlib
from data.base_dataset import BaseDataset, get_transform
from data.image_folder import make_dataset
from PIL import Image
import random


class FeedbackDataset(BaseDataset):
    def initialize(self, opt):
        self.opt = opt
        self.root = pathlib.Path(opt.dataroot)
        self.dir_AB = self.root / opt.phase / opt.subdir

        # self.AB_paths = sorted(make_dataset(self.dir_AB))
        self.AB_size = 100
        self.transform = get_transform(opt)

    def __getitem__(self, index):

        A_path = self.path_for_index(index)
        A_path = str(A_path)
        B_path = A_path

        # A_path = self.AB_paths[index]
        # B_path = self.AB_paths[index + 1]

        # print('(A, B) = (%d, %d)' % (index_A, index_B))
        A_img = Image.open(A_path).convert('RGB')
        B_img = Image.open(B_path).convert('RGB')

        A = self.transform(A_img)
        B = self.transform(B_img)

        # if self.opt.which_direction == 'BtoA':
        #     input_nc = self.opt.output_nc
        #     output_nc = self.opt.input_nc
        # else:
        input_nc = self.opt.input_nc
        output_nc = self.opt.output_nc

        if input_nc == 1:  # RGB to gray
            tmp = A[0, ...] * 0.299 + A[1, ...] * 0.587 + A[2, ...] * 0.114
            A = tmp.unsqueeze(0)

        if output_nc == 1:  # RGB to gray
            tmp = B[0, ...] * 0.299 + B[1, ...] * 0.587 + B[2, ...] * 0.114
            B = tmp.unsqueeze(0)
        return {'A': A, 'B': B,
                'A_paths': A_path, 'B_paths': B_path}

    def __len__(self):
        return self.AB_size

    def path_for_index(self, index):
        return self.dir_AB / f'{str(index).zfill(4)}.png'
    
    def name(self):
        return 'FeedbackDataset'
