unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls,dateutils, jpeg, RpCon, RpConDS,
  RpBase, RpSystem, DB, ADODB, RpDefine,shellapi, RpRave,unit14, StdCtrls, Buttons;

type
  Tfmain = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    N3: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N5: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    N48: TMenuItem;
    N49: TMenuItem;
    N50: TMenuItem;
    N51: TMenuItem;
    N52: TMenuItem;
    N53: TMenuItem;
    ADOQuery1: TADOQuery;
    Image1: TImage;
    sbbz: TSpeedButton;
    sbxtsz: TSpeedButton;
    spzbdj: TSpeedButton;
    sbckmx: TSpeedButton;
    sbzbtj: TSpeedButton;
    sbkcck: TSpeedButton;
    sblrfx: TSpeedButton;
    sbbbdy: TSpeedButton;
    Panelxtsz: TPanel;
    imagextsz: TImage;
    SpeedButton10: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panelzbdj: TPanel;
    Image2: TImage;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    Panelckmx: TPanel;
    Image3: TImage;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Panelzbtj: TPanel;
    Image4: TImage;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton19: TSpeedButton;
    Panellrfx: TPanel;
    Image5: TImage;
    SpeedButton6: TSpeedButton;
    SpeedButton21: TSpeedButton;
    Panelbbdy: TPanel;
    Image6: TImage;
    SpeedButton20: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton29: TSpeedButton;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    N54: TMenuItem;
    SpeedButton32: TSpeedButton;
    ADOQuery1id: TIntegerField;
    ADOQuery1name: TStringField;
    ADOQuery1name_1: TStringField;
    ADOQuery1number: TIntegerField;
    ADOQuery1price: TBCDField;
    ADOQuery1sumpricee: TBCDField;
    ADOQuery1cush: TBCDField;
    ADOQuery1date: TDateTimeField;
    SpeedButton17: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton18: TSpeedButton;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N16Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N52Click(Sender: TObject);
    procedure N53Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure N47Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure N45Click(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N49Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure N39Click(Sender: TObject);
    procedure N50Click(Sender: TObject);
    procedure N40Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbbzClick(Sender: TObject);
    procedure sbxtszClick(Sender: TObject);
    procedure spzbdjClick(Sender: TObject);
    procedure sbckmxClick(Sender: TObject);
    procedure sbzbtjClick(Sender: TObject);
    procedure sblrfxClick(Sender: TObject);
    procedure sbbbdyClick(Sender: TObject);
    procedure SpeedButton26MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure SpeedButton29Click(Sender: TObject);
    procedure SpeedButton30Click(Sender: TObject);
    procedure SpeedButton26Click(Sender: TObject);
    procedure N54Click(Sender: TObject);
    procedure SpeedButton27Click(Sender: TObject);
  private
    { Private declarations }
    procedure showpanel(sender: tobject);
  public
    { Public declarations }
  end;

var
  fmain: Tfmain;

implementation
 uses ulogin,Udata2,ubackup,unit23,unit20,unit21,unit12,unit11,unit19,jinhodengji,unit2,unit3,unit4,unit5,unit6,unit7,unit9,unit8,unit10,unit15,unit16;
{$R *.dfm}

procedure tfmain.showpanel(sender:tobject);
begin
  tpanel(sender).Visible:=true;
  tpanel(sender).BringToFront;
end;
procedure Tfmain.Timer1Timer(Sender: TObject);
begin
statusbar1.Panels.Items[2].text:='      '+datetimetostr(now);
end;

procedure Tfmain.FormCreate(Sender: TObject);
var
 i:integer;
begin
   try
      flogin.ADOConnection1.Connected:=false;
      data2.ADOConnection1.Connected:=false;
      data2.ADOConnection1.ConnectionString:=flogin.ADOConnection1.ConnectionString;
      flogin.ADOConnection1.Connected:=true;
      data2.ADOConnection1.Connected:=true;
  finally
   Data2.jinhuochangshang.Active:=True;
   data2.category.Active:=True;
   Data2.product.Active:=True;
   Data2.inproduct.Active:=True;
   Data2.outproduct.Active:=True;
   Data2.employee.Active:=True;
   Data2.customers.Active:=True;
   Data2.sell.Active:=True;
   Data2.login.Active:=True;
   Data2.outcustomers.Active:=True;
  end;


statusbar1.Panels.Items[0].text:='   ������΢Ц����   ';//��ֵ��������΢Ц���𣿡�����statusbar1.panel.items[0].text
statusbar1.Panels.Items[1].text:='  ���������Լ�������@@@@'; //��ֵ�����������Լ�������@@@@������statusbar1.panel.items[1].text
 a:=7;//��ֵ7����a
  for i:=0 to self.ComponentCount-1 do
   begin
    if self.Components[i] is tspeedbutton then
    begin
      if tspeedbutton(self.Components[i]).Tag<=0 then
      begin
      tspeedbutton(self.Components[i]).Tag:=a;
      inc(a);
      tspeedbutton(self.Components[i]).OnMouseMove:=SpeedButton26MouseMove;
      end;
    end;
   end;

end;



procedure Tfmain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 data2.ADOConnection1.Connected:=false;//�Ͽ���data2.ADOConnection1������
 flogin.ADOConnection1.Connected:=false;//�Ͽ���flogin.ADOConnection1������
 if messagebox(handle,'ȷ���˳�?','Warging',mb_okcancel+mb_iconquestion)=idcancel then
  action:=canone
 else application.Terminate;//ϵͳ��ʾ��ȷ���˳������ȷ�����˳�������򷵻ؽ���
end;

procedure Tfmain.N16Click(Sender: TObject);
begin
 if messagebox(handle,'ȷ���˳�?','Warging',mb_okcancel+mb_iconquestion)=idok then
 application.Terminate
 else
  exit;
end;//ϵͳ��ʾ��ȷ���˳������ȷ�����˳�������򷵻ؽ���

procedure Tfmain.N17Click(Sender: TObject);
begin
fzhangbodengji.ComboBox1.ItemIndex:=1;//��ֵ1����fzhangbodengji.combobox1.itemindex
//fzhangbodengji.Button1.Click;
fzhangbodengji.Caption:=fzhangbodengji.ComboBox1.Text;//��fzhangbodengji.ComboBox1.Text��ֵ����fzhangbodengji.Caption
fzhangbodengji.show;//��ʾfzhangbodengji����
end;

procedure Tfmain.N3Click(Sender: TObject);
begin
fxitongshezhi.RadioGroup1.ItemIndex:=0;//��ֵ0����fxitongshezhi.RadioGroup1.ItemIndex
fxitongshezhi.Show;//��ʾfxitongshezhi����
end;

procedure Tfmain.N11Click(Sender: TObject);
begin
fxitongshezhi.RadioGroup1.ItemIndex:=1;//��ֵ1����fxitongshezhi.RadioGroup1.ItemIndex
fxitongshezhi.Show;//��ʾfxitongshezhi����
end;

procedure Tfmain.N12Click(Sender: TObject);
begin
fxitongshezhi.RadioGroup1.ItemIndex:=2;//��ֵ2����fxitongshezhi.RadioGroup1.ItemIndex
fxitongshezhi.Show;//��ʾfxitongshezhi����
end;

procedure Tfmain.N13Click(Sender: TObject);
begin
fxitongshezhi.RadioGroup1.ItemIndex:=3;//��ֵ3����fxitongshezhi.RadioGroup1.ItemIndex
fxitongshezhi.Show;//��ʾfxitongshezhi����
end;

procedure Tfmain.N14Click(Sender: TObject);
var
 bo:boolean;
begin
 data2.login.Open;//��ģ��data2�е�login
 data2.login.Locate('name',ulogin.user,[]);
 bo:=data2.login.FieldByName('isadmin').AsBoolean;//�������û�����bo
 if not bo then
  begin
  if messagedlg('Ҫ�޸����������?',mtconfirmation,[mbyes,mbno],0)=mryes then
   begin
  form19.ShowModal;
   end//������ǳ����û���ϵͳ��ʾ��Ϣ'Ҫ�޸����������?'���ȷ����ʾform19����
  end
 else
 begin
  fxitongshezhi.RadioGroup1.ItemIndex:=4;
  fxitongshezhi.Show;
 end;//����ǳ����û��ͽ�ֵ4����fxitongshezhi.RadioGroup1.ItemIndex��ʾfxitongshezhi����
end;

procedure Tfmain.N18Click(Sender: TObject);
begin
fzhangbodengji.ComboBox1.ItemIndex:=2;//��ֵ2����fzhangbodengji.ComboBox1.ItemIndex
fzhangbodengji.Caption:=fzhangbodengji.ComboBox1.Text;//��fzhangbodengji.ComboBox1.ItemIndex��ֵ����fzhangbodengji.Caption
fzhangbodengji.show;//��fzhangbodengji����

end;

procedure Tfmain.N52Click(Sender: TObject);
begin
fzhangbodengji.ComboBox1.ItemIndex:=3;//��ֵ3����fzhangbodengji.ComboBox1.ItemIndex
fzhangbodengji.Caption:=fzhangbodengji.ComboBox1.Text;//��fzhangbodengji.ComboBox1.ItemIndex��ֵ����fzhangbodengji.Caption
fzhangbodengji.show;//��fzhangbodengji����
end;

procedure Tfmain.N53Click(Sender: TObject);
begin
fzhangbodengji.ComboBox1.ItemIndex:=4;//��ֵ4����fzhangbodengji.ComboBox1.ItemIndex
fzhangbodengji.Caption:=fzhangbodengji.ComboBox1.Text;//��fzhangbodengji.ComboBox1.ItemIndex��ֵ����fzhangbodengji.Caption
fzhangbodengji.show;//��fzhangbodengji����
end;

procedure Tfmain.N23Click(Sender: TObject);
begin
fzhangbodengji.ComboBox1.ItemIndex:=5;//��ֵ5����fzhangbodengji.ComboBox1.ItemIndex
fzhangbodengji.Caption:=fzhangbodengji.ComboBox1.Text;//��fzhangbodengji.ComboBox1.ItemIndex��ֵ����fzhangbodengji.Caption
fzhangbodengji.show;//��fzhangbodengji����
end;

procedure Tfmain.N25Click(Sender: TObject);
begin
fzhangbodengji.ComboBox1.ItemIndex:=6;//��ֵ6����fzhangbodengji.ComboBox1.ItemIndex
fzhangbodengji.Caption:=fzhangbodengji.ComboBox1.Text;//��fzhangbodengji.ComboBox1.ItemIndex��ֵ����fzhangbodengji.Caption
fzhangbodengji.show;//��fzhangbodengji����
end;

procedure Tfmain.N27Click(Sender: TObject);
begin
fzhangbodengji.ComboBox1.ItemIndex:=7;//��ֵ7����fzhangbodengji.ComboBox1.ItemIndex
fzhangbodengji.Caption:=fzhangbodengji.ComboBox1.Text;//��fzhangbodengji.ComboBox1.ItemIndex��ֵ����fzhangbodengji.Caption
fzhangbodengji.show;//��fzhangbodengji����

end;

procedure Tfmain.N43Click(Sender: TObject);
begin
 adoquery1.Open;//��adoquery1
 fqrinproduct.QuickRep1.Preview;//��ӡ����
end;

procedure Tfmain.N47Click(Sender: TObject);
begin
 data2.sell.Open;//��ģ��data2�е�sell
 fqrsell.QuickRep1.Preview;//��ӡ����
end;

procedure Tfmain.N28Click(Sender: TObject);
begin
fmingxi.ShowModal;//��ʾfmingxi����
end;

procedure Tfmain.N45Click(Sender: TObject);
begin
fmingxi.ShowModal;//��ʾfmingxi����
end;

procedure Tfmain.N30Click(Sender: TObject);
begin
 fyishoumingxi.button1.Visible:=false;//����fyishoumingxi.button1����
 fyishoumingxi.BitBtn1.Visible:=true;//��fyishoumingxi.BitBtn1����
 fyishoumingxi.ShowModal;//��ʾfyishoumingxi����
end;

procedure Tfmain.N32Click(Sender: TObject);
begin
 fyishoumingxi.BitBtn1.Visible:=false;//����fyishoumingxi.BitBtn1����
 fyishoumingxi.button1.Visible:=true;//��fyishoumingxi.button1����
 fyishoumingxi.ShowModal;//��ʾfyishoumingxi����
end;

procedure Tfmain.N49Click(Sender: TObject);
begin
 fyishoumingxi.button1.Visible:=false;//����fyishoumingxi.button1����
 fyishoumingxi.BitBtn1.Visible:=true;//��fyishoumingxi.BitBtn1����
 fyishoumingxi.ShowModal;//��ʾfyishoumingxi����
end;

procedure Tfmain.N51Click(Sender: TObject);
begin
 fyishoumingxi.BitBtn1.Visible:=false;//����fyishoumingxi.BitBtn1����
 fyishoumingxi.button1.Visible:=true;//��fyishoumingxi.button1����
 fyishoumingxi.ShowModal;//��ʾfyishoumingxi����
end;

procedure Tfmain.N7Click(Sender: TObject);
begin
 fstore.ShowModal;//��ʾfstore����
end;

procedure Tfmain.N5Click(Sender: TObject);
begin
 fselectdate.RadioGroup1.ItemIndex:=0;//��ֵ0����fselectdate.RadioGroup1.ItemIndex
 fselectdate.ShowModal;//��ʾfselectdate����
end;

procedure Tfmain.N37Click(Sender: TObject);
begin
 fselectdate.RadioGroup1.ItemIndex:=1;//��ֵ1����fselectdate.RadioGroup1.ItemIndex
 fselectdate.ShowModal;//��ʾfselectdate����
end;

procedure Tfmain.N39Click(Sender: TObject);
begin
 fselectdate.RadioGroup1.ItemIndex:=2;//��ֵ2����fselectdate.RadioGroup1.ItemIndex
 fselectdate.ShowModal;//��ʾfselectdate����
end;

procedure Tfmain.N50Click(Sender: TObject);
begin
 fproduct.ShowModal;//��ʾfproduct����
end;

procedure Tfmain.N40Click(Sender: TObject);
begin
 fprofit.ShowModal;//��ʾfproduct����
end;

procedure Tfmain.N42Click(Sender: TObject);
begin
 fprofit2.ShowModal;//��ʾfproduct2����
end;

procedure Tfmain.FormShow(Sender: TObject);
var
 bo:boolean;//�������bo
begin
 data2.login.Open;//��ģ��data2��login
 data2.login.Locate('name',ulogin.user,[]);
 bo:=data2.login.FieldValues['isadmin'];//�������û�����bo
 if not bo then speedbutton26.Enabled:=false;
 data2.login.Close;
     animatewindow(handle,700,aw_ver_positive)
end;//������ǳ����û���speedbutton26.Enabled��ֵΪflase���ر�ģ��data2�е�login��������̶�������Ļ�м�

procedure Tfmain.sbbzClick(Sender: TObject);
begin
 shellexecute(0,'open',pchar(extractfilepath(paramstr(0))+'\help\help.chm'),nil,nil,sw_normal);
 //��ʾfhelp����
end;

procedure Tfmain.sbxtszClick(Sender: TObject);
begin
  showpanel(panelxtsz);
end;

procedure Tfmain.spzbdjClick(Sender: TObject);
begin
     showpanel(panelzbdj);
end;

procedure Tfmain.sbckmxClick(Sender: TObject);
begin
   showpanel(panelckmx);
end;

procedure Tfmain.sbzbtjClick(Sender: TObject);
begin
   showpanel(panelzbtj);
end;

procedure Tfmain.sblrfxClick(Sender: TObject);
begin
   showpanel(panellrfx);
end;

procedure Tfmain.sbbbdyClick(Sender: TObject);
begin
  showpanel(panelbbdy);
end;



procedure Tfmain.SpeedButton26MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
 i:integer;
begin
   for i:=0 to self.ComponentCount-1 do
   begin
    if self.Components[i] is tspeedbutton then
    begin
      if (tspeedbutton(self.Components[i]).Tag<=6) and (tspeedbutton(self.Components[i]).Tag>=1)then
      begin
       if tspeedbutton(self.Components[i]).Tag=tspeedbutton(sender).Tag then
         tspeedbutton(sender).Layout:=blglyphbottom
       else
          tspeedbutton(self.Components[i]).Layout:=blglyphtop;
      end
      else
       begin
        if tspeedbutton(self.Components[i]).Tag=tspeedbutton(sender).Tag then
           tspeedbutton(self.Components[i]).Layout:=blglyphright
        else
           tspeedbutton(self.Components[i]).Layout:=blglyphleft;
       end;
    end;
   end;
end;

procedure Tfmain.SpeedButton29Click(Sender: TObject);
begin
 winexec('calc',0);
end;

procedure Tfmain.SpeedButton30Click(Sender: TObject);
begin
 winexec('notepad',sw_normal);
end;

procedure Tfmain.SpeedButton26Click(Sender: TObject);
begin
 Form22.ShowModal;//��ʾForm22����
end;

procedure Tfmain.N54Click(Sender: TObject);
begin
fxitongshezhi.RadioGroup1.ItemIndex:=5; //��ֵ5����fxitongshezhi.RadioGroup1.ItemIndex
fxitongshezhi.Show;//��ʾfxitongshezhi����
end;

procedure Tfmain.SpeedButton27Click(Sender: TObject);
begin
 form23.show;//��ʾform23����
end;

end.
