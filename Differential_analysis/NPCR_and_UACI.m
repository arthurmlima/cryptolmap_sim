function results = NPCR_and_UACI(img_a,img_b,need_display,largest_allowed_val)
% =========================================================================
% FUNCTION:
%        gives NPCR & UACI quantitative and qualitative scores for
%        the strength against possible differential attacks of image
%        ciphers
% =========================================================================
% INPUT:
%        img_a, img_b: two encrypted images of same size and type
%        need_display: on/off option to show outputs (default: on)
%        largest_allowed_val: is the value of the largest theoretical
%                      allowed value in encrypted image. If it is not
%                      provided, algorithm will automatically choose one.
% =========================================================================
% OUTPUT:
%        results.npcr_score: quantitative NPCR score (larger is better)
%        results.npcr_pVal : qualitative NPCR score  (larger is better)
%        results.npcr_dist : theoretical NPCR normal dist. (mean +\- var)
%        results.uaci_score: quantitative UACI score (larger is NOT better)
%        results.uaci_pVal : qualitative UACI score  (larger is better)
%        results.uaci_dist : theoretical UACI normal dist. (mean +\- var)
% =========================================================================
% SCORE INTERPRETATION:
%        if your cipher is abled to encrypted images that indistinguishable
%        from random images under the NPCR and UACI measures, pVals simply
%        represent the possibility that your tested images are indeed random
%        -like, and thus a larger pVal is preferred. On the other hand,
%        pVals are random variables, and could be very small (say 0.0001)
%        even though test images are truely random-like. Therefore, it is
%        meaningless to make any conclusive claim for a small test data set.
%        However, if you observe that out of 100 tested image pairs, 5 of
%        them fail to achieve pVals greater than 0.01 (or 1%), then this is
%        a clear indicator that this image cipher fail to generated
%        random-like outputs, because if we use 100 truely random-like
%        image pairs, we will only observe 1 out 100 with pVal less than
%        0.01 in theory.
% =========================================================================
% NOTE:
%        1. This code is only free-of-use for research and acadmic use.
%        2. Whenever the proposed code is used in scitific research,
%           please kindly cite the related article(s).
%        3. Achieving a good randomness P-vals does not guarantee a
%           cipher is secure. The only thing that is safe to claim is that
%           "a cipher is able to generate random-like data indistinguishable
%           from those truely random-like under XXX measure"
%        4. One may find UACI and NPCR are defined differently in
%           literature. This implementation adopts the definitions given in
%           the paper below.
% =========================================================================
% PAPER INFORMATION:
%       Wu, Y., Noonan, J. P., & Agaian, S.
%       NPCR and UACI randomness tests for image encryption.
%       on Journal of Selected Areas in Telecommunications (JSAT), 31-38.
%       2011. (http://www.cyberjournals.com/Papers/Apr2011/05.pdf)
% =========================================================================
% CONTACT:
%       Name: Dr. Yue Wu
%       Email: ywu03@ece.tufts.edu.
% =========================================================================
%% 1. Input_check
[height_a,width_a,depth_a] = size(img_a);
[height_b,width_b,depth_b] = size(img_b);
if ((height_a ~= height_b) ...
  || (width_a ~=  width_b) ...
  || (depth_a ~=  depth_b))
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
            largest_allowed_val = max (max(img_a(:),img_b(:)));
    end
end
if (~exist('need_display','var'))
    need_display = 1;
end
img_a = double(img_a);
img_b = double(img_b);
num_of_pix = numel(img_a);
%% 3. NCPR score and p_value
results.npcr_score = sum(double(img_a(:) ~= img_b(:)))/num_of_pix;
npcr_mu  = (largest_allowed_val)/(largest_allowed_val+1);
npcr_var = ((largest_allowed_val)/(largest_allowed_val+1)^2)/num_of_pix;
results.npcr_pVal = normcdf(results.npcr_score,npcr_mu,sqrt(npcr_var));
results.npcr_dist = [npcr_mu,npcr_var];
%% 4. UACI score and p_value
results.uaci_score = sum(abs(img_a(:)-img_b(:)))/num_of_pix/largest_allowed_val;
uaci_mu  = (largest_allowed_val+2)/(largest_allowed_val*3+3);
uaci_var = ((largest_allowed_val+2)*(largest_allowed_val^2+2*largest_allowed_val+3)/18/(largest_allowed_val+1)^2/largest_allowed_val)/num_of_pix;
p_vals = normcdf(results.uaci_score,uaci_mu,sqrt(uaci_var));
p_vals(p_vals>0.5) = 1-p_vals(p_vals>0.5);
results.uaci_pVal = 2*p_vals;
results.uaci_dist = [uaci_mu,uaci_var];
%% 5. Optional output
if (need_display)
   format long;
   display(results);
end