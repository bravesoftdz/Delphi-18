unit UnitfrmDayLoss;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWWebGrid, IWAdvWebGrid, IWTMSCal, IWCompEdit,
  IWCompButton, IWCompListbox, IWTMSImgCtrls, IWControl, IWExchangeBar,
  IWCompLabel, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompRectangle, IWTMSCtrls, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion;

type
  TIWfrmDayLoss = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    TIWAdvWebGrid1: TTIWAdvWebGrid;
    IWLabel2: TIWLabel;
    pEDate: TTIWDateSelector;
    IWLabel1: TIWLabel;
    pSDate: TTIWDateSelector;
    IWBtnBuild: TIWButton;
    IWButton1: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWBtnBuildClick(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure QueryDayLoss(MinDateTime,MaxDateTime: TDateTime;ServerIndex: Integer);
  end;

var
  IWfrmDayLoss: TIWfrmDayLoss;

implementation

uses ConfigINI, ServerController;

{$R *.dfm}

procedure TIWfrmDayLoss.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  pSDate.Date := Date-1;
  pEDate.Date := Date-1;
  SetServerListSelect(Langtostr(StatToolButtonStr[tbDayLoss]));
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + Langtostr(StatToolButtonStr[tbDayLoss]);
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),Langtostr(StatToolButtonStr[tbDayLoss])]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  IWRegion1.Visible := True;

  IWLabel1.Caption := Langtostr(150);
  IWLabel2.Caption := Langtostr(151);
  IWBtnBuild.Caption := Langtostr(171);
  IWButton1.Caption := Langtostr(182);

  TIWAdvWebGrid1.Columns[0].Title:= Langtostr(263);
  TIWAdvWebGrid1.Columns[1].Title:= Langtostr(264);
  TIWAdvWebGrid1.Columns[2].Title:= Langtostr(265);
  TIWAdvWebGrid1.Columns[3].Title:= Langtostr(266);
  TIWAdvWebGrid1.Columns[4].Title:= Langtostr(267);
  TIWAdvWebGrid1.Columns[5].Title:= Langtostr(268);
  TIWAdvWebGrid1.Columns[6].Title:= Langtostr(269);
  TIWAdvWebGrid1.Columns[7].Title:= Langtostr(270);
  TIWAdvWebGrid1.Columns[8].Title:= Langtostr(271);
  TIWAdvWebGrid1.Columns[9].Title:= Langtostr(272);
  TIWAdvWebGrid1.Columns[10].Title:= Langtostr(273);
  TIWAdvWebGrid1.Columns[11].Title:= Langtostr(274);
end;

procedure TIWfrmDayLoss.IWBtnBuildClick(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  try
    ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
    UserSession.ConnectionRoleMysql(ServerListData.RoleHostName,ServerListData.DataBase);
    try
      QueryDayLoss(pSDate.Date,pEDate.Date,ServerListData.Index);
    finally
      UserSession.SQLConnectionRole.Close;
    end;
  except
    On E: Exception do
    begin
      AppExceptionLog(ClassName,E);
    end;
  end;
end;

procedure TIWfrmDayLoss.IWButton1Click(Sender: TObject);
var
  sFileName: string;
begin
  sFileName := 'DayLoss'+DateToStr(pSDate.Date) + '.csv';
  TIWAdvWebGrid1.SaveToCSV(WebApplication.UserCacheDir+sFileName,False);
  WebApplication.SendFile(WebApplication.UserCacheDir+sFileName);
  DeleteFile(pchar(WebApplication.UserCacheDir+sFileName));
end;

procedure TIWfrmDayLoss.QueryDayLoss(MinDateTime,MaxDateTime: TDateTime;
  ServerIndex: Integer);
const
  RoleCountTip = 275;//'&nbsp;&nbsp;总角色数：%d，剩余角色：%d ，流失比例：%s';

  sqlLoss = 'SELECT Level,SUM(iCount) AS RoleCount,'+
            'SUM(CASE job WHEN 1 THEN iCount ELSE 0 END) AS Role2,'+
            'SUM(CASE job WHEN 2 THEN iCount ELSE 0 END) AS Role4,'+
            'SUM(CASE job WHEN 3 THEN iCount ELSE 0 END) AS Role7,'+
   //         'SUM(CASE job WHEN 0 THEN iCount ELSE 0 END) AS Role8,'+
            'SUM(CASE zy WHEN 1 THEN iCount ELSE 0 END) AS zy1,'+
            'SUM(CASE zy WHEN 2 THEN iCount ELSE 0 END) AS zy2,'+
            'SUM(CASE zy WHEN 3 THEN iCount ELSE 0 END) AS zy3'+
            ' FROM (SELECT Level,job,zy,COUNT(1) AS iCount FROM actors WHERE '+
            'createtime>="%s" AND createtime<"%s 23:59:59" AND updatetime<"%s 23:59:59" GROUP BY Level,job,zy) tmp GROUP BY Level';
  sqlTask = 'SELECT Level,MAX(CONCAT(length(floor(iCount)),"-",iCount,"-",roleid)) AS roleid FROM ('+
            ' SELECT Level,idtask & 0xFFFF AS roleid,COUNT(DISTINCT b.actorid) AS iCount FROM actors '+
            ' a,goingquest b WHERE a.actorid=b.actorid AND createtime>="%s" AND createtime<"%s 23:59:59" AND updatetime<"%s 23:59:59" '+
            ' GROUP BY a.Level,b.idtask & 0xFFFF UNION ALL SELECT Level,idtime & 0xFFFF AS roleid,'+
            ' COUNT(DISTINCT b.actorid) AS iCount FROM actors a,repeatquest b WHERE a.actorid=b.actorid'+
            ' AND createtime>="%s" AND createtime<"%s 23:59:59" AND updatetime<"%s 23:59:59" GROUP BY a.Level,b.idtime & 0xFFFF) tmp GROUP BY Level';
  sqlTotalRoleCount = 'SELECT COUNT(1) AS TotalCount FROM actors WHERE createtime>="%s" AND createtime<"%s 23:59:59"';
var
  iCount,iTotalRoleCount,iRoleCount,iRemainderCount,iLossTotalCount: Integer;
  procedure SetLossTaskMaxCount(Level: Integer;sValue: string);
  var
    I: Integer;
    iPos,RValue: Integer;
    pTask: PTTask;
    sCount: string;
  begin
    iPos := Pos('-',sValue);
    Delete(sValue,1,iPos);
    iPos := Pos('-',sValue);
    sCount := Copy(sValue,1,iPos-1);
    Delete(sValue,1,iPos);
    TryStrToInt(sValue,RValue);
    for I := 0 to TIWAdvWebGrid1.TotalRows - 1 do
    begin
      if TIWAdvWebGrid1.Cells[0,I] = IntToStr(Level) then
      begin
        pTask := OnGetTaskName(RValue);
        if pTask <> nil then
        begin
          TIWAdvWebGrid1.Cells[10,I] := string(pTask^.sTaskMapName);//GetZyName(pTask^.nZyID1,pTask^.nZyID2);
          TIWAdvWebGrid1.Cells[11,I] := Format('%s(%s)',[pTask^.sTaskName,sCount]);
        end;
        break;
      end;
    end;
  end;
begin
  iTotalRoleCount := GetRecordCount(Format(sqlTotalRoleCount,[DateToStr(MinDateTime),DateToStr(MaxDateTime)]),UserSession.quLoss);
  iRemainderCount := iTotalRoleCount;
  with UserSession.quLoss, TIWAdvWebGrid1 do
  begin
    iCount := 0; iLossTotalCount := 0;
    ClearCells;
    RowCount := objINI.MaxPageCount;
    SQL.Text := Format(sqlLoss,[DateToStr(MinDateTime),DateToStr(MaxDateTime),DateToStr(MaxDateTime)]);
    Open;
    while not Eof do
    begin
      TotalRows := RowCount+iCount;
      cells[0,iCount] := IntToStr(FieldByName('Level').AsInteger);
      iRoleCount := FieldByName('RoleCount').AsInteger;
      Inc(iLossTotalCount,iRoleCount);
      cells[1,iCount] := IntToStr(iRoleCount);
      Dec(iRemainderCount,iRoleCount);
      cells[2,iCount] := IntToStr(iRemainderCount);
      if iRemainderCount = 0 then iRemainderCount := 1;
      cells[3,iCount] := Format('%.2f%%',[iRoleCount/(iRoleCount+iRemainderCount)*100]);
      cells[4,iCount] := IntToStr(FieldByName('Role2').AsInteger);
      cells[5,iCount] := IntToStr(FieldByName('Role4').AsInteger);
      cells[6,iCount] := IntToStr(FieldByName('Role7').AsInteger);
      cells[7,iCount] := '0';//IntToStr(FieldByName('zy1').AsInteger);
      cells[8,iCount] := '0';//IntToStr(FieldByName('zy2').AsInteger);
      cells[9,iCount] := '0';//IntToStr(FieldByName('zy3').AsInteger);
      Inc(iCount);
      Next;
    end;
    TotalRows := iCount;
    Close;
    SQL.Text := Format(sqlTask,[DateToStr(MinDateTime),DateToStr(MaxDateTime),DateToStr(MaxDateTime),DateToStr(MinDateTime),DateToStr(MaxDateTime),DateToStr(MaxDateTime)]);
    Open;
    while not Eof do
    begin
      SetLossTaskMaxCount(FieldByName('Level').AsInteger,FieldByName('roleid').AsString);
      Next;
    end;
    Close;
    Controller.Caption := Format(Langtostr(RoleCountTip),[iTotalRoleCount,iRemainderCount,Format('%.2f%%',[iLossTotalCount/iTotalRoleCount*100])]);
  end;
end;

initialization
  RegisterClass(TIWfrmDayLoss);
end.
