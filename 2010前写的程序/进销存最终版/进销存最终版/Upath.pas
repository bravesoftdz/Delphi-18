unit Upath;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TFpath = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Animate1: TAnimate;
    Label2: TLabel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fpath: TFpath;

implementation
   uses udata2;
{$R *.dfm}

procedure TFpath.SpeedButton2Click(Sender: TObject);
begin
  if Trim(Edit1.Text)='' then Exit;
  try
    Animate1.Visible:=True;//��Animate1����
    data2.back.CommandText:='backup database jxc to disk='+''''+Trim(Edit1.Text)+'''';//��'backup database jxc to disk='+''''+Trim(Edit1.Text)+''''����data2.back.CommandText
    Animate1.Active:=True;//��Animate1������Active��Ϊtrue
    data2.back.Execute;
    Animate1.Active:=False;//��Animate1������Active��Ϊfalse
    Application.MessageBox('�������ݳɹ�','��ʾ',mb_ok);
  except
    Application.MessageBox('��������ʧ��','��ʾ',mb_ok);
  end;
  Animate1.Visible:=False;//����Animate1����
end;

procedure TFpath.SpeedButton1Click(Sender: TObject);
begin
 case tag of
 1:
 begin
  with tsavedialog.Create(nil) do
  begin
   title:='��ѡ�񱸷�λ��';
   if execute then
   edit1.Text:=filename;//���ļ�����·������edit1.Text
   free;//�ͷſռ�
  end;
 end;
 2:
 begin
  with topendialog.Create(nil) do
  begin
   title:='��ѡ�񱸷��ļ���λ��';
   if execute then
   edit1.Text:=filename;//���ļ�����·������edit1.Text
   free;//�ͷſռ�
  end;
 end;
 end;

end;

procedure TFpath.SpeedButton3Click(Sender: TObject);
begin
 if Application.MessageBox('�ָ�ǰ���ȱ��ݣ��Ƿ�ʼ�ָ���','��ʾ',mb_yesno)=id_no then
    Exit;
  if Trim(Edit1.Text)='' then Exit;
  try
    try
      Animate1.Visible:=True;//��Animate1����
      data2.back.CommandText:='use master alter database jxc set offline WITH ROLLBACK IMMEDIATE use master restore database jxc from disk='+''''+Trim(Edit1.Text)+''''+'with replace alter database jxc set online with rollback immediate';
      Animate1.Active:=True;//��Animate1������Active��ΪTrue
      data2.back.Execute;
      Animate1.Active:=False;
      Application.MessageBox('�ָ����ݳɹ�..����Ҫ���������ʹ�û�ԭ������','��ʾ',mb_ok);
    finally
      data2.back.CommandText:='use jxc';//��'use jxc'����data2.back.CommandText
      data2.back.Execute;
    end;
  except
    Application.MessageBox('�ָ�����ʧ��','��ʾ',mb_ok);
  end;
  Animate1.Visible:=False;//����Animate1����


end;

end.
