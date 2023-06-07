
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

#include "../imagem.h"

#include <stdio.h>

int main ()
{

    using namespace CryptoPP;
    // Generate a random floating-point number between 0 and 1

    HexEncoder encoder(new FileSink(std::cout));
    std::string digest;
    SHA256 hash;

    hash.Update((const byte*)&imagem[0], 512*512);

    digest.resize(hash.DigestSize());
    hash.Final((byte*)&digest[0]);

    double m1=0.0;
    double m2=0.0;
    // Primeira metade do HASh
    for (int i = 0; i < 15; i++)
    {
        uint8_t h = digest[i];
        m1 += h;
        i++;
    }

    // segunda metade do HASh
   for (int i = 16; i < 31; i++)
    {
        uint8_t h = digest[i];
        m2 += h;
        i++;
    }

    m1 = m1/(16.0  * 1000.0)+0.1;
    m2 = m2/(16.0  * 1000.0)+0.3;

    printf("Cond Ini Perm = %f\n",m1);
    printf("Cond Ini Diff = %f\n",m2);

}