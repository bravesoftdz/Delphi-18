unit Unit19;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm19 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form19: TForm19;

implementation
uses ulogin,udata2;
{$R *.dfm}

procedure TForm19.BitBtn1Click(Sender: TObject);
begin
 if edit1.text<>edit2.Text then showmessage('�Բ���,��������������벻һ�²����޸�')//���edit1.text��ֵ������edit2.Text����ʾ��Ϣ'�Բ���,��������������벻һ�²����޸�'
 else
 begin
   data2.login.Open;//��data2.login
  if not data2.login.Locate('name',user,[])
   then showmessage('û���ҵ�����û���')//���data2.login.Locate��'name'Ϊ������ʾ��Ϣ'û���ҵ�����û���'
  else
   begin
    data2.login.Edit;
    data2.login.FieldByName('password').AsString:=edit2.Text;//��edit2.Text��ֵ����data2.login.FieldByName�е�'password'
    data2.login.Post;
   end;

 end;

end;

end.

