
{*******************************************************}
{                                                       }
{       ϵͳ���� FTP�ͻ�����                            }
{       ��Ȩ����  �ɺ�����                              }
{       ��Ԫ���� UFTPServer.pas                         }
{       ��Ԫ���� ��Delphi 2006��TIdFTPServerFTP������   }
{                                                       }
{*******************************************************}



unit UFtpClient;
interface

uses
 windows,IdFTP,IdComponent,SysUtils,IdFTPCommon,Classes,IdGlobal,Dialogs,ComCtrls,Forms,msxml,winsock, strutils;


{-------------------------------------------------------------------------------
  ����:  �Զ�����Ϣ�������봰�������Ϣ����
-------------------------------------------------------------------------------}
type
  TFtpNotifyEvent = procedure (ADatetime: TDateTime;AUserIP, AEventMessage: string) of object;

type
{-------------------------------------------------------------------------------
  ����:  FTP�ͻ�����
-------------------------------------------------------------------------------}
 TFtpClientMy = class
 private
  FMachineName, FUsername, FPassword, FIP :string;
  Fport: integer;
  FHadTransSize: Int64;  // FHadTransSize �Ѿ��ϴ����ļ���С
  FProgresPostion: Int64;
  FIdFTP1: TIdFTP;
  FAbortTrans,FFtpPassive: Boolean;                  //�Ƿ��ж��ϴ�  �Ƿ񱻶�ģʽ
  Fputfilename: string;
  FOnFtpNotifyEvent: TFtpNotifyEvent;
  procedure FTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
  procedure FTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;  AWorkCountMax: Integer);
  procedure IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;  AWorkCount: Integer);
 public
  FProgressBar : ^TProgressBar;
  constructor Create;
  destructor Destroy; override;
  function  DeCompression():Boolean;
  function  FtpPut(srcname, Targetname: string;Bresume: boolean= False):Boolean;
  procedure FtpGet(srcname,Targetname:string; Bresume:boolean= False);
  function  FtpConnect(Bconnect :Boolean= True): boolean;
  property  AbortTrans: Boolean read  FAbortTrans write FAbortTrans;
  property  FtpUsername: string read  FUsername write FUsername;
  property  FtpPassword: string read  FPassword write FPassword;
  property  FtpIP: string read  FIP write FIP;
  property  Ftpport: Integer read  Fport write Fport;
  property  HadTransSize: Int64 read  FHadTransSize write FHadTransSize;
  property  OnFtpNotifyEvent: TFtpNotifyEvent read FOnFtpNotifyEvent write FOnFtpNotifyEvent;
  property  FtpMachineName: string read  FMachineName write FMachineName;
  property  FtpPassive: Boolean read FFtpPassive write FFtpPassive;
 end;


// function HostToIP(Name: string; Ip: string): Boolean;
function HostToIP(Name: string; Ip: integer): Boolean;






implementation


function MakeFileList(Path,FileExt:string):TStringList ;
var
sch:TSearchrec;
begin
Result:=TStringlist.Create;

if rightStr(trim(Path), 1) <> '\' then
    Path := trim(Path) + '\'
else
    Path := trim(Path);

if not DirectoryExists(Path) then
begin
    Result.Clear;
    exit;
end;

if FindFirst(Path + '*', faAnyfile, sch) = 0 then
begin
    repeat
       if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
       if DirectoryExists(Path+sch.Name) then
       begin
         Result.AddStrings(MakeFileList(Path+sch.Name,FileExt));
       end
       else
       begin
         if (UpperCase(extractfileext(Path+sch.Name)) = UpperCase(FileExt)) or (FileExt='.*') then
         Result.Add(Path+sch.Name);
       end;
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
end;
end;


//hosttoip ���������ǽ�����������ip
function HostToIP(Name: string; Ip: integer): Boolean;
var
  wsdata : TWSAData;
  hostName : array [0..255] of char;
  hostEnt : PHostEnt;
  addr : PChar;
  Pip : pstring;
begin
  WSAStartup ($0101, wsdata);
  try
    gethostname (pansichar(hostName), sizeof (hostName));
    StrPCopy(hostName, Name);
    hostEnt := gethostbyname (hostName);
    if Assigned (hostEnt) then
      if Assigned (hostEnt^.h_addr_list) then begin
        addr := hostEnt^.h_addr_list^;
        if Assigned (addr) then begin
          pip := pstring(Ip);
          pip^ :=Format ('%d.%d.%d.%d', [byte (addr [0]),
          byte (addr [1]), byte (addr [2]), byte (addr [3])]);
//          IP := Format ('%d.%d.%d.%d', [byte (addr [0]),
//          byte (addr [1]), byte (addr [2]), byte (addr [3])]);
          Result := True;
        end
        else
          Result := False;
      end
      else
        Result := False
    else begin
      Result := False;
    end;
  finally
    WSACleanup;
  end
end;


{ TFtpClient }

function TFtpClientMy.FtpPut(srcname, Targetname: string;Bresume: boolean):Boolean;
const
  SenderBuffer = 1024*1024;
var
  Tempfs : TFileStream;
  TempMS : TMemoryStream;
  BtempGo :Boolean;
begin
  Result := false;
  if not FtpConnect() then Exit;;
  Result := True;
  BtempGo := False;
  if Assigned(FProgressBar) then  FProgresPostion :=  FProgressBar.Position;
  Tempfs := TFileStream.Create(srcname, fmOpenRead);
  try
    Fputfilename := Utf8ToAnsi(srcname);
    //�ϵ�����ʱ ��������ʹ��
    FHadTransSize := FIdFTP1.Size(Targetname);
    FIdFTP1.TransferType := ftBinary;
    Bresume := (FHadTransSize <> -1);
//    if Assigned(FProgressBar) then
//    begin
//       TProgressBar(FProgressBar^).Max := Tempfs.Size;
//       TProgressBar(FProgressBar^).Position := 0;
//    end;
    if Bresume then
    begin
//     ShowMessage('�ϵ�');
     Tempfs.Seek(FHadTransSize, soFromBeginning);
     TempMS := TMemoryStream.Create;
      try
        while Tempfs.Position < Tempfs.Size do
        begin
          TempMS.Clear;
          TempMS.CopyFrom(Tempfs, Min(SenderBuffer, Tempfs.Size -Tempfs.Position));
          FIdFTP1.Put(TempMS,Targetname,True);
//          FHadTransSize := FIdFTP1.Size(Targetname);
          BtempGo := True;
        end ;
        if not BtempGo then
        begin
         if Assigned(FOnFtpNotifyEvent) then
          OnFtpNotifyEvent(Now, FIdFTP1.Host,'�ϴ��ļ��Ѵ���[' + srcname + ']')
        end
        else
         if Assigned(FOnFtpNotifyEvent) then
          OnFtpNotifyEvent(Now, FIdFTP1.Host,'�ϴ��ļ��Ѵ���, �Զ��ϵ������ɹ�[' + srcname + ']')
      except
        if Assigned(FOnFtpNotifyEvent) then
         OnFtpNotifyEvent(Now, FIdFTP1.Host,'�ϴ��ļ��Ѵ���, �Զ��ϵ�����ʧ��[' + srcname + ']');
        TempMS.Free;
        Result := False;
      end;
    end
    else
    begin
     FHadTransSize := 0;
     try
      FIdFTP1.Put(Tempfs, Targetname);
      if Assigned(FOnFtpNotifyEvent) then
         OnFtpNotifyEvent(Now, FIdFTP1.Host,'�ϴ��ļ��ɹ�[' + srcname + ']');
     except
      if Assigned(FOnFtpNotifyEvent) then
         OnFtpNotifyEvent(Now, FIdFTP1.Host,'�ϴ��ļ�ʧ��[' + srcname + ']');
      Result := False;
     end;
    end;
   finally
    Tempfs.Free;
  end;
end;


//���غ���
procedure TFtpClientMy.FtpGet(srcname,Targetname:string; Bresume:boolean);
var
  TempFs: TFileStream;
begin
  if not FtpConnect() then Exit;;
  if FileExists(Targetname) then
   TempFs := TFileStream.Create(Targetname, 1)
  else
   TempFs := TFileStream.Create(Targetname, 65535);
  try
//    ShowMessage(srcname + '�ļ���С' +IntToStr(FTP1.Size(srcname)));
//    pb1.Max := IdFTP1.Size(IdFTP1.RetrieveCurrentDir + srcname) ;
    FHadTransSize := 0;
    if Bresume then
    begin
      TempFs.Position := TempFs.Size;
      FHadTransSize := TempFs.Size;
      FIdFTP1.TransferType := ftBinary;
      FIdFTP1.Get(srcname,TempFs,True);
    end else
      FIdFTP1.get(srcname,TempFs,False);
  finally
    TempFs.Free;
  end;
end;



function TFtpClientMy.FtpConnect(Bconnect :Boolean): boolean;
begin
 Result := False;
 if Bconnect then
 begin
   with FIdFTP1 do
   begin
     if not Connected then
     begin
       try
          Username:=FtpUsername;
          Password:=FtpPassword;
          Host:=Ftpip;
          Port:= Ftpport;
          TransferType := ftASCII;
          passive := FtpPassive;
          Connect;
          Result := true;
       except
          Result := false;
//          MessageBox(0, PChar(Ftpip + '�޷�����'),'����',MB_ICONWARNING + MB_TASKMODAL);
          Abort;
       end;
     end
     else
       Result := true;
   end;
 end
end;


//procedure TFtpClientForm.IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Integer);
procedure TFtpClientMy.IdFTP1Work(Sender: TObject; AWorkMode: TWorkMode;  AWorkCount: Integer);
begin

  try
    Application.ProcessMessages;
    if AbortTrans then  TIdFTP(Sender).Abort;
//    HadTransSize := HadTransSize +  AWorkCount;
    if Assigned(FProgressBar) then
    begin
//       TProgressBar(FProgressBar^).Position :=  TProgressBar(FProgressBar^).Position +  AWorkCount;
       TProgressBar(FProgressBar^).Position :=  FProgresPostion + AWorkCount;
//       showmessage(IntToStr(TProgressBar(FProgressBar^).Position) + ' : ' + IntToStr(AWorkCount));
    end;
  except
    on E:Exception do
    begin
      MessageBox(0,'�ϴ�����,����ϵ�����Ա','����',MB_ICONEXCLAMATION);
    end;
  end;
end;



procedure TFtpClientMy.FTPWorkBegin(Sender: TObject; AWorkMode: TWorkMode;  AWorkCountMax: Integer);
begin
 AbortTrans := False;
end;


procedure TFtpClientMy.FTPWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  AbortTrans := False;
end;


constructor TFtpClientMy.Create;
begin
 FIdFTP1 := TIdFTP.Create(nil);
 with FIdFTP1 do
 begin
   OnWork := IdFTP1Work;
   OnWorkEnd := FTPWorkEnd;
   OnWorkBegin:= FTPWorkBegin;
 end;
  HadTransSize := 0;

end;


function TFtpClientMy.DeCompression: Boolean;
begin
  Result:= False;
  if FtpConnect() then
  begin
     case FIdFTP1.SendCmd('DecomPress') of
       731:  // 731����ʧ��
       begin
         if Assigned(FOnFtpNotifyEvent) then  OnFtpNotifyEvent(Now,FIdFTP1.Host,'��ѹ�ļ�ʧ��[' + Fputfilename + ']');
         begin
          Result := False;
         end;
       end;
       137:
       begin
         if Assigned(FOnFtpNotifyEvent) then  OnFtpNotifyEvent(Now,FIdFTP1.Host,'��ѹ�ļ��ɹ�[' + Fputfilename + ']');
         begin
          Result := True;
         end;
       end
     else
      Result := True;
     end;
  end;
end;

destructor TFtpClientMy.Destroy;
begin
  if FtpConnect() then  FIdFTP1.Abort;
    FIdFTP1.Disconnect;
    FIdFTP1.Free;
  if Assigned(FProgressBar) then  FProgressBar := nil;
  inherited destroy;
end;

end.
