unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Procedure ReadTxt(FileName:String);
Var
  F : Textfile;
  Str : String;
Begin
  AssignFile(F, FileName);
  Reset(F);
  Append(F); {����ԭ������������ԭ���ݱ����}
  Writeln(F, Str); {������ Ser д���ļ�F }
  Closefile(F);
End;

procedure TForm1.btn1Click(Sender: TObject);
begin
// LanguagePackage.GetLangText(LangCategoryId,Node.attributes.getNamedItem(MapAttributesOfName).nodeValue)
end;

end.
