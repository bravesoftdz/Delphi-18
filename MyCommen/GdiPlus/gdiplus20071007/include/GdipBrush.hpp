/**************************************************************************\
*
* Module Name:
*
*   GdipBrush.hpp
*
* 2007�꣬����ʡ������ͳ�ƾ� ë�� �ڴ���
*
\**************************************************************************/

#ifndef GdipBrushHPP
#define GdipBrushHPP

//--------------------------------------------------------------------------
// Brush types
//--------------------------------------------------------------------------

enum TBrushType { btSolidColor, btHatchFill, btTextureFill, btPathGradient, btLinearGradient };

//--------------------------------------------------------------------------
// Abstract base class for various brush types
//--------------------------------------------------------------------------

class TGpBrush : public TGdiplusBase
{
private:
    friend class TGpPen;
	friend class TGpGraphics;
	friend class TGpBrushs;

private:
	TBrushType __fastcall GetType(void)
    {
        CheckStatus(GdipGetBrushType(Native, (GdiplusSys::BrushType*)&Result.rUINT));
		return (TBrushType)Result.rUINT;
    }

protected:
	__fastcall TGpBrush(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpBrush));
	}
#endif
	__fastcall TGpBrush(void) { }

public:
	__fastcall virtual ~TGpBrush(void)
    {
        GdipDeleteBrush(Native);
    }
	virtual TGpBrush* __fastcall Clone(void)
    {
        return new TGpBrush(Native, (TCloneAPI)GdipCloneBrush);
	}
	// ����Brush����
	__property TBrushType BrushType = {read=GetType, nodefault};

};

//--------------------------------------------------------------------------
// Solid Fill Brush Object
//--------------------------------------------------------------------------

class TGpSolidBrush : public TGpBrush
{
private:
    friend  class TGpPen;

	TGpColor __fastcall GetColor(void)
    {
        CheckStatus(GdipGetSolidFillColor(Native, &Result.rARGB));
        return TGpColor(Result.rARGB);
    }
	void __fastcall SetColor(const TGpColor color)
    {
        CheckStatus(GdipSetSolidFillColor(Native, color.Argb));
    }

protected:
	__fastcall TGpSolidBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpSolidBrush));
	}
#endif
public:
	// ��ʼ��ָ����ɫ���� SolidBrush ����
	__fastcall TGpSolidBrush(TGpColor color)
    {
        CheckStatus(GdipCreateSolidFill(color.Argb, &Native));
    }
	virtual TGpSolidBrush* __fastcall Clone(void)
    {
        return new TGpSolidBrush(Native, (TCloneAPI)GdipCloneBrush);
	}
	// ��ȡ�����ô� SolidBrush �������ɫ��
	__property TGpColor Color = {read=GetColor, write=SetColor};

};

//--------------------------------------------------------------------------
// Texture Brush Fill Object
//--------------------------------------------------------------------------

class TGpTextureBrush : public TGpBrush
{
private:
    friend  class TGpPen;

	void __fastcall SetWrapMode(TWrapMode wrapMode)
    {
        CheckStatus(GdipSetTextureWrapMode(Native, (GdiplusSys::WrapMode)(int)wrapMode));
    }
	TWrapMode __fastcall GetWrapMode(void)
    {
        CheckStatus(GdipGetTextureWrapMode(Native, (GdiplusSys::WrapMode*)&Result.rINT));
        return (TWrapMode)Result.rINT;
    }
	TGpImage* __fastcall GetImage(void)
    {
        CheckStatus(GdipGetTextureImage(Native, &Result.rNATIVE));
        return new TGpImage(Result.rNATIVE, NULL);
    }

protected:
	__fastcall TGpTextureBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpTextureBrush));
	}
#endif
public:
	// ��ʼ��ʹ��ָ����ͼ����Զ�����ģʽ���� TextureBrush ����
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode = wmTile)
    {
        CheckStatus(GdipCreateTexture(image->Native, (GdiplusSys::WrapMode)(int)wrapMode, &Native));
	}
	// ��ʼ��ʹ��ָ��ͼ���Զ�����ģʽ�ͳߴ罨���� TextureBrush ����
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode, const TGpRectF &dstRect)
    {
        TGpTextureBrush(image, wrapMode, dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height);
    }
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode, const TGpRect &dstRect)
    {
        TGpTextureBrush(image, wrapMode, dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height);
    }
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode,
        float dstX, float dstY, float dstWidth, float dstHeight)
    {
        CheckStatus(GdipCreateTexture2(image->Native,
            (GdiplusSys::WrapMode)(int)wrapMode, dstX, dstY, dstWidth, dstHeight, &Native));
    }
	__fastcall TGpTextureBrush(TGpImage* image, TWrapMode wrapMode,
        int dstX, int dstY, int dstWidth, int dstHeight)
    {
        CheckStatus(GdipCreateTexture2I(image->Native,
            (GdiplusSys::WrapMode)(int)wrapMode, dstX, dstY, dstWidth, dstHeight, &Native));
	}
	// ��ʼ��ʹ��ָ����ͼ�񡢾��γߴ��ͼ�����Ե��� TextureBrush ����
	__fastcall TGpTextureBrush(TGpImage* image, const TGpRectF &dstRect,
        TGpImageAttributes* imageAttributes = NULL)
    {
        CheckStatus(GdipCreateTextureIA(image->Native, ObjectNative(imageAttributes),
                  dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height, &Native));
    }
	__fastcall TGpTextureBrush(TGpImage* image, const TGpRect &dstRect,
        TGpImageAttributes* imageAttributes = NULL)
    {
        CheckStatus(GdipCreateTextureIAI(image->Native, ObjectNative(imageAttributes),
                  dstRect.X, dstRect.Y, dstRect.Width, dstRect.Height, &Native));
	}
	virtual TGpTextureBrush* __fastcall Clone(void)
    {
        return new TGpTextureBrush(Native, (TCloneAPI)GdipCloneBrush);
	}
	// ���� TextureBrush ����� Transform ��������Ϊ��λ����
	void __fastcall ResetTransform(void)
    {
        CheckStatus(GdipResetTextureTransform(Native));
	}
	// ��ָ��˳�򽫱�ʾ TextureBrush ����ľֲ����α任�� Matrix �������ָ���� Matrix ����
	void __fastcall MultiplyTransform(TGpMatrix* matrix, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipMultiplyTextureTransform(Native, matrix->Native, (GdiplusSys::MatrixOrder)(int)order));
	}
	// ��ָ��˳�򽫴� TextureBrush ����ľֲ����α任ƽ��ָ���ĳߴ硣
	void __fastcall TranslateTransform(float dx, float dy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipTranslateTextureTransform(Native, dx, dy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// ��ָ��˳�򽫴� TextureBrush ����ľֲ����α任����ָ��������
	void __fastcall ScaleTransform(float sx, float sy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipScaleTextureTransform(Native, sx, sy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// ���� TextureBrush ����ľֲ����α任��תָ���ĽǶȡ�
	void __fastcall RotateTransform(float angle, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipRotateTextureTransform(Native, angle, (GdiplusSys::MatrixOrder)(int)order));
	}
	// ��ȡ������ Matrix ������Ϊ��� TextureBrush ���������ͼ����ֲ����α任��
	void __fastcall GetTransform(TGpMatrix *matrix)
    {
        CheckStatus(GdipGetTextureTransform(Native, matrix->Native));
    }
	void __fastcall SetTransform(const TGpMatrix* matrix)
    {
        CheckStatus(GdipSetTextureTransform(Native, matrix->Native));
    }
	// ��ȡ��� TextureBrush ��������� Image ���󡣱���Free
	__property TGpImage* Image = {read=GetImage};
	// ��ȡ������ WrapMode ö�٣���ָʾ�� TextureBrush ����Ļ���ģʽ
	__property TWrapMode WrapMode = {read=GetWrapMode, write=SetWrapMode, nodefault};

};

//--------------------------------------------------------------------------
// �����װ˫ɫ������Զ����ɫ���䡣
// ���н��䶼�����ɾ��εĿ�Ȼ�������ָ����ֱ�߶���ġ�
// Ĭ������£�˫ɫ��������ָ��ֱ�ߴ���ʼɫ������ɫ�ľ���ˮƽ���Ի�ϡ�
// ʹ�� Blend �ࡢSetSigmaBellShape ������ SetBlendTriangularShape ����
// �Զ�����ͼ����ͨ���ڹ��캯����ָ�� LinearGradientMode ö�ٻ�Ƕ��Զ��彥��ķ���
// ʹ�� InterpolationColors ���Դ�����ɫ���䡣
// Transform ����ָ��Ӧ�õ�����ľֲ����α��Ρ�
//--------------------------------------------------------------------------

enum TLinearGradientMode
{
    lmHorizontal,         // ָ�������ҵĽ��䡣
    lmVertical,           // ָ�����ϵ��µĽ��䡣
    lmForwardDiagonal,    // ָ�������ϵ����µĽ��䡣
    lmBackwardDiagonal    // ָ�������ϵ����µĽ��䡣
};

class TGpLinearGradientBrush : public TGpBrush
{
private:
    friend  class TGpPen;
	TWrapMode __fastcall GetWrapMode(void)
    {
        CheckStatus(GdipGetLineWrapMode(Native, (GdiplusSys::WrapMode*)&Result.rINT));
        return (TWrapMode)Result.rINT;
    }
	void __fastcall SetWrapMode(TWrapMode wrapMode)
    {
        CheckStatus(GdipSetLineWrapMode(Native, (GdiplusSys::WrapMode)(int)wrapMode));
    }
	void __fastcall SetGammaCorrection(bool useGammaCorrection)
    {
        CheckStatus(GdipSetLineGammaCorrection(Native, useGammaCorrection));
    }
	bool __fastcall GetGammaCorrection(void)
    {
        CheckStatus(GdipGetLineGammaCorrection(Native, &Result.rBOOL));
        return Result.rBOOL;
    }
	int __fastcall GetBlendCount(void)
    {
        CheckStatus(GdipGetLineBlendCount(Native, &Result.rINT));
        return Result.rINT;
    }
	int __fastcall GetInterpolationColorCount(void)
    {
        CheckStatus(GdipGetLinePresetBlendCount(Native, &Result.rINT));
        return Result.rINT;
    }
	TGpRectF __fastcall GetRectangleF()
    {
        TGpRectF r;
        CheckStatus(GdipGetLineRect(Native, &r));
        return r;
    }
	TGpRect __fastcall GetRectangle()
    {
        TGpRect r;
        CheckStatus(GdipGetLineRectI(Native, &r));
        return r;
    }

protected:
	__fastcall TGpLinearGradientBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpLinearGradientBrush));
	}
#endif
public:
	// ʹ��ָ���ĵ����ɫ��ʼ�� LinearGradientBrush �����ʵ����
	__fastcall TGpLinearGradientBrush(const TGpPointF &point1,
        const TGpPointF &point2, TGpColor color1, TGpColor color2)
    {
        CheckStatus(GdipCreateLineBrush(&point1, &point2,
            color1.Argb, color2.Argb, WrapModeTile, &Native));
    }
	__fastcall TGpLinearGradientBrush(const TGpPoint &point1,
        const TGpPoint &point2, TGpColor color1, TGpColor color2)
    {
        CheckStatus(GdipCreateLineBrushI(&point1, &point2,
            color1.Argb, color2.Argb, WrapModeTile, &Native));
	}
	// ����һ�����Ρ���ʼ��ɫ�ͽ�����ɫ�Լ����򣬴��� LinearGradientBrush �����ʵ����
	__fastcall TGpLinearGradientBrush(const TGpRectF &rect, TGpColor color1,
        TGpColor color2, TLinearGradientMode mode = lmHorizontal)
    {
        CheckStatus(GdipCreateLineBrushFromRect(&rect, color1.Argb, color2.Argb,
                (LinearGradientMode)(int)mode, WrapModeTile, &Native));
    }
	__fastcall TGpLinearGradientBrush(const TGpRect &rect,
        TGpColor color1, TGpColor color2, TLinearGradientMode mode = lmHorizontal)
    {
        CheckStatus(GdipCreateLineBrushFromRectI(&rect, color1.Argb, color2.Argb,
                (LinearGradientMode)(int)mode, WrapModeTile, &Native));
	}
	// ���ݾ��Ρ���ʼ��ɫ�ͽ�����ɫ�Լ�����Ƕȣ����� LinearGradientBrush �����ʵ����
	// isAngleScalable:ָ���Ƕ��Ƿ��� LinearGradientBrush �����ı�����Ӱ��
	__fastcall TGpLinearGradientBrush(const TGpRectF &rect,
        TGpColor color1, TGpColor color2, float angle, bool isAngleScalable = false)
    {
        CheckStatus(GdipCreateLineBrushFromRectWithAngle(&rect, color1.Argb,
                color2.Argb, angle, isAngleScalable, WrapModeTile, &Native));
    }
	__fastcall TGpLinearGradientBrush(const TGpRect &rect,
        TGpColor color1, TGpColor color2, float angle, bool isAngleScalable = false)
    {
        CheckStatus(GdipCreateLineBrushFromRectWithAngleI(&rect, color1.Argb,
                color2.Argb, angle, isAngleScalable, WrapModeTile, &Native));
	}
	virtual TGpLinearGradientBrush* __fastcall Clone(void)
    {
        return new TGpLinearGradientBrush(Native, (TCloneAPI)GdipCloneBrush);
	}
	// ��ȡ�����ý������ʼɫ�ͽ���ɫ��
	void __fastcall GetLinearColors(TGpColor &color1, TGpColor &color2)
    {
        DWORDLONG colors;
        CheckStatus(GdipGetLineColors(Native, (ARGB*)&colors));
        color1 = TGpColor((ARGB)colors);
        color2 = TGpColor((ARGB)(colors >> 32));
    }
	void __fastcall SetLinearColors(TGpColor color1, TGpColor color2)
    {
        CheckStatus(GdipSetLineColors(Native, color1.Argb, color2.Argb));
	}
	// ��ȡ������ Blend����ָ��Ϊ���䶨���Զ�����ɵ�λ�ú����ӡ�
	// blendFactors�����ڽ���Ļ���������顣blendPositions������Ļ��λ�õ����顣
	void __fastcall SetBlend(const float *blendFactors, const float * blendPositions, const int count)
    {
        CheckStatus(GdipSetLineBlend(Native, blendFactors, blendPositions, count));
    }
	void __fastcall GetBlend(float *blendFactors, float * blendPositions)
    {
        CheckStatus(GdipGetLineBlend(Native, blendFactors, blendPositions, BlendCount));
	}
	// ��ȡ������һ�������ɫ���Խ���� ColorBlend��
	// presetColors:�ؽ������Ӧλ�ô�ʹ�õ���ɫ����ɫ���顣blendPositions:�ؽ����ߵ�λ�á�
	void __fastcall SetInterpolationColors(
        const TGpColor *presetColors, const float *blendPositions, const int count)
    {
        CheckStatus(GdipSetLinePresetBlend(Native, (ARGB*)presetColors, blendPositions, count));
    }
	void __fastcall GetInterpolationColors(TGpColor *presetColors, float *blendPositions)
    {
        CheckStatus(GdipGetLinePresetBlend(Native,
            (ARGB*)presetColors, blendPositions, InterpolationColorCount));
	}
	// ���������������ߵĽ�����ɹ��̡�
	void __fastcall SetBlendBellShape(float focus, float scale = 1.0)
    {
        CheckStatus(GdipSetLineSigmaBlend(Native, focus, scale));
	}
	// ����һ��������ɫ�����˵�����ɫ���Թ��ɵ����Խ�����̡�
	void __fastcall SetBlendTriangularShape(float focus, float scale = 1.0)
    {
        CheckStatus(GdipSetLineLinearBlend(Native, focus, scale));
	}
	// ��ȡ������һ�� Matrix ���󣬸ö���Ϊ�� LinearGradientBrush ������ֲ����α��Ρ�
	void __fastcall SetTransform(const TGpMatrix* matrix)
    {
        CheckStatus(GdipSetLineTransform(Native, matrix->Native));
    }
	void __fastcall GetTransform(TGpMatrix* matrix)
    {
        CheckStatus(GdipGetLineTransform(Native, matrix->Native));
	}
	// �� Transform ��������Ϊ��ͬ��
	void __fastcall ResetTransform(void)
    {
        CheckStatus(GdipResetLineTransform(Native));
	}
	// ͨ��ָ���� Matrix����LinearGradientBrush �ľֲ����α��ε� Matrix �������ָ���� Matrix ��ˡ�
	void __fastcall MultiplyTransform(const TGpMatrix* matrix, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipMultiplyLineTransform(Native, matrix->Native, (GdiplusSys::MatrixOrder)(int)order));
	}
	// ���ֲ����α���ת��ָ���ĳߴ硣�÷�����Ԥ�ȼ���Ա��ε�ת����
	void __fastcall TranslateTransform(float dx, float dy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipTranslateLineTransform(Native, dx, dy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// ���ֲ����α�������ָ���������÷���Ԥ�ȼ���Ա��ε����ž���
	void __fastcall ScaleTransform(float sx, float sy, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipScaleLineTransform(Native, sx, sy, (GdiplusSys::MatrixOrder)(int)order));
	}
	// ���ֲ����α�����תָ����С���÷���Ԥ�ȼ���Ա��ε���ת��
	void __fastcall RotateTransform(float angle, TMatrixOrder order = moPrepend)
    {
        CheckStatus(GdipRotateLineTransform(Native, angle, (GdiplusSys::MatrixOrder)(int)order));
    }
	// ��ȡ���彥�����ʼ����ս��ľ�������
	__property TGpRectF RectangleF = {read=GetRectangleF};
	__property TGpRect Rectangle = {read=GetRectangle};
	// ��ȡ������ WrapMode ö�٣���ָʾ�� LinearGradientBrush �Ļ���ģʽ
	__property TWrapMode WrapMode = {read=GetWrapMode, write=SetWrapMode, nodefault};
	// ��ȡ������һ��ֵ����ֵָʾ�Ƿ�Ϊ�� LinearGradientBrush ��������٤��������
	__property bool GammaCorrection = {read=GetGammaCorrection, write=SetGammaCorrection, nodefault};
	__property int BlendCount = {read=GetBlendCount, nodefault};
	__property int InterpolationColorCount = {read=GetInterpolationColorCount, nodefault};

};

//--------------------------------------------------------------------------
// Hatch Brush Object ����Ӱ��ʽ��ǰ��ɫ�ͱ���ɫ������λ��ʡ�
//--------------------------------------------------------------------------

enum THatchStyle
{
    hsHorizontal, hsVertical, hsForwardDiagonal, hsBackwardDiagonal,
    hsCross, hsDiagonalCross, hs05Percent, hs10Percent, hs20Percent, hs25Percent,
    hs30Percent, hs40Percent, hs50Percent, hs60Percent, hs70Percent, hs75Percent,
    hs80Percent, hs90Percent, hsLightDownwardDiagonal, hsLightUpwardDiagonal,
    hsDarkDownwardDiagonal, hsDarkUpwardDiagonal, hsWideDownwardDiagonal,
    hsWideUpwardDiagonal, hsLightVertical, hsLightHorizontal, hsNarrowVertical,
    hsNarrowHorizontal, hsDarkVertical, hsDarkHorizontal, hsDashedDownwardDiagonal,
    hsDashedUpwardDiagonal, hsDashedHorizontal, hsDashedVertical, hsSmallConfetti,
    hsLargeConfetti, hsZigZag, hsWave, hsDiagonalBrick, hsHorizontalBrick,
    hsWeave, hsPlaid, hsDivot, hsDottedGrid, hsDottedDiamond, hsShingle,
    hsTrellis, hsSphere, hsSmallGrid, hsSmallCheckerBoard, hsLargeCheckerBoard,
    hsOutlinedDiamond, hsSolidDiamond
};

class TGpHatchBrush : public TGpBrush
{
private:
    friend  class TGpPen;

	TGpColor __fastcall GetBackgroundColor(void)
    {
        CheckStatus(GdipGetHatchBackgroundColor(Native, &Result.rARGB));
        return TGpColor(Result.rARGB);
    }
	TGpColor __fastcall GetForegroundColor(void)
    {
        CheckStatus(GdipGetHatchForegroundColor(Native, &Result.rARGB));
        return TGpColor(Result.rARGB);
    }
	THatchStyle __fastcall GetHatchStyle(void)
    {
        CheckStatus(GdipGetHatchStyle(Native, (GdiplusSys::HatchStyle*)&Result.rINT));
        return (THatchStyle)Result.rINT;
    }

protected:
	__fastcall TGpHatchBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpHatchBrush));
	}
#endif
public:
	// ʹ��ָ���� HatchStyle ö�١�ǰ��ɫ�ͱ���ɫ��ʼ�� HatchBrush �����ʵ����
	__fastcall TGpHatchBrush(THatchStyle hatchStyle, TGpColor foreColor, TGpColor backColor = TGpColor())
    {
		CheckStatus(GdipCreateHatchBrush((GdiplusSys::HatchStyle)(int)hatchStyle,
                foreColor.Argb, backColor.Argb, &Native));
	}
	virtual TGpHatchBrush* __fastcall Clone(void)
    {
        return new TGpHatchBrush(Native, (TCloneAPI)GdipCloneBrush);
    }
	// ��ȡ�� HatchBrush ������Ƶ���Ӱ��������ɫ��
	__property TGpColor ForegroundColor = {read=GetForegroundColor};
	// ��ȡ�� HatchBrush ������Ƶ���Ӱ������ռ����ɫ
	__property TGpColor BackgroundColor = {read=GetBackgroundColor};
	// ��ȡ�� HatchBrush �������Ӱ��ʽ��
	__property THatchStyle HatchStyle = {read=GetHatchStyle, nodefault};

};

//--------------------------------------------------------------------------
// Path Gradient Brush ͨ��������� GraphicsPath ������ڲ�
// ����ֻ���ඨ�壬ʵ�ִ�����GdipPath.h
//--------------------------------------------------------------------------

class TGpPathGradientBrush : public TGpBrush
{
private:
    friend  class TGpPen;

	TGpColor __fastcall GetCenterColor(void);
	void __fastcall SetCenterColor(const TGpColor color);
	int __fastcall GetPointCount(void);
	int __fastcall GetSurroundColorCount(void);
	void __fastcall SetGammaCorrection(bool useGammaCorrection);
	bool __fastcall GetGammaCorrection(void);
	int __fastcall GetBlendCount(void);
	TWrapMode __fastcall GetWrapMode(void);
	void __fastcall SetWrapMode(TWrapMode wrapMode);
	TGpPointF __fastcall GetCenterPoint();
	TGpPoint __fastcall GetCenterPointI();
	TGpRectF __fastcall GetRectangle();
	TGpRect __fastcall GetRectangleI();
	void __fastcall SetCenterPoint(const TGpPointF &Value);
	void __fastcall SetCenterPointI(const TGpPoint &Value);
	TGpPointF __fastcall GetFocusScales();
	void __fastcall SetFocusScales(const TGpPointF &Value);
	int __fastcall GetInterpolationColorCount(void);

protected:
	__fastcall TGpPathGradientBrush(GpNative *native, TCloneAPI cloneFun) : TGpBrush(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpPathGradientBrush));
	}
#endif
public:
	// ʹ��ָ���ĵ�ͻ���ģʽ��ʼ�� PathGradientBrush �����ʵ����
	__fastcall TGpPathGradientBrush(const TGpPointF *points, const int points_Size, TWrapMode wrapMode = wmClamp);
	__fastcall TGpPathGradientBrush(const TGpPoint *points, const int points_Size, TWrapMode wrapMode = wmClamp);
	// ʹ��ָ����·����ʼ�� PathGradientBrush �����ʵ����
	__fastcall TGpPathGradientBrush(TGpGraphicsPath* path);
	virtual TGpPathGradientBrush* __fastcall Clone(void);
	// ��ȡ��������� PathGradientBrush ��������·���еĵ����Ӧ����ɫ�����顣
	// ����ʵ�ʻ�ȡ�����õ�����Ԫ�ظ���
	int __fastcall GetSurroundColors(TGpColor *colors);
	int __fastcall SetSurroundColors(const TGpColor *colors, const int colors_Size);
	// ��ȡ������ Blend����ָ��Ϊ���䶨���Զ�����ɵ�λ�ú����ӡ�
	int __fastcall GetBlend(float *blendFactors, float *blendPositions);
	void __fastcall SetBlend(const float *blendFactors, const float * blendPositions, const int count);
	// ��ȡ������һ�������ɫ���Խ���� ColorBlend ����
	void __fastcall SetInterpolationColors(
		const TGpColor *presetColors, const float *blendPositions, const int count);
	int __fastcall GetInterpolationColors(TGpColor *presetColors, float *blendPositions);
	// ���������������ߵĽ�����ɹ��̡�
	void __fastcall SetBlendBellShape(float focus, float scale = 1.0);
	// ����һ��������ɫ����Χɫ���Թ��ɵĽ�����̡�
    // focus: ���� 0 �� 1 ֮���һ��ֵ����ָ����·�����ĵ�·���߽������뾶��������ɫ������ߵ�λ�á�
	// scale: ���� 0 �� 1 ֮���һ��ֵ����ָ����߽�ɫ��ϵ�����ɫ��������ȡ�
	void __fastcall SetBlendTriangularShape(float focus, float scale = 1.0);
	// ��ȡ������һ�� Matrix ���󣬸ö���Ϊ�� PathGradientBrush ������ֲ����α��Ρ�
	void __fastcall GetTransform(TGpMatrix* matrix);
	void __fastcall SetTransform(const TGpMatrix* matrix);
	// �� Transform ��������Ϊ��ͬ��
	void __fastcall ResetTransform(void);
	// ͨ��ָ���� Matrix����PathGradientBrush�ľֲ����α��ε� Matrix �������ָ���� Matrix ��ˡ�
	void __fastcall MultiplyTransform(const TGpMatrix* matrix, TMatrixOrder order = moPrepend);
	// ��ָ����˳����ֲ����α���Ӧ��ָ����ת����
	void __fastcall TranslateTransform(float dx, float dy, TMatrixOrder order = moPrepend);
	// ���ֲ����α�����ָ��˳������ָ��������
	void __fastcall ScaleTransform(float sx, float sy, TMatrixOrder order = moPrepend);
	// ��ָ��˳�򽫾ֲ����α�����תָ������
	void __fastcall RotateTransform(float angle, TMatrixOrder order = moPrepend);
	void __fastcall GetGraphicsPath(TGpGraphicsPath* path);
	void __fastcall SetGraphicsPath(const TGpGraphicsPath* path);
	// ��ȡ�� PathGradientBrush ����ı߿�
	__property TGpRectF Rectangle = {read=GetRectangle};
	__property TGpRect RectangleI = {read=GetRectangleI};
	// ��ȡ������һ�� WrapMode ö�٣���ָʾ�� PathGradientBrush ����Ļ���ģʽ��
	__property TWrapMode WrapMode = {read=GetWrapMode, write=SetWrapMode, nodefault};
	__property bool GammaCorrection = {read=GetGammaCorrection, write=SetGammaCorrection, nodefault};
	__property int BlendCount = {read=GetBlendCount, nodefault};
	__property int PointCount = {read=GetPointCount, nodefault};
	__property int SurroundColorCount = {read=GetSurroundColorCount, nodefault};
	// ��ȡ������·����������Ĵ�����ɫ��
	__property TGpColor CenterColor = {read=GetCenterColor, write=SetCenterColor};
	// ��ȡ������·����������ĵ㡣
	__property TGpPointF CenterPoint = {read=GetCenterPoint, write=SetCenterPoint};
	__property TGpPoint CenterPointI = {read=GetCenterPointI, write=SetCenterPointI};
	// ��ȡ�����ý�����ɵĽ��㡣
	__property TGpPointF FocusScales = {read=GetFocusScales, write=SetFocusScales};
	__property int InterpolationColorCount = {read=GetInterpolationColorCount, nodefault};

};


#endif
