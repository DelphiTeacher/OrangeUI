//文本框//
//convert pas to utf8 by ¥
unit uSkinFireMonkeyiOSNativeEdit;

interface
{$I FrameWork.inc}

{$I FMXiOSNativeEdit.inc}


uses
  SysUtils,
  uFuncCommon,
  Classes,
  uBaseLog,
  UITypes,
  Math,
  Types,
  FMX.Dialogs,
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Edit,
  uGraphicCommon,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uBinaryTreeDoc,
  uSkinEditType,
  uDrawEngine,
  uDrawCanvas,
  uSkinPicture,
//  uSkinPackage,
  uBaseList,
  FMX.Text,
  FMX.Objects,
  uDrawPicture,
  FMX.Edit.Style,
  FMX.Presentation.Factory,
  {$IF CompilerVersion >= 30.0}//>=XE10
  FMX.Presentation.Style,
  FMX.Controls.Presentation,

  {$IFDEF IOS}
  FMX.Edit.iOS,
  FMX.Presentation.iOS,
  iOSapi.Foundation,
  iOSapi.UIKit,
  {$ENDIF}

  {$ENDIF}
  uSkinRegManager,
  uSkinBufferBitmap;


  {$IF CompilerVersion >= 30.0}//>=XE10
  {$IFDEF IOS}

Type
  /// <summary>
  ///   文本框
  /// </summary>
  TSkinFMXiOSNativeEdit=class(TiOSNativeEdit)
  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Declare_FMX.inc}
  private
    FRePaintTimer:TTimer;
    procedure DoRePaintTimer(Sender:TObject);
  public
    procedure UpdateContentMargins;
  public
    constructor Create;override;
    destructor Destroy;override;
  end;


  {$ENDIF}
  {$ENDIF}



implementation

  {$IF CompilerVersion >= 30.0}//>=XE10
  {$IFDEF IOS}

uses
  uSkinFireMonkeyEdit;


{ TSkinFMXiOSNativeEdit }



function TSkinFMXiOSNativeEdit.GetContentMarginsLeft: Integer;
begin
  Result:=FContentMarginsLeft;
end;

function TSkinFMXiOSNativeEdit.GetContentMarginsTop: Integer;
begin
  Result:=FContentMarginsTop;
end;

function TSkinFMXiOSNativeEdit.GetContentMarginsRight: Integer;
begin
  Result:=FContentMarginsRight;
end;

function TSkinFMXiOSNativeEdit.GetContentMarginsBottom: Integer;
begin
  Result:=FContentMarginsBottom;
end;

procedure TSkinFMXiOSNativeEdit.DoRePaintTimer(Sender:TObject);
begin
  Self.Edit.Repaint;
end;

procedure TSkinFMXiOSNativeEdit.UpdateContentMargins;
var
  AFrame:NSRect;
  ALeftView:UIView;
  ARightView:UIView;
begin

  AFrame:=GetViewFrame;
  AFrame.size.width:=FContentMarginsLeft;
  if FContentMarginsLeft=0 then AFrame.size.width:=2;

  ALeftView:=TUIView.Wrap(TUIView.Alloc.initWithFrame(AFrame));
  Self.View.setLeftViewMode(UITextFieldViewModeAlways);
  Self.View.setLeftView(ALeftView);


  AFrame:=GetViewFrame;
  AFrame.size.width:=FContentMarginsRight;
  if FContentMarginsRight=0 then AFrame.size.width:=2;
  ARightView:=TUIView.Wrap(TUIView.Alloc.initWithFrame(AFrame));
  Self.View.setRightViewMode(UITextFieldViewModeAlways);
  Self.View.setRightView(ARightView);

end;


procedure TSkinFMXiOSNativeEdit.SetContentMarginsLeft(const Value:Integer);
begin
  if FContentMarginsLeft<>Value then
  begin
    FContentMarginsLeft := Value;
    UpdateContentMargins;
  end;
end;

procedure TSkinFMXiOSNativeEdit.SetContentMarginsTop(const Value:Integer);
begin
  if FContentMarginsTop<>Value then
  begin
    FContentMarginsTop := Value;
    UpdateContentMargins;
  end;
end;

procedure TSkinFMXiOSNativeEdit.SetContentMarginsRight(const Value:Integer);
begin
  if FContentMarginsRight<>Value then
  begin
    FContentMarginsRight := Value;
    UpdateContentMargins;
  end;
end;

procedure TSkinFMXiOSNativeEdit.SetContentMarginsBottom(const Value:Integer);
begin
  if FContentMarginsBottom<>Value then
  begin
    FContentMarginsBottom := Value;
    UpdateContentMargins;
  end;
end;

constructor TSkinFMXiOSNativeEdit.Create;
begin
  inherited;

  FRePaintTimer:=TTimer.Create(nil);
  FRePaintTimer.OnTimer:=Self.DoRePaintTimer;
  FRePaintTimer.Interval:=300;

  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Init_Code_FMX.inc}
end;

destructor TSkinFMXiOSNativeEdit.Destroy;
begin
  FreeAndNil(FRePaintTimer);

  inherited;
end;



initialization
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Unregister(TSkinFMXEdit, TControlType.Platform, TiOSPresentationProxy<TSkinFMXiOSNativeEdit>);
  TPresentationProxyFactory.Current.Register(TSkinFMXEdit, TControlType.Platform, TiOSPresentationProxy<TSkinFMXiOSNativeEdit>);
  {$ENDIF}

finalization
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Unregister(TSkinFMXEdit, TControlType.Platform, TiOSPresentationProxy<TSkinFMXiOSNativeEdit>);
  {$ENDIF}


  {$ENDIF}
  {$ENDIF}


end.



