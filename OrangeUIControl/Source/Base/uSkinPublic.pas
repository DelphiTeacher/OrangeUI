//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     皮肤公共
///   </para>
///   <para>
///     Skin public
///   </para>
/// </summary>
unit uSkinPublic;

interface
{$I FrameWork.inc}


uses
  Classes,
  SysUtils,

  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  Graphics,
  {$ENDIF}
  {$IFDEF FMX}
  Types,
  UITypes,
  FMX.Types,
  {$ENDIF}


  uDrawCanvas,
  uFuncCommon,
  uGraphicCommon;




{$IFDEF VCL}

const
  //非客户区事件
  WM_NCUAHDRAWCAPTION =$00AE;
  WM_NCUAHDRAWFRAME   =$00AF;
  WM_SYNCPAINT        =$0088;
  CM_RePaintInFormNCMessage     = $0400+1001;
  CM_InvalidateInParentWMSize   = $0400+1002;

procedure DebugMessage(Message:TMessage);

//绘制控件透明背景
procedure DrawParent(AControl: TControl; DC: HDC;
                    ALeft,ATop,AWidth,AHeight:Integer;
                    AParentLeft,AParentTop:Integer);
{$ENDIF}




implementation




{$IFDEF VCL}
procedure DrawParent(AControl: TControl; DC: HDC;
                    ALeft,ATop,AWidth,AHeight:Integer;
                    AParentLeft,AParentTop:Integer);
var
  P: TPoint;
  SaveIndex: Integer;
  ParentClientCanvas:TDrawCanvas;
//  TransparentControlIntf: ITransparentControl;
begin
  ParentClientCanvas:=nil;
  if Not (csDesigning in AControl.ComponentState) then
  begin
//    AControl.Parent.GetInterface(IID_ITransparentControl, TransparentControlIntf);
//    if TransparentControlIntf <> nil then
//    begin
//      ParentClientCanvas:=TransparentControlIntf.GetSubControlBackGroundCanvas;
//      if ParentClientCanvas<>nil then
//      begin
//        StretchBlt(DC, ALeft, ATop, AWidth, AHeight,
//              ParentClientCanvas.Handle, AControl.Left+AParentLeft+ALeft, AControl.Top+AParentLeft+ATop,
//              AWidth, AHeight,
//              SRCCOPY);
//      end;
//    end;
//    if ParentClientDC=0 then
//    begin
//      SaveIndex := SaveDC(DC);
//      GetViewportOrgEx(DC, P);
//      SetViewportOrgEx(DC, P.X - AControl.Left, P.Y - AControl.Top, nil);
//      IntersectClipRect(DC, 0, 0, AControl.Parent.Width, AControl.Parent.Height);
//
//      AControl.Parent.Perform(WM_ERASEBKGND, DC, 0);
//
//      AControl.Parent.Perform(WM_PrintClient, DC, prf_Client);
//      RestoreDC(DC, SaveIndex);

//      SaveIndex := SaveDC(DC);
//      GetViewportOrgEx(DC, P);
//      SetViewportOrgEx(DC, P.X - AControl.Left-AParentLeft-ALeft, P.Y - AControl.Top-AParentLeft-ATop, nil);
//      IntersectClipRect(DC, ALeft, ATop,AWidth,AHeight);
//      AControl.Parent.Perform(WM_ERASEBKGND, DC, 0);
//      AControl.Parent.Perform(WM_PrintClient, DC, prf_Client);
//      RestoreDC(DC, SaveIndex);
//    end;
  end;

  if (csDesigning in AControl.ComponentState) or (ParentClientCanvas=nil) then
  begin
    SaveIndex := SaveDC(DC);
    GetViewportOrgEx(DC, P);
    SetViewportOrgEx(DC, P.X - AControl.Left, P.Y - AControl.Top, nil);
    IntersectClipRect(DC, 0, 0, AControl.Parent.Width, AControl.Parent.Height);
    AControl.Parent.Perform(WM_ERASEBKGND, DC, 0);
    AControl.Parent.Perform(WM_PrintClient, DC, prf_Client);
    RestoreDC(DC, SaveIndex);
  end;


end;

{$ENDIF}


//function CursorInWindow(WindowHandle:HWND):Boolean;
//var
//  CursorPos:TPoint;
//  WindowRect:TRect;
//begin
//  Result:=False;
//  if GetCursorPos(CursorPos) then
//  begin
//    if GetWindowRect(WindowHandle,WindowRect) then
//    begin
//      if PtInRect(WindowRect,CursorPos) then
//      begin
//        Result:=True;
//      end;
//    end;
//  end;
//end;



//{$Region '调试输出消息常量字符串'}
{$IFDEF VCL}
//调试输出消息常量字符串
procedure DebugMessage(Message:TMessage);
var
  tmpMessageStr:WideString;
begin
  case Message.Msg of
    WM_NULL:
    begin
      tmpMessageStr:='WM_NULL';
    end;
    WM_CREATE:
    begin
      tmpMessageStr:='WM_CREATE';
    end;
    WM_DESTROY:
    begin
      tmpMessageStr:='WM_DESTROY';
    end;
    WM_MOVE:
    begin
      tmpMessageStr:='WM_MOVE';
    end;
    WM_SIZE:
    begin
      tmpMessageStr:='WM_SIZE';
    end;
    WM_ACTIVATE:
    begin
      tmpMessageStr:='WM_ACTIVATE';
    end;
    WM_SETFOCUS:
    begin
      tmpMessageStr:='WM_SETFOCUS';
    end;
    WM_KILLFOCUS:
    begin
      tmpMessageStr:='WM_KILLFOCUS';
    end;
    WM_ENABLE:
    begin
      tmpMessageStr:='WM_ENABLE';
    end;
    WM_SETREDRAW:
    begin
      tmpMessageStr:='WM_SETREDRAW';
    end;
    WM_SETTEXT:
    begin
      tmpMessageStr:='WM_SETTEXT';
    end;
    WM_GETTEXT:
    begin
      tmpMessageStr:='WM_GETTEXT';
    end;
    WM_GETTEXTLENGTH:
    begin
      tmpMessageStr:='WM_GETTEXTLENGTH';
    end;
    WM_PAINT:
    begin
      tmpMessageStr:='WM_PAINT';
    end;
    WM_CLOSE:
    begin
      tmpMessageStr:='WM_CLOSE';
    end;
    WM_QUERYENDSESSION:
    begin
      tmpMessageStr:='WM_QUERYENDSESSION';
    end;
    WM_QUIT:
    begin
      tmpMessageStr:='WM_QUIT';
    end;
    WM_QUERYOPEN:
    begin
      tmpMessageStr:='WM_QUERYOPEN';
    end;
    WM_ERASEBKGND:
    begin
      tmpMessageStr:='WM_ERASEBKGND';
    end;
    WM_SYSCOLORCHANGE:
    begin
      tmpMessageStr:='WM_SYSCOLORCHANGE';
    end;
    WM_ENDSESSION:
    begin
      tmpMessageStr:='WM_ENDSESSION';
    end;
    WM_SYSTEMERROR:
    begin
      tmpMessageStr:='WM_SYSTEMERROR';
    end;
    WM_SHOWWINDOW:
    begin
      tmpMessageStr:='WM_SHOWWINDOW';
    end;
    WM_CTLCOLOR:
    begin
      tmpMessageStr:='WM_CTLCOLOR';
    end;
    WM_WININICHANGE:
    begin
      tmpMessageStr:='WM_WININICHANGE';
    end;
//    WM_SETTINGCHANGE:
//    begin
//      tmpMessageStr:='WM_SETTINGCHANGE';
//    end;
    WM_DEVMODECHANGE:
    begin
      tmpMessageStr:='WM_DEVMODECHANGE';
    end;
    WM_ACTIVATEAPP:
    begin
      tmpMessageStr:='WM_ACTIVATEAPP';
    end;
    WM_FONTCHANGE:
    begin
      tmpMessageStr:='WM_FONTCHANGE';
    end;
    WM_TIMECHANGE:
    begin
      tmpMessageStr:='WM_TIMECHANGE';
    end;
    WM_CANCELMODE:
    begin
      tmpMessageStr:='WM_CANCELMODE';
    end;
//    WM_SETCURSOR:
//    begin
//      tmpMessageStr:='WM_SETCURSOR';
//    end;
    WM_MOUSEACTIVATE:
    begin
      tmpMessageStr:='WM_MOUSEACTIVATE';
    end;
    WM_CHILDACTIVATE:
    begin
      tmpMessageStr:='WM_CHILDACTIVATE';
    end;
    WM_QUEUESYNC:
    begin
      tmpMessageStr:='WM_QUEUESYNC';
    end;
    WM_GETMINMAXINFO:
    begin
      tmpMessageStr:='WM_GETMINMAXINFO';
    end;
    WM_PAINTICON:
    begin
      tmpMessageStr:='WM_PAINTICON';
    end;
    WM_ICONERASEBKGND:
    begin
      tmpMessageStr:='WM_ICONERASEBKGND';
    end;
    WM_NEXTDLGCTL:
    begin
      tmpMessageStr:='WM_NEXTDLGCTL';
    end;
    WM_SPOOLERSTATUS:
    begin
      tmpMessageStr:='WM_SPOOLERSTATUS';
    end;
    WM_DRAWITEM:
    begin
      tmpMessageStr:='WM_DRAWITEM';
    end;
    WM_MEASUREITEM:
    begin
      tmpMessageStr:='WM_MEASUREITEM';
    end;
    WM_DELETEITEM:
    begin
      tmpMessageStr:='WM_DELETEITEM';
    end;
    WM_VKEYTOITEM:
    begin
      tmpMessageStr:='WM_VKEYTOITEM';
    end;
    WM_CHARTOITEM:
    begin
      tmpMessageStr:='WM_CHARTOITEM';
    end;
    WM_SETFONT:
    begin
      tmpMessageStr:='WM_SETFONT';
    end;
    WM_GETFONT:
    begin
      tmpMessageStr:='WM_GETFONT';
    end;
    WM_SETHOTKEY:
    begin
      tmpMessageStr:='WM_SETHOTKEY';
    end;
    WM_GETHOTKEY:
    begin
      tmpMessageStr:='WM_GETHOTKEY';
    end;
    WM_QUERYDRAGICON :
    begin
      tmpMessageStr:='WM_QUERYDRAGICON';
    end;
    WM_COMPAREITEM:
    begin
      tmpMessageStr:='WM_COMPAREITEM';
    end;
    WM_GETOBJECT:
    begin
      tmpMessageStr:='WM_GETOBJECT';
    end;
    WM_COMPACTING:
    begin
      tmpMessageStr:='WM_COMPACTING';
    end;
    WM_COMMNOTIFY:
    begin
      tmpMessageStr:='WM_COMMNOTIFY';
    end;
    WM_WINDOWPOSCHANGING:
    begin
      tmpMessageStr:='WM_WINDOWPOSCHANGING';
    end;
    WM_WINDOWPOSCHANGED:
    begin
      tmpMessageStr:='WM_WINDOWPOSCHANGED';
    end;
    WM_POWER:
    begin
      tmpMessageStr:='WM_POWER';
    end;
    WM_COPYDATA:
    begin
      tmpMessageStr:='WM_COPYDATA';
    end;
    WM_CANCELJOURNAL:
    begin
      tmpMessageStr:='WM_CANCELJOURNAL';
    end;
    WM_NOTIFY:
    begin
      tmpMessageStr:='WM_NOTIFY';
    end;
    WM_INPUTLANGCHANGEREQUEST:
    begin
      tmpMessageStr:='WM_INPUTLANGCHANGEREQUEST';
    end;
    WM_INPUTLANGCHANGE:
    begin
      tmpMessageStr:='WM_INPUTLANGCHANGE';
    end;
    WM_TCARD:
    begin
      tmpMessageStr:='WM_TCARD';
    end;
    WM_HELP:
    begin
      tmpMessageStr:='WM_HELP';
    end;
    WM_USERCHANGED:
    begin
      tmpMessageStr:='WM_USERCHANGED';
    end;
    WM_NOTIFYFORMAT:
    begin
      tmpMessageStr:='WM_NOTIFYFORMAT';
    end;
    WM_CONTEXTMENU:
    begin
      tmpMessageStr:='WM_CONTEXTMENU';
    end;
    WM_STYLECHANGING:
    begin
      tmpMessageStr:='WM_STYLECHANGING';
    end;
    WM_STYLECHANGED:
    begin
      tmpMessageStr:='WM_STYLECHANGED';
    end;
    WM_DISPLAYCHANGE:
    begin
      tmpMessageStr:='WM_DISPLAYCHANGE';
    end;
//    WM_GETICON:
//    begin
//      tmpMessageStr:='WM_GETICON';
//    end;
    WM_SETICON:
    begin
      tmpMessageStr:='WM_SETICON';
    end;

    WM_NCCREATE:
    begin
      tmpMessageStr:='WM_NCCREATE';
    end;
    WM_NCDESTROY:
    begin
      tmpMessageStr:='WM_NCDESTROY';
    end;
    WM_NCCALCSIZE:
    begin
      tmpMessageStr:='WM_NCCALCSIZE';
    end;
//    WM_NCHITTEST:
//    begin
//      tmpMessageStr:='WM_NCHITTEST';
//    end;
    WM_NCPAINT:
    begin
      tmpMessageStr:='WM_NCPAINT';
    end;
    WM_NCACTIVATE:
    begin
      tmpMessageStr:='WM_NCACTIVATE';
    end;
    WM_GETDLGCODE:
    begin
      tmpMessageStr:='WM_GETDLGCODE';
    end;
//    WM_NCMOUSEMOVE:
//    begin
//      tmpMessageStr:='WM_NCMOUSEMOVE';
//    end;
    WM_NCLBUTTONDOWN:
    begin
      tmpMessageStr:='WM_NCLBUTTONDOWN';
    end;
    WM_NCLBUTTONUP:
    begin
      tmpMessageStr:='WM_NCLBUTTONUP';
    end;
    WM_NCLBUTTONDBLCLK:
    begin
      tmpMessageStr:='WM_NCLBUTTONDBLCLK';
    end;
    WM_NCRBUTTONDOWN:
    begin
      tmpMessageStr:='WM_NCRBUTTONDOWN';
    end;
    WM_NCRBUTTONUP:
    begin
      tmpMessageStr:='WM_NCRBUTTONUP';
    end;
    WM_NCRBUTTONDBLCLK:
    begin
      tmpMessageStr:='WM_NCRBUTTONDBLCLK';
    end;
    WM_NCMBUTTONDOWN:
    begin
      tmpMessageStr:='WM_NCMBUTTONDOWN';
    end;
    WM_NCMBUTTONUP:
    begin
      tmpMessageStr:='WM_NCMBUTTONUP';
    end;
    WM_NCMBUTTONDBLCLK:
    begin
      tmpMessageStr:='WM_NCMBUTTONDBLCLK';
    end;
    WM_NCXBUTTONDOWN:
    begin
      tmpMessageStr:='WM_NCXBUTTONDOWN';
    end;
    WM_NCXBUTTONUP:
    begin
      tmpMessageStr:='WM_NCXBUTTONUP';
    end;
    WM_NCXBUTTONDBLCLK:
    begin
      tmpMessageStr:='WM_NCXBUTTONDBLCLK';
    end;
    WM_INPUT_DEVICE_CHANGE:
    begin
      tmpMessageStr:='WM_INPUT_DEVICE_CHANGE';
    end;
    WM_INPUT:
    begin
      tmpMessageStr:='WM_INPUT';
    end;
    WM_KEYFIRST :
    begin
      tmpMessageStr:='WM_KEYFIRST';
    end;
//    WM_KEYDOWN :
//    begin
//      tmpMessageStr:='WM_KEYDOWN';
//    end;
    WM_KEYUP:
    begin
      tmpMessageStr:='WM_KEYUP';
    end;
    WM_CHAR:
    begin
      tmpMessageStr:='WM_CHAR';
    end;
    WM_DEADCHAR:
    begin
      tmpMessageStr:='WM_DEADCHAR';
    end;
    WM_SYSKEYDOWN :
    begin
      tmpMessageStr:='WM_SYSKEYDOWN';
    end;
    WM_SYSKEYUP :
    begin
      tmpMessageStr:='WM_SYSKEYUP';
    end;
    WM_SYSCHAR:
    begin
      tmpMessageStr:='WM_SYSCHAR';
    end;
    WM_SYSDEADCHAR:
    begin
      tmpMessageStr:='WM_SYSDEADCHAR';
    end;
    WM_UNICHAR:
    begin
      tmpMessageStr:='WM_UNICHAR';
    end;
//    WM_KEYLAST:
//    begin
//      tmpMessageStr:='WM_KEYLAST';
//    end;
    WM_INITDIALOG:
    begin
      tmpMessageStr:='WM_INITDIALOG';
    end;
    WM_COMMAND :
    begin
      tmpMessageStr:='WM_COMMAND';
    end;
    WM_SYSCOMMAND:
    begin
      tmpMessageStr:='WM_SYSCOMMAND';
    end;
    WM_TIMER:
    begin
      tmpMessageStr:='WM_TIMER';
    end;
    WM_HSCROLL:
    begin
      tmpMessageStr:='WM_HSCROLL';
    end;
    WM_VSCROLL:
    begin
      tmpMessageStr:='WM_VSCROLL';
    end;
    WM_INITMENU :
    begin
      tmpMessageStr:='WM_INITMENU';
    end;
    WM_INITMENUPOPUP:
    begin
      tmpMessageStr:='WM_INITMENUPOPUP';
    end;
    WM_GESTURE:
    begin
      tmpMessageStr:='WM_GESTURE';
    end;
    WM_GESTURENOTIFY :
    begin
      tmpMessageStr:='WM_GESTURENOTIFY';
    end;
    WM_MENUSELECT :
    begin
      tmpMessageStr:='WM_MENUSELECT';
    end;
    WM_MENUCHAR:
    begin
      tmpMessageStr:='WM_MENUCHAR';
    end;
    WM_ENTERIDLE:
    begin
      tmpMessageStr:='WM_ENTERIDLE';
    end;
    WM_MENURBUTTONUP:
    begin
      tmpMessageStr:='WM_MENURBUTTONUP';
    end;
    WM_MENUDRAG:
    begin
      tmpMessageStr:='WM_MENUDRAG';
    end;
    WM_MENUGETOBJECT:
    begin
      tmpMessageStr:='WM_MENUGETOBJECT';
    end;
    WM_UNINITMENUPOPUP:
    begin
      tmpMessageStr:='WM_UNINITMENUPOPUP';
    end;
    WM_MENUCOMMAND:
    begin
      tmpMessageStr:='WM_MENUCOMMAND';
    end;
    WM_CHANGEUISTATE:
    begin
      tmpMessageStr:='WM_CHANGEUISTATE';
    end;
    WM_UPDATEUISTATE:
    begin
      tmpMessageStr:='WM_UPDATEUISTATE';
    end;
    WM_QUERYUISTATE :
    begin
      tmpMessageStr:='WM_QUERYUISTATE';
    end;
    WM_CTLCOLORMSGBOX :
    begin
      tmpMessageStr:='WM_CTLCOLORMSGBOX';
    end;
    WM_CTLCOLOREDIT:
    begin
      tmpMessageStr:='WM_CTLCOLOREDIT';
    end;
    WM_CTLCOLORLISTBOX:
    begin
      tmpMessageStr:='WM_CTLCOLORLISTBOX';
    end;
    WM_CTLCOLORBTN:
    begin
      tmpMessageStr:='WM_CTLCOLORBTN';
    end;
    WM_CTLCOLORDLG:
    begin
      tmpMessageStr:='WM_CTLCOLORDLG';
    end;
    WM_CTLCOLORSCROLLBAR :
    begin
      tmpMessageStr:='WM_CTLCOLORSCROLLBAR';
    end;
    WM_CTLCOLORSTATIC:
    begin
      tmpMessageStr:='WM_CTLCOLORSTATIC';
    end;
//    WM_MOUSEFIRST:
//    begin
//      tmpMessageStr:='WM_MOUSEFIRST';
//    end;
//    WM_MOUSEMOVE:
//    begin
//      tmpMessageStr:='WM_MOUSEMOVE';
//    end;
    WM_LBUTTONDOWN:
    begin
      tmpMessageStr:='WM_LBUTTONDOWN';
    end;
    WM_LBUTTONUP:
    begin
      tmpMessageStr:='WM_LBUTTONUP';
    end;
    WM_LBUTTONDBLCLK:
    begin
      tmpMessageStr:='WM_LBUTTONDBLCLK';
    end;
    WM_RBUTTONDOWN:
    begin
      tmpMessageStr:='WM_RBUTTONDOWN';
    end;
    WM_RBUTTONUP :
    begin
      tmpMessageStr:='WM_RBUTTONUP';
    end;
    WM_RBUTTONDBLCLK :
    begin
      tmpMessageStr:='WM_RBUTTONDBLCLK';
    end;
    WM_MBUTTONDOWN:
    begin
      tmpMessageStr:='WM_MBUTTONDOWN';
    end;
    WM_MBUTTONUP:
    begin
      tmpMessageStr:='WM_MBUTTONUP';
    end;
    WM_MBUTTONDBLCLK :
    begin
      tmpMessageStr:='WM_MBUTTONDBLCLK';
    end;
    WM_MOUSEWHEEL:
    begin
      tmpMessageStr:='WM_MOUSEWHEEL';
    end;
    WM_XBUTTONDOWN:
    begin
      tmpMessageStr:='WM_XBUTTONDOWN';
    end;
    WM_XBUTTONUP:
    begin
      tmpMessageStr:='WM_XBUTTONUP';
    end;
    WM_XBUTTONDBLCLK :
    begin
      tmpMessageStr:='WM_XBUTTONDBLCLK';
    end;
    WM_MOUSEHWHEEL:
    begin
      tmpMessageStr:='WM_MOUSEHWHEEL';
    end;
//    WM_MOUSELAST:
//    begin
//      tmpMessageStr:='WM_MOUSELAST';
//    end;
    WM_PARENTNOTIFY:
    begin
      tmpMessageStr:='WM_PARENTNOTIFY';
    end;
    WM_ENTERMENULOOP:
    begin
      tmpMessageStr:='WM_ENTERMENULOOP';
    end;
    WM_EXITMENULOOP:
    begin
      tmpMessageStr:='WM_EXITMENULOOP';
    end;
    WM_NEXTMENU:
    begin
      tmpMessageStr:='WM_NEXTMENU';
    end;
    WM_SIZING:
    begin
      tmpMessageStr:='WM_SIZING';
    end;
    WM_CAPTURECHANGED:
    begin
      tmpMessageStr:='WM_CAPTURECHANGED';
    end;
    WM_MOVING:
    begin
      tmpMessageStr:='WM_MOVING';
    end;
    WM_POWERBROADCAST:
    begin
      tmpMessageStr:='WM_POWERBROADCAST';
    end;
    WM_DEVICECHANGE:
    begin
      tmpMessageStr:='WM_DEVICECHANGE';
    end;
    WM_IME_STARTCOMPOSITION:
    begin
      tmpMessageStr:='WM_IME_STARTCOMPOSITION';
    end;
    WM_IME_ENDCOMPOSITION :
    begin
      tmpMessageStr:='WM_IME_ENDCOMPOSITION';
    end;
    WM_IME_COMPOSITION:
    begin
      tmpMessageStr:='WM_IME_COMPOSITION';
    end;
//    WM_IME_KEYLAST:
//    begin
//      tmpMessageStr:='tmpMessageStr';
//    end;
    WM_IME_SETCONTEXT :
    begin
      tmpMessageStr:='WM_IME_SETCONTEXT';
    end;
    WM_IME_NOTIFY:
    begin
      tmpMessageStr:='WM_IME_NOTIFY';
    end;
    WM_IME_CONTROL:
    begin
      tmpMessageStr:='WM_IME_CONTROL';
    end;
    WM_IME_COMPOSITIONFULL:
    begin
      tmpMessageStr:='WM_IME_COMPOSITIONFULL';
    end;
    WM_IME_SELECT:
    begin
      tmpMessageStr:='WM_IME_SELECT';
    end;
    WM_IME_CHAR:
    begin
      tmpMessageStr:='WM_IME_CHAR';
    end;
    WM_IME_REQUEST:
    begin
      tmpMessageStr:='WM_IME_REQUEST';
    end;
    WM_IME_KEYDOWN:
    begin
      tmpMessageStr:='WM_IME_KEYDOWN';
    end;
    WM_IME_KEYUP:
    begin
      tmpMessageStr:='WM_IME_KEYUP';
    end;
    WM_MDICREATE:
    begin
      tmpMessageStr:='WM_MDICREATE';
    end;
    WM_MDIDESTROY:
    begin
      tmpMessageStr:='WM_MDIDESTROY';
    end;
    WM_MDIACTIVATE:
    begin
      tmpMessageStr:='WM_MDIACTIVATE';
    end;
    WM_MDIRESTORE:
    begin
      tmpMessageStr:='WM_MDIRESTORE';
    end;
    WM_MDINEXT:
    begin
      tmpMessageStr:='WM_MDINEXT';
    end;
    WM_MDIMAXIMIZE:
    begin
      tmpMessageStr:='WM_MDIMAXIMIZE';
    end;
    WM_MDITILE:
    begin
      tmpMessageStr:='WM_MDITILE';
    end;
    WM_MDICASCADE:
    begin
      tmpMessageStr:='WM_MDICASCADE';
    end;
    WM_MDIICONARRANGE:
    begin
      tmpMessageStr:='WM_MDIICONARRANGE';
    end;
    WM_MDIGETACTIVE:
    begin
      tmpMessageStr:='WM_MDIGETACTIVE';
    end;
    WM_MDISETMENU:
    begin
      tmpMessageStr:='WM_MDISETMENU';
    end;
    WM_ENTERSIZEMOVE:
    begin
      tmpMessageStr:='WM_ENTERSIZEMOVE';
    end;
    WM_EXITSIZEMOVE:
    begin
      tmpMessageStr:='WM_EXITSIZEMOVE';
    end;
    WM_DROPFILES:
    begin
      tmpMessageStr:='WM_DROPFILES';
    end;
    WM_MDIREFRESHMENU:
    begin
      tmpMessageStr:='WM_MDIREFRESHMENU';
    end;
    WM_TOUCH:
    begin
      tmpMessageStr:='WM_TOUCH';
    end;
    WM_MOUSEHOVER:
    begin
      tmpMessageStr:='WM_MOUSEHOVER';
    end;
    WM_MOUSELEAVE:
    begin
      tmpMessageStr:='WM_MOUSELEAVE';
    end;
    WM_NCMOUSEHOVER:
    begin
      tmpMessageStr:='WM_NCMOUSEHOVER';
    end;
    WM_NCMOUSELEAVE:
    begin
      tmpMessageStr:='WM_NCMOUSELEAVE';
    end;
    WM_WTSSESSION_CHANGE:
    begin
      tmpMessageStr:='WM_WTSSESSION_CHANGE';
    end;
    WM_TABLET_FIRST:
    begin
      tmpMessageStr:='WM_TABLET_FIRST';
    end;
    WM_TABLET_LAST:
    begin
      tmpMessageStr:='WM_TABLET_LAST';
    end;
    WM_CUT:
    begin
      tmpMessageStr:='WM_CUT';
    end;
    WM_COPY:
    begin
      tmpMessageStr:='WM_COPY';
    end;
    WM_PASTE:
    begin
      tmpMessageStr:='WM_PASTE';
    end;
    WM_CLEAR:
    begin
      tmpMessageStr:='WM_CLEAR';
    end;
    WM_UNDO:
    begin
      tmpMessageStr:='WM_UNDO';
    end;
    WM_RENDERFORMAT:
    begin
      tmpMessageStr:='WM_RENDERFORMAT';
    end;
    WM_RENDERALLFORMATS:
    begin
      tmpMessageStr:='WM_RENDERALLFORMATS';
    end;
    WM_DESTROYCLIPBOARD:
    begin
      tmpMessageStr:='WM_DESTROYCLIPBOARD';
    end;
    WM_DRAWCLIPBOARD:
    begin
      tmpMessageStr:='WM_DRAWCLIPBOARD';
    end;
    WM_PAINTCLIPBOARD:
    begin
      tmpMessageStr:='WM_PAINTCLIPBOARD';
    end;
    WM_VSCROLLCLIPBOARD:
    begin
      tmpMessageStr:='WM_VSCROLLCLIPBOARD';
    end;
    WM_SIZECLIPBOARD:
    begin
      tmpMessageStr:='WM_SIZECLIPBOARD';
    end;
    WM_ASKCBFORMATNAME:
    begin
      tmpMessageStr:='WM_ASKCBFORMATNAME';
    end;
    WM_CHANGECBCHAIN:
    begin
      tmpMessageStr:='WM_CHANGECBCHAIN';
    end;
    WM_HSCROLLCLIPBOARD:
    begin
      tmpMessageStr:='WM_HSCROLLCLIPBOARD';
    end;
    WM_QUERYNEWPALETTE:
    begin
      tmpMessageStr:='WM_QUERYNEWPALETTE';
    end;
    WM_PALETTEISCHANGING:
    begin
      tmpMessageStr:='WM_PALETTEISCHANGING';
    end;
    WM_PALETTECHANGED:
    begin
      tmpMessageStr:='WM_PALETTECHANGED';
    end;
    WM_HOTKEY:
    begin
      tmpMessageStr:='WM_HOTKEY';
    end;
    WM_PRINT:
    begin
      tmpMessageStr:='WM_PRINT';
    end;
    WM_PRINTCLIENT:
    begin
      tmpMessageStr:='WM_PRINTCLIENT';
    end;
    WM_APPCOMMAND:
    begin
      tmpMessageStr:='WM_APPCOMMAND';
    end;
    WM_THEMECHANGED:
    begin
      tmpMessageStr:='WM_THEMECHANGED';
    end;
    WM_CLIPBOARDUPDATE:
    begin
      tmpMessageStr:='WM_CLIPBOARDUPDATE';
    end;
    WM_HANDHELDFIRST:
    begin
      tmpMessageStr:='WM_HANDHELDFIRST';
    end;
    WM_HANDHELDLAST:
    begin
      tmpMessageStr:='WM_HANDHELDLAST';
    end;
    WM_PENWINFIRST:
    begin
      tmpMessageStr:='WM_PENWINFIRST';
    end;
    WM_PENWINLAST:
    begin
      tmpMessageStr:='WM_PENWINLAST';
    end;
    WM_COALESCE_FIRST:
    begin
      tmpMessageStr:='WM_COALESCE_FIRST';
    end;
    WM_COALESCE_LAST:
    begin
      tmpMessageStr:='WM_COALESCE_LAST';
    end;
    WM_DDE_FIRST:
    begin
      tmpMessageStr:='WM_DDE_FIRST';
    end;
//    WM_DDE_INITIATE:
//    begin
//      tmpMessageStr:='WM_DDE_INITIATE';
//    end;
    WM_DDE_TERMINATE:
    begin
      tmpMessageStr:='WM_DDE_TERMINATE';
    end;
    WM_DDE_ADVISE:
    begin
      tmpMessageStr:='WM_DDE_ADVISE';
    end;
    WM_DDE_UNADVISE:
    begin
      tmpMessageStr:='WM_DDE_UNADVISE';
    end;
    WM_DDE_ACK:
    begin
      tmpMessageStr:='WM_DDE_ACK';
    end;
    WM_DDE_DATA:
    begin
      tmpMessageStr:='WM_DDE_DATA';
    end;
    WM_DDE_REQUEST:
    begin
      tmpMessageStr:='WM_DDE_REQUEST';
    end;
    WM_DDE_POKE:
    begin
      tmpMessageStr:='WM_DDE_POKE';
    end;
    WM_DDE_EXECUTE :
    begin
      tmpMessageStr:='WM_DDE_EXECUTE';
    end;
//    WM_DDE_LAST:
//    begin
//      tmpMessageStr:='WM_DDE_LAST';
//    end;
    WM_DWMCOMPOSITIONCHANGED:
    begin
      tmpMessageStr:='WM_DWMCOMPOSITIONCHANGED';
    end;
    WM_DWMNCRENDERINGCHANGED:
    begin
      tmpMessageStr:='WM_DWMNCRENDERINGCHANGED';
    end;
    WM_DWMCOLORIZATIONCOLORCHANGED:
    begin
      tmpMessageStr:='WM_DWMCOLORIZATIONCOLORCHANGED';
    end;
    WM_DWMWINDOWMAXIMIZEDCHANGE:
    begin
      tmpMessageStr:='WM_DWMWINDOWMAXIMIZEDCHANGE';
    end;
    WM_DWMSENDICONICTHUMBNAIL:
    begin
      tmpMessageStr:='WM_DWMSENDICONICTHUMBNAIL';
    end;
    WM_DWMSENDICONICLIVEPREVIEWBITMAP:
    begin
      tmpMessageStr:='WM_DWMSENDICONICLIVEPREVIEWBITMAP';
    end;
    WM_GETTITLEBARINFOEX:
    begin
      tmpMessageStr:='WM_GETTITLEBARINFOEX';
    end;
//    WM_TABLET_DEFBASE:
//    begin
//      tmpMessageStr:='WM_TABLET_DEFBASE';
//    end;
//    WM_TABLET_MAXOFFSET:
//    begin
//      tmpMessageStr:='WM_TABLET_MAXOFFSET';
//    end;
    WM_TABLET_ADDED:
    begin
      tmpMessageStr:='WM_TABLET_ADDED';
    end;
    WM_TABLET_DELETED:
    begin
      tmpMessageStr:='WM_TABLET_DELETED';
    end;
    WM_TABLET_FLICK:
    begin
      tmpMessageStr:='WM_TABLET_FLICK';
    end;
    WM_TABLET_QUERYSYSTEMGESTURESTATUS:
    begin
      tmpMessageStr:='WM_TABLET_QUERYSYSTEMGESTURESTATUS';
    end;
    WM_APP:
    begin
      tmpMessageStr:='WM_APP';
    end;
//  CM_CLROFFSET:
//    begin
//      tmpMessageStr:='CM_CLROFFSET';
//    end;
//  CM_CLROFFSET:
//    begin
//      tmpMessageStr:='CM_CLROFFSET';
//    end;
  CM_ACTIVATE :
    begin
      tmpMessageStr:='CM_ACTIVATE';
    end;
  CM_DEACTIVATE :
    begin
      tmpMessageStr:='CM_DEACTIVATE';
    end;
  CM_GOTFOCUS :
    begin
      tmpMessageStr:='CM_GOTFOCUS';
    end;
  CM_LOSTFOCUS :
    begin
      tmpMessageStr:='CM_LOSTFOCUS';
    end;
  CM_CANCELMODE:
    begin
      tmpMessageStr:='CM_CANCELMODE';
    end;
  CM_DIALOGKEY:
    begin
      tmpMessageStr:='CM_DIALOGKEY';
    end;
  CM_DIALOGCHAR:
    begin
      tmpMessageStr:='CM_DIALOGCHAR';
    end;
  CM_FOCUSCHANGED:
    begin
      tmpMessageStr:='CM_FOCUSCHANGED';
    end;
  CM_PARENTFONTCHANGED:
    begin
      tmpMessageStr:='CM_PARENTFONTCHANGED';
    end;
  CM_PARENTCOLORCHANGED :
    begin
      tmpMessageStr:='CM_PARENTCOLORCHANGED';
    end;
  CM_HITTEST :
    begin
      tmpMessageStr:='CM_HITTEST';
    end;
  CM_VISIBLECHANGED:
    begin
      tmpMessageStr:='CM_VISIBLECHANGED';
    end;
  CM_ENABLEDCHANGED :
    begin
      tmpMessageStr:='CM_ENABLEDCHANGED';
    end;
  CM_COLORCHANGED :
    begin
      tmpMessageStr:='CM_COLORCHANGED';
    end;
  CM_FONTCHANGED:
    begin
      tmpMessageStr:='CM_FONTCHANGED';
    end;
  CM_CURSORCHANGED:
    begin
      tmpMessageStr:='CM_CURSORCHANGED';
    end;
  CM_CTL3DCHANGED:
    begin
      tmpMessageStr:='CM_CTL3DCHANGED';
    end;
  CM_PARENTCTL3DCHANGED :
    begin
      tmpMessageStr:='CM_PARENTCTL3DCHANGED';
    end;
  CM_TEXTCHANGED :
    begin
      tmpMessageStr:='CM_TEXTCHANGED';
    end;
  CM_MOUSEENTER :
    begin
      tmpMessageStr:='CM_MOUSEENTER';
    end;
  CM_MOUSELEAVE :
    begin
      tmpMessageStr:='CM_MOUSELEAVE';
    end;
  CM_MENUCHANGED :
    begin
      tmpMessageStr:='CM_MENUCHANGED';
    end;
  CM_APPKEYDOWN:
    begin
      tmpMessageStr:='CM_APPKEYDOWN';
    end;
  CM_APPSYSCOMMAND:
    begin
      tmpMessageStr:='CM_APPSYSCOMMAND';
    end;
  CM_BUTTONPRESSED :
    begin
      tmpMessageStr:='CM_BUTTONPRESSED';
    end;
  CM_SHOWINGCHANGED :
    begin
      tmpMessageStr:='CM_SHOWINGCHANGED';
    end;
  CM_ENTER:
    begin
      tmpMessageStr:='CM_ENTER';
    end;
  CM_EXIT:
    begin
      tmpMessageStr:='CM_EXIT';
    end;
  CM_DESIGNHITTEST:
    begin
      tmpMessageStr:='CM_DESIGNHITTEST';
    end;
  CM_ICONCHANGED :
    begin
      tmpMessageStr:='CM_ICONCHANGED';
    end;
  CM_WANTSPECIALKEY :
    begin
      tmpMessageStr:='CM_WANTSPECIALKEY';
    end;
  CM_INVOKEHELP:
    begin
      tmpMessageStr:='CM_INVOKEHELP';
    end;
  CM_WINDOWHOOK:
    begin
      tmpMessageStr:='CM_WINDOWHOOK';
    end;
  CM_RELEASE:
    begin
      tmpMessageStr:='CM_RELEASE';
    end;
  CM_SHOWHINTCHANGED:
    begin
      tmpMessageStr:='CM_SHOWHINTCHANGED';
    end;
  CM_PARENTSHOWHINTCHANGED:
    begin
      tmpMessageStr:='CM_PARENTSHOWHINTCHANGED';
    end;
  CM_SYSCOLORCHANGE:
    begin
      tmpMessageStr:='CM_SYSCOLORCHANGE';
    end;
  CM_WININICHANGE:
    begin
      tmpMessageStr:='CM_WININICHANGE';
    end;
  CM_FONTCHANGE:
    begin
      tmpMessageStr:='CM_FONTCHANGE';
    end;
  CM_TIMECHANGE:
    begin
      tmpMessageStr:='CM_TIMECHANGE';
    end;
  CM_TABSTOPCHANGED:
    begin
      tmpMessageStr:='CM_TABSTOPCHANGED';
    end;
  CM_UIACTIVATE:
    begin
      tmpMessageStr:='CM_UIACTIVATE';
    end;
  CM_UIDEACTIVATE:
    begin
      tmpMessageStr:='CM_UIDEACTIVATE';
    end;
  CM_DOCWINDOWACTIVATE:
    begin
      tmpMessageStr:='CM_DOCWINDOWACTIVATE';
    end;
  CM_CONTROLLISTCHANGE:
    begin
      tmpMessageStr:='CM_CONTROLLISTCHANGE';
    end;
  CM_GETDATALINK:
    begin
      tmpMessageStr:='CM_GETDATALINK';
    end;
  CM_CHILDKEY:
    begin
      tmpMessageStr:='CM_CHILDKEY';
    end;
  CM_DRAG:
    begin
      tmpMessageStr:='CM_DRAG';
    end;
  CM_HINTSHOW:
    begin
      tmpMessageStr:='CM_HINTSHOW';
    end;
  CM_DIALOGHANDLE:
    begin
      tmpMessageStr:='CM_DIALOGHANDLE';
    end;
  CM_ISTOOLCONTROL:
    begin
      tmpMessageStr:='CM_ISTOOLCONTROL';
    end;
  CM_RECREATEWND:
    begin
      tmpMessageStr:='CM_RECREATEWND';
    end;
  CM_INVALIDATE:
    begin
      tmpMessageStr:='CM_INVALIDATE';
    end;
  CM_SYSFONTCHANGED:
    begin
      tmpMessageStr:='CM_SYSFONTCHANGED';
    end;
  CM_CONTROLCHANGE:
    begin
      tmpMessageStr:='CM_CONTROLCHANGE';
    end;
  CM_CHANGED:
    begin
      tmpMessageStr:='CM_CHANGED';
    end;
  CM_DOCKCLIENT :
    begin
      tmpMessageStr:='CM_DOCKCLIENT';
    end;
  CM_UNDOCKCLIENT:
    begin
      tmpMessageStr:='CM_UNDOCKCLIENT';
    end;
  CM_FLOAT:
    begin
      tmpMessageStr:='CM_FLOAT';
    end;
  CM_BORDERCHANGED:
    begin
      tmpMessageStr:='CM_BORDERCHANGED';
    end;
  CM_BIDIMODECHANGED:
    begin
      tmpMessageStr:='CM_BIDIMODECHANGED';
    end;
  CM_PARENTBIDIMODECHANGED:
    begin
      tmpMessageStr:='CM_PARENTBIDIMODECHANGED';
    end;
  CM_ALLCHILDRENFLIPPED:
    begin
      tmpMessageStr:='CM_ALLCHILDRENFLIPPED';
    end;
  CM_ACTIONUPDATE:
    begin
      tmpMessageStr:='CM_ACTIONUPDATE';
    end;
  CM_ACTIONEXECUTE:
    begin
      tmpMessageStr:='CM_ACTIONEXECUTE';
    end;
  CM_HINTSHOWPAUSE:
    begin
      tmpMessageStr:='CM_HINTSHOWPAUSE';
    end;
  CM_DOCKNOTIFICATION:
    begin
      tmpMessageStr:='CM_DOCKNOTIFICATION';
    end;
  CM_MOUSEWHEEL:
    begin
      tmpMessageStr:='CM_MOUSEWHEEL';
    end;
  CM_ISSHORTCUT:
    begin
      tmpMessageStr:='CM_ISSHORTCUT';
    end;
  CM_UPDATEACTIONS:
    begin
      tmpMessageStr:='CM_UPDATEACTIONS';
    end;
//  CM_RAWX11EVENT:
//    begin
//      tmpMessageStr:='CM_RAWX11EVENT';
//    end;
  CM_INVALIDATEDOCKHOST:
    begin
      tmpMessageStr:='CM_INVALIDATEDOCKHOST';
    end;
  CM_SETACTIVECONTROL:
    begin
      tmpMessageStr:='CM_SETACTIVECONTROL';
    end;
  CM_POPUPHWNDDESTROY:
    begin
      tmpMessageStr:='CM_POPUPHWNDDESTROY';
    end;
  CM_CREATEPOPUP:
    begin
      tmpMessageStr:='CM_CREATEPOPUP';
    end;
  CM_DESTROYHANDLE:
    begin
      tmpMessageStr:='CM_DESTROYHANDLE';
    end;
  CM_MOUSEACTIVATE:
    begin
      tmpMessageStr:='CM_MOUSEACTIVATE';
    end;
  CM_CONTROLLISTCHANGING:
    begin
      tmpMessageStr:='CM_CONTROLLISTCHANGING';
    end;
  CM_BUFFEREDPRINTCLIENT:
    begin
      tmpMessageStr:='CM_BUFFEREDPRINTCLIENT';
    end;
  CM_UNTHEMECONTROL:
    begin
      tmpMessageStr:='CM_UNTHEMECONTROL';
    end;
  CM_DOUBLEBUFFEREDCHANGED:
    begin
      tmpMessageStr:='CM_DOUBLEBUFFEREDCHANGED';
    end;
  CM_PARENTDOUBLEBUFFEREDCHANGED:
    begin
      tmpMessageStr:='CM_PARENTDOUBLEBUFFEREDCHANGED';
    end;
  CM_THEMECHANGED:
    begin
      tmpMessageStr:='CM_THEMECHANGED';
    end;
  CM_GESTURE:
    begin
      tmpMessageStr:='CM_GESTURE';
    end;
  CM_CUSTOMGESTURESCHANGED:
    begin
      tmpMessageStr:='CM_CUSTOMGESTURESCHANGED';
    end;
  CM_GESTUREMANAGERCHANGED:
    begin
      tmpMessageStr:='CM_GESTUREMANAGERCHANGED';
    end;
  CM_STANDARDGESTURESCHANGED:
    begin
      tmpMessageStr:='CM_STANDARDGESTURESCHANGED';
    end;
  CM_INPUTLANGCHANGE:
    begin
      tmpMessageStr:='CM_INPUTLANGCHANGE';
    end;
  CM_TABLETOPTIONSCHANGED:
    begin
      tmpMessageStr:='CM_TABLETOPTIONSCHANGED';
    end;
  CM_PARENTTABLETOPTIONSCHANGED:
    begin
      tmpMessageStr:='CM_PARENTTABLETOPTIONSCHANGED';
    end;
  end;
//  if tmpMessageStr='' then
//  begin
//    tmpMessageStr:=IntToStr(Message.Msg);
//  end;
  if tmpMessageStr<>'' then
  begin
    OutPutDebugString(PChar(tmpMessageStr+' '+FloatToStr(Now)));
    //tmpMessageStr:=IntToStr(Message.Msg);
  end;
end;
{$ENDIF}

//{$EndRegion}



end.

