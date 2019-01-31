unit TColorButton;

interface

uses
  SysUtils, Classes, Controls, StdCtrls;

type
  TColorButton = class(TButton)
  private
    FColor:TColor;
    FCanvas: TCanvas;
    IsFocused: Boolean;
    procedure SetColor(Value:TColor);
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetButtonStyle(ADefault: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Color:TColor read FColor write SetColor default clWhite;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Standard', [TColorButton]);
end;

{ TColorButton }
/*** ���캯�� *****************************************************
constructor TColorButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FColor:=clWhite;//Ĭ����ɫ
end;

//*** �������� *************************************************
destructor TColorButton.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

//*** ���尴ť��ʽ�����뽫�ð�ť�ض���Ϊ�Ի�ʽ��ť *************
procedure TColorButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do Style := Style or BS_OWNERDRAW;
end;

//*** ����д���� ************************************************
procedure TColorButton.SetColor(Value:TColor);
begin
  FColor:=Value;
  Invalidate;
end;

//*** ���ð�ť״̬***********************************************
procedure TColorButton.SetButtonStyle(ADefault: Boolean);
begin
  if ADefault <> IsFocused then
  begin
    IsFocused := ADefault;
    Refresh;
  end;
end;

//*** ���ư�ť ***************************************************
procedure TColorButton.CNDrawItem(var Message: TWMDrawItem);
var
  IsDown, IsDefault: Boolean;
  ARect: TRect;
  Flags: Longint;
  DrawItemStruct: TDrawItemStruct;
  wh:TSize;
begin
  DrawItemStruct:=Message.DrawItemStruct^;
  FCanvas.Handle := DrawItemStruct.hDC;
  ARect := ClientRect;
  with DrawItemStruct do
  begin
    IsDown := itemState and ODS_SELECTED <> 0;
    IsDefault := itemState and ODS_FOCUS <> 0;
  end;

  Flags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
  if IsDown then Flags := Flags or DFCS_PUSHED;
  if DrawItemStruct.itemState and ODS_DISABLED <> 0 then
     Flags := Flags or DFCS_INACTIVE;

  if IsFocused or IsDefault then
  begin
    //��ť�õ�����ʱ��״̬����
    FCanvas.Pen.Color := clWindowFrame;
    FCanvas.Pen.Width := 1;
    FCanvas.Brush.Style := bsClear;
    FCanvas.Rectangle(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
    InflateRect(ARect, -1, -1);
  end;

  FCanvas.Pen.Color := clBtnShadow;
  FCanvas.Pen.Width := 1;
  FCanvas.Brush.Color := FColor;
  if IsDown then begin
    //��ť������ʱ��״̬����
     FCanvas.Rectangle(ARect.Left , ARect.Top, ARect.Right, ARect.Bottom);
     InflateRect(ARect, -1, -1);
  end else
     //����һ��δ���µİ�ť
     DrawFrameControl(DrawItemStruct.hDC, ARect, DFC_BUTTON, Flags);
  FCanvas.FillRect(ARect);

  //����Caption�ı�����
  FCanvas.Font := Self.Font;
  ARect:=ClientRect;
  wh:=FCanvas.TextExtent(Caption);
  FCanvas.Pen.Width := 1;
  FCanvas.Brush.Style := bsClear;
  if not Enabled then
  begin //��ťʧЧʱӦ���һ��Caption�ı�
     FCanvas.Font.Color := clBtnHighlight;
     FCanvas.TextOut((Width div 2)-(wh.cx div 2)+1,
                     (height div 2)-(wh.cy div 2)+1,
                      Caption);
     FCanvas.Font.Color := clBtnShadow;
  end;
  FCanvas.TextOut((Width div 2)-(wh.cx div 2),(height div 2)-(wh.cy div 2),Caption);

  //���Ƶõ�����ʱ���ڿ�����
  if IsFocused and IsDefault then
  begin
     ARect := ClientRect;
     InflateRect(ARect, -4, -4);
     FCanvas.Pen.Color := clWindowFrame;
     FCanvas.Brush.Color := FColor;
     DrawFocusRect(FCanvas.Handle, ARect);
  end;
  FCanvas.Handle := 0;
end;
//** The End *********************************************************
end.
end.
