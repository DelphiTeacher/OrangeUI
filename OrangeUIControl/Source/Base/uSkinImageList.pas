//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     图片列表组件
///   </para>
///   <para>
///     Picture list component
///   </para>
/// </summary>
unit uSkinImageList;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  SysConst,

  {$IFDEF VCL}
  Windows,
  CommCtrl,
  {$ENDIF}

  uBaseList,
  uFuncCommon,
  uDrawPicture,
  uSkinPicture;

type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     图片列表组件
  ///   </para>
  ///   <para>
  ///     Picture list component
  ///   </para>
  /// </summary>
  TSkinImageList=class(TSkinBaseImageList);


implementation



end.

