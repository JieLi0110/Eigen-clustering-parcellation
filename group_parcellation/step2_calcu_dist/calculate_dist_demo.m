% Script Name: calculate_dist.m
%
% Description:
% This demo calculates the dist matrix from FC matrix.
%
% Input：
% - kk: The dimension of the normalized Laplacian eigenvectors.
% - source_path: The storage path of this whole code.
%
% Output:
% - dist: The dist matrix calculated.
%
% Date  : January 27, 2024
%
% Usage:
% 1. Run this demo, you can get an NXN dist matrix, where N represents the
% number of total vertices in the symmetry areas. We perform the parcellation
% of the symmetry areas simultaneously, so we calculate dist matrix using
% the combining FC matrix of the symmetry areas. You can also get the seperate
% dist matrix using the FC matrix of only left or right area.
% 2. This demo only calculates the dist matrix under one dimension, you can
% modity the value of 'kk' as you need.

clc
clear
close all

% Input
kk = 9;
source_path = strcat('D:\group_parcellation\');

% Add search path
addpath(strcat(source_path,'data'))

% Load fc matrix for the symmetry area and combine them
fc_map_l = importdata('DK_region25_group_FCmap.mat');
fc_map_r = importdata('DK_region60_group_FCmap.mat');
fc_map = [fc_map_l;fc_map_r];

% calculate the dist matrix
dist = FC2dist(kk,fc_map);


