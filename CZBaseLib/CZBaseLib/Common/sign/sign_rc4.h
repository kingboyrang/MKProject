#pragma once

/* ================================================== *
    RC4加密/解密
    data[dataLen] [in/out] 加密/解密的数据
    key[keyLen]   [in]     密钥
 * ================================================== */
extern  void RC4_GL_WLDH(unsigned char* data, unsigned long dataLen, unsigned char* key, unsigned long keyLen);
