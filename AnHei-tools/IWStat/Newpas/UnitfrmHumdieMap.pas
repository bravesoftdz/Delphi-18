unit UnitfrmHumdieMap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWAdvChart, IWCompButton, IWCompEdit, IWTMSEdit, IWControl,
  IWTMSCal, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWCompLabel,
  AdvChart, IWAdvToolButton, IWTMSImgCtrls, DateUtils,
  IWCompListbox, IWExchangeBar, IWCompRectangle, IWTMSCtrls, IWWebGrid,
  IWAdvWebGrid, IWCompCheckbox;

const
  curTitle = '����������ͼͳ��';

type
  TIWfrmHumdieMap = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    pSTime: TTIWAdvTimeEdit;
    IWLabel3: TIWLabel;
    pEDate: TTIWDateSelector;
    pETime: TTIWAdvTimeEdit;
    IWBtnBuild: TIWButton;
    IWRegion3: TIWRegion;
    TIWAdvChart1: TTIWAdvChart;
    TIWDateSelector1: TTIWDateSelector;
    TIWAdvTimeEdit1: TTIWAdvTimeEdit;
    IWButton3: TIWButton;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLogMode: TIWCheckBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryRoleMap(ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
    procedure QueryRoleMapEx(Ispid, ServerIndex: Integer;MinDateTime,MaxDateTime: TDateTime);
  end;

var
  IWfrmHumdieMap: TIWfrmHumdieMap;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

procedure TIWfrmHumdieMap.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Now();
  pEDate.Date := Now();
  pSTime.Time := StrToTime('00:00:00');
  pETime.Time := StrToTime('23:59:59');
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;  
end;

procedure TIWfrmHumdieMap.IWBtnBuildClick(Sender: TObject);
var
  psld: PTServerListData;
begin
  if pSDate.Date+pSTime.Time > pEDate.Date+pETime.Time then
  begin
    WebApplication.ShowMessage('��ʼ����Ӧ���ڻ���ڽ������ڣ�������ѡ��');
    Exit;
  end;

  try
    psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    if not IWLogMode.Checked then
    begin
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        QueryRoleMap(psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
      finally
        UserSession.SQLConnectionLog.Close;
      end;
    end
    else begin  //��ģʽ
      UserSession.ConnectionLocalLogMysql(psld.RoleHostName);
      try
        QueryRoleMapEx(psld.Ispid, psld.Index,pSDate.Date+pSTime.Time,pEDate.Date+pETime.Time);
      finally
        UserSession.SQLConnectionLocalLog.Close;
      end;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmHumdieMap.IWButton3Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'HumdieMap' + DateToStr(pSDate.Date) + DateToStr(pEDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmHumdieMap.QueryRoleMap(ServerIndex: Integer; MinDateTime,
  MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT Para2, MidStr1 FROM log_common_%s WHERE serverindex= %d and logdate>="%s" and logdate<="%s" and Logid in (503,504) ';
  sqlGroup =  'SELECT Para2, MidStr1,COUNT(1) AS iCount FROM (%s) b GROUP BY Para2,MidStr1 ';
  sqlUnionALL  = ' UNION ALL ';
var
  iCount, nCount: Integer;
  sSQL: string;
begin
  sSQL := '';

  while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
  begin
     sSQL := sSQL + Format(sqlRoleCount,[FormatDateTime('YYYYMMDD',MinDateTime),
     ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
     MinDateTime := IncDay(MinDateTime,1);
  end;

  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    iCount := 0; nCount := 0;
    with UserSession.quHumDie,TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;
      SQL.Text := Format(sqlGroup,[sSQL]);
      Open;
      try
        while not Eof do
        begin
         Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
            UTF8ToWideString(FieldByName('MidStr1').AsAnsiString) + '('+ inttostr(FieldByName('Para2').AsInteger) + ')');
          Inc(iCount);
          Next;
        end;
      finally
        Close;
      end;

      Range.RangeFrom := 0;
      Range.RangeTo := iCount-1;
      Series[0].Autorange := arEnabledZeroBased;
      if iCount * objINI.AutoWidth < objINI.DefaultWidth then
        TIWAdvChart1.Width := objINI.DefaultWidth
      else
        TIWAdvChart1.Width := iCount * (objINI.AutoWidth + 40);
    end;
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quHumDie do
      begin
        SQL.Text := Format(sqlGroup,[sSQL]);
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := IntToStr(FieldByName('Para2').AsInteger);
            cells[2,nCount] := UTF8ToWideString(FieldByName('MidStr1').AsAnsiString);
            cells[3,nCount] := IntToStr(FieldByName('iCount').AsInteger);
            Inc(nCount);
            Next;
          end;
        finally
          Close;
        end;
      end;
    end;
    TIWAdvChart1.Visible := True;
  end;
end;

procedure TIWfrmHumdieMap.QueryRoleMapEx(Ispid, ServerIndex: Integer; MinDateTime, MaxDateTime: TDateTime);
const
  sqlRoleCount = 'SELECT Para2, MidStr1 FROM log_common_%d_%d_%s WHERE serverindex= %d and logdate>="%s" and logdate<="%s" and Logid in (503,504) ';
  sqlGroup =  'SELECT Para2, MidStr1,COUNT(1) AS iCount FROM (%s) b GROUP BY Para2,MidStr1 ';
  sqlUnionALL  = ' UNION ALL ';
var
  iCount, nCount: Integer;
  sSQL: string;
begin
  sSQL := '';

  while DateOf(MinDateTime)<=DateOf(MaxDateTime) do
  begin
     sSQL := sSQL + Format(sqlRoleCount,[Ispid, ServerIndex, FormatDateTime('YYYYMMDD',MinDateTime),
     ServerIndex,DateTimeToStr(MinDateTime),DateTimeToStr(MaxDateTime)]) + sqlUnionALL;
     MinDateTime := IncDay(MinDateTime,1);
  end;

  if sSQL <> '' then
  begin
    System.Delete(sSQL,Length(sSQL)-Length(sqlUnionall)+1,Length(sqlUnionall));
    iCount := 0; nCount := 0;
    with UserSession.quHumDieEx,TIWAdvChart1.Chart do
    begin
      Series[0].ClearPoints;
      SQL.Text := Format(sqlGroup,[sSQL]);
      Open;
      try
        while not Eof do
        begin
         Series[0].AddSinglePoint(ChangeZero(FieldByName('iCount').AsInteger),
            UTF8ToWideString(FieldByName('MidStr1').AsAnsiString) + '('+ inttostr(FieldByName('Para2').AsInteger) + ')');
          Inc(iCount);
          Next;
        end;
      finally
        Close;
      end;

      Range.RangeFrom := 0;
      Range.RangeTo := iCount-1;
      Series[0].Autorange := arEnabledZeroBased;
      if iCount * objINI.AutoWidth < objINI.DefaultWidth then
        TIWAdvChart1.Width := objINI.DefaultWidth
      else
        TIWAdvChart1.Width := iCount * (objINI.AutoWidth + 40);
    end;
    with TIWAdvWebGrid1 do
    begin
      ClearCells;
      with UserSession.quHumDieEx do
      begin
        SQL.Text := Format(sqlGroup,[sSQL]);
        Open;
        try
          while not Eof do
          begin
            RowCount := nCount + 1;
            cells[1,nCount] := IntToStr(FieldByName('Para2').AsInteger);
            cells[2,nCount] := UTF8ToWideString(FieldByName('MidStr1').AsAnsiString);
            cells[3,nCount] := IntToStr(FieldByName('iCount').AsInteger);
            Inc(nCount);
            Next;
          end;
        finally
          Close;
        end;
      end;
    end;
    TIWAdvChart1.Visible := True;
  end;
end;

initialization
  RegisterClass(TIWfrmHumdieMap);

end.
