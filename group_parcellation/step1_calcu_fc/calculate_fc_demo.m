% Script Name: calculate_fc.m
%
% Description:
% This demo calculates the functional connectivity (FC) for the area we need
% parcellate on individual level.
%
% Input：
% - area: The index of the parcellated area in DK template.
% - source_path: The storage path of this whole code.
%
% Output:
% - hcp_FC_map: The fc matrix calculated.
%
% Date  : January 27, 2024
%
% Usage:
% 1. Run this demo you can get an MxN FC matrix, where M is the number of
% the area to be parcellated and N is the number of ROI vertices. Here our
% ROI is sightly different from the paper, you can choose your own ROI.
% 2. To calculate the group-level FC, you should then calculate the mean FC
% of all the subjects after you calculate their own FC. Here is only a demo
% for calculating individual FC, so the time series is only an example of
% one subject. You can replace it with your time series extracted from fMRI
% data.
% 3. You can modify the parameters in 'Input' as you expected.

clc
clear
close all

% Input
area = 25;
source_path = strcat('D:\group_parcellation\');

% Add search path
addpath(strcat(source_path,'aid-template'))
addpath(strcat(source_path,'data'))

% Load the time series
dtseries_filt = importdata('plm_r1PA.mat');

% Load the DK template
load('average_DK.mat');
% Index of all vertices of the whole brain cerebral cortex
DK_label = b;

% Load the indices of ROI vertices
ROI = ft_read_cifti('fslr_downsample_900mesh_parcellation.dlabel.nii');
ROI_label = ROI.dlabel;

% calculate individual FC
hcp_FC_map = individualFC(DK_label,ROI_label,dtseries_filt,area);


