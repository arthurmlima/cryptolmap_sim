#include <iostream>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include <time.h>

#include "cryptopp/cryptlib.h"
#include "cryptopp/sha.h"
#include "cryptopp/hex.h"
#include "cryptopp/config.h"
#include "cryptopp/files.h"
#include <fstream>
#include <string>

#include "parameters.h"

#include <stdio.h>

perm_prec* logmap_perm(int dt, perm_prec x);
diff_prec* logmap_diff(int dt, diff_prec x);
uint8_t* permutation(perm_prec* v);
int cmp(const void* a, const void* b);
template <typename T> 
void print_img(T *image_impr, const char *filen);
uint8_t* lmapdc(diff_prec* v);
uint8_t* cipherxor(uint8_t* permuted_image, uint8_t* precipher);

int main ()
{
    using namespace CryptoPP;
    // Generate a random floating-point number between 0 and 1

    HexEncoder encoder(new FileSink(std::cout));
    std::string digest;
    SHA256 hash;
    hash.Update((const byte*)&image[0], BSIZE);
    digest.resize(hash.DigestSize());
    hash.Final((byte*)&digest[0]);

    double m1 = 0.0;
    double m2 = 0.0;

    // The first half of the HASH
    for (int i = 0; i < 16; i++)
    {
        uint8_t h = digest[i];
        m1 += h;
        i++;
    }

    // The second half of the HASH
   for (int i = 16; i < 32; i++)
    {
        uint8_t h = digest[i];
        m2 += h;
        i++;
    }

    m1 = m1/(16.0  * 1000.0)+0.1;
    m2 = m2/(16.0  * 1000.0)+0.3;

#ifdef DEBUG
printf("******************************************* DEBUG *****************************************\n");
    for (int i = 0; i < 32; i++)
    {
        uint8_t hd = digest[i];
        printf("%0.2X",hd);
    }
     printf("\n\n");

    printf("Initial Condition - Permutation = %f\n",m1);
    printf("Initial COndition - Diffusion = %f\n",m2);
    printf("\nmu Permutation = %f",(diff_prec)_MU_PERM_);
    printf("\nmu Diffusion = %f\n",(perm_prec)_MU_DIFF_);
printf("*******************************************************************************************\n");
#endif

    uint8_t* permuted_image = permutation(logmap_perm(_DT_,(perm_prec)m1));
    uint8_t* map_log_2 = lmapdc(logmap_diff(_DT_,(diff_prec)m2));
    uint8_t* cipher_image = cipherxor(permuted_image,map_log_2);

    print_img(image,"Text/plain.image");
    print_img(permuted_image,"Text/permuted.image");
    print_img(cipher_image,"Text/cipher.image");
}

uint8_t* lmapdc(diff_prec* v)
{
    uint8_t* lmapchar = (uint8_t *)malloc(BSIZE * sizeof(uint8_t));        // Allocate memory for the array
    if (lmapchar == NULL) {printf("Error! Low memory\n");}

    for (int i = 0; i < BSIZE; i++)
    {
            lmapchar[i] = _CIPHER_EXPR_;
    }
    return lmapchar;
}

uint8_t* cipherxor(uint8_t* permuted_image, uint8_t* precipher)
{
    uint8_t* cipher_image = (uint8_t *)malloc(BSIZE * sizeof(uint8_t));    // Allocate memory for the array
    if (cipher_image == NULL) {printf("Error! Low memory\n");}

    for (int i = 0; i < BSIZE; i++)
    {
           cipher_image[i] =  permuted_image[i] ^ precipher[i];
    }
    print_img(precipher, "Text/precipher.image");
    return cipher_image;
}

uint8_t* permutation(perm_prec* v)
{
       str* to_ord = (str *)malloc(BSIZE * sizeof(str));                   // Allocate memory for the array
       int* sorted_index =  (int *)malloc(BSIZE * sizeof(int));            // Allocate memory for the array

       if (to_ord == NULL) {printf("Error! Low memory\n");}
       if (sorted_index == NULL) {printf("Error! Low memory\n");}

       uint8_t* img = (uint8_t *)malloc(BSIZE * sizeof(uint8_t));          // Allocate memory for the array
       if (img == NULL) {printf("Error! Low memory\n");}

       for (int i = 0; i < BSIZE; i++)
       {
            to_ord[i].value = v[i];
            to_ord[i].index = i;
       }
       qsort(to_ord, BSIZE, sizeof(to_ord[0]), cmp);
       for (int i = 0; i < BSIZE; i++)
       {
            sorted_index[i]=to_ord[i].index;
            img[i] = image[to_ord[i].index];
       }
        print_img(sorted_index, "Text/var_d2.image");

       return  img;
}

perm_prec* logmap_perm(int dt, perm_prec x)
{
    perm_prec* vlogmap = (perm_prec *)malloc(BSIZE*sizeof(perm_prec));     // Allocate memory for the array
    if (vlogmap == NULL) {printf("Error! Low memory\n");}

    perm_prec x_at = x;
    perm_prec y_at = x;

    perm_prec mu = (perm_prec)_MU_PERM_;

    for (int i = 0; i < dt; i++)
    {
        long double logmap1 = (long double) mu * x_at * (NORM - x_at);
        long double logmap2 = (long double) mu * y_at - mu * POW(y_at,2);

        x_at = MOD(logmap1, NULL);
        y_at = MOD(logmap2, NULL);
    }

    for (int i = 0; i < BSIZE; i++)
    {
        long double logmap1 = (long double) mu * x_at * (NORM - x_at);
        long double logmap2 = (long double) mu * y_at - mu * POW(y_at,2);

        x_at = MOD(logmap1, NULL);
        y_at = MOD(logmap2, NULL);

        vlogmap[i] = ABS(MOD(logmap1, NULL)-MOD(logmap2, NULL));
    }
    return vlogmap;
}

diff_prec* logmap_diff(int dt, diff_prec x)
{
    diff_prec* vlogmap = (diff_prec *)malloc(BSIZE * sizeof(diff_prec));   // Allocate memory for the array
    if (vlogmap == NULL) {printf("Error! Low memory\n");}

    diff_prec x_at = x;
    diff_prec y_at = x;

    diff_prec mu = (diff_prec)_MU_DIFF_;

    for (int i = 0; i < dt; i++)
    {
        long double logmap1 = (long double) mu * x_at * (NORM - x_at);
        long double logmap2 = (long double) mu * y_at - mu * POW(y_at,2);

        x_at = MOD(logmap1, NULL);
        y_at = MOD(logmap2, NULL);
    }

    for (int i = 0; i < BSIZE; i++)
    {
        long double logmap1 = (long double) mu * x_at * (NORM - x_at);
        long double logmap2 = (long double) mu * y_at - mu * POW(y_at,2);

        x_at = MOD(logmap1, NULL);
        y_at = MOD(logmap2, NULL);

        vlogmap[i] = ABS(MOD(logmap1, NULL)-MOD(logmap2, NULL));
    }
    return vlogmap;
}

int cmp(const void* a, const void* b)
{
    struct str* a1 = (struct str*)a;
    struct str* a2 = (struct str*)b;
    if ((*a1).value > (*a2).value)
        return -1;
    else if ((*a1).value < (*a2).value)
        return 1;
    else
        return 0;
}
template <typename T> 
void print_img(T *image_impr, const char *filen)
{
    std::ofstream outputFile(filen);                                       // Open the file for writing
    if (outputFile.is_open())
    {
        for (int i = 0; i < BSIZE; i++)
        {
           outputFile << (int)image_impr[i] << std::endl;                  // Write to the file
        }
        outputFile.close();                                                // Close the file
    }
}

