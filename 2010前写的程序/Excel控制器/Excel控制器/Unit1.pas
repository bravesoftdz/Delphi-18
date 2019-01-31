unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, RzButton, Mask, RzEdit,
  RzLabel,StrUtils,UOrderExcel,upublic, cxControls,
  cxContainer, cxShellTreeView, cxSplitter, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, ShlObj, cxShellCommon, dxSkinsCore,
  dxSkinsDefaultPainters;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    chkFront: TCheckBox;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    SpeedButton1: TSpeedButton;
    TabSheet3: TTabSheet;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblSheet: TRzLabel;
    Label8: TLabel;
    reHColEnd: TRzEdit;
    reHColStart: TRzEdit;
    reHRowEnd: TRzEdit;
    reHRowStart: TRzEdit;
    RzButton3: TRzButton;
    RzButton5: TRzButton;
    RzButton17: TRzButton;
    RzButton16: TRzButton;
    RadioGroup2: TRadioGroup;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Label7: TLabel;
    UpDown1: TUpDown;
    ListBox1: TListBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    ����: TTabSheet;
    Button1: TButton;
    ListBox2: TListBox;
    Button2: TButton;
    cxShellTreeView1: TcxShellTreeView;
    Button3: TButton;
    Panel2: TPanel;
    cxSplitter1: TcxSplitter;
    Panel3: TPanel;
    cxSplitter2: TcxSplitter;
    TabSheet4: TTabSheet;
    Button4: TButton;
    Button5: TButton;
    btnEmpCol: TButton;
    Button6: TButton;
    DelEmptyCol: TButton;
    Button7: TButton;
    Splitter1: TSplitter;
    Memo1: TMemo;
    Button8: TButton;
    Button9: TButton;
    CheckBox1: TCheckBox;
    btn1: TButton;
    procedure chkFrontClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure RzButton3Click(Sender: TObject);
    procedure RzButton5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RzButton16Click(Sender: TObject);
    procedure RzButton17Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure btnEmpColClick(Sender: TObject);
    procedure DelEmptyColClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ExcelApp:variant;
  Myexcel:TExcel;
implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
 TheValue,straddr:variant;
 iRow,icol:integer;
begin
 if not assigned(myexcel) then exit;

 case RadioGroup1.ItemIndex of
 0:
 begin
   listbox1.Items:=myexcel.StatisticalItems(myexcel.CurCol);
 end;
 1:
 begin
   myexcel.teiLenFull(myexcel.CurCol);
 end;
 2:
 begin
   myexcel.FullAValue(myexcel.CurCol,edit1.Text,myexcel.CurRow);
 end;
 end;





end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  ShowMessage(IntToStr(Myexcel.CurRow)+'-'+inttostr(Myexcel.CurCol())+Myexcel.GetValue(Myexcel.CurRow,Myexcel.CurCol));
end;

procedure TForm1.btnEmpColClick(Sender: TObject);
begin
  if myexcel.EmptyCol then  showmessage('�ǿ���');

end;

procedure TForm1.Button10Click(Sender: TObject);
begin
 myexcel.Caption:='zmm is alter the doucument';
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  s:string;
begin
 s:='"'+'sdfs'+'"';
 showmessage(s);
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
 myexcel.DeleteEmptySheet;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     case RadioGroup2.ItemIndex of
 0:
 begin
   myexcel.SaveChange:=true;
  end;
 1:
 begin
   myexcel.SaveChange:=false;
 end;
 2:
 begin
   myexcel.SaveAs;
 end;


 end;
 if assigned(myexcel) then myexcel.Close ;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i,count:integer;
  ASheets:tstringlist;
begin
 asheets:=tstringlist.Create;
 for i :=0  to listbox2.Items.Count-1 do
 begin
   application.ProcessMessages;
   myexcel:=texcel.create(listbox2.Items[i]);
   asheets.AddStrings(myexcel.GetSheets());
   myexcel.Close;
 end;
 count:=1;
 stringlistdistinctitems(asheets);
 listbox2.Items:=asheets;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 listbox2.Items:=MakeFileList(cxShellTreeView1.Path,'.xls');

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 Myexcel.DelCol(Myexcel.CurCol());
 ShowMessage(IntToStr(Myexcel.MaxCol));
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 if myexcel.EmptyRow then  showmessage('�ǿ���');

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
 myexcel.DelEmpRow;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
 myexcel.ShowAll:=true;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
 myexcel.DelSpecialRow(memo1.Text,0,5);
 //myexcel.DelSpecialRow(memo1.Text,myexcel.CurCol,myexcel.CurRow);

 end;

procedure TForm1.Button9Click(Sender: TObject);
begin
 if myexcel.IsEmptyCell(myexcel.CurRow,myexcel.CurCol) then
  showmessage('NULL');

end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
 myexcel.ShowAllRC:=checkbox1.Checked;
end;

procedure TForm1.chkFrontClick(Sender: TObject);
begin
  if chkFront.Checked then
  begin
    SetWindowPos(self.Handle, HWND_TOPMOST, self.Left, self.Top, self.Width,
      self.Height, SWP_NOACTIVATE or SWP_SHOWWINDOW);
  end
  else
  begin
    SetWindowPos(self.Handle, HWND_NOTOPMOST, self.Left, self.Top, self.Width,
      self.Height, SWP_NOACTIVATE or SWP_SHOWWINDOW);
  end;
end;

procedure TForm1.DelEmptyColClick(Sender: TObject);
begin
  myexcel.DelEmpCol;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if  assigned(myexcel) then 
  myexcel.Close;

end;


procedure TForm1.RzButton16Click(Sender: TObject);
begin
 myexcel.NextSheet;
end;

procedure TForm1.RzButton17Click(Sender: TObject);
begin
myexcel.PreviousSheet;
end;

procedure TForm1.RzButton3Click(Sender: TObject);
begin
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, 'û�д��ļ������ļ��Ѿ����رգ���򿪻����´��ļ���', '����',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  reHRowStart.EditText := ExcelApp.ActiveCell.Row;
  reHColStart.EditText := ExcelApp.ActiveCell.Column;

end;

procedure TForm1.RzButton5Click(Sender: TObject);
var
  iRow, iCol: integer;
  strAddress: string;
begin
  if VarIsEmpty(ExcelApp) then
  begin
    messagebox(0, 'û�д��ļ������ļ��Ѿ����رգ���򿪻����´��ļ���', '����',
      MB_ICONSTOP + MB_OK + MB_SYSTEMMODAL);
    exit;
  end;
  // ����Ǻϲ��ĵ�Ԫ����ô��Ҫ���в��
  // Ĭ�ϵĺϲ���Ԫ��ĵ�ַ�Ǻϲ��������Ͻǵĵ�Ԫ���ַ
  if ExcelApp.ActiveCell.MergeCells = true then
  begin
    strAddress := ExcelApp.ActiveSheet.Range[ExcelApp.ActiveCell.Address].MergeArea.Address;
    strAddress := midstr(strAddress, pos(':', strAddress) + 1,length(strAddress));
    // showmessage(strAddress);
    iRow := ExcelApp.ActiveSheet.Range[strAddress].Row;
    iCol := ExcelApp.ActiveSheet.Range[strAddress].Column;
    reHRowEnd.EditText := inttostr(iRow);
    reHColEnd.EditText := inttostr(iCol);
  end else
  begin
  reHRowEnd.EditText := ExcelApp.ActiveCell.Row;
  reHColEnd.EditText := ExcelApp.ActiveCell.Column;
  end;

  if iRow < StrToInt(reHRowStart.EditText) then
  begin
    showmessage('��ͷѡ����󣬽�����С����ʼ�С�������ѡ��');
    reHRowEnd.EditText := '';
    exit;
  end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
 if assigned(myexcel) then myexcel.Close ;
  myexcel:=texcel.create();
 updown1.Enabled:=true;
 BitBtn1.Enabled:=true;
 radiogroup1.Enabled:=true;
 radiogroup2.Enabled:=true;
 checkbox2.Enabled:=true;
end;

procedure TForm1.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
 if button=btnext then myexcel.NextSheet
 else myexcel.PreviousSheet;
end;




end.
