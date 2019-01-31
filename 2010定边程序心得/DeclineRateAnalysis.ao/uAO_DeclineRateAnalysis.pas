unit uAO_DeclineRateAnalysis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uModRoot, ExtCtrls, StdCtrls, udmCLXBaseAppX, ImgList, Menus,
  cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxClasses, cxControls,
  cxGridCustomView, cxGrid, RzCmboBx, RzButton, MSHTML,
  uEIRCHostInterfaces, uStyleSeting, uGlobal,
  uDADataStreamer, uDABin2DataStreamer, uDADataTable, uDARemoteDataAdapter,
  ActnList, Grids, DBGrids, uDAInterfaces, uDAScriptingProvider,
  uDAMemDataTable, TeEngine, TeeURL, TeeSeriesTextEd, TFlatSpeedButtonUnit,
  RzStatus, TFlatPanelUnit, RzGrids, TeeComma, RzEdit, RzLabel, Series,
  TeeProcs, Chart, GridsEh, DBGridEh, RzTabs, RzRadChk, Mask, RzBtnEdt,
  ComCtrls, RzDTP, RzPanel, RzSplit,math,StrUtils, uROClient,IMainFrm,uEIRC2010Consts,EIRC_Library_Intf,DbFuncs,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxTextEdit,
  cxMaskEdit, cxDropDownEdit,SysPublicSelect_Decline,UBusinessGlobal;

const
  FilterValue = 0;
  MasterLXID = 1;
  MasterLXName = 2;
  ControlName = 3;
  MasterTableName = 4;
  SlaveTableName = 5;
  SlaveLXID = 6;
  SlaveLXName = 7;

  CxPopupEditCount = 3;

  CxPopupEditsConfig: array[0..CxPopupEditCount - 1, 0..7] of string =
    (
    ('TYPE = ''005''', 'PURPOSE_LAYER', 'PURPOSE_LAYER_NAME', 'PopLayer', 'tbl_DSS_E1_VIEW023', 'tbl_DSS_E1_BAS002', 'LXNO', 'NAME'),     //��λ
    ('TYPE = ''026''', 'AREANO',             'AREA_NAME',          'PopArea',  'DBWellDynDocMan', 'tbl_DSS_E1_BAS002', 'LXNO', 'NAME'),   //����
    ('WellNo <>0',    'WELLNO',              'WELLNAME',           'PopWellName',  'DBWellDynDocMan', 'tbl_DSS_E1_BAS003', 'LXNO', 'NAME') //�;�
    );
type
  TAO_DeclineRateAnalysis = class(TModRoot)
    RemoteDataAdapter: TDARemoteDataAdapter;
    DataStreamer: TDABin2DataStreamer;
    ActionList1: TActionList;
    actRefresh: TAction;
    actNew: TAction;
    actDelete: TAction;
    actModify: TAction;
    actReport: TAction;
    actExport: TAction;
    actExit: TAction;
    actFind: TAction;
    cdsDayReport: TDAMemDataTable;
    dsDayReport: TDADataSource;
    SeriesTextSource1: TSeriesTextSource;
    RzSizePanel1: TRzSizePanel;
    Panel2: TPanel;
    RzGroupBox1: TRzGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    DayOilType: TRzComboBox;
    DTCtrl1: TRzDateTimePicker;
    DTCtrl2: TRzDateTimePicker;
    SelectType: TRzComboBox;
    ckMultiSelect: TRzCheckBox;
    DayOilNum: TRzNumericEdit;
    RzTabControl1: TRzTabControl;
    Panel1: TPanel;
    Graph: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    RzSizePanel3: TRzSizePanel;
    RzLabel4: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel2: TRzLabel;
    RzBitBtn9: TRzBitBtn;
    RzBitBtn8: TRzBitBtn;
    RzBitBtn7: TRzBitBtn;
    MColorShow: TRzBitBtn;
    CbxStartColor: TRzColorEdit;
    CbxShape: TRzComboBox;
    CbxEndColor: TRzColorEdit;
    DBox: TRzCheckBox;
    RzSavePic: TRzBitBtn;
    RzPrintPic: TRzBitBtn;
    TeeCommand: TTeeCommander;
    RzStringGrid1: TRzStringGrid;
    dbgDayReport: TDBGridEh;
    MenuShowList: TPopupMenu;
    M1: TMenuItem;
    M2: TMenuItem;
    PopWellName: TcxPopupEdit;
    PopLayer: TcxPopupEdit;
    PopArea: TcxPopupEdit;
    RzPanel1: TRzPanel;
    RzClose: TRzBitBtn;
    RzMenuShow: TRzMenuButton;
    RzReport: TRzBitBtn;
    RzQuery: TRzBitBtn;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure DropoutBtClick(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure CbxShapeChange(Sender: TObject);
    procedure DayOilTypeChange(Sender: TObject);
    procedure DBoxClick(Sender: TObject);
    //
  //  procedure CbxShapeChange(Sender: TObject);
    //procedure DayOilTypeChange(Sender: TObject);
    procedure MColorShowClick(Sender: TObject);
    procedure RzBitBtn7Click(Sender: TObject);
    procedure RzBitBtn8Click(Sender: TObject);
    procedure RzBitBtn9Click(Sender: TObject);
    procedure RzPrintPicClick(Sender: TObject);
    procedure RzQueryClick(Sender: TObject);
    procedure RzReportClick(Sender: TObject);
    procedure RzSavePicClick(Sender: TObject);
    //
    procedure ShowGraph(InVar:integer);
    procedure FreeChartSeries(Chart: TChart);
    procedure M1Click(Sender: TObject);
    procedure M2Click(Sender: TObject);
    procedure RzCloseClick(Sender: TObject);
    procedure RzStringGrid1Resize(Sender: TObject);
    procedure RzStringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var
        CanSelect: Boolean);
    procedure RzTabControl1Change(Sender: TObject);
    procedure SelectTypeChange(Sender: TObject);
    procedure SelectTypeCloseUp(Sender: TObject);
  private
    { Private declarations }
    m_Wella : String;
    Mstr,StrTitle:string;
    sTableNames:string;
    SelfKey : Integer;
    SvrSysManage:IEIRCSYS;
    //�ӿ�ܻ�ȡ����Ϣ
    GetDepartID,GetDepartName,GetUserID,GetUserName : String;
  public
    q:Array of Array of Double; //���ݵ�����Ԥ���Ӵ��� OilOutputAnalysePreFrm
    K:integer;
    pMainForm: IMainForm;
    pEIRCHostInterfaceV11: IEIRCHostInterfaceV1;
    tbl_DSS_E1_BAS003: TDAMemDataTable;
    tbl_DSS_E1_SYS01:  TDAMemDataTable;
    tbl_DSS_E1_BAS002: TDAMemDataTable;
    function FindDAMemDataTable(DAMemDataTableName: String): TDAMemDataTable;
    procedure SetcxGridTextDisplay(aDAMemDataTable: TDAMemDataTable; acxGrid: TcxGridDBTableView);
    procedure OnBeforeUnload(const pEvtObj: IHTMLEventObj); override;
    procedure InitModule(Data: string; SvrHost: string); override;
    function DataSaved: Boolean;
    //����ʹ�ð�ť
    procedure SetPrivileges(PrivilegeString: string); //�Լ�ʵ��

    //���ý�����
    procedure SetModuleStyle(ModuleStyle: TEIRCStyle); //�Լ�ʵ��
    procedure cxPopupEditPropertiesPopup(Sender: TObject);
    procedure cxPopupEditPropertiesCloseUp(Sender: TObject);
  end;

function GetModClass: TModRootClass;

var
  UserInfo: TUserInfo;
  ModuleStyle: TEIRCStyle;
  SystemSettingInfo: TSystemSettingInfo;
  AO_DeclineRateAnalysis : TAO_DeclineRateAnalysis;

const
  c_Succeed = 'Succeed';
  
implementation

uses uEmuleEIRCHost, DeclineRateAnalysisPre;

{$R *.dfm}

exports
  GetModClass;


function GetModClass: TModRootClass;
begin
  Result := TAO_DeclineRateAnalysis;
end;


procedure TAO_DeclineRateAnalysis.FormCreate(Sender: TObject);
var SystemTime: TSystemTime;
  I : Integer;
    cxPopupEdit: TcxPopupEdit;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
  DTCtrl1.Date := EncodeDate(wYear - 1, 1, 1);
  with SystemTime do
  DTCtrl2.Date := EncodeDate(wYear, wMonth, 1)-1;
  RzMenuShow.Enabled:=false;
  RzReport.Enabled:=false;
  setlength(q,6,7);
  K:=-1;
  SysPublicSelect_DeclineFrm := TSysPublicSelect_DeclineFrm.Create(Self);
   KeyPreview := True;
  for I := 0 to Self.ComponentCount - 1 do
  begin
    if (Self.Components[I] is TcxPopupEdit) then
    begin
      cxPopupEdit := Self.Components[I] as TcxPopupEdit;
      cxPopupEdit.Properties.OnPopup := cxPopupEditPropertiesPopup;
      cxPopupEdit.Properties.OnCloseUp := cxPopupEditPropertiesCloseUp;
    end;
  end;
end;

procedure TAO_DeclineRateAnalysis.InitModule(Data, SvrHost: string);

begin
  pEIRCHostInterfaceV11 := nil;
  pMainForm := nil;
  AO_DeclineRateAnalysis:=self;
  //����ģʽ
  {$IFDEF DEBUG}
  {EmuleEIRCHost := TEmuleEIRCHost.Create(nil);
  pEIRCHostInterfaceV11 := FindForm('oilworkerman') as IEIRCHostInterfaceV1;
  if not Assigned(pEIRCHostInterfaceV11) then
  begin
    Application.MessageBox(SysInterFaceErr, csMSGClew, MROK);
    Exit;
  end;
   RemoteDataAdapter.remoteservice := pEIRCHostInterfaceV11.GetRemoteService('EIRCService');   }
  {$ELSE}
  //���ģʽ
  pMainForm := FindForm('TFmMain') as IMainForm;
  if not Assigned(pMainForm) then
  begin
    Application.MessageBox(SysInterFaceErr, 'ss', MROK);
    Exit;
  end;
  RemoteDataAdapter.RemoteService := pMainForm.GetRemoteService('EIRCService');
  pMainForm.SetActionStatus(ActionList1, 'oilworkerman', self.ClassName);   //�õ�Ȩ��
  SelfKey := pMainForm.GetModuleHandle;      //ע��1
  //SvrSysManage:=pMainForm.GetConnection(Handle,'','');   //�õ�����Դ
  //csyslog(SvrSysManage,c_Succeed,Self.Name,'���͹���Ϣ��¼',pMainForm.IFmMainEx.LogonInfo.UserID); //д����־
  {$ENDIF}
  //�ӿ�ܵõ�����Ϣ
  tbl_DSS_E1_BAS002:= pMainForm.GetDAMemDataTable('tbl_DSS_E1_BAS002');
  tbl_DSS_E1_SYS01 := pMainForm.GetDAMemDataTable('tbl_DSS_E1_SYS01');
  tbl_DSS_E1_BAS003 := pMainForm.GetDAMemDataTable('tbl_DSS_E1_BAS003');
  GetDepartID   := pMainForm.IFmMainEx.LogonInfo.DepartNo;      //���ű��
  GetDepartName := pMainForm.IFmMainEx.LogonInfo.DepartName  ;  //��������
  GetUserID     := pMainForm.IFmMainEx.LogonInfo.UserID;        //�û�ID
  GetUserName   := pMainForm.IFmMainEx.LogonInfo.UserName;      //�û���

  //self code 2010-1-30
  RzStringGrid1.RowCount:=5;
  RzStringGrid1.ColCount:=6;
  RzStringGrid1.Cols[0].CommaText:='����';
  RzStringGrid1.Cols[1].CommaText:='���͵ݼ�';
  RzStringGrid1.Cols[2].CommaText:='˥�ߵݼ�';
  RzStringGrid1.Cols[3].CommaText:='˫���ݼ�';
  RzStringGrid1.Cols[4].CommaText:='ָ���ݼ�';
  RzStringGrid1.Cols[5].CommaText:='ֱ�ߵݼ�';
  RzStringGrid1.Rows[1].CommaText:='n';
  RzStringGrid1.Rows[2].CommaText:='q0';
  RzStringGrid1.Rows[3].CommaText:='di';
  RzStringGrid1.Rows[4].CommaText:='r';
  RzStringGrid1.DefaultColWidth:= RzStringGrid1.Width div 6;
  RzStringGrid1.Cells[1,1]:='';
  //
  PopWellName.Visible := True;
  PopArea.Visible := False;
  PopLayer.Visible := False;
  ckMultiSelect.Enabled:=True;

end;


procedure TAO_DeclineRateAnalysis.OnBeforeUnload(const pEvtObj: IHTMLEventObj);
begin
  inherited;
end;


function TAO_DeclineRateAnalysis.DataSaved: Boolean;
begin
   //TODO:
  Result := False;
end;

procedure TAO_DeclineRateAnalysis.DropoutBtClick(Sender: TObject);
begin
  inherited;
end;



 {
 'E'   ,'$'       ,'Q'    ,'I'   ,'U'   ,'D'   ,'A'     ,'R'        ,'G'     ,'P'   ,'B'       ,'X'    ,'M'   ,'L'     ,'~'(V)
'����','������','��ѯ','����','�޸�','ɾ��','���','�������','��Ʊ���','��ӡ','������ϸ', '����','����','�ֶβ���','��Ȩ'
 }
//����ʹ�ð�ť
procedure TAO_DeclineRateAnalysis.SetPrivileges(PrivilegeString: string); //�Լ�ʵ��
var
  I: integer;
  PrivilegeChar: AnsiChar;
begin

  for I := 1 to Length(PrivilegeString) do
  begin
    PrivilegeChar := PrivilegeString[I];
    case PrivilegeChar of
      'E': //����
      begin
      end;
      '$': //������
      begin
      end;
      'Q': //��ѯ
      begin
      end;
      'I': //����
      begin
      end;
      'U': //�޸�
      begin
      end;
      'D': //ɾ��
      begin
      end;
      'A': //���
      begin
      end;
      'R': //�������
      begin
      end;
      'G': //��Ʊ���
      begin
      end;
      'P': //��ӡ
      begin
      end;
      'B': //������ϸ
      begin
      end;
      'X': //����
      begin
      end;
      'M': //����
      begin
      end;
      'L': //�ֶβ���
      begin
      end;
      '~': //��Ȩ
      begin
      end;
    end;
  end;
end;

//���ý�����
procedure TAO_DeclineRateAnalysis.SetModuleStyle(ModuleStyle: TEIRCStyle); //�Լ�ʵ��
begin
end;


procedure TAO_DeclineRateAnalysis.actExitExecute(Sender: TObject);
begin
  inherited;
  //'TAO_DeclineRateAnalysis'Ϊ��ģ�������
  if Assigned(pEIRCHostInterfaceV11) then
  begin
    pEIRCHostInterfaceV11.CloseMe('TAO_DeclineRateAnalysis');
  end;
end;

procedure TAO_DeclineRateAnalysis.CbxShapeChange(Sender: TObject);
begin
  ShowGraph(CbxShape.ItemIndex);
end;

procedure TAO_DeclineRateAnalysis.DayOilTypeChange(Sender: TObject);
begin
   if DayOilType.ItemIndex=1 then
    DayOilNum.Visible:=true
  else
    DayOilNum.Visible:=false;
end;

procedure TAO_DeclineRateAnalysis.DBoxClick(Sender: TObject);
begin
  TeeCommand.Button3D.Down := DBox.Checked;
  TeeCommand.Button3D.Click;
end;

 //
 procedure TAO_DeclineRateAnalysis.MColorShowClick(Sender: TObject);
begin
    Graph.Gradient.EndColor := CbxEndColor.SelectedColor;
  Graph.Gradient.StartColor := CbxStartColor.SelectedColor;
  if MColorShow.Caption='�����ʾ' then
  begin
    Graph.Gradient.Visible := True;
    MColorShow.Caption := '�رն��';
  end else begin
    Graph.Gradient.Visible := False;
    MColorShow.Caption := '�����ʾ';
  end;
end;

procedure TAO_DeclineRateAnalysis.RzBitBtn7Click(Sender: TObject);
begin
   TeeCommand.ButtonRotate.Down := true;
end;

procedure TAO_DeclineRateAnalysis.RzBitBtn8Click(Sender: TObject);
begin
  TeeCommand.ButtonMove.Down := True;
end;

procedure TAO_DeclineRateAnalysis.RzBitBtn9Click(Sender: TObject);
begin
  TeeCommand.ButtonNormal.Down := True;
end;

procedure TAO_DeclineRateAnalysis.RzPrintPicClick(Sender: TObject);
begin
 TeeCommand.ButtonPrint.Click;
end;

procedure TAO_DeclineRateAnalysis.RzQueryClick(Sender: TObject);
var ssql: String;
    sTableNames:String;
    m_strDate1,m_strDate2:String;
    m_DayOilType:String;
    m_DayOilNum:String;
    i          : Integer;
function HexToStr(str: String): AnsiString;
  var
    I, L: Integer;
    HexStr: AnsiString;
    K: Ansichar;
  begin
    Result := '';
    L := Length(str);
    for I := 1 to L DIV 2 do
      begin
        HexStr  := '$' + AnsiMidStr(str, I * 2 - 1, 2);
        K       := AnsiChar(CHR(StrToInt(HexStr)));
        Result  := Result + K;
      end;
  end;
begin



   

    dbgDayReport.Visible:=true;
    //Panel1.Visible:=false;
    m_strDate1:=DateToStr(DTCtrl1.Date);
    m_strDate2:=DateToStr(DTCtrl2.Date);

    if SelectType.ItemIndex = 0 then
      m_Wella :=  Trim(PopWellName.Text);

    if SelectType.ItemIndex = 1 then
       m_Wella :=  Trim(PopArea.Text);

    if SelectType.ItemIndex = 2 then
      m_Wella :=  Trim(PopLayer.Text);

    if SelectType.ItemIndex = 3 then
      m_Wella := '';

    if SelectType.ItemIndex=3 then
      StrTitle:='ȫ���;�'
    else
      StrTitle:=m_Wella;

   // m_Wella:=edWellName.Text;
    m_DayOilType:=IntTostr(DayOilType.ItemIndex);
    m_DayOilNum:=FloatToStr(DayOilNum.Value);

    if (Selecttype.ItemIndex<>3) and (m_Wella='') then begin
      showmessage('�Բ�����ѡ����Ŀ��');
      exit;
    end;
   { ssql:='execute Proc_OilOutputDJFX '''+ m_strDate1+''','''+ m_strDate2 +''','''+m_Wella+''','''+ Selecttype.Value +'''';
    sTableNames := 'ProductionMonthDetail';
    SvrCommon := IFmMain.GetConnection(Handle, '', 'ReportServer.untPooler');
    GetDataFormServer(SvrCommon,cdsDayReport,ssql,50000);
    SetFieldProperty(CdsFieldProPerty,cdsDayReport,sTableNames); }

    RzMenuShow.Enabled:=false;
    cdsDayReport.Active := true;
    //DecodeDisplayLables(cdsDayReport);
   try
   for I := 0 to cdsDayReport.fields.count -1 do
   begin
     if cdsDayReport.Fields[I].DisplayLabel <> cdsDayReport.Fields[I].Name then
     begin
        cdsDayReport.Fields[I].DisplayLabel := HexToStr(cdsDayReport.Fields[I].DisplayLabel);
     end;
   end;
 except
 end;
    RzTabControl1.TabIndex:=0;
    if cdsDayReport.RecordCount>0 then
    begin
      RzMenuShow.Enabled:=true;
    end; 

  //
  cdsDayReport.Close;
  cdsDayReport.ParamByName('STARTDATE').AsDateTime := StrToDateTime(m_strDate1);
  cdsDayReport.ParamByName('ENDDATE').AsDateTime := StrToDateTime(m_strDate2) ;
  cdsDayReport.ParamByName('LIST_STR').asstring := m_Wella;
  cdsDayReport.ParamByName('TYPE_STR').asstring := Selecttype.Value;
  cdsDayReport.Open;
end;

procedure TAO_DeclineRateAnalysis.RzReportClick(Sender: TObject);
var I,J:integer;
begin
  frmDeclineRateAnalysisPre := TfrmDeclineRateAnalysisPre.Create(nil);
with frmDeclineRateAnalysisPre do
  begin
  for I := 0 to 6 - 1 do
  begin
    for J := 0 to 7 - 1 do
    begin
       qq[I,J]:=q[I,J];
    end;
  end;
  sday:=DTCtrl1.Date;
    BtnNew.Enabled:=false;
    if ShowModal = mrOk then begin
       showmessage('sss');
    end;
    Free;
  end;  
end;

procedure TAO_DeclineRateAnalysis.RzSavePicClick(Sender: TObject);
begin
 TeeCommand.ButtonSave.Click;
end;

procedure TAO_DeclineRateAnalysis.ShowGraph(InVar: integer);
var
    I,ii,n,I_sel: integer;
    m_strDate1,m_strDate2 : string;
    Aseries:Array of TChartSeries;
    ACol :integer;
    x2,y2,xy,s_x,s_y,A,B: Double;
    r,q0,di,r_sel,q0_sel,di_sel,e_value: Double;
    e:Array of Double;
    y:Array of Double;
    xx,yy:Array of Double;
    PP,QQ,RR,SS,TT,UU,VV,DD,aa,bb,cc: Double;
    n2: integer;

begin

    m_strDate1:=DateToStr(DTCtrl1.Date);
    m_strDate2:=DateToStr(DTCtrl2.Date);
    Panel1.Visible:=true;
    dbgDayReport.Visible:=false;
    FreeChartSeries(Graph);
    Graph.Title.Text.Clear;
    Graph.Title.Text.Clear;


  SetLength(Aseries,3);
  For ACol:=0 to 2 do
  begin
    case CbxShape.ItemIndex of
      0:
      begin
        ASeries[ACol] := TBarSeries.Create(self);
      end;
      1:
      begin
        ASeries[ACol] := TPointSeries.Create(self);
      end;
      2:
      begin
        ASeries[ACol] := TFastLineSeries.Create(self);
      end;
      3:
      begin
        ASeries[ACol] := TLineSeries.Create(self);
      end;
      4:
      begin
        ASeries[ACol] := TAreaSeries.Create(self);
      end;
    end;
    Graph.AddSeries(ASeries[ACol]);
    ASeries[ACol].Marks.Gradient.Visible := True; //��������ʾ������ɫ��Label
    ASeries[ACol].Marks.Style:=smsValue; //��������ʾ����Y���ֵ
   if cdsDayReport.RecordCount>=10 then
    ASeries[ACol].Marks.Visible:=FALSE; //����10��ʱ����ʾY���ֵ��ʾ��ǩ

  end;

  if Mstr='M1' then
  begin
    Graph.Title.Text.Add(StrTitle+'��������ͼ');
    Graph.series[0].Title:='��Һ';
    Graph.series[1].Title:='��ˮ';
    Graph.series[2].Title:='����';
    cdsDayReport.First;
    for i := 0 to cdsDayReport.RecordCount-1 do
    begin
      Aseries[0].addy(cdsDayReport.FieldByName('TOTAL_FLUID').AsFloat,cdsDayReport.FieldByName('YEARMONTH').AsString);
      Aseries[1].addy(cdsDayReport.FieldByName('TOTAL_WATER').AsFloat,cdsDayReport.FieldByName('YEARMONTH').AsString);
      Aseries[2].addy(cdsDayReport.FieldByName('TOTAL_OIL').AsFloat,cdsDayReport.FieldByName('YEARMONTH').AsString);
      cdsDayReport.Next;
    end;

  end
  else
  begin
    Graph.series[1].Free;
    Graph.Title.Text.Add(StrTitle+'�ݼ�����ͼ');
    Graph.series[0].Title:='�ݼ�����';
    Graph.series[2].Title:='ʵ�ʲ���';
    //Graph.series[1].Title:='��Ȼ����';


//*******��ʼ����ݼ��ʺ���******


    r_sel:=0;
    I_sel:=0;
    n:=cdsDayReport.RecordCount;

    setlength(y,cdsDayReport.RecordCount);

    setlength(e,5);   //ȡ(1,0.5,0.2,0,-1)
    e[0]:=1;
    e[1]:=0.5;
    e[2]:=0.2;
    e[3]:=0;
    e[4]:=-1;

    n2:=99; //ȡ(0.01,0.02,...,0.98,0.99)
    setlength(xx,n2);
    setlength(yy,n2);
    for ii := 1 to n2 do
    begin
      xx[ii-1]:=ii/100;
    end;

 Try

    for I := 0 to n2-1 do //����˫���ݼ����������xx(I)ʱ��r
    begin
      cdsDayReport.First;
      for ii := 0 to n-1 do
      begin
        y[ii]:= Power(cdsDayReport.FieldByName('TOTAL_OIL').AsFloat,-xx[I]);
        cdsDayReport.Next;
      end;
      
      x2:=0;
      y2:=0;
      xy:=0;
      s_x:=0;
      s_y:=0;

      for ii := 0 to n-1 do
      begin
        x2:=x2+ii*ii;
        y2:=y2+y[ii]*y[ii];
        xy:=xy+ii*y[ii];
        s_x:=s_x+ii;
        s_y:=s_y+y[ii];
      end;

      //r:= yy[I]
      yy[I]:=abs((n*xy-s_x*s_y)/(Sqrt(n*x2-s_x*s_x)*Sqrt(n*y2-s_y*s_y)));
    end;

    //***********����������� y=ax2+bx+c
    PP:=0;
    QQ:=0;
    RR:=0;
    SS:=0;
    TT:=0;
    UU:=0;
    VV:=0;

 	  for ii:=0 to n2-1 do
    begin
	    PP:=PP+xx[ii];
	    QQ:=QQ+xx[ii]*xx[ii];
	    RR:=RR+xx[ii]*xx[ii]*xx[ii];
	    SS:=SS+xx[ii]*xx[ii]*xx[ii]*xx[ii];
	    TT:=TT+yy[ii];
	    UU:=UU+xx[ii]*yy[ii];
	    VV:=VV+xx[ii]*xx[ii]*yy[ii];
    end;

   
    DD:=n2*QQ*SS+2*PP*QQ*RR-QQ*QQ*QQ-PP*PP*SS-n2*RR*RR;
    aa:=(n2*QQ*VV+PP*RR*TT+PP*QQ*UU-QQ*QQ*TT-PP*PP*VV-n2*RR*UU)/DD;
    bb:=(n2*SS*UU+PP*QQ*VV+QQ*RR*TT-QQ*QQ*UU-PP*SS*TT-n2*RR*VV)/DD;
    cc:=(QQ*SS*TT+QQ*RR*UU+PP*RR*VV-QQ*QQ*VV-PP*SS*UU-RR*RR*TT)/DD;

    if -bb/(2*aa)<=0 then //�����ѵ�ָ��n<0 ȡn=0.0001  (0<n<1)
        e[2]:=0.0001
    else if -bb/(2*aa)>=1 then  //�����ѵ�ָ��n>1 ȡn=0.9999  (0<n<1)
        e[2]:=0.9999
    else
        e[2]:=-bb/(2*aa);
   //������˫���ݼ���n��ȡֵ ������e[2]

	 //********��ʼ����5��ݼ����ߵĸ�������  ************
	 r_sel:=0;
	 for I := 0 to 4 do
	 begin
	    if e[I]=0 then
	    begin
	      cdsDayReport.First;
	      for ii := 0 to n-1 do
	      begin
          y[ii]:= ln(cdsDayReport.FieldByName('TOTAL_OIL').AsFloat);
          cdsDayReport.Next;
	      end;
	    end
	    else
	    begin
	      cdsDayReport.First;
	      for ii := 0 to n-1 do
	      begin
          y[ii]:= Power(cdsDayReport.FieldByName('TOTAL_OIL').AsFloat,-e[I]);
          cdsDayReport.Next;
	      end;
	    end;


	    x2:=0;
	    y2:=0;
	    xy:=0;
	    s_x:=0;
	    s_y:=0;

	    for ii := 0 to n-1 do
	    begin
	      x2:=x2+ii*ii;
	      y2:=y2+y[ii]*y[ii];
	      xy:=xy+ii*y[ii];
	      s_x:=s_x+ii;
	      s_y:=s_y+y[ii];
	    end;

	    r:=abs((n*xy-s_x*s_y)/(Sqrt(n*x2-s_x*s_x)*Sqrt(n*y2-s_y*s_y)));

	    if I=2 then
	      RzStringGrid1.Cells[I+1,1]:=FormatFloat('0.0000',e[I])
	    else
	    begin
	      RzStringGrid1.Cells[1,1]:='1.0000';
	      RzStringGrid1.Cells[2,1]:='0.5000';
	      RzStringGrid1.Cells[4,1]:='0.0000';
	      RzStringGrid1.Cells[5,1]:='-1.0000';
	    end;
	    RzStringGrid1.Cells[I+1,4]:=FormatFloat('0.0000',r);
	    q[I+1,1]:= e[I];
	    q[I+1,4]:= r;

	    A:=(xy-(s_x/n)*s_y)/(x2-(s_x/n)*s_x);
	    B:=s_y/n-A*s_x/n;


	    if e[i]=1 then
	    begin
	      q0:=1/B;
	      di:=A/B;
	    end;

	    if e[i]=0 then
	    begin
	      q0:=exp(B);
	      di:=-A ;
	    end;

	    if (e[I]<>1) and (e[I]<>0) then
	    begin
	      q0:=Power(1/B,1/e[I]);
	      di:=A/(B*e[I]) ;
	    end;

      if (DayOilType.ItemIndex=1) and (DayOilNum.Value<>0) then  //�Զ���q0��ֵ
        q0:=DayOilNum.Value;

	    RzStringGrid1.Cells[I+1,2]:=FormatFloat('0.0000',q0);
	    RzStringGrid1.Cells[I+1,3]:=FormatFloat('0.0000',di);
	    q[I+1,2]:= q0;
	    q[I+1,3]:= di;

	    if (K<>-1) then
	    begin
	      if  K=I then
	      begin
          r_sel:=r;
          I_sel:=I;
          q0_sel:=q0;
          di_sel:=di;
          e_value:=e[I_sel];
	      end;
	    end
	    else
	    begin
	      if r_sel<r then
	      begin
          r_sel:=r;
          I_sel:=I;
          q0_sel:=q0;
          di_sel:=di;
          e_value:=e[I_sel];
	      end;
	    end;

	    //****�ݼ���ʽ��q=q0/Power((1+e(I)*di*x(ii)),1/e(I)),N=0ʱq=q0*ln((-di*x(i)) *******//
	 end;

    if DayOilType.ItemIndex=1 then
    begin
      if DayOilNum.Value=0 then
      begin
      showmessage('������궨�ղ�ֵ��');
      exit;
      end
      else
      q0_sel:=DayOilNum.Value;
    end;
    //*******��ʼ��ͼ*****************
    Graph.series[0].Title:= RzStringGrid1.Cells[I_sel+1,0];
    cdsDayReport.First;

    for i := 0 to cdsDayReport.RecordCount-1 do
    begin
    if e_value=0 then
    begin
      Aseries[0].addy(q0_sel*exp((-di_sel*i)),FloatToStr(i));
    end
    else
    begin
      Aseries[0].addy(q0_sel/Power((1+e_value*di_sel*i),1/e_value),FloatToStr(i));
    end;
      Aseries[2].addy(cdsDayReport.FieldByName('TOTAL_OIL').AsFloat,FloatToStr(i));
      cdsDayReport.Next;
    end;
    RzReport.Enabled:=True;

 Except
    RzReport.Enabled:=false;
    showmessage('������0ֵ������ֵ����ѡ�񲻰�����Щֵ��ʱ��Σ�');
 End;
  end;
end;



procedure TAO_DeclineRateAnalysis.FreeChartSeries(Chart: TChart);
var
  N1: Integer;
  Series: TChartSeries;
begin
  for N1:= Chart.SeriesList.Count-1 downto 0 do
  begin
    Series:= Chart.Series[N1];
    FreeAndNil(Series);
  end;
  Chart.RemoveAllSeries;
  Chart.SeriesList.Clear;
end;

procedure TAO_DeclineRateAnalysis.M1Click(Sender: TObject);
   var I:integer;
begin
      for I := 0 to RzTabControl1.Tabs.Count - 1 do
      begin
        if RzTabControl1.Tabs[I].Caption='��������' then
        begin
          RzTabControl1.Tabs.Delete(I);
          break;
        end;
      end;
      RzTabControl1.Tabs.Insert(1);
      RzTabControl1.Tabs[1].Caption:='��������';
      RzTabControl1.TabIndex:=1;
      Mstr:='M1';
      ShowGraph(CbxShape.ItemIndex);
end;

procedure TAO_DeclineRateAnalysis.M2Click(Sender: TObject);
    var I:integer;
begin
      for I := 0 to RzTabControl1.Tabs.Count - 1 do
      begin
        if RzTabControl1.Tabs[I].Caption='�ݼ�����' then
        begin
          RzTabControl1.Tabs.Delete(I);
          break;
        end;
      end;
      RzTabControl1.Tabs.Insert(1);
      RzTabControl1.Tabs[1].Caption:='�ݼ�����';
      RzTabControl1.TabIndex:=1;
      Mstr:='M2';
      ShowGraph(CbxShape.ItemIndex);
end;

procedure TAO_DeclineRateAnalysis.RzCloseClick(Sender: TObject);
begin
  pMainForm.CloseTabsheet(SelfKey);
end;

procedure TAO_DeclineRateAnalysis.RzStringGrid1Resize(Sender: TObject);
begin
  RzStringGrid1.DefaultColWidth:= RzStringGrid1.Width div 6;
end;

procedure TAO_DeclineRateAnalysis.RzStringGrid1SelectCell(Sender: TObject;
    ACol, ARow: Integer; var CanSelect: Boolean);
begin
  CanSelect:=true;
  K:=ACol-1;
  ShowGraph(CbxShape.ItemIndex);
end;

procedure TAO_DeclineRateAnalysis.RzTabControl1Change(Sender: TObject);
  var
  a:string;
begin
  a:=RzTabControl1.Tabs[RzTabControl1.TabIndex].Caption;
  if a='��������' then
    begin
      Mstr:='M1';
      RzReport.Enabled:=False;
      ShowGraph(CbxShape.ItemIndex);
    end
  else if a='�ݼ�����' then
    begin
      Mstr:='M2';
      ShowGraph(CbxShape.ItemIndex);
    end
  else
    begin
      dbgDayReport.Visible:=true;
      Panel1.Visible:=false;
    end;
end;

procedure TAO_DeclineRateAnalysis.SelectTypeChange(Sender: TObject);
begin
  ckMultiSelect.Enabled:=true;
  PopWellName.Text := '';
  PopArea.Text := '';
  PopLayer.Text := '';
  case SelectType.ItemIndex of
    0:
    begin
      PopWellName.Visible := True;
      PopArea.Visible := False;
      PopLayer.Visible := False;
      ckMultiSelect.Enabled:=True;
    end;
    1:
    begin
      PopWellName.Visible := False;
      PopArea.Visible := True;
      PopLayer.Visible := False;
      ckMultiSelect.Enabled:=True;
    end;
    2:
    begin
      PopWellName.Visible := False;
      PopArea.Visible := False;
      PopLayer.Visible := True;
      ckMultiSelect.Enabled:=True;
    end;
    3:
    begin
      PopWellName.Visible := False;
      PopArea.Visible := False;
      PopLayer.Visible := False;
      ckMultiSelect.Enabled:=false;
    end;
  end;
end;
procedure TAO_DeclineRateAnalysis.SelectTypeCloseUp(Sender: TObject);
var
 s: string;
begin

 {   if Trim(SelectType.text) = '��������ѯ' then
  begin
     tbl_DSS_E1_BAS002.Filtered := False;
     tbl_DSS_E1_BAS002.Filter := 'Type =''026''';
     tbl_DSS_E1_BAS002.Filtered := True;
     tbl_DSS_E1_BAS002.Active := true;
  end;
  if Trim(SelectType.text) = '���ز��ѯ' then
  begin
     tbl_DSS_E1_BAS002.Filtered := False;
     tbl_DSS_E1_BAS002.Filter := 'Type =''005''';
     tbl_DSS_E1_BAS002.Filtered := True;
     tbl_DSS_E1_BAS002.Active := true;
  end;
  if Trim(SelectType.text) = '���;���ѯ' then
  begin


  end;  }
end;

procedure TAO_DeclineRateAnalysis.SetcxGridTextDisplay(
  aDAMemDataTable: TDAMemDataTable; acxGrid: TcxGridDBTableView);
var
  I: Integer;
begin
  with aDAMemDataTable do
  begin
    for I := 0 to FieldCount - 1 do
    begin
      acxGrid.Columns[I].HeaderAlignmentHorz := taCenter;
      if Fields[I].DataType = datFloat then
      begin
        Fields[I].Alignment := taRightJustify;
      end
      else
      begin
        Fields[I].Alignment := taLeftJustify;
      end;
      if Fields[I].TableField = 'PROD_FLUID' then
      begin
        Fields[I].DisplayFormat := '0.000;-,0.000';
      end;
      if (Fields[I].TableField = 'PROD_OIL_T') or
        (Fields[I].TableField = 'PROD_OIL_M') or
        (Fields[I].TableField = 'PROD_WATER') then
      begin
        Fields[I].DisplayFormat := '0.000;-,0.000';
      end;
      if (Fields[I].TableField = 'WATER') or
        (Fields[I].TableField = 'TOTAL_WATER') or
        (Fields[I].TableField = 'MONTH_WATER') then
      begin
        Fields[I].DisplayFormat := '0.000;-,0.000';
      end;
    end;
  end;
end;


procedure TAO_DeclineRateAnalysis.cxPopupEditPropertiesCloseUp(
  Sender: TObject);
var
 I : Integer;
begin
  if SysPublicSelect_DeclineFrm.Flag then
  begin
    if SysPublicSelect_DeclineFrm.SelectRowValues[2] = '' then
    begin
      Exit;
    end;
   if ckMultiSelect.Checked = True then
   begin
     if Trim((Sender as TcxPopupEdit).Text) = '' then
      (Sender as TcxPopupEdit).Text :=  SysPublicSelect_DeclineFrm.SelectRowValues[2]
     else
     (Sender as TcxPopupEdit).Text := (Sender as TcxPopupEdit).Text+','+ SysPublicSelect_DeclineFrm.SelectRowValues[2] ;
   end
   else
    (Sender as TcxPopupEdit).Text :=  SysPublicSelect_DeclineFrm.SelectRowValues[2] ;
    SysPublicSelect_DeclineFrm.SelectRowValues[2] := '';
  end;
end;

procedure TAO_DeclineRateAnalysis.cxPopupEditPropertiesPopup(
  Sender: TObject);
var
  cxPopupEdit: TcxPopupEdit;
  I: Integer;
  SlaveDAMemDataTable: TDAMemDataTable;
begin
  cxPopupEdit := Sender as TcxPopupEdit;
  for I := 0 to CxPopupEditCount - 1 do
  begin

    if cxPopupEdit.Name = cxPopupEditsConfig[I][ControlName] then
    begin

      SlaveDAMemDataTable := AO_DeclineRateAnalysis.FindDAMemDataTable(cxPopupEditsConfig[I][SlaveTableName]);

      Break;
    end;
  end;

  cxPopupEdit.Properties.PopupSysPanelStyle := True;
  if SlaveDAMemDataTable <> nil then
  begin
    SlaveDAMemDataTable.Filtered := False;
    SlaveDAMemDataTable.Filter := cxPopupEditsConfig[I][FilterValue];
    SlaveDAMemDataTable.Filtered := True;
    with SysPublicSelect_DeclineFrm do
    begin
      DADataSource.DataTable := SlaveDAMemDataTable;
      FrmClassName := AO_DeclineRateAnalysis;
      InitGridView(cxPopupEditsConfig[I][SlaveLXName]);
    end;
  end;

end;

function TAO_DeclineRateAnalysis.FindDAMemDataTable(
  DAMemDataTableName: String): TDAMemDataTable;
var
  I: Integer;
  DAMemDataTable: TDAMemDataTable;
begin
  Result := nil;
  if tbl_DSS_E1_BAS003.Name = DAMemDataTableName then
  begin
    result := tbl_DSS_E1_BAS003;
  end;

  if tbl_DSS_E1_SYS01.Name = DAMemDataTableName then
  begin
    result := tbl_DSS_E1_SYS01;
  end;

  if tbl_DSS_E1_BAS002.Name = DAMemDataTableName then
  begin
    result := tbl_DSS_E1_BAS002;
  end;
end;


end.

