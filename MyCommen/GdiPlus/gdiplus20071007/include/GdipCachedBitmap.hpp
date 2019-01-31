/**************************************************************************\
*
* Module Name:
*
*   GdipCachedBitmap.hpp
*
* 2007�꣬����ʡ������ͳ�ƾ� ë�� �ڴ���
*
\**************************************************************************/

#ifndef GdipCachedBitmapHPP
#define GdipCachedBitmapHPP

inline
__fastcall TGpCachedBitmap::TGpCachedBitmap(TGpBitmap *bitmap, TGpGraphics *graphics)
{
	CheckStatus(GdipCreateCachedBitmap(bitmap->Native, graphics->Native, &Native));
}
inline
__fastcall TGpCachedBitmap::~TGpCachedBitmap(void)
{
	GdipDeleteCachedBitmap(Native);
}

#endif


