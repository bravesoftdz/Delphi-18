unit Ulogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons,upublic,unit1,StdCtrls, jpeg, ExtCtrls;

type
  TFlogin = class(TForm)
    Image1: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Flogin: TFlogin;
  times:integer;
implementation

uses Udata;

{$R *.dfm}

procedure TFlogin.SpeedButton2Click(Sender: TObject);
begin
 application.Terminate;
end;

procedure TFlogin.SpeedButton1Click(Sender: TObject);
var
 loginpw:string;
 a:variant;    //�������

begin
 fdata.employees.Open;
 if not fdata.employees.locate('name',edit1.Text,[]) then
 begin
 showmessage('���û�������');
 exit;
 end else
 a:=fdata.employees.lookup('name',edit1.Text,'password');//�����ݿ������û���Ӧ������ֵ����a
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
 user:=edit1.Text;//��edit1.text��ֵ����user
 department:=fdata.employees.lookup('name',edit1.Text,'department');
 fdata.employees.close;//�ر�fdata.employees
 close;
 fmain.Show;


end;

procedure TFlogin.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
 speedbutton1.Click;
end;

procedure TFlogin.FormShow(Sender: TObject);
begin
   animatewindow(Handle,700,aw_center+aw_activate);
 //  if fmain.Skin.Active then
 begin
     speedbutton1.Caption:='��½';
     speedbutton2.Caption:='�˳�';
   end 
end;

procedure TFlogin.FormActivate(Sender: TObject);
begin
 self.Repaint;
end;

end.
