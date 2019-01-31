{
�Զ���htpp��
���ܣ���ȡ��������ݣ�������httpGet��httpPost
by wfj
2013.7.4
}
unit uMyHttp;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, IdMultiPartFormData,
  IdTCPConnection, IdTCPClient, IdHTTP, FMX.Messages{$IFDEF IOS}, DPF.iOS.HTTP{$ENDIF};

type
  TAjaxCallback = reference to procedure(const aBuffer: String);
  TDownCallback = reference to procedure(const aFileName: string; const aIndex: integer);
  TUploadCallback = reference to procedure(const aLink: string; const aIndex: integer);

  {ajax�߳���}
  TAjaxThread = class (TThread)
  private
    fIdHttp: TIdHttp;
    fURL: string;
    fBuffer: string;
    fAjaxCallback: TAjaxCallback;
    procedure HandlingEnd;
  protected
    procedure Execute; override;
  public
    constructor Create(const aUrl: string; ajaxCallback: TAjaxCallback);
    destructor Destroy; override;
  end;

  {�ļ������߳���}
  TDownThread = class (TThread)
  private
    fIdHttp: TIdHttp;
    fURL: string;
    fLocalPath: string;
    fIndex: integer;
    fFileName: string;
    fDownCallback: TDownCallback;
    procedure HandlingEnd;
    function  HandlingDown: string;
    function  fUrlParams(const AParam, AUrl:string):string;
  protected
    procedure Execute; override;
  public
    constructor Create(const aUrl: string; const aLocalPath: string; const aIndex: integer; downCallback: TDownCallback);
    destructor Destroy; override;
  end;

  {�ļ��ϴ��߳���}
  TUploadThread = class (TThread)
  private
    fIdHttp: TIdHttp;
    fIndex: integer;
    fUrl: string;
    fLink: string;
    fFileName: string;
    fStream: TStream;
    fUploadCallback: TUploadCallback;
    procedure HandlingEnd;
    function  HandlingUpload: string;
  protected
    procedure Execute; override;
  public
    constructor Create(const aUrl: string; const aFileName: string; const aStream: TStream;
      const aIndex: integer; uploadCallback: TUploadCallback);
    destructor Destroy; override;
  end;

  //----------------------------------------------------------------------------
  {�߳��ⲿ���ú���}
  procedure AjaxCall(const aUrl: string; ajaxCallback: TAjaxCallback);
  procedure DownCall(const aUrl: string; const aLocalPath: string; const aIndex: integer; downCallback: TDownCallback);
  procedure UploadCall(const aUrl: string; const aFileName: string; const aStream: TStream;
      const aIndex: integer; uploadCallback: TUploadCallback);

  //----------------------------------------------------------------------------
  {��ͨ����}
  function httpGet(const aUrl: String=''):String;
  function httpPost(const AUrl: String='';const AParams:TStream=nil):String;
  function uploadFIle(AUrl:String; const AFileName: string; const AStream: TStream):String;
  function downFile(AUrl:String;const ALocalPath:String):String;

implementation

uses uMyHttpFun, PublicVar;

procedure AjaxCall(const aUrl: string; ajaxCallback: TAjaxCallback);
var
  fBuffer: string;
begin
  fBuffer:= httpGet(aUrl);
  if Assigned(ajaxCallback) then
    ajaxCallback(fBuffer);
  //������Ķ��߳�
  //TAjaxThread.Create (aUrl, ajaxCallback);
end;

procedure DownCall(const aUrl: string; const aLocalPath: string; const aIndex: integer; downCallback: TDownCallback);
begin
  TDownThread.Create (aUrl, aLocalPath, aIndex, downCallback);
end;


procedure UploadCall(const aUrl: string; const aFileName: string; const aStream: TStream;
      const aIndex: integer; uploadCallback: TUploadCallback);
begin
  TUploadThread.Create (aUrl, aFileName, aStream, aIndex, uploadCallback);
end;

{ TAjaxThread }

constructor TAjaxThread.Create(const aUrl: string; ajaxCallback: TAjaxCallback);
begin
  fUrl:= aUrl;
  fajaxCallback:= ajaxCallback;

  if not Assigned(fIdHttp) then
  begin
    fIdHttp := TIdHTTP.Create;
    fIdHttp.ConnectTimeout:= 3000;
    fIdHttp.ReadTimeout := 2000; //ʵ��Ϊ��ֵ��3��
    fIdHttp.ProtocolVersion := pv1_1;
    fIdHttp.HandleRedirects := true;  //֧����ת����
  end;

  inherited Create(false);
  FreeOnTerminate := True;
end;

destructor TAjaxThread.Destroy;
begin
  if Assigned(fIdHttp) then
  begin
    fIdHttp.Disconnect;
    FreeAndNil(fIdHttp);
  end;

  inherited;
end;

procedure TAjaxThread.HandlingEnd();
begin
  if Assigned(self.fAjaxCallback) then
    self.fAjaxCallback(fBuffer);
end;

procedure TAjaxThread.Execute;
var
  aResponseContent: TStringStream;
begin
  aResponseContent := TStringStream.Create('', TEncoding.GetEncoding(65001));
  try
    fIdHttp.Get(fURL, aResponseContent);
    aResponseContent.Position := 0;
    fBuffer:= aResponseContent.DataString;
  finally
    FreeAndNil(aResponseContent);
  end;
  //ͬ���߳�
  Synchronize(HandlingEnd);
end;

{ TDownThread }

constructor TDownThread.Create(const aUrl: string; const aLocalPath: string; const aIndex: integer; downCallback: TDownCallback);
begin
  fUrl:= aUrl;
  fLocalPath:= aLocalPath;
  fIndex:= aIndex;
  fdownCallback:= downCallback;

  if not Assigned(fIdHttp) then
  begin
    fIdHttp := TIdHTTP.Create;
    fIdHttp.ConnectTimeout:= 3000;
    fIdHttp.ReadTimeout := 2000; //ʵ��Ϊ��ֵ��3��
    fIdHttp.ProtocolVersion := pv1_1;
    fIdHttp.HandleRedirects := true;  //֧����ת����
  end;

  inherited Create (false);
  FreeOnTerminate := True;
end;

destructor TDownThread.Destroy;
begin
  if Assigned(fIdHttp) then
  begin
    fIdHttp.Disconnect;
    FreeAndNil(fIdHttp);
  end;

  inherited;
end;

procedure TDownThread.HandlingEnd();
begin
  if Assigned(self.fDownCallback) then
    self.fDownCallback(fFileName.Trim, fIndex);
end;

function TDownThread.HandlingDown: string;
var
  MemStream: TMemoryStream;
  DFileName: string;
  FilePosition: int64;
  FileSize: integer;
begin
  DFileName := fUrlParams('picture=',fURL);

  //�����ص�ַת��Ϊ�����ļ���
  while pos('/',DFileName) > 0 do
  begin
    delete(DFileName, 1, pos('/',DFileName));
  end;

  if DFileName = '' then begin
    result:= DFileName;
    exit;
  end;

  DFileName:= fLocalPath + DFileName;
  if FileExists(DFileName) then begin
    result:= DFileName;
    exit;
  end;

  MemStream := TMemoryStream.Create;
  try
    try
      fIdHttp.Head(fUrl);
      FileSize := fIdHttp.Response.ContentLength;
      FilePosition := 0;

      if FileExists(fLocalPath + DFileName) then
      begin
        try
          MemStream.LoadFromFile(DFileName);
          MemStream.Seek(0, soFromEnd);
          FilePosition := MemStream.Size;
        except
          MemStream.Free;
          result:= DFileName;
          exit;
        end;
      end;

      while FilePosition < FileSize do
      begin
        //����1
        //IdHttp.Response.ContentRangeStart := FilePosition;
        //IdHttp.Response.ContentRangeEnd   := FilePosition + 1024;
        //����2
        fIdHttp.Request.Range := IntToStr(FilePosition) + '-' ;
        if FilePosition + 10240 < FileSize then
          fIdHttp.Request.Range := fIdHttp.Request.Range + IntToStr(FilePosition + 10239);

        fIdHttp.get(fUrl, MemStream);
        //MemStream.LoadFromStream(IdHttp.Response.ContentStream);
        //�����ļ�
        MemStream.SaveToFile(DFileName);
        //���óߴ�
        FilePosition := MemStream.Size;
      end;
    except
      DFileName:= '';//����
    end;
  finally
    MemStream.Free;
  end;
  result:= DFileName;
end;

procedure TDownThread.Execute;
begin
  fFileName:= HandlingDown();
  Synchronize(HandlingEnd);
end;

{
  ���ã���ȡURL����
  ������AUrl��ַ�� ALocalPath��Ҫ�ļ�·��
  ����: ��
}
function TDownThread.fUrlParams(const AParam, AUrl:string):string;
var
  p:Integer;
begin
  Result := '';
  p := Pos(AParam,AUrl);
  if P > 0 then begin
    Inc(p, Length(AParam));
    while (p<=length(AUrl)) and (AUrl[p]<>'&') do begin
      Result := Result + AUrl[p];
      Inc(p);
    end;
  end;
  //�������Ϊ�գ��򷵻�url
  //if Result='' then Result := AUrl;
end;

{ TUploadThread }

constructor TUploadThread.Create(const aUrl: string; const aFileName: string; const aStream: TStream;
      const aIndex: integer; uploadCallback: TUploadCallback);
begin
  fUrl:= aUrl;
  fFileName:= aFileName;
  fStream:= aStream;
  fIndex:= aIndex;
  fuploadCallback:= uploadCallback;

  if not Assigned(fIdHttp) then
  begin
    fIdHttp := TIdHTTP.Create(nil);
    fIdHttp.ConnectTimeout:= 3000;
    fIdHttp.ReadTimeout := 2000; //ʵ��Ϊ��ֵ��3��
    fIdHttp.Request.ContentType := 'multipart/form-data' ;
  end;

  inherited Create (false);
  FreeOnTerminate := True;
end;

destructor TUploadThread.Destroy;
begin
  if Assigned(fIdHttp) then
  begin
    fIdHttp.Disconnect;
    FreeAndNil(fIdHttp);
  end;

  inherited;
end;

procedure TUploadThread.HandlingEnd();
begin
  if Assigned(self.fUploadCallback) then
    self.fUploadCallback(fLink.Trim, fIndex);
end;

function TUploadThread.HandlingUpload: string;
var
  aMultiStream: TIdMultiPartFormDataStream;
begin
  if (fStream=nil) and (not FileExists(fFileName)) then begin
    result:= '';
    exit;
  end;

  try
    aMultiStream:= TIdMultiPartFormDataStream.Create;
    try
      if fFileName<>'' then
        aMultiStream.AddFile('file', fFileName)
      else begin
        aMultiStream.AddFormField('file', '',' ', fStream, FormatDateTime('yyyymmddhhMMss',Now())+'.jpg');
      end;
      result:= fIdHttp.Post(fUrl, aMultiStream);
    except
    end;
  finally
    FreeAndNil(aMultiStream);
  end;
end;

procedure TUploadThread.Execute;
begin
  fLink:= HandlingUpload();
  Synchronize(HandlingEnd);
end;

//------------------------------------------------------------------------------
{
  ���ã�httpget��������
  ������Url��ַ
  ����: �ַ���
}
function httpGet(const aUrl: String=''):String;
var
  fIdHttp: TDPFHttp;
begin
  result := '{"posts":[]}';
  try
    fIdHttp := TDPFHttp.Create(nil);
    fIdHttp.ConnectionTimeout := 5000;
    try
      {$IFDEF IOS}
      result:= fIdHttp.GetUrlContentString( aUrl, [BuildHeaderRecord( 'content-type', 'application/json' ), BuildHeaderRecord( 'Accept', 'application/json' )], false );
      {$ENDIF}
    except
      result := '{"posts":[]}';
    end;
  finally
    fIdHttp.FreeOnRelease;
  end;
end;

{
  ���ã�httpPost��������
  ������httpʵ����Url��ַ
  ����: �ַ���
}
function httpPost(const AUrl: String='';const AParams:TStream=nil):String;
var reponseStr:String;
    fIdHttp:TIdHTTP;
begin
  if (AUrl='') then begin //urlΪ�� ���˳�
    result:= '';
    exit;
  end;

  reponseStr:= '';
  try
    fIdHttp:= TIdHTTP.Create(nil);
    fIdHttp.ConnectTimeout:= 3000;
    fIdHttp.ReadTimeout := 2000; //ʵ��Ϊ��ֵ��3��
    fIdHttp.Request.ContentType := 'application/x-www-form-urlencoded';
    try
      reponseStr:= fIdHttp.Post(AUrl,AParams);  //��ȡhttp�ַ���
    except
      reponseStr:= '';
    end;
  finally
    fIdHttp.Disconnect;
    FreeAndNil(fIdHttp);
  end;
  result:= reponseStr;
end;

{
  ���ã��ϴ�ͼƬ����
  ������AUrl��ַ�� ALocalPath��Ҫ�ļ�·��
  ����: �����ļ�·������
}
function uploadFIle(AUrl:String; const AFileName: string; const AStream: TStream): String;
var
  fIdHttp: TIdHttp;
  fMultiStream: TIdMultiPartFormDataStream;
begin
  result:= '';
  if (AStream=nil) and (not FileExists(AFileName)) then begin
    exit;
  end;

  try
    fIdHttp := TIdHTTP.Create(nil);
    fIdHttp.ConnectTimeout:= 3000;
    fIdHttp.ReadTimeout := 2000; //ʵ��Ϊ��ֵ��3��
    fIdHttp.Request.ContentType := 'multipart/form-data' ;
    fMultiStream:= TIdMultiPartFormDataStream.Create;
    try
      if AFileName<>'' then
        fMultiStream.AddFile('file', AFileName)
      else begin
        fMultiStream.AddFormField('file', '',' ', AStream, FormatDateTime('yyyymmddhhMMss',Now())+'.jpg');
      end;
      result:= fIdHttp.Post(aUrl, fMultiStream);
    except
      result:= '';
    end;
  finally
    fIdHttp.Disconnect;
    FreeAndNil(fIdHttp);
    FreeAndNil(fMultiStream);
  end;
end;

{
  ���ã��ֿ�ϵ���������
  ������AUrl��ַ�� ALocalPath��Ҫ�ļ�·��
  ����: �����ļ�·������
}
function downFile(AUrl:String;const ALocalPath:String):String;
var
  fIdHttp: TIdHttp;
  MemStream: TMemoryStream;
  DFileName: string;
  FilePosition: int64;
  FileSize: integer;
begin
  DFileName := UrlParams('picture=',AUrl);

  //�����ص�ַת��Ϊ�����ļ���
  while pos('/',DFileName) > 0 do
  begin
    delete(DFileName, 1, pos('/',DFileName));
  end;

  if DFileName = '' then begin
    result:= DFileName;
    exit;
  end;

  DFileName:= ALocalPath + DFileName;
  if FileExists(DFileName) then begin
    result:= DFileName;
    exit;
  end;

  MemStream := TMemoryStream.Create;
  fIdHttp := TIdHttp.Create(nil);
  try
    fIdHttp.ProtocolVersion := pv1_1;
    fIdHttp.ConnectTimeout := 3000;
    fIdHttp.ReadTimeout := 2000; //ʵ��Ϊ��ֵ��3��
    fIdHttp.HandleRedirects := true;
    fIdHttp.HTTPOptions := [hoInProcessAuth,hoForceEncodeParams,hoNoParseMetaHTTPEquiv,hoNoProtocolErrorException];
    //��ȡ�ض��������ص�ַ���ļ���С
    try
      fIdHttp.Head(AUrl);
      FileSize := fIdHttp.Response.ContentLength;
      FilePosition := 0;

      if FileExists(ALocalPath + DFileName) then
      begin
        try
          MemStream.LoadFromFile(DFileName);
          MemStream.Seek(0, soFromEnd);
          FilePosition := MemStream.Size;
        except
          MemStream.Free;
          result:= '';
          exit;
        end;
      end;

      while FilePosition < FileSize do
      begin
        //����1
        //IdHttp.Response.ContentRangeStart := FilePosition;
        //IdHttp.Response.ContentRangeEnd   := FilePosition + 1024;
        //����2
        fIdHttp.Request.Range := IntToStr(FilePosition) + '-' ;
        if FilePosition + 10240 < FileSize then
          fIdHttp.Request.Range := fIdHttp.Request.Range + IntToStr(FilePosition + 10239);

        fIdHttp.get(fIdHttp.URL.URI, MemStream);
        //MemStream.LoadFromStream(IdHttp.Response.ContentStream);
        //�����ļ�
        MemStream.SaveToFile(DFileName);
        //���óߴ�
        FilePosition := MemStream.Size;
      end;
    except
      DFileName:= '';//����
    end;
  finally
    fIdHttp.Disconnect;
    FreeAndNil(fIdHttp);
    MemStream.Free;
  end;
  result:= DFileName;
end;


end.
