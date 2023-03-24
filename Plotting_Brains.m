function Plotting_Brains(fdr_region,t_region,mode,model,transparency,mymin,mymax)
%% Mahsa Dadar, Yashar Zeighami, 2023-03-24
% This function plots voxel-wise maps or atlas regions overlaid on average
% templates
% fdr_region: binary values reflecting statistically significant
% regions/voxels
% t_region: t-stats or estimates corresponding to the significant
% voxels/regions
% mode: 'voxelwise' or 'allen'
% model: 'icbm_sym', 'icbm_asym', or 'adni'
% transparency: level of transparency of the overlaid maps
% mymin: minimum range of t_region values
% mymax: maximum range of t_region values

% [~,icbm_sym]=niak_read_minc('/opt/quarantine/resources/mni_icbm152_nlin_sym_09c_minc2/mni_icbm152_t1_tal_nlin_sym_09c.mnc');
% [~,icbm_sym_mask]=niak_read_minc('/opt/quarantine/resources/mni_icbm152_nlin_sym_09c_minc2/mni_icbm152_t1_tal_nlin_sym_09c_mask.mnc');
% 
% [~,icbm_asym]=niak_read_minc('/opt/quarantine/resources/mni_icbm152_nlin_asym_09c_minc2/mni_icbm152_t1_tal_nlin_asym_09c.mnc');
% [~,icbm_asym_mask]=niak_read_minc('/opt/quarantine/resources/mni_icbm152_nlin_asym_09c_minc2/mni_icbm152_t1_tal_nlin_asym_09c_mask.mnc');
% 
% [~,adni]=niak_read_minc('/opt/quarantine/resources/adni_model_3d_v2/model_t1w.mnc');
% [~,adni_mask]=niak_read_minc('/opt/quarantine/resources/adni_model_3d_v2/model_t1w_mask.mnc');
% 
% [~,Allen_sym]=niak_read_minc('/data/zeiyas/tools/models/mni_icbm152_nlin_sym_09b_minc2_allen/mni_icbm152_t1_tal_nlin_sym_09b_labels.mnc');

load Atlases
switch model
    case 'icbm_sym'
        Template=icbm_sym;
        brain_mask=icbm_sym_mask;
    case 'icbm_asym'
        Template=icbm_asym;
        brain_mask=icbm_asym_mask;
    case 'adni'
        Template=adni;
        brain_mask=adni_mask;
end

Template(brain_mask==0)=10000; % white background, skull-stripped

switch mode
    case 'voxelwise'
        Regions=t_region.*fdr_region;
    case 'allen'
        for i=1:141
            if fdr_region(i)==1
                Regions(Regions==i)=t_region(i);
            end
            if fdr_region(i)==0
                Regions(Regions==i)=0;
            end
        end
        for i=142:282
            if fdr_region(i)==1
                Regions(Regions==i+1000-141)=t_region(i);
            end
            if fdr_region(i)==0
                Regions(Regions==i+1000-141)=0;
            end
        end
end
%% Saggittal images, change x_coordinate range if necessary
for i=1:8
    x_coordinate=75+i*5;
    x_p=zeros(size(Template,2),size(Template,3));x_p(:)=Template(x_coordinate,:,:)/100;
    x_p_seg=zeros(size(Template,2),size(Template,3));x_p_seg(:)=Regions(x_coordinate,:,:);
    subplot(6,4,i);imshow(rot90(x_p));
    hold on;color_map=double2rgb(rot90(x_p_seg),jet,[mymin mymax]);f=imagesc(color_map);
    hold off;set(f, 'AlphaData', (rot90(x_p_seg)~=0)*transparency)

end
%% Coronal images, change y_coordinate range if necessary
for i=1:8
    y_coordinate=60+i*5;
    y_p=zeros(size(Template,1),size(Template,3));y_p(:)=Template(:,y_coordinate,:)/100;
    y_p_seg=zeros(size(Template,1),size(Template,3));y_p_seg(:)=Regions(:,y_coordinate,:);
    subplot(6,4,i+8);imshow(rot90(y_p));
    hold on;color_map=double2rgb(rot90(y_p_seg),jet,[mymin mymax]);f=imagesc(color_map);
    hold off;set(f, 'AlphaData', (rot90(y_p_seg)~=0)*transparency)

end
%% Axial images, change x_coordinate range if necessary
for i=1:8
    z_coordinate=44+i*5;
    z_p=zeros(size(Template,1),size(Template,2));z_p(:)=Template(:,:,z_coordinate)/100;
    z_p_seg=zeros(size(Template,1),size(Template,2));z_p_seg(:)=Regions(:,:,z_coordinate);
    subplot(6,4,i+16);imshow(rot90(z_p));
    hold on;color_map=double2rgb(rot90(z_p_seg),jet,[mymin mymax]);f=imagesc(color_map);
    hold off;set(f, 'AlphaData', (rot90(z_p_seg)~=0)*transparency);
end
