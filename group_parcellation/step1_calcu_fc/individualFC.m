% Function Name: individualFC.m
%
% Description:
% This function calculates FC matrix from time series.
%
% Input：
% - DK_label: Index of all vertices of the whole brain cerebral cortex.
% - ROI_label: The indices of ROI vertices.
% - dtseries_filt: The time series.
% - area: The index of the parcellated area in DK template.
%
% Output:
% - hcp_FC_map: The fc matrix calculated.
%
% Date  : January 27, 2024

function hcp_FC_map = individualFC(DK_label,ROI_label,dtseries_filt,area)

% The time series of ROI vertices
ROI_index = ROI_label~=0;
ROI_tc = dtseries_filt(ROI_index,:);

% The time series of vertices in the parcellated area
index = DK_label==area;
area_TC = dtseries_filt(index,:);
% 计算功能连接
sum_FC = atanh(corr(area_TC',ROI_tc'));
hcp_FC_map = sum_FC;

