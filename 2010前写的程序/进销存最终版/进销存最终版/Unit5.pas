unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Grids, DBGrids, ExtCtrls, StdCtrls;

type
  TFmenu3 = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmenu3: TFmenu3;
  summoney:string;
implementation

uses Udata2,unit6,unit7,unit4;

{$R *.dfm}

procedure TFmenu3.SpeedButton1Click(Sender: TObject);
begin
 frpys.QRLabel7.Caption:=inttostr(unit4.sum)+'Ԫ';//��unit4�е�sumת��Ϊstring���ͺ󸳸�frpys.QRLabel7.Caption
 frpys.QuickRep1.Preview;//��ӡ����
end;

procedure TFmenu3.SpeedButton2Click(Sender: TObject);
begin
 fqryf.QRLabel6.Caption:=inttostr(unit4.sum);//��unit4�е�sumת��Ϊstring���ͺ󸳸�fqryf.QRLabel6.Caption
 fqryf.QuickRep1.Preview;//��ӡ����
end;

procedure TFmenu3.FormShow(Sender: TObject);
var i:integer;
begin
 summoney:=edit1.Text;//��edit1.Text��ֵ����summoney
     i:=dbgrid1.Columns.Count-1;//��dbgrid1.Columns.Count-1��ֵ����i
    for i:=0 to i do
    begin
     with dbgrid1 do
     begin
      Columns[i].Width:=137;//��i=0��i��ֵ137����dbgrid1�е�Columns[i].Width
     end;
    end;

end;

end.
