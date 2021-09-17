//文本框//
//convert pas to utf8 by ¥
unit uSkinFireMonkeyiOSNativeMemo;

interface
{$I FrameWork.inc}

{$I FMXiOSNativeMemo.inc}


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
  FMX.Memo,
  uGraphicCommon,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uBinaryTreeDoc,
  uSkinMemoType,
  uDrawEngine,
  uDrawCanvas,
  uSkinPicture,
//  uSkinPackage,
  uBaseList,
  FMX.Text,
  FMX.Objects,
  uDrawPicture,
  FMX.Memo.Style,
  FMX.Controls.Presentation,
  FMX.Presentation.Factory,
  {$IF CompilerVersion >= 30.0}//>=XE10
  FMX.Presentation.Style,

  {$IFDEF IOS}
//  FMX.Memo.iOS,
  uSkinFMX.Memo.iOS,
  FMX.Presentation.iOS,
  iOSapi.Foundation,
  iOSapi.UIKit,
  {$ENDIF}

  System.TypInfo,

  {$ENDIF}
  uSkinRegManager,
  uSkinBufferBitmap;


  {$IF CompilerVersion >= 30.0}//>=XE10
  {$IFDEF IOS}

Type

  /// <summary>
  ///   文本框
  /// </summary>
  TSkinFMXiOSNativeMemo=class(TSkiniOSNativeMemo)
  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Declare_FMX.inc}

  private
//    FRePaintTimer:TTimer;
//    procedure DoRePaintTimer(Sender:TObject);
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
  uSkinFireMonkeyMemo;


{ TSkinFMXiOSNativeMemo }



function TSkinFMXiOSNativeMemo.GetContentMarginsLeft: Integer;
begin
  Result:=FContentMarginsLeft;
end;

function TSkinFMXiOSNativeMemo.GetContentMarginsTop: Integer;
begin
  Result:=FContentMarginsTop;
end;

function TSkinFMXiOSNativeMemo.GetContentMarginsRight: Integer;
begin
  Result:=FContentMarginsRight;
end;

function TSkinFMXiOSNativeMemo.GetContentMarginsBottom: Integer;
begin
  Result:=FContentMarginsBottom;
end;

//procedure TSkinFMXiOSNativeMemo.DoRePaintTimer(Sender:TObject);
//begin
//  Self.Memo.Repaint;
//end;

procedure TSkinFMXiOSNativeMemo.UpdateContentMargins;
var
  AUIEdgeInsets:UIEdgeInsets;
begin
  AUIEdgeInsets.left:=FContentMarginsLeft;
  AUIEdgeInsets.top:=FContentMarginsTop;
  AUIEdgeInsets.right:=FContentMarginsRight;
  AUIEdgeInsets.bottom:=FContentMarginsBottom;
  Self.View.setContentInset(AUIEdgeInsets);
end;


procedure TSkinFMXiOSNativeMemo.SetContentMarginsLeft(const Value:Integer);
begin
  if FContentMarginsLeft<>Value then
  begin
    FContentMarginsLeft := Value;
    UpdateContentMargins;
  end;
end;

procedure TSkinFMXiOSNativeMemo.SetContentMarginsTop(const Value:Integer);
begin
  if FContentMarginsTop<>Value then
  begin
    FContentMarginsTop := Value;
    UpdateContentMargins;
  end;
end;

procedure TSkinFMXiOSNativeMemo.SetContentMarginsRight(const Value:Integer);
begin
  if FContentMarginsRight<>Value then
  begin
    FContentMarginsRight := Value;
    UpdateContentMargins;
  end;
end;

procedure TSkinFMXiOSNativeMemo.SetContentMarginsBottom(const Value:Integer);
begin
  if FContentMarginsBottom<>Value then
  begin
    FContentMarginsBottom := Value;
    UpdateContentMargins;
  end;
end;

constructor TSkinFMXiOSNativeMemo.Create;
begin
  inherited;

//  FMenuController := TUIMenuController.Wrap(TUIMenuController.OCClass.sharedMenuController);

//  FRePaintTimer:=TTimer.Create(nil);
//  FRePaintTimer.OnTimer:=Self.DoRePaintTimer;
//  FRePaintTimer.Interval:=300;

  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Init_Code_FMX.inc}
end;

destructor TSkinFMXiOSNativeMemo.Destroy;
begin
//  FreeAndNil(FRePaintTimer);

  inherited;
end;



initialization
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Unregister(TSkinFMXMemo, TControlType.Platform, TiOSPresentationProxy<TSkinFMXiOSNativeMemo>);
  TPresentationProxyFactory.Current.Register(TSkinFMXMemo, TControlType.Platform, TiOSPresentationProxy<TSkinFMXiOSNativeMemo>);
  {$ENDIF}

finalization
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Unregister(TSkinFMXMemo, TControlType.Platform, TiOSPresentationProxy<TSkinFMXiOSNativeMemo>);
  {$ENDIF}


  {$ENDIF}
  {$ENDIF}


end.



