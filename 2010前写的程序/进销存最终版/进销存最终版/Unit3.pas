unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, RpCon,
  RpConDS, RpBase, RpSystem, RpDefine, RpRave;

type
  TFmingxi = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    ComboBox2: TComboBox;
    Button1: TButton;
    DBGrid1: TDBGrid;
    RvProject1: TRvProject;
    RvSystem1: TRvSystem;
    RvDataSetConnection1: TRvDataSetConnection;
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmingxi: TFmingxi;
  customer:string;
  sumall:string;
implementation
 uses udata2,unit18;
{$R *.dfm}


procedure TFmingxi.ComboBox1Change(Sender: TObject);
var
 a,b:variant;
 a1,b1,sum:integer;
begin
 customer:=combobox1.Text;//��combobox1.Text��ֵ����customer
 data2.adostoredproc1.Close;//�ر�data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='�ͻ���δ�����Ϣ;1';//��ֵ'�ͻ���δ�����Ϣ;1'����customerdata2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;
 data2.adostoredproc1.Parameters.ParamValues['@name']:=combobox1.Text;//��combobox1.Text��ֵ����data2.adostoredproc1.Parameters.ParamValues['@name']
 data2.adostoredproc1.Open;//��data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//��ֵdata2.adostoredproc1����data2.dstemp.DataSet
 dbgrid1.DataSource:=data2.dstemp;//��ֵdata2.dstemp����dbgrid1.DataSource
 sum:=0;
 data2.ADOStoredProc1.First;
 while not  data2.ADOStoredProc1.Eof do
 begin
  a:=data2.ADOStoredProc1.fieldbyname('sumpricee').Value;//��ֵsumpricee����a
  b:=data2.ADOStoredProc1.fieldbyname('cush').Value;//��ֵcush����b
  a1:=a;//��a��ֵ����a1
  b1:=b;//��b��ֵ����b1
  sum:=sum+(a1-b1);//��sum+(a1-b1)��ֵ����sum
  data2.ADOStoredProc1.next;
 end;
 edit1.Text:=inttostr(sum);//��sumת��Ϊstring���͸���edit1.Text
 sumall:=inttostr(sum);//��sumת��Ϊstring���͸���sumall


end;


procedure TFmingxi.SpeedButton1Click(Sender: TObject);
begin
 form18.qrlabel9.Caption:=unit3.customer+'��δ�����Ϣ';//��unit3�е�customer+'��δ�����Ϣ'����form18.qrlabel9.Caption
 form18.qrlabel11.Caption:=unit3.sumall+'Ԫ';//��unit3�е�sumall+'Ԫ'����form18.qrlabel11
 form18.QuickRep1.Preview;//��ӡ����
end;

procedure TFmingxi.FormCreate(Sender: TObject);
begin
 combobox1.Items.Clear;//��combobox1.Items��ֵ���
  data2.customers.Open;//��data2.customers
  data2.customers.First;
 while not data2.customers.Eof do
 begin
  combobox1.Items.Add(data2.customers.fieldbyname('name').asstring);//��data2.customers.fieldbyname�е�'name'��ӵ�combobox1.Items
  data2.customers.Next;
 end;
end;

end.
