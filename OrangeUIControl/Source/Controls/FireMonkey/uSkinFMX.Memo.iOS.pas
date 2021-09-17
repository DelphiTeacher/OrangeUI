//convert pas to utf8 by ¥
{*******************************************************}
{                                                       }
{             Delphi FireMonkey Platform                }
{ Copyright(c) 2014-2015 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}

unit uSkinFMX.Memo.iOS;

interface

{$IFDEF IOS}

{$SCOPEDENUMS ON}



uses
  System.Types, System.SysUtils, System.TypInfo,
  Macapi.ObjectiveC, iOSapi.UIKit, iOSapi.Foundation, iOSapi.CoreGraphics,


//  iOSapi.UIKit,
//  Macapi.ObjectiveC,
//  iOSapi.Foundation,
//  Macapi.Helpers,
  Macapi.ObjCRuntime,
//  iOSapi.CoreGraphics,


  FMX.Dialogs,

  Classes,


  FMX.Memo, FMX.Presentation.Messages, FMX.Controls.Presentation, FMX.Presentation.iOS, FMX.Controls, FMX.Types,
  FMX.ScrollBox.iOS, FMX.Memo.Types, FMX.Controls.Model;

type

  //wn
  SEL = Pointer;
  id = Pointer;

{ TiOSNativeMemo }

  TSkiniOSTextViewDelegate = class;

  ISkinFMXUITextView = interface(UITextView)
  ['{F24D110A-BDC7-4653-94E1-4FF6305FCAC0}']
    { Touches }
    procedure touchesBegan(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure touchesCancelled(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure touchesEnded(touches: NSSet; withEvent: UIEvent); cdecl;
    procedure touchesMoved(touches: NSSet; withEvent: UIEvent); cdecl;
    { Gestures }
    procedure HandlePan(gestureRecognizer: UIPanGestureRecognizer); cdecl;
    function gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer): Boolean; cdecl;
    { Focus }
    function canBecomeFirstResponder: Boolean; cdecl;

    //wn
    function canPerformAction(action: SEL; withSender: Pointer): Boolean; cdecl;
    procedure CustomMenu1(Sender: id);cdecl;
    procedure CustomMenu2(Sender: id);cdecl;
    procedure CustomMenu3(Sender: id);cdecl;
  end;



  TSkiniOSNativeMemo = class(TiOSScrollBox)
  private
//    SpellTitle: NSString;
    //wn
    FMenuController: UIMenuController;

    FCustomMenu1Item: UIMenuItem;
    FCustomMenu2Item: UIMenuItem;
    FCustomMenu3Item: UIMenuItem;

    FCustomMenu1SEL:SEL;
    FCustomMenu2SEL:SEL;
    FCustomMenu3SEL:SEL;

  public


    procedure CustomMenu1(Sender: id);cdecl;
    procedure CustomMenu2(Sender: id);cdecl;
    procedure CustomMenu3(Sender: id);cdecl;

    //wn
    function canPerformAction(action: SEL; withSender: Pointer): Boolean; cdecl;

    procedure SyncCustomMenuCaption;
  private
    FDefaultBackgroundColor: UIColor;
    FAttributedString: NSMutableAttributedString;
    function GetModel: TCustomMemoModel;
    function GetMemo: TCustomMemo;
    function GetView: UITextView;
  protected
    procedure UpdateTextSettings;
    procedure UpdateTextSelection;
    function CreateDelegate: TiOSScrollBoxDelegate; override;
    function GetObjectiveCClass: PTypeInfo; override;
    function DefineModelClass: TDataModelClass; override;
  protected
    { Messages from Model }
    procedure MMCaretChanged(var AMessage: TDispatchMessageWithValue<TCaret>); message MM_MEMO_CARETCHANGED;
    procedure MMCheckSpellingChanged(var AMessage: TDispatchMessageWithValue<Boolean>); message MM_MEMO_CHECKSPELLING_CHANGED;
    procedure MMDataDetectoTypes(var AMessage: TDispatchMessageWithValue<TDataDetectorTypes>); message MM_MEMO_DATADETECTORTYPES_CHANGED;
    procedure MMKeyboardTypeChanged(var AMessage: TDispatchMessageWithValue<TVirtualkeyboardType>); message MM_MEMO_KEYBOARDTYPE_CHANGED;
    procedure MMLinesChanged(var AMessage: TDispatchMessage); message MM_MEMO_LINES_CHANGED;
    procedure MMReadOnlyChanged(var AMessage: TDispatchMessage); message MM_MEMO_READONLY_CHANGED;
    procedure MMSelStartChanged(var AMessage: TDispatchMessage); message MM_MEMO_SELSTART_CHANGED;
    procedure MMSelLengthChanged(var AMessage: TDispatchMessage); message MM_MEMO_SELLENGTH_CHANGED;
    procedure MMTextSettingsChanged(var AMessage: TDispatchMessage); message MM_MEMO_TEXT_SETTINGS_CHANGED;
    procedure MMCaretPositionChanged(var AMessage: TDispatchMessageWithValue<TCaretPosition>); message MM_MEMO_SET_CARET_POSITION;
    procedure MMLinesClear(var AMessage: TDispatchMessage); message MM_MEMO_LINES_CLEAR;
    { Messages from PresentationProxy }
    procedure PMInit(var AMessage: TDispatchMessage); message PM_INIT;
    procedure PMAbsoluteChanged(var AMessage: TDispatchMessage); message PM_ABSOLUTE_CHANGED;
    procedure PMDoEnter(var AMessage: TDispatchMessage); message PM_DO_ENTER;
    procedure PMSetStyleLookup(var AMessage: TDispatchMessageWithValue<string>); message PM_SET_STYLE_LOOKUP;
    procedure PMGetRecommendSize(var AMessage: TDispatchMessageWithValue<TSizeF>); message PM_GET_RECOMMEND_SIZE;
    procedure PMSetClipChildren(var AMessage: TDispatchMessageWithValue<Boolean>); message PM_SET_CLIP_CHILDREN;
    procedure PMGoToTextBegin(var AMessage: TDispatchMessage); message PM_MEMO_GOTO_TEXT_BEGIN;
    procedure PMGoToTextEnd(var AMessage: TDispatchMessage); message PM_MEMO_GOTO_TEXT_END;
    procedure PMGoToLineBegin(var AMessage: TDispatchMessage); message PM_MEMO_GOTO_LINE_BEGIN;
    procedure PMGoToLineEnd(var AMessage: TDispatchMessage); message PM_MEMO_GOTO_LINE_END;
    procedure PMSelectText(var AMessage: TDispatchMessage); message PM_MEMO_SELECT_TEXT;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    { Focus }
    ///<summary>Overriding UIResponder.canBecomeFirstResponder method to retranslate TCustomMemo.CanFocus value</summary>
    function canBecomeFirstResponder: Boolean; cdecl;

  public
    property Model: TCustomMemoModel read GetModel;
    property Memo: TCustomMemo read GetMemo;
    property View: UITextView read GetView;
  end;

  TSkiniOSTextViewDelegate = class(TiOSScrollBoxDelegate, UITextViewDelegate)
  private
    [Weak] FNativeMemo: TSkiniOSNativeMemo;
  public
    constructor Create(const ANativeMemo: TSkiniOSNativeMemo);
    { UITextViewDelegate }
    function textView(textView: UITextView; shouldChangeTextInRange: NSRange; replacementText: NSString): Boolean; cdecl;
    procedure textViewDidBeginEditing(textView: UITextView); cdecl;
    procedure textViewDidChange(textView: UITextView); cdecl;
    procedure textViewDidChangeSelection(textView: UITextView); cdecl;
    procedure textViewDidEndEditing(textView: UITextView); cdecl;
    function textViewShouldBeginEditing(textView: UITextView): Boolean; cdecl;
    function textViewShouldEndEditing(textView: UITextView): Boolean; cdecl;
    [MethodName('textView:shouldChangeTextInRange:replacementText:')]
    function textViewShouldChangeTextInRangeReplacementText(textView: UITextView; shouldChangeTextInRange: NSRange;
      replacementText: NSString): Boolean; cdecl;
    [MethodName('textView:shouldInteractWithURL:inRange:')]
    function textViewShouldInteractWithURLInRange(textView: UITextView; shouldInteractWithURL: NSURL; inRange: NSRange)
      : Boolean; cdecl;
    [MethodName('textView:shouldInteractWithTextAttachment:inRange:')]
    function textViewShouldInteractWithTextAttachmentInRange(textView: UITextView;
      shouldInteractWithTextAttachment: NSTextAttachment; inRange: NSRange): Boolean; cdecl;
  end;


{$ENDIF}

var
  GlobalIsNeedCustomMenu:Boolean;






implementation






{$IFDEF IOS}

uses
  uSkinFireMonkeyMemo,
  System.UITypes,
  System.Math, MacApi.Helpers, {$IFDEF MACOS}Macapi.CoreFoundation,{$ENDIF}
  FMX.Presentation.Factory, FMX.Consts, FMX.Graphics, FMX.Helpers.iOS,
  iOSapi.CoreText;

function DataDetectorTypesToUIDataDetectorTypes(const ASource: TDataDetectorTypes): UIDataDetectorTypes;
begin
  Result := UIDataDetectorTypeNone;
  if TDataDetectorType.PhoneNumber in ASource then
    Result := Result or UIDataDetectorTypePhoneNumber;
  if TDataDetectorType.Link in ASource then
    Result := Result or UIDataDetectorTypeLink;
  if TDataDetectorType.Address in ASource then
    Result := Result or UIDataDetectorTypeAddress;
  if TDataDetectorType.CalendarEvent in ASource then
    Result := Result or UIDataDetectorTypeCalendarEvent;
end;

{ TSkiniOSNativeMemo }

//wn

procedure TSkiniOSNativeMemo.SyncCustomMenuCaption;
begin
  if FCustomMenu1Item<>nil then FCustomMenu1Item.setTitle(NSStr(TSkinFMXMemo(Control).CustomMenu1Caption));
  if FCustomMenu2Item<>nil then FCustomMenu2Item.setTitle(NSStr(TSkinFMXMemo(Control).CustomMenu2Caption));
  if FCustomMenu3Item<>nil then FCustomMenu3Item.setTitle(NSStr(TSkinFMXMemo(Control).CustomMenu3Caption));
end;

function TSkiniOSNativeMemo.canPerformAction(action: SEL; withSender: Pointer): Boolean;
begin
    FMX.Types.Log.d('OrangeUI TSkiniOSNativeMemo.canPerformAction');

    if Assigned(TSkinFMXMemo(Control).OnCustomMenu1) and (action = FCustomMenu1SEL)//sel_getUid('CustomMenu1:'))
      or Assigned(TSkinFMXMemo(Control).OnCustomMenu2) and (action = FCustomMenu2SEL)//sel_getUid('CustomMenu2:'))
      or Assigned(TSkinFMXMemo(Control).OnCustomMenu3) and (action = FCustomMenu3SEL)//sel_getUid('CustomMenu3:'))
      then
    begin
      FMX.Types.Log.d('OrangeUI TSkiniOSNativeMemo.canPerformAction 1');
      Result:=True;
    end
    else if Not TSkinFMXMemo(Control).IsHideDefaultCopyMenu and (action = sel_getUid('copy:')) then
    begin
      FMX.Types.Log.d('OrangeUI TSkiniOSNativeMemo.canPerformAction 2');
      Result:=True;
    end
    else
    begin
      FMX.Types.Log.d('OrangeUI TSkiniOSNativeMemo.canPerformAction 3');
      if Not TSkinFMXMemo(Control).IsHideDefaultMenu then
      begin
        Result:=UIResponder(Super).canPerformAction(action,withSender);
      end
      else
      begin
        Result:=False;
      end;
    end

end;

function TSkiniOSNativeMemo.canBecomeFirstResponder: Boolean;
begin
  Result := Memo.CanFocus and Memo.HitTest;
end;

procedure TSkiniOSNativeMemo.Clear;
begin
  if FAttributedString <> nil then
  begin
    FAttributedString.deleteCharactersInRange(NSMakeRange(0, FAttributedString.length));
    View.setAttributedText(FAttributedString);
  end;
end;

constructor TSkiniOSNativeMemo.Create;
//wn
var
  MenuItems: NSMutableArray;
begin
  inherited;
  Delegate.Model := Model;
  FDefaultBackgroundColor := TUIColor.Wrap(View.layer.backgroundColor);

  FCustomMenu1SEL:=sel_getUid('CustomMenu1:');
  FCustomMenu2SEL:=sel_getUid('CustomMenu2:');
  FCustomMenu3SEL:=sel_getUid('CustomMenu3:');


  if GlobalIsNeedCustomMenu then
  begin
      //wn 加入自定义弹出菜单
      FMenuController := TUIMenuController.Wrap(TUIMenuController.OCClass.sharedMenuController);


      MenuItems := TNSMutableArray.Create;


      //菜单项1
      FCustomMenu1Item := TUIMenuItem.Alloc;
      FCustomMenu1Item := TUIMenuItem.Wrap(FCustomMenu1Item.initWithTitle(StrToNSStr('Custom1'),
              FCustomMenu1SEL//sel_getUid('CustomMenu1:')
              ));
      MenuItems.addObject((FCustomMenu1Item as ILocalObject).GetObjectID);

      //菜单项2
      FCustomMenu2Item := TUIMenuItem.Alloc;
      FCustomMenu2Item := TUIMenuItem.Wrap(FCustomMenu2Item.initWithTitle(StrToNSStr('Custom2'),
              FCustomMenu2SEL//sel_getUid('CustomMenu2:')
              ));
      MenuItems.addObject((FCustomMenu2Item as ILocalObject).GetObjectID);

      //菜单项3
      FCustomMenu3Item := TUIMenuItem.Alloc;
      FCustomMenu3Item := TUIMenuItem.Wrap(FCustomMenu3Item.initWithTitle(StrToNSStr('Custom3'),
              FCustomMenu3SEL//sel_getUid('CustomMenu3:')
              ));
      MenuItems.addObject((FCustomMenu3Item as ILocalObject).GetObjectID);



      FMenuController.setMenuItems(MenuItems);
  end;

end;

function TSkiniOSNativeMemo.CreateDelegate: TiOSScrollBoxDelegate;
begin
  Result := TSkiniOSTextViewDelegate.Create(Self);
end;

procedure TSkiniOSNativeMemo.CustomMenu1(Sender: id);
begin
  if Assigned(TSkinFMXMemo(Control).OnCustomMenu1) then
  begin
    TSkinFMXMemo(Control).OnCustomMenu1(Self);
  end;
end;

procedure TSkiniOSNativeMemo.CustomMenu2(Sender: id);
begin
  if Assigned(TSkinFMXMemo(Control).OnCustomMenu2) then
  begin
    TSkinFMXMemo(Control).OnCustomMenu2(Self);
  end;
end;

procedure TSkiniOSNativeMemo.CustomMenu3(Sender: id);
begin
  if Assigned(TSkinFMXMemo(Control).OnCustomMenu3) then
  begin
    TSkinFMXMemo(Control).OnCustomMenu3(Self);
  end;
end;

function TSkiniOSNativeMemo.DefineModelClass: TDataModelClass;
begin
  Result := TCustomMemoModel;
end;

destructor TSkiniOSNativeMemo.Destroy;
begin
  FMenuController:=nil;

  FAttributedString.release;
  inherited;
end;

function TSkiniOSNativeMemo.GetMemo: TCustomMemo;
begin
  Result := Control as TCustomMemo;
end;

function TSkiniOSNativeMemo.GetModel: TCustomMemoModel;
begin
  Result := inherited GetModel<TCustomMemoModel>;
end;

function TSkiniOSNativeMemo.GetObjectiveCClass: PTypeInfo;
begin
  Result := TypeInfo(ISkinFMXUITextView);
end;

function TSkiniOSNativeMemo.GetView: UITextView;
begin
  Result := inherited GetView<UITextView>;
end;

procedure TSkiniOSNativeMemo.MMCaretChanged(var AMessage: TDispatchMessageWithValue<TCaret>);
begin
  if TOSVersion.Check(7) and (Model.Caret.Color <> TAlphaColorRec.Null) then
    View.setTintColor(AlphaColorToUIColor(Model.Caret.Color));
end;

procedure TSkiniOSNativeMemo.MMCaretPositionChanged(var AMessage: TDispatchMessageWithValue<TCaretPosition>);
begin
  View.setSelectedRange(NSMakeRange(Model.PosToTextPos(AMessage.Value), 0));
end;

procedure TSkiniOSNativeMemo.MMCheckSpellingChanged(var AMessage: TDispatchMessageWithValue<Boolean>);
begin
  if Model.CheckSpelling then
    View.setSpellCheckingType(UITextSpellCheckingTypeYes)
  else
    View.setSpellCheckingType(UITextSpellCheckingTypeNo);
end;

procedure TSkiniOSNativeMemo.MMDataDetectoTypes(var AMessage: TDispatchMessageWithValue<TDataDetectorTypes>);
begin
  View.setDataDetectorTypes(DataDetectorTypesToUIDataDetectorTypes(AMessage.Value));
end;

procedure TSkiniOSNativeMemo.MMKeyboardTypeChanged(var AMessage: TDispatchMessageWithValue<TVirtualkeyboardType>);
begin
  View.setKeyboardType(VirtualKeyboardTypeToUIKeyboardType(AMessage.Value));
end;

procedure TSkiniOSNativeMemo.MMLinesChanged(var AMessage: TDispatchMessage);
begin
  if (FAttributedString = nil) or (FAttributedString.length = 0) then
    UpdateTextSettings
  else
  begin
    FAttributedString.replaceCharactersInRange(NSMakeRange(0, FAttributedString.length), StrToNSStr(Model.Lines.Text));
    View.setAttributedText(FAttributedString);
  end;
end;

procedure TSkiniOSNativeMemo.MMLinesClear(var AMessage: TDispatchMessage);
begin
  Clear;
end;

procedure TSkiniOSNativeMemo.MMReadOnlyChanged(var AMessage: TDispatchMessage);
begin
  View.setEditable(not Model.ReadOnly);
end;

procedure TSkiniOSNativeMemo.MMSelLengthChanged(var AMessage: TDispatchMessage);
begin
  UpdateTextSelection;
end;

procedure TSkiniOSNativeMemo.MMSelStartChanged(var AMessage: TDispatchMessage);
begin
  UpdateTextSelection;
end;

procedure TSkiniOSNativeMemo.MMTextSettingsChanged(var AMessage: TDispatchMessage);
begin
  UpdateTextSettings;
end;

procedure TSkiniOSNativeMemo.PMAbsoluteChanged(var AMessage: TDispatchMessage);
begin
  inherited;
  TUIMenuController.Wrap(TUIMenuController.OCClass.sharedMenuController).setMenuVisible(False);
end;

procedure TSkiniOSNativeMemo.PMDoEnter(var AMessage: TDispatchMessage);
var
  Range: NSRange;
begin
  inherited;
  if Model.AutoSelect then
  begin
    View.setSelectedRange(NSMakeRange(0, Model.Lines.Text.Length));
    Range := view.selectedRange;
  end;
end;

procedure TSkiniOSNativeMemo.PMGetRecommendSize(var AMessage: TDispatchMessageWithValue<TSizeF>);
begin
  // This control doesn't support recommend size, so we don't have to change required size in AMessage
end;

procedure TSkiniOSNativeMemo.PMGoToLineBegin(var AMessage: TDispatchMessage);
var
  LineBeginPos: TCaretPosition;
begin
  LineBeginPos := Model.CaretPosition;
  LineBeginPos.Pos := 0;
  View.setSelectedRange(NSMakeRange(Model.PosToTextPos(LineBeginPos), 0));
end;

procedure TSkiniOSNativeMemo.PMGoToLineEnd(var AMessage: TDispatchMessage);
var
  LineEndPos: TCaretPosition;
begin
  LineEndPos := Model.CaretPosition;
  if InRange(LineEndPos.Line, 0, Model.Lines.Count - 1) then
  begin
    LineEndPos.Pos := Model.Lines[LineEndPos.Line].Length;
    View.setSelectedRange(NSMakeRange(Model.PosToTextPos(LineEndPos), 0));
  end;
end;

procedure TSkiniOSNativeMemo.PMGoToTextBegin(var AMessage: TDispatchMessage);
begin
  View.setSelectedRange(NSMakeRange(0, 0));
end;

procedure TSkiniOSNativeMemo.PMGoToTextEnd(var AMessage: TDispatchMessage);
begin
  View.setSelectedRange(NSMakeRange(Model.Lines.Text.Length, 0));
end;

procedure TSkiniOSNativeMemo.PMInit(var AMessage: TDispatchMessage);
begin
  if Model.CheckSpelling then
    View.setSpellCheckingType(UITextSpellCheckingTypeYes)
  else
    View.setSpellCheckingType(UITextSpellCheckingTypeNo);
  View.setKeyboardType(VirtualKeyboardTypeToUIKeyboardType(Model.KeyboardType));
  View.setEditable(not Model.ReadOnly);
  View.setDataDetectorTypes(DataDetectorTypesToUIDataDetectorTypes(Model.DataDetectorTypes));
  UpdateTextSettings;
end;

procedure TSkiniOSNativeMemo.PMSelectText(var AMessage: TDispatchMessage);
begin
  UpdateTextSelection;
end;

procedure TSkiniOSNativeMemo.PMSetClipChildren(var AMessage: TDispatchMessageWithValue<Boolean>);
begin
  View.setClipsToBounds(True);
end;

procedure TSkiniOSNativeMemo.PMSetStyleLookup(var AMessage: TDispatchMessageWithValue<string>);
const
  TransparentStyleName = 'transparentmemo'; // do not localize
begin
  if AMessage.Value.ToLower = TransparentStyleName then
    View.layer.setBackgroundColor(TUIColor.OCClass.clearColor)
  else
    View.layer.setBackgroundColor((FDefaultBackgroundColor as ILocalObject).GetObjectID);
end;

procedure TSkiniOSNativeMemo.UpdateTextSelection;
begin
  View.setSelectedRange(NSMakeRange(Model.SelStart, Model.SelLength));
end;

procedure TSkiniOSNativeMemo.UpdateTextSettings;
var
  TextSettings: TTextSettings;
  TextRange: NSRange;
  FontRef: CTFontRef;
  Underline: CFNumberRef;
  LValue: Cardinal;
begin
  TextSettings := Model.TextSettingsInfo.ResultingTextSettings;

  if FAttributedString <> nil then
    FAttributedString.release;

  FAttributedString := TNSMutableAttributedString.Alloc;
  FAttributedString := TNSMutableAttributedString.Wrap(FAttributedString.initWithString(StrToNSStr(Model.Lines.Text)));

  FAttributedString.beginEditing;
  try
    TextRange := NSMakeRange(0, Model.Lines.Text.Length);
    //Font
    FontRef := FontToCTFontRef(TextSettings.Font);
    if FontRef <> nil then
    try
      FAttributedString.addAttribute(TNSString.Wrap(kCTFontAttributeName), FontRef, TextRange);
    finally
      CFRelease(FontRef);
    end;
    //Font style
    if TFontStyle.fsUnderline in TextSettings.Font.Style then
    begin
      LValue := kCTUnderlineStyleSingle;
      Underline := CFNumberCreate(nil, kCFNumberSInt32Type, @LValue);
      try
        FAttributedString.addAttribute(TNSString.Wrap(kCTUnderlineStyleAttributeName), Underline, TextRange);
      finally
        CFRelease(Underline);
      end;
    end;
  finally
    FAttributedString.endEditing;
  end;

  View.setAttributedText(FAttributedString);

  View.setTextAlignment(TextAlignToUITextAlignment(TextSettings.HorzAlign));
  View.setTextColor(AlphaColorToUIColor(TextSettings.FontColor));
  View.setFont(FontToUIFont(TextSettings.Font));
  if TOSVersion.Check(7) and (Model.Caret.Color <> TAlphaColorRec.Null) then
    View.setTintColor(AlphaColorToUIColor(Model.Caret.Color));
end;

{ TSkiniOSTextViewDelegate }

constructor TSkiniOSTextViewDelegate.Create(const ANativeMemo: TSkiniOSNativeMemo);
begin
  if ANativeMemo = nil then
    raise Exception.CreateFmt(SWrongParameter, ['ANativeMemo']); // do not localize
  inherited Create;
  FNativeMemo := ANativeMemo;
end;

function TSkiniOSTextViewDelegate.textView(textView: UITextView; shouldChangeTextInRange: NSRange;
  replacementText: NSString): Boolean;
var
  TextTmp: string;
begin
  if FNativeMemo.Model.MaxLength > 0 then
  begin
    TextTmp := NSStrToStr(FNativeMemo.View.Text);
    TextTmp := TextTmp.Remove(shouldChangeTextInRange.location, shouldChangeTextInRange.length);
    TextTmp := TextTmp.Insert(shouldChangeTextInRange.location, NSStrToStr(replacementText));
    Result := TextTmp.Length <= FNativeMemo.Model.MaxLength;
  end
  else
    Result := True;
end;

procedure TSkiniOSTextViewDelegate.textViewDidBeginEditing(textView: UITextView);
begin
  if not FNativeMemo.Control.IsFocused then
    FNativeMemo.Control.SetFocus;
end;

procedure TSkiniOSTextViewDelegate.textViewDidChange(textView: UITextView);
var
  LinesCount: Integer;
begin
  FNativeMemo.Model.DisableNotify;
  try
    LinesCount := FNativeMemo.Model.Lines.Count;
    FNativeMemo.Model.Lines.Text := NSStrToStr(FNativeMemo.View.text);
  finally
    FNativeMemo.Model.EnableNotify;
  end;
  if (FNativeMemo.Model.Lines.Count <> LinesCount) and (FNativeMemo.Model.Lines.Count > 1) then
    FNativeMemo.Model.Change;
end;

procedure TSkiniOSTextViewDelegate.textViewDidChangeSelection(textView: UITextView);
var
  SelectionRange: NSRange;
begin
  SelectionRange := FNativeMemo.View.selectedRange;
  FNativeMemo.Model.DisableNotify;
  try
    FNativeMemo.Model.SelStart := SelectionRange.location;
    FNativeMemo.Model.SelLength := SelectionRange.length;
  finally
    FNativeMemo.Model.EnableNotify;
  end;
end;

procedure TSkiniOSTextViewDelegate.textViewDidEndEditing(textView: UITextView);
begin
end;

function TSkiniOSTextViewDelegate.textViewShouldBeginEditing(textView: UITextView): Boolean;
begin
  Result := True;
  if FNativeMemo.Observers.IsObserving(TObserverMapping.EditLinkID) and (FNativeMemo <> nil) then
    if TLinkObservers.EditLinkEdit(FNativeMemo.Observers) then
      TLinkObservers.EditLinkModified(FNativeMemo.Observers)
    else
    begin
      TLinkObservers.EditLinkReset(FNativeMemo.Observers);
      Result := False;
    end;
  if FNativeMemo.Observers.IsObserving(TObserverMapping.ControlValueID) and Result then
    TLinkObservers.ControlValueModified(FNativeMemo.Observers);
  Result := Result and (FNativeMemo <> nil) and not FNativeMemo.Model.ReadOnly;
end;

function TSkiniOSTextViewDelegate.textViewShouldChangeTextInRangeReplacementText(textView: UITextView;
  shouldChangeTextInRange: NSRange; replacementText: NSString): Boolean;
begin
  Result := True;
end;

function TSkiniOSTextViewDelegate.textViewShouldEndEditing(textView: UITextView): Boolean;
begin
  FNativeMemo.Model.Change;
  Result := True;
end;

function TSkiniOSTextViewDelegate.textViewShouldInteractWithTextAttachmentInRange(textView: UITextView;
  shouldInteractWithTextAttachment: NSTextAttachment; inRange: NSRange): Boolean;
begin
  Result := True;
end;

function TSkiniOSTextViewDelegate.textViewShouldInteractWithURLInRange(textView: UITextView; shouldInteractWithURL: NSURL;
  inRange: NSRange): Boolean;
begin
  Result := True;
end;

//initialization
//  TPresentationProxyFactory.Current.Register(TMemo, TControlType.Platform, TiOSPresentationProxy<TSkiniOSNativeMemo>);
//finalization
//  TPresentationProxyFactory.Current.Unregister(TMemo, TControlType.Platform, TiOSPresentationProxy<TSkiniOSNativeMemo>);


{$ENDIF}

initialization
  GlobalIsNeedCustomMenu:=False;//True;


end.
