unit ConfigINI;

interface

uses IniFiles, Classes;

type
  TConfigINI = class(TObject)
  public
    sFileName      : string;

    sAppTitle      : string;
    sAppName       : string;
    curTipText     : string;
    ServerListXML  : string;
    ShopListXML    : string;
    ItemListXML    : string;
    TaskListXML    : string;
    LogIdentFile   : string;
    CommandFile    : string;
    MaxLevel       : Integer;
    RMBFormat      : string;
    OpenLossStat   : Boolean;
    LossSpid       : string;
    DataDisposeSpid: string;

    AutoWidth      : Integer;
    AutoHeigth     : Integer;
    DefaultWidth   : Integer;
    IW_Port        : Integer;

    MaxPageCount   : Integer;

    LossBuildTime  : string;

    EngineConnectPort: Integer;
    EngineConnectStart: Boolean;
    DelayUpholePass: string;
    LangType: Integer;

    SafetyPassPort : Integer;
    SafetyPassStart: Boolean;

    OpenSpanPK     : Boolean;
    AcrossWeek     : Integer;
    AcrossDTime    : string;
    AcrossPass     : string;
    AcrossAwardWeek : Integer;
    AcrossAwardDTime: string;
    AcrossImportDBDataRetry: Integer;
    HTType: Integer;

    CallBonusHttp  : string;

    IWBoServer: Boolean;
    IWServerSPID : string;
    IWServerIP   : string;
    IWServerPort : Integer;
    IW_SPID : string;
    IW_SID : Integer;

    constructor Create(FileName: string);
    procedure ReadINI;
    procedure WriteStringINI(Section,Ident,Value: string);
    procedure WriteIntegerINI(Section,Ident: string;Value: Integer);
    procedure WriteBooleanINI(Section,Ident: string; Value: Boolean);
    procedure WriteFloatINI(Section,Ident: string; Value: double);
  end;

var
  objINI: TConfigINI;

implementation

{ TConfigINI }

constructor TConfigINI.Create(FileName: string);
begin
  sFileName := FileName;
  ReadINI;
end;

procedure TConfigINI.ReadINI;
var
  Section,Ident: string;
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    Section := '��������';
    Ident := 'IW�˿�';
    IW_Port := FConfigINI.ReadInteger(Section,Ident,89);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,IW_Port);
    Ident := '��̨SPID';
    IW_SPID := FConfigINI.ReadString(Section,Ident,'vsk');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,IW_SPID);
    Ident := '��̨SID';
    IW_SID := FConfigINI.ReadInteger(Section,Ident,1);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,IW_SID);
    Ident := '��̨����';
    HTType := FConfigINI.ReadInteger(Section,Ident,0);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,HTType);
    Ident := 'IE����';
    sAppTitle := FConfigINI.ReadString(Section,Ident,'���ڽ�ħ¼����ͳ��');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,sAppTitle);
    Ident := '�����������';
    sAppName := FConfigINI.ReadString(Section,Ident,'IWDataStat');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,sAppName);

    Ident := '������ʾ';
    curTipText := FConfigINI.ReadString(Section,Ident,'��ǰ��������%s -> %s');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,curTipText);
    Ident := '�������б�';
    ServerListXML := FConfigINI.ReadString(Section,Ident,'http://static.lhzs.521g.com/autoconf/admin.xml');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,ServerListXML);
    Ident := '��Ϸ��󼶱�';
    MaxLevel := FConfigINI.ReadInteger(Section,Ident,60);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,MaxLevel);
    Ident := '�̳��б�';
    ShopListXML := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/store.cbp');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,ShopListXML);
    Ident := '��Ʒ�б�';
    ItemListXML := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/stditems.cbp');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,ItemListXML);
    Ident := '�����б�';
    TaskListXML := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/stdquest.cbp');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,TaskListXML);
    Ident := '��Ϊ�б�';
    LogIdentFile := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/LogIdent.txt');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,LogIdentFile);

    Ident := '�����б�';
    CommandFile := FConfigINI.ReadString(Section,Ident,'http://res.lhzs.vspk.com/lang/zh-cn/CommandGS.txt');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,CommandFile);

    Ident := '�����ӿ�';
    CallBonusHttp := FConfigINI.ReadString(Section,Ident,'http://127.0.0.1:8083/zjcq/%s/awd?');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,CallBonusHttp);
    Ident := 'RMB��ʾ��ʽ';
    RMBFormat := FConfigINI.ReadString(Section,Ident,'%.1n');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,RMBFormat);
    Ident := '��ʧͳ��ʱ��';
    LossBuildTime := FConfigINI.ReadString(Section,Ident,'03:00:00');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,LossBuildTime);
    Ident := '������ʧͳ��';
    OpenLossStat := FConfigINI.ReadBool(Section,Ident,False);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,OpenLossStat);
    Ident := '��ʧͳ�������б�';
    LossSpid := FConfigINI.ReadString(Section,Ident,'wyi');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,LossSpid);
    Ident := '��̨���ݴ�����Ӫ���б�';
    DataDisposeSpid := FConfigINI.ReadString(Section,Ident,'wyi');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,DataDisposeSpid);
    Section := 'ͼ������';
    Ident := 'ͼ���Զ���';
    AutoWidth := FConfigINI.ReadInteger(Section,Ident,55);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AutoWidth);
    Ident := 'ͼ���Զ���';
    AutoHeigth := FConfigINI.ReadInteger(Section,Ident,45);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AutoHeigth);
    Ident := 'ͼ��Ĭ�Ͽ�';
    DefaultWidth := FConfigINI.ReadInteger(Section,Ident,600);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,DefaultWidth);
    Section := '������ʾ����';
    Ident := '��ҳÿҳ���ֵ';
    MaxPageCount := FConfigINI.ReadInteger(Section,Ident,100);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,MaxPageCount);
    Section := '��ȫ����ӿ�';
    Ident := '�˿�';
    SafetyPassPort := FConfigINI.ReadInteger(Section,Ident,95);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,SafetyPassPort);
    Ident := '��������';
    SafetyPassStart := FConfigINI.ReadBool(Section,Ident,True);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,SafetyPassStart);
    Section := '����˹���';
    Ident := '�˿�';
    EngineConnectPort := FConfigINI.ReadInteger(Section,Ident,8500);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,EngineConnectPort);
    Ident := '��������';
    EngineConnectStart := FConfigINI.ReadBool(Section,Ident,True);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,EngineConnectStart);
    Ident := '����ʱ����';
    DelayUpholePass := FConfigINI.ReadString(Section,Ident, 'xianhai');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,DelayUpholePass);
    Ident := '��������';
    LangType := FConfigINI.ReadInteger(Section,Ident,0);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,LangType);

    Section := '���ս����';
    Ident := '�������ս';
    OpenSpanPK := FConfigINI.ReadBool(Section,Ident,True);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,OpenSpanPK);
    Ident := '���ݴ�����';
    AcrossWeek := FConfigINI.ReadInteger(Section,Ident,7);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AcrossWeek);
    Ident := '���ݴ���ʱ��';
    AcrossDTime := FConfigINI.ReadString(Section,Ident, '00:00:00');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,AcrossDTime);
    Ident := '���ݴ�������';
    AcrossPass := FConfigINI.ReadString(Section,Ident, 'zjkfz');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,AcrossPass);
    Ident := '����������';
    AcrossAwardWeek := FConfigINI.ReadInteger(Section,Ident,1);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AcrossAwardWeek);
    Ident := '��������ʱ��';
    AcrossAwardDTime := FConfigINI.ReadString(Section,Ident, '00:00:00');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,AcrossAwardDTime);
    Ident := 'ʧ�����Դ���';
    AcrossImportDBDataRetry := FConfigINI.ReadInteger(Section,Ident,2);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,AcrossImportDBDataRetry);

    Section := '��̨��������';
    Ident := '�ܷ����̨';
    IWBoServer := FConfigINI.ReadBool(Section,Ident,False);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteBool(Section,Ident,IWBoServer);
    Ident := '�ܺ�̨SPID';
    IWServerSPID := FConfigINI.ReadString(Section,Ident,'vsk');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,IWServerSPID);
    Ident := '�ܺ�̨IP';
    IWServerIP := FConfigINI.ReadString(Section,Ident,'125.90.196.141');
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteString(Section,Ident,IWServerIP);
    Ident := '�ܺ�̨�˿�';
    IWServerPort := FConfigINI.ReadInteger(Section,Ident,8600);
    if not FConfigINI.ValueExists(Section,Ident) then
      FConfigINI.WriteInteger(Section,Ident,IWServerPort);
  finally
    FConfigINI.Free;
  end;
end;

procedure TConfigINI.WriteBooleanINI(Section, Ident: string;
  Value: Boolean);
var
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    FConfigINI.WriteBool(Section, Ident, Value);
  finally
    FConfigINI.Free;
  end;
end;

procedure TConfigINI.WriteFloatINI(Section, Ident: string; Value: double);
var
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    FConfigINI.WriteFloat(Section, Ident, Value);
  finally
    FConfigINI.Free;
  end;
end;

procedure TConfigINI.WriteIntegerINI(Section, Ident: string; Value: Integer);
var
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    FConfigINI.WriteInteger(Section, Ident, Value);
  finally
    FConfigINI.Free;
  end;
end;

procedure TConfigINI.WriteStringINI(Section, Ident, Value: string);
var
  FConfigINI: TINIFile;
begin
  FConfigINI := TINIFile.Create(sFileName);
  try
    FConfigINI.WriteString(Section, Ident, Value);
  finally
    FConfigINI.Free;
  end;
end;

end.
