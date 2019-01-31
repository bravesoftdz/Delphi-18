unit ConfigINI;

interface

uses IniFiles;

type
  TConfigINI = class(TObject)
  private
    FConfigINI: TINIFile;
  public
    sHostName: string;
    iPort: Integer;
    sDBUser: string;
    sDBPass: string;
    sDataBase: string;
    sSQLFile: string;
    sSQLPass: string;
    iServer: string;
    iServerEx: Integer;
    iRule: Integer;
    constructor Create(FileName: string);
    destructor Destroy;override;
  end;

var
  objINI: TConfigINI;

implementation

{ TConfigINI }

constructor TConfigINI.Create(FileName: string);
var
  Section,Ident: string;
begin
  FConfigINI := TINIFile.Create(FileName);
  Section := '��������';
  Ident := 'Mysql��ַ';
  sHostName := FConfigINI.ReadString(Section,Ident,'localhost');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sHostName);
  Ident := 'Mysql�˿�';
  iPort := FConfigINI.ReadInteger(Section,Ident,3306);
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteInteger(Section,Ident,iPort);
  Ident := '��¼�û�';
  sDBUser := FConfigINI.ReadString(Section,Ident,'root');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sDBUser);
  Ident := '��¼����';
  sDBPass := FConfigINI.ReadString(Section,Ident,'');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sDBPass);
  Ident := '���ݿ�';
  sDataBase := FConfigINI.ReadString(Section,Ident,'');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sDataBase);
  Ident := '�ű��ļ�';
  sSQLFile := FConfigINI.ReadString(Section,Ident,'');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sSQLFile);
  Ident := '�ű��ļ�����';
  sSQLPass := FConfigINI.ReadString(Section,Ident,'');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,sSQLPass);
  Ident := '������ID';
  iServer := FConfigINI.ReadString(Section,Ident,'0');
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteString(Section,Ident,iServer);
  Ident := '����ID';
  iServerEx := FConfigINI.ReadInteger(Section,Ident,0);
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteInteger(Section,Ident,iServerEx);
  Ident := '��������';
  iRule := FConfigINI.ReadInteger(Section,Ident,0);
  if not FConfigINI.ValueExists(Section,Ident) then
    FConfigINI.WriteInteger(Section,Ident,iRule);
end;

destructor TConfigINI.Destroy;
begin
  FConfigINI.Free;
  inherited Destroy;
end;

end.

