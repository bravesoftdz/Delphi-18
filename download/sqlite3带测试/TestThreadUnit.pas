unit TestThreadUnit;

interface

Uses
   {$IF CompilerVersion>=23.0}System.Classes{$ELSE}Classes{$IFEND},
   {$IF CompilerVersion>=23.0}System.SysUtils{$ELSE}SysUtils{$IFEND},
   {$IF CompilerVersion>=23.0}Winapi.Windows{$ELSE}Windows{$IFEND},
   SQLiteTable3;

type
    TTestThread = class(TThread)
    private
       filename: string;
       ThreadIndex: integer;
       Msg: string;
       taskcount: integer;
       TestCount: integer;
    protected
       procedure Execute; override;
       procedure ShowMsg;
    public
       constructor Create(ThreadIdx: integer; MaxCount: integer; dbfilename: string; CreateSuspended: boolean);
       destructor Destroy; override;
    end;

implementation

uses uTestSqlite;

//
// ��������ʵ��...
constructor TTestThread.Create(ThreadIdx: integer; MaxCount: integer; dbfilename: string; CreateSuspended: boolean);
begin
   inherited Create(CreateSuspended);
   FreeOnTerminate:=true;
   filename:=dbfilename;
   ThreadIndex:=ThreadIdx;
   taskcount:=0;
   TestCount:=MaxCount;
end;

//
// �ͷŶ���ʵ��...
destructor TTestThread.Destroy;
begin
   inherited;
end;

//
// ��ʾ��Ϣ�Ĺ���...
procedure TTestThread.ShowMsg;
begin
   Form1.ShowThreadMessage(self.Handle,ThreadIndex,msg);
end;

//
// �߳�ִ�й���...
procedure TTestThread.Execute;
var
//   ssql: string;
   SqlDB: TSQLiteDatabase;
   SqlTable: TSQLIteTable;
   i: integer;
begin
   SqlDB := TSQLiteDatabase.Create(filename);
   for i:=1 to TestCount do
      begin
         inc(taskcount);
         try
            //
            // ����һ����¼...
//            sSQL := 'INSERT INTO testtable(Name,OtherID,Number,Notes) VALUES ("Some Name",4,587.6594,"Here are some notes");';
//            SqlDB.ExecSQL(AnsiString(sSQL));
            //
            SqlTable := SqlDB.GetTable('SELECT * FROM testtable');
            Msg:='��'+inttostr(taskcount)+'�ζ����ݱ�ɹ���RecordCount='+inttostr(SqlTable.RowCount);
            synchronize(showmsg);
         except
            Msg:='��'+inttostr(taskcount)+'�ζ����ݱ�����쳣��';
            synchronize(showmsg);
         end;
         if assigned(SqlTable) then
            FreeAndNil(SqlTable);
         sleep(1);
      end;
   freeandnil(SqlDB);
end;

end.

