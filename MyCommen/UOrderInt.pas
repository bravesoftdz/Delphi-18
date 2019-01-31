unit UOrderInt;

interface
uses SysUtils;


//ʮ���� ת ��ʮ������
function Int64ToHex26(n: Int64): string;
//��ʮ������ ת ʮ����
function Hex26ToNumber(s: string): Int64;
//��int ת���� ��������ʽ��ʾ
Function Str_IntToBin(Int: LongInt; Size: Integer): String;


implementation

//��int ת���� ��������ʽ��ʾ
Function Str_IntToBin(Int: LongInt; Size: Integer): String;
Var
  i: Integer;
Begin
  If Size < 1 Then Exit;
  For i := Size Downto 1 Do
    Begin
      If Int And (1 Shl (Size - i)) <> 0 Then
        Result := '1' + Result
      Else
        Result := '0' + Result;
    End;
End;

//ʮ���� ת ��ʮ������
function Int64ToHex26(n: Int64): string;
var
  m: Int64;
begin
  Result := '';
  while n > 0 do
  begin
    m := n mod 26;
    if m = 0 then m := 26;
    Result := char(m + 64) + Result;
    n := (n - m) div 26;
  end;
end;
//��ʮ������ ת ʮ����
function Hex26ToNumber(s: string): Int64;
var
  I: Integer;
  J: Int64;
  bRes: Boolean;
begin
  Result := 0;
  if Trim(s) = '' then Exit;
  bRes := True;
  for I := 1 to Length(s) do
  begin
    if not (S[i] in ['A'..'Z']) then
    begin
      bRes := False;
      break;
    end;
  end;
  if bRes then
  begin
    J := 1;
    for I := Length(s) downto 1 do
    begin
      Result := Result + (Ord(s[I])-64) * J;
      J := J * 26;
    end;
  end;
end;

end.
