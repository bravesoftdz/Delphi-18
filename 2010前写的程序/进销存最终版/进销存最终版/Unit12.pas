unit Unit12;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFselectdate = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fselectdate: TFselectdate;

implementation
   uses unit13,udata2;
{$R *.dfm}

procedure TFselectdate.Button1Click(Sender: TObject);
begin

 case radiogroup1.ItemIndex of
 0:
 begin
 fsingledbgrid.Panel1.Caption:='����ͳ������';//��'����ͳ������'���� fsingledbgrid.Panel1.Caption
 data2.adostoredproc1.Close;//�ر�data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='����ͳ��;1';//��'����ͳ��;1'����data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//ˢ��
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//��datetimepicker1.DateTime����'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//��datetimepicker2.DateTime����'@enddate'
 data2.adostoredproc1.Open;//��data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//��data2.adostoredproc1����data2.dstemp.DataSet
 fsingledbgrid.dbgrid1.DataSource:=data2.dstemp;//��data2.dstemp����fsingledbgrid.dbgrid1.DataSource
 fsingledbgrid.Show;//��ʾfsingledbgrid����
 end;
 1:
 begin
  fsingledbgrid.Panel1.Caption:='����ͳ������';//��'����ͳ������'����fsingledbgrid.Panel1.Caption
 data2.adostoredproc1.Close;//�ر� data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='����ͳ��;1';//��'����ͳ��;1'����data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//ˢ��
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//��datetimepicker1.DateTime����'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//��datetimepicker2.DateTime����'@enddate'
 data2.adostoredproc1.Open;//��data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//��data2.adostoredproc1����data2.dstemp.DataSet
 fsingledbgrid.dbgrid1.DataSource:=data2.dstemp;//��data2.dstemp����fsingledbgrid.dbgrid1.DataSource
 fsingledbgrid.ShowModal;//��ʾfsingledbgrid����
 end;
 2:
 begin
  fsingledbgrid.Panel1.Caption:='�˻�ͳ������';//��'�˻�ͳ������'����fsingledbgrid.Panel1.Caption
  data2.adostoredproc1.Close;//�ر�data2.adostoredproc1
  data2.ADOStoredProc1.ProcedureName:='�ͻ��˻�ͳ��;1';//��'�ͻ��˻�ͳ��;1'����data2.ADOStoredProc1.ProcedureName
  data2.ADOStoredProc1.Parameters.Refresh;//ˢ��
  data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//��datetimepicker1.DateTime����'@startdate'
  data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//��datetimepicker2.DateTime����'@enddate'
  data2.adostoredproc1.Open;//��data2.adostoredproc1
  data2.dstemp.DataSet:=data2.adostoredproc1;//��data2.adostoredproc1����data2.dstemp.DataSet
  fsingledbgrid.dbgrid1.DataSource:=data2.dstemp;//��data2.dstemp����fsingledbgrid.dbgrid1.DataSource
  fsingledbgrid.ShowModal;//��ʾfsingledbgrid����
 end;
 end;
self.Close;//�˳�self
end;   

end.
