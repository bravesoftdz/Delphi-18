unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  // ������Ϣ
  TwindowStruct = record
   hwnd: HWND;
   classname: string;
  end;
  TArrWindowStruct = array of TwindowStruct;
  PwindowStruct = ^TArrWindowStruct;

  // ������Ϣ
  TProcessStruct = record
   hwnd,pid: DWORD;
  end;
  TArrProcessStruct = array of TProcessStruct;
  PArrProcessStruct = ^TArrProcessStruct;

  TForm1 = class(TForm)
    lst1: TListBox;
    btn1: TButton;
    btn2: TButton;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


//��ȡinsert�ľ�� �ͱ���
function EnumWindowsProc_1(hwnd: HWND;lparam: LPARAM):boolean;stdcall;
var
 buf, classBuf : array[Byte] of Char;
 pws: PwindowStruct;
begin
  GetWindowText(hwnd, buf, SizeOf(buf));
  GetClassName(hwnd, classBuf, SizeOf(buf));

  pws := PwindowStruct(lparam);
  SetLength(pws^, Length(pws^) + 1);
  pws^[High(pws^)].hwnd := hwnd;
  pws^[High(pws^)].classname := buf;

//  if buf<>'' then
//   form1.lst1.Items.Add(IntToStr(hwnd) + ' ������⣺' + buf + ' ����Ϊ��' + classBuf)
//  else
//   form1.lst1.Items.Add(IntToStr(hwnd) + ' û�д�����⣺'+ ' û������');

  Result := true;
end;



//��ȡinsert�ľ�� ����id
function EnumWindowsProc_2(hwnd: HWND;lparam: LPARAM):boolean;stdcall;
var
 pid : DWORD;
 pMyPS: PArrProcessStruct;
 buf: array[Byte] of Char;
begin
  GetWindowThreadProcessId(hwnd,pid);

  GetWindowText(hwnd, buf, SizeOf(buf));
//  GetClassName(hwnd, classBuf, SizeOf(buf));

  pMyPS := PArrProcessStruct(lparam);
  SetLength(pMyPS^, Length(pMyPS^) + 1);
  pMyPS^[High(pMyPS^)].hwnd := hwnd;
  pMyPS^[High(pMyPS^)].pid := pid;

//  if buf<>'' then
//   form1.lst1.Items.Add(IntToStr(hwnd) + ' ������⣺' + buf + ' ����Ϊ��' + classBuf)
//  else
//   form1.lst1.Items.Add(IntToStr(hwnd) + ' û�д�����⣺'+ ' û������');

  Result := true;
end;


procedure TForm1.btn1Click(Sender: TObject);
var
 myWindowStruct: TArrWindowStruct;
 i: Integer;
begin
// EnumWindows(@EnumWindowsProc_1, 0);
 EnumWindows(@EnumWindowsProc_1, Integer(@myWindowStruct));

 for i := Low(myWindowStruct) to High(myWindowStruct) do
 begin
  lst1.Items.Add(Format('%d -���� %s', [myWindowStruct[i].hwnd, myWindowStruct[i].classname]));

 end;



end;

procedure TForm1.btn2Click(Sender: TObject);
var
 temp : TArrProcessStruct;
 i :integer;
begin

 EnumWindows(@EnumWindowsProc_2,Integer(@temp));
 for i := Low(temp) to High(temp) do
 begin
  lst1.Items.Add(Format('%d -����ID %D', [temp[i].hwnd, temp[i].pid]));

 end;

end;

end.
