unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons;

type
  TFyishoumingxi = class(TForm)
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fyishoumingxi: TFyishoumingxi;
   a,b:variant;
 a1,b1,sum:integer;
implementation
   uses udata2,unit5,unit18;
{$R *.dfm}

procedure TFyishoumingxi.BitBtn1Click(Sender: TObject);
begin
 Fyishoumingxi.Close;//�ر�Fyishoumingxi
 data2.adostoredproc1.Close;//�ر�data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='һ��ʱ���ڵ����տ�Ŀͻ���Ϣ;1';
 data2.ADOStoredProc1.Parameters.Refresh;//ˢ��
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//��datetimepicker1.DateTime����'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//��datetimepicker2.DateTime����'@enddate'
 data2.adostoredproc1.Open;//��data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//��data2.adostoredproc1����data2.dstemp.DataSet

 fmenu3.dbgrid1.DataSource:=data2.dstemp;//��data2.dstemp����fmenu3.dbgrid1.DataSource
 sum:=0;
 data2.ADOStoredProc1.First;
 while not  data2.ADOStoredProc1.Eof do
 begin
  a:=data2.ADOStoredProc1.fieldbyname('�Ѹ���').Value;//��'�Ѹ���'����a
  a1:=a;//��a��ֵ����a1
  sum:=sum+a1;//��sum+a1����sum
  data2.ADOStoredProc1.next;
 end;
 fmenu3.edit1.Text:=inttostr(sum);//��sumת��Ϊstring���͸���fmenu3.edit1.Text
 fmenu3.SpeedButton1.Visible:=true;//��fmenu3.SpeedButton1����
 fmenu3.SpeedButton2.Visible:=false;//����fmenu3.SpeedButton2����
  fmenu3.label1.Caption:='�ѽ��ϼƣ�';//��'�ѽ��ϼƣ�'����fmenu3.label1.Caption
 fmenu3.ShowModal;//��ʾfmenu3����
end;



procedure TFyishoumingxi.Button1Click(Sender: TObject);
begin
 Fyishoumingxi.Close;//�ر�Fyishoumingxi
 data2.adostoredproc1.Close;//�ر�data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='����ʱ���ѯ��ǰ�Ĺ�˾Ƿ����Ϣ;1';//��'����ʱ���ѯ��ǰ�Ĺ�˾Ƿ����Ϣ;1'����data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//ˢ��
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//��datetimepicker1.DateTime����'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//��datetimepicker2.DateTime����'@enddate'
 data2.adostoredproc1.Open;//��data2.adostoredproc1
 data2.dstemp.DataSet:=data2.adostoredproc1;//��data2.adostoredproc1����data2.dstemp.DataSet

 fmenu3.dbgrid1.DataSource:=data2.dstemp;//��data2.dstemp����fmenu3.dbgrid1.DataSource
 sum:=0;//��0����sum
 data2.ADOStoredProc1.First;
 while not  data2.ADOStoredProc1.Eof do
 begin
  a:=data2.ADOStoredProc1.fieldbyname('Ӧ����').Value;//��'Ӧ����'��ֵ����a
  b:=data2.ADOStoredProc1.fieldbyname('ʵ����').Value;//��'ʵ����'��ֵ����b
  a1:=a;//��a��ֵ����a1
  b1:=b;//��b��ֵ����b1
  sum:=sum+(a-b);//��sum+(a+b)��ֵ����sum
  data2.ADOStoredProc1.next;
 end;
 fmenu3.edit1.Text:=inttostr(sum);//��sumת��Ϊstring���͸���fmenu3.edit1.Text
  fmenu3.SpeedButton1.Visible:=false;//����fmenu3.SpeedButton1����
  fmenu3.SpeedButton2.Visible:=true;//��fmenu3.SpeedButton2����
  fmenu3.label1.Caption:='Ƿ��ϼƣ�';//��'Ƿ��ϼƣ�'����fmenu3.label1.Caption
  fmenu3.ShowModal;//��ʾ����fmenu3
  

end; 
end.
