unit Unit23;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons;

type
  TForm23 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    DBGrid1: TDBGrid;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form23: TForm23;

implementation
   uses Udata2;
{$R *.dfm}

procedure TForm23.BitBtn1Click(Sender: TObject);
begin
  data2.qtemp.Close;//�ر�data2.qtemp
  data2.qtemp.SQL.Clear;//��data2.qtemp.SQL���
  data2.qtemp.SQL.Add('select * from product where stocks<='+quotedstr(edit1.Text));//��SQL��ѯ���'select * from product where stocks<='+quotedstr(edit1.Text)��ӵ�data2.qtemp.SQL
  dbgrid1.DataSource:=data2.dstemp;//��ֵdata2.dstemp����dbgrid1.DataSource
  data2.qtemp.Open;//��data2.qtemp
end;

end.
