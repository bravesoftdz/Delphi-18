unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComObj, Grids, DBGrids, DB, ADODB, Mask, DBCtrls;

type
  TfrmMain = class(TForm)
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Button7: TButton;
    Button6: TButton;
    Button5: TButton;
    Button4: TButton;
    Button3: TButton;
    btnStart: TButton;
    btnClose: TButton;
    Button2: TButton;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button8: TButton;
    Label3: TLabel;
    Button9: TButton;
    ADOQuery2: TADOQuery;
    DataSource2: TDataSource;
    DBGrid2: TDBGrid;
    Label4: TLabel;
    DBEditdjh: TDBEdit;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    btntd: TButton;
    Button17: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure btnStartClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure DBEditdjhChange(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure btntdClick(Sender: TObject);
    procedure Button17Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  etapp:olevariant;
  myworkbook: OleVariant;    //�����ɽ���Ĺ���������
implementation
uses uniths;
{$R *.dfm}

procedure TfrmMain.btnStartClick(Sender: TObject);

begin
etapp:=createoleobject('et.application');
etApp.Visible := true;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
etApp.Visible := true;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
etApp.Visible := false;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  myworkbook :=etapp.Workbooks.add;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
  myworkbook :=etapp.Workbooks.Open(ExtractFilePath(ParamStr(0))+ '��������.et');
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.Open(ExtractFilePath(ParamStr(0))+ '��������.et');
  myworkbook.WorkSheets['ԭ������ⵥ'].Activate;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
etApp.Quit ;   //�˳������
end;

procedure TfrmMain.Button6Click(Sender: TObject);
begin
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.add;
    myworkbook.WorkSheets['sheet2'].Activate;
end;

procedure TfrmMain.Button7Click(Sender: TObject);
begin
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.add;
  myworkbook.WorkSheets['sheet2'].Activate;
  myworkbook.worksheets['sheet2'].cells[1,1].value:='3' ;
  myworkbook.worksheets['sheet2'].cells[4,2].value:='���'    ;

end;

procedure TfrmMain.Button8Click(Sender: TObject);
var
a:string;
begin
a:='���';
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.add;
  myworkbook.WorkSheets['sheet2'].Activate;
  myworkbook.worksheets['sheet2'].cells[5,2].value:=a;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
ADOQuery1.Close;
Adoquery1.SQL.CommaText :='select top 200 * from rkd order by id desc' ;
ADOQuery1.Open;
end;

procedure TfrmMain.Button9Click(Sender: TObject);
begin
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.add;
  myworkbook.WorkSheets['sheet2'].Activate;
  myworkbook.worksheets['sheet2'].cells[1,1].value:=datasource1.DataSet.FieldByName('dwmc').AsString  ;
end;

procedure TfrmMain.DBEditdjhChange(Sender: TObject);
begin
ADOQuery2.Close;
Adoquery2.SQL.CommaText :='select  * from rkdmx  where djh='''+dbeditdjh.Text +'''' ;
ADOQuery2.Open;
end;

procedure TfrmMain.Button10Click(Sender: TObject);
var
  i,row,column,j:integer;begin
  if dbgrid1.DataSource.DataSet.RecordCount =0 then exit;
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.add;
  myworkbook.WorkSheets['sheet1'].Activate;

  column:=1;
  for j:=0 to dbgrid1.FieldCount-1 do
  begin
    IF dbgrid1.Columns[j].Visible =true then
    begin
    myworkbook.worksheets['sheet1'].cells[1,column].value:=dbgrid1.columns.Items[j].Title.caption   ;
    column:=column+1;
    end;
  end;
  row:=2;
  dbgrid1.DataSource.DataSet.First;

  While Not (dbgrid1.DataSource.DataSet.Eof) do
  begin
    column:=1;
    for i:=0 to dbgrid1.Columns.Count-1   do
    begin
      IF dbgrid1.Columns[I].Visible =true then
        begin
        myworkbook.worksheets['sheet1'].cells[row,column].value:=dbgrid1.Columns[i].Field.AsString   ;
        column:=column+1;
      end;
    end;
    dbgrid1.DataSource.DataSet.Next;
    row:=row+1;
  end;
    showmessage('�������,����wps����н��б༭���Ű桢��ӡ�Ȳ�����');
 end;


procedure TfrmMain.Button11Click(Sender: TObject);
begin
savetoet(dbgrid1);
end;

procedure TfrmMain.Button12Click(Sender: TObject);
begin
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.add;
  myworkbook.WorkSheets['sheet2'].Activate;
  myworkbook.worksheets['sheet2'].cells[1,1].value:='���'    ;
  myworkbook.worksheets['sheet2'].Rows[1].select;
  showmessage('ѡ���˵�һ��');
end;

procedure TfrmMain.Button13Click(Sender: TObject);
begin
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.add;
  myworkbook.WorkSheets['sheet2'].Activate;
  myworkbook.worksheets['sheet2'].cells[1,1].value:='���'    ;
  showmessage('a1��Ԫ���������� ��� ���֣����潫ɾ�����У�');
  myworkbook.Worksheets['sheet2'].Rows[1].Delete  ;  //����ɾ����1��
end;

procedure TfrmMain.Button14Click(Sender: TObject);
begin
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.add;
  myworkbook.WorkSheets['sheet2'].Activate;
  myworkbook.worksheets['sheet2'].cells[1,1].value:='���'    ;
  myworkbook.worksheets['sheet2'].Rows[1].select;
  myworkbook.Worksheets['sheet2'].Rows[1].Insert(-4121);  //���ǲ����У�����Ϊʲô����д����Ϊ��ɽ��˾�����ǹ�˾�ļ���Ա�����ҵġ�
  showmessage('��ʵ���״��У������к���Ҫ��');
end;

procedure TfrmMain.btntdClick(Sender: TObject);
var
row:integer;
str:string;
begin
str:='˵����';
str:=str+chr(13)+'�±���е��������ϱ�����ϸ������ʱ���ǽ�һ�鵼����wps����С�';
str:=str+chr(13)+'���wps�������Ԥ�������˸�ʽ������������ݽ���ѭ���úõĸ�ʽ��';
str:=str+chr(13)+'������ʵ�����״����ֱ����������������û������ô�ӡ��ʽ����';
str:=str+chr(13)+'�������������ñ���ķ�����';
showmessage(str);

  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.Open(ExtractFilePath(ParamStr(0))+ '��������.et');

  if datasource1.DataSet.RecordCount =0 then exit;
  if datasource2.DataSet.RecordCount =0 then exit;
  etapp.Workbooks.Close;
  myworkbook :=etapp.Workbooks.Open(ExtractFilePath(ParamStr(0))+ '��������.et');
  myworkbook.WorkSheets['ԭ������ⵥ'].Activate;
  myworkbook.worksheets['ԭ������ⵥ'].cells[1,1].value:=datasource1.DataSet.FieldByName('dwmc').AsString +'��ⵥ';

  myworkbook.worksheets['ԭ������ⵥ'].cells[2,1].value:='���ݺţ�'+datasource1.DataSet.FieldByName('djh').AsString  +'    ҵ��Ա��'+ datasource1.DataSet.FieldByName('ywy').AsString  ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[3,1].value:='��λ���ƣ�'+datasource1.DataSet.FieldByName('dwmc').AsString    ;

  row:=5;
  datasource2.DataSet.First ;
  while not datasource2.DataSet.Eof do
  begin
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,1].value:=row-4     ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,2].value:=datasource2.DataSet.FieldByName('pm').AsString    ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,3].value:=datasource2.DataSet.FieldByName('ggxh').AsString  ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,4].value:=datasource2.DataSet.FieldByName('cd').AsString  ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,5].value:=datasource2.DataSet.FieldByName('dw').AsString  ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,6].value:=datasource2.DataSet.FieldByName('sl').AsString  ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,7].value:=datasource2.DataSet.FieldByName('jj').AsString  ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,8].value:=datasource2.DataSet.FieldByName('je').AsString  ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,9].value:=datasource2.DataSet.FieldByName('ckmc').AsString  ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,10].value:=datasource2.DataSet.FieldByName('bz').AsString  ;
  datasource2.DataSet.Next ;

  if datasource2.DataSet.Eof  then
  begin
   myworkbook.Worksheets['ԭ������ⵥ'].Rows[row+1].Delete  ;
   break;
  end;

  row:=row+1;

  myworkbook.Worksheets['ԭ������ⵥ'].Rows[row].select;
  myworkbook.Worksheets['ԭ������ⵥ'].Rows[row].Insert(-4121);
  end;

  if datasource1.DataSet.FieldByName('dwmc').AsString  <>'' then
  begin
  row:=row+1;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,1].value:='��ע:'+datasource1.DataSet.FieldByName('bz').AsString     ;
  end;

  row:=row+1;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,1].value:='����Ա:'+ datasource1.DataSet.FieldByName('czy').AsString  ;
  myworkbook.worksheets['ԭ������ⵥ'].cells[row,8].value:='���ϼ�:'+ datasource1.DataSet.FieldByName('jehj').AsString  +'Ԫ'  ;

  end;

procedure TfrmMain.Button17Click(Sender: TObject);
begin
btntd.click;
  myworkbook.worksheets['ԭ������ⵥ'].printout();
end;

end.
