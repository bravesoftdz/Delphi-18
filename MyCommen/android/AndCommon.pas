unit AndCommon;

interface
uses
  Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText, FMX.Helpers.Android, Androidapi.JNI.Net;


procedure Call_URI(const AAction : JString;const AURI: string);


implementation




procedure Call_URI(const AAction : JString;const AURI: string);
var
  uri: Jnet_Uri;
  Intent: JIntent;
begin
  uri := StrToJURI(AURI);
  Intent := TJIntent.JavaClass.init(AAction, uri);
  {Intent.putExtra()
  �����Ҫ�����ŵȸ��ӵ�Ӧ��,��Ҫ���ݸ��������Ĳ���.Ҫ�õ�Intent.putExtra()���ݶ������.
  ����ֻ��װ��򵥵�,����Intent.putExtra()���÷�,���Բ�ѯJava������.��ѵ�
  }
  SharedActivityContext.startActivity(Intent);

//ʹ������:
//��绰
//Call_URI(TJIntent.JavaClass.ACTION_CALL, 'tel:137114553XX');
////�򿪵�ͼ��ʾĳ�������
//Call_URI(TJIntent.JavaClass.ACTION_VIEW, 'geo:38.899533,-77.036476');
////���͵����ʼ�
// Call_URI(TJIntent.JavaClass.ACTION_SENDTO, 'mailto:wr960204@126.com');
////��������
//Call_URI(TJIntent.JavaClass.ACTION_VIEW, 'file:///sdcard/download/���������.mp3');

end;


end.
