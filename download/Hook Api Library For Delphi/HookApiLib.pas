{
  Hook Api Library 0.2 [Ring3] By Anskya
  Email:Anskya@Gmail.com
  ring3 inline hook For Api

Thank:
  ǰ29A����Ҳһֱ�����ҵ�ż��...z0mbie��ţ...����Ĥ��һ��
  ʹ�õ�LDE32�����Ƿ��������˼ҵ�...C->Delphi...


˵��:
  1.���ö�ջ��ת
  û��ʹ�ô�ͳ��jmp xxxx ����ת,ʹ����������push xxxx+ret
  ��ϸ�������������...��װ���.

  2.�ڴ油���ṹ:
  ����1:|push xxx--���Ӵ������|ret|
  ����2:|����ԭʼ������ַ|����ԭʼ��ַ���볤��|ԭʼ��ַ�Ĵ���|push xxxxxx|ret|

����˵��:
  0.2:
    ֧��Ring0 Inline Hook
  0.1:
    Ring3 Inline Hook
}
unit HookApiLib;

interface

//{$DEFINE Ring0}

uses
  LDE32,
{$IFDEF Ring0}
  ntddk
{$ELSE}
  Windows
{$ENDIF}
  ;

function HookCode(OldProc, NewProc: Pointer): Pointer;
function UnHookCode(TargetProc: Pointer): Boolean;

implementation

type
  LPfar_jmp = ^_far_jmp;
  _far_jmp = packed record
    PushOpCode: BYTE;
    PushArg: Pointer;
    RetOpCode: BYTE;
  end;
  Tfar_jmp = _far_jmp;

function HookCode(OldProc, NewProc: Pointer): Pointer;
var
  lpFuncProc, lpInlineProc: Pointer;
  InlineLen, OpcodeLen: DWORD;
  stfar_jmp_hook: Tfar_jmp;
  OldProtect: DWORD;
begin
  Result := nil;
  if ((OldProc = nil) or (NewProc = nil)) then Exit;

  InlineLen := 0;
  lpFuncProc := OldProc;

  while (InlineLen < SizeOf(Tfar_jmp)) do
  begin
    GetInstLenght(lpFuncProc, @OpcodeLen);
    lpFuncProc := Pointer(ULONG(lpFuncProc) + OpcodeLen);
    InlineLen := InlineLen + OpcodeLen;
  end;

  stfar_jmp_hook.PushOpCode := $68;
  stfar_jmp_hook.PushArg := NewProc;
  stfar_jmp_hook.RetOpCode := $C3;

{$IFDEF Ring0}
  lpInlineProc := ExAllocatePoolWithTag(NonPagedPool, 8 + InlineLen  + SizeOf(Tfar_jmp), PoolWithTag);
{$ELSE}
  lpInlineProc := Pointer(GlobalAlloc(GMEM_FIXED, SizeOf(Pointer) + SizeOf(ULONG) + InlineLen  + SizeOf(Tfar_jmp)));
{$ENDIF}

  if (lpInlineProc = nil) then Exit;
  
  PPointer(lpInlineProc)^ := OldProc;
  Inc(PBYTE(lpInlineProc), SizeOf(Pointer));

  PULONG(lpInlineProc)^ := InlineLen;
  Inc(PBYTE(lpInlineProc), SizeOf(ULONG));

{$IFDEF Ring0}
  memcpy(lpInlineProc, OldProc, InlineLen);
{$ELSE}
  CopyMemory(lpInlineProc, OldProc, InlineLen);
{$ENDIF}
  Inc(PBYTE(lpInlineProc), InlineLen);
  //  ��д��ת����
  with LPfar_jmp(lpInlineProc)^ do
  begin
    PushOpCode := $68;
    PushArg := Pointer(ULONG(OldProc) + InlineLen);
    RetOpCode := $C3;
  end;

{$IFDEF Ring0}
  //  ��ʼǶ��Hook
  if NT_SUCCESS(WriteReadOnlyMemoryMark(OldProc, @stfar_jmp_hook, SizeOf(Tfar_jmp))) then
  begin
    Result := Pointer(ULONG(lpInlineProc) - InlineLen);
  end else
  begin
    ExFreePoolWithTag(lpInlineProc, PoolWithTag);
    Result := nil;
  end;  
{$ELSE}
  //  ʹ�ڴ��д
  VirtualProtect(OldProc, SizeOf(Tfar_jmp), PAGE_EXECUTE_READWRITE, OldProtect);
  //  д����ת����
  CopyMemory(OldProc, @stfar_jmp_hook, SizeOf(Tfar_jmp));
  Result := Pointer(ULONG(lpInlineProc) - InlineLen);
  //  д��ԭ����
  VirtualProtect(OldProc, SizeOf(Tfar_jmp), OldProtect, OldProtect);
{$ENDIF}
end;

function UnHookCode(TargetProc: Pointer): Boolean;
var
  lpFuncProc, lpInlineProc: Pointer;
  InlineLen: ULONG;
  OldProtect: ULONG;
begin
  Result := False;
  if (TargetProc = nil) then Exit;
  lpInlineProc := TargetProc;
  Dec(PBYTE(lpInlineProc), SizeOf(Pointer) + SizeOf(ULONG));

  lpFuncProc := PPointer(lpInlineProc)^;
  Inc(PBYTE(lpInlineProc), SizeOf(Pointer));

  InlineLen := PULONG(lpInlineProc)^;
  Inc(PBYTE(lpInlineProc), SizeOf(ULONG));

{$IFDEF Ring0}
  //  ��ʼ���Hook
  if NT_SUCCESS(WriteReadOnlyMemoryMark(lpFuncProc, TargetProc, InlineLen)) then
  begin
    Dec(PBYTE(lpInlineProc), SizeOf(Pointer) + SizeOf(ULONG));
    ExFreePoolWithTag(lpInlineProc, PoolWithTag);
    Result := True;
  end;  
{$ELSE}
  //  ʹ�ڴ��д
  VirtualProtect(lpFuncProc, InlineLen, PAGE_EXECUTE_READWRITE, OldProtect);
  //  д��ԭ������
  CopyMemory(lpFuncProc, TargetProc, InlineLen);
  Dec(PBYTE(lpInlineProc), SizeOf(Pointer) + SizeOf(ULONG));

  GlobalFree(ULONG(lpInlineProc));
  Result := True;
  //  д��ԭ����
  VirtualProtect(lpFuncProc, InlineLen, OldProtect, OldProtect);
{$ENDIF}
end;

end.
