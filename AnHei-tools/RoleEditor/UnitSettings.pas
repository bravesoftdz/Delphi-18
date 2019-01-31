{*******************************************************}
{                                                       }
{       ����༭����                                    }
{                                                       }
{                                                       }
{                                                       }
{*******************************************************}

unit UnitSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmSettings = class(TForm)
    grpSetting: TGroupBox;
    btnSelectcbp: TButton;
    edtCbpPath: TEdit;
    lblCbpPath: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    chkkeepCheck: TCheckBox;
    Label2: TLabel;
    Edit2: TEdit;
    procedure btnSelectcbpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
    //��ȡ·����ֵ���ؼ�AEdit
    procedure GetDirectroy(ADirEdit: TEdit);

    //�����ʼ��
    procedure DoInit();
  public
    { Public declarations }
  end;

var
  FrmSettings: TFrmSettings;

  //��ʾ�ɱ༭����
  function ShowSettings(): Boolean;

implementation
uses FileCtrl, UnitMain, IniFiles;
{$R *.dfm}

function ShowSettings(): Boolean;
begin
  Result := False;
  FrmSettings := TFrmSettings.Create(nil);
  with FrmSettings do
  try
    if ShowModal = mrOk then
      Result := True;   
  finally
    Free;
  end;
end;

procedure TFrmSettings.btnOkClick(Sender: TObject);
begin
  G_CbpPath := edtCbpPath.Text;
  g_UserName := Edit2.Text;
  IsKeepLanguage    := chkkeepCheck.Checked;
  with TIniFile.Create(ExtRactFilePath(ParamStr(0)) + sConfigName) do
  try
    WriteString(sMainConfigKey, sCbpPath, G_CbpPath);
    WriteBool(sMainConfigKey, sIsKeepLanguage, IsKeepLanguage);
    WriteString(sMainConfigKey, sUserName, g_UserName);
  finally
    Free;
  end;
end;

procedure TFrmSettings.btnSelectcbpClick(Sender: TObject);
begin
  GetDirectroy(edtCbpPath);
end;

procedure TFrmSettings.DoInit;
begin
  edtCbpPath.Text := G_CbpPath;
  chkkeepCheck.Checked := IsKeepLanguage;
  Edit2.Text := g_UserName;
end;

procedure TFrmSettings.FormCreate(Sender: TObject);
begin
  //��ʼ��
  DoInit;  
end;

procedure TFrmSettings.GetDirectroy(ADirEdit: TEdit);
var
  s: string;
begin
  if SelectDirectory('ѡ��Ŀ¼', '', S) then
    ADirEdit.Text  := S;
end;

end.
