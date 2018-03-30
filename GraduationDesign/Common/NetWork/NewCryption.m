//
//  DriverDataCryption.c
//  CarDriver
//
//  Created by jinfeng.du on 16/10/26.
//  Copyright © 2016年 Qunar. All rights reserved.
//

#include "NewCryption.h"
#include <string.h>
#include <zlib.h>
#include <stdlib.h>

static const unsigned char* POLL_KEY = "A001-B117-C911-0122012321-A3-B2-C1-K";

static unsigned char*
byteToHexStr(unsigned char* byte_arr, int arr_len)
{
    unsigned char* hexstr = (unsigned char*) malloc((arr_len * sizeof(char) + 1) * 2);
    memset(hexstr, 0x0, (arr_len * sizeof(unsigned char) + 1) * 2);
    int i = 0;
    for (i = 0; i < arr_len; i++)
    {
        unsigned char hex1;
        unsigned char hex2;
        unsigned char value = byte_arr[i];
        int v1 = value / 16;
        int v2 = value % 16;
        
        if (v1 >= 0 && v1 <= 9)
            hex1 = (unsigned char) (48 + v1);
        else
            hex1 = (unsigned char) (55 + v1);
        
        if (v2 >= 0 && v2 <= 9)
            hex2 = (unsigned char) (48 + v2);
        else
            hex2 = (unsigned char) (55 + v2);
        
        hexstr[2 * i] = hex1;
        hexstr[2 * i + 1] = hex2;
    }
    return hexstr;
}

static unsigned char*
HexTobyteStr(unsigned char* hex_str, int arr_len)
{
    int length = (arr_len) / (sizeof(unsigned char) * 2);
    unsigned char* byte_arr = (unsigned char*) malloc(length);
    memset(byte_arr, 0, length);
    int i = 0;
    for (i = 0; i < length; i++)
    {
        int pos = i * 2;
        unsigned char v1;
        unsigned char v2;
        unsigned char hex1 = hex_str[pos];
        unsigned char hex2 = hex_str[pos + 1];
        if (hex1 >= '0' && hex1 <= '9')
            v1 = hex1 - 48;
        else if (hex1 >= 'a' && hex1 <= 'z')
            v1 = hex1 - 87;
        else
            v1 = hex1 - 55;
        if (hex2 >= '0' && hex2 <= '9')
            v2 = hex2 - 48;
        else if (hex2 >= 'a' && hex2 <= 'z')
            v2 = hex2 - 87;
        else
            v2 = hex2 - 55;
        byte_arr[i] = v1 << 4 | v2;
    }
    return byte_arr;
}

static unsigned long
getCRC(unsigned char* str, int len)
{
    unsigned long crc1 = 0;
    crc1 = crc32(0L, Z_NULL, 0);
    crc1 = crc32(crc1, str, len);
    
    return crc1;
}
static unsigned char*
edPoll(unsigned char* data, const unsigned char* key, int length)
{
    unsigned char* result = (unsigned char*) malloc((length + 1) * sizeof(unsigned char));
    memset(result, 0x0, (length + 1) * sizeof(char));
    memcpy(result, data, length);
    int keylen = strlen(key);
    unsigned char v = 90;
    int i = 0;
    for (i = 0; i < length; i++)
    {
        result[i] ^= v;
        result[i] += key[i % keylen];
        result[i] += keylen;
    }
    return result;
}

static unsigned char*
ddPoll(unsigned char* data, const unsigned char* key, int length)
{
    unsigned char* result = (unsigned char*) malloc((length + 1) * sizeof(unsigned char));
    memset(result, 0x0, (length + 1) * sizeof(char));
    memcpy(result, data, length);
    int keylen = strlen(key);
    unsigned char v = 90;
    int i = 0;
    for (i = 0; i < length; i++)
    {
        result[i] -= keylen;
        result[i] -= key[i % keylen];
        result[i] ^= v;
    }
    return result;
}

unsigned char* eLocal(unsigned char* input, int inputLen)
{
    if (input == NULL)
        return NULL;
    
    const unsigned char* ikey = POLL_KEY;
    unsigned char* r1 = edPoll(input, ikey, inputLen);
    unsigned long crc32 = getCRC(r1, inputLen);
    unsigned char* r2 = (unsigned char*) malloc(sizeof(unsigned char) * (inputLen + 4) + 1);
    memset(r2, 0x0, sizeof(unsigned char) * (inputLen + 4) + 1);
    r2[0] = (unsigned char) (crc32 & 0x000000FF);
    r2[1] = (unsigned char) ((crc32 >> 24) & 0x000000FF);
    r2[2] = (unsigned char) ((crc32 >> 16) & 0x000000FF);
    r2[3] = (unsigned char) ((crc32 >> 8) & 0x000000FF);
    memcpy(r2 + 4, r1, inputLen);
    free(r1);
    unsigned char* r3 = byteToHexStr(r2, inputLen + 4);
    return r3;
}

unsigned char* dLocal(unsigned char* input, int inputLen)
{
    if (input == NULL || inputLen == 0)
        return NULL;
    unsigned long crc, crc1;
    const unsigned char* ikey = POLL_KEY;
    unsigned char * b = HexTobyteStr(input, inputLen);
    int bLen = inputLen / (sizeof(unsigned char) * 2);
    crc = (unsigned long) (b[0] & 0xff) + ((unsigned long) (b[1] & 0xff) << 24) + ((unsigned long) (b[2] & 0xff) << 16)
    + ((unsigned long) (b[3] & 0xff) << 8);
    crc1 = getCRC(b + 4, bLen - 4);
    if (crc1 == crc)
    {
        unsigned char * bb = ddPoll(b + 4, ikey, bLen - 4);
        return bb;
    }
    return "error";
}

//unsigned char* eLocalttt(unsigned char* input, int inputLen)
//{
//    if (input == NULL)
//        return NULL;
//    
//    unsigned int t1 = strlen(input);
//    
//    const unsigned char* ikey = POLL_KEY;
//    unsigned char* r1 = edPoll(input, ikey, inputLen);
//    unsigned char * bb = ddPoll(r1, ikey, inputLen);
//    
//    
//    
//    unsigned long crc32 = getCRC(r1, inputLen);
//    unsigned char* r2 = (unsigned char*) malloc(sizeof(unsigned char) * (inputLen + 4) + 1);
//    memset(r2, 0x0, sizeof(unsigned char) * (inputLen + 4) + 1);
//    r2[0] = (unsigned char) (crc32 & 0x000000FF);
//    r2[1] = (unsigned char) ((crc32 >> 24) & 0x000000FF);
//    r2[2] = (unsigned char) ((crc32 >> 16) & 0x000000FF);
//    r2[3] = (unsigned char) ((crc32 >> 8) & 0x000000FF);
//    memcpy(r2 + 4, r1, inputLen);
//    free(r1);
//    
//    unsigned long crc = (unsigned long) (r2[0] & 0xff) + ((unsigned long) (r2[1] & 0xff) << 24) + ((unsigned long) (r2[2] & 0xff) << 16)
//    + ((unsigned long) (r2[3] & 0xff) << 8);
//    unsigned long crc1 = getCRC(r2 + 4, inputLen);
//    
//    
////    unsigned char* r2 = input; //test
//    unsigned int t2 = strlen(r2);
//    
//    unsigned char* r3 = byteToHexStr(r2, inputLen+4);
//    unsigned int t3 = strlen(r3);
//    unsigned char * b = HexTobyteStr(r3, t2*2);
//    unsigned int t4 = strlen(b);
//    
//    return r3;
//}
