program ESQLTool;

{$APPTYPE CONSOLE}

uses
  Forms,
  Classes,
  Windows,
  AES,
  SysUtils,
  shellapi,
  SQLFileDecrypt in '..\common\SQLFileDecrypt.pas',
  UnitSQLParser in 'UnitSQLParser.pas',
  UnitDBConnection in 'UnitDBConnection.pas',
  ConfigINI in 'ConfigINI.pas';

{$R *.res}
const
  ScriptExecFile = '.\ScriptExecList.txt';
  LogslistFile = '.\Logslist';
  ConfigFile = '.\Config.ini';
  
var
  sError,sKey, sDirName: string;
  MemoryStream: TMemoryStream;
  StringStream: TStream;
  ScriptText, SQLFileName: string;
  i, Idx,iCount: Integer;
  RecordList, Logslist: TStringList;
  MyConnection: TMysqlConnection;
  strlist, strlist2: TStringList;
  function GetVersion: string;
  var
    VerInfoSize: DWORD;
    VerInfo: Pointer;
    VerValueSize: DWORD;
    VerValue: PVSFixedFileInfo;
    Dummy: DWORD;
  begin
    Result := '0.0.0.0';

    VerInfoSize := GetFileVersionInfoSize(PChar(Application.ExeName), Dummy);
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    with VerValue^ do
    begin
      dwProductVersionMS := dwFileVersionMS;
      dwProductVersionLS := dwFileVersionLS;
      Result :=Format('%d.%d.%d.%d', [
        dwProductVersionMS shr 16,
        dwProductVersionMS and $FFFF,
        dwProductVersionLS shr 16,
        dwProductVersionLS and $FFFF
        ]);
    end;
    FreeMem(VerInfo, VerInfoSize);
  end;

  function WordLoHiExchange(w:Word):Word;register;
  asm
    XCHG AL, AH
  end;
  function GetStrEncodeing(ABuffer: string): string;
  var
    W: Word;
  begin
    try
      W := PWord(Copy(ABuffer, 1, 2))^;
      W := WordLoHiExchange(W); //�ߵ��ֽڻ���
      if W=$0000 then
        Result := ABuffer
      else if W=$EFBB then
        Result := Utf8ToAnsi(Copy(ABuffer,4,MaxInt))
    {  else if W=$1895 then
        Result := Utf8ToAnsi(Copy(ABuffer,2,MaxInt)) }
      else
        Result := ABuffer;
    except
      Result := ABuffer;
    end;
  end;
  
  procedure NoteMessage(sMessage: string);
  begin
    System.Writeln(sMessage);
  end;

  function ExecSQLFile(pMyConnection: TMysqlConnection;sText, sstr: string): Integer;
  var
    Parser: TSQLParser;
    sStatement, strreplac, strreplacEx: string;
    nRowsAffected: Integer;
  begin
    nRowsAffected := 0;
    Parser := TSQLParser.Create();
    Parser.DenyTokens.Add('source');
    Parser.OnNoteMessage := NoteMessage;
    try

      if StrToInt(sstr) > 0 then
        strreplac:= StringReplace (sText, '?', sstr, [rfReplaceAll, rfIgnoreCase])
      else
        strreplac:= StringReplace (sText, '?', '', [rfReplaceAll, rfIgnoreCase]);

      if objINI.iServerEx > 0 then
        strreplacEx:= StringReplace (strreplac, '~', inttostr(objINI.iServerEx), [rfReplaceAll, rfIgnoreCase])
      else
        strreplacEx:= StringReplace (strreplac, '~', '', [rfReplaceAll, rfIgnoreCase]);

      Parser.Text := strreplacEx;
      while true do
      begin
        sStatement := Parser.GetStatement();
          if sStatement = '' then
          break;
         nRowsAffected := nRowsAffected + pMyConnection.RunScript(sStatement);
      end;
    finally
      Parser.Free;
    end;
    Result := nRowsAffected;
  end;
  function dlgCopyFiles(FromPath,ToPath:string):Integer;
  var
   lpFileOP:SHFileOpStruct;
  begin
    lpFileOP.Wnd:= 0;
    lpFileOP.wFunc:= FO_COPY;
    lpFileOP.pFrom:= PAnsiChar(FromPath+#0);
    lpFileOP.pTo:= PAnsiChar(ToPath+#0);
    //�Զ�����Ŀ¼
    lpFileOP.fFlags:= FOF_NOCONFIRMMKDIR;
    Result:= SHFileOperation(lpFileOP);
    if(lpFileOP.fAnyOperationsAborted)then
      Result:= 0
    else
    begin
      if(Result = 0)then Result:= 1
      else Result:= -1;
    end;
  end;
begin
  Application.Initialize;
  Application.Title := '���ݿ�ű�ִ�г���';
  Writeln(#10 + Format('ESQLTool %s',[GetVersion]));
  objINI := TConfigINI.Create(ConfigFile);
  RecordList := TStringList.Create;
  Logslist := TStringList.Create;
  strlist := TStringList.Create;
  strlist2 := TStringList.Create;
  iCount := 0;
  if FileExists(ScriptExecFile) then RecordList.LoadFromFile(ScriptExecFile);

  try
    if objINI.iRule = 0 then
    begin
      if (ParamStr(1) <> '') or (ParamStr(2) <> '') or (ParamStr(3) <> '')then
      begin
        if ParamStr(1) <> ''  then
        begin
          objINI.sSQLFile := ParamStr(1);
        end;
        if ParamStr(2) <> ''  then
        begin
          objINI.sDataBase := ParamStr(2);
        end;
        if ParamStr(3) <> ''  then
        begin
          objINI.iServer := ParamStr(3);
        end;

        if (objINI.sHostName = '') or (objINI.sDBUser = '') or (objINI.sDBPass = '') or
           (objINI.iPort = 0) or (objINI.sDataBase = '') {or (not FileExists(objINI.sSQLFile))} or
           (objINI.sSQLPass = '') then
        begin
          Writeln(#10 + '����ȷ����Config.ini�ļ������ݲ���Ϊ�ջ�ű��ļ�������');
          Exit;
        end;
        sDirName:= 'D:\Program Files\MySQL\MySQL Server 5.0\data';
        SQLFileName := ExtractFileName(objINI.sSQLFile);
        Idx := RecordList.IndexOf(SQLFileName);
        if Idx <> -1 then
        begin
          RecordList.Delete(Idx);
        end;
        MyConnection := TMysqlConnection.Create;
        try
          try
            sKey := DecryptString(objINI.sDBPass,GetRealKey(DBLogin_AESKey));
          except
            ZeroMemory(PChar(sKey),Length(sKey));
            Writeln(#10+'��¼���벻��ȷ');
            Exit;
          end;
          sError := MyConnection.ConnectionMysql(objINI.sHostName,objINI.sDataBase,objINI.sDBUser,sKey,objINI.iPort);
          ZeroMemory(PChar(sKey),Length(sKey)); sKey := '';
          if sError <> '' then
          begin
            Writeln(#10+sError);
            Exit;
          end;

         //���ȼ���Ƿ���� Ȼ�� ���ݷ�����������ִ��
          if ExtractFileName(objINI.sSQLFile) = 'mergeactor.esql' then
          if (ParamStr(1) = '') or (ParamStr(2) = '') or (ParamStr(3) = '')then
          if DirectoryExists(sDirName + objINI.sDataBase) then
          begin
            if not DirectoryExists('D:\BackupMySQL\') then MkDir(PChar('D:\BackupMySQL\')); //�����ļ���
               dlgCopyFiles(sDirName + objINI.sDataBase,  'D:\BackupMySQL\' + objINI.sDataBase + FormatDateTime('YYYY-MM-DD hh-mm-ss',Now));
          end;

          MemoryStream := TMemoryStream.Create;
          StringStream := TStringStream.Create('');
          MemoryStream.LoadFromFile(objINI.sSQLFile);
          try
            sKey := DecryptString(objINI.sSQLPass,GetRealKey(SQL_AESKey));
          except
            ZeroMemory(PChar(sKey),Length(sKey));
            Writeln(#10+'�ű����벻��ȷ');
          end;
          if DecryptStream(MemoryStream,sKey,StringStream) then
          begin
            Writeln(#10+Format('������%s:%dͨ��%sִ��%s',[objINI.sHostName,objINI.iPort,objINI.sDBUser,objINI.sSQLFile]));
            if FileExists(LogslistFile + objINI.iServer + '.txt') then Logslist.LoadFromFile(LogslistFile+ objINI.iServer + '.txt');
            Logslist.Add('['+ FormatDateTime('YYYY-MM-DD hh:mm:ss',Now) + Format('] ���ݿ�:%s �ű��ļ�:%s ������ID:%s ����ID:%d ',[objINI.sDataBase,objINI.sSQLFile,objINI.iServer,objINI.iServerEx]));
            Logslist.SaveToFile(LogslistFile+ objINI.iServer + '.txt');
            ScriptText := GetStrEncodeing(TStringStream(StringStream).DataString);
            try
              iCount := ExecSQLFile(MyConnection,ScriptText, objINI.iServer);
            except
              on E: Exception do
              begin
                Writeln(#10+'ִ�нű������г��ִ���'+E.Message);
                Exit;
              end;
            end;
            Writeln(#10+Format('�ű�ִ�гɹ���Ӱ��ļ�¼��%d��',[iCount]));
            RecordList.Add(SQLFileName);
            RecordList.SaveToFile(ScriptExecFile);
          end;
          ZeroMemory(PChar(sKey),Length(sKey));
        finally
          MyConnection.Free;
        end;
      end
      else begin
        strlist.DelimitedText := objINI.iServer;
        strlist.Delimiter := ',';
        for I := 0 to strlist.Count - 1 do
        begin
          if (objINI.sHostName = '') or (objINI.sDBUser = '') or (objINI.sDBPass = '') or
             (objINI.iPort = 0) or (objINI.sDataBase = '') or (not FileExists(objINI.sSQLFile)) or
             (objINI.sSQLPass = '') then
          begin
            Writeln(#10 + '����ȷ����Config.ini�ļ������ݲ���Ϊ�ջ�ű��ļ�������');
            Exit;
          end;
          sDirName:= 'D:\Program Files\MySQL\MySQL Server 5.0\data';
          SQLFileName := ExtractFileName(objINI.sSQLFile);
          Idx := RecordList.IndexOf(SQLFileName);
          if Idx <> -1 then
          begin
            RecordList.Delete(Idx);
          end;
          MyConnection := TMysqlConnection.Create;
          try
            try
              sKey := DecryptString(objINI.sDBPass,GetRealKey(DBLogin_AESKey));
            except
              ZeroMemory(PChar(sKey),Length(sKey));
              Writeln(#10+'��¼���벻��ȷ');
              Exit;
            end;
            sError := MyConnection.ConnectionMysql(objINI.sHostName,objINI.sDataBase,objINI.sDBUser,sKey,objINI.iPort);
            ZeroMemory(PChar(sKey),Length(sKey)); sKey := '';
            if sError <> '' then
            begin
              Writeln(#10+sError);
              Exit;
            end;

            //���ȼ���Ƿ���� Ȼ�� ���ݷ�����������ִ��
            if ExtractFileName(objINI.sSQLFile) = 'mergeactor.esql' then
            if DirectoryExists(sDirName + objINI.sDataBase) then
            begin
              if not DirectoryExists('D:\BackupMySQL\') then MkDir(PChar('D:\BackupMySQL\')); //�����ļ���
                 dlgCopyFiles(sDirName + objINI.sDataBase,  'D:\BackupMySQL\' + objINI.sDataBase + FormatDateTime('YYYY-MM-DD hh-mm-ss',Now));
            end;

            MemoryStream := TMemoryStream.Create;
            StringStream := TStringStream.Create('');
            MemoryStream.LoadFromFile(objINI.sSQLFile);
            try
              sKey := DecryptString(objINI.sSQLPass,GetRealKey(SQL_AESKey));
            except
              ZeroMemory(PChar(sKey),Length(sKey));
              Writeln(#10+'�ű����벻��ȷ');
            end;
            if DecryptStream(MemoryStream,sKey,StringStream) then
            begin
              Writeln(#10+Format('������%s:%dͨ��%sִ��%s',[objINI.sHostName,objINI.iPort,objINI.sDBUser,objINI.sSQLFile]));
              if FileExists(LogslistFile + objINI.iServer + '.txt') then Logslist.LoadFromFile(LogslistFile+ objINI.iServer + '.txt');
              Logslist.Add('['+ FormatDateTime('YYYY-MM-DD hh:mm:ss',Now) + Format('] ���ݿ�:%s �ű��ļ�:%s ������ID:%s ����ID:%d ',[objINI.sDataBase,objINI.sSQLFile,strList.Strings[i],objINI.iServerEx]));
              Logslist.SaveToFile(LogslistFile);
              ScriptText := GetStrEncodeing(TStringStream(StringStream).DataString);
              try
                iCount := ExecSQLFile(MyConnection,ScriptText, strList.Strings[i]);
              except
                on E: Exception do
                begin
                  Writeln(#10+'ִ�нű������г��ִ���'+E.Message);
                  Exit;
                end;
              end;
              Writeln(#10+Format('�ű�ִ�гɹ���Ӱ��ļ�¼��%d��',[iCount]));
              RecordList.Add(SQLFileName);
              RecordList.SaveToFile(ScriptExecFile);
            end;
            ZeroMemory(PChar(sKey),Length(sKey));
          finally
            MyConnection.Free;
          end;
        end;
      end;
    end
    else
    begin
      strlist.DelimitedText := objINI.sDataBase;
      strlist.Delimiter := ',';
      strlist2.DelimitedText := objINI.iServer;
      strlist2.Delimiter := ',';
      for I := 0 to strlist.Count - 1 do
      begin

        if (objINI.sHostName = '') or (objINI.sDBUser = '') or (objINI.sDBPass = '') or
           (objINI.iPort = 0) or (objINI.sDataBase = '') or (not FileExists(objINI.sSQLFile)) or
           (objINI.sSQLPass = '') then
        begin
          Writeln(#10 + '����ȷ����Config.ini�ļ������ݲ���Ϊ�ջ�ű��ļ�������');
          Exit;
        end;
        sDirName:= 'D:\Program Files\MySQL\MySQL Server 5.0\data';
        SQLFileName := ExtractFileName(objINI.sSQLFile);
        Idx := RecordList.IndexOf(SQLFileName);
        if Idx <> -1 then
        begin
          RecordList.Delete(Idx);
        end;
        MyConnection := TMysqlConnection.Create;
        try
          try
            sKey := DecryptString(objINI.sDBPass,GetRealKey(DBLogin_AESKey));
          except
            ZeroMemory(PChar(sKey),Length(sKey));
            Writeln(#10+'��¼���벻��ȷ');
            Exit;
          end;
          sError := MyConnection.ConnectionMysql(objINI.sHostName,strlist.Strings[i],objINI.sDBUser,sKey,objINI.iPort);
          ZeroMemory(PChar(sKey),Length(sKey)); sKey := '';
          if sError <> '' then
          begin
            Writeln(#10+sError);
            Exit;
          end;

          MemoryStream := TMemoryStream.Create;
          StringStream := TStringStream.Create('');
          MemoryStream.LoadFromFile(objINI.sSQLFile);
          try
            sKey := DecryptString(objINI.sSQLPass,GetRealKey(SQL_AESKey));
          except
            ZeroMemory(PChar(sKey),Length(sKey));
            Writeln(#10+'�ű����벻��ȷ');
          end;
          if DecryptStream(MemoryStream,sKey,StringStream) then
          begin
            Writeln(#10+Format('������%s:%dͨ��%sִ��%s',[objINI.sHostName,objINI.iPort,objINI.sDBUser,objINI.sSQLFile]));
            if FileExists(LogslistFile + objINI.iServer + '.txt') then Logslist.LoadFromFile(LogslistFile + objINI.iServer + '.txt');
            Logslist.Add('['+ FormatDateTime('YYYY-MM-DD hh:mm:ss',Now) + Format('] ���ݿ�:%s �ű��ļ�:%s ������ID:%s ����ID:%d ',[strList.Strings[i],objINI.sSQLFile,strList2.Strings[i],objINI.iServerEx]));
            Logslist.SaveToFile(LogslistFile);
            ScriptText := GetStrEncodeing(TStringStream(StringStream).DataString);
            try
              iCount := ExecSQLFile(MyConnection,ScriptText, strList2.Strings[i]);
            except
              on E: Exception do
              begin
                Writeln(#10+'ִ�нű������г��ִ���'+E.Message);
                Exit;
              end;
            end;
            Writeln(#10+Format('�ű�ִ�гɹ���Ӱ��ļ�¼��%d��',[iCount]));
            RecordList.Add(SQLFileName);
            RecordList.SaveToFile(ScriptExecFile);
          end;
          ZeroMemory(PChar(sKey),Length(sKey));
        finally
          MyConnection.Free;
        end;
      end;
    end;
  finally
    RecordList.Free;
    Logslist.Free;
    objINI.Free;
    strlist.Free;
    strlist2.Free;
    Writeln(#10 + '�˳��ر�...');
    if (ParamStr(1) = '') or (ParamStr(2) = '') or (ParamStr(3) = '')then //�������������������Ҫ�ֶ��ر�
    Readln; //�����Ƿ���Ҫ�ر�
  end;

end.
