unit UOrderAccess;
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
  Windows,ADODB,classes,sysutils,Dialogs,DB,variants,stdctrls;
const
   SqlTables='select name from MSysObjects where type=1 and flags=0';
type
  FieldMap = record
    FieldName: string;
    ColIndex: integer;
  end;
procedure ComboboxAddTablename(var adoquery: tadoquery;var combobox: tcombobox);
function AutoMatch(var comparefields, mapcol: tadoquery): boolean;overload;
function AutoMatch(var comparefields, mapcol: TADOTable): boolean;overload;
procedure ComboboxAddItems(var table:tadotable;Fieldname:string;var Combobox:TComboBox);
procedure DropTable(Tablename:string;var adocommand:tadocommand);
function AppendCompare(fieldname,fielddesc,datatype:string;var adocommand:tadocommand):boolean;
Procedure AlterTable(var tableBI:tadoquery;var tableI:tadotable;var adocommand:tadocommand);overload;
Procedure AlterTable(var tableBI:TADOTable;var tableI:TADOTable;var adocommand:tadocommand);overload;
procedure craetetable(tablename: string; var mapcol: tadoquery;var adocommand: tadocommand);overload;
procedure craetetable(tablename: string; var mapcol: TADOTable;var adocommand: tadocommand);overload;
function GetValueByOtherField(var table:TADOTable;setField,setFieldValue,GetField:string):variant;overload;
function GetValueByOtherField(var table:TADOQuery;setField,setFieldValue,GetField:string):variant;overload;

function GetValueByTwoField(var table:TADOTable;FirstFieldname,SecondFieldname,TheFieldname:string;FirstValue,SecondValue:Variant):variant;
procedure SetStringListByFieldName(var stringlist:tstringlist;var adoquery:tadoquery;Fieldname:string);



var
  ExcelApp: variant;

implementation

function GetValueByTwoField(var table:TADOTable;FirstFieldname,SecondFieldname,TheFieldname:string;FirstValue,SecondValue:Variant):variant;
begin
try
 if not table.Active then table.Open;
 table.First;
 if  table.Locate(FirstFieldname+';'+secondfieldname,vararrayof([FirstValue,SecondValue]), [loCaseInsensitive]) then
  result:=table.FieldByName(TheFieldname).Value
 else
  result:='null';
except on E: Exception do
 ShowMessage('Error From UorderAccess.GetValueByTwoField');
end;
end;

function GetValueByOtherField(var table:TADOQuery;setField,setFieldValue,GetField:string):variant;
begin
 if not table.Active then table.Open;
 table.First;
 if  table.Locate(setField,setFieldValue,[loCaseInsensitive,loPartialKey]) then
 result:=table.FieldByName(GetField).Value
 else
 result:='Null';
end;

procedure ComboboxAddItems(var table:tadotable;Fieldname:string;var Combobox:TComboBox);
begin
 Combobox.Clear;
 if not table.Active then table.Open;
 table.First;
 while not table.Eof do
 begin
  Combobox.Items.Add(table.FieldByName(Fieldname).Value);
  table.Next;
 end;
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



procedure Updatetable(tablename,PrimaryName,PrimaryValue,Fieldname,FieldValue:string;var adocommand:tadocommand);
var
 sql:string;
begin
 sql:='update '+tablename+' set '+fieldname+'='+quotedstr(Fieldvalue)+' where '+PrimaryName+'='+quotedstr(PrimaryValue);
 adocommand.CommandText:=sql;
 adocommand.Execute;
end;

// �ڱ�����һ���ض��ֶβ�������һ�е���һ���ֶε�ֵ
function GetValueByOtherField(var table:TADOTable;setField,setFieldValue,GetField:string):variant;
begin
 if not table.Active then table.Open;
 table.First;
 if  table.Locate(setField,setFieldValue,[loCaseInsensitive,loPartialKey]) then
 result:=table.FieldByName(GetField).Value
 else
 result:='Null';
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
    stringlist.add(temps);
    adoquery.Next;
  end;
  stringlist.Sort;
  adoquery.Close;
end;

Procedure AlterTable(var tableBI:TADOTable;var tableI:TADOTable;var adocommand:tadocommand);
var
  Altersql,Valuesql,sql:string;
  fi:integer;
  IsNewField,HaveNewField:boolean;
begin
  Altersql:=' alter table '+tableI.TableName+' add column ';
  Valuesql:='';
  tableI.Close;
  tablebi.Close;
  if not tableI.Active then tableI.Open;
  if not tableBI.Active then tablebi.Open;
  tablebi.First;
  while not tableBI.Eof do
  begin
   fi:=0;
   IsNewField:=true;
   HaveNewField:=false;
   while fi<=tableI.FieldCount-1  do
   begin
      if (trim(tableBI.FieldByName('DBfieldname').Value)=tableI.Fields[fi].FieldName)
      or (trim(tableBI.FieldByName('DBfieldname').Value)='DoesNotHandle')
      or (trim(tableBI.FieldByName('DBfieldname').Value)='') then
      begin
        IsNewField:=false;
        break;
      end;
      HaveNewField:=true;
      fi:=fi+1;
   end;
   if IsNewField  then
   begin
     if ValueSql<>'' then
     begin
      Valuesql:= valuesql
                 +','
                 +tableBI.FieldByName('dbfieldname').Value+' '
                 +tableBI.FieldByName('datatype').Value

     end
      else
     begin
      Valuesql:=  tableBI.FieldByName('dbfieldname').Value+' '
                 +tableBI.FieldByName('datatype').Value;

     end;

   end;
   tablebi.Next;
  end;
  if trim(Valuesql)<>'' then
  begin
    adocommand.CommandText:=Altersql+ValueSql;
    adocommand.Execute;
  end;
  tableI.Close;
  tableI.Open;
end;



//��߳���ĵ��ٶ�,ˢ�¶�����Ϣ �����¶��ձ��еĶ�����Ϣ��ԭ��Ļ������޸ı�ṹ
Procedure AlterTable(var tableBI:tadoquery;var tableI:tadotable;var adocommand:tadocommand);
var
  Altersql,Valuesql,sql:string;
  fi:integer;
  IsNewField,HaveNewField:boolean;
begin
  Altersql:=' alter table '+tableI.TableName+' add column ';
  Valuesql:='';
  tableI.Close;
  tablebi.Close;
  if not tableI.Active then tableI.Open;
  if not tableBI.Active then tablebi.Open;
  tablebi.First;
  while not tableBI.Eof do
  begin
   fi:=0;
   IsNewField:=true;
   HaveNewField:=false;
   while fi<=tableI.FieldCount-1  do
   begin
      if (trim(tableBI.FieldByName('DBfieldname').Value)=tableI.Fields[fi].FieldName)
      or (trim(tableBI.FieldByName('DBfieldname').Value)='DoesNotHandle')
      or (trim(tableBI.FieldByName('DBfieldname').Value)='') then
      begin
        IsNewField:=false;
        break;
      end;
      HaveNewField:=true;
      fi:=fi+1;
   end;
   if IsNewField  then
   begin
     if ValueSql<>'' then
     begin
      Valuesql:= valuesql
                 +','
                 +tableBI.FieldByName('dbfieldname').Value+' '
                 +tableBI.FieldByName('datatype').Value

     end
      else
     begin
      Valuesql:=  tableBI.FieldByName('dbfieldname').Value+' '
                 +tableBI.FieldByName('datatype').Value;

     end;

   end;
   tablebi.Next;
  end;
  if trim(Valuesql)<>'' then
  begin
    adocommand.CommandText:=Altersql+ValueSql;
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
  else if datatype='����' then  TDT:='date'
  else if datatype='����' then  TDT:='varchar(73)';
  sql:='insert into comparefields(fieldname,fielddesc,datatype) values('
  +quotedstr(fieldname)+','
  +quotedstr(fielddesc)+','
  +quotedstr(tdt)+')';
  adocommand.CommandText:=sql;
  adocommand.Execute;
  result:=true;
end;




function AutoMatch(var comparefields, mapcol: TADOTable): boolean;
var
  n,iz: integer;
begin
  comparefields.Open;
  comparefields.Filtered := false;
  mapcol.First;
  result := true;
  while not mapcol.eof do
  begin
    if comparefields.Locate('XlsColName',
      mapcol.FieldByName('XlsColName').AsString, [loCaseInsensitive]) then
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
  iz:=0;
  mapcol.First;
  while not mapcol.eof do
  begin
    if trim(mapcol.FieldByName('DBFieldDesc').AsString) = '����' then
      n := n + 1;
    if trim(mapcol.FieldByName('DBFieldDesc').AsString) = 'ǰ�������ۼ�עˮ��' then
      iz := iz + 1;
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
    if iz >= 2 then
  begin
      mapcol.First;
    if mapcol.Locate('DBFieldDesc', 'ǰ�������ۼ�עˮ��', [loPartialKey])then
      mapcol.Locate('DBFieldDesc', 'ǰ�������ۼ�עˮ��', [loPartialKey]);
      mapcol.Edit;
      mapcol.FieldByName('DBFieldDesc').AsString := '���������ۼ�עˮ��';
      mapcol.FieldByName('DBFieldName').AsString := 'TodayZSL';
      mapcol.FieldByName('datatype').AsString := 'float';
      mapcol.Post;
  end;


//  if result = false then
//    showmessage('�Զ�ƥ��δ���,���ֶ�ƥ��');
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
      mapcol.FieldByName('XlsColName').AsString, [loCaseInsensitive]) then
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




// ADD Table's name to combobox
procedure ComboboxAddTablename(var adoquery: tadoquery;
  var combobox: tcombobox);
var
  sqlstr: string;
begin // and name not in('log','mapcol','comparefields','comparefieldsbackup')
  sqlstr :=SqlTables
    + 'and name not in(' + quotedstr('log') + ',' + quotedstr('mapcol')
    + ',' + quotedstr('comparefields') + ','+ quotedstr('MapSheets') + ','+ quotedstr('XLSSchema') + ',' + quotedstr
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

procedure craetetable(tablename: string; var mapcol: TADOTable;var adocommand: tadocommand);
var
  sqlstr: string;
  sqladd:string;
begin
  if trim(tablename) = '' then
  begin
    showmessage('Tatget Table Can not be empty');
    exit;
  end;
  sqlstr := 'create table ' + trim(tablename) + '(';
  mapcol.Open;
  mapcol.First;
  while not mapcol.eof do
  if (trim(vartostr(mapcol.FieldByName('dbfieldname').Value))='DoesNotHandle')
  or (trim(vartostr(mapcol.FieldByName('dbfieldname').Value))='') then
  begin
   mapcol.Next;
   continue;
  end else
  begin
    sqlstr := sqlstr + mapcol.FieldByName('dbfieldname').Value
            + ' '
            + mapcol.FieldByName('datatype').Value + ',';
      mapcol.Next;
  end;
 try
  //warter_well_no varchar(30) null,oil_well_no varchar(30) null,
  sqlstr:=sqlstr+'BiaoGeMingCheng varchar(30),InputDate date,' +
    'DEPNAME varchar(30),WELLNAMEC varchar(30),WELLNAMEB varchar(30),ICHK yesno,iSel yesno,USERNAME varchar(30)'+ ')';
  adocommand.CommandText := sqlstr;
  adocommand.Execute;
 except on E:exception do
    showmessage('create table ����� '+e.Message);
 end;
end;


procedure craetetable(tablename: string; var mapcol: tadoquery;var adocommand: tadocommand);
var
  sqlstr: string;
  sqladd:string;
begin
  if trim(tablename) = '' then
  begin
    showmessage('Tatget Table Can not be empty');
    exit;
  end;
  sqlstr := 'create table ' + trim(tablename) + '( ';
  mapcol.Open;
  mapcol.First;
  while not mapcol.eof do
  if trim(vartostr(mapcol.FieldByName('dbfieldname').Value))='DoesNotHandle' then
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
  sqlstr:=sqlstr+'BiaoGeMingCheng varchar(30),InputDate date,' +
    'SchemaName varchar(30),InputUser varchar(30)'+ ')';
  adocommand.CommandText := sqlstr;
  adocommand.Execute;
 except on exception do
    showmessage('������ʧ��');
 end;
end;
end.
