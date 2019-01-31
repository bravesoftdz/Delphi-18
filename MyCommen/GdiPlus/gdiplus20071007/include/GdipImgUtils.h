#ifndef __GDIPIMGUTILS_H
#define __GDIPIMGUTILS_H

#include <windows.h>
#ifdef __cplusplus
#include <algorithm>
using std::min;
using std::max;
#include <gdiplus.h>
using namespace Gdiplus;
#else
#include "Gdiplus_c.h"
#endif
#include "ImageUtils.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus

// ��ȡBitmapͼ�����ݽṹ��������FreeImageData�ͷŷ���ֵ
BOOL GetGpBitmapData(const Bitmap *bitmap, PImageData data);
// ����Bitmap������ͼ�����ݽṹ��ֱ�Ӳ���Bitmapɨ����
BOOL GpBitmapLockData(const Bitmap *bitmap, PImageData data);
// ������Bitmap��ͼ�����ݽṹData����
void GpBitmapUnlockData(const Bitmap *bitmap, PImageData data);

#else

// ��ȡBitmapͼ�����ݽṹ��������FreeImageData�ͷŷ���ֵ
BOOL GetGpBitmapData(const PGpBitmap bitmap, PImageData data);
// ����Bitmap������ͼ�����ݽṹ��ֱ�Ӳ���Bitmapɨ����
BOOL GpBitmapLockData(const PGpBitmap bitmap, PImageData data);
// ������Bitmap��ͼ�����ݽṹData����
void GpBitmapUnlockData(const PGpBitmap bitmap, PImageData data);

#endif

#ifdef __cplusplus
}   // extern "C"
#endif

#endif

