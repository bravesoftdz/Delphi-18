unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFprofit = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    ComboBox1: TComboBox;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fprofit: TFprofit;

implementation
   uses udata2;
{$R *.dfm}

procedure TFprofit.FormCreate(Sender: TObject);
begin
  data2.product.Open;//��data2.product
  data2.product.First;
  while not data2.product.Eof do
  begin
   combobox1.Items.Add(data2.product.fieldbyname('name').asstring);//��'name'��ӵ�combobox1.Items
   data2.product.Next;
  end;
  data2.product.Close;//�ر�data2.product
end;

procedure TFprofit.Button1Click(Sender: TObject);
begin
 data2.adostoredproc1.Close;//�ر�data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='�����Ʒ����;1';//��'�����Ʒ����;1'����data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//ˢ��
 data2.adostoredproc1.Parameters.ParamValues['@productname']:=combobox1.Text;//��combobox1.Text��ֵ����'@productname'
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//��datetimepicker1.DateTime����'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//��datetimepicker1.DateTime����'@enddate'
 data2.adostoredproc1.Open;//��data2.adostoredproc1
 Label10.Caption:=data2.adostoredproc1.fieldbyname('����۸��').AsString;//��'����۸��'����Label10.Caption
 Label9.Caption:=data2.adostoredproc1.fieldbyname('��������').AsString;//��'��������'����Label9.Caption
 Label11.Caption:=data2.adostoredproc1.fieldbyname('����').AsString;//��'����'����Label1.Caption

end;

procedure TFprofit.Button2Click(Sender: TObject);
begin
self.Close;//�˳�self
end;

end.
