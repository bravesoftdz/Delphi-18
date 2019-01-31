/**************************************************************************\
*
* Module Name:
*
*   GdipMatrix.hpp
*
* 2007�꣬����ʡ������ͳ�ƾ� ë�� �ڴ���
*
\**************************************************************************/

#ifndef GdipMatrixHPP
#define GdipMatrixHPP

//--------------------------------------------------------------------------
// ��װ��ʾ���α��ε� 3 x 2 �������
// ��ע: 3 x 2 �����ڵ�һ�а��� x ֵ���ڵڶ��а��� y ֵ���ڵ����а��� w ֵ��
//--------------------------------------------------------------------------

enum TMatrixOrder
{
	moPrepend,		// �ھɲ���ǰӦ���²�����
	moAppend		// �ھɲ�����Ӧ���²�����
};

#pragma pack(push,1)
union TMatrixElements
{
    float Elements[6];
    struct
    {
    	float m11;
	    float m12;
    	float m21;
	    float m22;
    	float dx;
	    float dy;
    };
} ;
#pragma pack(pop)

typedef TMatrixElements *PMatrixElements;

class TGpMatrix : public TGdiplusBase
{
private:
	friend	class TGpRegion;
    friend  class TGpPen;
    friend  class TGpTextureBrush;
	friend  class TGpLinearGradientBrush;
	friend	class TGpPathGradientBrush;
    friend  class TGpGraphicsPath;
	friend	class TGpGraphics;
	
	TMatrixElements __fastcall GetElements()
    {
	    TMatrixElements e;
	    CheckStatus(GdipGetMatrixElements(Native, e.Elements));
	    return e;
    }
	void __fastcall SetElements(const TMatrixElements &Value)
    {
    	CheckStatus(GdipSetMatrixElements(Native, Value.m11, Value.m12, Value.m21,
									Value.m22, Value.dx, Value.dy));
    }
	float __fastcall GetOffsetX(void)
	{
		return Elements.dx;
    }
	float __fastcall GetOffsetY(void)
	{
		return Elements.dy;
    }

protected:
	__fastcall TGpMatrix(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpMatrix));
	}
#endif
public:
	// �� Matrix ���һ����ʵ����ʼ��Ϊ��λ����. Elements = 1,0,0,1,0,0
	__fastcall TGpMatrix(void)
	{
		CheckStatus(GdipCreateMatrix(&Native));
	}
	// ʹ��ָ����Ԫ�س�ʼ�� Matrix �����ʵ����
	__fastcall TGpMatrix(float m11, float m12, float m21, float m22, float dx, float dy)
	{
		CheckStatus(GdipCreateMatrix2(m11, m12, m21, m22, dx, dy, &Native));
	}
	// �� Matrix ���һ����ʵ����ʼ��Ϊָ�����κ͵����鶨��ļ��α��Ρ�dstplg ������ Point �ṹ���ɵ�����
	__fastcall TGpMatrix(const TGpRectF &rect, PGpPointF dstplg)
	{
		CheckStatus(GdipCreateMatrix3(&rect, dstplg, &Native));
	}
	__fastcall TGpMatrix(const TGpRect &rect, PGpPoint dstplg)
	{
		CheckStatus(GdipCreateMatrix3I(&rect, dstplg, &Native));
	}
	__fastcall virtual ~TGpMatrix(void)
	{
		GdipDeleteMatrix(Native);
    }
	TGpMatrix* __fastcall Clone(void)
	{
		return new TGpMatrix(Native, (TCloneAPI)GdipCloneMatrix);
	}
	// ���ô� Matrix �����Ծ��е�λ�����Ԫ�ء�
	void __fastcall Reset(void)
	{
		CheckStatus(GdipSetMatrixElements(Native, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0));
	}
	// ��ָ����˳�򽫴� Matrix �������� matrix ������ָ���ľ�����ˡ�
	void __fastcall Multiply(const TGpMatrix* matrix, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipMultiplyMatrix(Native, matrix->Native, (MatrixOrder)(int)order));
	}
	// ͨ��Ԥ�ȼ���ת��������ָ����ת������Ӧ�õ��� Matrix ����
	void __fastcall Translate(float offsetX, float offsetY, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipTranslateMatrix(Native, offsetX, offsetY, (MatrixOrder)(int)order));
	}
	// ʹ��ָ����˳��ָ��������������scaleX �� scaleY��Ӧ�õ��� Matrix ����
	void __fastcall Scale(float scaleX, float scaleY, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipScaleMatrix(Native, scaleX, scaleY, (MatrixOrder)(int)order));
	}
	// Ӧ�� angle ������ָ����˳ʱ����ת����Ϊ�� Matrix ������ԭ�㣨X,Y ���꣩��ת��
	void __fastcall Rotate(float angle, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipRotateMatrix(Native, angle, (MatrixOrder)(int)order));
	}
	// ͨ��Ԥ�ȼ�����ת������ָ�����˳ʱ����תӦ�õ��� Matrix ����
	void __fastcall RotateAt(float angle, const TGpPointF &center, TMatrixOrder order = moPrepend)
    {
    	if (order == moPrepend)
    	{
    		CheckStatus(GdipTranslateMatrix(Native, center.X, center.Y, (MatrixOrder)(int)order));
    		CheckStatus(GdipRotateMatrix(Native, angle, (MatrixOrder)(int)order));
    		CheckStatus(GdipTranslateMatrix(Native, -center.X, -center.Y, (MatrixOrder)(int)order));
    	}
    	else
    	{
    		CheckStatus(GdipTranslateMatrix(Native, -center.X, - center.Y, (MatrixOrder)(int)order));
    		CheckStatus(GdipRotateMatrix(Native, angle, (MatrixOrder)(int)order));
    		CheckStatus(GdipTranslateMatrix(Native, center.X, center.Y, (MatrixOrder)(int)order));
       }
	}
	// ��ָ����˳��ָ�����б�����Ӧ�õ��� Matrix ����
	void __fastcall Shear(float shearX, float shearY, TMatrixOrder order = moPrepend)
	{
		CheckStatus(GdipShearMatrix(Native, shearX, shearY, (MatrixOrder)(int)order));
	}
	// ����� Matrix �����ǿ���ת�ģ�����ת�ö���
	void __fastcall Invert(void)
	{
		CheckStatus(GdipInvertMatrix(Native));
	}
	// ��ָ���ĵ�����Ӧ�ô� Matrix ��������ʾ�ļ��α��Ρ�
	void __fastcall TransformPoints(TGpPointF *pts, const int pts_Size)
	{
		CheckStatus(GdipTransformMatrixPoints(Native, pts, pts_Size));
    }
	void __fastcall TransformPoints(TGpPoint *pts, const int pts_Size)
	{
		CheckStatus(GdipTransformMatrixPointsI(Native, pts, pts_Size));
	}
	// ֻ���� Matrix �������������ת�ɷ�Ӧ�õ�ָ���ĵ����顣
	void __fastcall TransformVectors(TGpPointF *pts, const int pts_Size)
	{
		CheckStatus(GdipVectorTransformMatrixPoints(Native, pts, pts_Size));
    }
	void __fastcall TransformVectors(TGpPoint *pts, const int pts_Size)
	{
		CheckStatus(GdipVectorTransformMatrixPointsI(Native, pts, pts_Size));
	}
	// ��ȡһ��ֵ����ֵָʾ�� Matrix �����Ƿ��ǿ���ת�ġ�
	bool __fastcall IsInvertible(void)
	{
		CheckStatus(GdipIsMatrixInvertible(Native, &Result.rBOOL));
		return Result.rBOOL;
	}
	// ��ȡһ��ֵ����ֵָʾ�� Matrix �����Ƿ��ǵ�λ����
	bool __fastcall IsIdentity(void)
	{
		CheckStatus(GdipIsMatrixIdentity(Native, &Result.rBOOL));
		return Result.rBOOL;
	}
#if (__BORLANDC__ >= 0x610)
    HIDESBASE bool __fastcall Equals(const TGpMatrix* matrix)
#else
	bool __fastcall Equals(const TGpMatrix* matrix)
#endif
	{
		CheckStatus(GdipIsMatrixEqual(Native, matrix->Native, &Result.rBOOL));
		return Result.rBOOL;
	}
	// ��ȡ�����ø� Matrix �����Ԫ�ء�
	__property TMatrixElements Elements = {read=GetElements, write=SetElements};
	// ��ȡ�� Matrix ����� x ת��ֵ��dx ֵ��������С���һ���е�Ԫ�أ���
	__property float OffsetX = {read=GetOffsetX};
	// ��ȡ�� Matrix �� y ת��ֵ��dy ֵ��������С��ڶ����е�Ԫ�أ���
	__property float OffsetY = {read=GetOffsetY};

};

#endif
