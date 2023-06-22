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
IMAGE = 'tank.tif';

Image = imread(strcat('C:\Users\lgnar\suplogmap\Entropy_histogram_correlation\Images\',IMAGE));
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
figure(3)
imshow(uint8(reshape(cipher_image,Height,Width)'));
aux_b = uint8(reshape(cipher_image,Height,Width)');

% Entropy
disp('-----------------Entropy - Plain Image----------------');
entropia = myentropy(aux_a(:))

% Entropy
disp('----------------Entropy - Cipher Image----------------');
entropia = myentropy(aux_b(:))

% Histogram
figure(4)
myimhist(aux_a)

% Histogram
figure(5)
myimhist(aux_b)

disp('--------Correlation Coefficient - Plain Image---------');
A = im2double(aux_a);
c_diag = corrcoef(A(1:end-1,1:end-1),A(2:end,2:end))
c_vert = corrcoef(A(1:end-1,:),A(2:end,:))
c_horz = corrcoef(A(:,1:end-1),A(:,2:end))

figure(6)
plot(aux_a(1:100-1,1:100-1),aux_a(2:100,2:100),'k.')
axis([0 260 0 260])

figure(7)
plot(aux_a(1:100-1,1:100),aux_a(2:100,1:100),'k.')
axis([0 260 0 260])

figure(8)
plot(aux_a(1:100,1:100-1),aux_a(1:100,2:100),'k.')
axis([0 260 0 260])

disp('--------Correlation Coefficient - Cipher Image--------');
I = im2double(aux_b);
c_diag2 = corrcoef(I(1:end-1,1:end-1),I(2:end,2:end))
c_vert2 = corrcoef(I(1:end-1,:),I(2:end,:))
c_horz2 = corrcoef(I(:,1:end-1),I(:,2:end))

figure(9)
plot(aux_b(1:100-1,1:100-1),aux_b(2:100,2:100),'k.')
axis([0 260 0 260])

figure(10)
plot(aux_b(1:100-1,1:100),aux_b(2:100,1:100),'k.')
axis([0 260 0 260])

figure(11)
plot(aux_b(1:100,1:100-1),aux_b(1:100,2:100),'k.')
axis([0 260 0 260])