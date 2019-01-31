unit Ulogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,unit1,jpeg, ExtCtrls, StdCtrls, Buttons, DB, ADODB,shellapi,adoconed;

type
  Tflogin = class(TForm)
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    ComboBox1: TComboBox;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  flogin: Tflogin;
  theconnectstring:string;
  user:string;
implementation

uses Udata2;
var
  times:integer=0;
{$R *.dfm}

procedure Tflogin.ComboBox1Change(Sender: TObject);
begin
speedbutton1.Enabled:=combobox1.itemindex<>0;//combobox1ֵ��Ϊ��
end;

procedure Tflogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if messagebox(handle,'ȷ���˳�?','Warging',mb_okcancel+mb_iconquestion)=idcancel then
  action:=canone;
end;

procedure Tflogin.SpeedButton1Click(Sender: TObject);
var
 loginpw:string;
 a:variant;    //�������

begin
 adotable1.Open;//��adotable1
 a:=adotable1.lookup('name',combobox1.Text,'password');//�����ݿ������û���Ӧ������ֵ����a
 loginpw:=a;//��aֵ����loginpw
 if edit2.text<>trim(loginpw) then
 begin
  inc(times);
   if times>3 then
   begin
    application.messagebox(pchar('�Բ�����������������'),pchar('����'),mb_ok);
    application.Terminate;
   end;//���������������������3������ʾ���Բ����������������ޡ�
  application.MessageBox(pchar('�������,����������'),pchar('��ʾ'),mb_ok);
  exit;//������������������ʾ������������������롯
 end;
 user:=combobox1.Text;//��combobox1.text��ֵ����user
 flogin.hide;
 adotable1.close;//�ر�adotable1
 fmain.Show;//��fmainҳ��
end;


procedure Tflogin.SpeedButton2Click(Sender: TObject);
begin
  application.Terminate;
end;


procedure Tflogin.FormShow(Sender: TObject);
begin
 try
 combobox1.Items.Add('��ѡ���û���');//���ֵ����ѡ���û�������combobox1.items
 adotable1.Open;//��adtable1
 while not adotable1.Eof do
 begin
  combobox1.Items.Add(adotable1.fieldbyname('name').asstring);
  adotable1.Next;//�����ݿ��С�name����ֵ��ӵ�combobox1.items��
 end;
 combobox1.ItemIndex:=0;
 except
   showmessage('���ӳ���');
 end;
  animatewindow(handle,700,aw_center)//��flogin���������ʾ�����벢�̶�
end;

procedure Tflogin.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_return then
 speedbutton1.Click;
end;

procedure Tflogin.FormHide(Sender: TObject);
begin
 animatewindow(handle,700,aw_center+aw_hide);//��flogin��������
end;

end.
