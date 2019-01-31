unit USqlServer;
////////////////////////////////////////////////////////
///                 Announce                        ////
///      Author: ������/zmm                         ////
///      QQ    : 378982719                          ////
///      Email : 378982719@qq.com                   ////
///                                                 ////
///      Power by zmm  20100713                     ////
///                                                 ////
////////////////////////////////////////////////////////
interface

uses
  Windows, Messages, SysUtils, strutils,Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids,Mask, DirOutln,DB, DBCtrls, Buttons, DBGrids,
  ValEdit,  ADODB, shellapi;
type
  FieldMap = record
    FieldName: string;
    ColIndex: integer;
  end;


procedure ComboboxAddTablename(var adoquery: tadoquery;var combobox: tcombobox);
function ToDBC(input: String): WideString;
procedure DC(var StrSource: string);
function IsMBCSChar(const ch: char): boolean;
function IsNumeric(AStr: string): boolean;
function GetDate(var str: String): Tdate;
procedure CloseExcel();
function AutoMatch(var comparefields, mapcol: tadoquery): boolean;
// procedure ComboboxAddItems(var comparefields,mapcol:tadoquery);
function SplitString(const Source, ch: string): TStringList;
procedure DropTable(Tablename:string;var adocommand:tadocommand);
function AppendCompare(fieldname,fielddesc,datatype:string;var adocommand:tadocommand):boolean;
Procedure AlterTable(var tableBI:tadoquery;var tableI:tadotable;var adocommand:tadocommand);
procedure craetetable(tablename: string; var mapcol: tadoquery;var adocommand: tadocommand);
function ChineseIndexIInString(var StrSource:string):integer;
function GetValueByOtherField(var table:tadoquery;setField,setFieldValue,GetField:string):variant;
procedure SetStringListByFieldName(var stringlist:tstringlist;var adoquery:tadoquery;Fieldname:string);
function MakeFileList(Path,FileExt:string):TStringList ;
function CompareFile(mFileName1,mFileName2: string): Boolean;// ���������ļ��Ƿ����
procedure StringlistDistinctItems(var Stringlist:tstringlist);
var
  ExcelApp: variant;

implementation

//�Ƚ��������Ƿ����
procedure StringlistDistinctItems(var Stringlist:tstringlist);
var
 i:integer;
begin
  if stringlist.Count<0 then exit;
  stringlist.Sort;
  for i :=stringlist.Count-1  downto 1 do
  begin
    if stringlist[i]=stringlist[i-1] then
    stringlist.Delete(i);
  end;
end;

function CompareStream(mStream1, mStream2: TStream): Boolean;
var
  vBuffer1, vBuffer2: array[0..$1000-1] of Char;
  vLength1, vLength2: Integer;
begin
  Result := mStream1 = mStream2;
  if Result then Exit;
  if not Assigned(mStream1) or not Assigned(mStream2) then Exit;// ����һ��Ϊ��
  while True do
  begin
      vLength1 := mStream1.Read(vBuffer1, SizeOf(vBuffer1));
      vLength2 := mStream2.Read(vBuffer2, SizeOf(vBuffer2));
      if vLength1 <> vLength2 then Exit;
      if vLength1 =0 then Break;
      if not CompareMem(@vBuffer1[0],@vBuffer2[0], vLength1) then Exit;
  end;
  Result := True;
end;{ CompareStream }
//�Ƚ������ļ��ǲ���һ����
function CompareFile(mFileName1,mFileName2: string): Boolean;// ���������ļ��Ƿ����
var
 vFileHandle1, vFileHandle2: THandle;
 vFileStream1, vFileStream2: TFileStream;
 vShortPath1, vShortPath2: array[0..MAX_PATH] of Char;
begin
  Result := False;
  // ����һ���ļ�������
  if not FileExists(mFileName1) or not FileExists(mFileName2) then Exit;
  GetShortPathName(PChar(mFileName1), vShortPath1, SizeOf(vShortPath1));
  GetShortPathName(PChar(mFileName2), vShortPath2, SizeOf(vShortPath2));
  Result := SameText(vShortPath1, vShortPath2);// �����ļ����Ƿ���ͬ
  if Result then Exit;
  vFileHandle1 := _lopen(PansiChar(mFileName1), OF_READ or OF_SHARE_DENY_NONE);
  vFileHandle2 := _lopen(PansiChar(mFileName2), OF_READ or OF_SHARE_DENY_NONE);
  Result :=(Integer(vFileHandle1)>0) and (Integer(vFileHandle2)>0);// �ļ��Ƿ���Է���
  if not Result then
  begin
      _lclose(vFileHandle1);
      _lclose(vFileHandle2);
      Exit;
  end;
  Result := GetFileSize(vFileHandle1, nil)= GetFileSize(vFileHandle2, nil);// �ļ���С�Ƿ�һ��
  if not Result then
  begin
      _lclose(vFileHandle1);
      _lclose(vFileHandle2);
      Exit;
  end;
  vFileStream1 := TFileStream.Create(vFileHandle1);
  vFileStream2 := TFileStream.Create(vFileHandle2);
  try
      Result := CompareStream(vFileStream1, vFileStream2);// �Ƚ������ļ������Ƿ���ͬ
  finally
      vFileStream1.Free;
      vFileStream2.Free;
  end;
end;{ CompareFile }


// ��ĳһĿ¼�²�ѯ�ض���׺�����ļ�
function MakeFileList(Path,FileExt:string):TStringList ;
var
sch:TSearchrec;
begin
Result:=TStringlist.Create;

if rightStr(trim(Path), 1) <> '\' then
    Path := trim(Path) + '\'
else
    Path := trim(Path);

if not DirectoryExists(Path) then
begin
    Result.Clear;
    exit;
end;

if FindFirst(Path + '*', faAnyfile, sch) = 0 then
begin
    repeat
       Application.ProcessMessages;
       if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
       if DirectoryExists(Path+sch.Name) then
       begin
         Result.AddStrings(MakeFileList(Path+sch.Name,FileExt));
       end
       else
       begin
         if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt)) or (FileExt='.*') then
         Result.Add(Path+sch.Name);
       end;
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
end;
end;


procedure Updatetable(tablename,PrimaryName,PrimaryValue,Fieldname,FieldValue:string;var adocommand:tadocommand);
var
 sql:string;
begin
 sql:='update '+tablename+' set '+fieldname+'='+quotedstr(Fieldvalue)+' where '+PrimaryName+'='+quotedstr(PrimaryValue);
 adocommand.CommandText:=sql;
 adocommand.Execute;
end;

// �ڱ�����һ���ض��ֶβ�������һ�е���һ���ֶε�ֵ
function GetValueByOtherField(var table:tadoquery;setField,setFieldValue,GetField:string):variant;
begin
 if not table.Active then table.Open;
 table.First;
 if  table.Locate(setField,setFieldValue,[loCaseInsensitive,loPartialKey]) then
 result:=table.FieldByName(GetField).Value
 else
 result:='null';
end;

//��һ�ű���ȡ���ض����ֶη���һ��tstinglist��
procedure SetStringListByFieldName(var stringlist:tstringlist;var adoquery:tadoquery;Fieldname:string);
var
 temps:string;
begin
  stringlist := TStringList.Create;
  if adoquery.Active then adoquery.Open;
  adoquery.First;
  while not adoquery.eof do
  begin
    temps:=adoquery.FieldByName(Fieldname).AsString;
//    temps:=stringreplace(temps,' ','',[rfreplaceall]);
    stringlist.add(temps);
    adoquery.Next;
  end;
  stringlist.Sort;
  adoquery.Close;
end;

//��߳���ĵ��ٶ�,ˢ�¶�����Ϣ �����¶��ձ��еĶ�����Ϣ��ԭ��Ļ������޸ı�ṹ
Procedure AlterTable(var tableBI:tadoquery;var tableI:tadotable;var adocommand:tadocommand);
var
  sql:string;
  fi:integer;
  IsNewField:boolean;
begin
  sql:='';
  tableI.Close;
  tablebi.Close;
  if not tableI.Active then tableI.Open;
  if not tableBI.Active then tablebi.Open;
  tablebi.First;
  while not tableBI.Eof do
  begin
   fi:=0;
   IsNewField:=true;
   while fi<=tableI.FieldCount-1  do
   begin
      if (trim(tableBI.FieldByName('DBfieldname').Value)=tableI.Fields[fi].FieldName) or (trim(tableBI.FieldByName('DBfieldname').Value)='') then
      begin
        IsNewField:=false;
        break;
      end;
      fi:=fi+1;
   end;
   if IsNewField then sql:=sql+' alter table '+tableI.TableName+' add  '+tableBI.FieldByName('dbfieldname').Value+' '+tableBI.FieldByName('datatype').Value;
   tablebi.Next;
  end;
  if trim(sql)<>'' then
  begin
    adocommand.CommandText:=sql;
    adocommand.Execute;
  end;
  tableI.Close;
  tablei.Open;
end;
//����ƥ��������Ҫ����ƥ������
function AppendCompare(fieldname,fielddesc,datatype:string;var adocommand:tadocommand):boolean;
var
 TDT:string;
 sql:string;
begin
 result:=false;
  if (trim(fieldname)='') or (trim(fielddesc)='') or (trim(datatype)='')  then
  begin
    showmessage('Ҫ���ӵ�ƥ�����ݲ���Ϊ��');
    exit;
  end
  else if datatype='����' then  TDT:='float'
  else if datatype='����' then  TDT:='datetime'
  else if datatype='����' then  TDT:='varchar(150)';
  sql:='insert into comparefields(fieldname,fielddesc,datatype) values('
  +quotedstr(fieldname)+','
  +quotedstr(fielddesc)+','
  +quotedstr(tdt)+')';
  adocommand.CommandText:=sql;
  adocommand.Execute;
  result:=true;
end;



//�ָ��ַ���
function SplitString(const Source, ch: string): TStringList;
var
  sources,temp: String;
  i: integer;
begin
  sources:=stringreplace(Source,' ','',[rfreplaceall]);
  Result := TStringList.Create;
  // ����ǿ��Է����򷵻ؿ��б�
  if Source = '' then
    exit;
  temp := stringreplace(Sources,' ','',[rfreplaceall]);
  i := pos(ch, Sources);
  while i <> 0 do
  begin
    Result.add(copy(temp, 0, i - 1));
    DELETE(temp, 1, i);
    i := pos(ch, temp);
  end;
  Result.add(temp);
end;


// �Զ�ƥ����
function AutoMatch(var comparefields, mapcol: tadoquery): boolean;
var
  n: integer;
begin
  comparefields.Open;
  comparefields.Filtered := false;
  mapcol.First;
  result := true;
  while not mapcol.eof do
  begin
    if comparefields.Locate('XlsColName',
      mapcol.FieldByName('XlsColName').AsString, [loCaseInsensitive,
      loPartialKey]) then
    begin
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := comparefields.FieldByName
        ('FieldDesc').AsString;
      mapcol.FieldByName('DBFieldName').AsString := comparefields.FieldByName
        ('FieldName').AsString;
      mapcol.FieldByName('datatype').AsString := comparefields.FieldByName
        ('datatype').AsString;
      mapcol.Post;
      mapcol.Next;
    end
    else
    begin
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '';
      mapcol.FieldByName('DBFieldName').AsString := '';
      mapcol.FieldByName('datatype').AsString := '';
      mapcol.Post;
      mapcol.Next;
      result := false;
    end;
  end;

  // �жϾ���(�����Ǿ���,Ҳ�������¾���)��ʲô ƥ�� 
  n := 0;
  mapcol.First;
  while not mapcol.eof do
  begin
    if trim(mapcol.FieldByName('DBFieldDesc').AsString) = '����' then
      n := n + 1;
    mapcol.Next;
  end;
  if n >= 2 then
  begin
    if mapcol.Locate('XlsColName', 'ԭ', [loPartialKey]) or mapcol.Locate
      ('XlsColName', '��', [loPartialKey]) or mapcol.Locate('XlsColName', '��',
      [loPartialKey]) then
    begin
      if not mapcol.Locate('XlsColName', '����', [loPartialKey]) then
        mapcol.Locate('XlsColName', '����', [loPartialKey]);
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '����';
      mapcol.FieldByName('DBFieldName').AsString := 'WELLNAME';
      mapcol.FieldByName('datatype').AsString := 'varchar(150)';
      mapcol.Post;
      mapcol.Next;
    end
    else
    begin
      if not mapcol.Locate('XlsColName', '����', [loPartialKey]) then
        mapcol.Locate('XlsColName', '����', [loPartialKey]);
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '�ɾ���';
      mapcol.FieldByName('DBFieldName').AsString := 'WELLNAMEA';
      mapcol.FieldByName('datatype').AsString := 'varchar(150)';
      mapcol.Post;
      mapcol.Next;
    end;
  end;

  if result = false then
    showmessage('�Զ�ƥ��δ���,���ֶ�ƥ��');
end;

// ��һ���ַ����л�ȡʱ��
function GetDate(var str: String): Tdate;
begin
  str := ExtractFilename(str);
  str := stringreplace(str, '.xls', '', [rfreplaceall]);
  DC(str);
  str := stringreplace(str, '.', '', [rfreplaceall]);
  result := strtodate(str);
  //   messagebox(0,'��������ַ���һ�����ֽ��ַ��������ַ�','Endlesslove137����',MB_OK);

end;

// �ر�excel 
procedure CloseExcel();
begin
  // �������Excel����ô�˳���ʱ��Ҫ�ر��ĵ��ͳ��� 
  if not VarIsEmpty(ExcelApp) then
  begin
    try
      // �������� 
      ExcelApp.ActiveWorkBook.Saved := true;
      ExcelApp.WorkBooks.Close;
      ExcelApp.quit;
      ExcelApp := Unassigned;
      VarClear(ExcelApp);
    except
      on e: exception do
        showmessage(e.message);
    end;
  end;

end;

// �ж��ǲ������� 
function IsNumeric(AStr: string): boolean;
var
  Value: Double;
  Code: integer;
begin
  Val(AStr, Value, Code);
  result := Code = 0;
end;

//�������ַ�����λ��
function ChineseIndexIInString(var StrSource:string):integer;
var
  Sl, ci: integer;
begin
  result:=0;
  ci := 0;
  Sl := length(StrSource);
  while ci <= Sl do
  begin
    if ((Word(StrSource[ci]) >= $3447) and (Word(StrSource[ci]) <= $FA29)) then
    begin
     result:=ci;
     break;
    end
    else ci := ci + 1;
  end;
end;
// ɾ�����ַ�
procedure DC(var StrSource: string);
var
  Sl, ci: integer;
begin
  ci := 0;
  Sl := length(StrSource);
  while ci <= Sl do
  begin
    if ((Word(StrSource[ci]) >= $3447) and (Word(StrSource[ci]) <= $FA29)) then
      StrSource := stringreplace(StrSource, StrSource[ci], ' ', [rfreplaceall]);
    ci := ci + 1;
  end;
  StrSource := stringreplace(StrSource, ' ', '', [rfreplaceall]);
end;

// �ж��ַ��Ƿ��� 
function IsMBCSChar(const ch: char): boolean;
begin
  // Result := (ByteType(ch, 1) <> mbSingleByte); 
  result := (Word(ch) >= $3447) and (Word(ch) <= $FA29);
end;

// ��ȫ��ת��Ϊ��� 
function ToDBC(input: String): WideString;
var
  c: WideString;
  i: integer;
begin
  c := input;
  for i := 1 to length(input) do
  begin
    if (Ord(c[i]) = 12288) then
    begin
      c[i] := chr(32);
      Continue;
    end;
    if (Ord(c[i]) > 65280) and (Ord(c[i]) < 65375) then
      c[i] := WideChar(chr(Ord(c[i]) - 65248));
    if (Ord(c[i]) = 10005) or (c[i] = '*') or (Ord(c[i]) = 215) then
    begin
      c[i] := 'x';
    end;
  end;
  result := c;
end;

procedure DropTable(Tablename:string;var adocommand:tadocommand);
var
 sql:string;
begin


   if tablename='����һ����' then  exit
   else   if trim(tablename)='' then  exit
   else
   begin
    sql:='drop table '+tablename;
    adocommand.CommandText:=sql;
    adocommand.Execute;
    showmessage('ɾ���ɹ�');
   end;
end;

// ����������ӱ���
procedure ComboboxAddTablename(var adoquery: tadoquery;
  var combobox: tcombobox);
var
  sqlstr: string;
begin // and name not in('log','mapcol','comparefields','comparefieldsbackup') 
  sqlstr := 'select * from sysobjects where type=' + quotedstr('U')
    + 'and name not in(' + quotedstr('log') + ',' + quotedstr('mapcol')
    + ',' + quotedstr('comparefields') + ',' + quotedstr
    ('comparefieldsbackup') + ')';
  adoquery.SQL.Clear;
  adoquery.SQL.Add(sqlstr);
  adoquery.Open;
  adoquery.First;
  combobox.Items.Clear;
  while not adoquery.eof do
  begin
    combobox.Items.Add(adoquery.FieldByName('name').Value);
    adoquery.Next;
  end;
  combobox.Items.Add('����һ����');
end;

procedure craetetable(tablename: string; var mapcol: tadoquery;var adocommand: tadocommand);
var
  sqlstr: string;
  sqladd:string;
begin
  if trim(tablename) = '' then
  begin
    showmessage('����Ǩ�Ƶ�Ŀ���������Ϊ��');
    exit;
  end;
  sqlstr := 'create table ' + trim(tablename) + '( ';
  mapcol.Open;
  mapcol.First;
  while not mapcol.eof do
  if trim(vartostr(mapcol.FieldByName('dbfieldname').Value))='' then
  begin
   mapcol.Next;
   continue;
  end else
  begin
    sqlstr := sqlstr + mapcol.FieldByName('dbfieldname')
      .Value + ' ' + mapcol.FieldByName('datatype').Value + ',';
      mapcol.Next;
  end;
 try
  //warter_well_no varchar(30) null,oil_well_no varchar(30) null,
  sqlstr:=sqlstr+'BiaoGeMingCheng varchar(30) null,InputDate datetime null,SchemaName varchar(30),InputUser varchar(30) null';
  sqlstr := sqlstr + ')';
  adocommand.CommandText := sqlstr;
  adocommand.Execute;
 except on exception do
    showmessage('������ʧ��');
 end;
end;

end.
