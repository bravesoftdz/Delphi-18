unit Ubackup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,upublic, ComCtrls, StdCtrls,udata, Buttons;

type
  TFbackup = class(TForm)
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    Edit1: TEdit;
    Animate1: TAnimate;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fbackup: TFbackup;

implementation

{$R *.dfm}

procedure TFbackup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  isexit(self,action);
end;

procedure TFbackup.SpeedButton2Click(Sender: TObject);
begin
  backup(edit1,animate1,fdata.command1);
end;

procedure TFbackup.SpeedButton1Click(Sender: TObject);
begin
  with tsavedialog.Create(nil) do
  begin
   title:='��ѡ�񱸷�λ��';
   if execute then
   edit1.Text:=filename;//���ļ�����·������edit1.Text
   free;//�ͷſռ�
  end;
end;

end.
