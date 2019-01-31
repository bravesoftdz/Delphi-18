unit UnitIWfrmUserConsume;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvToolButton, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, IWTMSCal, DateUtils,
  IWCompLabel, AdvChart, IWAdvChart, IWTMSImgCtrls, IWCompListbox,
  IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWCompEdit;

const
  curTitle = 42;//'����Ԫ��ͳ��';

type
  TIWfrmUserConsume = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    IWLabel4: TIWLabel;
    TIWAdvChart2: TTIWAdvChart;
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
  public
    procedure QueryUserConsume(sgstatic:string;ServerIndex: Integer;dRate: Double;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmUserConsume: TIWfrmUserConsume;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmUserConsume.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := IncDay(Now(),-1); //-14
  pEDate.Date := Now();
  TIWAdvChart1.Chart.Series[0].ValueFormat := objINI.RMBFormat;
  SetServerListSelect(Langtostr(curTitle));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(curTitle);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(curTitle)]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(150);
  IWLabel3.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);
end;

procedure TIWfrmUserConsume.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date > pEDate.Date then
  begin
    WebApplication.ShowMessage(Langtostr(172));
    Exit;
  end;
  if DayOf(pEDate.Date)-DayOf(pSDate.Date) >= 32 then
  begin
    WebApplication.ShowMessage(Langtostr(309));
    Exit;
  end;
  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if psld.Index <> 0 then
    begin
      if psld.OpenTime = '' then
      begin
//        WebApplication.ShowMessage('������δ���������Ե�');
        Exit;
      end;
      if pSDate.Date < StrToDateTime(psld.OpenTime) then
      begin
        pSDate.Date := StrToDateTime(psld.OpenTime);
      end;
      if pEDate.Date < StrToDateTime(psld.OpenTime) then
      begin
        pEDate.Date := StrToDateTime(psld.OpenTime);
      end;
    end;
    UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
    try
      QueryUserConsume(psld.GstaticDB,psld.Index,psld.CurrencyRate,pSDate.Date,pEDate.Date);
    finally
      UserSession.SQLConnectionLog.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmUserConsume.QueryUserConsume(sgstatic:string;ServerIndex: Integer; dRate: Double; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlTotalConsume = 'SELECT SUM(paymentcount*-1) AS TotalConsume FROM log_consume_%s WHERE moneytype=3 AND logid not in (122,142) AND paymentcount<=0 AND account not in (SELECT account FROM %s.insideraccount) %s ';
  sqlUserConsume = 'SELECT COUNT(DISTINCT account) AS iCount FROM log_consume_%s  WHERE moneytype=3 AND logid not in (122,142) AND paymentcount<=0 AND account not in (SELECT account FROM %s.insideraccount) %s ';
  tServerID = 'AND serverindex=%d ';
  sTipText = 310;//'�� %s �� %s ���ܼ����ѽ��(RMB)Ϊ��%s���ܼ������û���Ϊ��%d';
var
  iCount,TotalCount: Integer;
  sServerIndex: string;
  SDateTime: TDateTime;
  TotalConsume,curConsume,dValue: Double;
begin
  sServerIndex := '';
  if MaxDateTime > Now then MaxDateTime := Now;
  if ServerIndex <> 0 then sServerIndex := Format(tServerID,[ServerIndex]);
  iCount := 0; TotalConsume := 0;  TotalCount := 0;
  TIWAdvChart1.Chart.Series[0].ClearPoints;
  TIWAdvChart2.Chart.Series[0].ClearPoints;
  SDateTime := MinDateTime;
  while MinDateTime<=MaxDateTime do
  begin
//    if UserSession.IsCheckTable('globallog',sTableName) then
//    begin
      with UserSession.quUserConsume do
      begin
        SQL.Text := Format(sqlTotalConsume,[FormatDateTime('YYYYMMDD',MinDateTime),sgstatic,sServerIndex]);
        Open;
     //   dValue := DivZero(FieldByName('TotalConsume').AsInteger,10) * dRate;
        dValue := DivZero(FieldByName('TotalConsume').AsInteger / 10,dRate);
        curConsume := StrToFloat(Format('%.1f',[dValue]));
        TIWAdvChart1.Chart.Series[0].AddSinglePoint(ChangeZero(curConsume),FormatDateTime('MM-DD',MinDateTime));
        TotalConsume := TotalConsume + curConsume;
        Close;

        SQL.Text := Format(sqlUserConsume,[FormatDateTime('YYYYMMDD',MinDateTime),sgstatic,sServerIndex]);
        Open;
        Inc(TotalCount,FieldByName('iCount').AsInteger);
        TIWAdvChart2.Chart.Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),FormatDateTime('MM-DD',MinDateTime));
        Close;
      end;
      Inc(iCount);
//    end;
    MinDateTime := IncDay(MinDateTime,1);
  end;
  IWLabel4.Caption := Format(Langtostr(sTipText),[FormatDateTime('YYYY-MM-DD',SDateTime),FormatDateTime('YYYY-MM-DD',MaxDateTime),Format(objINI.RMBFormat,[TotalConsume]),TotalCount]);
  TIWAdvChart1.Chart.Range.RangeFrom := 0;
  TIWAdvChart1.Chart.Range.RangeTo := iCount-1;
  if iCount * (objINI.AutoWidth+20) < objINI.DefaultWidth then
    TIWAdvChart1.Width := objINI.DefaultWidth
  else
    TIWAdvChart1.Width := iCount * (objINI.AutoWidth+20);
  TIWAdvChart2.Chart.Range.RangeFrom := 0;
  TIWAdvChart2.Chart.Range.RangeTo := iCount-1;
  if iCount * (objINI.AutoWidth+20) < objINI.DefaultWidth then
    TIWAdvChart2.Width := objINI.DefaultWidth
  else
    TIWAdvChart2.Width := iCount * (objINI.AutoWidth+20);
  TIWAdvChart1.Visible := True;
  TIWAdvChart2.Visible := True;
end;

initialization
  RegisterClass(TIWfrmUserConsume);

end.
