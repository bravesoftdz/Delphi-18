unit Urstore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,upublic, StdCtrls,udata, Buttons;

type
  TFrestore = class(TForm)
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
  Frestore: TFrestore;

implementation

{$R *.dfm}

procedure TFrestore.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  isexit(self,action);
end;

procedure TFrestore.SpeedButton2Click(Sender: TObject);
begin
  restore(edit1,animate1,fdata.command1);
end;

procedure TFrestore.SpeedButton1Click(Sender: TObject);
begin
  with topendialog.Create(nil) do
  begin
   title:='��ѡ�񱸷��ļ���λ��';
   if execute then
   edit1.Text:=filename;//���ļ�����·������edit1.Text
   free;//�ͷſռ�
  end;
end;

end.
