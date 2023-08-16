clear all
clc
close all

% Parameters
MU_PERM = "128";
MU_DIFF = "256";
PRECISION_PERMUTATION = "DOUBLE";
PRECISION_DIFFUSION = "DOUBLE";
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

cmdc = strcat("wsl g++ -DDEBUG ",prec,mu,isize,expr,dt," -o /home/lucas/aux/a.out /home/lucas/aux/main.cpp -lcryptopp");
system("wsl cp -R /mnt/c/Users/lgnar/suplogmap/Information_loss/main.cpp /home/lucas/aux/");
system("wsl cp -R /mnt/c/Users/lgnar/suplogmap/Information_loss/image.h /home/lucas/aux/");
system("wsl cp -R /mnt/c/Users/lgnar/suplogmap/Information_loss/parameters.h /home/lucas/aux/");
system(sprintf("%s",cmdc));
system("wsl cd ~/aux ; ./a.out");
system("wsl cp -R /home/lucas/aux/Text /mnt/c/Users/lgnar/suplogmap/Information_loss/");

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

loss_image = aux_c;
% Information loss - 256 x 256
for i = 128:383
    for j = 128:383
        loss_image(i,j) = 0;
    end
end

% loss_image = aux_c;
% % Information loss - 512 x 256
% for i = 1:512
%     for j = 1:256
%         loss_image(i,j) = 0;
%     end
% end

figure(4)
imshow(loss_image)

% Decryption Algorithm
aux_d = load('Text\precipher.image');
key = uint8(reshape(aux_d,Height,Width)');

% Bit-XOR operation
permuted_image_2 = bitxor(loss_image,key,'uint8');

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