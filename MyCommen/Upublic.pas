unit Upublic;
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
  Dialogs, StdCtrls,  ComCtrls, DirOutln, DB,DBCtrls, Buttons, ADODB;

type
  FieldMap = record
    FieldName: string;
    ColIndex: integer;
  end;


procedure ComboboxAddTablename(var adoquery: tadoquery;var combobox: tcombobox);
function AutoMatch(var comparefields, mapcol: tadoquery): boolean;
// procedure ComboboxAddItems(var comparefields,mapcol:tadoquery);
procedure DropTable(Tablename:string;var adocommand:tadocommand);
function AppendCompare(fieldname,fielddesc,datatype:string;var adocommand:tadocommand):boolean;
Procedure AlterTable(var tableBI:tadoquery;var tableI:tadotable;var adocommand:tadocommand);
procedure craetetable(tablename: string; var mapcol: tadoquery;var adocommand: tadocommand);
function GetValueByOtherField(var table:tadoquery;setField,setFieldValue,GetField:string):variant;
procedure SetStringListByFieldName(var stringlist:tstringlist;var adoquery:tadoquery;Fieldname:string);

var
  ExcelApp: variant;

implementation


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
