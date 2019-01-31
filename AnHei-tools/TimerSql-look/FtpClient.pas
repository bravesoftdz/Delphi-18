unit FtpClient;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdComponent, IdTCPConnection,XPMan,
  IdFTP, StdCtrls, ExtCtrls, ComCtrls, IdFTPCommon, IdGlobal,
  IdThreadComponent, IdHTTP ,IdHashMessageDigest, 
  commctrl,UnitStdXmlForm, shellapi,UFtpClient,
  Menus, ActnList, msxml, IdExplicitTLSClientServerBase, ImgList, IdTCPClient,
  IdBaseComponent, Buttons, RichEdit, IdGlobalProtocols, IdAntiFreezeBase,
  IdAntiFreeze, IniFiles,winsock, System.Actions;

const
    colorReadonly  = clBtnFace;
    colorModify    = clwindow;
    colorGeneral   = clWhite;   // ��ͨ��Ϣ ��ɫ
    colorSuccess   = clGreen;   // �ɹ���Ϣ ��ɫ
    colorWarning   = clYellow;  // ������Ϣ ��ɫ
    colorerror     = clRed;     // ������Ϣ ��ɫ�Ӵ�
    msgStart = '--------------%s �ͻ��˷�����־--------------';
    MessageClose = '��ȷʵҪ ֹͣʹ�ô˹�����';
    fLogname = '.\log\%Sftp�ͻ�����־.rtf';
    msgUploadFailed  = '%s [�ϴ��ļ�ʧ��] ����������%s, IP: %s';
    msgDecompressFailed  = '%s [��ѹ�ļ�ʧ��] ����������%s, IP: %s';
    msgSuccess = '%s' + #32 + '��ϲ��' + #32 + '�����з������ϴ���ѹ�Ĳ����ɹ����';
    msgInfo = '%s  ��������ϴ��ļ����� ʧ����Ϣ���£�';
    Parent_imageIndex = 8;
    Class_ImageIndex = 10;
    Ftp_ImageIndex =9;
    WM_BARICON = WM_USER + 111;
    wM_TransOK = WM_USER + 113;
    sFtpClientFile = 'http://xh.521g.com/miros/wwy/zj2/FtpServerList.xml';
    sLocalFtpClientFile = '.\FtpServerList.xml';
    sTransInfo = '��Ҫ�ϴ� %d ̨������ ;�Ѿ��ϴ� %d ̨.....';
    MesssageCaption = '�ɺ����� ��ܰ����';
    MesssageGetLink = '�������ļ���ַ:';
    sConfigName = '.\FtpClientConfig.ini';
    sDefUserName = 'servutest';
    sDefPassword = '123';
    sDefPort = 73;

 FtpClasssAttr = 'FtpClass';
   ClassIDAttr = 'ClassID';
   ClassNameAttr = 'ClassName';

 FtpServerAttr = 'Server';
  ServerIdAttr = 'ID';
  ServerNameAttr = 'Name';
  ServerIPAttr = 'IP';
  ServerPortAttr = 'Port';
  ServerUserNameAttr = 'UserName';
  ServerPasswordAttr = 'Password';
  ServerPassive = 'Passive';
  ServerNoteAttr = 'Note';

type
  TFtpclientThread = class(TThread)
  private
  protected
//    FftpclientTd :TFtpClientMy;
    FinfoDOME:IXMLDOMElement;
    FfileName :string;
    FtpCS: TRTLCriticalSection;
    procedure Execute;override;
    procedure putfile;
  public
    constructor Create(infoNode: IXMLDOMElement; locFilename:string);
    destructor Destroy; override;
  published
  end;


type
  TFtpClientForm = class(TStdXmlForm)
    btn2: TButton;
    dlgSave1: TSaveDialog;
    idthrdcmpnt1: TIdThreadComponent;
    pb1: TProgressBar;
    lv1: TListView;
    btn9: TButton;
    actlst1: TActionList;
    pm1: TPopupMenu;
    il1: TImageList;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    tv1: TTreeView;
    actNewFtp: TAction;
    lbledtPort: TLabeledEdit;
    lbledtUserName: TLabeledEdit;
    lbledtPassword: TLabeledEdit;
    lbledtPath: TLabeledEdit;
    btnConnectButton: TButton;
    lbledtIP: TLabeledEdit;
    chkNoAnonymous: TCheckBox;
    lbledtEDCurDir: TLabeledEdit;
    FTP1: TIdFTP;
    N1: TMenuItem;
    actload: TAction;
    actsave: TAction;
    N2: TMenuItem;
    N3: TMenuItem;
    pnl3: TPanel;
    pnl1: TPanel;
    btn6: TButton;
    actSelectAll: TAction;
    actNoSelect: TAction;
    actGetChecked: TAction;
    btn1: TButton;
    btnDel: TButton;
    btn4: TButton;
    btn7: TButton;
    btn3: TButton;
    btn8: TBitBtn;
    spl1: TSplitter;
    actNewCLass: TAction;
    N5: TMenuItem;
    actDelnode: TAction;
    actDelnode1: TMenuItem;
    lstDebugListBox: TListBox;
    RichEdit1: TRichEdit;
    pnl4: TPanel;
    pnl2: TPanel;
    lbl1: TLabel;
    edt1: TEdit;
    chk1: TCheckBox;
    pnl5: TPanel;
    lbledtPort1: TLabeledEdit;
    lbledtUser: TLabeledEdit;
    lbledtPW: TLabeledEdit;
    lbledtFtpIp: TLabeledEdit;
    lbledtftpname: TLabeledEdit;
    mmo1: TMemo;
    lbl2: TLabel;
    btn5: TSpeedButton;
    btnsave: TSpeedButton;
    btn11: TSpeedButton;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    actConfig: TAction;
    URL1: TMenuItem;
    chkPassive: TCheckBox;
    OpenDialogOpen1: TOpenDialog;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure FTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure FTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure FTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure FormCreate(Sender: TObject);
    procedure FTP1Work(Sender: TObject; AWorkMode: TWorkMode;
       AWorkCount: Integer);

    procedure btn9Click(Sender: TObject);
    // ���ļ��Ϸ��������к�ϵͳ�����巢��WM_DRAPFILES�¼���
    // ������ǿ�����WMDROPFILES�����л�ȡ�ļ��������ļ�����
    procedure WMDROPFILES(var Msg: TMessage);message WM_DROPFILES;
    procedure actNewFtpExecute(Sender: TObject);
    procedure chkNoAnonymousClick(Sender: TObject);
    procedure actloadExecute(Sender: TObject);
    procedure LoadConfig;
    procedure actsaveExecute(Sender: TObject);
    procedure tv1Change(Sender: TObject; Node: TTreeNode);
    procedure test();
    procedure actSelectAllExecute(Sender: TObject);
    procedure actNoSelectExecute(Sender: TObject);
    procedure tv1Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure actNewCLassExecute(Sender: TObject);
    function  GetDOMNode(TreeNode: TTreeNode): IXMLDOMNode;
    procedure tv1Editing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure tv1Edited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure tv1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tv1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure actDelnodeExecute(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
    procedure lbledtftpnameChange(Sender: TObject);
    procedure edt1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnsaveClick(Sender: TObject);
    procedure saveRft;
    procedure tv1Changing(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure actConfigExecute(Sender: TObject);
    procedure SaveConfig;

  private
    BnotModify: Boolean; // ��֧���޸�ģʽ �����ڵ������ļ�����������
    ftpListUrl: string;
    FFtpclient: TFtpClientMy;
    selNodeList : TList; // ����Ѿ�ѡ�еķ������ڵ�
    FBaseTreeNode: TTreeNode;
    CurrentElement: IXMLDOMElement; //��ǰ�ڱ༭�Ľڵ�
    procedure MyFtpGet(srcname, Targetname: string; Bresume: boolean=False);
    procedure MyFtpPut(srcname, Targetname: string; Bresume: boolean=False);
    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
    procedure WMBarIcon(var Message:TMessage);message WM_BARICON;
    procedure WMTransOK(var message:TMessage);message WM_TransOK;
    public
    { Public declarations }
    function MyConnect(TragetIdFTP: TIdFTP;Bconnect :Boolean=True):boolean;overload;
    function MyConnect(Node:TTreeNode; TragetIdFTP: TIdFTP;Bconnect :Boolean=True):boolean;overload;
    function MyTestConnect(TragetIdFTP: TIdFTP; Btest:Boolean=True):boolean;
    // ���¼���FTpĿ¼
    procedure MyFtpChangeDir(Dir: string);
    function  GetDOMElementByObjectID(const nID: Integer): IXMLDOMElement;
    procedure SelectNode(ANode: TTreeNode);
    function  ReadXMLData():Boolean;override;
    procedure SaveNoad(ANode: TTreeNode);
    procedure ReadNode(Element: IXMLDOMElement; TreeNode: TTreeNode);
    procedure setEnabled(Benable :boolean);
    //��ȡ��ѡ�ķ������б�
    function getCheckedNode():Integer;
    procedure FTPclentNotifyEvent(ADatetime: TDateTime;AUserIP, AEventMessage: string);
    function  GetFtpServerList(ftpUrl: string):boolean;
  end;
var
  FtpClientForm: TFtpClientForm;
  babortTrans : Boolean;
  FtpFileList : TStrings;
  ResultList : tstrings;
  BHadTrans: Int64;
  TransCount: Integer;
  Templist: TStringList;      // ��������ļ� ���iDֵ�᲻�����ظ���

//   sDefUserName, sDefPassword :string;
//   sDefPort :integer;

implementation
{$R *.dfm}

procedure   SetRDColorByAddText(RichEdit:TRichEdit;TargetStr:string);
var
  i, c, backStart, tempi:   integer;
  Fmt   :TCharFormat2;
begin
  if trim(RichEdit.Text)=''  then
  begin
   RichEdit.Lines.Add(format(msgStart,[DateTimeToStr(now)]));
//   showmessage(' ����� ');
  end;
  tempi :=  length(RichEdit.Text);
  richedit.Lines.Add(TargetStr);
  RichEdit.SelStart   :=   tempi;   //Ѱ��ѡ����������λ��
  RichEdit.SelLength   :=  length(TargetStr);   //���ѡ��ǰ�еĳ���
  Fmt.cbSize   :=   SizeOf(Fmt);//����Ŵ��ݵĽṹ��С��ϵͳͨ�����֪�����ݵ���CharFormat����CharFormat2
  Fmt.dwMask   :=   CFM_COLOR or CFM_BACKCOLOR;  // ����ϵͳֻ��������ɫ�ͱ�����ɫ�����ֶε�ֵ��Ч

  if Pos('�ɹ�',TargetStr)>0 then
   Fmt.crTextColor   :=   colorSuccess//����������ɫ
  else if Pos('ʧ��',TargetStr)>0 then
   Fmt.crTextColor   :=   colorerror//����������ɫ
  else
   Fmt.crTextColor   :=   colorWarning;//����������ɫ
   Fmt.crBackColor   :=   0;//�������屳��ɫ

  RichEdit.Perform(EM_SETCHARFORMAT,SCF_SELECTION,integer(@Fmt));//��EM_SETCHARFORMAT��Ϣ��RichEdit����ʾֻ��ѡ�񲿷ּӱ�����ɫ
  SendMessage(RichEdit.Handle,WM_VSCROLL,SB_PAGEDOWN,0);
  RichEdit.SelLength   :=   0;

end;


function TFtpClientForm.GetFtpServerList(ftpUrl: string):boolean;
var
  MyStream:TMemoryStream;
begin
  Result := false;
  IdAntiFreeze1.OnlyWhenIdle:=False;//����ʹ�����з�Ӧ.
  MyStream:=TMemoryStream.Create;
  try
    //������վ���һ��ZIP�ļ�
    IdHTTP1.Get(ftpUrl,MyStream);
  except//INDY�ؼ�һ��Ҫʹ������try..except�ṹ.
    MessageBox(0,'�����õ��ļ����󣬻������粻ͨ',MesssageCaption,mb_ok + MB_TASKMODAL +  MB_ICONERROR);
    MyStream.Free;
    Exit;
  end;
  MyStream.SaveToFile(sLocalFtpClientFile);
  MyStream.Free;
  Result := True;
end;



function TFtpClientForm.MyConnect(TragetIdFTP: TIdFTP;Bconnect :Boolean): boolean;
begin
 Result := False;
 if Bconnect then
 begin
   with TragetIdFTP do
   begin
     if Connected then
     begin
       FTP1.Abort;
       FTP1.Disconnect;
     end;
     if not Connected then
     begin
       try
          Username:=lbledtUserName.Text;
          Password:=lbledtPassword.Text;
          Host:=lbledtIP.Text;
          Port:= StrToInt(lbledtPort.Text);
          TransferType := ftASCII;
          Connect;
          Result := true;
          MessageBox(0,'���������ӳɹ�,����ͨ��',MesssageCaption,mb_ok + MB_TASKMODAL +  MB_ICONINFORMATION);

       except
          Abort;
          MessageBox(0,'����������ʧ��,�������',MesssageCaption,mb_ok + MB_TASKMODAL +  MB_ICONWARNING);
          Result := false;
       end;
     end
     else
          MessageBox(0,'�������Ѿ�����',MesssageCaption,mb_ok + MB_TASKMODAL + MB_ICONINFORMATION);
   end;
 end
end;




procedure TFtpClientForm.chkNoAnonymousClick(Sender: TObject);
begin
 if chkNoAnonymous.Checked then
 begin
  lbledtUserName.Text := '521g';
  lbledtPassword.Text := '521g';
  lbledtPort.Text := '37';
 end
 else
 begin
  lbledtUserName.Text := 'servutest';
  lbledtPassword.Text := '123';
  lbledtPort.Text := '73';
 end;
end;

procedure TFtpClientForm.edt1Change(Sender: TObject);
begin
 btn11.Enabled := FileExists(Trim(edt1.Text));
end;

function GetNameFromDirLine(Line: String;  var IsDirectory: Boolean): String;
Var
//���ַ�����ȡ���ļ���
  i: Integer; 
  DosListing: Boolean; 
begin 
  IsDirectory := Line[1] = 'd'; 
  DosListing := false; 
  for i := 0 to 7 do begin 
  if (i = 2) and not IsDirectory then begin 
  IsDirectory := Copy(Line, 1, Pos(' ', Line) - 1) = '<DIR>'; 
  if not IsDirectory then 
  DosListing := Line[1] in ['0'..'9'] 
  else DosListing := true;
  end; 
  Delete(Line, 1, Pos(' ', Line)); 
  While Line[1] = ' ' do Delete(Line, 1, 1); 
  if DosListing and (i = 2) then break; 
  end; 
  Result := Line; 
end;

//���غ���
procedure TFtpClientForm.MyFtpGet(srcname,Targetname:string; Bresume:boolean);
var
  TempFs: TFileStream;
begin
  MyConnect(FTP1);
  if FileExists(Targetname) then
   TempFs := TFileStream.Create(Targetname, 1)
  else
   TempFs := TFileStream.Create(Targetname, 65535);
  try
//    ShowMessage(srcname + '�ļ���С' +IntToStr(FTP1.Size(srcname)));
    pb1.Max := FTP1.Size(FTP1.RetrieveCurrentDir + srcname) ;
    BHadTrans := 0;
    if Bresume then
    begin
      TempFs.Position := TempFs.Size;
      BHadTrans := TempFs.Size;
      FTP1.TransferType := ftBinary;
      FTP1.Get(srcname,TempFs,True);
    end else
      FTP1.get(srcname,TempFs,False);
  finally
    TempFs.Free;
  end;
end;

procedure TFtpClientForm.SaveConfig;
var
  Section: string;
  Ident: string;
begin
  with TIniFile.Create(sConfigName) do
  begin
    Section := 'FTP����';
    Ident := 'Զ�̵�ַ';
    if not ValueExists(Section,Ident) then
     WriteString(Section,Ident,sFtpClientFile)
    else
     WriteString(Section,Ident,ftpListUrl);
    Free;
  end;
end;


procedure TFtpClientForm.actConfigExecute(Sender: TObject);
begin
  ftpListUrl := InputBox(MesssageCaption,MesssageGetLink,ftpListUrl);
  SaveConfig;
end;

procedure TFtpClientForm.actDelnodeExecute(Sender: TObject);
var
  Node: IXMLDOMNode;
begin
  if tv1.Selected.ImageIndex = Parent_imageIndex  then exit;
  if (tv1.Selected <> nil) then
  if Application.MessageBox( 'ȷʵҪɾ��ѡ������Ŀ��?', MesssageCaption, MB_YESNOCANCEL or MB_ICONQUESTION or MB_TASKMODAL) = ID_YES then
  begin
    Node := GetDOMNode( tv1.Selected );
    if Node <> nil then
    begin
      Node.parentNode.removeChild( Node );
      tv1.Selected.Delete();
      actsaveExecute(nil);
    end;
  end;
end;


procedure TFtpClientForm.LoadConfig;
var
  Section: string;
  Ident: string;
  x : TIniFile;
begin

  with TIniFile.Create(sConfigName) do
  begin
    Section := 'FTP����';
    Ident := 'Զ�̵�ַ';
    if not ValueExists(Section,Ident) then  WriteString(Section,Ident,sFtpClientFile);
    ftpListUrl := ReadString(Section,Ident,sFtpClientFile);
    Free;
  end;
end;



procedure TFtpClientForm.actloadExecute(Sender: TObject);
begin
  LoadConfig;
  if GetFtpServerList(ftpListUrl) then
  begin
    tv1.Items[0].DeleteChildren;
    Open(sLocalFtpClientFile);
  end;


end;

procedure TFtpClientForm.actNewCLassExecute(Sender: TObject);
const
  sDefServerName = '�½�����';
var
  Element: IXMLDOMElement;
  TreeNode: TTreeNode;
  nId: Integer;
begin
  nId := AllocAutoIncrementId();
  Element := FXML.createElement(FtpClasssAttr);
  //����Ĭ��ֵ
  Element.setAttribute(ClassIDAttr, nId);
  Element.setAttribute(ClassNameAttr, sDefServerName);
  (FBaseNode as IXMLDOMElement).appendChild(Element);

  TreeNode := FBaseTreeNode;
  TreeNode := tv1.Items.AddChild(TreeNode, sDefServerName);
  TreeNode.Data := Pointer(nId);
  TreeNode.ImageIndex := Class_ImageIndex;
  TreeNode.SelectedIndex := Class_ImageIndex;
  tv1.Selected := TreeNode;
//  Save();
  actsaveExecute(nil);
  TreeNode.EditText();


end;

function TFtpClientForm.GetDOMNode(TreeNode: TTreeNode): IXMLDOMNode;
var
  sQueryStr: string;
  nId: Integer;
begin
  Result := nil;

  if TreeNode<>nil then
  begin
     sQueryStr := '';
    while TreeNode <> nil do
    begin
        nId := Integer(TreeNode.Data);
        case TreeNode.ImageIndex of
          Ftp_ImageIndex:begin       //�������ּ����  xml�Ľṹ ����....
            sQueryStr := FtpServerAttr
              + '[@' + ServerIdAttr + '=''' + IntToStr(nId) + ''']'
              + '/' + sQueryStr;
          end;
          Class_ImageIndex:
          begin
            sQueryStr := FtpClasssAttr
              + '[@' + ClassIDAttr + '=''' + IntToStr(nId) + ''']'
              + '/' + sQueryStr;
          end;
          else break;
        end;
        TreeNode := TreeNode.Parent;
    end;
  end;

  Result := FBaseNode;
  if (Result <> nil) and (sQueryStr <> '') then
  begin
    Delete( sQueryStr, Length(sQueryStr), 1 );
    Result := Result.selectSingleNode( sQueryStr );
  end;
end;


procedure TFtpClientForm.lbledtftpnameChange(Sender: TObject);
begin
 if BnotModify then
  Exit
 else
  btnsave.Enabled := True;
end;

procedure TFtpClientForm.actNewFtpExecute(Sender: TObject);
const
  sDefServerName = '�½�������';
var
  Element: IXMLDOMElement;
  DOMNode: IXMLDOMNode;
  TreeNode: TTreeNode;
  nId: Integer;
begin
  // ��ѡ���˷��� ��ʱ��������½�������
  if tv1.Selected.ImageIndex <> Class_ImageIndex then   Exit;
    DOMNode := GetDOMNode( tv1.Selected );
  if DOMNode = nil then
    Exit;



   nId := AllocAutoIncrementId();
  Element := FXML.createElement(FtpServerAttr);
  //����Ĭ��ֵ
  Element.setAttribute(ServerIdAttr, nId);
//  Element.setAttribute(ServerNameAttr, sDefServerName+ IntToStr(nId));
//  Element.setAttribute(ServerIPAttr, '');
//  Element.setAttribute(ServerPortAttr, 37);
//  Element.setAttribute(ServerUserNameAttr, sDefUserName);
//  Element.setAttribute(ServerPasswordAttr, sDefPassword);
//  Element.setAttribute(ServerNoteAttr, TimeToStr(Now()) + '�½�������' + IntToStr(nId));
  Element.setAttribute(ServerNameAttr, '');
  Element.setAttribute(ServerIPAttr, '');
  Element.setAttribute(ServerPortAttr, '');
  Element.setAttribute(ServerUserNameAttr, '');
  Element.setAttribute(ServerPasswordAttr, '');
  Element.setAttribute(ServerNoteAttr, '');
  Element.setAttribute(ServerPassive, true);




  DOMNode.appendChild(Element);

  TreeNode := tv1.Selected;

  TreeNode := tv1.Items.AddChild(TreeNode, '');
  TreeNode.Data := Pointer(nId);
  TreeNode.ImageIndex := Ftp_ImageIndex;
  TreeNode.SelectedIndex := Ftp_ImageIndex;
  tv1.Selected := TreeNode;
  TreeNode.Parent.Expanded := true;
//  Save();
//  actSave.Enabled := True;
  actsaveExecute(nil);
  TreeNode.EditText();
end;

// ȫѡ tv1�ϵ����нڵ�  Bcheck= true Ϊѡ�У����� ȥ����ѡ
//procedure setTVSelected(tv1: TTreeNode; Bcheck: Boolean);
procedure setTVSelected(tv1: TTreeView; Bcheck: Boolean);
var
  Node: TTreeNode;
  TVI: TTVItem;
begin

  for Node in tv1.Items do

  begin
    TVI.mask := TVIF_STATE;
    TVI.hItem := Node.ItemId;
    TVI.stateMask := TVIS_STATEIMAGEMASK;
    if Bcheck then TVI.state := $2000 else TVI.state := $2000 shr 1;
    TreeView_SetItem(tv1.Handle, TVI);
  end;
end;

// ȫѡ TTreeNode�����е��ӽ��  Bcheck= true Ϊѡ�У����� ȥ����ѡ
procedure setTNSelected(tv1: TTreeNode; Bcheck: Boolean);
var
  Node: TTreeNode;
  TVI: TTVItem;
  tempNode, parNode : TTreeNode;
begin
 if tv1.HasChildren then
 begin
  tempNode := tv1.getFirstChild;
  while tempNode <> nil  do
  begin
    TVI.mask := TVIF_STATE;
    TVI.hItem := tempNode.ItemId;
    TVI.stateMask := TVIS_STATEIMAGEMASK;
    if Bcheck then TVI.state := $2000 else TVI.state := $2000 shr 1;
    TreeView_SetItem(tv1.Handle, TVI);
    tempNode:= tempNode.getNextSibling;
  end;
 end;
end;




procedure TFtpClientForm.actNoSelectExecute(Sender: TObject);
begin
   setTVSelected(tv1,False)
end;

procedure TFtpClientForm.actsaveExecute(Sender: TObject);
begin

  inherited SaveDocument;
    btnsave.Enabled := False;

end;


procedure TFtpClientForm.actSelectAllExecute(Sender: TObject);
begin
 setTVSelected(tv1,True)
end;





// ���� tv1Ϊ ��ѡģʽ
procedure setCheckStyle(tv1:TTreeView);
var
  H: HWND;
begin
//  if tv1.Items.Count > 1 then
//  begin
    tv1.Items[0].Expanded := True;
    // ���ø�ѡģʽ
    H := tv1.Handle;
    SetWindowLong(H, GWL_STYLE, GetWindowLong(H, GWL_STYLE) or TVS_CHECKBOXES);
//  end;
end;


function TFtpClientForm.ReadXMLData: Boolean;
var
  I,nId: Integer;
  H: HWND;
  Nodes: IXMLDOMNodeList;
  Element: IXMLDOMElement;
begin
  Result := Inherited ReadXMLData;
  Templist.Clear;
  ReadNode(FBaseNode as IXMLDOMElement,tv1.Items[0]);
  setCheckStyle(tv1);
end;


procedure TFtpClientForm.ReadNode(Element: IXMLDOMElement; TreeNode: TTreeNode);
var
  NodeList: IXMLDOMNodeList;
  I, nId: Integer;        
  ChildElement: IXMLDOMElement;
  NewTreeNode: TTreeNode;
begin
  TreeNode.DeleteChildren;
  NodeList := Element.selectNodes( FtpClasssAttr );
  for I := 0 to NodeList.length - 1 do
  begin
    ChildElement := NodeList.item[I] as IXMLDOMElement;
    NewTreeNode := tv1.Items.AddChild( TreeNode, ChildElement.getAttribute( ClassNameAttr ));
    nId := ChildElement.getAttribute( ClassIDAttr );
    NewTreeNode.Data := Pointer(nId);
    NewTreeNode.ImageIndex := CLASS_IMAGEINDEX;
    NewTreeNode.SelectedIndex := CLASS_IMAGEINDEX;
    ReadNode( ChildElement, NewTreeNode );
  end;

  NodeList := Element.selectNodes( FtpServerAttr );
  for I := 0 to NodeList.length - 1 do
  begin
    ChildElement := NodeList.item[I] as IXMLDOMElement;
    nId  := ChildElement.getAttribute( ServerIdAttr );
    if Templist.IndexOf(IntToStr(nid)) = -1 then
     Templist.Add(IntToStr(nid))
    else
     SetRDColorByAddText(RichEdit1, DateTimeToStr(Now) + #32 + '�����⵽������ID�ظ� ֵΪ��' + #32 + IntToStr(nid));

    NewTreeNode := tv1.Items.AddChild( TreeNode, ChildElement.getAttribute( ServerNameAttr ));
    nId := ChildElement.getAttribute( ServerIdAttr );
    NewTreeNode.Data := Pointer(nId);
    NewTreeNode.ImageIndex := Ftp_ImageIndex;
    NewTreeNode.SelectedIndex := Ftp_ImageIndex;
  end;


end;



// ��ʾ������
procedure showResult();
begin
  
end;



procedure TFtpClientForm.WMTransOK(var message: TMessage);
begin
// ShowMessage(IntToStr(message.LParam));
end;



procedure TFtpClientForm.btn11Click(Sender: TObject);
var
  FileName, Strlist : string;
  Item : TListItem;
  SendFileItem  : TListItem;
  Isize : integer;
  i : integer;
  sNoPassServer : tstrings; //����ͨ�����ӵķ�����
  TempCurrentElement: IXMLDOMElement;
begin
  if not (FileExists(edt1.Text) and SameText(ExtractFileExt(edt1.Text), '.rar')) then
  begin
   MessageBox(0,'��ѡ����ļ����Ϸ�, ������ѡ��Ĳ���Rar�ļ�',MesssageCaption,mb_ok + MB_TASKMODAL + MB_ICONERROR);
   exit;
  end;


  if getCheckedNode < 1  then
  begin
     MessageBox(0,'�빴ѡ��Ҫ�ϴ��ķ�����������',MesssageCaption,mb_ok + MB_TASKMODAL + MB_ICONWARNING);
     Exit;
  end;

  sNoPassServer := TStringList.Create;
  try
    sNoPassServer.Add(DateTimeToStr(Now) + '   ����������ѡ�ķ����� ���Խ�����£�');
    // ������������ѡ�ķ�����
    for i := 0 to selNodeList.Count - 1 do
    begin
       if not  MyConnect(TTreeNode(selNodeList[i]), FTP1, True) then
       begin
         sNoPassServer.Add(DateTimeToStr(Now) + '     �������� ��' + TTreeNode(selNodeList[i]).Text +'��ʧ��');
         Continue;
       end;
    end;
    if sNoPassServer.Count > 1 then
    begin

      RichEdit1.Lines.BeginUpdate;
      RichEdit1.Lines.AddStrings(sNoPassServer);
      RichEdit1.Lines.EndUpdate;
      Exit;
    end;
  finally
    sNoPassServer.Free;
  end;

   for i := 0 to selNodeList.Count - 1 do
    Strlist := Strlist + '��' + TTreeNode(selNodeList[i]).Text + ' ��' +#13#10;



  if MessageBox(0,PChar(Strlist + 'ȷ��Ҫ�����ϵķ������ϴ��ļ���'),MesssageCaption,MB_OKCANCEL + MB_TASKMODAL + MB_ICONQUESTION) <> IDOK then
  exit;


  if chk1.Checked then  // ���߳��ϴ�
  begin
    pb1.Max := IdGlobalProtocols.FileSizeByName(edt1.text) * selNodeList.Count;
//    ShowMessage(IntToStr(pb1.Max));
    pb1.Position := 0;
    btn11.Enabled := False;
    TransCount := selNodeList.Count;
    ResultList.Clear;
    ResultList.Add(Format(msgInfo, [DateTimeToStr(now)]));
    for i := 0 to selNodeList.Count - 1 do
    begin
     try
      TempCurrentElement := GetDOMElementByObjectID(Integer(TTreeNode(selNodeList[i]).Data));
      TFtpclientThread.create(TempCurrentElement, Trim(edt1.text));
     except
      on  e:Exception do
       ShowMessage(e.Message);
     end;
    end;
  end
  else  // �Ƕ��߳��ϴ�
  begin
    for i := 0 to selNodeList.Count - 1 do
    begin
       if not  MyConnect(TTreeNode(selNodeList[i]), FTP1, True) then
       begin
         Continue;
       end;
      try
        if not FileExists(edt1.Text) then
        begin
           dlgOpen1.Execute;
           edt1.Text :=  dlgOpen1.FileName;
        end;
        if True  then
        begin
          Isize := FTP1.Size(ExtractFileName(edt1.Text));
          if Isize = -1 then
           MyFtpPut(edt1.Text, AnsiToUtf8(ExtractFileName(edt1.Text)))
          else
           MyFtpPut(edt1.Text, AnsiToUtf8(ExtractFileName(edt1.Text)),True);
        end;
        lbl1.Caption := Format(sTransInfo,[selNodeList.Count,i+1]);
      except
        on E:Exception do
        begin
          ShowMessage(E.Message);
        end;
      end;
    end;
  end;

end;


function TFtpClientForm.GetDOMElementByObjectID(const nID: Integer): IXMLDOMElement;
ResourceString
  sQueryStr = '//*[@'+ServerIdAttr+'=%d]';
begin
  if nID = 0 then
    Result := FBaseNode as IXMLDOMElement
  else
    Result := FBaseNode.selectSingleNode( Format(sQueryStr, [nID]) ) as IXMLDOMElement;

end;


procedure TFtpClientForm.SelectNode(ANode: TTreeNode);
begin
  if ANode.ImageIndex <> Ftp_ImageIndex then
  begin
   setEnabled(False);
   Exit;
  end;
  
   setEnabled(True);
  if ANode <> nil then
  begin
   try
    CurrentElement := GetDOMElementByObjectID(Integer(ANode.Data))
   except
    Exit;
   end;
  end
  else
  begin
     CurrentElement := nil;
     exit;
  end;
  lbledtftpname.Text := CurrentElement.getAttribute(ServerNameAttr);
  lbledtUser.Text := CurrentElement.getAttribute(ServerUserNameAttr);
  lbledtPW.Text := CurrentElement.getAttribute(ServerPasswordAttr);
  lbledtPort1.Text := CurrentElement.getAttribute(ServerPortAttr);
  lbledtFtpIp.Text := CurrentElement.getAttribute(ServerIPAttr);
  mmo1.Text := CurrentElement.getAttribute(ServerNoteAttr);
  chkPassive.Checked := CurrentElement.getAttribute(ServerPassive);
  btnsave.Enabled := False;
end;


procedure TFtpClientForm.SaveNoad(ANode: TTreeNode);
begin

  if Assigned(ANode) then
  begin
    if ANode.ImageIndex <> Ftp_ImageIndex then Exit;
    CurrentElement.setAttribute(ServerNameAttr, lbledtftpname.Text);
    CurrentElement.setAttribute(ServerUserNameAttr, lbledtUser.Text);
    CurrentElement.setAttribute(ServerPasswordAttr, lbledtPW.Text);
    CurrentElement.setAttribute(ServerPortAttr, lbledtPort1.Text);
    CurrentElement.setAttribute(ServerPassive, chkPassive.Checked);
    CurrentElement.setAttribute(ServerIPAttr, lbledtFtpIp.Text);
    CurrentElement.setAttribute(ServerNoteAttr, mmo1.Text);

    ANode.Text := lbledtftpname.Text;
  end;
end;





procedure TFtpClientForm.tv1Change(Sender: TObject; Node: TTreeNode);
begin
  if Node.IsFirstNode then Exit;
   SelectNode(tv1.Selected);


end;


procedure TFtpClientForm.tv1Changing(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
 if btnsave.Enabled  then btnsave.Click;
end;

function GetChecked(mTreeNode: TTreeNode): Boolean;
var
  vTVItem: TTVItem;
begin
  Result := false;
  if not Assigned(mTreeNode) or not Assigned(mTreeNode.TreeView) then
    Exit;
  vTVItem.mask := TVIF_STATE;
  vTVItem.hItem := mTreeNode.ItemId;
  if TreeView_GetItem(mTreeNode.TreeView.Handle, vTVItem) then
    Result := (vTVItem.State and IndexToStateImageMask(2)) > 0;
  // 0:  None  1:  False  2:  True
end;

procedure TFtpClientForm.setEnabled(Benable :boolean);
begin

  if not Benable then
  begin
    lbledtftpname.Text := '';
    lbledtUser.Text := '';
    lbledtPW.Text := '';
    lbledtPort1.Text := '';
    lbledtFtpIp.Text := '';
    mmo1.Text := '';
    chkPassive.Checked := true;
  end ;
  if BnotModify then
  begin
    lbledtftpname.Enabled := not BnotModify;
    lbledtUser.Enabled := not BnotModify;
    lbledtPW.Enabled := not BnotModify;
    lbledtPort1.Enabled := not BnotModify;
    lbledtFtpIp.Enabled := not BnotModify;
    mmo1.Enabled := not BnotModify;
    chkPassive.Enabled := not BnotModify;
//    lbledtftpname.Color := colorReadonly;
//    lbledtUser.Color := colorReadonly;
//    lbledtPW.Color := colorReadonly;
//    lbledtPort1.Color := colorReadonly;
//    lbledtFtpIp.Color := colorReadonly;
//    mmo1.Color := colorReadonly;
    btnsave.Enabled := not BnotModify
  end
  else
  begin
    lbledtftpname.Enabled := Benable;
    lbledtUser.Enabled := Benable;
    lbledtPW.Enabled := Benable;
    lbledtPort1.Enabled := Benable;
    lbledtFtpIp.Enabled := Benable;
    mmo1.Enabled := Benable;
    chkPassive.Enabled := Benable;
//    lbledtftpname.Color := colorModify;
//    lbledtUser.Color := colorModify;
//    lbledtPW.Color := colorModify;
//    lbledtPort1.Color := colorModify;
//    lbledtFtpIp.Color := colorModify;
//    mmo1.Color := colorModify;

    btnsave.Enabled := Benable;
  end;


  btn5.Enabled := Benable;

end;


procedure TFtpClientForm.tv1Click(Sender: TObject);
var
  Node: TTreeNode;
  TVI: TTVItem;
  p : TPoint;
begin
  if (tv1.Selected <> nil) and (btnsave.enabled)  then
  begin
    btnsaveClick(nil);
  end;
  
  GetCursorPos(p);
  P := tv1.ScreenToClient(p);
  Node := tv1.GetNodeAt(p.x, p.Y);
  if Node <> nil then
  begin
    if Node.IsFirstNode then
      if GetChecked(Node) then
        setTVSelected(tv1, True)
      else
        setTVSelected(tv1, False)
    else  if Node.HasChildren then
      if GetChecked(Node) then
        setTNSelected(Node, True)
      else
        setTNSelected(Node, False);
     if not Node.IsFirstNode then   SelectNode(tv1.Selected);

  end else
  begin
    setEnabled(False);
  end;
end;


procedure TFtpClientForm.tv1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  TargetTreeNode: TTreeNode;
  SourceDOMNode, TargetDOMNode: IXMLDOMNode;
  NewNodeList : IXMLDOMNodeList;
  I: Integer;
  boCopy: Boolean;
  SelectTreeList: TStrings;
begin
  TargetTreeNode := tv1.GetNodeAt( X, Y );
  if TargetTreeNode = nil then
    Exit;
  TargetDOMNode := GetDOMNode( TargetTreeNode );
  if TargetDOMNode <> nil then
  begin
    if Source = tv1 then
    begin
      SourceDOMNode := GetDOMNode( tv1.Selected );
      if SourceDOMNode = nil then
        Exit;
        SelectTreeList := TStringList.Create;
        for I:=0 to tv1.SelectionCount-1 do
        begin
          SelectTreeList.AddObject('',tv1.Selections[I]);
        end;
        for I:=0 to SelectTreeList.Count-1 do
        begin
          SourceDOMNode := GetDOMNode( TTreeNode(SelectTreeList.Objects[I]) );
          SourceDOMNode.parentNode.removeChild( SourceDOMNode );
          TargetDOMNode.appendChild( SourceDOMNode );
          TTreeNode(SelectTreeList.Objects[I]).MoveTo( TargetTreeNode, naAddChild );
        end;
        SelectTreeList.Free;
        actsaveExecute(nil);
    end
  end;
end;


procedure TFtpClientForm.tv1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  TargetTreeNode: TTreeNode;
  SourceLevel, TargetLevel: Integer;
  I : INTEGER;
begin
  Accept := False;
  TargetTreeNode := tv1.GetNodeAt( X, Y );
  if (TargetTreeNode = nil) or (TargetTreeNode = tv1.Selected)
  or (TargetTreeNode = tv1.Selected.Parent) then
  begin
    Exit;
  end;

  Accept := True;
  for I := 0 to tv1.SelectionCount - 1 do
  begin
   IF tv1.Selections[I].HasChildren THEN
   begin
    Accept := False;
    Break;
   end;
  end;
end;

procedure TFtpClientForm.tv1Edited(Sender: TObject; Node: TTreeNode;
  var S: string);
var
  Element: IXMLDOMElement;
begin
  S := Trim( S );
  if S <> Node.Text then
  begin
    Element := GetDOMNode( Node ) as IXMLDOMElement;
    Element.setAttribute(ClassNameAttr, s);
  end;
  actsaveExecute(nil);
end;


procedure TFtpClientForm.tv1Editing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  AllowEdit := Node.ImageIndex = CLASS_IMAGEINDEX;
end;

procedure TFtpClientForm.btn1Click(Sender: TObject);
var
  BDIr :Boolean;
  byteTotransfer: Integer;
  Fname : string;
begin
   if not FTP1.Connected then
     exit;
  if lv1.Selected = nil then Exit;
  if lv1.Items.Count >0 then
  begin
   Fname := GetNameFromDirLine(FtpFileList.Strings[lv1.itemindex],bdir);
   if not bdir then
   begin
     dlgSave1.FileName := Fname;
     if   dlgSave1.Execute then
     begin
       if fileexists(dlgSave1.FileName) then
       case MessageDlg('�ļ��Ѿ����ڣ���Ҫ������һ�ε�������', mtConfirmation, mbYesNoCancel,0) of
         mrYes: MyFtpGet(Fname,dlgSave1.FileName,True);
         mrno:  MyFtpGet(Fname,dlgSave1.FileName,False);
         else Exit;
       end
       else
          MyFtpGet(Fname,dlgSave1.FileName,False)
     end;
   end;
  end;

end;

procedure TFtpClientForm.btn2Click(Sender: TObject);
begin
 FTP1.ChangeDir(lbledtEDCurDir.Text);
end;

//������������   richEdit   ��Ԫ��
procedure   SetRicheditLineColor(RichEdit:TRichEdit;FontColor,LineBackGroundColor   :TColor;LineIndex:Integer);
var   i:Integer;
    c:integer;
    backStart   :   integer;
    Fmt   :TCharFormat2;
begin
    c:=0;   //����������
    backStart   :=   RichEdit.SelStart;     //���ݹ��λ��
    for   i:=0   to   RichEdit.Lines.Count-1   do
    begin
        if   i=lineIndex   then
        begin
        RichEdit.SelStart   :=   c;   //Ѱ��ѡ����������λ��
        RichEdit.SelLength   :=   length(RichEdit.Lines.Strings[i]);   //���ѡ��ǰ�еĳ���
        Fmt.cbSize   :=   SizeOf(Fmt);//����Ŵ��ݵĽṹ��С��ϵͳͨ�����֪�����ݵ���CharFormat����CharFormat2
        Fmt.dwMask   :=   CFM_COLOR or CFM_BACKCOLOR;  // ����ϵͳֻ��������ɫ�ͱ�����ɫ�����ֶε�ֵ��Ч
        Fmt.crTextColor   :=   FontColor;//����������ɫ 
        Fmt.crBackColor   :=   0;//�������屳��ɫ
        RichEdit.Perform(EM_SETCHARFORMAT,SCF_SELECTION,integer(@Fmt));//��EM_SETCHARFORMAT��Ϣ��RichEdit����ʾֻ��ѡ�񲿷ּӱ�����ɫ
        RichEdit.SelLength   :=   0;   //�ָ�ѡ��
        break;                                                                   //�ж�
        end;
        c   :=   c   +   length(RichEdit.Lines.Strings[i])+2 ;     //  +   2��ʾ#13#10��windows   ϵͳ�ǻس�+����   2���ַ�
    end;
    RichEdit.SelStart   :=   backStart   ;   //�ָ����λ�� 
end;



procedure TFtpClientForm.btn3Click(Sender: TObject);
begin
end;

// ���¼���FTpĿ¼
function TFtpClientForm.MyConnect(Node: TTreeNode; TragetIdFTP: TIdFTP;
  Bconnect: Boolean): boolean;
begin
 SelectNode(Node);
 Result := MyTestConnect(TragetIdFTP,False);
end;


procedure TFtpClientForm.MyFtpChangeDir(Dir : string);
var
 Bdir : boolean;
 I : integer;
 TEmpLi : TListItem;
begin
   MyConnect(FTP1);
   lv1.Items.Clear;
   FtpFileList.Clear;
  try
    lv1.Items.BeginUpdate;
    FTP1.ChangeDir(Dir);
    FTP1.TransferType := ftASCII;
    FTP1.List(FtpFileList);
    for i:= 0 to FtpFileList.count -1 do
    begin
     TEmpLi := lv1.Items.Add;
     TEmpLi.Caption :=  GetNameFromDirLine(FtpFileList.Strings[i],Bdir);
    end;
  finally
    lv1.Items.EndUpdate;
  end;
end;

procedure TFtpClientForm.btnDelClick(Sender: TObject);
var
  bdir :boolean;
  Fname :string;
begin
  if lv1.Selected = nil then Exit;
  if lv1.Items.Count >0 then
  begin
   Fname := GetNameFromDirLine(FtpFileList.Strings[lv1.itemindex],bdir);
   if not bdir then
   begin
    FTP1.delete(Fname);
    MyFtpChangeDir(FTP1.RetrieveCurrentDir);
   end
   else
    FTP1.RemoveDir(Fname);
  end;
end;
procedure TFtpClientForm.btnsaveClick(Sender: TObject);
begin
  SaveNoad(tv1.Selected);
  actsaveExecute(nil);
end;

procedure TFtpClientForm.btn4Click(Sender: TObject);
var
  TempStrem : TFileStream;

  Bdir : Boolean;
  sDownToFileName,Sfilename : string;
begin
 if not FTP1.Connected then Exit;
   Sfilename := GetNameFromDirLine(lstDebugListBox.Items.Strings[lstDebugListBox.ItemIndex],BDIr);
   dlgSave1.FileName := Sfilename;
 Application.ProcessMessages;
 if dlgSave1.Execute then
 begin
   sDownToFileName := dlgSave1.FileName;
   if FileExists(sDownToFileName) then
   TempStrem := TFileStream.Create(sDownToFileName,fmOpenWrite)
   else
   TempStrem := TFileStream.Create(sDownToFileName,fmCreate);
   try
    if not bdir then
    begin
      pb1.Max := FTP1.Size( lbledtEDCurDir.Text + Sfilename);
      pb1.Position := TempStrem.Size;
      TempStrem.Position := TempStrem.Size;
      FTP1.Get(lbledtEDCurDir.Text + Sfilename,TempStrem,True);
    end
    else
     Exit;
   finally
     FreeAndNil(TempStrem);
   end;
 
 end;
end;
 





procedure TFtpClientForm.btn5Click(Sender: TObject);
begin
MyTestConnect(FTP1);
end;

procedure TFtpClientForm.btn7Click(Sender: TObject);
var
  iRtn : integer;
begin
  if not FTP1.Connected then Exit;
  case FTP1.SendCmd('REST 1')of
   350:ShowMessage('֧�ֶϵ�����');
  else ShowMessage('��֧�ֶϵ�����');
  end;
end;






procedure TFtpClientForm.btn8Click(Sender: TObject);
var
 IdFTP1: TIdFTP;
begin
  if not Assigned(FFtpclient) then
  begin
    FFtpclient :=TFtpClientMy.Create;
    FFtpclient.FtpUserName := Trim(lbledtUserName.Text);
    FFtpclient.FtpPassword := Trim(lbledtPassword.Text);
    FFtpclient.Ftpport := StrToIntdef(Trim(lbledtPort.Text),21);
    FFtpclient.FtpIP := Trim(lbledtIP.Text);
    FFtpclient.FtpPut(edt1.Text, AnsiToUtf8(ExtractFileName(edt1.Text)),False) ;
    if FFtpclient.DeCompression then  ShowMessage('�ɹ�');

//    end;
  end;
end;


//��ȡ��ѡ�ķ������б�
function TFtpClientForm.getCheckedNode():Integer;
var
  Node: TTreeNode;
  TVI: TTVItem;
begin
  Result := -1;
  selNodeList.Clear;
  for Node in tv1.Items do
  begin
    Sleep(11);
    TVI.mask := TVIF_STATE;
    TVI.hItem := Node.ItemId;
    TreeView_GetItem(tv1.Handle, TVI);
    if Node.IsFirstNode then  Continue;
    if Node.ImageIndex <> Ftp_ImageIndex then Continue;
    if TVI.state and $2000 = $2000 then
      selNodeList.Add(Node)
  end;
  Result := selNodeList.count;
end;


procedure TFtpClientForm.btn9Click(Sender: TObject);
var
  Node: TTreeNode;
  TVI: TTVItem;
begin
  for Node in tv1.Items do
  begin
    TVI.mask := TVIF_STATE;
    TVI.hItem := Node.ItemId;
    TreeView_GetItem(tv1.Handle, TVI);
    if TVI.state and $2000 = $2000 then
      ShowMessage(Node.Text);
  end;
end;

procedure TFtpClientForm.FTP1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: String);
begin
 lstDebugListBox.ItemIndex := lstDebugListBox.Items.Add(AStatusText);
// IdFTP1.LoginMsg.Text.Text;
end;


procedure TFtpClientForm.FTP1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
 babortTrans := False;
end;


procedure TFtpClientForm.FTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  inherited;
  babortTrans := False;
end;

procedure TFtpClientForm.FTPclentNotifyEvent(ADatetime: TDateTime; AUserIP,
  AEventMessage: string);
begin
  RichEdit1.Lines.BeginUpdate;
  SetRDColorByAddText(RichEdit1, DateTimeToStr(ADatetime) + #32 + AUserIP + #32 + AEventMessage);
  RichEdit1.Lines.EndUpdate;

end;

procedure TFtpClientForm.test();
begin
       case FTP1.SendCmd('DecomPress') of
       731: ShowMessage('fail');   // 731����ʧ��
     else
       ShowMessage('success');
     end;


end;


procedure TFtpClientForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 CanClose := (MessageBox(Handle, MessageClose, MesssageCaption, MB_OKCANCEL + MB_ICONQUESTION + MB_TASKMODAL) = IDOK);
 if CanClose then
 begin
  if Assigned(FtpFileList) then FreeAndNil(FtpFileList);
  if Assigned(selNodeList) then FreeAndNil(selNodeList);
  if Assigned(ResultList) then FreeAndNil(ResultList);
  if Assigned(Templist) then FreeAndNil(Templist);

  saveRft;
 end;
   

end;

procedure TFtpClientForm.saveRft;
var
  tempRich: TRichEdit;
  filename: string;
begin
  filename := Format(fLogname,[FormatDateTime('yyyy-mm-dd', Now)]);
  if FileExists(filename) then
  begin
    tempRich :=TRichEdit.Create(self);
    try
      tempRich.Parent := Self;
      tempRich.Lines.LoadFromFile(filename);
      RichEdit1.SelectAll;
      RichEdit1.CopyToClipboard;
      tempRich.PasteFromClipboard;
      tempRich.Lines.SaveToFile(filename);
    finally
      tempRich.Free;
    end;
  end
  else
      RichEdit1.Lines.SaveToFile(filename);
end;


procedure TFtpClientForm.FormCreate(Sender: TObject);
var
 i : Integer;
begin
  if not DirectoryExists('.\log') then CreateDir('.\log');
  pgc1.Align := alClient;
  FtpFileList := TStringList.Create;
  ResultList := TStringList.Create;
  Templist := TStringList.Create;
  selNodeList := TList.Create;
  DragAcceptFiles(Handle, True);
  FBaseTreeNode := tv1.Items[0];
  RichEdit1.Color := clBlack;
  ts2.TabVisible := False;
  actloadExecute(nil);
  setEnabled(False);
  BnotModify := true;
  btn11.Enabled := False;
  tv1.ReadOnly := true;
end;



procedure TFtpClientForm.FTP1Work(Sender: TObject; AWorkMode: TWorkMode;  AWorkCount: Integer);
begin
  try
    if babortTrans then  FTP1.Abort;
    pb1.Position := BHadTrans + AWorkCount;
    application.ProcessMessages;
  except
    on E:Exception do
    begin
      ShowMessage('�ϴ�������');
    end;
  end;
end;
function GetMD5ByFileName(CheckStr:string):String;
var
  MyMD5 : TIdHashMessageDigest5;
  TempFS: TFileStream;
begin
    TempFS := TFileStream.Create(CheckStr,fmOpenRead   or   fmSharedenyNone);
    MyMD5:=TIdHashMessageDigest5.Create;
  try
    Result:=MyMD5.AsHex(MyMD5.HashValue(TempFS));
  finally
    MyMD5.Free;
    TempFS.Free;
  end;
end;

procedure TFtpClientForm.MyFtpPut(srcname, Targetname: string;Bresume: boolean);
const
  SenderBuffer = 1024*1024;
var
  Tempfs : TFileStream;
  TempMS : TMemoryStream;
begin
//  MyConnect(FTP1);
  if not FTP1.Connected then ShowMessage('δ����');
  Tempfs := TFileStream.Create(srcname, fmOpenRead);
  try
    //�ϵ�����ʱ ��������ʹ��
    BHadTrans := FTP1.Size(Targetname);
    FTP1.TransferType := ftBinary;
    pb1.Max := Tempfs.Size; // ��������ʹ��
    if Bresume then
    begin
     //���Ҷϵ�
     // ShowMessage('�ϵ��ϴ� ԭ���ϴ�' + IntToStr(BHadTrans) );
     Tempfs.Seek(BHadTrans, soFromBeginning);
     TempMS := TMemoryStream.Create;
      try
        while Tempfs.Position < Tempfs.Size do
        begin
          TempMS.Clear;
          TempMS.CopyFrom(Tempfs, Min(SenderBuffer, Tempfs.Size -Tempfs.Position));
          FTP1.Put(TempMS,Targetname,True);
          BHadTrans := FTP1.Size(Targetname);
        end;
      finally
        TempMS.Free;
      end;
    end
    else
    begin
     BHadTrans := 0;
     FTP1.Put(Tempfs, Targetname)
    end;
   finally
    Tempfs.Free;
  end;

end;


function TFtpClientForm.MyTestConnect(TragetIdFTP: TIdFTP; Btest:Boolean): boolean;
begin
   Result := False;
   with TragetIdFTP do
   begin
     if Connected then   Disconnect;
     try
        Username:=lbledtUser.Text;
        Password:=lbledtPW.Text;
        HostToIP(lbledtFtpIp.Text,integer(@Host));
        Port:= StrToInt(lbledtPort1.Text);
        TransferType := ftASCII;
        ConnectTimeout := 1000;
        Connect;
        Result := true;
        if Btest then              
        begin
         MessageBox(0,'���������ӳɹ�,����ͨ��',MesssageCaption,mb_ok + MB_TASKMODAL + MB_ICONINFORMATION);
         Disconnect;
        end;
     except
        if Btest then
        MessageBox(0,'����������ʧ��,�������',MesssageCaption,mb_ok + MB_TASKMODAL + MB_ICONWARNING);
        Result := false;
     end;
   end
end;

procedure TFtpClientForm.WMBarIcon(var Message: TMessage);
var
   lpData:PNotifyIconData;
begin
if (Message.LParam = WM_LBUTTONDOWN) then
   begin
     //����û����������ͼ����ͼ��ɾ�����ظ����ڡ�
     lpData := new(PNotifyIconDataA);
     lpData.cbSize := SizeOf(PNotifyIconDataA);
     lpData.Wnd := FtpClientForm.Handle;
     lpData.hIcon := Application.Icon.Handle;
     lpData.uCallbackMessage := WM_BARICON;
     lpData.uID :=1;
     lpData.szTip := '�ɺ�Ftp�ͻ���';
     lpData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
     Shell_NotifyIcon(NIM_DELETE,lpData);
     dispose(lpData);
     FtpClientForm.Visible := True;
   end;
end;

procedure TFtpClientForm.WMDROPFILES(var Msg: TMessage);
var
  i: Integer;
  FileName: array[0..255] of Char;
begin
  edt1.Clear;
  DragQueryFile(Msg.WParam, 0, FileName, 256);
  edt1.Text := FileName;
  DragFinish(Msg.WParam);
end;

procedure TFtpClientForm.WMSysCommand(var Message: TMessage);
var
   lpData:PNotifyIconData;
begin
  if Message.WParam = SC_ICON then
  begin
       //����û���С�������򽫴������ز��������������ͼ��
       lpData := new(PNotifyIconDataA);
       lpData.cbSize := SizeOf(PNotifyIconDataA);
       lpData.Wnd := FtpClientForm.Handle;
       lpData.hIcon := Application.Icon.Handle;
       lpData.uCallbackMessage := WM_BARICON; //�ص�����
       lpData.uID :=1;
       lpData.szTip := '�ɺ�Ftp�ͻ���';
       lpData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
       Shell_NotifyIcon(NIM_ADD,lpData);
       dispose(lpData);
       FtpClientForm.Visible := False;
  end
  else
  begin
       //�����������SystemCommand��Ϣ�����ϵͳȱʡ����������֮��
     DefWindowProc(FtpClientForm.Handle,Message.Msg,Message.WParam,Message.LParam);
  end;
end;
{ TGetMM }

constructor TFtpclientThread.Create(infoNode: IXMLDOMElement; locFilename:string);
begin
//   InitializeCriticalSection(FtpCS);
   FinfoDOME :=  infoNode;
   FfileName := locFilename;
   inherited Create(False);
   Priority := tpTimeCritical;
end;



destructor TFtpclientThread.Destroy;
begin
//  DeleteCriticalSection(ftpcs);
//  ShowMessage('destroy');
//  SendMessage(FtpClientForm.Handle,WM_TransOK, 0 ,1);
//  Synchronize(putfile);
  Dec(TransCount);
  if TransCount = 0 then
  begin
   if  ResultList.Count = 1 then
   begin
    ResultList.Clear;
    ResultList.Add(Format(msgSuccess,[DateTimeToStr(now)]))
   end;
   FtpClientForm.RichEdit1.Lines.AddStrings(ResultList);
   FtpClientForm.btn11.Enabled := true;
  end;
  inherited;
end;

procedure TFtpclientThread.Execute;
begin
//    FtpClientForm.btn11.Enabled := False;
    FreeOnTerminate := True;
    Synchronize(putfile);
//    putfile;
end;





procedure TFtpclientThread.putfile;
var
 sIP: string;
 FftpclientTd : TFtpClientMy;
 Bsuccess :Boolean;
begin
    Bsuccess := false;
//    if not Assigned(FftpclientTd) then
    FftpclientTd :=TFtpClientMy.Create;
    try
      FftpclientTd.OnFtpNotifyEvent := FtpClientForm.FTPclentNotifyEvent;
      sIP := Trim(FinfoDOME.getAttribute(ServerIPAttr));
      FftpclientTd.FProgressBar :=  @(FtpClientForm.pb1);
      FftpclientTd.FtpMachineName := FinfoDOME.getAttribute(ServerNameAttr);
      FftpclientTd.FtpUserName := FinfoDOME.getAttribute(ServerUserNameAttr);
      FftpclientTd.FtpPassword := FinfoDOME.getAttribute(ServerPasswordAttr);
      FftpclientTd.Ftpport := StrToIntdef(Trim(FinfoDOME.getAttribute(ServerPortAttr)),37);
      FftpclientTd.FtpPassive := FinfoDOME.getAttribute(ServerPassive);
      HostToIP(sIP, integer(@FftpclientTd.FtpIP));
      Bsuccess := FftpclientTd.FtpPut(FfileName, AnsiToUtf8(ExtractFileName(FfileName)));
      if Bsuccess then
      begin
        if not   FftpclientTd.DeCompression then
        ResultList.Add(Format(msgDecompressFailed,[DateTimeToStr(now), FftpclientTd.FtpMachineName, FftpclientTd.FtpIP]))
      end else
      begin
        ResultList.Add(Format(msgUploadFailed,[DateTimeToStr(now), FftpclientTd.FtpMachineName, FftpclientTd.FtpIP]))
      end;
    finally
     FftpclientTd.AbortTrans;
     FftpclientTd.Free;
    end;
end;





end.
