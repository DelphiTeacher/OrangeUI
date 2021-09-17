//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     弹出框
///   </para>
///   <para>
///     Popup Box
///   </para>
/// </summary>
unit uSkinPopupType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  StdCtrls,
  Forms,
  ExtCtrls,
  Graphics,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  {$ENDIF}
  uSkinPublic,
  uGraphicCommon,
  uBaseLog,
  uBinaryTreeDoc,
//  uSkinPackage,
  uSkinRegManager,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinMaterial,
  uComponentType,
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uDrawPictureParam;

const
  IID_ISkinPopup:TGUID='{9FD2137C-A17E-4D91-AEF8-787FBAE9BB69}';



type
  TPopupProperties=class;




  /// <summary>
  ///   <para>
  ///     弹出框接口
  ///   </para>
  ///   <para>
  ///     Interface of Popup Box
  ///   </para>
  /// </summary>
  ISkinPopup=interface//(ISkinControl)
    ['{9FD2137C-A17E-4D91-AEF8-787FBAE9BB69}']

    function GetPopupProperties:TPopupProperties;
    property Properties:TPopupProperties read GetPopupProperties;
    property Prop:TPopupProperties read GetPopupProperties;
  end;





  //
  /// <summary>
  ///   <para>
  ///     弹出框属性
  ///   </para>
  ///   <para>
  ///     Popup Box properties
  ///   </para>
  /// </summary>
  TPopupProperties=class(TSkinControlProperties)
  protected
    //弹出框接口
    FSkinPopupIntf:ISkinPopup;
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  end;









  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     弹出框默认素材
  ///   </para>
  ///   <para>
  ///     Popup Box default material
  ///   </para>
  /// </summary>
  TSkinPopupDefaultMaterial=class(TSkinControlMaterial)
  private
    //背景图片
    FBackGndPicture:TDrawPicture;
    //图片绘制参数
    FDrawBackGndPictureParam:TDrawPictureParam;
    procedure SetBackGndPicture(const Value: TDrawPicture);
    procedure SetDrawBackGndPictureParam(const Value: TDrawPictureParam);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //
    /// <summary>
    ///   <para>
    ///     背景图片
    ///   </para>
    ///   <para>
    ///     Background picture
    ///   </para>
    /// </summary>
    property BackGndPicture:TDrawPicture read FBackGndPicture write SetBackGndPicture;
    //
    /// <summary>
    ///   <para>
    ///     图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of picture
    ///   </para>
    /// </summary>
    property DrawBackGndPictureParam:TDrawPictureParam read FDrawBackGndPictureParam write SetDrawBackGndPictureParam;
  end;

  TSkinPopupDefaultType=class(TSkinControlType)
  protected
    //弹出框接口
    FSkinPopupIntf:ISkinPopup;
    function GetSkinMaterial:TSkinPopupDefaultMaterial;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //绘制边框
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;









implementation





{ TSkinPopupDefaultType }


function TSkinPopupDefaultType.GetSkinMaterial: TSkinPopupDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinPopupDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinPopupDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  //绘制背景图片
  ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawBackGndPictureParam,Self.GetSkinMaterial.BackGndPicture,ADrawRect);
end;

function TSkinPopupDefaultType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinPopup,Self.FSkinPopupIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinPopup Interface');
    end;
  end;
end;

procedure TSkinPopupDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinPopupIntf:=nil;
end;


{ TSkinPopupDefaultMaterial }


constructor TSkinPopupDefaultMaterial.Create;
begin
  inherited Create(AOwner);
  FBackGndPicture:=CreateDrawPicture('BackGndPicture','背景图片');

  FDrawBackGndPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
  FDrawBackGndPictureParam.IsStretch:=True;
end;

//function TSkinPopupDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  I: Integer;
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited LoadFromDocNode(ADocNode);
//
////  for I := 0 to ADocNode.ChildNodes.Count - 1 do
////  begin
////    ABTNode:=ADocNode.ChildNodes[I];
////    if ABTNode.NodeName='DrawPictureParam' then
////    begin
////      FDrawPictureParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='BackGndPicture' then
////    begin
////      FBackGndPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HoverPicture' then
////    begin
////      FHoverPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='DisabledPicture' then
////    begin
////      FDisabledPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    ;
////
////  end;
//
//  Result:=True;
//end;
//
//function TSkinPopupDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawPictureParam',FDrawPictureParam.Name);
////  Self.FDrawPictureParam.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('BackGndPicture',FBackGndPicture.Name);
////  Self.FBackGndPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('HoverPicture',FHoverPicture.Name);
////  Self.FHoverPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('DisabledPicture',FDisabledPicture.Name);
////  Self.FDisabledPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
//
//  Result:=True;
//end;

destructor TSkinPopupDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawBackGndPictureParam);
  FreeAndNil(FBackGndPicture);
  inherited;
end;

procedure TSkinPopupDefaultMaterial.SetDrawBackGndPictureParam(const Value: TDrawPictureParam);
begin
  FDrawBackGndPictureParam.Assign(Value);
end;

procedure TSkinPopupDefaultMaterial.SetBackGndPicture(const Value: TDrawPicture);
begin
  Self.FBackGndPicture.Assign(Value);
end;


{ TPopupProperties }


function TPopupProperties.GetComponentClassify: String;
begin
  Result:='SkinPopup';
end;

procedure TPopupProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

constructor TPopupProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinPopup,Self.FSkinPopupIntf) then
  begin
    ShowException('This Component Do not Support ISkinPopup Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=100;
  end;
end;

destructor TPopupProperties.Destroy;
begin
  inherited;
end;



end.

