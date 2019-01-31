unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Comobj,DBCtrls, Grids, DBGrids, StdCtrls, Buttons;

type
  TFxitongshezhi = class(TForm)
    DBGrid1: TDBGrid;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    DBNavigator1: TDBNavigator;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fxitongshezhi: TFxitongshezhi;

implementation
 uses Udata2,jinhodengji,ulogin;
{$R *.dfm}

procedure TFxitongshezhi.FormActivate(Sender: TObject);
var i:integer;
begin
 case radiogroup1.ItemIndex of
  0:
   begin
   dbgrid1.DataSource:=data2.dsemployee;//��data2.dsemployee����dbgrid1.DataSource
   data2.employee.Open;//��data2.employee
   dbnavigator1.DataSource:=data2.dsemployee;//��data2.dsemployee����dbnavigator1.DataSource
   end;
  1:
   begin
   dbgrid1.DataSource:=data2.dscustomers;//��data2.dscustomers����dbgrid1.DataSource
   data2.customers.Open;//��data2.customers
   dbnavigator1.DataSource:=data2.dscustomers;//��data2.dscustomers����dbnavigator1.DataSource
   end;
  2:
   begin
   dbgrid1.DataSource:=data2.dsjinhuochangshang;//��data2.dsjinhuochangshang����dbgrid1.DataSource
   data2.jinhuochangshang.Open;//��data2.jinhuochangshang
   dbnavigator1.DataSource:=data2.dsjinhuochangshang;//��data2.dsjinhuochangshang����dbnavigator1.DataSource
   end;
  3:
   begin
   data2.product.Open;//��data2.product
   dbgrid1.DataSource:=data2.dsproduct;//��data2.dsproduct����dbgrid1.DataSource
   dbnavigator1.DataSource:=data2.dsproduct;//��data2.dsproduct����dbnavigator1.DataSource
   end;
  4:
   begin
   dbgrid1.DataSource:=data2.dslogin;//��data2.dslogin����dbgrid1.DataSource
   data2.login.Open;//��data2.login
   dbnavigator1.DataSource:=data2.dslogin;//��data2.dslogin����dbnavigator1.DataSource
   end;
  5:
   begin
   dbgrid1.DataSource:=data2.dscategory;//��data2.dscategory����dbgrid1.DataSource
   data2.category.Open;//��data2.category
   dbnavigator1.DataSource:=data2.dscategory;//��data2.dscategory����dbnavigator1.DataSource
   end;
  end;

    i:=dbgrid1.Columns.Count-1;
    for i:=0 to i do
    begin
     with dbgrid1 do
     begin
      Columns[i].Width:=137;
     end;
    end;
end;



procedure TFxitongshezhi.FormShow(Sender: TObject);
var
 bo:boolean;
begin
 data2.login.Open;
 data2.login.Locate('name',ulogin.user,[]);
 bo:=data2.login.FieldValues['isadmin'];
 if not bo then bitbtn2.Enabled:=false;
    fxitongshezhi.Caption:=RadioGroup1.Items[RadioGroup1.ItemIndex];
end;


procedure TFxitongshezhi.BitBtn2Click(Sender: TObject);
begin
 if messagebox(handle,'ȷ��Ҫɾ����?','ɾ���󽫲��ɻָ���',mb_okcancel+mb_iconquestion)=idcancel then
  exit;
 case radiogroup1.ItemIndex of
  0:
   begin
   dbgrid1.DataSource:=data2.dsemployee;//��data2.dsemployee����dbgrid1.DataSource

   data2.employee.Open;//��data2.employee
   data2.employee.Delete;//ɾ��data2.employee
   end;
  1:
   begin
   dbgrid1.DataSource:=data2.dscustomers;//��data2.dscustomers����dbgrid1.DataSource
   data2.customers.Open;//��data2.customers
   data2.customers.Delete;//ɾ��data2.customers
   end;
  2:
   begin
   dbgrid1.DataSource:=data2.dsjinhuochangshang;//��data2.dsjinhuochangshang����dbgrid1.DataSource
   data2.jinhuochangshang.Open;//��data2.jinhuochangshang
   data2.jinhuochangshang.Delete;//ɾ��data2.jinhuochangshang
   end;
  3:
   begin
   data2.product.Open;//��data2.product
   dbgrid1.DataSource:=data2.dsproduct;//��data2.dsproduct����dbgrid1.DataSource
   data2.product.Delete;//ɾ��data2.product
   end;
  4:
   begin
   dbgrid1.DataSource:=data2.dslogin;//��data2.dslogin����dbgrid1.DataSource
   data2.login.Open;//��data2.login
   data2.login.Delete;//ɾ��data2.login
   end;
  5:
   begin
   dbgrid1.DataSource:=data2.dscategory;//��data2.dscategory����dbgrid1.DataSource
   data2.category.Open;//��data2.category
   data2.category.Delete;//ɾ��data2.category
   end;
  end;

end;

end.

