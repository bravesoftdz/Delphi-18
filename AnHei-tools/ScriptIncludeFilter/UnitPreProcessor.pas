unit UnitPreProcessor;

(****************************************************************

                   ͨ��LUA�ű��ı�����Ԥ������

    ����LUA�ʷ������������д����ı�Ԥ����Ĺ�������ʵ����������Ҫ�õ����������
  ����C���Ե�Ԥ�����ܣ�����ṩ�������ڶԽű��ı����ݽ��м򵥵�Ԥ����Ϊ��ʹ
  Ԥ����ָ��Ĵ����﷨����lua�﷨������������HTML����дJavaScript����ķ�ʽ��
  ʹ��ԭ�����Ե�ע���﷨ʵ��Ԥ�����﷨����luaԤ��������Ԥ����ָ����﷨�������£�
  --#directive implemente data
    ����Ԥ����ָ��������п�ʼ�ĵ�һ���ַ�����д��һ��Ԥ����ָ��ó���һ�С�Ԥ
  ����ָ���ǲ����ִ�Сд�ġ�

  Ԥ����Ŀǰʵ�������й��ܣ�
    1�������ļ�������ʹ�á�--#include "FilePath"��������һ�������ļ���
	  �����ļ�������˳�������ȴӵ�ǰ�ļ���Ŀ¼��ʼʹ�����·������������Ҳ���
	  �ļ�����Ԥ��Ĵ����ļ�����Ŀ¼�н���������Ŀ¼�������������ָ�����֧��
	  �����ճ���Ϊ1024���ַ���·�����д���

****************************************************************)

interface

uses
  Windows, SysUtils, Classes, Contnrs;

type                         
	//Ԥ��������������
  PPreProcParseEnvir = ^TPreProcParseEnvir;
  TPreProcParseEnvir = record
    sParsePtr     : PAnsiChar;
    sNewLinePtr   : PAnsiChar;
    sLineEndPtr   : PAnsiChar;
    cCharAtLineEnd: AnsiChar;
  end;

  TLineRange = class
  public
    sFileName: string;
    nStart : Integer;
    nEnd   : Integer;
  end;

  TCustomLuaPreProcessor = class(TMemoryStream)
  protected                            
    m_ParseEnvir      : TPreProcParseEnvir;		//��ǰ��������
    m_ParseEnvirStack : TStack;             	//Ԥ������������������б�����ȳ�
    m_IncludeDirList  : TStrings;             //������Ԥ���Ԥ��������ļ�����Ŀ¼�б�
	  m_FilePathStack   : TStrings;	            //Ԥ�����������ļ�����ջ������ȳ�
    m_LineRangeList   : TObjectList;          //�з�Χ��¼�б�
	  m_NewLineChar     : AnsiChar;		          //���з���Ĭ����'\n'
    m_LineNo          : Integer;              //��ǰд�����ݵ��к�
  public
    constructor Create();virtual;
    destructor Destroy();override;

    (* ������ű����ݽ���Ԥ����
     *sSourceText	�����ַ�����ʼָ�룬�����ַ���������0��β��
     *sFilePath		���������ļ������ļ���������·�������ڽ������Ȱ���Ŀ¼����
     *cNewLine		�����ַ���Ĭ��ֵΪ'\n'
     *@return ���ش������ַ���ָ�룬�ַ�����Ԥ���������ٻ�����´η���֮ǰһֱ��Ч
     *)
    function parse(sSourceText: PAnsiChar; sFilePath: String; const cNewLine: AnsiChar  = #10):PAnsiChar;
    //��Ӱ����ļ�����Ŀ¼
    procedure addIncludeDirectory(sPath: string);
	  //��հ����ļ�����Ŀ¼
	  procedure clearIncludeDirectory();
    //��ȡ�ж�Ӧ���ļ�·���Լ������к�
    function getLineFileInfo(const nLineNo: Integer): TLineRange;

  protected
	  (* ������ǰ�������ڲ����µ�����ű����ݽ���Ԥ����
	  *sSourceText	�����ַ�����ʼָ�룬�����ַ���������0��β��
	  *)
	  function ParseSource(sSourceText: PAnsiChar): PAnsiChar;
	  //���浱ǰԤ��������������������������ѹ�뻷��ջ��
	  procedure SaveParseEnvir();
	  //�ָ���һ��Ԥ�����������������ָ���ɾ��ջ���ķ�����������
	  procedure RestorsParseEnvir();
    //�����ԡ�--#���ı���ͷ��Ԥ������
    procedure ProcessLine(sLineText: PAnsiChar);
    (* ����ִ��Ԥ����ָ��Ĺ���
     * ���������Ҫ����ʵ�ָ����Ԥ����ָ����޸�����Ԥ����ָ���ʵ�ֹ�������Ը��Ǵ˺���
     *)
    procedure ProcessDirective(sDirective: PAnsiChar; sData: PAnsiChar);
    //��#includeԤ����ָ��ܵ�ʵ��
    procedure DirectiveOfInclude(sData: PAnsiChar);

  protected
    function Realloc(var NewCapacity: Longint): Pointer; override;

  private
    (* ������ǰ�������ڲ����µ�����ű����ݽ���Ԥ����
     * ��������ǰ��ȡ�ô����ļ���Ŀ¼��ѹ��Ԥ�����������ļ�����ջ�У��������ջ�н�Ŀ¼�Ƴ�
     *sSourceText	�����ַ�����ʼָ�룬�����ַ���������0��β��
     *sFillFilePath	�����ļ�������·��
     *)
    function SaveFileDirAndParse(sSourceText: PAnsiChar; sFullFilePath: String): PAnsiChar;
    //���������ذ����ļ�
    function SearchAndLoadIncludeFile(sIncludeFileName: PAnsiChar): Boolean;
    //���ز����������ļ�
    function LoadIncludeFile(sIncludeFilePath: string): Boolean;
    
  end;


implementation

uses FuncUtil;

function GetFileNamePart(sFullFilePath: PAnsiChar): PAnsiChar;
begin
  Result := sFullFilePath;
  while sFullFilePath^ <> #0 do
  begin
    if (sFullFilePath^ = '/') or (sFullFilePath^ = '\') then
      Result := sFullFilePath + 1;
    Inc(sFullFilePath);
  end;
end;

{ TCustomLuaPreProcessor }

procedure TCustomLuaPreProcessor.addIncludeDirectory(sPath: string);
begin       
  m_IncludeDirList.add(sPath);
end;

procedure TCustomLuaPreProcessor.clearIncludeDirectory;
begin
  m_IncludeDirList.Clear();
end;

constructor TCustomLuaPreProcessor.Create;
begin
  inherited;
  m_NewLineChar := #10;
  m_ParseEnvirStack := TStack.Create;
  m_IncludeDirList := TStringList.Create;
  m_FilePathStack := TStringList.Create;
  m_LineRangeList := TObjectList.Create;
end;

destructor TCustomLuaPreProcessor.Destroy;
begin
  m_IncludeDirList.Free;
  m_FilePathStack.Free;
  m_ParseEnvirStack.Free;
  m_LineRangeList.Free;
  inherited;
end;

procedure TCustomLuaPreProcessor.DirectiveOfInclude(sData: PAnsiChar);
var
  sFile: array [0..1023] of AnsiChar;
  sPtr: PAnsiChar;
  dwSize: DWord;
begin
	//ȡ�������ļ�������֮�ڵ��ļ�����
	if ( sData^ <> '"') then Exit;

	Inc(sData);
	if ( sData^ = '"' ) then Exit;

  sPtr := strchr(sData, '"');
  if sPtr = nil then Exit;

	//���ļ���������sFile��������
	dwSize := sPtr - sData;
	if ( dwSize > sizeof(sFile) div sizeof(sFile[0]) -1 ) then
		dwSize := sizeof(sFile) div sizeof(sFile[0]) -1;
	StrLCopy(sFile, sData, dwSize);
	sFile[dwSize] := #0;
	SearchAndLoadIncludeFile(sFile);
end;

function TCustomLuaPreProcessor.getLineFileInfo(const nLineNo: Integer): TLineRange;
var
  I: Integer;
  Line: TLineRange;
begin
  Result := nil;
  for I := 0 to m_LineRangeList.Count - 1 do
  begin
    Line := m_LineRangeList[I] as TLineRange;
    if Line.nStart <= nLineNo then
      Result := Line;
  end;
end;

function TCustomLuaPreProcessor.LoadIncludeFile(
  sIncludeFilePath: string): Boolean;
var
  ms: TMemoryStream;
  dwSize: Int64;
begin
  ms := TMemoryStream.Create;
  try
    ms.LoadFromFile(sIncludeFilePath);
    dwSize := ms.Size;
    ms.SetSize(dwSize + sizeof(Integer));
    PChar(ms.Memory)[dwSize] := #0;
	  SaveParseEnvir();  
	  SaveFileDirAndParse(ms.Memory, sIncludeFilePath);
	  RestorsParseEnvir();
    Result := True;
  finally
    ms.Free;
  end;
end;

function TCustomLuaPreProcessor.parse(sSourceText: PAnsiChar; sFilePath: String;
  const cNewLine: AnsiChar): PAnsiChar;
begin
	SetSize(0);
  m_LineNo := 0;
	m_NewLineChar := cNewLine;
  m_LineRangeList.Clear;
	Result := SaveFileDirAndParse(sSourceText, sFilePath);
end;

function TCustomLuaPreProcessor.ParseSource(sSourceText: PAnsiChar): PAnsiChar;
const
  cEndChar: AnsiChar = #0;
var
  dwPos, dwSize: Int64;
begin
	dwPos := Position;            
  //����UTF-8 BOM
  if ( (PInteger(sSourceText)^ and $00FFFFFF) = $00BFBBEF ) then
    Inc(sSourceText, 3);
	m_ParseEnvir.sParsePtr := sSourceText;
	while ( m_ParseEnvir.sParsePtr^ <> #0 ) do
  begin
		m_ParseEnvir.sNewLinePtr := strchr(m_ParseEnvir.sParsePtr, m_NewLineChar);
		//��λ����λ��
		if ( m_ParseEnvir.sNewLinePtr <> nil ) then
    begin
			m_ParseEnvir.sLineEndPtr := m_ParseEnvir.sNewLinePtr - 1;
			Inc(m_ParseEnvir.sNewLinePtr);//���������ַ�
		end
    else begin
			m_ParseEnvir.sNewLinePtr := m_ParseEnvir.sParsePtr + strlen(m_ParseEnvir.sParsePtr);
			m_ParseEnvir.sLineEndPtr := m_ParseEnvir.sNewLinePtr - 1;
		end;
		//��λ��ǰ��β������\n\r�Լ��Ʊ��
		while ((m_ParseEnvir.sLineEndPtr >= m_ParseEnvir.sParsePtr) and (m_ParseEnvir.sLineEndPtr < #$20)) do
		begin
			Dec(m_ParseEnvir.sLineEndPtr);
    end;
  
		if ( m_ParseEnvir.sLineEndPtr >= m_ParseEnvir.sParsePtr ) then
    begin
			//��ֹ��β��Ч�ַ�֮��ĺ�һ���ַ�
			Inc(m_ParseEnvir.sLineEndPtr);
			m_ParseEnvir.cCharAtLineEnd := m_ParseEnvir.sLineEndPtr^;
			m_ParseEnvir.sLineEndPtr^ := #0;
			//�����������ı��У����ǰ3���ַ�Ԥ����ָ���ַ���--#�������Ԥ��������ֱ��д���ı�����
			if ( StrLIComp(m_ParseEnvir.sParsePtr, '--#', 3) = 0 ) then
			begin
				ProcessLine(m_ParseEnvir.sParsePtr);
			end
			else begin
				Write(m_ParseEnvir.sParsePtr^, m_ParseEnvir.sLineEndPtr - m_ParseEnvir.sParsePtr);
				//�ڴ�����д�뻻�з�
				Write(m_NewLineChar, sizeof(m_NewLineChar));
        //����Դ�ļ��к�
        Inc(m_LineNo);
			end;
			//�ָ�����ֹ���ַ�
			m_ParseEnvir.sLineEndPtr^ := m_ParseEnvir.cCharAtLineEnd; 
		end
    else begin
      //�ڴ�����д�뻻�з�
      Write(m_NewLineChar, sizeof(m_NewLineChar));
      //����Դ�ļ��к�
      Inc(m_LineNo);
    end;
		//�����봦��ָ���������һ��
		m_ParseEnvir.sParsePtr := m_ParseEnvir.sNewLinePtr;
	end;
           
  dwSize := Size;
	if dwSize > 0 then
  begin
    Write(cEndChar, sizeof(cEndChar));  //д����ֹ��
    SetSize(dwSize);
    Result := PChar(Memory) + dwPos;
  end
  else Result := '';
end;

procedure TCustomLuaPreProcessor.ProcessDirective(sDirective, sData: PAnsiChar);
begin
	//�����ļ�����ָ��--#include
	if ( StrLIComp(sDirective, 'include', 7) = 0 ) then
	begin
		DirectiveOfInclude(sData);
	end;
end;

procedure TCustomLuaPreProcessor.ProcessLine(sLineText: PAnsiChar);
var
  nIdx: Integer;
  sDirective: array [0..127] of AnsiChar;
begin
	//ȡ��Ԥ����ָ���Լ�ָ������
	Inc(sLineText, 3);//����--#
  nIdx := 0;
	while (nIdx < sizeof(sDirective) div sizeof(sDirective[0]) -1) do
	begin
		if ( (sLineText^ = #0) or (sLineText^ <= #$20) ) then
			break;
		sDirective[nIdx] := sLineText^;
		Inc(sLineText);
		Inc(nIdx);
	end;
	if ( nIdx > 0 ) then
	begin
		sDirective[nIdx] := #0;
		//����Ԥ����ָ�����ݲ��ֿ�ͷ�Ĳ��ɼ��ַ�
		while (sLineText^ <> #0) and (sLineText^ <= #$20) do
			Inc(sLineText);
		//ִ��Ԥ����ָ��
		ProcessDirective(sDirective, sLineText);
	end;
end;

function TCustomLuaPreProcessor.Realloc(var NewCapacity: Integer): Pointer;
begin
  if NewCapacity = 0 then
  begin
    Result := Inherited Realloc(NewCapacity);
  end
  else begin
    //����4���ֽ�������д�ַ�����ֹ��
    NewCapacity := NewCapacity + sizeof(Integer);
    Result := Inherited Realloc(NewCapacity);
    Dec(NewCapacity, sizeof(Integer));
    PAnsiChar(Result)[NewCapacity] := #0;
  end;
end;

procedure TCustomLuaPreProcessor.RestorsParseEnvir;
var
  pEnvir: PPreProcParseEnvir;
begin
  pEnvir := m_ParseEnvirStack.Pop();
  m_ParseEnvir := pEnvir^;
  Dispose(pEnvir);
end;

function TCustomLuaPreProcessor.SaveFileDirAndParse(sSourceText: PAnsiChar;
  sFullFilePath: String): PAnsiChar;
var
  Line: TLineRange;
begin
	//�����ļ�·���ַ�������·��ѹ��Ԥ�����������ļ�����ջ
	m_FilePathStack.add(ExtRactFilePath(sFullFilePath));

  Line := TLineRange.Create;
  Line.sFileName := sFullFilePath;
  Line.nStart := m_LineNo;
  m_LineRangeList.Add(Line);

	//�����ļ��еĴ���
	Result := ParseSource(sSourceText);
  Line.nEnd := m_LineNo - 1;

	//��Ԥ�����������ļ�����ջ�ӵ����ļ�·��
	m_FilePathStack.Delete(m_FilePathStack.Count - 1);
end;

procedure TCustomLuaPreProcessor.SaveParseEnvir;  
var
  pEnvir: PPreProcParseEnvir;
begin
  New(pEnvir);
  pEnvir^ := m_ParseEnvir;
  m_ParseEnvirStack.push(pEnvir);
end;

function TCustomLuaPreProcessor.SearchAndLoadIncludeFile(
  sIncludeFileName: PAnsiChar): Boolean;
var
  sPath: string;
  i, nCount: Integer;
begin
  Result := False;
	//��ʼ�����ļ������ȴӵ�ǰ�ļ���Ŀ¼��ʼ����
	nCount := m_FilePathStack.Count;
	if ( nCount > 0 ) then
	begin
		Dec(nCount);
		sPath := m_FilePathStack[nCount] + sIncludeFileName;
    sPath := ExpandFileName(sPath);
		if ( FileExists(sPath) ) then
		begin
			Result := LoadIncludeFile(sPath);
      Exit;
    end;
  end;
	//�޷��ӵ�ǰ�ļ���Ŀ¼�ҵ��ļ���Ӱ����ļ�Ŀ¼�б��н���ѭ������
	for i := m_IncludeDirList.Count-1 downto 0 do
  begin
		sPath := m_IncludeDirList[i] + sIncludeFileName;
    sPath := ExpandFileName(sPath);
		if ( FileExists(sPath) ) then
		begin
			Result := LoadIncludeFile(sPath);
      Exit;
    end;
  end;
	//����ļ���Ϊ����·���е��ļ�
	if ( FileExists(sIncludeFileName) ) then
  begin
    Result := LoadIncludeFile(sPath);
    Exit;
  end;
end;

end.
