unit Unit11;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,ADODB;

type
  TFstore = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    ComboBox1: TComboBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
 procedure comboboxadditem(table: TADOTable;combobox: tcombobox;s:string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fstore: TFstore;

implementation
   uses udata2;
{$R *.dfm}
procedure TFstore.comboboxadditem(table: TADOTable;combobox: tcombobox;s:string);
begin
  combobox.Items.Clear;//��combobox.Items���
  table.Open;//��table
  table.First;
  while not table.Eof do
  begin
   combobox.Items.Add(table.fieldbyname(s).AsString);//�� table.fieldbyname(s)��ӵ�combobox.Items
   table.Next;
  end;
  table.Close;//�ر�table
end;

procedure TFstore.FormCreate(Sender: TObject);
begin
 comboboxadditem(data2.product,self.ComboBox1,'name');//�� 'name'��ӵ� combobox.items
end;

procedure TFstore.Button1Click(Sender: TObject);
begin
 data2.product.Open;//��data2.product
 if not data2.product.Locate('name',combobox1.text,[]) then
  showmessage('�Բ���˾�Ĳֿ���û�����ֲ�Ʒ')//���combobox1.text�����ݿ���Ϊ������ʾ'�Բ���˾�Ĳֿ���û�����ֲ�Ʒ'
 else
  label3.Caption:=data2.product.fieldbyname('stocks').asstring;//��'stocks'����label3.Caption

end;

end.
