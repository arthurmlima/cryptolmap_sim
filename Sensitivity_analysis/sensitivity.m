function results = sensitivity(img_a,img_b,need_display,largest_allowed_val)
% Adapted from the NPCR e UACI test found in: https://rb.gy/kf1ael
% =========================================================================
% FUNCTION:
%        analyzes the key sensitivity and gives quantitative scores for
%        the strength against possible cyber attacks
% =========================================================================
% INPUT:
%        img_a, img_b: two encrypted images of same size and type
%        need_display: on/off option to show outputs (default: on)
%        largest_allowed_val: is the value of the largest theoretical
%                      allowed value in encrypted image. If it is not
%                      provided, algorithm will automatically choose one.
% =========================================================================
% OUTPUT:
%        results.diff.score: quantitative Diff1 score (must be near to 99.6094%)
% =========================================================================
%% 1. Input_check
[height_a,width_a,depth_a] = size(img_a);
[height_b,width_b,depth_b] = size(img_b);
if ((height_a ~= height_b) ...
  || (width_a ~= width_b) ...
  || (depth_a ~= depth_b))
    error('input images have to be of same dimensions');
end
class_a = class(img_a);
class_b = class(img_b);
if (~strcmp(class_a,class_b))
    error('input images have to be of same data type');
end
%% 2. Measure preparations
if (~exist('largest_allowed_val','var'))
    switch  class_a
        case 'uint16'
            largest_allowed_val = 65535;
        case 'uint8'
            largest_allowed_val = 255;
        case 'logical'
            largest_allowed_val = 2;
        otherwise
            largest_allowed_val = max(max(img_a(:),img_b(:)));
    end
end
if (~exist('need_display','var'))
    need_display = 1;
end
img_a = double(img_a);
img_b = double(img_b);
num_of_pix = numel(img_a);
%% 3. Diff score
results.diff_score = sum(double(img_a(:) ~= img_b(:)))/num_of_pix;
%% 5. Optional output
if (need_display)
   format long;
   display(results);
end