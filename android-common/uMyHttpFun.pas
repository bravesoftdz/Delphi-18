unit uMyHttpFun;

interface
uses
  System.SysUtils, System.Classes, Data.Cloud.CloudAPI;

  function Base64Encode(const convertStr:String):String;
  function Base64Decode(const convertStr:String):String;
  function UrlParams(const AParam, AUrl:string):string;
implementation
{
  ���ã�Base64Encode��������
  ������ת���ַ���
  ����: base64�ַ���
}
function Base64Encode(const convertStr:String):String;
begin
  if (convertStr='') then begin  //ת��Ϊ�գ��˳�
    result:= '';
    exit;
  end;

  result:= Encode64(convertStr);
end;

{
  ���ã�Base64Decode��������
  ������base64�ַ���
  ����: ԭ�ַ���
}
function Base64Decode(const convertStr:String):String;
begin
  if (convertStr='') then begin  //ת��Ϊ�գ��˳�
    result:= '';
    exit;
  end;

  result:= Decode64(convertStr);
end;


{
  ���ã���ȡURL����
  ������AUrl��ַ�� ALocalPath��Ҫ�ļ�·��
  ����: ��
}
function UrlParams(const AParam, AUrl:string):string;
var
  p:Integer;
begin
  Result := '';
  p := Pos(AParam,AUrl);
  if P > 0 then begin
    Inc(p, Length(AParam));
    while (p<=length(AUrl)) and (AUrl[p]<>'&') do begin
      Result := Result + AUrl[p];
      Inc(p);
    end;
  end;
  //�������Ϊ�գ��򷵻�url
  if Result='' then Result := AUrl;
end;

end.
