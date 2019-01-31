/**************************************************************************\
*
* Module Name:
*
*   GdipStringFormat.hpp
*
* 2007�꣬����ʡ������ͳ�ƾ� ë�� �ڴ���
*
\**************************************************************************/

#ifndef GdipStringFormatHPP
#define GdipStringFormatHPP

//---------------------------------------------------------------------------
// National language digit substitution
//---------------------------------------------------------------------------

enum TStringDigitSubstitute
{
    ssUser,             // ָ���û�������滻������
    ssNone,             // ָ�������滻��
    ssNational,         // ָ�����û��������õ���ʽ����/�����������Ӧ���滻����λ��
    ssTraditional       // ָ�����û��ı����ű����������Ӧ���滻����λ
};

//---------------------------------------------------------------------------
// Hotkey prefix interpretation
//---------------------------------------------------------------------------

enum THotkeyPrefix { hpNone, hpShow, hpHide };

//---------------------------------------------------------------------------
// String alignment flags ���Ҳ��֣�Զ��λ�����ҡ��ҵ��󲼾֣�Զ��λ������
//---------------------------------------------------------------------------

enum TStringAlignment
{
    saNear,     // �ı����˶���
    saCenter,   // �ı����ж���
    saFar       // �ı�Զ�˶���
};

//---------------------------------------------------------------------------
// StringFormatFlags
//---------------------------------------------------------------------------

enum TStringFormatFlag
{
    sfDirectionRightToLeft,     // �ı����ҵ�������
    sfDirectionVertical,        // �ı���ֱ����
    sfNoFitBlackBox,            // �κα�־���ŵ��κβ��ֶ���ͻ���߿�
    sfDisplayFormatControl = 5, // �����ַ�����д����Եı�־����һ����ʾ�������
    sfNoFontFallback = 10,      // ȱʧ���ַ�����ȱʧ��־���ŵ�������ʾ
       // ��Ĭ������£�MeasureString �������صı߿򶼽��ų�ÿһ�н�β���Ŀո�
    // ���ô˱���Ա��ڲⶨʱ���ո������ȥ��
    sfMeasureTrailingSpaces,
    sfNoWrap,                   // �ھ����н��и�ʽ��ʱ�����ı�����
    sfLineLimit,                // ȷ�������Ķ�������
    sfNoClip                    // ������ʾ��־���ŵ�������ֺ����쵽�߿����δ�����ı�
};

typedef Set<TStringFormatFlag, sfDirectionRightToLeft, sfNoClip>  TStringFormatFlags;

//---------------------------------------------------------------------------
// StringTrimming
//---------------------------------------------------------------------------

enum TStringTrimming
{
    stNone,             // �������κ�����
    stCharacter,        // ���ı���������ӽ����ַ�
    stWord,             // ���ı���������ӽ��ĵ���
    stEllipsisCharacter,// ���ı���������ӽ����ַ��������е�ĩβ����һ��ʡ�Ժš�
    stEllipsisWord,     // ���ı���������ӽ��ĵ��ʣ������е�ĩβ����һ��ʡ�Ժ�
    stEllipsisPath      // ���Ĵӱ����������Ƴ�����ʡ�Ժ��滻
};

class TGpStringFormat : public TGdiplusBase
{
private:
	friend  class TGpGraphicsPath;
    friend  class TGpGraphics;

	int __fastcall GetTabStopCount(void)
    {
         CheckStatus(GdipGetStringFormatTabStopCount(Native, &Result.rINT));
         return Result.rINT;
    }
	LANGID __fastcall GetDigitSubstitutionLanguage(void)
    {
        CheckStatus(GdipGetStringFormatDigitSubstitution(Native, (Word*)&Result.rUINT, NULL));
        return Result.rUINT;
    }
	TStringDigitSubstitute __fastcall GetDigitSubstitutionMethod(void)
    {
        CheckStatus(GdipGetStringFormatDigitSubstitution(Native, NULL, (StringDigitSubstitute*)&Result.rINT));
        return (TStringDigitSubstitute)Result.rINT;
    }
	int __fastcall GetMeasurableCharacterRangeCount(void)
    {
        CheckStatus(GdipGetStringFormatMeasurableCharacterRangeCount(Native, &Result.rINT));
        return Result.rINT;
    }
	TStringAlignment __fastcall GetAlignment(void)
    {
        CheckStatus(GdipGetStringFormatAlign(Native, (StringAlignment*)&Result.rINT));
        return (TStringAlignment)Result.rINT;
    }
	TStringFormatFlags __fastcall GetFormatFlags(void)
    {
        CheckStatus(GdipGetStringFormatFlags(Native, &Result.rINT));
        return *(TStringFormatFlags*)&Result.rINT;
    }
	THotkeyPrefix __fastcall GetHotkeyPrefix(void)
    {
        CheckStatus(GdipGetStringFormatHotkeyPrefix(Native, &Result.rINT));
        return (THotkeyPrefix)Result.rINT;
    }
	TStringAlignment __fastcall GetLineAlignment(void)
    {
        CheckStatus(GdipGetStringFormatLineAlign(Native, (GdiplusSys::StringAlignment*)&Result.rINT));
        return (TStringAlignment)Result.rINT;
    }
	TStringTrimming __fastcall GetTrimming(void)
    {
        CheckStatus(GdipGetStringFormatTrimming(Native, (GdiplusSys::StringTrimming*)&Result.rINT));
        return (TStringTrimming)Result.rINT;
    }
	void __fastcall SetAlignment(TStringAlignment align)
    {
        CheckStatus(GdipSetStringFormatAlign(Native,(StringAlignment)(int)align));
    }
	void __fastcall SetFormatFlags(TStringFormatFlags flags)
    {
		CheckStatus(GdipSetStringFormatFlags(Native, SETTOWORD(flags)));
    }
	void __fastcall SetHotkeyPrefix(THotkeyPrefix hotkeyPrefix)
    {
        CheckStatus(GdipSetStringFormatHotkeyPrefix(Native, (int)hotkeyPrefix));
    }
	void __fastcall SetLineAlignment(TStringAlignment align)
    {
        CheckStatus(GdipSetStringFormatLineAlign(Native, (StringAlignment)(int)align));
    }
	void __fastcall SetTrimming(TStringTrimming trimming)
    {
        CheckStatus(GdipSetStringFormatTrimming(Native, (StringTrimming)(int)trimming));
    }

protected:
	__fastcall TGpStringFormat(GpNative *native, TCloneAPI cloneFun) : TGdiplusBase(native, cloneFun) { }
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGpStringFormat));
	}
#endif
	// ��Ĭ�Ϲ��캯���Ѿ�������Native��TGenericStringFormatֻ����������캯���������ڴ�й¶
	__fastcall TGpStringFormat(bool Generic){}
public:
	__fastcall TGpStringFormat(TStringFormatFlags formatFlags = TStringFormatFlags(), LANGID language = LANG_NEUTRAL)
    {
		CheckStatus(GdipCreateStringFormat(SETTOWORD(formatFlags), language, &Native));
    }
	__fastcall TGpStringFormat(TGpStringFormat* format)
    {
        CheckStatus(GdipCloneStringFormat(ObjectNative(format), &Native));
    }
	static TGpStringFormat* __fastcall GenericDefault(void);
	static TGpStringFormat* __fastcall GenericTypographic(void);
	TGpStringFormat* __fastcall Clone(void)
	{
		return new TGpStringFormat(Native, (TCloneAPI)GdipCloneStringFormat);
	}
	__fastcall virtual ~TGpStringFormat(void)
	{
		GdipDeleteStringFormat(Native);
	}
	void __fastcall SetTabStops(float firstTabOffset, const float * tabStops, const int tabStops_Size)
    {
        CheckStatus(GdipSetStringFormatTabStops(Native, firstTabOffset, tabStops_Size, tabStops));
    }
	void __fastcall GetTabStops(float &firstTabOffset, float *tabStops)
    {
        CheckStatus(GdipGetStringFormatTabStops(Native, TabStopCount, &firstTabOffset, tabStops));
    }
	void __fastcall SetDigitSubstitution(LANGID language, TStringDigitSubstitute substitute)
    {
        CheckStatus(GdipSetStringFormatDigitSubstitution(Native, language,
                (GdiplusSys::StringDigitSubstitute)(int)substitute));
    }
	void __fastcall SetMeasurableCharacterRanges(const TCharacterRange *ranges, const int ranges_Size)
    {
        CheckStatus(GdipSetStringFormatMeasurableCharacterRanges(Native,ranges_Size, (CharacterRange*)ranges));
    }
    
	__property int TabStopCount = {read=GetTabStopCount, nodefault};
	__property LANGID DigitSubstitutionLanguage = {read=GetDigitSubstitutionLanguage, nodefault};
	__property TStringDigitSubstitute DigitSubstitutionMethod = {read=GetDigitSubstitutionMethod, nodefault};
	__property int MeasurableCharacterRangeCount = {read=GetMeasurableCharacterRangeCount, nodefault};
	__property TStringAlignment Alignment = {read=GetAlignment, write=SetAlignment, nodefault};
	__property TStringFormatFlags FormatFlags = {read=GetFormatFlags, write=SetFormatFlags, nodefault};
	__property THotkeyPrefix HotkeyPrefix = {read=GetHotkeyPrefix, write=SetHotkeyPrefix, nodefault};
	__property TStringAlignment LineAlignment = {read=GetLineAlignment, write=SetLineAlignment, nodefault};
	__property TStringTrimming Trimming = {read=GetTrimming, write=SetTrimming, nodefault};

};

class TGenericStringFormat : public TGpStringFormat
{

protected:
#if !defined(BCC32_HAS_CLASSMETHODS)
	virtual TObject* __fastcall NewInstance(TClass cls)
	{
		return TGdiplusBase::NewInstance(__classid(TGenericStringFormat));
	}
#endif
	virtual void __fastcall FreeInstance()
	{
		GdipGenerics.GenericNil(this);
		TGdiplusBase::FreeInstance();
	}
public:
	TGenericStringFormat(void): TGpStringFormat(true){}
};

inline
static TGpStringFormat* __fastcall TGpStringFormat::GenericDefault(void)
{
	if (GdipGenerics.GenericDefaultStringFormatBuffer == NULL)
	{
		GdipGenerics.GenericDefaultStringFormatBuffer = new TGenericStringFormat();
		GdipStringFormatGetGenericDefault(&GdipGenerics.GenericDefaultStringFormatBuffer->Native);
	}
	return (TGpStringFormat*)GdipGenerics.GenericDefaultStringFormatBuffer;
}

inline
static TGpStringFormat* __fastcall TGpStringFormat::GenericTypographic(void)
{
	if (GdipGenerics.GenericTypographicStringFormatBuffer == NULL)
	{
		GdipGenerics.GenericTypographicStringFormatBuffer = new TGenericStringFormat();
		GdipStringFormatGetGenericTypographic(&GdipGenerics.GenericTypographicStringFormatBuffer->Native);
	}
	return (TGpStringFormat*)GdipGenerics.GenericTypographicStringFormatBuffer;
}

#endif // !_GDIPLUSSTRINGFORMAT_H

