function Plotting_Voxelwise_Maps(t_values,fdr_p_values,slice,coordinate,subplot_title,n_rows,n_columns,n_subplot)
%% Plotting_Voxelwise_Maps is a matlab function that takes voxelwise t-values & p-values and plots significant the t-values on MNI-ICBM average template
%% Inputs
% fdr_p_values: 3D voxelwise map of significant p values
% t_values: 3D voxelwise map of t values
% slice: orientation of the slice to be plotted: choose from 'axial','coronal','sagittal' 
% coordinate: coordinate of the slice to be plotted
% subplot_title: title of the subplot
% n_rows: number of subplot rows
% n_columns: number of subplot columns
% n_subplot: number of the slice within the subplots 
load ICBM.mat % loads ICBM information
Indices=find(brain_mask>0);
%% checks which regions are significant, and only plots those, leaving the others empty
t_values(fdr_p_values>0.05)=0;
Regions=t_values;
%% plot visualization characteristics 
transparency=0.6; % transparency of the colors overlaid on ICBM, change if necessary
mymin=-1.5; % min range value of the t-stats, change if necessary
mymax=1.5; % max range value of the t-stats, change if necessary
% you can also change the colormap from jet to other maps from: https://www.mathworks.com/help/matlab/ref/colormap.html
%% this section basically grabs the indicated slice, and overlays it on the corresponding ICBM slice
Template(brain_mask==0)=10000; % plots nonbrain areas as white, remove if you want skull included

if strcmp(slice,'axial')
z_p=zeros(size(Template,1),size(Template,2));z_p(:)=Template(:,:,coordinate)/100;
z_p_seg=zeros(size(Template,1),size(Template,2));z_p_seg(:)=Regions(:,:,coordinate);
end
if strcmp(slice,'coronal')
z_p=zeros(size(Template,1),size(Template,3));z_p(:)=Template(:,coordinate,:)/100;
z_p_seg=zeros(size(Template,3),size(Template,3));z_p_seg(:)=Regions(:,coordinate,:);
end
if strcmp(slice,'sagittal')
z_p=zeros(size(Template,2),size(Template,3));z_p(:)=Template(coordinate,:,:)/100;
z_p_seg=zeros(size(Template,2),size(Template,3));z_p_seg(:)=Regions(coordinate,:,:);
end

subaxis(n_rows,n_columns,n_subplot,'SpacingVertical',0.01,'SpacingHorizontal',0.001);
imshow(rot90(z_p));
hold on;color_map=double2rgb(rot90(z_p_seg),jet,[mymin mymax]);f=imagesc(color_map);
hold off;set(f, 'AlphaData', (rot90(z_p_seg)~=0)*transparency);title(subplot_title,'fontsize',12)
end