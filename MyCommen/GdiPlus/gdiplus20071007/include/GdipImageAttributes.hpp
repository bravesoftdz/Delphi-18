/**************************************************************************\
*
* Module Name:
*
*   GdipImageAttributes.hpp
*
* 2007�꣬����ʡ������ͳ�ƾ� ë�� �ڴ���
*
\**************************************************************************/

#ifndef GdipImageAttributesHPP
#define GdipImageAttributesHPP

//--------------------------------------------------------------------------
// ImageAttributes ��������й��ڳ���ʱ��β���λͼ��ͼԪ�ļ���ɫ����Ϣ��
//  ά�������ɫ�������ã�������ɫ�������󡢻Ҷȵ�������٤��У��ֵ��
//  ��ɫӳ������ɫ��ֵ�����ֹ����У����Զ���ɫ����У����������������ɾ���ȵȡ�
//--------------------------------------------------------------------------

//----------------------------------------------------------------------------
// Color Matrix flags
//----------------------------------------------------------------------------

enum TColorMatrixFlags
{
	cfDefault,  // �������е���ɫֵ��������ɫ���ƣ���
	cfSkipGrays,// ������ɫ����������ɫ���ơ�
	cfAltGray
};

//----------------------------------------------------------------------------
// Color Adjust Type
//----------------------------------------------------------------------------

enum TColorAdjustType
{
	ctDefault,  // ����û����ɫ������Ϣ������ GDI+ ������ʹ�õ���ɫ������Ϣ��
	ctBitmap,   // TBitmap �������ɫ������Ϣ��
	ctBrush,    // TBrush �������ɫ������Ϣ��
	ctPen,      // TPen �������ɫ������Ϣ��
	ctText,     // �ı�����ɫ������Ϣ��
	ctCount,    // ָ�������͵���Ŀ��
	ctAny       // ָ�������͵���Ŀ��
};

//----------------------------------------------------------------------------
// Color Channel flags
//----------------------------------------------------------------------------

enum TColorChannelFlags
{
	ccfC,   // ��ɫͨ����
	ccfM,   // ���ɫͨ����
	ccfY,   // ��ɫͨ����
	ccfK,   // ��ɫͨ����
	ccfLast // ��Ԫ��ָ���������ϴ�ѡ������ɫͨ����
};

//--------------------------------------------------------------------------
// Various wrap modes for brushes
//--------------------------------------------------------------------------

enum TWrapMode
{
    wmTile,       // ƽ�̽��������
    wmTileFlipX,  // ˮƽ��ת����򽥱䣬Ȼ��ƽ�̸�����򽥱䡣
    wmTileFlipY,  // ��ֱ��ת����򽥱䣬Ȼ��ƽ�̸�����򽥱䡣
    wmTileFlipXY, // ˮƽ�ʹ�ֱ��ת����򽥱䣬Ȼ��ƽ�̸�����򽥱䡣
    wmClamp       // ������ͽ��������߽���£��
};

typedef	ColorMatrix		TColorMatrix;
typedef	ColorMap		TColorMap;

class TGpImageAttributes : public TGdiplusBase
{
	friend class TGpGraphics;
	friend class TGpTextureBrush;

protected:
	__fastcall TGpImageAttributes(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpImageAttributes));
	}
#endif
public:
	__fastcall TGpImageAttributes(void)
    {
		CheckStatus(GdipCreateImageAttributes(&Native));
    }
	__fastcall virtual ~TGpImageAttributes(void)
    {
		GdipDisposeImageAttributes(Native);
    }
	TGpImageAttributes* __fastcall Clone(void)
	{
		return new TGpImageAttributes(Native, (TCloneAPI)GdipCloneImageAttributes);
	}

	void __fastcall SetToIdentity(TColorAdjustType type = ctDefault)
	{
		CheckStatus(GdipSetImageAttributesToIdentity(Native, (ColorAdjustType)(int)type));
    }

	void __fastcall Reset(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipResetImageAttributes(Native, (ColorAdjustType)(int)type));
    }
	// Ϊָ�����������ɫ��������
	void __fastcall SetColorMatrix(const TColorMatrix &colorMatrix,
						TColorMatrixFlags mode = cfDefault,
						TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorMatrix(Native, (ColorAdjustType)(int)type,
			true, &colorMatrix, NULL, (ColorMatrixFlags)mode));
    }
    // ���ָ��������ɫ��������
	void __fastcall ClearColorMatrix(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorMatrix(Native,
            (ColorAdjustType)(int)type, false, NULL, NULL, ColorMatrixFlagsDefault));
    }
    // Ϊָ�����������ɫ��������ͻҶȵ�������
	void __fastcall SetColorMatrices(const TColorMatrix &colorMatrix,
						  const TColorMatrix &grayMatrix,
						  TColorMatrixFlags mode = cfDefault,
						  TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorMatrix(Native,
            (ColorAdjustType)(int)type, true, &colorMatrix, &grayMatrix, (ColorMatrixFlags)(int)mode));
    }
    // ���ָ�������ɫ��������ͻҶȵ�������
	void __fastcall ClearColorMatrices(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorMatrix(Native,
							  (ColorAdjustType)(int)type, false, NULL, NULL, ColorMatrixFlagsDefault));
    }
    // Ϊָ�����������ֵ��͸����Χ����
    // threshold: 0.0 �� 1.0 ֮�����ֵ.ָ��ÿ����ɫ�ɷֵķֽ�㡣�ٶ���ֵ����Ϊ 0.7��
    // ���Ҽٶ���ǰ�����ֵ���ɫ�еĺ�ɫ����ɫ����ɫ�ɷֱַ�Ϊ 230��50 �� 220��
    // ��ɫ�ɷ� 230 ���� 0.7x255����ˣ���ɫ�ɷֽ�����Ϊ 255��ȫ���ȣ���
    // ��ɫ�ɷ� 50 С�� 0.7x255����ˣ���ɫ�ɷֽ�����Ϊ 0��
    // ��ɫ�ɷ� 220 ���� 0.7x255����ˣ���ɫ�ɷֽ�����Ϊ 255
	void __fastcall SetThreshold(float threshold, TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesThreshold(Native, (ColorAdjustType)(int)type, true, threshold));
    }
    // Ϊָ����������ֵ��
	void __fastcall ClearThreshold(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesThreshold(Native, (ColorAdjustType)(int)type, false, 0.0));
    }
    // Ϊָ���������٤��ֵ��gamma ٤��У��ֵ�����͵�٤��ֵ�� 1.0 �� 2.2 ֮�䣻
    // ����ĳЩ����£�0.1 �� 5.0 ��Χ�ڵ�ֵҲ�����á�
	void __fastcall SetGamma(float gamma, TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesGamma(Native, (ColorAdjustType)(int)type, true, gamma));
    }
    // ����٤��У����
	void __fastcall ClearGamma(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesGamma(Native, (ColorAdjustType)(int)type, false, 0.0));
    }
    // Ϊָ�����ر���ɫ���������Ե��� ClearNoOp �ָ��� SetNoOp ����ǰ�Ѵ��ڵ���ɫ�������á�
	void __fastcall SetNoOp(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesNoOp(Native, (ColorAdjustType)(int)type, true));
    }
    // ��� NoOp ���á�
	void __fastcall ClearNoOp(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesNoOp(Native, (ColorAdjustType)(int)type, false));
    }
    // Ϊָ���������ɫ����͸����Χ����ֻҪ��ɫ�ɷִ��ڸߵ�ɫ����Χ�ڣ�����ɫ�ͻ��Ϊ͸���ġ�
    // colorLow ��ɫ��ֵ; colorHigh ��ɫ��ֵ
	void __fastcall SetColorKey(const TGpColor& colorLow, const TGpColor& colorHigh,
					 TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorKeys(Native,
                              (ColorAdjustType)(int)type, true, colorLow.Argb, colorHigh.Argb));
    }
    // Ϊָ��������ɫ����͸����Χ��
	void __fastcall ClearColorKey(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesColorKeys(Native, (ColorAdjustType)(int)type, false, NULL, NULL));
    }
    // Ϊָ��������� CMYK ���ͨ����flags: ָ�����ͨ����
	void __fastcall SetOutputChannel(TColorChannelFlags channelFlags, TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesOutputChannel(Native,
            (ColorAdjustType)(int)type, true, (ColorChannelFlags)(int)channelFlags));
    }
    // Ϊָ�������� CMYK ���ͨ�����á�
	void __fastcall ClearOutputChannel(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesOutputChannel(Native, (ColorAdjustType)(int)type, false, ColorChannelFlagsLast));
    }
    // Ϊָ������������ͨ����ɫ�����ļ�
	void __fastcall SetOutputChannelColorProfile(const WideString colorProfileFilename,
								TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesOutputChannelColorProfile(
                              Native, (ColorAdjustType)(int)type, true, colorProfileFilename.c_bstr()));
    }
    // Ϊָ�����������ͨ����ɫ�����ļ����á�
	void __fastcall ClearOutputChannelColorProfile(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesOutputChannelColorProfile(Native, (ColorAdjustType)(int)type, false, NULL));
    }
    // Ϊָ�����������ɫ����ӳ���
	void __fastcall SetRemapTable(UINT mapSize, const TColorMap *map, TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesRemapTable(Native, (ColorAdjustType)(int)type, true, mapSize, map));
    }
    // �����ɫ����ӳ���
	void __fastcall ClearRemapTable(TColorAdjustType type = ctDefault)
    {
		CheckStatus(GdipSetImageAttributesRemapTable(Native, (ColorAdjustType)(int)type, false, 0, NULL));
    }
    // Ϊ��ˢ���������ɫ����ӳ���map: TColorMap���顣
	void __fastcall SetBrushRemapTable(UINT mapSize, const TColorMap *map)
    {
		SetRemapTable(mapSize, map, ctBrush);
    }
    // �����ˢ��ɫ����ӳ���
	void __fastcall ClearBrushRemapTable()
    {
		ClearRemapTable(ctBrush);
    }
    // ���û���ģʽ����ɫ�����ھ�����ν�����ƽ�̵�һ����״�ϣ���ƽ�̵���״�ı߽��ϡ�
    // ������С������������״ʱ�������ڸ���״��ƽ������������״��
    // mode �ظ���ͼ�񸱱�ƽ������ķ�ʽ; color ָ������ͼ���ⲿ�����ص���ɫ��
	void __fastcall SetWrapMode(TWrapMode wrap, const TGpColor& color = TGpColor(kcBlack), bool clamp = false)
    {
		CheckStatus(GdipSetImageAttributesWrapMode(Native, (WrapMode)(int)wrap, color.Argb, clamp));
    }
    // ����ָ�����ĵ������ã�������ɫ���е���ɫ��
    // ColorPalette��������ʱ����Ҫ�����ĵ�ɫ�壬�����ʱ�����ѵ����ĵ�ɫ��
    // TColorAdjustType ö�ٵ�Ԫ�أ���ָ����������ý�Ӧ���ڵ�ɫ������
	void __fastcall GetAdjustedPalette(TColorPalette* colorPalette, TColorAdjustType colorAdjustType)
    {
		CheckStatus(GdipGetImageAttributesAdjustedPalette(Native, colorPalette, (ColorAdjustType)(int)colorAdjustType));
	}

};

#endif
