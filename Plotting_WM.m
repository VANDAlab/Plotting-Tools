function Plotting_WM(fdr_region_significant,t_region,slice,coordinate,subplot_title,n_rows,n_columns,n_subplot)
%% Plotting_Atlas is a matlab function that can take t-values corresponding to CerebrA atlas as input and plot them on MNI-ICBM average template
%% Inputs
% fdr_region_significant: vector indicating whether the p value for each
% significant region 
% t_region: t statistics values of the regions
% slice: orientation of the slice to be plotted: choose from 'axial','coronal','sagittal' 
% coordinate: coordinate of the slice to be plotted
% subplot_title: title of the subplot
% n_rows: number of subplot rows
% n_columns: number of subplot columns
% n_subplot: number of the slice within the subplots 

% Region IDs
% 1: left frontal lobe
% 2: right frontal lobe
% 3: left temporal lobe
% 4: right temporal lobe
% 5: left parietal lobe
% 6: right pariental lobe
% 7: left cerebellum
% 8: right cerebellum
% 9: brainstem
% 10: left occipital lobe
% 11: right occipital lobe
load Atlas_WM.mat % loads Hammers WM and ICBM information
Indices=find(brain_mask>0);
%% checks which regions are significant, and only plots those, leaving the others empty
for i=1:11
    if fdr_region_significant(i)==1
        Regions(Regions==i)=t_region(i);
    end
    if fdr_region_significant(i)==0
        Regions(Regions==i)=0;
    end
end
%% plot visualization characteristics 
transparency=0.6; % transparency of the colors overlaid on ICBM, change if necessary
mymin=-1; % min range value of the t-stats, change if necessary
mymax=1; % max range value of the t-stats, change if necessary
% you can also change the colormap from jet to other maps from: https://www.mathworks.com/help/matlab/ref/colormap.html
%% this section basically grabs the indicated slice, and overlays it on the corresponding ICBM slice
Template(brain_mask==0)=10000;
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