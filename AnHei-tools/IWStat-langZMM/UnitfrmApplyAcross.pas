unit UnitfrmApplyAcross;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitfrmBasic, IWTMSImgCtrls, IWControl,
  IWAdvToolButton, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWCompLabel, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompButton, IWCompEdit, IWTMSEdit,
  IWCompListbox, IWCompCheckbox, IWCompRectangle, IWTMSCtrls,
  IWWebGrid, IWExchangeBar, IWCompMemo;

const
  curTitle = '���ս����';

type
  TIWfrmApplyAcross = class(TIWFormBasic)
    IWRegion2: TIWRegion;
    TIWGradientLabel7: TTIWGradientLabel;
    IWcBoxOpenSpanPK: TIWCheckBox;
    IWLabel11: TIWLabel;
    IWcBoxWeek: TIWComboBox;
    TIWAdvtedtAcrossTime: TTIWAdvTimeEdit;
    IWButton4: TIWButton;
    TIWGradientLabel2: TTIWGradientLabel;
    IWedtAcrossPass: TIWEdit;
    IWButton2: TIWButton;
    IWButton1: TIWButton;
    IWLabel2: TIWLabel;
    IWcBoxAwardWeek: TIWComboBox;
    TIWAdvtedtAcrossAwardTime: TTIWAdvTimeEdit;
    IWButton5: TIWButton;
    IWButton3: TIWButton;
    IWLabel1: TIWLabel;
    TIWAdvsedtServerIndex: TTIWAdvSpinEdit;
    IWedtAccount: TIWEdit;
    IWedtRole: TIWEdit;
    IWLabel3: TIWLabel;
    IWLabel4: TIWLabel;
    IWButton6: TIWButton;
    TIWGradientLabel1: TTIWGradientLabel;
    IWLabel5: TIWLabel;
    TIWAdvSedtImportDBDataRetry: TTIWAdvSpinEdit;
    IWMemo1: TIWMemo;
    IWButton7: TIWButton;
    IWLabel6: TIWLabel;
    IWSpidkBox: TIWCheckBox;
    procedure IWButton2Click(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWButton4Click(Sender: TObject);
    procedure IWButton1Click(Sender: TObject);
    procedure IWButton5Click(Sender: TObject);
    procedure IWButton3Click(Sender: TObject);
    procedure IWButton6Click(Sender: TObject);
    procedure IWButton7Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  IWfrmApplyAcross: TIWfrmApplyAcross;

implementation

uses ServerController, ConfigINI;

{$R *.dfm}

{ TIWfrmApplyAcross }

procedure TIWfrmApplyAcross.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  IWcBoxOpenSpanPK.Checked := objINI.OpenSpanPK;
  IWcBoxWeek.ItemIndex := objINI.AcrossWeek-1;
  TIWAdvtedtAcrossTime.Time := StrToTime(objINI.AcrossDTime);
  IWcBoxAwardWeek.ItemIndex := objINI.AcrossAwardWeek-1;
  TIWAdvtedtAcrossAwardTime.Time := StrToTime(objINI.AcrossAwardDTime);
  SetServerListSelect(curTitle);
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName) + ' - ' + curTitle;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),curTitle]);
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);
  TIWAdvSedtImportDBDataRetry.Value := objINI.AcrossImportDBDataRetry;
  IWRegion1.Visible := True;  
end;

procedure TIWfrmApplyAcross.IWButton1Click(Sender: TObject);
const
  sqlTruncateTable = 'DELETE FROM %s.acrossuser';
var
  psld: PTServerListData;
begin
  if objINI.AcrossPass = IWedtAcrossPass.Text then
  begin
    try
      psld := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
      UserSession.ConnectionLogMysql(psld.LogDB,psld.LogHostName);
      try
        if objINI.AcrossPass = IWedtAcrossPass.Text then
        begin
          with UserSession.quAcross do
          begin
            SQL.Text :=  Format(sqlTruncateTable,[psld.GstaticDB]);
            ExecSQL;
            Close;
          end;
          WebApplication.ShowMessage('�������');
        end
        else begin
          WebApplication.ShowMessage('�����������������');
        end;
      finally
         UserSession.SQLConnectionLog.Close;
      end;
    except
      On E: Exception do
      begin
        AppExceptionLog(ClassName,E);
      end;
    end;
  end
  else begin
    WebApplication.ShowMessage('�����������������');
  end;
end;

procedure TIWfrmApplyAcross.IWButton2Click(Sender: TObject);
begin
  if objINI.AcrossPass = IWedtAcrossPass.Text then
  begin
    IWServerController.BatchInsertAcrossData(False);
  end
  else begin
    WebApplication.ShowMessage('�����������������');
  end;
end;

procedure TIWfrmApplyAcross.IWButton3Click(Sender: TObject);
begin
  if objINI.AcrossPass = IWedtAcrossPass.Text then
  begin
    IWServerController.ClearAcrossDBData;
    WebApplication.ShowMessage('��տ��ս�������');
  end
  else begin
    WebApplication.ShowMessage('�����������������');
  end;
end;

procedure TIWfrmApplyAcross.IWButton4Click(Sender: TObject);
begin
  inherited;
  objINI.OpenSpanPK := IWcBoxOpenSpanPK.Checked;
  objINI.WriteBooleanINI(TIWGradientLabel7.Caption,IWcBoxOpenSpanPK.Caption,IWcBoxOpenSpanPK.Checked);
  objINI.AcrossWeek := IWcBoxWeek.ItemIndex+1;
  objINI.WriteIntegerINI(TIWGradientLabel7.Caption,'���ݴ�����',IWcBoxWeek.ItemIndex+1);
  objINI.AcrossDTime := TimeToStr(TIWAdvtedtAcrossTime.Time);
  objINI.WriteStringINI(TIWGradientLabel7.Caption,IWLabel11.Caption,TimeToStr(TIWAdvtedtAcrossTime.Time));
  objINI.AcrossAwardWeek := IWcBoxAwardWeek.ItemIndex+1;
  objINI.WriteIntegerINI(TIWGradientLabel7.Caption,'����������',IWcBoxAwardWeek.ItemIndex+1);
  objINI.AcrossAwardDTime := TimeToStr(TIWAdvtedtAcrossAwardTime.Time);
  objINI.WriteStringINI(TIWGradientLabel7.Caption,IWLabel2.Caption,TimeToStr(TIWAdvtedtAcrossAwardTime.Time));
  objINI.WriteIntegerINI(TIWGradientLabel7.Caption,IWLabel5.Caption,TIWAdvSedtImportDBDataRetry.Value);
  objINI.AcrossImportDBDataRetry := TIWAdvSedtImportDBDataRetry.Value;
  WebApplication.ShowMessage('�������');
end;

procedure TIWfrmApplyAcross.IWButton5Click(Sender: TObject);
begin
  if objINI.AcrossPass = IWedtAcrossPass.Text then
  begin
    IWServerController.SendEngineGetAcrossRank;
    WebApplication.ShowMessage('������ս�������');
  end
  else begin
    WebApplication.ShowMessage('�����������������');
  end;
end;

procedure TIWfrmApplyAcross.IWButton6Click(Sender: TObject);
var
  ServerListData: PTServerListData;
begin
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  if (TIWAdvsedtServerIndex.Value > 0) and (IWedtAccount.Text<>'') and (IWedtRole.Text <> '') then
  begin
    if not IWSpidkBox.Checked then
    begin
      if Pos('_'+ServerListData.spID,IWedtAccount.Text) = 0 then
      begin
        IWedtAccount.Text := IWedtAccount.Text + '_'+ServerListData.spID;
      end;
    end;
    if IWServerController.AddAcrossData(TIWAdvsedtServerIndex.Value,IWedtAccount.Text,IWedtRole.Text) <> 1 then
    begin
      if IWServerController.ApplyAcross(TIWAdvsedtServerIndex.Value,IWedtAccount.Text,IWedtRole.Text) then
      begin
        WebApplication.ShowMessage('�����ɫ('+IWedtRole.Text+')�����ս���ɹ�');
      end
      else begin
        WebApplication.ShowMessage('�����ɫ('+IWedtRole.Text+')�����ս��ʧ��');
      end;
    end
    else begin
      WebApplication.ShowMessage('��ӽ�ɫ('+IWedtRole.Text+')�����ս��ʧ��');
    end;
  end;
end;

procedure TIWfrmApplyAcross.IWButton7Click(Sender: TObject);
begin
  inherited;
  if objINI.AcrossPass = IWedtAcrossPass.Text then
  begin
    IWServerController.AcrossRankAward(0,IWMemo1.Lines.Text);
  end
  else begin
    WebApplication.ShowMessage('�����������������');
  end;

end;

initialization
  RegisterClass(TIWfrmApplyAcross);

end.
