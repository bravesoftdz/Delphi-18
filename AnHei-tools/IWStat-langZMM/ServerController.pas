unit ServerController;

interface

uses
  SysUtils, Classes, IWServerControllerBase, IWBaseForm, HTTPApp,
  // For OnNewSession Event
  UserSessionUnit, IWApplication, IWAppForm, DBXMySQL, FMTBcd, DBClient,
  SimpleDS, DB, SqlExpr, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdCustomHTTPServer, IdHTTPServer, ExtCtrls, Windows, {AAServiceXML,}
  GSManageServer, ZGSManageServer, EDcode, IWTMSCheckList, Graphics, ActiveX,
  idHttp, ShellAPI, DateUtils, IWForm, IWContainer, ScktComp;

type
  pTStdItem = ^TStdItem;
  TStdItem = packed record
    Name: string[21];
    Dup: Byte;
    ItemDateTime: Integer;
  end;

  PTTask = ^TTask;
  TTask = packed record
    nTaskID: Integer;
    sTaskName: string[20];
    bType: Byte;
    nParentID: Integer;
    bAcceptLevel: Byte;
    bMaxLevel: Byte;
    sTaskMapName: string[32];
  end;

  TStringArray = array of string;
  PTStringArray = ^TStringArray;

  //TOperateType = (otActivityItem, otRoleActivityItem, otBonus,otSurpriseret,otIcksoft,otChatlevel);
  THTType = (htGlobalYuYing,htJOINYuYing,htMalaysia);


  PTServerListData = ^TServerListData;
  TServerListData = record
    spID: string;
    Ispid: Integer;
    Index: Integer;
    ServerID: Integer;
    SessionHostName: string;
    SessionHostName2: string;
    DataBase: string;
    LogHostName: string;
    RoleHostName: string;
    IsDisplay: Boolean;
    CurrencyRate: Double;
    PassKey: string;
    OpenTime: string;
    JoinIdx: Integer;
    BonusKey: string;
    //�������Զ������
    LogDB: string;
    Amdb: string;
    Amdb2: string;
    AccountDB: string;
    AccountDB2: string;
    GstaticDB: string;
  end;

  PTLogRecord=^TLogRecord;
  TLogRecord = record
    nIdent : Integer;  //��Ϊ
    nSrvIndex : Integer;
    nType: Integer;   //Para0:��ƷID
    nChange: Integer; //Para1:�仯ǰ��ֵ
    nCount: Integer;  //para2:�仯����ֵ
    sSender: string;  //��ɫ��
    sObjName: string; ///LongStr2:��Ʒ����
    sObjId: string;  //LongStr1:��Ʒ���к�
    sRemark: string; //LongStr0:��ע˵��
    sDate: string;
    sMidStr0: string;  //Ŀ��
  end;

  TIWServerController = class(TIWServerControllerBase)
    TimerAutoRun: TTimer;
    IdHTTPServer: TIdHTTPServer;
    TimerAutoUpdate: TTimer;
    TimerNoticeRun: TTimer;
    SQLConnectionRAuto: TSQLConnection;
    quRobotInfo: TSQLQuery;
    SendTimer: TTimer;
    TimerStart: TTimer;
    ASumTime1: TTimer;
    SQLConnectionASumMoney: TSQLConnection;
    quASumMoney: TSQLQuery;
    SQLConnectionASumOL: TSQLConnection;
    quASumOL: TSQLQuery;
    quASumchg: TSQLQuery;
    SQLConnectionASumChg: TSQLConnection;
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication;
      var VMainForm: TIWBaseForm);
    procedure IWServerControllerBaseCreate(Sender: TObject);
    procedure IWServerControllerBaseDestroy(Sender: TObject);
    procedure TimerAutoRunTimer(Sender: TObject);
    procedure TimerAutoUpdateTimer(Sender: TObject);
    procedure IWServerControllerBaseBackButton(ASubmittedSequence,
      ACurrentSequence: Integer; AFormName: string; var VHandled,
      VExecute: Boolean);
    procedure IWServerControllerBaseCloseSession(ASession: TIWApplication);
    procedure IWServerControllerBaseBeforeDispatch(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure IWServerControllerBaseAfterRender(ASession: TIWApplication;
      AForm: TIWBaseForm);
    procedure TimerNoticeRunTimer(Sender: TObject);
    procedure SendTimerTimer(Sender: TObject);
    procedure ASumTime1Timer(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
  private
    m_SafetyPassLock: TRTLCriticalSection;
    m_SessionLoadLock: TRTLCriticalSection;

  //  ServiceXML: TAAServiceXML;
   // AcrossRankList: TStringList;
   // curAcrossIdx: Integer;
 //   AcrossIDBDataRetry: Integer;
    AuthIPList: TStringList;

    Bobusy: Boolean;
    BoRunClient: Boolean;
    CSocStr, CBufferStr: string;

    IWFClient: TClientSocket;
    procedure GSRequestResult(Sender: TObject; Connection: TGSConnection; const DefMsg: TDefaultMessage; Data: string);
    procedure ZGSRequestResult(Sender: TObject; Connection: TZGSConnection; const DefMsg: TDefaultMessage; Data: string);

    procedure DecodeMessagePacket (datablock: string);//�ͻ��˽�����Ϣ
  public
    function IsCheckTable(SQLQuery: TSQLQuery;sDBName,sTableName: string): Boolean;
    function DBExecSQL(SQLQuery: TSQLQuery;sSQL: string): Integer;
    procedure ConnectionRoleMysql(SQLConnection: TSQLConnection;sHostName,sDataBase: string); overload;
    procedure ConnectionRoleMysql(SQLConnection: TSQLConnection;sHostName,sDataBase,sUser,sPass: string;iPort: Integer); overload;
    procedure ConnectionLogMysql(SQLConnection: TSQLConnection;slog,sHostName: string);
    procedure ConnectionLocalLogMysql(SQLConnection: TSQLConnection; sHostName: string);
    procedure ConnectionSessionMysql(SQLConnection: TSQLConnection;sAccount,sHostName: string);


    procedure SetRobotMessage (spid: string; Idx, nMsgType, Num, nTick: Integer; sdata: string; daTime: TDateTime);

    procedure SendAddNotices(spid: string; Idx, nMsgType, nTick: Integer; sdata: string);
    procedure SendDelNotices(spid: string; Idx: Integer; sdata: string);
    procedure SendSetExpRates(spid: string; Idx, ExpRate, ExpTime: Integer; sdata: string);

    procedure SendCMSocket (sendstr: AnsiString);

    function PayAndOLTotal(sspid: string): Boolean;
    function PayAndOLTotal2(sspid: string): Boolean;
    procedure InsertPayAndOL(sdata: string);
    procedure InsertPayAndOL2(sdata: string);

    procedure OnRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OnConnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnDisconnect(Sender: TObject;Socket: TCustomWinSocket);
    procedure OnError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;var ErrorCode: Integer);
  end;

  function UserSession: TIWUserSession;
  function IWServerController: TIWServerController;
  function Move(AFormClass: TIWAppFormClass; IsRelease: Boolean = True): TIWAppForm;
  function NumberSort(List: TStringList; Index1,Index2: Integer): Integer;
  function GetCellName(sText: string): string;
  function ChangeZero(Value: Double): Double;overload;
  function ChangeZero(Value: Integer): Integer;overload;
  function DivZero(sValue,eValue: Double): Double;
  function GetServerIndex(ServerName: string): string;
  procedure ClearServerListData;
  procedure ClearShopListData(pList: TStringList);
  function GetHttpXML(sHttp: string): string;
  procedure LoadServerList;
  procedure LoadShopList;
  procedure LoadStdItems;
  procedure ClearStdItems;
  procedure LoadTasks;
  procedure ClearTasks;
  procedure LoadLogIdent;
  procedure LoadCommonList;
  procedure ClearWebGridDataList(DataList: TStringList);
  function GetServerListDataBySPID(const sSPID: string): PTServerListData;
  function GetServerListData(sServerName: string): PTServerListData; overload;
  function GetServerListData(iServerIndex: Integer): PTServerListData; overload;
  function GetServerListData(spid: string; iServerIndex: Integer): PTServerListData; overload;
  function GetServerListName(spid: string;iServerIndex: Integer; CheckJoin: Boolean = False): string;
  function GetServerListNameEx(iServerIndex: Integer; CheckJoin: Boolean = False): string;
  function GetRecordCount(sSQL: string; Query: TSQLQuery): Integer;
  function GetServerIsdisplay(spid: string;ServerIndex: Integer): Boolean;
  function OnGetStdItemName(const StdItemIdx: Integer): string;
  function OnGetTaskName(const StdTaskIdx: Integer): PTTask; overload;
  function GetZyName(zyID1,zyID2: Integer): string;
  function GetLogIdentStr(const nIdent: Integer): string;
  procedure WriteErrorFile(IsDate: Boolean; sText: string);
  function GetSessionDMessage(AppID: string): Integer;
  function GetSessionIWMessage(AppID: string): Integer;
  function GSResultStr(AppID, spid: string): string;
  function GSIWResultStr(AppID: string): string;
  procedure ClearGSMsgListData;
  procedure LoadGSServers(CheckListBox: TTIWCheckListBox; spID: string; IsDisplay: Boolean = True); overload;
  procedure LoadGSServers(StringList: TStringList; spID: string; IsDisplay: Boolean = True); overload;
  procedure AppExceptionLog(sClassName: string; E: Exception);
  function GetShopItemPrice(pList: TStringList;ItemName: string): Integer;
  function DecryptZJHTKey(sKey: string): AnsiString;
  function UrlEncode(const ASrc: AnsiString): AnsiString;
  function BuildSerialNO: string;
  function SecondToTime(I:integer):string;
  function GetSQLJob: string;
  function GetExtSysICon(sExt: string): HIcon;
  function QuerySQLStr(sFieldName: string): string;
  function QuerySQLStrEx(sFieldName: string): string;
  function ParameterIntValue(pStr: string): Integer;
  function ParameterStrValue(pStr: string): string;
  function ParameterStrValueEx(pStr: string): string;
  function GetJoinServerIndex(iServerIndex: Integer): string;
  function GetFirstOpenTime(spId: string): TDateTime;
  function InttoCurrType(num: Integer): string; //���ӻ����������
  function Str_ToInt (Str: string; def: Longint): Longint;
  function Str_ToInt64(Str: string; def: Longint): Int64;
  function InttoKillType(num: Integer): string; //���ӱ�ɱ����
  function MsgTypestr(num: Integer): string; //��������
  function RobotTypestr(num: Integer): string;
  function ItemTypeStr(num: Integer): string;
  function BoolToIntStr(boo: Boolean): string;
  function GetVersionEx: string;
const
  AdminUser = 'admin';
  filesdir = 'files\';
  filesPath  = 'files\';
  UserPopFile = 'UserPopList.xml';
  ZJConfigINI = 'ZJConfig.ini';
  ZJServerINI = 'ZJServer.ini';
  NoticeFile = 'notice.txt';
  AuthIPListFile = 'AuthIPList.txt';
  UserIPListFile = 'UserIPList.txt';
  TopCount = 500;
  CurSection = '�һ�������';
  GSLogInfo = '[%s] %s';
  sBind: array[0..1] of string = ('����','��');
  sStack: array[0..1] of string = ('������','����');
  THTTypeStr: array[THTType] of string = ('ͨ�ú�̨','�����̺�̨','�������Ǻ�̨');
  TDBTableList: array[0..14] of string =
                ('actorbagitem','actorbinarydata','actorconsignment','actordepotitem',
                 'actorequipitem','actorfriends','actorguild','actormsg',
                 'actors','actorvariable','fubendata','goingquest',
                 'repeatquest','skill', 'useritem');
  sRoleJob : array [0..3] of Integer = (376, 267, 268, 269);
  RoleChartColor : array [0..8] of Integer = (clRed, clGreen, clBlack, clBlue, clLime, clFuchsia, clPurple, clOlive, clSilver);
  TOperateTypeStr: array[0..8] of string = ('�����˺Ż��Ʒ','���Ž�ɫ���Ʒ','���ź���','��ϲ����','���ü������','��������ȼ�','ɾ���л�','ɾ��װ��','ɾ������');
  ZyNameStr: array[0..3] of string = ('����Ӫ','�޼�','��ң','����');
  TBugInfoStateStr: array[0..1] of Integer = (468,469);

var
  xmlText: string;
  xmlShop: string;
  xmlReputeShop: string;
  AppPathEx: string;
  ServerList: TStringList;
  FStdItemList: TStringList;
  TaskList: TStringList;
  ShopList: TStringList;
  LogIdentList: TStringList;
  CommonList: TStringList;
  FGSMServer : TGSManageServer;
  ZGSMServer : TZGSManageServer;
  SessionIDList: TStringList;
  GSMsgList: TStringList;
  FPrintMsgLock: TRTLCriticalSection;
  FPrintMsgLockIW: TRTLCriticalSection;
  SafetyPassHttpServer: TIdHTTPServer;
  m_WriteLogLock: TRTLCriticalSection;
  SerialNO: Integer;
 // IsAcrossRun: Boolean;
  BugTypeList: TStringList;
  NoticeMsgData: array[0..7, 0..1] of Byte =((1,0),(2,0),(4,0),(8,0),(16,0),(32,0),(64,0),(128,0));
  sNoticeMsgData: array [0..7] of string=('�Ҳ���ʾ��','��Ļ����','������','������','����Ϣ','��ܰ��ʾ','GM��ʾ��Ϣ','���������');

  AuthUserIPList: TStringList;
  AuthLangList: TStringList;

  GameStateList: TStringList;

  MyMsgList: TStringList;  //�ܺ�̨������Ϣ


implementation

{$R *.dfm}

uses
  IWInit, IWGlobal, ConfigINI, ServerINI, GSProto, MSXML, SQLFileDecrypt, AES,
  uDataDispose, Share, ComCBPRead_TLB, AIWRobot, Forms;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

function UserSession: TIWUserSession;
begin
  Result := TIWUserSession(WebApplication.Data);
end;

function TIWServerController.PayAndOLTotal(sspid: string): Boolean;
const
  sqlOnlineCount = 'SELECT MAX(onlinecount) AS onlinecount FROM log_onlinecount_%s ';
  sqlPayAndOLTotal = 'SELECT SUM(rmb) AS TotalMoney,COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
var
  psld: PTServerListData;
  TotalUser, TotalOnline, TotalMoney: Integer;
  sBuffer  : string;
  msg : TDefaultMessage;
  samdb, saccont: string;
begin
  Result := False;
 // TotalUser := 0; TotalOnline := 0; TotalMoney := 0;
  try
    sBuffer := '';
    psld := GetServerListDataBySPID(sspid);
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionASumOL,psld.LogDB,psld.LogHostName);
    ConnectionSessionMysql(SQLConnectionASumMoney,psld.AccountDB,psld.SessionHostName);
    try
      with quASumOL do //��������
      begin
        SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd',Now)]);
        Open;
        TotalOnline := Fields[0].AsInteger;
        Close;
      end;

      with quASumMoney do
      begin
        SQL.Text := Format(sqlPayAndOLTotal,[psld.amdb,psld.spid, FormatDateTime('yyyy-mm-dd',Now),FormatDateTime('yyyy-mm-dd',Now)]);;
        Open;
       // TotalMoney := Trunc(Fields[0].AsFloat*psld^.CurrencyRate*10);
        TotalMoney := ROUND(DivZero(Fields[0].AsInteger,psld.CurrencyRate) * 10);

        TotalUser  := Fields[1].AsInteger;
        Close;
      end;

      //New Add
      if psld^.SessionHostName2 <> '127.0.0.1' then
      begin
        if psld^.AccountDB2 = 'cq_account' then saccont := 'cq_account'
        else  saccont := psld^.AccountDB2;

        if psld^.Amdb2 = 'amdb' then samdb := 'amdb'
        else  samdb := psld^.Amdb2;

        ConnectionSessionMysql(SQLConnectionASumMoney,saccont,psld.SessionHostName2);
        with quASumMoney do
        begin
          SQL.Text := Format(sqlPayAndOLTotal,[psld.amdb,psld.spid, FormatDateTime('yyyy-mm-dd',Now),FormatDateTime('yyyy-mm-dd',Now)]);;
          Open;
         // TotalMoney := TotalMoney + Trunc(Fields[0].AsFloat*psld^.CurrencyRate*10);
          TotalMoney := TotalMoney + ROUND(DivZero(Fields[0].AsInteger,psld.CurrencyRate) * 10);
          TotalUser  := TotalUser + Fields[1].AsInteger;
          Close;
        end;
      end;

      sBuffer := psld.spid +'/'+IntToStr(TotalMoney)+'/'+IntToStr(TotalUser)+'/'+IntToStr(TotalOnline);
      msg := MakeDefaultMsg (CM_IW_PAYALL, 0, 0, 0, 0);
      SendCMSocket(EncodeMessage(msg) + EncodeString(AnsiString(AnsiToUtf8(sBuffer))));
      Result := True;
    finally
      SQLConnectionASumOL.Close;
      SQLConnectionASumMoney.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

function TIWServerController.PayAndOLTotal2(sspid: string): Boolean;
const
  sqlOnlineCount = 'SELECT MAX(onlinecount) AS onlinecount FROM log_onlinecount_%s ';
  sqlPayAndOLTotal = 'SELECT SUM(rmb) AS TotalMoney,COUNT(DISTINCT account) AS iCount FROM %s.payorder WHERE yunying="_%s" AND type = 3 and state = 1 AND orderdate>="%s" AND orderdate<="%s 23:59:59"';
var
  psld: PTServerListData;
  TotalUser, TotalOnline, TotalMoney: Integer;
  sBuffer  : string;
  msg : TDefaultMessage;
  samdb, saccont: string;
begin
  Result := False;
 // TotalUser := 0; TotalOnline := 0; TotalMoney := 0;
  try
    sBuffer := '';
    psld := GetServerListDataBySPID(sspid);
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionASumOL,psld.LogDB,psld.LogHostName);
    ConnectionSessionMysql(SQLConnectionASumMoney,psld.AccountDB,psld.SessionHostName);
    try
      with quASumOL do //��������
      begin
        SQL.Text := Format(sqlOnlineCount,[FormatDateTime('yyyymmdd',Now)]);
        Open;
        TotalOnline := Fields[0].AsInteger;
        Close;
      end;

      with quASumMoney do
      begin
        SQL.Text := Format(sqlPayAndOLTotal,[psld.amdb,psld.spid, FormatDateTime('yyyy-mm-dd',Now),FormatDateTime('yyyy-mm-dd',Now)]);;
        Open;
        //TotalMoney := Trunc(Fields[0].AsFloat*psld^.CurrencyRate*10);
        TotalMoney := ROUND(DivZero(Fields[0].AsInteger,psld.CurrencyRate) * 10);
        TotalUser  := Fields[1].AsInteger;
        Close;
      end;

      //New Add
      if psld^.SessionHostName2 <> '127.0.0.1' then
      begin
        if psld^.AccountDB2 = 'cq_account' then saccont := 'cq_account'
        else  saccont := psld^.AccountDB2;

        if psld^.Amdb2 = 'amdb' then samdb := 'amdb'
        else  samdb := psld^.Amdb2;

        ConnectionSessionMysql(SQLConnectionASumMoney,saccont,psld.SessionHostName2);
        with quASumMoney do
        begin
          SQL.Text := Format(sqlPayAndOLTotal,[psld.amdb,psld.spid, FormatDateTime('yyyy-mm-dd',Now),FormatDateTime('yyyy-mm-dd',Now)]);;
          Open;
        //  TotalMoney := TotalMoney + Trunc(Fields[0].AsFloat*psld^.CurrencyRate*10);
          TotalMoney := TotalMoney + ROUND(DivZero(Fields[0].AsInteger,psld.CurrencyRate) * 10);
          TotalUser  := TotalUser + Fields[1].AsInteger;
          Close;
        end;
      end;

      sBuffer := FormatDateTime('YYYY-MM-DD hh:mm:ss',Now)+'/'+psld.spid +'/'+IntToStr(TotalMoney)+'/'+IntToStr(TotalUser)+'/'+IntToStr(TotalOnline);
      msg := MakeDefaultMsg (CM_IW_PAYALL, 0, 0, 0, 0);
      SendCMSocket(EncodeMessage(msg) + EncodeString(AnsiString(AnsiToUtf8(sBuffer))));
      Result := True;
    finally
      SQLConnectionASumOL.Close;
      SQLConnectionASumMoney.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.InsertPayAndOL(sdata: string);
const
  sqlInsertPayUser = 'INSERT INTO %s.mypaydata VALUES ("%s","%s","%s",%d,%d)';
  sqlUpdatePayUser = 'UPDATE %s.mypaydata SET paytotal="%s",payuser=%d,globalonline=%d WHERE logdate>="%s" AND logdate<="%s 23:59:59" and spid="%s"';
  sqlCreatePayUser = 'CREATE TABLE %s.mypaydata (logdate datetime NOT NULL, spid varchar(3) NOT NULL, paytotal decimal(10) default NULL,payuser int(10) NOT NULL default "0", ' +
                     'globalonline int(10) NOT NULL default "0") ENGINE=MyISAM DEFAULT CHARSET=utf8;';
   function IsCheckResult(SQLQuery: TSQLQuery; gstatic, sspid, sdate: string): Boolean;
   const
    tSql = 'SELECT logdate FROM %s.mypaydata WHERE spid="%s" AND logdate>="%s" AND logdate<="%s 23:59:59"';
   var
    gtgold2: string;
   begin
     gtgold2:= Format(tSql,[gstatic, sspid, sdate, sdate]);
     with SQLQuery do
     begin
      SQL.Text := Format(tSql,[gstatic, sspid, sdate, sdate]);
      Open;
      Result := Fields[0].AsString <> '';
      Close;
     end;
   end;
var
  psld: PTServerListData;
  gspid, guol, gtusr, gtgold: string;
begin
  try
    sdata := GetValidStr3 (sdata, gspid, ['/']);
    sdata := GetValidStr3 (sdata, gtgold, ['/']);
    sdata := GetValidStr3 (sdata, gtusr, ['/']);
    sdata := GetValidStr3 (sdata, guol, ['/']);

    psld := GetServerListDataBySPID(objINI.IWServerSPID); //��ȡ�ܺ�̨�ṹ
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionASumChg,psld.LogDB,psld.LogHostName);
    try
      if not IsCheckTable(quASumchg,psld.GstaticDB,'mypaydata') then
      begin
        DBExecSQL(quASumchg,Format(sqlCreatePayUser,[psld.GstaticDB]));
      end;

      if not IsCheckResult(quASumchg, psld.GstaticDB, gspid, FormatDateTime('YYYY-MM-DD',Now)) then
      begin
        with quASumchg do
        begin
          SQL.Text := Format(sqlInsertPayUser,[psld.GstaticDB,FormatDateTime('YYYY-MM-DD hh:mm:ss',now), gspid, gtgold, Str_ToInt(gtusr, 0), Str_ToInt(guol, 0)]);
          ExecSQL;
          Close;
        end;
      end
      else begin
        with quASumchg do
        begin
          SQL.Text := Format(sqlUpdatePayUser,[psld.GstaticDB, gtgold, Str_ToInt(gtusr, 0), Str_ToInt(guol, 0), FormatDateTime('YYYY-MM-DD',now), FormatDateTime('YYYY-MM-DD',now), gspid]);
          ExecSQL;
          Close;
        end;
      end;
    finally
      SQLConnectionASumChg.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.InsertPayAndOL2(sdata: string);
const
  sqlInsertPayUser = 'INSERT INTO %s.mypaydata VALUES ("%s","%s","%s",%d,%d)';
  sqlUpdatePayUser = 'UPDATE %s.mypaydata SET paytotal="%s",payuser=%d,globalonline=%d WHERE logdate>="%s" AND logdate<="%s 23:59:59" and spid="%s"';
  sqlCreatePayUser = 'CREATE TABLE %s.mypaydata (logdate datetime NOT NULL, spid varchar(3) NOT NULL, paytotal decimal(10) default NULL,payuser int(10) NOT NULL default "0", ' +
                     'globalonline int(10) NOT NULL default "0") ENGINE=MyISAM DEFAULT CHARSET=utf8;';
   function IsCheckResult(SQLQuery: TSQLQuery; gstatic, sspid, sdate: string): Boolean;
   const
    tSql = 'SELECT logdate FROM %s.mypaydata WHERE spid="%s" AND logdate>="%s" AND logdate<="%s 23:59:59"';
   var
    sidate: string;
   begin
     sdate := GetValidStr3 (sdate, sidate, [' ']);
     with SQLQuery do
     begin
      SQL.Text := Format(tSql,[gstatic, sspid, sidate, sidate]);
      Open;
      Result := Fields[0].AsString <> '';
      Close;
     end;
   end;
var
  psld: PTServerListData;
  gdate, gspid, guol, gtusr, gtgold, sidate: string;
begin
  try
    sdata := GetValidStr3 (sdata, gdate, ['/']);
    sdata := GetValidStr3 (sdata, gspid, ['/']);
    sdata := GetValidStr3 (sdata, gtgold, ['/']);
    sdata := GetValidStr3 (sdata, gtusr, ['/']);
    sdata := GetValidStr3 (sdata, guol, ['/']);

    psld := GetServerListDataBySPID(objINI.IWServerSPID); //��ȡ�ܺ�̨�ṹ
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionASumChg,psld.LogDB,psld.LogHostName);
    try
      if not IsCheckTable(quASumchg,psld.GstaticDB,'mypaydata') then
      begin
        DBExecSQL(quASumchg,Format(sqlCreatePayUser,[psld.GstaticDB]));
      end;

      if not IsCheckResult(quASumchg, psld.GstaticDB, gspid, gdate) then
      begin
        with quASumchg do
        begin
          SQL.Text := Format(sqlInsertPayUser,[psld.GstaticDB,gdate, gspid, gtgold, Str_ToInt(gtusr, 0), Str_ToInt(guol, 0)]);
          ExecSQL;
          Close;
        end;
      end
      else begin
        gdate := GetValidStr3 (gdate, sidate, [' ']);
        with quASumchg do
        begin
          SQL.Text := Format(sqlUpdatePayUser,[psld.GstaticDB, gtgold, Str_ToInt(gtusr, 0), Str_ToInt(guol, 0), sidate, sidate, gspid]);
          ExecSQL;
          Close;
        end;
      end;
    finally
      SQLConnectionASumChg.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.ASumTime1Timer(Sender: TObject);
var
  I: Integer;
  psld: PTServerListData;
begin
  if not objINI.IWBoServer then //��ⲻ���ܺ�̨
  begin
    if BoRunClient then //����Ͽ��Ͳ���ѯ
    begin
      for I := 0 to ServerList.Count - 1 do
      begin
        psld := PTServerListData(ServerList.Objects[I]);
        if psld <> nil then
        begin
          if psld.Index <> 0 then Continue;

          if Pos(psld^.spID,objINI.DataDisposeSpid) <> 0 then
          begin
             PayAndOLTotal2(psld^.spID);
          end;
        end;
      end;
    end;
  end;
end;

procedure TIWServerController.OnError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
  BoRunClient := FALSE; //ǿ�ƹر�
end;
//����    OnDisconnect
procedure TIWServerController.OnConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
	BoRunClient := True;
  SendCMSocket (EncodeMessage(MakeDefaultMsg(CM_REGIST_SERVER_RET,0,objINI.IW_SID,0,0)) +  EncodeString(AnsiString(objINI.IW_SPID+ '|'+objINI.sAppTitle + ' V'+ GetVersionEx)));
  CSocStr := '';
  CBufferStr := '';
end;
//�Ͽ�
procedure TIWServerController.OnDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
	BoRunClient := FALSE;
end;

//��Ϣ
procedure TIWServerController.OnRead(Sender: TObject; Socket: TCustomWinSocket);
var
   n: integer;
   data, data2: AnsiString;
begin
   data := Socket.ReceiveText;

   n := pos('*', string(data));
   if n > 0 then begin
      data2 := Copy (data, 1, n-1);
      data := data2 + Copy (data, n+1, Length(data));
      IWFClient.Socket.SendText ('*');
   end;
   CSocStr := CSocStr + string(data);
end;

procedure TIWServerController.ConnectionLogMysql(SQLConnection: TSQLConnection;
  slog,sHostName: string);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database=' + slog);
  SQLConnection.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnection.Params.Append('Password=' + UM_PASSWORD);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Connected := True;
end;

procedure TIWServerController.ConnectionLocalLogMysql(SQLConnection: TSQLConnection;
  sHostName: string);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database=' + UM_DATA_LOCALLOG);
  SQLConnection.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnection.Params.Append('Password=' + UM_PASSWORD);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Connected := True;
end;

procedure TIWServerController.ConnectionRoleMysql(SQLConnection: TSQLConnection;
  sHostName, sDataBase, sUser, sPass: string; iPort: Integer);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database='+sDataBase);
  SQLConnection.Params.Append('User_Name='+sUser);
  SQLConnection.Params.Append('Password='+sPass);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Params.Append('Server Port='+IntToStr(iPort));
  SQLConnection.Connected := True;
end;

procedure TIWServerController.ConnectionRoleMysql(SQLConnection: TSQLConnection;
  sHostName, sDataBase: string);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database='+sDataBase);
  SQLConnection.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnection.Params.Append('Password=' + UM_PASSWORD);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Connected := True;
end;

procedure TIWServerController.ConnectionSessionMysql(
  SQLConnection: TSQLConnection; sAccount,sHostName: string);
begin
  SQLConnection.Connected := False;
  SQLConnection.Params.Clear;
  SQLConnection.Params.Append('HostName='+sHostName);
  SQLConnection.Params.Append('Database=' + sAccount);
  SQLConnection.Params.Append('User_Name=' + UM_USERNAME);
  SQLConnection.Params.Append('Password=' + UM_PASSWORD);
  SQLConnection.Params.Append('ServerCharset=utf-8');
  SQLConnection.Connected := True;
end;

function TIWServerController.DBExecSQL(SQLQuery: TSQLQuery;
  sSQL: string): Integer;
begin
  with SQLQuery do
  begin
    SQL.Text := sSQL;
    Result := ExecSQL;
    Close;
  end;
end;

procedure TIWServerController.DecodeMessagePacket (datablock: string);
var
   i, iPos: Integer;
   head, body: String;
   sstr, sdata: String;
   msg2, msgex : TDefaultMessage;
   m_Server: TGSConnection;
   GSConnection: TGSConnection;
begin
   head := Copy (datablock, 1, DEFBLOCKSIZE);
   body := Copy (datablock, DEFBLOCKSIZE+1, Length(datablock)-DEFBLOCKSIZE);
   msg2  := DecodeMessage (AnsiString(head));
   case msg2.Ident of
      SM_RELOADDATALL: //���¼���ServerList�б�
         begin
            case msg2.Tag of
               0:
               begin
                  LoadServerList;
                  LoadShopList;
                  LoadStdItems;
                  LoadTasks;
                  LoadLogIdent;
                  LoadCommonList;
               end;
               1: LoadServerList;
               2: LoadShopList;
               3: LoadStdItems;
               4: LoadTasks;
               5: LoadLogIdent;
               6: LoadCommonList;
            end;
            msgex := MakeDefaultMsg (CM_RELOADDATALL, msg2.Recog, 0, 0, 0);
            SendCMSocket(EncodeMessage(msgex));
         end;
      SM_RELOADNPC:
         begin
            body := string(DecodeString(AnsiString(body)));

            iPos := Pos('/',body);
            sstr := Copy(body,1,iPos-1);
            sdata := Copy(body,iPos+1,Length(body));

            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
              m_Server.SendReloadNPC(-1, sstr, sdata);
            end;
            msgex := MakeDefaultMsg (CM_RELOADNPC, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
      SM_RELOAD_FUNCTION:
         begin
            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
                m_Server.SendReloadFunction(-1);
            end;
            msgex := MakeDefaultMsg (CM_RELOAD_FUNCTION, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
      SM_REFRESHCORSS:
         begin
            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
                m_Server.SendSetReFreshcorss(-1);
            end;
            msgex := MakeDefaultMsg(CM_REFRESHCORSS, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
      SM_RELOADCONFIG:
         begin
            body := string(DecodeString(AnsiString(body)));
            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
                 m_Server.SendSetReLoadConfig(-1, body);
            end;
            msgex := MakeDefaultMsg(CM_RELOADCONFIG, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
      SM_RELOADLANG:
         begin
            for i := 0 to FGSMServer.FConnectionList.Count-1 do
            begin
              GSConnection := TGSConnection(FGSMServer.FConnectionList[I]);
              m_Server := FGSMServer.GetServerByIndex(GSConnection.spid, GSConnection.ServerIndex);
              if m_Server <> nil then
                m_Server.SendSetReLoadLang(-1);
            end;
            msgex := MakeDefaultMsg(CM_RELOADLANG, msg2.Recog, 0, 0, 0);
            SendCMSocket (EncodeMessage(msgex));
         end;
   else
   end;
end;

procedure TIWServerController.GSRequestResult(Sender: TObject;
  Connection: TGSConnection; const DefMsg: TDefaultMessage; Data: string);
var
  RetData: string;
  pDefMsg: PTDefaultMessage;
begin
  EnterCriticalSection(FPrintMsgLock);
  try
    case DefMsg.Ident of
       MCS_VIEW_STATE: //����ϵͳ״̬������Ϣ
        begin
           RetData := UTF8ToString(DecodeString(AnsiString(Data)));
           GameStateList.Add(RetData);
        end;
    else
       begin
         New(pDefMsg);
         pDefMsg^ := DefMsg;
         RetData := UTF8ToString(DecodeString(AnsiString(Data)));
         GSMsgList.AddObject(IntToStr(Connection.ServerIndex) +'|'+RetData,TObject(pDefMsg));
       end;
    end;
  finally
    LeaveCriticalSection(FPrintMsgLock);
  end;
end;

procedure TIWServerController.ZGSRequestResult(Sender: TObject;
  Connection: TZGSConnection; const DefMsg: TDefaultMessage; Data: string);
var
  RetBody: string;
  pDefMsg: PTDefaultMessage;
begin
  EnterCriticalSection(FPrintMsgLockIW);
  try
    case DefMsg.Ident of
       CM_IW_PAYALL: //���ջ�����Ϣ
           begin
              RetBody := UTF8ToString(DecodeString(AnsiString(Data)));
              InsertPayAndOL2 (RetBody);
           end;
    else
       begin
          New(pDefMsg);
          pDefMsg^ := DefMsg;
          RetBody := UTF8ToString(DecodeString(AnsiString(Data)));
          MyMsgList.AddObject(IntToStr(Connection.ServerIndex) + '|'+ RetBody,TObject(pDefMsg));
              //    GSMsgList.AddObject(IntToStr(Connection.ServerIndex) +'|'+RetData,TObject(pDefMsg));
       end;
    end;
  finally
    LeaveCriticalSection(FPrintMsgLockIW);
  end;
end;

function TIWServerController.IsCheckTable(SQLQuery: TSQLQuery; sDBName,
  sTableName: string): Boolean;
const
  tSql = 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA="%s" AND TABLE_NAME="%s"';
begin
  with SQLQuery do
  begin
    SQL.Text := (Format(tSql,[sDBName,sTableName]));
    Open;
    Result := Fields[0].AsString<>'';
    Close;
  end;
end;

procedure TIWServerController.IWServerControllerBaseAfterRender(
  ASession: TIWApplication; AForm: TIWBaseForm);
begin
  ASession.SessionTimeOut := 300;
end;

procedure TIWServerController.IWServerControllerBaseBackButton(
  ASubmittedSequence, ACurrentSequence: Integer; AFormName: string;
  var VHandled, VExecute: Boolean);
Type
  TIWFormClass = class of TIWForm;
var
  LForm : TIWForm;
begin
  VHandled := True;
  VExecute := True;
  if AFormName = '' then Exit;
  if WebApplication.FindComponent(AFormName) <> nil then
  begin
    WebApplication.SetActiveForm(WebApplication.FindComponent(AFormName) as TIWContainer);
  end else
  begin
    try
      LForm := TIWFormClass(FindClass('T'+AFormName)).Create(WebApplication);
      WebApplication.SetActiveForm(LForm);
    except
      VHandled := False;
    end;
  end;
end;

procedure TIWServerController.IWServerControllerBaseBeforeDispatch(
  Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
const
  OldURLPage = '/IWStat';
begin
  if Request.URL = OldURLPage then
  begin
    Response.SendRedirect(AnsiString(Format('http://%s:%d',[string(Request.Host),Request.ServerPort])));
    Handled :=  True;
    Exit;
  end;
end;

procedure TIWServerController.IWServerControllerBaseCloseSession(
  ASession: TIWApplication);
var
  Idx: Integer;
begin
  EnterCriticalSection( m_SessionLoadLock );
  try
    Idx := SessionIDList.IndexOf(ASession.AppID);
    if Idx <> -1 then
    begin
      SessionIDList.Delete(Idx);
    end;
  finally
   LeaveCriticalSection( m_SessionLoadLock );
  end;
end;

procedure TIWServerController.IWServerControllerBaseCreate(Sender: TObject);
begin
  SessionTimeout := 180;
  CoInitialize(nil);
  BoundIP := '0.0.0.0';
  try
    ServerList := TStringList.Create;
    FStdItemList := TStringList.Create;
    ShopList := TStringList.Create;
    LogIdentList := TStringList.Create;
    CommonList := TStringList.Create;
    SessionIDList := TStringList.Create;
    GSMsgList := TStringList.Create;
 //   AcrossRankList := TStringList.Create;
    objINI := TConfigINI.Create(AppPath+ZJConfigINI);
    Port := objINI.IW_Port;
    objServerINI := TServerINI.Create(AppPath+ZJServerINI);
    HTMLHeaders.Add('<link rel="shortcut icon" href="/files/favicon.ico">');
    AppPathEx := AppPath;
    AppName := objINI.sAppName;
    InitializeCriticalSection( m_SafetyPassLock );
    InitializeCriticalSection( m_SessionLoadLock );
    InitializeCriticalSection( m_WriteLogLock );

    IdHTTPServer.DefaultPort := objINI.SafetyPassPort;
    IdHTTPServer.Active := objINI.SafetyPassStart;
    SafetyPassHttpServer := IdHTTPServer;
    InitializeCriticalSection(FPrintMsgLock);
    InitializeCriticalSection(FPrintMsgLockIW);
    FGSMServer := TGSManageServer.Create;
    FGSMServer.ServiceName := '���ڽ�ħ¼����˹�������';
    FGSMServer.BindPort := objINI.EngineConnectPort;
    FGSMServer.OnGSRequestResult := GSRequestResult;
    FGSMServer.Start();
    //�ܺ�̨
    if objINI.IWBoServer then
    begin
      ZGSMServer := TZGSManageServer.Create;
      ZGSMServer.ServiceName := 'VSPK��̨��������';
      ZGSMServer.BindPort := objINI.IWServerPort;
      ZGSMServer.OnGSRequestResult := ZGSRequestResult; //����Ҫ��
      ZGSMServer.Start();
    end
    else begin
      IWFClient := TClientSocket.Create(nil);
      IWFClient.OnRead := OnRead;        //��Ϣ
      IWFClient.OnConnect := OnConnect;  //����
      IWFClient.OnDisconnect := OnDisconnect;  //�Ͽ�
      IWFClient.OnError := OnError;      //�����Ͽ�
    end;
   // ServiceXML := TAAServiceXML.Create(AppPathEx);
    //IsAcrossRun := False;
   // AcrossIDBDataRetry := 0;
    AuthIPList := TStringList.Create;
    AuthLangList := TStringList.Create;
    GameStateList := TStringList.Create;
    AuthUserIPList := TStringList.Create;
    TaskList:= TStringList.Create;
    BugTypeList := TStringList.Create;
    LoadStdItems;
    LoadServerList;
    LoadShopList;
  //  ServiceXML.LoadAwardConfig;
    LoadTasks;
    LoadLogIdent;
    LoadCommonList;

    ARobots:= TFileRoot.Create;
    ARobots.LoadRobotList;

    if FileExists(AppPath+AuthIPListFile) then
    begin
      AuthIPList.LoadFromFile(AppPath+AuthIPListFile);
    end;
    if FileExists(AppPath+'LangList.txt') then
    begin
      AuthLangList.LoadFromFile(AppPath+'LangList.txt');
    end;

    if FileExists(AppPath+UserIPListFile) then
    begin
      AuthUserIPList.LoadFromFile(AppPath+UserIPListFile);
    end;

    DataDispose := TDataDispose.Create;

    MyMsgList := TStringList.Create;

    Bobusy:= False;

   	BoRunClient := FALSE;
    TimerStart.Enabled := True;

    TimerNoticeRun.Enabled := True; //�ֶ���ʼ�� ��ֹ����
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.IWServerControllerBaseDestroy(Sender: TObject);
begin
  ClearServerListData;
  ServerList.Free;
  ClearStdItems;
  FStdItemList.Free;
  ClearShopListData(ShopList);
  ShopList.Free;
  objINI.Free;
  objServerINI.Free;
  LogIdentList.Free;
  CommonList.Free;
  TaskList.Free;
  DeleteCriticalSection( m_SafetyPassLock );
  FGSMServer.Stop;
  FGSMServer.Release();
  ZGSMServer.Stop;
  ZGSMServer.Release();
  DeleteCriticalSection(FPrintMsgLock);
  DeleteCriticalSection(FPrintMsgLockIW);
  SessionIDList.Free;
  ClearGSMsgListData;
  GSMsgList.Free;
  DeleteCriticalSection( m_SessionLoadLock );
  DeleteCriticalSection( m_WriteLogLock );
 // ServiceXML.Free;
 // AcrossRankList.Free;
  AuthIPList.Free;
  AuthLangList.Free;
  GameStateList.Free;
  AuthUserIPList.Free;
  BugTypeList.Free;
  DataDispose.Free;

  ARobots.Free;

  MyMsgList.Free;

  CoUninitialize;
end;

procedure TIWServerController.IWServerControllerBaseNewSession(
  ASession: TIWApplication; var VMainForm: TIWBaseForm);
begin
  if (AuthIPList.Count > 0) and (AuthIPList.IndexOf(ASession.IP) = -1) then
  begin
   // ASession.Terminate('δ��ȨIP');
    ASession.Terminate('Unauthorized IP');
    Exit;
  end;
  try
    EnterCriticalSection( m_SessionLoadLock );
    try
      ASession.Data := TIWUserSession.Create(nil);
      SessionIDList.Add(ASession.AppID);
    finally
      LeaveCriticalSection( m_SessionLoadLock );
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.TimerAutoRunTimer(Sender: TObject);
begin
  if SameTime(StrToTime(TimeToStr(Time)),StrToTime(objINI.LossBuildTime)) then
  begin
    EnterCriticalSection( m_SessionLoadLock );
    try
      LoadServerList;
    finally
      LeaveCriticalSection( m_SessionLoadLock );
    end;
    DataDispose.ExecEverydayData;
  end;
  if (DayOf(Now) = 1) and (SameTime(StrToTime(TimeToStr(Time)),StrToTime('0:00:00'))) then
  begin
    EnterCriticalSection( m_SessionLoadLock );
    try
      LoadServerList;
    finally
      LeaveCriticalSection( m_SessionLoadLock );
    end;
    DataDispose.ExecMonthlyData;
  end;
end;

procedure TIWServerController.TimerAutoUpdateTimer(Sender: TObject);
begin
  LoadServerList;
  LoadLogIdent;
end;

procedure TIWServerController.TimerNoticeRunTimer(Sender: TObject);
begin
  ARobots.ProcessRun;
end;

procedure TIWServerController.TimerStartTimer(Sender: TObject);
begin
  if not objINI.IWBoServer then //��ⲻ���ܺ�̨
  begin
     if not BoRunClient  then
     begin
        IWFClient.Close;
        IWFClient.Address := objINI.IWServerIP;
        IWFClient.Port := objINI.IWServerPort;
        IWFClient.Open;

        SendTimer.Enabled := True;
     end;
  end else
    TimerStart.Enabled := False;
end;

procedure TIWServerController.SetRobotMessage(spid: string; Idx, nMsgType, Num, nTick: Integer; sdata: string; daTime: TDateTime);
const
  sqlAdd = 'INSERT INTO %s.robotinfo VALUES ("%s",%d,%d,%s,%d,"%s",%d)';
  sqlUpdate = 'UPDATE %s.robotinfo SET numtype = %d , logdate = "%s" WHERE spid = "%s" and serverindex = %d and message = %s';
  sqlDel = 'DELETE FROM %s.robotinfo WHERE spid = "%s" and serverindex = %d and message=%s';
  sqlDel2 = 'DELETE FROM %s.robotinfo WHERE spid = "%s" and serverindex = %d and numtype in (3,4) and message=%s and logdate = "%s"';
  sqlDel3 = 'DELETE FROM %s.robotinfo WHERE spid = "%s" and serverindex = %d and numtype = 3 and logdate = "%s"';
var
  sSQL: string;
  psld: PTServerListData;
begin
  try
    psld := GetServerListData(spid, Idx);
    if psld = nil then Exit;
    ConnectionLogMysql(SQLConnectionRAuto,psld^.LogDB,psld^.LogHostName);
    try
      case Num of
        1, 2: //���� 1��ʱ���� 2��ʱɾ��
        begin
          sSQL := Format(sqlAdd,[psld^.GstaticDB, spid, Idx, nMsgType, QuerySQLStr(sdata), Num, FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime), nTick]);
        end;

        3, 4: //���� 3��ʱ���� 4��ʱɾ��
        begin
          sSQL := Format(sqlAdd,[psld^.GstaticDB, spid, Idx, nMsgType, QuerySQLStr(sdata), Num, FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime), nTick]);
        end;

        100: //ɾ�� ����
        begin
          sSQL := Format(sqlDel2,[psld^.GstaticDB, spid, Idx, QuerySQLStr(sdata), FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime)]);
        end;
        101: //ɾ�� ����
        begin
          sSQL := Format(sqlDel3,[psld^.GstaticDB, spid, Idx, FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime)]);
        end;
        102: //���� �޸�
        begin
          sSQL := Format(sqlUpdate,[psld^.GstaticDB, 4, FormatDateTime('YYYY-MM-DD hh:mm:ss',daTime), spid, Idx, QuerySQLStr(sdata)]);
        end;

        103: //ɾ�� ����
        begin
          sSQL := Format(sqlDel,[psld^.GstaticDB, spid, Idx, QuerySQLStr(sdata)]);
        end;
      end;
      quRobotInfo.SQL.Text := sSQL;
      quRobotInfo.ExecSQL;
      quRobotInfo.Close;
    finally
      SQLConnectionRAuto.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWServerController.SendAddNotices(spid: string; Idx, nMsgType, nTick: Integer; sdata: string);
var
  m_Server: TGSConnection;
begin
  m_Server := FGSMServer.GetServerByIndex(spid, Idx);
  if m_Server <> nil then
  begin
    m_Server.SendAddNotice(-1, nMsgType, nTick, sdata);
    ARobots.Delete(sdata, Idx);
    SetRobotMessage(spID, Idx, 0, 103, 0, sdata, Now);
  end;
end;

procedure TIWServerController.SendDelNotices(spid: string; Idx: Integer; sdata: string);
var
  m_Server: TGSConnection;
begin
  m_Server := FGSMServer.GetServerByIndex(spid, Idx);
  if m_Server <> nil then
  begin
    m_Server.SendDelNotice(-1, sdata);
    ARobots.Delete(sdata, Idx);
    SetRobotMessage(spID, Idx, 0, 103, 0, sdata, Now);
  end;
end;

procedure TIWServerController.SendSetExpRates(spid: string; Idx, ExpRate, ExpTime: Integer; sdata: string);
var
  m_Server: TGSConnection;
begin
  m_Server := FGSMServer.GetServerByIndex(spid, Idx);
  if m_Server <> nil then
  begin
    m_Server.SendSetExpRate(-1, ExpRate, ExpTime);
  end;
end;

procedure TIWServerController.SendCMSocket (sendstr: AnsiString);
begin
   if IWFClient.Socket.Connected then begin
      IWFClient.Socket.SendText ('#' + sendstr + '!');
   end;
end;


procedure TIWServerController.SendTimerTimer(Sender: TObject);
var
  data: string;
begin
   if Bobusy then exit;
   Bobusy := TRUE;
   try
      CBufferStr := CBufferStr + CSocStr;
      CSocStr := '';
      if CBufferStr <> '' then begin
         while Length(CBufferStr) >= 2 do begin
            if Pos('!', CBufferStr) <= 0 then break;
            CBufferStr := ArrestStringEx (CBufferStr, '#', '!', data);
            if data <> '' then begin
               DecodeMessagePacket (data);
            end else
               if Pos('!', CBufferStr) = 0 then
                  break;
         end;
      end;
   finally
      Bobusy := FALSE;
   end;
end;

function Move(AFormClass: TIWAppFormClass; IsRelease: Boolean = True): TIWAppForm;
var
  ComponentName: string;
begin
  ComponentName := Copy(AFormClass.ClassName,2,Length(AFormClass.ClassName)-1);
  if IsRelease then
    TIWAppForm(WebApplication.ActiveForm).Free
  else
    TIWAppForm(WebApplication.ActiveForm).Hide;
  if WebApplication.FindComponent(ComponentName) <> nil then begin
    Result := TIWAppForm(WebApplication.FindComponent(ComponentName));
  end else begin
    Result := AFormClass.Create(WebApplication);
  end;
end;

function NumberSort(List: TStringList; Index1,Index2: Integer): Integer;
var
  Value1,Value2:Double;
begin
  Value1:=StrToFloat(List[Index1]);
  Value2:=StrToFloat(List[Index2]);
  if   Value1> Value2   then
      Result:=-1
  else if Value1 <Value2 then
    Result:=1
  else
    Result:=0;
end;

function GetCellName(sText: string): string;
begin
  Result := sText;
  if Pos('</FONT>',sText) > 0 then
  begin
    Result := StringReplace(Result,'<FONT color=red>', '', [rfReplaceAll]);
    Result := StringReplace(Result,'</FONT>', '', [rfReplaceAll]);
  end;
end;

function ChangeZero(Value: Double): Double;overload;
begin
  Result := Value;
  if Value = 0 then Result := -1;
end;

function ChangeZero(Value: Integer): Integer;overload;
begin
  Result := Value;
  if Value = 0 then Result := -1;
end;

function DivZero(sValue,eValue: Double): Double;
begin
  Result := 0;
  if (sValue <> 0) and (eValue <> 0) then
  begin
    Result := sValue/eValue;
  end;
end;

function GetServerIndex(ServerName: string): string;
var
  SPos,EPos: Integer;
begin
  Result := '0';
  SPos := Pos('��',ServerName);
  if SPos > -1 then
  begin
    EPos := Pos('��',ServerName);
    if EPos > -1 then
    begin
      Result := Copy(ServerName,SPos+2,EPos-SPos-2);
    end;
  end;
end;

procedure ClearServerListData;
var
  I: Integer;
begin
  for I := 0 to ServerList.Count - 1 do
  begin
    System.DisPose(PTServerListData(ServerList.Objects[I]));
  end;
  ServerList.Clear;
end;

procedure ClearShopListData(pList: TStringList);
var
  I: Integer;
begin
  for I := 0 to pList.Count - 1 do
  begin
    TStringList(pList.Objects[I]).Free;
  end;
  pList.Clear;
end;

function GetHttpXML(sHttp: string): string;
var
  ResponseSteam: TStringStream;
  IdHttp: TIdHttp;
  hs: AnsiString;
begin
  Result := '';
  ResponseSteam := TStringStream.Create('',TEncoding.UTF8);
  IdHttp := TIdHttp.Create;
  IdHttp.HandleRedirects := True;
  try
    IdHttp.Get(sHttp,ResponseSteam);
    Result := ResponseSteam.DataString;
    SetLength(hs,3);
    ResponseSteam.Position := 0;
    ResponseSteam.Read(hs[1],3);
    if hs=#$EF#$BB#$BF then
    begin
      Result := ResponseSteam.ReadString(ResponseSteam.Size-3);
    end;
  finally
    IdHttp.Free;
    ResponseSteam.Free;
  end;
end;

procedure LoadServerList;
var
  I,J,n,iCount: Integer;
  sBonusKey,tmpXML, spD: string;
  xmlDoc : IXMLDOMDocument;
  xmlNode: IXMLDomNode;
  GroupList,NodeList: IXMLDomNodeList;
  psld: PTServerListData;
begin
  CoInitialize(nil);
  tmpXML := GetHttpXML(objINI.ServerListXML);
  if tmpXML <> '' then xmlText := tmpXML;
  xmlDoc := CoDOMDocument.Create();
  EnterCriticalSection(IWServerController.m_SessionLoadLock);
  try
    if xmlDoc.loadXML(xmlText) then
    begin
      ClearServerListData;
      objServerINI.ReadSections;
      xmlNode := xmlDoc.documentElement;
      GroupList := xmlNode.selectNodes('//Group');
      iCount:= 0;
      for I := 0 to objServerINI.SectionList.Count - 1 do
      begin
        New(psld);
        psld.Index := 0;
        psld.spid := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'��Ӫ��','wyi');
        spD := psld.spid;
        psld.ServerID := objServerINI.FConfigINI.ReadInteger(objServerINI.SectionList.Strings[I],'������IDֵ',0);
        psld.CurrencyRate := objServerINI.FConfigINI.ReadFloat(objServerINI.SectionList.Strings[I],'���Ҷһ���',1);
        psld.SessionHostName := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'�Ự������','127.0.0.1');
        psld.SessionHostName2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'�Ự������2','127.0.0.1');
        psld.LogHostName := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'��־������','127.0.0.1');
        psld.PassKey := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'��ȫ�ӿ�Key','wyi');
        psld.BonusKey := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'�����ӿ�Key','');

        psld.LogDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'LogDB','cq_log');
        psld.Amdb := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'Amdb','amdb');
        psld.Amdb2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'Amdb2','amdb');
        psld.AccountDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'AccountDB','cq_account');
        psld.AccountDB2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'AccountDB2','cq_account');
        psld.GstaticDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'GstaticDB','gstatic');
        sBonusKey :=  psld.BonusKey;
        psld.IsDisplay := True;
        ServerList.AddObject(objServerINI.SectionList.Strings[I],TObject(psld));

        if iCount > 0 then iCount := iCount + 1; //�ж��������0 +1��ֹ�б������

        for n := 0 to GroupList.length - 1 do
        begin
          NodeList := GroupList.item[n].selectNodes('Server');
          if spD = GroupList.item[n].attributes.getNamedItem('sp').nodeValue then
          begin
            PTServerListData(ServerList.Objects[iCount]).spID := GroupList.item[n].attributes.getNamedItem('sp').nodeValue;
            PTServerListData(ServerList.Objects[iCount]).Ispid := GroupList.item[n].attributes.getNamedItem('sid').nodeValue;
         //   sBonusKey := objServerINI.FConfigINI.ReadString(ServerList.Strings[i],'�����ӿ�Key','');
            for J := 0 to NodeList.length - 1 do
            begin
              New(psld);
              psld.CurrencyRate := 1;
              if I<objServerINI.SectionList.Count then
              begin
                psld.ServerID := objServerINI.FConfigINI.ReadInteger(objServerINI.SectionList.Strings[i],'������IDֵ',0);
                psld.CurrencyRate := objServerINI.FConfigINI.ReadFloat(objServerINI.SectionList.Strings[i],'���Ҷһ���',1);

                psld.LogDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'LogDB','cq_log');
                psld.Amdb := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'Amdb','amdb');
                psld.Amdb2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'Amdb2','amdb');
                psld.AccountDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'AccountDB','cq_account');
                psld.AccountDB2 := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'AccountDB2','cq_account');
                psld.GstaticDB := objServerINI.FConfigINI.ReadString(objServerINI.SectionList.Strings[I],'GstaticDB','gstatic');
              end;
              psld.Index := NodeList.item[J].attributes.getNamedItem('index').nodeValue;
              psld.SessionHostName := NodeList.item[J].attributes.getNamedItem('ss').nodeValue;
              psld.SessionHostName2 := NodeList.item[J].attributes.getNamedItem('ss').nodeValue;
              psld.RoleHostName := NodeList.item[J].attributes.getNamedItem('db').nodeValue;
              psld.LogHostName := NodeList.item[J].attributes.getNamedItem('log').nodeValue;
              psld.IsDisplay := NodeList.item[J].attributes.getNamedItem('display').nodeValue;
              psld.OpenTime := NodeList.item[J].attributes.getNamedItem('time').nodeValue;
              psld.JoinIdx := NodeList.item[J].attributes.getNamedItem('join').nodeValue;
              psld.spID := GroupList.item[n].attributes.getNamedItem('sp').nodeValue;
              psld.Ispid := GroupList.item[n].attributes.getNamedItem('sid').nodeValue;
              psld.BonusKey := sBonusKey;
              psld.DataBase := NodeList.item[J].attributes.getNamedItem('database').nodeValue;
              ServerList.AddObject(NodeList.item[J].attributes.getNamedItem('name').text,TObject(psld));
              Inc(iCount, 1);
            end;
          end;
        end;
      end;
    end;
  finally
    xmlDoc := nil;
    LeaveCriticalSection( IWServerController.m_SessionLoadLock );
    CoUninitialize;
  end;
end;

procedure LoadShopList;
var
  I,J: Integer;
  cbp: IComBinaryProperty;
  ValueField,ItemsField,TableField,LuaField: ILuaField;
  tmpList: TStringList;
begin
  cbp := CreateLocalComBinaryProperty;
  EnterCriticalSection(IWServerController.m_SessionLoadLock);
  try
    LuaField := cbp.LoadHttpCBP(objINI.ShopListXML);
    ClearShopListData(ShopList);
    for I := 0 to LuaField.FieldCount-1 do
    begin
      TableField := LuaField.FieldIndex[I].AsTable;  //���б�

      if TableField <> nil then
      begin
        ItemsField := TableField.Fields['Items'].AsTable;   //�����б�
        tmpList := TStringList.Create;
        for J:= 0 to ItemsField.FieldCount-1 do
        begin
          ValueField := ItemsField.FieldIndex[J];  //������Ҫȡ�������б�
          tmpList.AddObject(OnGetStdItemName(ValueField.Fields['Item'].AsInteger),TObject(ValueField.Fields['Price'].FieldIndex[0].Fields['Price'].AsInteger));
        end;
        ShopList.AddObject(TableField.Fields['Name'].AsString,TObject(tmpList));
      end;
    end;
  finally
    cbp := nil;
    LeaveCriticalSection( IWServerController.m_SessionLoadLock );
  end;
end;

procedure LoadStdItems;
var
  I: Integer;
  pStdItem: pTStdItem;
  cbp: IComBinaryProperty;
  TableField,LuaField: ILuaField;
begin
  cbp := CreateLocalComBinaryProperty;
  EnterCriticalSection(IWServerController.m_SessionLoadLock);
  try
    LuaField := cbp.LoadHttpCBP(objINI.ItemListXML);
    ClearStdItems;
    for I := 0 to LuaField.FieldCount-1 do
    begin
      TableField := LuaField.FieldIndex[I].AsTable;
      if TableField <> nil then
      begin
        New(pStdItem);
        FillChar(pStdItem^,SizeOf(pStdItem^),0);
        pStdItem^.Name := ShortString(TableField.Fields['name'].AsString);
        if TableField.FieldExists['dup'] then
        begin
          pStdItem^.Dup := TableField.Fields['dup'].AsInteger;
        end;
        pStdItem^.ItemDateTime := 0;
        FStdItemList.AddObject(string(pStdItem^.Name),TObject(pStdItem));
      end;
    end;
  finally
    cbp := nil;
    LeaveCriticalSection( IWServerController.m_SessionLoadLock );
  end;
end;

procedure ClearStdItems;
var
  I: Integer;
begin
  for I := 0 to FStdItemList.Count - 1 do
  begin
    System.Dispose(pTStdItem(FStdItemList.Objects[I]));
  end;
  FStdItemList.Clear;
end;

procedure LoadTasks;
var
  i: Integer;
  pTask: PTTask;
  cbp: IComBinaryProperty;
  TableField,TableField2,LuaField: ILuaField;
begin
  cbp := CreateLocalComBinaryProperty;
  EnterCriticalSection(IWServerController.m_SessionLoadLock);
  try
    LuaField := cbp.LoadHttpCBP(objINI.TaskListXML);
    ClearTasks;
    for I := 0 to LuaField.FieldCount-1 do
    begin
      TableField := LuaField.FieldIndex[I].AsTable;
      try
        if TableField <> nil then
        begin
          New(pTask);
          pTask^.nTaskID := TableField.Fields['Id'].AsInteger;
          pTask^.sTaskName := ShortString(TableField.Fields['Name'].AsString);
          pTask^.bType := TableField.Fields['Type'].AsInteger;
          pTask^.nParentID :=  TableField.Fields['ParentID'].AsInteger;

          if TableField.FieldExists['conds'] then  //��ȡ���б�..
          begin
             TableField2:=  TableField.Fields['conds'].FieldIndex[0].AsTable;
             if TableField2 <> nil then
             begin
               pTask^.bAcceptLevel := TableField2.Fields['count'].AsInteger;
               pTask^.bMaxLevel := TableField2.Fields['id'].AsInteger;
             end;
          end;
          if TableField.FieldExists['prom'] then  //��ȡ���б�..
          begin
            pTask^.sTaskMapName := ShortString(TableField.Fields['prom'].Fields['scene'].AsString);
          end;

          TaskList.AddObject(string(pTask^.sTaskName),TObject(pTask))
        end;
      except
        continue;
      end;

    end;
  finally
    cbp := nil;
    LeaveCriticalSection( IWServerController.m_SessionLoadLock );
  end;
end;

procedure ClearTasks;
var
  I: Integer;
begin
  for I := 0 to TaskList.Count - 1 do
  begin
    System.Dispose(pTTask(TaskList.Objects[I]));
  end;
  TaskList.Clear;
end;

procedure LoadLogIdent;
var
  tmpXML: string;
begin
  tmpXML := GetHttpXML(objINI.LogIdentFile);
  if tmpXML <> '' then LogIdentList.Text := tmpXML;
end;

procedure LoadCommonList;
var
  tmpXML: string;
begin
  tmpXML := GetHttpXML(objINI.CommandFile);
  if tmpXML <> '' then CommonList.Text := tmpXML;
end;

procedure ClearWebGridDataList(DataList: TStringList);
var
  I: Integer;
begin
  for I := 0 to DataList.Count - 1 do
  begin
    System.Dispose(PTStringArray(DataList.Objects[I]));
  end;
  DataList.Clear;
end;

function GetServerListDataBySPID(const sSPID: string): PTServerListData;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ServerList.Count - 1 do
  begin
    if PTServerListData(ServerList.Objects[I]).spID = sSPID then
    begin
      Result := PTServerListData(ServerList.Objects[I]);
      break;
    end;
  end;
end;

function GetServerListData(sServerName: string): PTServerListData; overload;
begin
  Result := PTServerListData(ServerList.Objects[ServerList.IndexOf(sServerName)]);
end;

function GetServerListData(iServerIndex: Integer): PTServerListData; overload;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ServerList.Count - 1 do
  begin
    if PTServerListData(ServerList.Objects[I]).Index = iServerIndex then
    begin
      Result := PTServerListData(ServerList.Objects[I]);
      break;
    end;
  end;
end;
//������ SPID �� ������ID�ж�
function GetServerListData(spid: string; iServerIndex: Integer): PTServerListData; overload;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ServerList.Count - 1 do
  begin
    if (PTServerListData(ServerList.Objects[I]).Index = iServerIndex) and
       (PTServerListData(ServerList.Objects[I]).spID = spid)
    then
    begin
      Result := PTServerListData(ServerList.Objects[I]);
      break;
    end;
  end;
end;

function GetServerListName(spid: string;iServerIndex: Integer; CheckJoin: Boolean = False): string;
var
  I: Integer;
  psld: PTServerListData;
begin
  Result := '';
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if (psld^.Index = iServerIndex) and (psld^.spID = spid) then
    begin
      Result := ServerList.Strings[I];
      if CheckJoin then
      begin
        if psld^.JoinIdx > 0 then
        begin
          Result := GetServerListName(psld^.spID, psld^.JoinIdx);
        end;
      end;
      break;
    end;
  end;
end;

function GetServerListNameEx(iServerIndex: Integer; CheckJoin: Boolean = False): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to ServerList.Count - 1 do
  begin
    if PTServerListData(ServerList.Objects[I]).Index = iServerIndex then
    begin
      Result := ServerList.Strings[I];
      if CheckJoin then
      begin
        if PTServerListData(ServerList.Objects[I]).JoinIdx > 0 then
        begin
          Result := GetServerListNameEx(PTServerListData(ServerList.Objects[I]).JoinIdx);
        end;
      end;
      break;
    end;
  end;
end;


function GetRecordCount(sSQL: string; Query: TSQLQuery): Integer;
begin
  with Query do
  begin
    SQL.Text := sSQL;
    Open;
    Result := Query.Fields.FieldByNumber(1).AsInteger;
    Close;
  end;
end;

function GetServerIsdisplay(spid: string;ServerIndex: Integer): Boolean;
var
  I: Integer;
  pServerListData: PTServerListData;
begin
  Result := False;
  for I := 0 to ServerList.Count - 1 do
  begin
    pServerListData := PTServerListData(ServerList.Objects[I]);
    if (pServerListData^.Index = ServerIndex) and (pServerListData^.spID = spid) then
    begin
      Result := PTServerListData(ServerList.Objects[I]).IsDisplay;
      break;
    end;
  end;
end;

function OnGetStdItemName(const StdItemIdx: Integer): string;
begin
  if (StdItemIdx <= 0) or (StdItemIdx >= FStdItemList.Count) then
    Result := ''
  else Result := FStdItemList[StdItemIdx];
end;

function OnGetTaskName(const StdTaskIdx: Integer): PTTask; overload;
var
  I: Integer;
  pTask: PTTask;
begin
  Result := nil;
  for I := 0 to TaskList.Count - 1 do
  begin
    pTask := PTTask(TaskList.Objects[I]);
    if pTask^.nTaskID = StdTaskIdx then
    begin
      Result := pTask;
      break;
    end;
  end;
end;

function GetZyName(zyID1,zyID2: Integer): string;
begin
  if (zyID1 <> 0) and (zyID2 <> 0) then
  begin
    Result := ZyNameStr[zyID1] + '����' + ZyNameStr[zyID2];
  end
  else begin
    Result := ZyNameStr[zyID1];
    if zyID1 = 0 then Result := ZyNameStr[zyID2];
    if Result = ZyNameStr[0] then Result := '������';
  end;
end;

function GetLogIdentStr(const nIdent: Integer): string;
var
  I,iPos,iValue: Integer;
  strTmp: string;
begin
  Result := 'N/A('+IntToStr(nIdent)+')';
  for I := 0 to LogIdentList.Count - 1 do
  begin
    strTmp := LogIdentList.Strings[I];
    iPos := Pos('��',strTmp);
    if iPos > 0 then
    begin
      iValue := StrToInt(Copy(strTmp,1,iPos-1));
      if iValue = nIdent then
      begin
        Result := Copy(strTmp,iPos+1,length(strTmp));
        break;
      end;
    end;
  end;
end;

procedure WriteErrorFile(IsDate: Boolean; sText: string);
const
  ErrorDir = 'Error\';
var
  F: TextFile;
  sDate: string;
  Logfile: string;
begin
  if not DirectoryExists(AppPathEx + ErrorDir) then
  begin
    CreateDir(AppPathEx + ErrorDir);
  end;
  LogFile := AppPathEx + ErrorDir + FormatDateTime('YYYYMMDD',Date)+'.txt';
  AssignFile(F, LogFile);
  if FileExists(LogFile) then
    Append(F)
  else
    Rewrite(F);
  sDate := DateTimeToStr(Now) + ':';
  if not IsDate then sDate := '';
  Writeln(F, sDate + sText);
  CloseFile(F);
end;

function GetSessionDMessage(AppID: string): Integer;
var
  I,Recog: Integer;
  pDefMsg: PTDefaultMessage;
begin
  Result := -1;
  Recog := SessionIDList.IndexOf(AppID);
  for I := 0 to GSMsgList.Count - 1 do
  begin
    pDefMsg := PTDefaultMessage(GSMsgList.Objects[I]);
    if Recog = pDefMsg.Recog then
    begin
      Result := I;
      break;
    end;
  end;
end;

function GetSessionIWMessage(AppID: string): Integer;
var
  I,Recog: Integer;
  pDefMsg: PTDefaultMessage;
begin
  Result := -1;
  Recog := SessionIDList.IndexOf(AppID);
  for I := 0 to MyMsgList.Count - 1 do
  begin
    pDefMsg := PTDefaultMessage(MyMsgList.Objects[I]);
    if Recog = pDefMsg.Recog then
    begin
      Result := I;
      break;
    end;
  end;
end;

function GSIWResultStr(AppID: string): string;
const
  SuccessStr: array [0..1] of string = ('�ɹ�', 'ʧ��');
  ResultStr = '%d<%s> %s';
var
  Idx,IsSuccess: Integer;
  ServerName: string;
  pDefMsg: PTDefaultMessage;
begin
  Result := '';
  EnterCriticalSection(FPrintMsgLockIW);
  try
    pDefMsg := nil; IsSuccess := 1;
    Idx := GetSessionIWMessage(AppID);
    if Idx <> -1 then
    begin
      pDefMsg := PTDefaultMessage(MyMsgList.Objects[Idx]);
      ServerName := GetServerListName(PTServerListData(ServerList.Objects[0])^.spID, 0);
    end;
    if pDefMsg <> nil then
    begin
      if pDefMsg^.Tag > 1 then pDefMsg^.Tag := 1;
      case pDefMsg^.Ident of
        CM_RELOADDATALL:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'���¼�����������' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_RELOADNPC:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ��NPC' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_RELOAD_FUNCTION:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ�¹��ܽű�' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_REFRESHCORSS:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ�¿������' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_RELOADCONFIG:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ����������' + SuccessStr[pDefMsg^.Tag]]);
        end;
        CM_RELOADLANG:
        begin
           if pDefMsg^.Tag = 0 then IsSuccess := 0;
           Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ�����԰�' + SuccessStr[pDefMsg^.Tag]]);
        end;
      end;
      if Idx < MyMsgList.Count then
      begin
        System.Dispose(pDefMsg);
        MyMsgList.Delete(Idx);
      end;
    end;
  finally
    LeaveCriticalSection(FPrintMsgLockIW);
  end;
end;

function GSResultStr(AppID, spid: string): string;
const
  SuccessStr: array [0..3] of string = ('�ɹ�', 'ʧ��', '�ѿ���', 'δ����');
  SuccessStrEx: array [0..2] of string = ('�ɹ�','�Ѵ���', 'ʧ��');
  ResultStr = '%d<%s> %s';
var
  Idx,IsSuccess,ServerIndex: Integer;
  ServerName,sData,sStr: string;
  pDefMsg: PTDefaultMessage;
begin
  Result := '';
  EnterCriticalSection(FPrintMsgLock);
  try
    pDefMsg := nil; IsSuccess := 1;
    Idx := GetSessionDMessage(AppID);
    if Idx <> -1 then
    begin
      pDefMsg := PTDefaultMessage(GSMsgList.Objects[Idx]);
      sStr := GSMsgList.Strings[Idx];
      ServerIndex := StrToInt(Copy(sStr,1,Pos('|',sStr)-1));
      sData := Copy(sStr,Pos('|',sStr)+1,Length(sStr));
      ServerName := GetServerListName(spid, ServerIndex);
    end;

    if pDefMsg <> nil then
    begin
      //if pDefMsg^.Tag > 1 then pDefMsg^.Tag := 1; Old
      if pDefMsg^.Tag > 3 then pDefMsg^.Tag := 3;
      case pDefMsg^.Ident of
        //����ˢ��NPC���(tagΪ0��ʾ�ɹ��������ʾʧ�ܡ�param��ʾ���ص�NPC����)
        MCS_RELOADNPC_RET:
        begin
          Result := Format(ResultStr,[1,ServerName,'ˢ��NPC' + SuccessStr[1]]);
          if (pDefMsg^.Tag = 0) and (pDefMsg^.Param > 0) then
          begin
            Result := Format(ResultStr,[0,ServerName,'ˢ��NPC' + SuccessStr[0]]);
          end;
        end;
        //����ˢ�¹�����(tagΪ0��ʾ�ɹ�,�����ʾʧ�ܣ���ʧ��ʱ���ݶ�Ϊ�����Ĵ��������ַ���)
        MCS_RELOADNOTICE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���¼��ع���' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //�����߽�ɫ���߽��(tagΪ0��ʾ�ɹ���1��ʾ��ɫ������)
        MCS_KICKPLAY_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'�߽�ɫ����' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //�������˺����߽��(tagΪ0��ʾ�ɹ���1��ʾ��ɫ������)
        MCS_KICKUSER_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���û�����' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //���ز�ѯ��ɫ�Ƿ����߽��(tagΪ1��ʾ����)
        MCS_QUERYPLAYONLINE_RET:
        begin
          IsSuccess := 0;
          if pDefMsg^.Tag = 1 then Result := Format(ResultStr,[IsSuccess,ServerName,'��ɫ����']) else Result := Format(ResultStr,[IsSuccess,ServerName,'��ɫ������']);
        end;
        //���ز�ѯ�˺��Ƿ����߽��(tagΪ1��ʾ����)
        MCS_QUERYUSERONLINE_RET:
        begin
          IsSuccess := 0;
          if pDefMsg^.Tag = 1 then Result := Format(ResultStr,[IsSuccess,ServerName,'�û�����']) else Result := Format(ResultStr,[IsSuccess,ServerName,'�û�������']);
        end;
        //������ӹ�����(tagΪ0��ʾ�ɹ�)
        MCS_ADDNOTICE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;

          Result := Format(ResultStr,[IsSuccess,ServerName,'��ӹ���' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //����ɾ��������(tagΪ0��ʾ�ɹ���1��ʾ�����ڴ˹�������)
        MCS_DELNOTICE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'ɾ������' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //���ؽ��뵹��ʱά�����(tagΪ0��ʾ�ɹ�)
        MCS_DELAY_UPHOLE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'����ʱά��' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //����ȡ������ʱά��״̬���(tagΪ0��ʾ�ɹ�)
        MCS_CANLCE_UPHOLE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'ȡ������ʱά��' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //�������þ��鱶�ʽ��(tagΪ0��ʾ�ɹ���paramΪʵ�����õı��ʣ����ܲ�ͬ���������õı���)
        MCS_SET_EXPRATE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;

          Result := Format(ResultStr,[IsSuccess,ServerName,'���þ��鱶��' + SuccessStr[pDefMsg^.Tag] +'�����鱶��Ϊ��' + IntToStr(pDefMsg^.Param)]);
        end;
        //���ؽ��Խ��(tagΪ0��ʾ�ɹ�)
        MCS_SHUTUP_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���ý���' + SuccessStr[pDefMsg^.Tag] +'������ʱ��Ϊ��' + IntToStr(pDefMsg^.Param)+ '����']);
        end;
        //���ؽ���Խ��(tagΪ0��ʾ�ɹ�)
        MCS_RELEASESHUTUP_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'�������' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //ˢ�¹��ܽű����(tagΪ0��ʾ�ɹ�)
        MCS_RELOAD_FUNCTION_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ�¹��ܽű�' + SuccessStr[pDefMsg^.Tag]]);
        end;
         //��̨���¼��ص�½�ű����(tagΪ0��ʾ�ɹ�)
        MCS_RELOAD_LOGIN_SCRIPT_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ�µ�½�ű�' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //��̨���¼��ػ����˽ű����(tagΪ0��ʾ�ɹ�)
        MCS_RELOAD_ROBOTNPC_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ�»����˽ű�' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //��̨���¼����̳���Ʒ���(tagΪ0��ʾ�ɹ�)
        MCS_RELOAD_SHOP_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ���̳���Ʒ' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //��ȡ���浱ǰ���ڴ�ʹ�������(tagΪ0��ʾ�ɹ�,��ʱParamΪ�ڴ�ʹ����,��λ: MB)
        MCS_GET_CURR_PROCESS_MEM_USED_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,Format('��ǰ�ڴ�ʹ����(%d MB)',[pDefMsg^.Param])]);
        end;
        //��̨��������ӷ���(��Ԫ��)�ķ��ؽ��(tagΪ0��ʾ�ɹ�, 1��ʾ���ﲻ���߻��߽�ɫ������ȷ)
        MCS_ADD_PLAYER_RESULTPOINT_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          if pDefMsg^.Tag = 0 then
          begin
            Result := Format(ResultStr,[IsSuccess,ServerName,'���Ӱ�Ԫ��'+SuccessStr[pDefMsg^.Tag]+'�����ӣ�' + IntToStr(pDefMsg^.Param)+'��Ԫ��']);
          end
          else begin
            Result := Format(ResultStr,[IsSuccess,ServerName,'���Ӱ�Ԫ��'+SuccessStr[pDefMsg^.Tag]+'�����ﲻ���߻��߽�ɫ������ȷ']);
          end;
        end;
        //���¼������ַ��Թ�����Ϣ��(tagΪ0��ʾ�ɹ�)
        MCS_RELOAD_ABUSEINFORMATION_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���¼������ַ��Թ�����Ϣ��' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //���¼��ع���ű�(tagΪ0��ʾ�ɹ�)
        MCS_RELOAD_MONSTER_SCRIPT_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���¼��ع���ű�' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //�����Ĳ�ϵͳ����(tagΪ0��ʾ�ɹ�)
        MCS_OPEN_GAMBLE:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'�����Ĳ�ϵͳ' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //�رնĲ�ϵͳ����(tagΪ0��ʾ�ɹ�)
        MCS_CLOSE_GAMBLE:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'�رնĲ�ϵͳ' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //�������ϵͳ����(tagΪ0��ʾ�ɹ�)
        MCS_OPEN_COMMONSERVER:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'�������ϵͳ' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //�رտ��ϵͳ����(tagΪ0��ʾ�ɹ�)
        MCS_CLOSE_COMMONSERVER:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'�رտ��ϵͳ' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //���غ�̨�����ֱ�ӷ���������Ϣ���(tagΪ0��ʾ�ɹ�)
        MCS_SEND_OFFMSGTOACOTOR:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'����ҷ���������Ϣ' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //��̨������������ (tagΪ0��ʾ�ɹ� ���򷵻ص�ǰ�����Ĳ�������ID)
        MCS_OPEN_COMPENSATE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���ò�������ID' + SuccessStr[pDefMsg^.Tag] +'������IDΪ��' + IntToStr(pDefMsg^.Param)]);
        end;

        //��̨�رղ������� (tagΪ0��ʾ�ɹ�)
        MCS_CLOSE_COMPENSATE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'��̨�رղ���' + SuccessStr[pDefMsg^.Tag] +'����ǰ����IDΪ��' + IntToStr(pDefMsg^.Param)]);
        end;
        //��̨��������֣�ParamΪ0��ʾ�ɹ���1 ��ʾ�Ѵ��������֣�2 ��ʾʧ�ܣ�
        MCS_RETURN_FILTER_RET:
        begin
          if pDefMsg^.Param > 2 then pDefMsg^.Param:= 2;
          if pDefMsg^.Param = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'��̨����������' + SuccessStrEx[pDefMsg^.Param]]);
        end;
        //���غ�̨�����������������ʽ��(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_DROPRATE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'��̨������������������' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //������ҵ�����  (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_QUICKSOFT_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'������ҵ�����' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //��������ȼ� (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_CHATLEVEL_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'��������ȼ�' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //���غ�̨ɾ���л� (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_DELGUILD_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'��̨ɾ���л�' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //�������õİٷ����� (tagΪ0��ʾ�ɹ���1��ʾ����ʧ�� )
        MCS_RETURN_HUNDREDSERVER:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���ðٷ��' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //���غ�̨�����������ý�� (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_RELOADCONFIG:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'��̨������������' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //���غ�̨���úϷ�����ʱ (tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MSS_DELAY_COMBINE_RET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'�Ϸ�����ʱ' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //���غ�̨ˢ�¿������(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_REFRESHCORSS:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'ˢ�¿������' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //�������ÿ���ķ�����ID(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_SET_COMMON_SRVID:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���ÿ��������ID' + SuccessStr[pDefMsg^.Tag] +'�����ID��' + IntToStr(pDefMsg^.Param)]);
        end;
        //���ػ�ȡ����ķ�����Id(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_GET_COMMON_SRVID:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'��ȡ����ķ�����ID' + SuccessStr[pDefMsg^.Tag] +'�����ID��' + IntToStr(pDefMsg^.Param)]);
        end;
        //��̨���þ�ϲ��������(tagΪ0��ʾ�ɹ���1��ʾ����ʧ�ܣ�2��ʾ�ѿ���)
        MCS_RETURN_SET_SURPRISERET:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���þ�ϲ����' + SuccessStr[pDefMsg^.Tag]+'������ID��' + IntToStr(pDefMsg^.Param)]);
        end;
        //����Ѱ��Ԫ������(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RESET_GAMBLE:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'����Ѱ��Ԫ������' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //���غ�̨��������(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_CHANGENAME:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���غ�̨��������' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //��������һع���(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_OLDPLYBACK:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'��������һع�' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //���ؼ������԰�(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_RELOADLAND:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���ؼ������԰�' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //��̨�����Ź�����(tagΪ0��ʾ�ɹ���1��ʾ����ʧ�ܣ�2��ʾ�ѿ���)
        MCS_RETURN_SET_GROUPON:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'�����Ź�ID' + SuccessStr[pDefMsg^.Tag]+'������ID��' + IntToStr(pDefMsg^.Param)]);
        end;
        //���غ�̨���������ħս��(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RETURN_CROSSBATTLE:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'���ؿ����ħս��' + SuccessStr[pDefMsg^.Tag] ]);
        end;
        //���ػ�ȡ����ķ�����Id(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MSS_RETURN_CROSSBATTLENUM:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'�������ÿ����ħս������' + SuccessStr[pDefMsg^.Tag]]);
        end;
        //����ˢ�¹��ܽű�(tagΪ0��ʾ�ɹ���1��ʾ����ʧ��)
        MCS_RELOAD_ITMEFUNCTION:
        begin
          if pDefMsg^.Tag = 0 then IsSuccess := 0;
          Result := Format(ResultStr,[IsSuccess,ServerName,'����ˢ�¹��ܽű�' + SuccessStr[pDefMsg^.Tag] ]);
        end;
      end;
      if Idx < GSMsgList.Count then
      begin
        System.Dispose(pDefMsg);
        GSMsgList.Delete(Idx);
      end;
    end;
  finally
    LeaveCriticalSection(FPrintMsgLock);
  end;
end;

procedure ClearGSMsgListData;
var
  I: Integer;
begin
  for I := 0 to GSMsgList.Count - 1 do
  begin
    System.DisPose(PTDefaultMessage(GSMsgList.Objects[I]));
  end;
  GSMsgList.Clear;
end;

procedure LoadGSServers(CheckListBox: TTIWCheckListBox; spID: string; IsDisplay: Boolean = True); overload;
var
  I: Integer;
  psld: PTServerListData;
begin
  CheckListBox.Items.Clear;
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if (psld.Index<>0) and (psld.spID=spID) then
    begin
      if IsDisplay then
      begin
        if psld.IsDisplay then
        begin
          CheckListBox.Items.AddObject(ServerList.Strings[I],TObject(psld.Index));
          CheckListBox.Selected[CheckListBox.Items.Count-1] := IsDisplay;
        end;
      end
      else begin
        CheckListBox.Items.AddObject(ServerList.Strings[I],TObject(psld.Index));
        CheckListBox.Selected[CheckListBox.Items.Count-1] := IsDisplay;
      end;
    end;
  end;
end;

procedure LoadGSServers(StringList: TStringList; spID: string; IsDisplay: Boolean = True); overload;
var
  I: Integer;
  psld: PTServerListData;
begin
  StringList.Clear;
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if (psld.Index<>0) and (psld.spID=spID) then
    begin
      if IsDisplay then
      begin
        if psld.IsDisplay then
        begin
          StringList.AddObject(ServerList.Strings[I],TObject(psld.Index));
        end;
      end
      else begin
        StringList.AddObject(ServerList.Strings[I],TObject(psld.Index));
      end;
    end;
  end;
end;

procedure AppExceptionLog(sClassName: string; E: Exception);
begin
  EnterCriticalSection( m_WriteLogLock );
  try
    WriteErrorFile(True,Format('%s��Ԫ������һ��δԤ�ϵ��쳣���쳣��Ϊ��%s', [sClassName,E.ClassName]) + #13#10+
                 #9'�쳣����Ϊ��' + E.Message);
  finally
    LeaveCriticalSection( m_WriteLogLock );
  end;
end;

function GetShopItemPrice(pList: TStringList;ItemName: string): Integer;
var
  I,Idx: Integer;
  tmpList: TStringList;
begin
  Result := 0;
  for I := 0 to pList.Count - 1 do
  begin
    tmpList := TStringList(pList.Objects[I]);
    Idx := tmpList.IndexOf(ItemName);
    if Idx <> -1 then
    begin
      Result := Integer(tmpList.Objects[Idx]);
      break;
    end;
  end;
end;

function DecryptZJHTKey(sKey: string): AnsiString;
begin
  Result := '';
  if sKey <> '' then
  begin
    Result := DecryptString(AnsiString(sKey),AnsiString(GetRealKey(DBLogin_AESKey)));
  end;
end;

function UrlEncode(const ASrc: AnsiString): AnsiString;
const
  UnsafeChars = '*#%<>+ []';
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(ASrc) do begin
    if (AnsiPos(string(ASrc[i]), UnsafeChars) > 0) or (ASrc[i]< #32) or (ASrc[i] > #127) then begin
      Result := Result + '%' + AnsiString(IntToHex(Ord(ASrc[i]), 2));
    end else begin
      Result := Result + ASrc[i];
    end;
  end;
end;

function BuildSerialNO: string;
var
  strTmp: string;
begin
  Inc(SerialNO);
  if SerialNO > 9999 then SerialNO := 1;
  strTmp := StringOfChar('0',4-Length(IntToStr(SerialNO)))+IntToStr(SerialNO);
  Result := 'HT'+FormatDateTime('YYYYMMDDHHMMSS',Now())+strTmp;
end;

function SecondToTime(I:integer):string;
const
  DayS = 86400;
var
  iDay,iSecond: Integer;
begin
  iDay := (I div DayS);
  iSecond := I;
  if iDay > 0 then
  begin
    iSecond := I-(iDay*DayS);
  end;
  Result := Format('%d��%s',[iDay,TimeToStr(iSecond/DayS)]);
end;

function GetSQLJob: string;
var
  I: Integer;
begin
  Result := 'CASE job ';
  for I := Low(sRoleJob) to High(sRoleJob) do
  begin
    Result := Result+Format(' WHEN %d THEN "%s" ',[I, UserSession.ALangs.Find(UserSession.iLangNum, sRoleJob[I])]);
  end;
  Result := Result+' ELSE "δְ֪ҵ" END';
end;

function GetExtSysICon(sExt: string): HIcon;
var
  sinfo: SHFILEINFO;
begin
  ZeroMemory(@sinfo,   sizeof(sinfo));
  SHGetFileInfo(PChar(sExt),   FILE_ATTRIBUTE_NORMAL,
  sinfo,   sizeof(sinfo),   SHGFI_USEFILEATTRIBUTES   or   SHGFI_ICON);
  Result := sinfo.hIcon;
end;

function StrToHex(str: string; AEncoding: TEncoding): string;
var
  ss: TStringStream;
  i: Integer;
begin
  Result := '';
  ss := TStringStream.Create(str, AEncoding);
  for i := 0 to ss.Size - 1 do
    Result := Result + Format('%.2x', [ss.Bytes[i]]);
  ss.Free;
end;

function QuerySQLStr(sFieldName: string): string;
const
  CONVERTEncoding = 'convert(0x%s using latin1)';
begin
  Result := '""';
  if sFieldName <> '' then
  begin
    Result := Format(CONVERTEncoding,[StrToHex(sFieldName,TEncoding.UTF8)]);
  end;
end;

function QuerySQLStrEx(sFieldName: string): string;
const
  CONVERTEncoding = 'CONCAT("%s",convert(0x%s using latin1),"%s")';
var
  iLen: Integer;
  sValue,eValue: string;
begin
  Result := '""';
  if sFieldName <> '' then
  begin
    iLen := Length(sFieldName);
    sValue := ''; eValue := '';
    if sFieldName[1] = '%' then sValue := '%';
    if sFieldName[iLen] = '%' then eValue := '%';
    Result := Format(CONVERTEncoding,[sValue,StrToHex(sFieldName,TEncoding.UTF8),eValue]);
  end;
end;

function ParameterIntValue(pStr: string): Integer;
var
  iPos,iTmp: Integer;
begin
  Result := 0;
  iPos := Pos(#32,pStr);
  if iPos = 0 then
  begin
    iPos := Pos(#9,pStr);
  end;
  if iPos > 0 then
  begin
    if TryStrToInt(Copy(pStr,iPos+1,Length(pStr)),iTmp) then
    begin
      Result := iTmp;
    end;
  end;
end;

function ParameterStrValue(pStr: string): string;
var
  iPos: Integer;
begin
  Result := '';
  iPos := Pos(#32,pStr);
  if iPos = 0 then
  begin
    iPos := Pos(#9,pStr);
  end;
  if iPos > 0 then
  begin
    Result := Copy(pStr,1,iPos-1);
  end;
end;
//ȡ�ո����ַ���
function ParameterStrValueEx(pStr: string): string;
var
  iPos: Integer;
begin
  Result := '';
  iPos := Pos(#32,pStr);
  if iPos = 0 then
  begin
    iPos := Pos(#9,pStr);
  end;
  if iPos > 0 then
  begin
    Result := Copy(pStr,iPos+1,Length(pStr));
  end;
end;

function GetJoinServerIndex(iServerIndex: Integer): string;
var
  I: Integer;
  psld: PTServerListData;
begin
  psld := GetServerListData(iServerIndex);
  Result := IntToStr(iServerIndex-psld^.ServerID);
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    if psld^.JoinIdx = iServerIndex then
    begin
      Result := Result+','+IntToStr(psld^.Index-psld^.ServerID);
    end;
  end;
end;

function GetFirstOpenTime(spId: string): TDateTime;
var
  I: Integer;
  pServerListData: PTServerListData;
begin
  Result := Now;
  for I := 0 to ServerList.Count - 1 do
  begin
    pServerListData := PTServerListData(ServerList.Objects[I]);
    if (pServerListData^.spID = spId) and (pServerListData^.Index <> 0) then
    begin
      if pServerListData^.OpenTime <> '' then
      begin
        Result := StrToDateTime(pServerListData^.OpenTime);
      end;
      break;
    end;
  end;
end;

function InttoCurrType(num: Integer): string; //���ӻ����������
begin
  case num of
     0: Result:= '�󶨽��';
     1: Result:= '���';
     2: Result:= '��ȯ';
     3: Result:= 'Ԫ��';
     4: Result:= '����';
     5: Result:= '����';
  else
     Result:= 'δ֪';
  end;
end;

function Str_ToInt (Str: string; def: Longint): Longint; //�ַ���תint
begin
   Result := def;
   if Str <> '' then begin
      if ((word(Str[1]) >= word('0')) and (word(str[1]) <= word('9'))) or
         (str[1] = '+') or (str[1] = '-')
      then
      try
         Result := StrToInt (Str);
      except
         Result := def;
      end;
   end;
end;

function Str_ToInt64(Str: string; def: Longint): Int64;
begin
  Result := def;
  if Str <> '' then
  begin
    if ((word(Str[1]) >= word('0')) and (word(str[1]) <= word('9'))) or
      (str[1] = '+') or (str[1] = '-') then
    try
      Result := StrToInt64(Str);
    except
    end;
  end;
end;

function InttoKillType(num: Integer): string; //���ӱ�ɱ����
begin
  case num of
     503: Result:= '���';
     504: Result:= '����';
  else
     Result:= 'δ֪';
  end;
end;

function MsgTypestr(num: Integer): string;
var
  I: Integer;
begin
  Result:= '';
  for I := High(NoticeMsgData) downto 0 do
  begin
     NoticeMsgData[i,1]:= num div NoticeMsgData[i,0];
     num := num mod NoticeMsgData[i,0];
  end;
  for I := 0 to High(NoticeMsgData) do
  begin
    if NoticeMsgData[i,1] > 0 then
     Result:= Result + sNoticeMsgData[i] + '��';
  end;
end;

function RobotTypestr(num: Integer): string;
begin
  case num of
     0 : Result := '����';
     1 : Result := '<a style="color:Blue">����</a>';
     2 : Result := '<a style="color:red">ɾ��</a>';
     3 : Result := '<a style="color:Blue">����</a>';
     4 : Result := '<a style="color:Red">����</a>';
  else
     Result := '����';
  end;
end;

function ItemTypeStr(num: Integer): string;
begin
  case num of
     0 : Result := '����';
     1 : Result := '�·�';
     2 : Result := 'ͷ��';
     3 : Result := '����';
     4 : Result := 'ѫ��';
     5 : Result := '������';
     6 : Result := '������';
     7 : Result := '���ָ';
     8 : Result := '�ҽ�ָ';
     9 : Result := '����';
    10 : Result := 'Ь��';
    11 : Result := '��ʯ';
    12 : Result := '����';
    13 : Result := 'ʱװ';
    14 : Result := '���';
    15 : Result := '����';
  else
     Result := '�µ���';
  end;
end;

function BoolToIntStr(boo: Boolean): string;
begin
  Result := IntToStr(Integer(boo));
end;

function GetVersionEx: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  Result := '0.0.0.0';

  VerInfoSize := GetFileVersionInfoSize(PWideChar(Application.ExeName), Dummy);
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

initialization
  TIWServerController.SetServerControllerClass;

end.

