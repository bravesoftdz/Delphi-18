unit UnitfrmBasic;

interface

uses
  Classes, SysUtils, Controls, Forms, jpeg, Windows, md5, IWAppForm, IWApplication,
  IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, MSXML, ActiveX, IWAdvToolButton,
  IWControl, IWTMSCal, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWCompEdit, IWCompButton, IWTMSImgCtrls,
  IWCompListbox, IWCompRectangle, IWTMSCtrls, IWExchangeBar;

type
  TStatToolButton = ({1}tbBasicConfig,tbSetUserPop,tbOverview,tbOnlineAndPay,tbAllOnlineAndPay,
                     {5}tbOnlineCount,tbHumMapCount,tbCurOnline,tbAvgOnline,
                     {9}tbGlobalOnline,tbLoginStatus,tbCreateAccount,tbOnlineRegister,
                     {13}tbLogin,tbLoginModeTotal,tbLoginAgain,tbUserCount,tbGlobalAccount,tbRoleStayTime,
                     {17}tbAccountLoss,tbDayLoss,tbTaskLoss,tbAccountRate,
                     {21}tbAccountType,tbPay,tbUserConsume,tbBindConsume,
                     {25}tbBonus,tbGlobalPay,tbShop,tbShopType,
                     {29}tbPayUser,tbPayRoleLevel,tbConsumeYXB,tbARPU,
                     {33}tbSurplusMoney,tbCurrTotal,tbFirstExtrYbCount,btFirstExtrYb,
                     {37}tbFirstConsume,tbConsumeLevel,tbConsume,tbUserConsumeOrder,
                     {41}tbPayOrder,tbLevelRank,tbMoneyRank,btHonourvalTotal,
                     {45}tbBindGoldRank,tbGoldRank,tbIntegralTotal,tbAcrossRank,tbZyRank,
                     {49}tbReputeRank,tbReputeShopOrder,tbSex,tbRole,
                     {53}tbRoleLevel,tbLevelRole,tbCountry,tbRoleInfo,tbHeroInfo,tbHunShi,tbRelati,tbGuildInfo,
                     {57}tbRoleConsume,tbHumLog,tbLoginLog,tbStockItem,
                     {61}tbBugInfo,tbSysExceptLog,tbFlashPlayerVersion,tbItemTrace,
                     {65}tbItems,tbActivityItem,tbExtractGold,tbPayDetail,
                     {69}tbBonusDetail,tbPayAllUser,btZYCount,tbGameFeedback,
                     {73}tbAcross,tbItemsTotal,tbTreasureHuntTotal,btStallTrack,
                     {77}tbMonDieTotal,tbCopyTrack,tbHumDieLevel,tbHumdieMap,
                     {81}tbMonStrength,tbMonKillhum,tbHumDropItems,tbSeedGold,
                     {85}tbDmkjGold,tbGMGS,tbOperateLog,tbReloadNPC,
                     {89}tbRoleGS,tbNoticeGS,tbFunctionGS,tbAbuseGS,
                     {93}tbShopGS,tbDataEngine,tbBonusGS,tbDelayUphole,
                     {97}tbViewState,tbExpRateGS,tbCompenGS,tbDropReteGS,tbBindGoldGS,
                    {101}tbActivityItemGS,tbRoleActivityItemGS,tbDataExport,tbOpenModuleGS,
                    {105}tbInsiderAccount,tbGameEngineList,tbS1Engine, tbIllegalInfo,tbGlobalUserYuanbao,
                    {110}tbVaseries,tbIWStatList
                     );

  TStatToolButtons = Set of TStatToolButton;
  TToolButtonGroup = (bgSysSet,bgOverview,bgOnline,bgPay,bgRank,bgQuery,bgTrack,bgManager);

const
  StatToolButtonStr: array[TStatToolButton] of Integer
                  = (  {1}//'��������','�˺�����','�ſ�','�������ֵ','ƽ̨����',
                          17,18,19,20,21,
                       {5}//'������','��������׷��','ʵʱ����','ƽ������',
                          22,23,24,25,
                       {9}//'�������','���û���½״̬','�����˺�ͳ��','����ע��ͳ��',
                          26,27,28,29,
                      {13}//'��½ͳ��','��½��ʽͳ��','���ε�¼��ͳ��','�û���ͳ��','ע���˺�ͳ��','�˺�ͣ��ʱ��',
                          30,31,32,33,34,35,
                      {17}//'��ɫ��ʧ','����ʧ��','������ʧ','�û�ת����',
                          36,37,38,39,
                      {21}//'�����˺�ͳ��','��ֵͳ��','����Ԫ��ͳ��','������ȯͳ��',
                          40,41,42,43,
                      {25}//'����ͳ��','������ֵ', '�̳�ͳ��','�̳Ƿ���ͳ��',
                          44,45,46,47,
                      {29}//'��ֵ�˺�ͳ��','��ֵ�ȼ�ͳ��','���Ѳ�ѯ','ARPUͳ��',
                          48,49,50,51,
                      {33}//'ʣ��Ԫ��ͳ��','����״����ѯͳ��','�״���ȡԪ������', '�״���ȡԪ��',
                          52,53,54,55,
                      {37}//'�״����ѹ���','�״����ѵȼ�','�̳�����ͳ��','��������ͳ��',
                          56,57,58,59,
                      {41}//'��ֵ����ͳ��','�ȼ�����ͳ��','�������ͳ��','��������ͳ��',
                          60,61,62,63,
                      {45}//'��ȯ����ͳ��','Ԫ������ͳ��','��������ͳ��','�������ͳ��','��Ӫ��������',
                          64,65,66,67,68,
                      {49}//'��������ͳ��','�����̳�����ͳ��','�Ա�ͳ��','ְҵͳ��',
                          69,70,71,72,
                      {53}//'�ȼ�ͳ��','ְҵ�ȼ�','��Ӫ�˿�','��ɫ��Ϣ','Ӣ����Ϣ','��ʯ��Ϣ','�罻��ϵ','�л���Ϣ',
                          73,74,75,76,77,78,79,80,
                      {57}//'��ɫ����','������־','��½��־','�����Ʒͳ��',
                          81,82,83,84,
                      {61}//'Bug��Ϣ','ϵͳ�쳣��־','FP�汾ͳ��','��Ʒ׷��',
                          85,86,87,88,
                      {65}//'��Ʒ��ѯ','���Ʒ','Ԫ����ȡ','��ֵ��ϸ',
                          89,90,91,92,
                      {69}//'������ϸ','��ֵ��ѯ','��Ӫ����ֵͳ��','��ҷ���',
                          93,94,95,96,
                      {73}//'���ս��ѯ','��Ʒ��ѯͳ��','Ѱ�����','��̯׷��',
                          97,98,99,100,
                      {77}//'����׷��', '����׷��','���������ȼ�ͳ��','����������ͼͳ��',
                          101,102,103,104,
                      {81}//'�����������ͳ��','����ʵ����ѯ','�����������䲿λ','��ֲԪ��',
                          105,106,107,108,
                      {85}//'Ѱ������','GM����','������־','NPC����',
                          109,110,111,112,
                      {89}//'��ɫ״̬����','�������','�ű�����','�����ֹ���',
                          113,114,115,116,
                      {93}//'�̳ǹ���','�������','��������','����ʱ����',
                          117,118,119,120,
                      {97}//'ϵͳ״̬�б�','���鱶�ʹ���','������������','�����������','��ȯ����',
                          121,122,123,124,125,
                     {101}//'�˺Ż��Ʒ����','��ɫ���Ʒ����','���ݵ���', '��Ϸ���ܹ���',
                          126,127,128,129,
                     {105}//'�ڲ��˺Ź���','�����������б�','��������A', '�鿴��Ҽ�¼','ƽ̨Ԫ��׷��',
                          130,131,132,133,134,
                     {110}//'����Ų�ѯ','��̨��������'
                          135,136
                     );

  ToolButtonGroupStr: array[TToolButtonGroup] of Integer
                  = (9{ϵͳ����},10{�ſ�},11{������ע��},12{��ֵ������},13{����ͳ��},14{��ѯ},15{׷��},16{����});

  ToolButtonFileIcon: array[TToolButtonGroup] of string
                  = ('files/wrench.png','files/chart_organisation.png','files/chart_line.png','files/money_yen.png','files/chart_bar.png',
                     'files/chart_pie.png','files/chart_curve.png','files/group.png');

  ToolButtonGroup: array[TToolButtonGroup,0..49] of Integer
                  = ((Ord(tbBasicConfig),ord(tbSetUserPop),-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
                     (Ord(tbOverview),Ord(tbOnlineAndPay),Ord(tbAllOnlineAndPay),-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
                     (Ord(tbOnlineCount),Ord(tbHumMapCount),Ord(tbCurOnline),Ord(tbAvgOnline),Ord(tbGlobalOnline),Ord(tbLoginStatus),Ord(tbCreateAccount),Ord(tbOnlineRegister),Ord(tbLogin),Ord(tbLoginModeTotal),Ord(tbLoginAgain),Ord(tbUserCount),Ord(tbGlobalAccount),Ord(tbRoleStayTime),Ord(tbAccountLoss),Ord(tbDayLoss),Ord(tbTaskLoss),Ord(tbAccountRate),Ord(tbAccountType),-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
                     (Ord(tbPay),Ord(tbUserConsume),Ord(tbBindConsume), Ord(tbBonus),Ord(tbGlobalPay),Ord(tbShop),Ord(tbShopType),Ord(tbPayUser),Ord(tbPayRoleLevel),Ord(tbConsumeYXB),Ord(tbARPU),Ord(tbSurplusMoney),Ord(tbCurrTotal),Ord(tbFirstExtrYbCount),Ord(btFirstExtrYb),Ord(tbFirstConsume),Ord(tbConsumeLevel),-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
                     (Ord(tbConsume),Ord(tbUserConsumeOrder),Ord(tbPayOrder),Ord(tbLevelRank),Ord(tbMoneyRank),Ord(btHonourvalTotal),Ord(tbBindGoldRank),Ord(tbGoldRank),Ord(tbIntegralTotal),Ord(tbAcrossRank),Ord(tbZyRank),Ord(tbReputeRank),Ord(tbReputeShopOrder),-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
                     (Ord(tbSex),Ord(tbRole),Ord(tbRoleLevel),Ord(tbLevelRole),Ord(tbCountry),Ord(tbRoleInfo),Ord(tbHeroInfo),Ord(tbHunShi),Ord(tbRelati),Ord(tbGuildInfo),Ord(tbRoleConsume),Ord(tbHumLog),Ord(tbLoginLog),Ord(tbStockItem),Ord(tbBugInfo),Ord(tbSysExceptLog),Ord(tbFlashPlayerVersion),Ord(tbItemTrace),Ord(tbItems),Ord(tbActivityItem),Ord(tbExtractGold),Ord(tbPayDetail),Ord(tbBonusDetail),Ord(tbPayAllUser),Ord(tbGameFeedback),Ord(tbAcross{�����ѯ}),-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
                     (Ord(tbItemsTotal),Ord(tbTreasureHuntTotal),Ord(btStallTrack),Ord(tbMonDieTotal),Ord(tbCopyTrack),Ord(tbHumDieLevel),Ord(tbHumdieMap),Ord(tbMonStrength),Ord(tbMonKillhum),Ord(tbHumDropItems),Ord(tbSeedGold),Ord(tbDmkjGold),Ord(btZYCount),Ord(tbGlobalUserYuanbao),ord(tbVaseries),-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1),
                     (Ord(tbGMGS),Ord(tbOperateLog),Ord(tbReloadNPC),Ord(tbRoleGS),Ord(tbNoticeGS),Ord(tbFunctionGS),Ord(tbAbuseGS),Ord(tbShopGS),Ord(tbDataEngine),Ord(tbBonusGS),Ord(tbDelayUphole),Ord(tbViewState),Ord(tbExpRateGS),Ord(tbCompenGS),Ord(tbDropReteGS),Ord(tbBindGoldGS),Ord(tbActivityItemGS),Ord(tbRoleActivityItemGS),Ord(tbDataExport),Ord(tbOpenModuleGS),Ord(tbInsiderAccount),Ord(tbGameEngineList),Ord(tbS1Engine),Ord(tbIllegalInfo),Ord(tbIWStatList),-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1));

type
  TIWFormBasic = class(TIWAppForm)
    IWRegionClient: TIWRegion;
    IWRegion1: TIWRegion;
    IWNavBarRegion: TIWRegion;
    IWRegion4: TIWRegion;
    IWAppTitleRegion: TIWRegion;
    TIWFadeImage1: TTIWFadeImage;
    TIWGradientTitleTop: TTIWGradientLabel;
    IWcBoxZJHTServers: TIWComboBox;
    IWlabZJHTTitle: TIWLabel;
    TIWBasicSideNavBar1: TTIWExchangeBar;
    IWlabCurDate: TIWLabel;
    IWlabCurUser: TIWLabel;
    IWbtnCloseApp: TIWButton;
    TIWGradientBarRight: TTIWGradientLabel;
    TIWGradientNavigation: TTIWGradientLabel;
    IWlabcurServer: TIWLabel;
    IWlabOpenServerTime: TIWLabel;
    IWRegionChangePass: TIWRegion;
    TIWGradientChangPass: TTIWGradientLabel;
    IWlabChangePassTitle: TIWLabel;
    IWLabelCPOldPass: TIWLabel;
    IWedtCPOldPass: TIWEdit;
    IWedtCPNewPass: TIWEdit;
    IWbtnCPOK: TIWButton;
    IWbtnCPCancel: TIWButton;
    IWLabelCPNewPass: TIWLabel;
    IWlabCPVerifyPass: TIWLabel;
    IWedtCPVerifyPass: TIWEdit;
    IWbtnChangePass: TIWButton;
    IWcBoxZJHTSpList: TIWComboBox;
    IWLabelApp: TIWLabel;
    IWPTServers: TIWLabel;
    IWLHZSServers: TIWLabel;
    procedure TIWBasicSideNavBar1ItemClick(Sender: TComponent; PanelIndex,
      ItemIndex: Integer);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWbtnCloseAppClick(Sender: TObject);
    procedure IWbtnChangePassClick(Sender: TObject);
    procedure IWbtnCPCancelClick(Sender: TObject);
    procedure IWbtnCPOKClick(Sender: TObject);
    procedure IWcBoxZJHTSpListChange(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWcBoxZJHTServersChange(Sender: TObject);
  private
    GlobalToolButton: TStatToolButtons;
    SingleToolButton: TStatToolButtons;
  public
    procedure SetServerListSelect(sName: string);
    procedure ShowHumlog(pHumName,pItemName: string;pDTStart,pDTEnd: TDateTime);
    procedure ShowLoginLog(pIndex: Integer;pHumName: string;pDTStart,pDTEnd: TDateTime);
    procedure ShowItemTrace(pItemID: string;pDTStart,pDTEnd: TDateTime);
    procedure ShowIllegalInfo(pDTStart,pDTEnd: TDateTime);
    procedure SetToolButtonList(index: Integer);
    procedure LoadcBoxZJHTServers;
    procedure AddSPServers(sServerName: string);
    function GetParentServerName(sServerName: string): string;
  end;

function Langtostr(num: Integer): string;

implementation

uses ServerController, ConfigINI, UnitfrmOnlineCount, UnitfrmRole,
  UnitfrmRoleLevel, UnitfrmPayRoleLevel, UnitfrmLevelRole, UnitfrmLogin,
  UnitIWfrmUserConsume, UnitfrmPayUser, UnitfrmPayAllUser, UnitIWfrmPay,
  UnitfrmBonus, UnitIWfrmConsume, UnitIWfrmUserConsumeOrder, UnitIWfrmPayOrder,
  UnitfrmLevelRank, UnitfrmMoneyRank, UnitfrmGoldRank, UnitIWfrmHumLog,
  UnitfrmNoticeGS, UnitfrmLoginLog, UnitfrmItemTrace, UnitfrmItems,
  UnitfrmAccountLoss, UnitfrmRoleConsume, UnitfrmRoleInfo,
  UnitfrmActivityItem, UnitfrmReloadNPC, UnitfrmRoleGS,
  UnitfrmFunctionGS, UnitfrmDelayUphole, UnitfrmExpRateGS, UnitfrmShopGS,
  UnitfrmDataEngine, UnitfrmActivityItemGS, UnitfrmBindGoldGS,
  UnitfrmAccountType, UnitfrmRoleStayTime, UnitfrmCreateAccount, UnitfrmShop,
  UnitfrmShopType, UnitfrmCurOnline, UnitfrmGlobalOnline, UnitfrmGlobalPay,
  UnitfrmUserCount, UnitfrmExtractGold, UnitfrmPayDetail, UnitfrmAcross,
  UnitfrmSysExceptLog, UnitfrmViewState, UnitSetUserPop, UnitfrmBasicConfig,
  UnitfrmAcrossRank, UnitfrmAvgOnline, UnitfrmGlobalAccount, UnitfrmConsumeYXB,
  UnitfrmAccountRate, UnitfrmBonusDetail, UnitfrmBonusGS, UnitfrmSex,
  UnitfrmDataExport, UnitfrmLoginStatus, UnitfrmRoleActivityItemGS,
  UnitfrmOperateLog, UnitfrmDayLoss, UnitfrmOnlineRegister, UnitfrmCountry,
  UnitfrmBindConsume, UnitfrmZYRank, UnitfrmBindGoldRank, UnitfrmReputeRank,
  UnitfrmTaskLoss, UnitfrmReputeShopOrder, UnitfrmBugInfo, UnitfrmOverview,
  UnitfrmZYCount, UnitfrmSeedGold, UnitfrmDmkjGold, UnitfrmOpenModuleGS,
  UnitfrmInsiderAccount, UnitFlashPlayerVersion, UnitARPU, UnitfrmStockItem,
  UnitfrmSurplusMoney, UnitfrmOnlineAndPay, UnitfrmGameFeedback, UnitfrmGameEngineList,
  UnitfrmGMGS, UnitfrmFirstExtrYbCount, UnitfrmHonourvalTotal, UnitfrmItemsTotal,
  UnitfrmTreasureHuntTotal, UnitfrmFinCurrencyTotal,UnitfrmStallTrack,UnitfrmMonDieTotal,
  UnitfrmHumDieLevel, UnitfrmHumMapOnline, UnitfrmCopyTrack, UnitfrmHumdieMap,
  UnitfrmFirstConsume, UnitfrmConsumeLevel,UnitfrmFirstExtrYb,UnitfrmHumDropItems,
  UnitfrmMonKillhum, UnitfrmMonStrength,UnitfrmLoginAgain,UnitfrmLoginModeTotal,
  UnitfrmIntegralTotal, UnitfrmHeroInfo, UnitfrmHunShiInfo, UnitfrmRelati,
  UnitfrmCompenGS, UnitfrmAbuseGS, UnitfrmDropReteGS, UnitfrmS1Engine,
  UnitfrmGuildList,UnitfrmAllOnlineAndPay, UnitfrmIllegalInfo, UnitfrmGlobalUserYuanbao,
  UnitfrmVaseries, UnitfrmIWStatList;

{$R *.dfm}


function Langtostr(num: Integer): string;
begin
  Result := UserSession.ALangs.Find(UserSession.iLangNum, num);
end;

procedure TIWFormBasic.AddSPServers(sServerName: string);
var
  I: Integer;
  spID,strTmp: string;
  psld: PTServerListData;
begin
  IWcBoxZJHTServers.Items.Clear;
  spID := GetServerListData(sServerName).spID;
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := GetServerListData(ServerList.Strings[I]);
    if psld <> nil then
    begin
      if (psld.spID = spID) and (psld.IsDisplay or (UserSession.curTB in [Ord(tbHumLog),Ord(tbItemTrace),Ord(tbLoginLog)])) then
      begin
        strTmp := ServerList.Strings[I];
        IWcBoxZJHTServers.Items.Add(strTmp);
      end;
    end;
  end;
end;

function TIWFormBasic.GetParentServerName(sServerName: string): string;
var
  I: Integer;
  spID: string;
  psld: PTServerListData;
begin
  psld := GetServerListData(sServerName);
  spID := psld.spID;
  if psld.Index = 0 then
  begin
    Result := sServerName;
  end
  else begin
    for I := 0 to ServerList.Count - 1 do
    begin
      psld := PTServerListData(ServerList.Objects[I]);
      if (psld.spID = spID) and (psld.Index = 0) then
      begin
        Result := ServerList.Strings[I];
      end;
    end;
  end;
end;

procedure TIWFormBasic.IWAppFormCreate(Sender: TObject);
var
  S: string;
  ServerListData: PTServerListData;
  function GetWeek: Integer;
  var
    mytime:SYSTEMTIME;
  begin
    GetLocalTime(mytime);
    case mytime.wDayOfWeek of
      0: Result:= 137;//'������';
      1: Result:= 138;//'����һ';
      2: Result:= 139;//'���ڶ�';
      3: Result:= 140;//'������';
      4: Result:= 141;//'������';
      5: Result:= 142;//'������';
      6: Result:= 143;//'������';
    else
      Result:= 424;
    end;
  end;
begin
  CoInitialize(nil);
  LoadcBoxZJHTServers;
  IWlabZJHTTitle.Caption := Langtostr(1);
  IWlabCurUser.Caption := Format(Langtostr(2),[UserSession.UserName]);
  IWlabCurDate.Caption := Format(Langtostr(3),[FormatDateTime(Langtostr(144){YYYY��MM��DD��},Now), Langtostr(GetWeek)]);
  IWbtnChangePass.Caption := Langtostr(4);
  IWbtnCloseApp.Caption := Langtostr(5);

  IWlabChangePassTitle.Caption := Langtostr(4);
  IWLabelCPOldPass.Caption := Langtostr(6);
  IWLabelCPNewPass.Caption := Langtostr(7);
  IWlabCPVerifyPass.Caption := Langtostr(8);
  IWbtnCPOK.Caption := Langtostr(168);
  IWbtnCPCancel.Caption := Langtostr(169);

  GlobalToolButton := [tbOnlineCount,tbCurOnline,tbAvgOnline,tbGlobalOnline,tbLogin,tbLoginModeTotal,tbUserConsume,tbPay,
  tbBonus,tbGlobalPay,tbUserCount,tbShop,tbShopType,tbConsume,tbUserConsumeOrder,tbPayOrder,tbLoginLog,
  tbExtractGold,tbPayDetail,tbPayAllUser,tbSysExceptLog,tbReloadNPC,tbRoleGS,tbNoticeGS,
  tbFunctionGS,tbAbuseGS,tbDelayUphole,tbExpRateGS,tbCompenGS,tbDropReteGS,tbShopGS,tbDataEngine,tbBindGoldGS,tbBasicConfig,tbSetUserPop,
  tbActivityItemGS,tbGlobalAccount,tbConsumeYXB,tbBonusDetail,tbLoginStatus,tbRoleStayTime,tbOperateLog,
  tbBindConsume,tbReputeShopOrder,tbBugInfo,tbOverview,btZYCount,tbOpenModuleGS,tbInsiderAccount,
  tbFlashPlayerVersion,tbARPU,tbSurplusMoney,tbOnlineAndPay,tbAllOnlineAndPay,tbGameFeedback,tbGameEngineList,tbIWStatList,
  tbS1Engine,tbIllegalInfo,tbGMGS,tbGlobalUserYuanbao,tbVaseries,tbViewState];

  SingleToolButton := [tbOnlineCount,tbRole,tbRoleLevel,tbPayRoleLevel,tbLevelRole,tbLogin,tbLoginModeTotal,tbLoginAgain,tbUserConsume,
  tbPay,tbBonus,tbConsume,tbUserConsumeOrder,tbPayOrder,tbLevelRank,tbMoneyRank,tbGoldRank,tbIntegralTotal,tbHumLog,tbLoginLog,
  tbItemTrace,tbItems,tbPayAllUser,tbAccountLoss,tbDayLoss,tbRoleConsume,tbRoleInfo,tbHeroInfo,tbHunShi,tbRelati,tbGuildInfo,tbActivityItem,
  tbReloadNPC,tbRoleGS,tbNoticeGS,tbFunctionGS,tbAbuseGS,tbDelayUphole,tbExpRateGS,tbCompenGS,tbDropReteGS,tbShopGS,tbDataEngine,
  tbBindGoldGS,tbShop,tbShopType,tbPayUser,tbAccountType,tbCreateAccount,tbBasicConfig,tbSetUserPop,tbBonusGS,
  tbSex,tbDataExport,tbLoginStatus,tbAccountRate,tbRoleActivityItemGS,tbOnlineRegister,tbCountry,tbBindConsume,
  tbZyRank,tbBindGoldRank,tbReputeRank,tbTaskLoss,tbReputeShopOrder,tbOverview,tbSeedGold,tbDmkjGold,tbOpenModuleGS,
  tbARPU,tbStockItem,tbGameFeedback,tbGameEngineList,tbIWStatList,tbS1Engine,tbIllegalInfo,tbGMGS, tbFirstExtrYbCount, btFirstExtrYb,
  btHonourvalTotal,tbHumDieLevel, tbItemsTotal, tbTreasureHuntTotal, tbCurrTotal,btStallTrack, tbMonDieTotal,
  tbHumMapCount,tbCopyTrack,tbHumdieMap,tbHumDropItems, tbFirstConsume, tbConsumeLevel,tbMonKillhum,tbMonStrength,tbGlobalUserYuanbao];

  Title := objINI.sAppTitle;
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  SetToolButtonList(ServerListData.Index);
  IWlabOpenServerTime.Caption := '';
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),'']);
  if ServerListData.Index <> 0 then
  begin
    IWlabOpenServerTime.Caption := Langtostr(145){'����ʱ�䣺'}+ServerListData.OpenTime;
  end;
  S := GetParentServerName(UserSession.pServerName);
  IWcBoxZJHTSpList.ItemIndex := IWcBoxZJHTSpList.Items.IndexOf(S);
  if IWcBoxZJHTSpList.Items.Count > 0 then
  begin
    AddSPServers(S);
  end;
  IWcBoxZJHTServers.ItemIndex := IWcBoxZJHTServers.Items.IndexOf(UserSession.pServerName);

end;

procedure TIWFormBasic.IWAppFormDestroy(Sender: TObject);
begin
  CoUninitialize;
end;

procedure TIWFormBasic.IWbtnCloseAppClick(Sender: TObject);
begin
  WebApplication.Terminate('You have to exit security system');
end;

procedure TIWFormBasic.IWbtnCPCancelClick(Sender: TObject);
begin
  IWRegionChangePass.Visible := False;
end;

procedure TIWFormBasic.IWbtnCPOKClick(Sender: TObject);
var
  xmlDoc : IXMLDOMDocument;
  xmlNode,UserNode: IXMLDomNode;
begin
  if IWedtCPNewPass.Text <> IWedtCPVerifyPass.Text then
  begin
    WebApplication.ShowMessage(Langtostr(146){'�������ȷ�����벻һ�£�����������'});
    Exit;
  end;
  CoInitialize(nil);
  xmlDoc := CoDOMDocument.Create();
  try
    if FileExists(AppPathEx+UserPopFile) then
    begin
      if xmlDoc.load(AppPathEx+UserPopFile) then
      begin
        xmlNode := xmlDoc.documentElement;
        UserNode := xmlNode.selectSingleNode(Format('//User[@Name="%s"]',[UserSession.UserName]));
        if UserNode <> nil then
        begin
          if MD5EncryptString(AnsiString(IWedtCPOldPass.Text))= AnsiString(UserNode.attributes.getNamedItem('Password').text) then
          begin
            (UserNode as IXMLDOMElement).setAttribute('Password',MD5EncryptString(AnsiString(IWedtCPNewPass.Text)));
            xmlDoc.save(AppPathEx+UserPopFile);
            WebApplication.ShowMessage(Langtostr(147){'�������óɹ�'});
            IWRegionChangePass.Visible := False;
          end
          else begin
            WebApplication.ShowMessage(Langtostr(148){'ԭ���벻��ȷ'});
          end;
        end;
      end;
    end;
  finally
    xmlDoc := nil;
    CoUninitialize;
  end;
end;

procedure TIWFormBasic.IWcBoxZJHTServersChange(Sender: TObject);
var
  TipTime: string;
  ServerListData: PTServerListData;
begin
  IWRegion1.Visible := False;
  UserSession.pServerName := IWcBoxZJHTServers.Text;
  Title := objINI.sAppTitle + ' - ' + Trim(UserSession.pServerName);
  ServerListData := PTServerListData(ServerList.Objects[ServerList.IndexOf(Trim(UserSession.pServerName))]);
  SetToolButtonList(ServerListData.Index);
  IWlabOpenServerTime.Caption := '';
  if ServerListData.Index <> 0 then
  begin
    TipTime := ServerListData.OpenTime;
    if TipTime = '' then TipTime := Langtostr(149){'������δ���������Ե�'};
    IWlabOpenServerTime.Caption := Langtostr(145){'����ʱ�䣺'}+TipTime;
  end;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),'']);
end;

procedure TIWFormBasic.IWcBoxZJHTSpListChange(Sender: TObject);
begin
  AddSPServers(IWcBoxZJHTSpList.Text);
  if IWcBoxZJHTServers.Items.Count > 0 then
  begin
    IWcBoxZJHTServers.ItemIndex := 0;
  end;
  IWcBoxZJHTServers.OnChange(self);
end;

procedure TIWFormBasic.IWbtnChangePassClick(Sender: TObject);
begin
  IWRegionChangePass.Left := Trunc((Width/2)-(IWRegionChangePass.Width/2));
  IWRegionChangePass.Top := Trunc((Height/2)-(IWRegionChangePass.Height/2));
  IWRegionChangePass.Visible := True;
  IWedtCPOldPass.Text := '';
  IWedtCPNewPass.Text := '';
  IWedtCPVerifyPass.Text := '';
end;

procedure TIWFormBasic.LoadcBoxZJHTServers;
var
  I: Integer;
  spID: string;
  psld: PTServerListData;
begin
  for I := 0 to ServerList.Count - 1 do
  begin
    psld := PTServerListData(ServerList.Objects[I]);
    //if psld.Index <> 0 then break;  ԭ��
    if psld.Index <> 0 then Continue;
    spID := psld.spID;
    if (Pos(spID,UserSession.UserSpid) <> 0) or (UserSession.UserSpid = 'ALL') or (UserSession.UserName = AdminUser) then
    begin
      IWcBoxZJHTSpList.Items.Add(ServerList.Strings[I]);
    end;
  end;
end;

procedure TIWFormBasic.SetServerListSelect(sName: string);
var
  I,J: Integer;
begin
  if sName = '' then Exit;
  for I := 0 to TIWBasicSideNavBar1.Panels.Count - 1 do
  begin
    for J := 0 to TIWBasicSideNavBar1.Panels[I].Items.Count - 1 do
    begin
      if TIWBasicSideNavBar1.Panels[I].Items[J].Caption = sName then
      begin
        TIWBasicSideNavBar1.ActivePanel := I;
        TIWBasicSideNavBar1.SelectedItem := TIWBasicSideNavBar1.Panels[I].Items[J].Index;
        break;
      end;
    end;
  end;
end;

procedure TIWFormBasic.SetToolButtonList(index: Integer);
var
  I,J,iCount: Integer;
  GroupPanel :TExchangeBarPanel;
  tmpToolButton: TStatToolButtons;
  tmpTB: TStatToolButton;
  IsAdd: Boolean;
begin
  tmpToolButton := SingleToolButton;
  if index = 0 then tmpToolButton := GlobalToolButton;
  TIWBasicSideNavBar1.Panels.Clear;
  for I := 0 to Integer(High(ToolButtonGroupStr)) do
  begin
    GroupPanel := TIWBasicSideNavBar1.Panels.Add;
    GroupPanel.Caption :=  Langtostr(ToolButtonGroupStr[TToolButtonGroup(I)]);
    GroupPanel.Tag := I;
    GroupPanel.Glyph.FileName := ToolButtonFileIcon[TToolButtonGroup(I)];
    for J := 0 to High(ToolButtonGroup[TToolButtonGroup(I)]) do
    begin
      if ToolButtonGroup[TToolButtonGroup(I)][J] = -1 then continue;
      tmpTB := TStatToolButton(ToolButtonGroup[TToolButtonGroup(I)][J]);
      if (tmpTB In tmpToolButton) and (UserSession.GetModulePrivilege(Ord(tmpTB)+1)) then
      begin
        IsAdd := True;
        if IsAdd then
        begin
          with GroupPanel.Items.Add do
          begin
            Caption := Langtostr(StatToolButtonStr[TStatToolButton(tmpTB)]);
            Glyph.FileName := ToolButtonFileIcon[TToolButtonGroup(I)];
            Tag := Ord(tmpTB);
          end;
        end;
      end;
    end;
  end;
  iCount := TIWBasicSideNavBar1.Panels.Count;
  for I := TIWBasicSideNavBar1.Panels.Count-1 downto 0 do
  begin
    if TIWBasicSideNavBar1.Panels[I].Items.Count = 0 then
    begin
      Dec(iCount);
      TIWBasicSideNavBar1.Panels.Delete(I);
    end;
  end;
  TIWBasicSideNavBar1.VisiblePanels := iCount;
end;

procedure TIWFormBasic.ShowHumlog(pHumName,pItemName: string;pDTStart,pDTEnd: TDateTime);
begin
  with Move(TIWfrmHumLog,False) as TIWfrmHumLog do
  begin
    EditHumName.Text := pHumName;
    EditItemName.Text := pItemName;
    pSDate.Date := pDTStart;
    pEDate.Date := pDTEnd;
    IWbtTrace.OnClick(self);
    Show;
  end;
end;

procedure TIWFormBasic.ShowItemTrace(pItemID: string; pDTStart,
  pDTEnd: TDateTime);
begin
  with Move(TIWfrmItemTrace,False) as TIWfrmItemTrace do
  begin
    EditItemId.Text := pItemID;
    DTStart.Date := pDTStart;
    DTEnd.Date := pDTEnd;
    IWbtTrace.OnClick(self);
    Show;
  end;
end;

procedure TIWFormBasic.ShowLoginLog(pIndex: Integer;pHumName: string;pDTStart,pDTEnd: TDateTime);
begin
  with Move(TIWfrmLoginLog,False) as TIWfrmLoginLog do
  begin
    EditHumName.Text := pHumName;
    CBType.ItemIndex := pIndex;
    DTStart.Date := pDTStart;
    DTEnd.Date := pDTEnd;
    IWbtTrace.OnClick(self);
    Show;
  end;
end;

procedure TIWFormBasic.ShowIllegalInfo(pDTStart,pDTEnd: TDateTime);
begin
  with Move(TIWfrmIllegalInfo,False) as TIWfrmIllegalInfo do
  begin
    pSDate.Date := pDTStart;
    pEDate.Date := pDTEnd;
    IWBtnBuild.OnClick(self);
    Show;
  end;
end;

procedure TIWFormBasic.TIWBasicSideNavBar1ItemClick(Sender: TComponent;
  PanelIndex, ItemIndex: Integer);
var
  S: string;
begin
  S := TIWBasicSideNavBar1.Panels[PanelIndex].Items[ItemIndex].Caption;
  IWlabcurServer.Caption := Format(objINI.curTipText,[Trim(UserSession.pServerName),S]);
  UserSession.curTB := TIWBasicSideNavBar1.Panels[PanelIndex].Items[ItemIndex].Tag;
  case TStatToolButton(UserSession.curTB) of
    tbOnlineCount:
    begin
      with (Move(TIWfrmOnlineCount) as TIWfrmOnlineCount) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbRole:
    begin
      with (Move(TIWfrmRole) as TIWfrmRole) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbRoleLevel:
    begin
      with (Move(TIWfrmRoleLevel) as TIWfrmRoleLevel) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbPayRoleLevel:
    begin
      with (Move(TIWfrmPayRoleLevel) as TIWfrmPayRoleLevel) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbLevelRole:
    begin
      with (Move(TIWfrmLevelRole) as TIWfrmLevelRole) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbLogin:
    begin
      with (Move(TIWfrmLogin) as TIWfrmLogin) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbLoginModeTotal:
    begin
      with (Move(TIWfrmLoginModeTotal) as TIWfrmLoginModeTotal) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbLoginAgain:
    begin
      with (Move(TIWfrmLoginAgain) as TIWfrmLoginAgain) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbUserConsume:
    begin
      with (Move(TIWfrmUserConsume) as TIWfrmUserConsume) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbPay:
    begin
      with (Move(TIWfrmPay) as TIWfrmPay) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbBonus:
    begin
      with (Move(TIWfrmBonus) as TIWfrmBonus) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbConsume:
    begin
      with (Move(TIWfrmConsume) as TIWfrmConsume) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbUserConsumeOrder:
    begin
      with (Move(TIWfrmUserConsumeOrder) as TIWfrmUserConsumeOrder) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbPayOrder:
    begin
      with (Move(TIWfrmPayOrder) as TIWfrmPayOrder) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbLevelRank: Move(TIWfrmLevelRank).Show;
    tbMoneyRank: Move(TIWfrmMoneyRank).Show;
    tbGoldRank: Move(TIWfrmGoldRank).Show;
    tbIntegralTotal: Move(TIWfrmIntegralTotal).Show;
    tbHumLog:
    begin
      Move(TIWfrmHumLog).Show;
    end;
    tbLoginLog: Move(TIWfrmLoginLog).Show;
    tbItemTrace:
    begin
      Move(TIWfrmItemTrace).Show;
    end;
    tbItems:
    begin
      Move(TIWfrmItems).Show;
    end;
    tbPayAllUser:
    begin
      with Move(TIWfrmPayAllUser) as TIWfrmPayAllUser do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbAccountLoss:
    begin
      with (Move(TIWfrmAccountLoss) as TIWfrmAccountLoss) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbRoleConsume:
    begin
      with Move(TIWfrmRoleConsume) as TIWfrmRoleConsume do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbRoleInfo:
    begin
      Move(TIWfrmRoleInfo).Show;
    end;
    tbHeroInfo:
    begin
      Move(TIWfrmHeroInfo).Show;
    end;
    tbHunShi:
    begin
      Move(TIWfrmHunShiInfo).Show;
    end;
    tbRelati:
    begin
      Move(TIWfrmRelati).Show;
    end;
    tbGuildInfo:
    begin
      Move(TIWfrmGuildList).Show;
    end;
    tbActivityItem:
    begin
      Move(TIWfrmActivityItem).Show;
    end;
    tbReloadNPC:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmReloadNPC).Show;
    end;
    tbRoleGS:
    begin
      Move(TIWfrmRoleGS).Show;
    end;
    tbNoticeGS:
    begin
      Move(TIWfrmNoticeGS).Show;
    end;
    tbFunctionGS:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmFunctionGS).Show;
    end;
    tbAbuseGS:
    begin
      Move(TIWfrmAbuseGS).Show;
    end;
    tbDelayUphole:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmDelayUphole).Show;
    end;
    tbExpRateGS:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmExpRateGS).Show;
    end;
    tbCompenGS:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmCompenGS).Show;
    end;
    tbDropReteGS:
    begin
      Move(TIWfrmDropReteGS).Show;
    end;
    tbShopGS:
    begin
      Move(TIWfrmShopGS).Show;
    end;
    tbDataEngine:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmDataEngine).Show;
    end;
    tbActivityItemGS:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmActivityItemGS).Show;
    end;
    tbBindGoldGS:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmBindGoldGS).Show;
    end;
    tbPayUser: Move(TIWfrmPayUser).Show;
    tbAccountType:
    begin
      with Move(TIWfrmAccountType) as TIWfrmAccountType do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbRoleStayTime:
    begin
      with Move(TIWfrmRoleStayTime) as TIWfrmRoleStayTime do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbCreateAccount:
    begin
      with Move(TIWfrmCreateAccount) as TIWfrmCreateAccount do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbShop:
    begin
      Move(TIWfrmShop).Show;
    end;
    tbShopType:
    begin
      with (Move(TIWfrmShopType) as TIWfrmShopType) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbCurOnline: Move(TIWfrmCurOnline).Show;
    tbGlobalOnline:
    begin
      with (Move(TIWfrmGlobalOnline) as TIWfrmGlobalOnline) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbGlobalPay:
    begin
      with (Move(TIWfrmGlobalPay) as TIWfrmGlobalPay) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbUserCount:
    begin
      with (Move(TIWfrmUserCount) as TIWfrmUserCount) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbExtractGold:
    begin
      with (Move(TIWfrmExtractGold) as TIWfrmExtractGold) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbPayDetail:
    begin
      with (Move(TIWfrmPayDetail) as TIWfrmPayDetail) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbAcross:
    begin
      with Move(TIWfrmAcross) as TIWfrmAcross do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbSysExceptLog:
    begin
      with Move(TIWfrmSysExceptLog) as TIWfrmSysExceptLog do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbViewState: Move(TIWfrmViewState).Show;
    tbSetUserPop: Move(TIWfrmSetUserPop).Show;
    tbBasicConfig: Move(TIWfrmBasicConfig).Show;
    tbAcrossRank:
    begin
      with Move(TIWfrmAcrossRank) as TIWfrmAcrossRank do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbAvgOnline:
    begin
      with (Move(TIWfrmAvgOnline) as TIWfrmAvgOnline) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbGlobalAccount:
    begin
      with (Move(TIWfrmGlobalAccount) as TIWfrmGlobalAccount) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbConsumeYXB:
    begin
      with (Move(TIWfrmConsumeYXB) as TIWfrmConsumeYXB) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbAccountRate:
    begin
      with (Move(TIWfrmAccountRate) as TIWfrmAccountRate) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbBonusDetail:
    begin
      with (Move(TIWfrmBonusDetail) as TIWfrmBonusDetail) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbBonusGS:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmBonusGS).Show;
    end;
    tbSex:
    begin
      with (Move(TIWfrmSex) as TIWfrmSex) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbDataExport:
    begin
      Move(TIWfrmDataExport).Show;
    end;
    tbLoginStatus:
    begin
      with (Move(TIWfrmLoginStatus) as TIWfrmLoginStatus) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbRoleActivityItemGS:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmRoleActivityItemGS).Show;
    end;
//    tbPet: Move(TIWfrmPet).Show;
    tbOperateLog:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      with (Move(TIWfrmOperateLog) as TIWfrmOperateLog) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbDayLoss:
    begin
      with (Move(TIWfrmDayLoss) as TIWfrmDayLoss) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbOnlineRegister:
    begin
      with (Move(TIWfrmOnlineRegister) as TIWfrmOnlineRegister) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbCountry:
    begin
      with (Move(TIWfrmCountry) as TIWfrmCountry) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbBindConsume:
    begin
      with (Move(TIWfrmBindConsume) as TIWfrmBindConsume) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbZyRank: Move(TIWfrmZYRank).Show;
    tbBindGoldRank: Move(TIWfrmBindGold).Show;
    tbReputeRank: Move(TIWfrmReputeRank).Show;
    tbTaskLoss:
    begin
      with (Move(TIWfrmTaskLoss) as TIWfrmTaskLoss) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbReputeShopOrder:
    begin
      with (Move(TIWfrmReputeShopOrder) as TIWfrmReputeShopOrder) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbBugInfo:
    begin
      with (Move(TIWfrmBugInfo) as TIWfrmBugInfo) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbOverview:
    begin
      with (Move(TIWfrmOverview) as TIWfrmOverview) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    btZYCount:
    begin
      with (Move(TIWfrmZYCount) as TIWfrmZYCount) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbSeedGold:
    begin
      with (Move(TIWfrmSeedGold) as TIWfrmSeedGold) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbDmkjGold:
    begin
      with (Move(TIWfrmDmkjGold) as TIWfrmDmkjGold) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbOpenModuleGS:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      Move(TIWfrmOpenModuleGS).Show;
    end;
    tbInsiderAccount:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
      with (Move(TIWfrmInsiderAccount) as TIWfrmInsiderAccount) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbFlashPlayerVersion:
    begin
      with (Move(TIWfrmFlashPlayerVersion) as TIWfrmFlashPlayerVersion) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbARPU:
    begin
      with (Move(TIWfrmARPU) as TIWfrmARPU) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbStockItem:
    begin
      with (Move(TIWfrmStockItem) as TIWfrmStockItem) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbSurplusMoney:
    begin
      with (Move(TIWfrmSurplusMoney) as TIWfrmSurplusMoney) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbOnlineAndPay:
    begin
      with (Move(TIWfrmOnlineAndPay) as TIWfrmOnlineAndPay) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbAllOnlineAndPay:
    begin
      with (Move(TIWfrmAllOnlineAndPay) as TIWfrmAllOnlineAndPay) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbGameFeedback:
    begin
      with (Move(TIWfrmGameFeedback) as TIWfrmGameFeedback) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbGameEngineList:
    begin
      with (Move(TIWfrmGameEngineList) as TIWfrmGameEngineList) do
      begin
        IWBtnBuild.OnClick(self);
        Show;
      end;
    end;
    tbIWStatList:
    begin
      if (AuthUserIPList.Count > 0) and (AuthUserIPList.IndexOf(WebApplication.IP) = -1) then
      begin
        WebApplication.ShowMessage('��ǰIP�޷�ʹ�ô˹��ܣ�δ��Ȩ');
        Exit;
      end;
       Move(TIWfrmIWStatList).Show;
    end;
    tbS1Engine:
    begin
       Move(TIWfrmS1Engine).Show;
    end;
    tbIllegalInfo:
    begin
       Move(TIWfrmIllegalInfo).Show;
    end;
    tbGMGS:
    begin
       Move(TIWfrmGMGS).Show;
    end;
    tbFirstExtrYbCount:
    begin
       Move(TIWfrmFirstExtrYbCount).Show;
    end;
    btFirstExtrYb:
    begin
      Move(TIWfrmFirstExtrYb).Show;
    end;
    btHonourvalTotal: Move(TIWfrmHonourvalTotal).Show;
    tbHumDieLevel: Move(TIWfrmHumDieLevel).Show;
    tbItemsTotal:
    begin
      Move(TIWfrmItemsTotal).Show;
    end;
    tbTreasureHuntTotal:
    begin
      Move(TIWfrmTreasureHuntTotal).Show;
    end;
    btStallTrack:
    begin
      Move(TIWfrmStallTrack).Show;
    end;
    tbMonDieTotal:
    begin
      Move(TIWfrmMonDieTotal).Show;
    end;
    tbCurrTotal:
    begin
      Move(TIWfrmFinCurrencyTotal).Show;
    end;
    tbHumMapCount:
    begin
      Move(TIWfrmHumMapOnline).Show;
    end;
   tbCopyTrack:
    begin
      Move(TIWfrmCopyTrack).Show;
    end;
    tbHumdieMap: Move(TIWfrmHumdieMap).Show;
    tbHumDropItems : Move(TIWfrmHumDropItems).Show;
   tbFirstConsume:
    begin
      Move(TIWfrmFirstConsume).Show;
    end;
   tbConsumeLevel:
    begin
      Move(TIWfrmConsumeLevel).Show;
    end;
   tbMonKillhum:
    begin
      Move(TIWfrmMonKillhum).Show;
    end;
    tbMonStrength:
    begin
      Move(TIWfrmMonStrength).Show;
    end;
    tbGlobalUserYuanbao:
    begin
      Move(TIWfrmGlobalUserYuanbao).Show;
    end;
    tbVaseries:
    begin
      Move(TIWfrmVaseries).Show;
    end;
  end;
end;

end.
