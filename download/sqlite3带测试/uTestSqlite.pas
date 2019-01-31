unit uTestSqlite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SQLiteTable3, ExtCtrls, jpeg, TestThreadUnit, OfflineMessages;

type
  TForm1 = class(TForm)
    btnTest: TButton;
    memNotes: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    ebName: TEdit;
    Label3: TLabel;
    ebNumber: TEdit;
    Label4: TLabel;
    ebID: TEdit;
    Image1: TImage;
    btnLoadImage: TButton;
    btnDisplayImage: TButton;
    btnBackup: TButton;
    pnStatus: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label7: TLabel;
    Edit2: TEdit;
    Memo1: TMemo;
    procedure btnTestClick(Sender: TObject);
    procedure btnLoadImageClick(Sender: TObject);
    procedure btnDisplayImageClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ShowThreadMessage(threadhandle: THandle; ThreadIndex: integer; Msg: string);
  private
    { Private declarations }
  public
    { Public declarations }
    threadcount: integer;
    threads: array of TTestThread;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//
// ����SQLite3����...
procedure TForm1.btnTestClick(Sender: TObject);
var
  SqlDBpath: string;
  SqlDB: TSQLiteDatabase;
  SqlTable: TSQLIteTable;
  sSQL: String;
  Notes: String;
begin
  SqlDBPath := ExtractFilepath(application.exename)+ 'test.db';
  SqlDB := TSQLiteDatabase.Create(SqlDBPath);
  try
    //
    // �жϱ���ڷ񣬴��ھ�ɾ����...
    if SqlDB.TableExists('testTable') then
      begin
        sSQL := 'DROP TABLE testtable';
        SqlDB.execsql(AnsiString(sSQL));
      end;
    //
    // ���½�����...
    sSQL := 'CREATE TABLE testtable ([ID] INTEGER PRIMARY KEY,[OtherID] INTEGER NULL,';
    sSQL := sSQL + '[Name] VARCHAR (255),[Number] FLOAT, [notes] BLOB, [picture] BLOB COLLATE NOCASE);';
    SqlDB.execsql(AnsiString(sSQL));
    //
    // ������...
    SqlDB.execsql('CREATE INDEX TestTableName ON [testtable]([Name]);');
    //
    // ��ʼ����...
    SqlDB.BeginTrans;
    try
      //
      // ����һ����¼...
      sSQL := 'INSERT INTO testtable(Name,OtherID,Number,Notes) VALUES ("Some Name",4,587.6594,"Here are some notes");';
      SqlDB.ExecSQL(AnsiString(sSQL));
      //
      // ����һ����¼...
      sSQL := 'INSERT INTO testtable(Name,OtherID,Number,Notes) VALUES ("Another Name",12,4758.3265,"More notes");';
      SqlDB.ExecSQL(AnsiString(sSQL));
      //
      // �ύ����...
      SqlDB.CommitTrans;
    //
    // �쳣�;������...
    except
       SqlDB.RollbackTrans;
    end;
    //
    // �����ݼ�...
    SqlTable := SqlDB.GetTable('SELECT * FROM testtable');
    try
      //
      // �м�¼������ʾ��һ����¼...
      if SqlTable.Count > 0 then
        begin
          ebName.Text := SqlTable.FieldAsString(SqlTable.FieldIndex['Name']);
          ebID.Text := inttostr(SqlTable.FieldAsInteger(SqlTable.FieldIndex['ID']));
          ebNumber.Text := floattostr( SqlTable.FieldAsDouble(SqlTable.FieldIndex['Number']));
          Notes :=  SqlTable.FieldAsBlobText(SqlTable.FieldIndex['Notes']);
          memNotes.Text := notes;
        end;
      //
      // ��ѯ������ɣ��ͷ����ݼ�...
      pnStatus.Caption:='����SQLite������ɣ�';
    finally
      SqlTable.Free;
    end;
//
// �������ͷ����ݿ�...
  finally
    SqlDB.Free;
  end;
end;

//
// ���̲߳���...
procedure TForm1.Button1Click(Sender: TObject);
var
   i: integer;
begin
   ThreadCount:=strtoint(edit1.Text);
   memo1.Lines.Clear;
   SetLength(Threads,ThreadCount);
   for i:=0 to ThreadCount-1 do
      begin
         memo1.Lines.Add('');
         Threads[i]:=TTestThread.Create(i,strtoint(edit2.text),ExtractFilepath(application.exename)+ 'test.db',true);
         Threads[i].Resume;
      end;
end;

//
// ��ʾһ���̹߳�����Ϣ�Ĺ���...
procedure TForm1.ShowThreadMessage(threadhandle: THandle; ThreadIndex: integer; Msg: string);
begin
   memo1.Lines[threadindex]:='�߳�'+inttostr(threadhandle)+': '+msg;
end;

//
// дͼƬ�ļ���BLOB�ֶεĲ���...
procedure TForm1.btnLoadImageClick(Sender: TObject);
var
  SqlDBpath: string;
  SqlDB: TSQLiteDatabase;
  SqlTable: TSQLIteTable;
  iID: integer;
  fs: TFileStream;
begin
//
// �ж����ݿ��ļ����ڷ�...
  SqlDBPath := ExtractFilepath(application.exename)+ 'test.db';
  if not FileExists(SqlDBPath) then
    begin
      MessageDLg('Test.db does not exist. Click Test Sqlite 3 to create it.',mtInformation,[mbOK],0);
      exit;
    end;
//
// �����ڣ��������ݿ���󣨼������ݿ��ļ���...
  SqlDB := TSQLiteDatabase.Create(SqlDBPath);
  try
    //
    // ��ȡ�׼�¼��ID�ֶε�ֵ���Ա��������sql���֮��...
    SqlTable := SqlDB.GetTable('SELECT ID FROM testtable');
    try
      if SqlTable.Count = 0 then
        begin
          MessageDLg('There are no rows in the database. Click Test Sqlite 3 to insert a row.',mtInformation,[mbOK],0);
          exit;
        end;
      iID := SqlTable.FieldAsInteger(SqlTable.FieldIndex['ID']);
    finally
      SqlTable.Free;
    end;
    //
    // д��һ��ͼƬ�ļ���BLOB�ֶ�...
    fs:=TFileStream.Create(ExtractFileDir(application.ExeName) + '\sunset.jpg',fmOpenRead);
    try
      SqlDB.UpdateBlob('UPDATE testtable set picture=? WHERE ID=' + AnsiString(inttostr(iID)),fs);
      pnStatus.Caption:='д��ͼƬ��Blob�ֶγɹ���';
    finally
      fs.Free;
    end;
//
// ��ɣ��ر����ݿ�...
  finally
    SqlDB.Free;
  end;
end;

//
// �����ݱ��Blob�ֶζ�һ��ͼƬ...
procedure TForm1.btnDisplayImageClick(Sender: TObject);
var
  SqlDBpath: string;
  SqlDB: TSQLiteDatabase;
  SqlTable: TSQLIteTable;
  iID: integer;
  ms: TMemoryStream;
  pic: TJPegImage;
begin
//
// �����ݿ�...
  SqlDBPath := ExtractFilepath(application.exename)+ 'test.db';
  if not FileExists(SqlDBPath) then
    begin
      MessageDLg('Test.db does not exist. Click Test Sqlite 3 to create it, then Load image to load an image.',mtInformation,[mbOK],0);
      exit;
    end;
//
// �����ݱ�...
  SqlDB := TSQLiteDatabase.Create(SqlDBPath);
  try
    //
    // ȡID��������ʹ��...
    SqlTable := SqlDB.GetTable('SELECT ID FROM testtable');
    try
      if not SqlTable.Count = 0 then
        begin
          MessageDLg('No rows in the test database. Click Test Sqlite 3 to insert a row, then Load image to load an image.',mtInformation,[mbOK],0);
          exit;
        end;
      iID := SqlTable.FieldAsInteger(SqlTable.FieldIndex['ID']);
    finally
      SqlTable.Free;
    end;
    //
    // ���Ҽ�¼������ͼƬȡ������������ʾ��ͼƬ����...
    SqlTable := SqlDB.GetTable('SELECT picture FROM testtable where ID = ' + AnsiString(inttostr(iID)));
    try
      //
      // ȡ����������MS�У�ע��˶��������һ���ִ��ʱ�Զ�������Ҳ���ڱ�����ͷ�ʱ�Զ�һ���ͷţ�...
      ms:=SqlTable.FieldAsBlob(SqlTable.FieldIndex['picture']);
      if (ms = nil) then
        begin
          MessageDLg('No image in the test database. Click Load image to load an image.',mtInformation,[mbOK],0);
          exit;
        end;
      ms.Position := 0;
      pic := TJPEGImage.Create;
      pic.LoadFromStream(ms);
      self.Image1.Picture.Graphic:= pic;
      pic.Free;
      pnStatus.Caption:='��Blob�ֶζ�ȡͼƬ�ɹ���';
    finally
      SqlTable.Free;
    end;
//
// ��ɣ��ͷ����ݿ����...
  finally
    SqlDB.Free;
  end;
end;

//
// ���ݿⱸ�ݲ���...
procedure TForm1.btnBackupClick(Sender: TObject);
var
  SqlDBpath: string;
  SqlDB: TSQLiteDatabase;
  SqlDBBak: TSQLiteDatabase;
begin
//
// �����ݿ�...
  SqlDBPath := ExtractFilepath(application.exename);
  if not FileExists(SqlDBPath + 'test.db') then
    begin
      MessageDLg('Test.db does not exist. Click Test Sqlite 3 to create it.',mtInformation,[mbOK],0);
      exit;
    end;
  SqlDB := TSQLiteDatabase.Create(SqlDBPath + 'test.db');
//
// ���ݵ��µĿ��ļ�...
  try
    SqlDBBak := TSQLiteDatabase.Create(SqlDBPath + 'testbak.db');
    try
      if SqlDB.Backup(SqlDBBak) = 101 then
        pnstatus.Caption := '�������ݿ�ɹ���'
      else
        pnstatus.Caption := '�������ݿ�ʧ����';
    finally
      SqlDBBak.Free;
    end;
  finally
    SqlDB.Free;
  end;
end;

end.
