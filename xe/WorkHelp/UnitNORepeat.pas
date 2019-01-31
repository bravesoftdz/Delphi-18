unit UnitNORepeat;
//�������ô˵�Ԫ���ܷ�ֹͬʱ���ֶ��ʵ��unit MultInst;

interface

uses
 Windows ,Messages, SysUtils, Classes, Forms;

implementation

const
 STR_UNIQUE    = '{2BE6D96E-827F-4BF9-B33E-8740412CDE96}';
 MI_ACTIVEAPP  = 1;  {����Ӧ�ó���}
 MI_GETHANDLE  = 2;  {ȡ�þ��}

var
 iMessageID    : Integer;
 OldWProc      : TFNWndProc;
 MutHandle     : THandle;
 BSMRecipients : DWORD;

function NewWndProc(Handle: HWND; Msg: Integer; wParam, lParam: Longint):
 Longint; stdcall;
var
 FormHandle :THandle;
begin
 Result := 0;
 if Msg = iMessageID then
 begin
   case wParam of
     MI_ACTIVEAPP: {����Ӧ�ó���}
       if lParam<>0 then
       begin
         {�յ���Ϣ�ļ���ǰһ��ʵ��}
         {ΪʲôҪ����һ�������м���?}
         {��Ϊ��ͬһ��������SetForegroundWindow�����ܰѴ����ᵽ��ǰ}
         //�ж��Ƿ���С��
         if IsIconic(lParam) then
         begin
           OpenIcon(lParam);
           SendMessage(lParam,WM_SYSCOMMAND,SC_MAXIMIZE ,SC_SCREENSAVE)
         end
         //������������� ����
         else if not IsWindowVisible(lParam) then
         begin
            FormHandle := GetWindow(lParam, GW_Child);
            ShowWindow(lParam, SW_SHOW);
            ShowWindow(FormHandle, SW_SHOW);
         end
         else
           SetForegroundWindow(lParam);
           Application.Terminate; {��ֹ��ʵ��}
       end;
     MI_GETHANDLE: {ȡ�ó�����}
       begin
         PostMessage(HWND(lParam), iMessageID, MI_ACTIVEAPP,
           Application.Handle);
       end;
   end;
 end
 else
   Result := CallWindowProc(OldWProc, Handle, Msg, wParam, lParam);
end;

procedure InitInstance;
begin
 {ȡ��Ӧ�ó������Ϣ����}
 OldWProc    := TFNWndProc(SetWindowLong(Application.Handle, GWL_WNDPROC,
   Longint(@NewWndProc)));

 {�򿪻������}
 MutHandle := OpenMutex(MUTEX_ALL_ACCESS, False, STR_UNIQUE);
 if MutHandle = 0 then
 begin
   {�����������}
   MutHandle := CreateMutex(nil, False, STR_UNIQUE);
 end
 else begin
   Application.ShowMainForm  :=  False;
   {�Ѿ��г���ʵ��,�㲥��Ϣȡ��ʵ�����}
   BSMRecipients := BSM_APPLICATIONS;
   BroadCastSystemMessage(BSF_IGNORECURRENTTASK or BSF_POSTMESSAGE,
       @BSMRecipients, iMessageID, MI_GETHANDLE,Application.Handle);
 end;
end;

initialization
 {ע����Ϣ}
 iMessageID  := RegisterWindowMessage(STR_UNIQUE);
 InitInstance;

finalization
 {��ԭ��Ϣ�������}
 if OldWProc <> Nil then
   SetWindowLong(Application.Handle, GWL_WNDPROC, LongInt(OldWProc));

 {�رջ������}
 if MutHandle <> 0 then CloseHandle(MutHandle);

end.


