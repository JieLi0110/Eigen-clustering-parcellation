% Script Name: group_parcellation.m
%
% Description:
% This demo performs the group parcellation using EIC algorith from dist matrix.
%
% Input：
% - source_path: The storage path of this whole code.
%
% Output:
% - cl_label: The parcellation result.
% - center_index: The index of cluster centers.
%
% Date  : January 27, 2024
%
% Usage:
% 1. Run this demo, you can a 1xN vector, representing the corresponding
% parcellation label for every vertex.
% 2. This demo performs the parcellation on precuneus. You can replace the
% 'dist' with any dist matrix calculated by step2.

clc
clear
close all

% Input
source_path = strcat('D:\group_parcellation\');

% Add search path
addpath(strcat(source_path,'data'))

dist = importdata('dist_region25+60.mat');
[cl_label,center_index] = dist2parcel_group(dist);
