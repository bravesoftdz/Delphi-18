unit Unit16;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFprofit2 = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    DateTimePicker1: TDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    DateTimePicker2: TDateTimePicker;
    Label9: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fprofit2: TFprofit2;

implementation
   uses udata2;
{$R *.dfm}

procedure TFprofit2.Button1Click(Sender: TObject);
begin
 data2.adostoredproc1.Close;//�ر�data2.adostoredproc1
 data2.ADOStoredProc1.ProcedureName:='��������;1';//��'��������;1'����data2.ADOStoredProc1.ProcedureName
 data2.ADOStoredProc1.Parameters.Refresh;//ˢ��
 data2.adostoredproc1.Parameters.ParamValues['@startdate']:=datetimepicker1.DateTime;//��datetimepicker1.DateTime����'@startdate'
 data2.adostoredproc1.Parameters.ParamValues['@enddate']:=datetimepicker2.DateTime;//��datetimepicker2.DateTime����'@enddate'
 data2.adostoredproc1.Open;//��data2.adostoredproc1
 Label1.Caption:=data2.adostoredproc1.fieldbyname('��������').AsString;//��'��������'����Label1.Caption
 Label11.Caption:=data2.adostoredproc1.fieldbyname('���ۿ�').AsString;//��'���ۿ�'����Label11.Caption
 Label12.Caption:=data2.adostoredproc1.fieldbyname('�ͻ��˻���').AsString;//��'�ͻ��˻���'����Label12.Caption
 Label19.Caption:=data2.adostoredproc1.fieldbyname('��˾�˻���').AsString;//��'��˾�˻���'����Label19.Caption
 Label13.Caption:=data2.adostoredproc1.fieldbyname('����').AsString;//��'����'����Label13.Caption
end;

procedure TFprofit2.Button2Click(Sender: TObject);
begin
self.Close;//�˳�self
end;

end.
