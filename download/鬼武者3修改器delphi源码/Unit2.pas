unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask;

type
  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    StaticText1: TStaticText;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    Timer2: TTimer;
    StaticText2: TStaticText;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  hWnd: Integer;   //��¼���ھ���ı���
  Pid:  Cardinal;   //��¼����PID�ı���
  hProcess:  Thandle;   //��¼���̾���ı���
  Isrun :  	Boolean;    //��¼�Ƿ�����˽��̵ı���
  nosize:  Thandle;       //������дʵ��д�볤��
implementation

{$R *.dfm}

procedure TForm2.BitBtn1Click(Sender: TObject);  //��������ߵİ�ť����
var
  res:boolean;  //������¼�޸��ڴ�ɹ���״̬
  bians: Integer;
  Addr:Integer;
begin
if  Isrun then  //��Ϸ������
  begin
      Addr:=$33FDFB4;// ��������ߵ��ڴ��ַ [ʮ������]
      bians:= 600;  //��Ҫ�޸ĵ����� [10����]
      res:=WriteProcessMemory(hProcess,pointer(Addr),pointer(@bians),2,nosize);
      if res then
      begin
        StaticText1.Caption:='��������߳ɹ�';
      end
      else
        begin
          StaticText1.Caption:='���������ʧ��';
        end;
  end
  else
    begin
      StaticText1.Caption:='��Ϸ��û������';
    end;

if checkbox1.Checked then  //���ѡ���ѡ����
  begin
    timer2.Enabled:=true;   //����ʱ��2��Ч
  end;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
var
Addr:Integer ;
juyao:array [1..8] of byte;
begin
//   (OX340D738, { 104, 1, 255, 136, 62, 62, 62, 62 });
Addr:=$340D738;  //�޸ľ�ҩ���ڴ��ַ
juyao[1]:= 104;
juyao[2]:= 1;
juyao[3]:= 255;
juyao[4]:= 136;
juyao[5]:=strtoint(Edit1.Text);
juyao[6]:=strtoint(Edit1.Text);
juyao[7]:=strtoint(Edit1.Text);
juyao[8]:=strtoint(Edit1.Text);
//��Ҫд�������.����4�����ݷֱ���4���˵�����.

WriteProcessMemory(hProcess,pointer(Addr),pointer(@juyao),8,nosize);
// д�ڴ����,������ⶪ���˷���ֵ.
end;

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
if checkbox1.Checked=false then  //���ѡ���ȡ��ѡ��
  begin
    timer2.Enabled:=false;   //����ʱ��2ʧЧ
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);  //�������е�ʱ��
begin
Isrun:= false;


end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);  //���༭��������Ƿ�Ϊ����
begin
if not(key in['0'..'9',#8])then  //��������ȡ��д��
  begin
    key:=#0;
  end;
end;


procedure TForm2.Timer1Timer(Sender: TObject);    //��һ��ʱ�ӿؼ���ȡ���ھ��
begin
   hWnd:=FindWindow('Direct3DWindowClass','oni3'); //��ȡ���ھ��
if  hWnd=0 then
  begin
    StaticText1.Caption:='��Ϸû������?';
  end
  else
    begin
      GetWindowThreadProcessId(hWnd,@Pid); //��ȡPID
      hProcess:=OpenProcess(PROCESS_ALL_ACCESS,FALSE,Pid); //��ȡ���̾��
      if  hProcess=0 then   //���ʽ���ʧ��
        begin
          StaticText1.Caption:='����Ϸ����ʧ��';
        end
        else
          begin
              StaticText1.Caption:='�Ѿ�����������';
              Isrun:=true;  //��ʾ�������Ѿ���ȡ��Ϸ�Ľ��̾����.
              Timer1.Enabled:=False;
              //��ȡ��Ϸ���̾����������������ʱ�ӿؼ�����Ҫ��.
          end;
    end;
end;

end.
