clear all
clc
close all

% Parameters
MU_PERM = "128";
MU_DIFF = "256";
PRECISION_PERMUTATION = "FLOAT";
PRECISION_DIFFUSION = "FLOAT";
DISCARDED_TIME = "10";
CEXPR = '"((long long int)(v[i]*POW(10,5)))%256"';

% Select image
IMAGE = 'plane.tif';

Image = imread(strcat('C:\Users\lgnar\suplogmap\Information_loss\Images\',IMAGE));
[Height,Width] = size(Image);

fid = fopen('image.h','w');
n_pixels = Width*Height;
vector_image = reshape(Image(:,:)',[1 n_pixels]);
fprintf(fid,"#include<stdint.h>\n");
fprintf(fid,sprintf('\n\nuint8_t image[%d*%d] = {\n',Height,Width));
for i = 1:n_pixels
    if(i == n_pixels)
        fprintf(fid,'%d\n',vector_image(i));
    else
        fprintf(fid,'%d,\n',vector_image(i));
    end
end
fprintf(fid,'\n};');
fclose(fid);

prec = strcat(' -D',PRECISION_PERMUTATION,'_DIFF',' -D',PRECISION_DIFFUSION,'_PERM');
mu = strcat(' -D','MU_PERM=',MU_PERM,' -D','MU_DIFF=',MU_DIFF);
isize = strcat(' -D','_H=',string(Height),' -D','_W=',string(Width));
expr = strcat(" -D","CEXPR=",CEXPR);
dt = strcat(" -D","DT=",DISCARDED_TIME);

versmatlab = strcat("set path=%path:C:\Program Files\MATLAB\R", version('-release'),"\bin\win64;=% & a.exe");

cmdc = strcat("g++ -DDEBUG ",prec,mu,isize,expr,dt," main.cpp -lcryptopp");

system(sprintf("%s",cmdc));
system(sprintf("%s",versmatlab));

plain_image = load('Text\plain.image');
permuted_image = load('Text\permuted.image');
cipher_image = load('Text\cipher.image');

figure(1)
imshow(uint8(reshape(plain_image,Height,Width)'));
aux_a = uint8(reshape(plain_image,Height,Width)');
figure(2)
imshow(uint8(reshape(permuted_image,Height,Width)'));
aux_b = uint8(reshape(permuted_image,Height,Width)');
figure(3)
imshow(uint8(reshape(cipher_image,Height,Width)'));
aux_c = uint8(reshape(cipher_image,Height,Width)');

% Add white gaussian noise in the cipher-image
%noise_image = imnoise(aux_c,'gaussian',0,0.001);

% Add "salt and pepper" noise in the cipher-image
noise_image = imnoise(aux_c,'salt & pepper',0.125);

figure(4)
imshow(noise_image)

% Decryption Algorithm
aux_d = load('Text\precipher.image');
key = uint8(reshape(aux_d,Height,Width)');

% Bit-XOR operation
permuted_image_2 = bitxor(noise_image,key,'uint8');

flat_permuted_image_2 = reshape(permuted_image_2',1,Height*Width);

aux_e = load('Text\pixel_position.image');
aux_e = aux_e(:,1)+1;

% Permutation process - Decryption
for k = 1:Height*Width
    aux_f = aux_e(k);
    decrypted_image(aux_f) = flat_permuted_image_2(k);
end

decrypted_image = reshape(decrypted_image,Height,Width)';

figure(5)
imshow(decrypted_image)