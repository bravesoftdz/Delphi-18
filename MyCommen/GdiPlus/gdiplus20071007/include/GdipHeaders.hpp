/**************************************************************************\
*
* Module Name:
*
*   GdipHeaders.hpp
*
* 2007�꣬����ʡ������ͳ�ƾ� ë�� �ڴ���
*
\**************************************************************************/

#ifndef GdipHeadersHPP
#define GdipHeadersHPP

class TGpRegion : public TGdiplusBase
{
private:
	friend	class TGpGraphics;

	int __fastcall GetDataSize(void);

protected:
	__fastcall TGpRegion(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpRegion));
	}
#endif
public:
	// �������ڲ���ʼ���� Region ����
	__fastcall TGpRegion(void);
	// ��ָ���� Rect �ṹ��ʼ���� Region ����
	__fastcall TGpRegion(const TGpRectF &rect);
	__fastcall TGpRegion(const TGpRect &rect);
	// ��ָ���� Rect �ṹ��ʼ���� Region ����
	__fastcall TGpRegion(TGpGraphicsPath *path);
    // �����е� Region ������ڲ����ݴ���һ���� Region ����
	// regionData ����Region�����ڲ����ݵĻ�������һ��ͨ��GetData���
	__fastcall TGpRegion(BYTE *regionData, const int regionData_Size);
	// ��ָ�������� GDI ����ľ����ʼ���� Region ����
	__fastcall TGpRegion(HRGN hrgn);
	static TGpRegion* __fastcall FromHRGN(HRGN hrgn);
	__fastcall virtual ~TGpRegion(void);
	TGpRegion* __fastcall Clone(void);
	// ���� Region �����ʼ��Ϊ�����ڲ���
	void __fastcall MakeInfinite(void);
	// ���� Region �����ʼ��Ϊ���ڲ���
	void __fastcall MakeEmpty(void);
	// ���� RegionData������ʾ���������� Region �ṹ��������Ϣ��
	void __fastcall GetData(BYTE *buffer, const int buffer_Size, UINT *sizeFilled = NULL);
	// ���� Region �������Ϊ��������ָ���ṹ�����Ľ�����
	void __fastcall Intersect(const TGpRect &rect);
	void __fastcall Intersect(const TGpRectF &rect);
	void __fastcall Intersect(TGpGraphicsPath* path);
	void __fastcall Intersect(TGpRegion* region);
	// ���� Region �������Ϊ��������ָ���ṹ�����Ĳ�����
	void __fastcall Union(const TGpRect &rect);
	void __fastcall Union(const TGpRectF &rect);
	void __fastcall Union(TGpGraphicsPath* path);
	void __fastcall Union(TGpRegion* region);
	// ���� Region �������Ϊ��������ָ���ṹ�����Ĳ�����ȥ�����ߵĽ���
	void __fastcall Xor(const TGpRect &rect);
	void __fastcall Xor(const TGpRectF &rect);
	void __fastcall Xor(TGpGraphicsPath* path);
	void __fastcall Xor(TGpRegion* region);
	// ���� Region �������Ϊ���������ڲ���ָ���ṹ������ཻ�Ĳ��֡�
	void __fastcall Exclude(const TGpRect &rect);
	void __fastcall Exclude(const TGpRectF &rect);
	void __fastcall Exclude(TGpGraphicsPath* path);
	void __fastcall Exclude(TGpRegion* region);
	// ���� Region �������Ϊָ���ṹ���߶�������� Region �����ཻ�Ĳ��֡�
	void __fastcall Complement(const TGpRect &rect);
	void __fastcall Complement(const TGpRectF &rect);
	void __fastcall Complement(TGpGraphicsPath* path);
	void __fastcall Complement(TGpRegion* region);
	// ʹ�� Region ���������ƫ��ָ��������
	void __fastcall Translate(float dx, float dy);
	void __fastcall Translate(int dx, int dy);
	// ��ָ���� Matrix ����任�� Region ����
	void __fastcall Transform(TGpMatrix* matrix);
	// ��ȡһ�����νṹ���þ����γ� Graphics ����Ļ��Ʊ����ϴ� Region ����ı߽硣
	void __fastcall GetBounds(TGpRect &rect, const TGpGraphics* g);
	void __fastcall GetBounds(TGpRectF &rect, const TGpGraphics* g);
	// ����ָ��ͼ���������д� Region ����� Windows GDI �����
	HRGN __fastcall GetHRGN(TGpGraphics* g);
	// ���Դ� Region ������ָ���Ļ��Ʊ��� g ���Ƿ�յ��ڲ�
	bool __fastcall IsEmpty(TGpGraphics* g);
	// ���Դ� Region ������ָ���Ļ��Ʊ������Ƿ������ڲ���
	bool __fastcall IsInfinite(TGpGraphics* g);
	// ����ָ���������Ƿ�����ڴ� Region �����ڡ�
	bool __fastcall IsVisible(int x, int y, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(const TGpPoint &point, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(float x, float y, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(const TGpPointF &point, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(int x, int y, int width, int height, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(const TGpRect &rect, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(float x, float y, float width, float height, TGpGraphics* g = NULL);
	bool __fastcall IsVisible(const TGpRectF &rect, TGpGraphics* g = NULL);
#if (__BORLANDC__ >= 0x610)
	HIDESBASE bool __fastcall Equals(TGpRegion* region, TGpGraphics* g);
#else
	bool __fastcall Equals(TGpRegion* region, TGpGraphics* g);
#endif
	int __fastcall GetRegionScansCount(TGpMatrix* matrix);
	// ��ȡ��� Region ������Ƶ� RectF �ṹ�����顣��������Ԫ�ظ���
	int __fastcall GetRegionScans(TGpMatrix* matrix, TGpRectF *rects);
	int __fastcall GetRegionScans(TGpMatrix* matrix, TGpRect *rects);
	// �������� Region ������Ϣ�������ĳ���
	__property int DataSize = {read=GetDataSize};

};

//--------------------------------------------------------------------------
// FontFamily
//--------------------------------------------------------------------------

class TGpFontFamily : public TGdiplusBase
{
private:
	friend class TGpFont;
	friend class TGpGraphics;
	friend class TGpGraphicsPath;
	friend class TGpFontCollection;

protected:
	__fastcall TGpFontFamily(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpFontFamily));
	}
#endif
public:
	__fastcall TGpFontFamily(void) : TGdiplusBase() { }
	__fastcall TGpFontFamily(WideString name, TGpFontCollection* fontCollection = NULL);
	__fastcall virtual ~TGpFontFamily(void);
	static TGpFontFamily* __fastcall GenericSansSerif(void);
	static TGpFontFamily* __fastcall GenericSerif(void);
	static TGpFontFamily* __fastcall GenericMonospace(void);
	// ��ָ�������Է��ش� FontFamily ��������ơ�
	WideString __fastcall GetFamilyName(WORD language = 0);
	TGpFontFamily* __fastcall Clone(void);
	// FontFamily �����Ƿ���Ч
	bool __fastcall IsAvailable(void);
	// ָʾָ���� FontStyle ö���Ƿ���Ч��
	bool __fastcall IsStyleAvailable(TFontStyles style);
	// ��ȡָ����ʽ�� em ���εĸ߶ȣ�����������Ƶ�λ��
	WORD __fastcall GetEmHeight(TFontStyles style);
	// ����ָ����ʽ�� FontFamily ����ĵ�Ԫ������
	WORD __fastcall GetCellAscent(TFontStyles style);
	// ����ָ����ʽ�� FontFamily ����ĵ�Ԫ���½�
	WORD __fastcall GetCellDescent(TFontStyles style);
	// ����ָ����ʽ�� FontFamily ������о�
	WORD __fastcall GetLineSpacing(TFontStyles style);

};

enum TUnit {
	utWorld,      // 0 -- ��ȫ�ֵ�λָ��Ϊ������λ��
	utDisplay,    // 1 -- �� 1/75 Ӣ��ָ��Ϊ������λ��
	utPixel,      // 2 -- ���豸����ָ��Ϊ������λ��
	utPoint,      // 3 -- ����ӡ���㣨1/72 Ӣ�磩ָ��Ϊ������λ��.
	utInch,       // 4 -- ��Ӣ��ָ��Ϊ������λ
	utDocument,   // 5 -- ���ĵ���λ��1/300 Ӣ�磩ָ��Ϊ������λ��
	utMillimeter  // 6 -- ������ָ��Ϊ������λ��
};

//--------------------------------------------------------------------------
// Font
//--------------------------------------------------------------------------

class TGpFont : public TGdiplusBase
{
private:
	friend class TGpGraphics;

private:
	float __fastcall GetSize(void);
	TFontStyles __fastcall GetStyle(void);
	TUnit __fastcall GetUnit(void);
	WideString __fastcall GetName();

protected:
	__fastcall TGpFont(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpFont));
	}
#endif
public:
	    // ���豸�����ĵ�ָ�� Windows ������� Font ����
    // DC ���������������ѡ��������豸�����ĵľ����
	// �˷����������ڴ� GDI+ Graphics �����õ� hdc����Ϊ�� hdc û��ѡ�������塣
	__fastcall TGpFont(HDC DC);
	__fastcall TGpFont(HDC DC, LOGFONTA* logfont);
	__fastcall TGpFont(HDC DC, LOGFONTW* logfont);
	__fastcall TGpFont(HDC DC, HFONT font);
	__fastcall TGpFont(TGpFontFamily* family, float emSize,
		TFontStyles style = TFontStyles(), TUnit unit = utPoint);
	__fastcall TGpFont(WideString familyName, float emSize,
		TFontStyles style = TFontStyles(), TUnit unit = utPoint,
		TGpFontCollection* fontCollection = NULL);
	__fastcall virtual ~TGpFont(void);
	LOGFONTA __fastcall GetLogFontA(TGpGraphics* g);
	LOGFONTW __fastcall GetLogFontW(TGpGraphics* g);
	TGpFont* __fastcall Clone(void);
	bool __fastcall IsAvailable(void);
	// ����ָ���� Graphics ����ĵ�ǰ��λ�����ش�������оࡣ
	float __fastcall GetHeight(TGpGraphics* graphics);
    // ����ָ���Ĵ�ֱ�ֱ��ʻ��Ƶ��豸ʱ���ش� Font ����ĸ߶ȣ�������Ϊ��λ��
    // �о������������ı��еĻ���֮��Ĵ�ֱ���롣
	// ��ˣ��о�����м�Ŀհ׿ռ估�ַ�����ĸ߶ȡ�
	float __fastcall GetHeight(float dpi);
	// ��ȡ�� Font �����������Ϣ��
	void __fastcall GetFamily(TGpFontFamily* family);
	// ��ȡ������� Font ����ĵ�λ�������ġ���� Font �����ȫ���С
	__property float Size = {read=GetSize};
	__property TFontStyles Style = {read=GetStyle};
	__property TUnit FontUnit = {read=GetUnit};
	__property WideString Name = {read=GetName};

};

//--------------------------------------------------------------------------
// Font Collection
//--------------------------------------------------------------------------
class TGpFontCollection : public TGdiplusBase
{
private:
	friend	class TGpFontFamily;

protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpFontCollection));
	}
#endif
public:
	__fastcall TGpFontCollection(void) : TGdiplusBase() { }
	__fastcall virtual ~TGpFontCollection(void) { }
	int __fastcall GetFamilyCount(void);
	int __fastcall GetFamilies(TGpFontFamily **gpfamilies, const int gpfamilies_Size);

};

class TGpInstalledFontCollection : public TGpFontCollection
{
protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpInstalledFontCollection));
	}
#endif
public:
	__fastcall TGpInstalledFontCollection(void);
	__fastcall virtual ~TGpInstalledFontCollection(void) { }

};

class TGpPrivateFontCollection : public TGpFontCollection
{
protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpPrivateFontCollection));
	}
#endif
public:
	__fastcall TGpPrivateFontCollection(void);
	__fastcall virtual ~TGpPrivateFontCollection(void);
	void __fastcall AddFontFile(const WideString filename);
	void __fastcall AddMemoryFont(const void *memory, int length);

};

//--------------------------------------------------------------------------
// Abstract base class for Image and Metafile
//--------------------------------------------------------------------------

enum TImageType {itUnknown, itBitmap, itMetafile};
enum TRotateFlipType
{
	rfNone     = 0,      // ָ����������ת�ͷ�ת
	rfNone90   = 1,      // ָ�������з�ת�� 90 ����ת��
	rfNone180  = 2,      // ָ�������з�ת�� 180 ����ת��
	rfNone270  = 3,      // ָ�������з�ת�� 270 ����ת��

	rfXNone    = 4,      // ָ��ˮƽ��ת��
	rfX90      = 5,      // ָ��ˮƽ��ת�� 90 ����ת��
	rfX180     = 6,      // ָ��ˮƽ��ת�� 180 ����ת��
	rfX270     = 7,      // ָ��ˮƽ��ת�� 270 ����ת��

	rfYNone = rfX180,    // ָ����ֱ��ת
	rfY90 = rfX270,      // ָ����ֱ��ת�� 90 ����ת��
	rfY180 = rfXNone,    // ָ����ֱ��ת�� 180 ����ת��
	rfY270 = rfX90,      // ָ����ֱ��ת�� 270 ����ת��

	rfXYNone = rfNone180,// ָ��û��ˮƽ�ʹ�ֱ��ת����ת
	rfXY90 = rfNone270,  // ָ��ˮƽ��ת�ʹ�ֱ��ת�� 90 ����ת��
	rfXY180 = rfNone,    // ָ��ˮƽ��ת�ʹ�ֱ��ת�� 180 ����ת��
	rfXY270 = rfNone90   // ָ��ˮƽ��ת�ʹ�ֱ��ת�� 270 ����ת��
};

enum TPixelFormat
{
    pfNone,           // δ����
    pf1bppIndexed,    // ���ظ�ʽΪ 1 λ����ָ����ʹ��������ɫ�������ɫ������������ɫ��
    pf4bppIndexed,    // ���ظ�ʽΪ 4 λ�����Ѵ���������
    pf8bppIndexed,    // ���ظ�ʽΪ 8 λ�����Ѵ��������������ɫ������ 256 ����ɫ��
    pf16bppGrayScale, // ���ظ�ʽΪ 16 λ������ɫ��Ϣָ�� 65536 �ֻ�ɫ����
    pf16bppRGB555,    // ���ظ�ʽΪ 16 λ����ɫ����ɫ����ɫ������ʹ�� 5 λ��ʣ��� 1 λδʹ�á�
    pf16bppRGB565,    // ���ظ�ʽΪ 16 λ����ɫ����ʹ�� 5 λ����ɫ����ʹ�� 6 λ����ɫ����ʹ�� 5 λ��
    pf16bppARGB1555,  // ���ظ�ʽ 16 λ������ɫ��Ϣָ�� 32,768 ��ɫ������ɫ����ɫ����ɫ������ʹ�� 5 λ��1 λΪ alpha��
    pf24bppRGB,       // ���ظ�ʽΪ 24 λ����ɫ����ɫ����ɫ������ʹ�� 8 λ��
    pf32bppRGB,       // ���ظ�ʽΪ 32 λ����ɫ����ɫ����ɫ������ʹ�� 8 λ��ʣ��� 8 λδʹ�á�
    pf32bppARGB,      // ���ظ�ʽΪ 32 λ��alpha����ɫ����ɫ����ɫ������ʹ�� 8 λ��
    pf32bppPARGB,	  // ���ظ�ʽΪ 32 λ��alpha����ɫ����ɫ����ɫ������ʹ�� 8 λ������ alpha �������Ժ�ɫ����ɫ����ɫ������������ˡ�
    pf48bppRGB,		  // ���ظ�ʽΪ 48 λ����ɫ����ɫ����ɫ������ʹ�� 16 λ��
    pf64bppARGB,      // ���ظ�ʽΪ 64 λ��alpha����ɫ����ɫ����ɫ������ʹ�� 16 λ��
    pf64bppPARGB,	  // ���ظ�ʽΪ 64 λ��alpha����ɫ����ɫ����ɫ������ʹ�� 16 λ������ alpha �������Ժ�ɫ����ɫ����ɫ������������ˡ�
};

class TGpImage : public TGdiplusBase
{
private:
	friend class TGpBrush;
	friend class TGpTextureBrush;
	friend class TGpGraphics;

protected:
	__fastcall TGpImage(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpImage));
	}
#endif
    __fastcall TGpImage(void){}
private:
	TColorPalette* FPalette;

	TImageFlags __fastcall GetFlags(void);
	int __fastcall GetHeight(void);
	float __fastcall GetHorizontalResolution(void);
	int __fastcall GetPaletteSize(void);
	TGpSizeF __fastcall GetPhysicalDimension();
	TGUID __fastcall GetRawFormat();
	TImageType __fastcall GetType(void);
	float __fastcall GetVerticalResolution(void);
	int __fastcall GetWidth(void);
	TPixelFormat __fastcall GetPixelFormat(void);
	int __fastcall GetFrameDimensionsCount(void);
	int __fastcall GetPropertyCount(void);
	int __fastcall GetPropertySize(void);
	TColorPalette* __fastcall GetPalette();
	void __fastcall SetPalette(const TColorPalette *palette);
	
public:
	// ʹ�ø��ļ��е�Ƕ����ɫ������Ϣ����ָ�����ļ����� Image ����
	__fastcall TGpImage(const WideString filename, bool useEmbeddedColorManagement = false);
	static TGpImage* __fastcall FromFile(const WideString filename, bool useEmbeddedColorManagement = false);
	// ʹ��ָ������������Ƕ�����ɫ������Ϣ���Ӹ����������� Image ����
	__fastcall TGpImage(IStream *stream, bool useEmbeddedColorManagement = false);
	static TGpImage* __fastcall FromStream(IStream *stream, bool useEmbeddedColorManagement = false);
	__fastcall virtual ~TGpImage(void);
	virtual TGpImage* __fastcall Clone(void);
	// ����ͼ����ָ���ĸ�ʽ���浽ָ�����ļ���
	// ע��ͨ���ļ���������Image�����ļ���������״̬��ֱ�Ӹ��Ǳ�������
	void __fastcall Save(const WideString filename, const TGUID &clsidEncoder,
			const TEncoderParameters* encoderParams = NULL);
	// ����ͼ����ָ���ĸ�ʽ���浽ָ�������С�
	void __fastcall Save(IStream *stream, const TGUID &clsidEncoder,
			const TEncoderParameters* encoderParams = NULL);
	// ����һ Save ����������ָ�����ļ����������һ֡��
	void __fastcall SaveAdd(const TEncoderParameters* encoderParams);
	void __fastcall SaveAdd(TGpImage *newImage, const TEncoderParameters* encoderParams);
	// ��ָ���ĵ�λ��ȡ�� Image ����ľ���
	void __fastcall GetBounds(TGpRectF &srcRect, TUnit &srcUnit);
	// ���ش� Image ���������ͼ��ʹ�ú����Free
	TGpImage* __fastcall GetThumbnailImage(int thumbWidth, int thumbHeight,
			GetThumbnailImageAbort callback = NULL, void *callbackData = NULL);
	// ��ȡ GUID �����飬��Щ GUID ��ʾ Image ������֡��ά�ȡ�
	void __fastcall GetFrameDimensionsList(TGUID *dimensionIDs, const int dimensionIDs_Size);
	// ����ָ��ά�ȵ�֡����
	int __fastcall GetFrameCount(const TGUID &dimensionID);
	// ѡ����ά�Ⱥ�����ָ����֡��
	void __fastcall SelectActiveFrame(const TGUID &dimensionID, int frameIndex);
	// �˷�����ת����ת����ͬʱ��ת�ͷ�ת Image ����
	void __fastcall RotateFlip(TRotateFlipType rotateFlipType);
	// ��ȡ�洢�� Image �����е�������� ID��list���Ȳ�С��PropertyCount
	void __fastcall GetPropertyIdList(int numOfProperty, PROPID *list);
	// ��ȡpropID��ָ������ĳ��ȣ�����TPropertyItem���Ⱥ���value��ָ�ĳ���
	int __fastcall GetPropertyItemSize(PROPID propId);
	// ��ȡpropID��ָ�����buffer�ĳ���Ӧ��С��GetPropertyItemSize
	void __fastcall GetPropertyItem(PROPID propId, TPropertyItem* buffer);
	// ��ȡȫ�������alItems�ĳ��ȱ��벻С��PropertySize
	void __fastcall GetAllPropertyItems(TPropertyItem* allItems);
	// ��Image����ȥpropID��ָ��������
	void __fastcall RemovePropertyItem(PROPID propId);
	// ����������
	void __fastcall SetPropertyItem(const TPropertyItem &item);
	// �����й�ָ����ͼ���������֧�ֵĲ�������Ϣ�ĳ��ȣ��ֽ�����
	int __fastcall GetEncoderParameterListSize(const Activex::TCLSID &clsidEncoder);
	// �����й�ָ����ͼ���������֧�ֵĲ�������Ϣ��
	void __fastcall GetEncoderParameterList(const Activex::TCLSID &clsidEncoder, int size, TEncoderParameters* buffer);
    // ����ָ�������ظ�ʽ����ɫ��ȣ����ص�λ������
	static int __fastcall GetPixelFormatSize(TPixelFormat Format);
	// ��ȡ�� Image ��������Ա��
	__property TImageFlags Flags = {read=GetFlags};
	// ��ȡ�� Image ����ĸ߶ȡ�
	__property int Height = {read=GetHeight};
	// ��ȡ�� Image �����ˮƽ�ֱ��ʣ��ԡ�����/Ӣ�硱Ϊ��λ����
	__property float HorizontalResolution = {read=GetHorizontalResolution};
	// ��ȡ��ͼ��Ŀ�Ⱥ͸߶ȡ�
	__property TGpSizeF PhysicalDimension = {read=GetPhysicalDimension};
	// ��ȡ�� Image ����ĸ�ʽ��
	__property TGUID RawFormat = {read=GetRawFormat};
	// ��ȡ Image ���������
	__property TImageType ImageType = {read=GetType};
	// ��ȡ�� Image ����Ĵ�ֱ�ֱ��ʣ��ԡ�����/Ӣ�硱Ϊ��λ����
	__property float VerticalResolution = {read=GetVerticalResolution};
	// ��ȡ�� Image ����Ŀ�ȡ�
	__property int Width = {read=GetWidth};
	// ��ȡ�� Image ��������ظ�ʽ��
	__property TPixelFormat PixelFormat = {read=GetPixelFormat};
	__property int FrameDimensionsCount = {read=GetFrameDimensionsCount};
	// ��ȡ�洢�� Image �����е����Ը���
	__property int PropertyCount = {read=GetPropertyCount};
	// ��ȡ�洢�� Image �����е�ȫ��������ĳ��ȣ�����TpropertyItem.value��ָ���ֽ���
	__property int PropertySize = {read=GetPropertySize};
	// ��ȡ��ɫ��ĳ���
	__property int PaletteSize = {read=GetPaletteSize};
	// ��ȡ���������ڴ� Image ����ĵ�ɫ�塣
	__property TColorPalette* Palette = {read=GetPalette, write=SetPalette};

};

enum TImageLockMode
{
	imRead,
	imWrite,
	imUserInputBuf
};

typedef Set<TImageLockMode, imRead, imUserInputBuf> TImageLockModes;

class TGpBitmap : public TGpImage
{
private:
	friend class TGpImage;
	friend class TGpCachedBitmap;

protected:
	__fastcall TGpBitmap(GpNative *native, TCloneAPI cloneFun) : TGpImage(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpBitmap));
	}
#endif
private:
	TGpColor __fastcall GetPixel(int x, int y);
	void __fastcall SetPixel(int x, int y, const TGpColor &color);
	
public:
	__fastcall TGpBitmap(const WideString filename, bool useEmbeddedColorManagement = false);
	__fastcall TGpBitmap(IStream *stream, bool useEmbeddedColorManagement = false);
	__fastcall TGpBitmap(int width, int height, int stride, TPixelFormat format, BYTE* scan0);
	__fastcall TGpBitmap(int width, int height, TPixelFormat format = pf32bppARGB);
	__fastcall TGpBitmap(int width, int height, TGpGraphics* target);
	__fastcall TGpBitmap(const BITMAPINFO &gdiBitmapInfo, void * gdiBitmapData);
	__fastcall TGpBitmap(HBITMAP hbm, HPALETTE hpal);
	__fastcall TGpBitmap(HICON icon);
	__fastcall TGpBitmap(HINSTANCE hInstance, const WideString bitmapName);
	__fastcall TGpBitmap(IDirectDrawSurface7* surface);
	static TGpBitmap* __fastcall FromFile(const WideString filename, bool useEmbeddedColorManagement = false);
	static TGpBitmap* __fastcall FromStream(IStream *stream, bool useEmbeddedColorManagement = false);
	static TGpBitmap* __fastcall FromDirectDrawSurface7(IDirectDrawSurface7* surface);
	static TGpBitmap* __fastcall FromBITMAPINFO(const BITMAPINFO &gdiBitmapInfo, void * gdiBitmapData);
	static TGpBitmap* __fastcall FromHBITMAP(HBITMAP hbm, HPALETTE hpal);
	static TGpBitmap* __fastcall FromHICON(HICON icon);
	static TGpBitmap* __fastcall FromResource(HINSTANCE hInstance, const WideString bitmapName);

	HIDESBASE TGpBitmap* __fastcall Clone(const TGpRect &rect, TPixelFormat format);
	HIDESBASE TGpBitmap* __fastcall Clone(int x, int y, int width, int height, TPixelFormat format);
	HIDESBASE TGpBitmap* __fastcall Clone(const TGpRectF &rect, TPixelFormat format);
	HIDESBASE TGpBitmap* __fastcall Clone(float x, float y, float width, float height, TPixelFormat format);
	// �� Bitmap ����������ϵͳ�ڴ��С����� rect: ��ָ��Ҫ������ Bitmap ���֡�
    // flags: ImageLockMode ö�٣���ָ�� Bitmap ����ķ��ʼ��𣨶���д����
	// format: Bitmap ��������ݸ�ʽ
	void __fastcall LockBits(const TGpRect &rect, TImageLockModes mode, TPixelFormat format, TBitmapData &data);
	// ��ϵͳ�ڴ���� Bitmap��
	void __fastcall UnlockBits(TBitmapData &lockedBitmapData);
	// ���ô� Bitmap �ķֱ��ʡ�
	void __fastcall SetResolution(float xdpi, float ydpi);
	    // �ô� Bitmap ���󴴽������� GDI λͼ����colorBackgroundָ������ɫ��
	// ���λͼ��ȫ��͸��������Դ˲�����Ӧ���� DeleteObject �ͷ� GDI λͼ����
	HBITMAP __fastcall GetHBITMAP(const TGpColor &colorBackground);
	// ����ͼ��ľ����
	HICON __fastcall GetHICON(void);
	// ��ȡ������ Bitmap ������ָ�����ص���ɫ��
	__property TGpColor Pixels[int x][int y] = {read=GetPixel, write=SetPixel};

};


//--------------------------------------------------------------------------
// Line cap constants (only the lowest 8 bits are used).
//--------------------------------------------------------------------------

enum TLineCap
{
	lcFlat,   					// ƽ��ñ��
	lcSquare,   				// ����ñ��
	lcRound,   					// Բ��ñ
	lcTriangle,   				// ������ñ��
	lcNoAnchor         = 0x10, 	// û��ê��
	lcSquareAnchor     = 0x11, 	// ��êͷñ
	lcRoundAnchor      = 0x12, 	// Բêͷñ��
	lcDiamondAnchor    = 0x13, 	// ����êͷñ��
	lcArrowAnchor      = 0x14, 	// ��ͷ״êͷñ
	lcCustom           = 0xff, 	// �Զ�����ñ��
	lcAnchorMask       = 0xf0  	// ���ڼ����ñ�Ƿ�Ϊêͷñ�����롣
};

//--------------------------------------------------------------------------
// Custom Line cap type constants
//--------------------------------------------------------------------------

enum TCustomLineCapType {ltDefault, ltAdjustableArrow};

//--------------------------------------------------------------------------
// Line join constants
//--------------------------------------------------------------------------

enum TLineJoin
{
	ljMiter, 		// б���ӡ��⽫����һ����ǻ��г���
	ljBevel, 		// ��б�ǵ����ӡ��⽫����һ��б�ǡ�
	ljRound, 		// Բ�����ӡ��⽫��������֮�����ƽ����Բ����
	ljMiterClipped  // б���ӡ��⽫����һ����ǻ�б�ǣ�
};

class TGpCustomLineCap : public TGdiplusBase
{
private:
	friend	class TGpPen;

protected:
	__fastcall TGpCustomLineCap(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun){}
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpCustomLineCap));
	}
#endif
	__fastcall TGpCustomLineCap(void){}
private:
	TLineCap __fastcall GetBaseCap(void);
	void __fastcall SetBaseCap(TLineCap baseCap);
	float __fastcall GetBaseInset(void);
	void __fastcall SetBaseInset(float inset);
	TLineJoin __fastcall GetStrokeJoin(void);
	void __fastcall SetStrokeJoin(TLineJoin lineJoin);
	float __fastcall GetWidthScale(void);
	void __fastcall SetWidthScale(float widthScale);
	
public:
    // ͨ��ָ��������������Ƕ���ָ�������� LineCap ö�ٳ�ʼ�� CustomLineCap �����ʵ����
    // fillPath: �Զ�����ñ������ݵĶ���strokePath: �Զ�����ñ�����Ķ���
	// baseCap: �����䴴���Զ�����ñ����ñ��baseInset: ��ñ��ֱ��֮��ľ��롣
	__fastcall TGpCustomLineCap(TGpGraphicsPath* fillPath,
			TGpGraphicsPath* strokePath, TLineCap baseCap = lcFlat, float baseInset = 0.0);
	__fastcall virtual ~TGpCustomLineCap(void);
	TGpCustomLineCap* __fastcall Clone(void);
	// �������ڹ��ɴ��Զ�����ñ����ʼֱ�ߺͽ���ֱ����ͬ����ñ��
	void __fastcall SetStrokeCap(TLineCap strokeCap);
	// ��ȡ���ڹ��ɴ��Զ�����ñ����ʼֱ�ߺͽ���ֱ�ߵ���ñ��
	void __fastcall GetStrokeCaps(TLineCap &startCap, TLineCap &endCap);
	// �������ڹ��ɴ��Զ�����ñ����ʼֱ�ߺͽ���ֱ�ߵ���ñ��
	void __fastcall SetStrokeCaps(TLineCap startCap, TLineCap endCap);
	// ��ȡ�����ø� CustomLineCap �����ڵ� LineCap ö�١�
	__property TLineCap BaseCap = {read=GetBaseCap, write=SetBaseCap};
	// ��ȡ��������ñ��ֱ��֮��ľ��롣
	__property float BaseInset = {read=GetBaseInset, write=SetBaseInset};
	// ��ȡ������ LineJoin ö�٣���ö��ȷ��������ӹ��ɴ� CustomLineCap �����ֱ�ߡ�
	__property TLineJoin StrokeJoin = {read=GetStrokeJoin, write=SetStrokeJoin};
	// ��ȡ����������� Pen ����Ŀ�ȴ� CustomLineCap ��������������
	__property float WidthScale = {read=GetWidthScale, write=SetWidthScale};

};

class TGpCachedBitmap : public TGdiplusBase
{
private:
	friend	class TGpGraphics;

protected:
	__fastcall TGpCachedBitmap(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun){}
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpCachedBitmap));
	}
#endif
public:
	__fastcall TGpCachedBitmap(TGpBitmap *bitmap, TGpGraphics *graphics);
	__fastcall virtual ~TGpCachedBitmap(void);

};

#endif  // !GDIPHEADERS.HPP
