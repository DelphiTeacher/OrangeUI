//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     图片框
///   </para>
///   <para>
///     Image Box
///   </para>
/// </summary>
unit uSkinImageType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  ExtCtrls,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  {$ENDIF}

  {$IFDEF IOS}
  FMX.Helpers.iOS,
  {$ENDIF}

  {$IF CompilerVersion >= 30.0}
  System.NetEncoding,
  {$IFEND}

  uBasePageStructure,
  StrUtils,
  Math,
  uUrlPicture,
  Variants,
  uBaseLog,
  uSkinItems,
  uBaseSkinControl,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinImageList,
  uComponentType,
  uFileCommon,
  uDrawEngine,
  uSkinPicture,
  uDrawPicture,
  uDrawTextParam,
  uDrawRectParam,
  uSkinRegManager,
  uDrawPictureParam;



const
  IID_ISkinImage:TGUID='{A53D5EC8-7245-4B6D-B1AB-317EEFEB0EB9}';

type
  TImageProperties=class;



  /// <summary>
  ///   <para>
  ///     图片框接口
  ///   </para>
  ///   <para>
  ///     ImageBox interface
  ///   </para>
  /// </summary>
  ISkinImage=interface//(ISkinControl)
  ['{A53D5EC8-7245-4B6D-B1AB-317EEFEB0EB9}']


    function GetImageProperties:TImageProperties;
    property Properties:TImageProperties read GetImageProperties;
    property Prop:TImageProperties read GetImageProperties;
  end;







  /// <summary>
  ///   <para>
  ///     图片框属性
  ///   </para>
  ///   <para>
  ///     Properties of ImageBox
  ///   </para>
  /// </summary>
  TImageProperties=class(TSkinControlProperties)
  protected
    //可以用作图片的顶部状态栏
    FIsToolBar:Boolean;


    //绘制的图片
    FPicture: TDrawPicture;

    //是否显示GIF图片
    FAnimated: Boolean;
    FAnimateSpeed: Double;
    //GIF的延迟间隔基数
    FGIFDelayExp: Integer;


    FCurrentRotateAngle:Integer;
    FRotated:Boolean;
    FRotateSpeed:Double;
    FRotateIncrement:Integer;

    FRotateTimer:TTimer;

    FAnimateTicket:Integer;

    FSkinImageIntf:ISkinImage;

    procedure SetGIFDelayExp(const Value: Integer);
    procedure DoGIFAnimateRePaint(Sender:TObject);

    function CanRotate:Boolean;
    procedure CreateRotateTimer;
    procedure DoRotateTimer(Sender:TObject);

    procedure SetAnimated(const Value: Boolean);
    procedure SetAnimateSpeed(const Value: Double);

    procedure SetPicture(Value:TDrawPicture);
    procedure DoPictureChanged(Sender: TObject);override;

    procedure SetRotated(const Value: Boolean);
    procedure SetRotateSpeed(const Value: Double);

    procedure SetCurrentRotateAngle(const Value: Integer);
  private
//    FIsClipRound: Boolean;
//    procedure SetIsClipRound(const Value: Boolean);
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  published
    property AutoSize;

//    property IsClipRound:Boolean read FIsClipRound write SetIsClipRound;

    /// <summary>
    ///   <para>
    ///     图片
    ///   </para>
    ///   <para>
    ///     Picture
    ///   </para>
    /// </summary>
    property Picture: TDrawPicture read FPicture write SetPicture;



    /// <summary>
    ///   <para>
    ///     如果当前图片是GIF图片, 是否播放
    ///   </para>
    ///   <para>
    ///     If current picture is GIF picture, whether play
    ///   </para>
    /// </summary>
    property Animated:Boolean read FAnimated write SetAnimated;
    /// <summary>
    ///   <para>
    ///     播放GIF图片的速度
    ///   </para>
    ///   <para>
    ///     Speed of playing GIF picture
    ///   </para>
    /// </summary>
    property AnimateSpeed:Double read FAnimateSpeed write SetAnimateSpeed;
    property GIFDelayExp: Integer read FGIFDelayExp write SetGIFDelayExp;


    /// <summary>
    ///   <para>
    ///     旋转角度
    ///   </para>
    ///   <para>
    ///     Rotate angle
    ///   </para>
    /// </summary>
    property CurrentRotateAngle:Integer read FCurrentRotateAngle write SetCurrentRotateAngle;


    /// <summary>
    ///   <para>
    ///     是否旋转
    ///   </para>
    ///   <para>
    ///     Whether rotate
    ///   </para>
    /// </summary>
    property Rotated:Boolean read FRotated write SetRotated;
    /// <summary>
    ///   <para>
    ///     旋转速度
    ///   </para>
    ///   <para>
    ///     Rotate speed
    ///   </para>
    /// </summary>
    property RotateSpeed:Double read FRotateSpeed write SetRotateSpeed;
    /// <summary>
    ///   <para>
    ///     旋转角度的增量
    ///   </para>
    ///   <para>
    ///     Increment of rotate angle
    ///   </para>
    /// </summary>
    property RotateIncrement:Integer read FRotateIncrement write FRotateIncrement;
  published
    {$IFDEF FMX}
    /// <summary>
    ///   是否是工具栏
    ///   <para>
    ///     Whether is ToolBar
    ///   </para>
    /// </summary>
    property IsToolBar:Boolean read FIsToolBar write FIsToolBar;
    {$ENDIF}
  end;








  /// <summary>
  ///   图片框素材基类
  ///   <para>
  ///     Base class of ImageBox material
  ///   </para>
  /// </summary>
  TSkinImageMaterial=class(TSkinControlMaterial)
  protected
    //图片绘制参数
    FDrawPictureParam:TDrawPictureParam;
    //标题绘制参数
    FDrawCaptionParam:TDrawTextParam;
    procedure SetDrawCaptionParam(const Value: TDrawTextParam);
    procedure SetDrawPictureParam(const Value: TDrawPictureParam);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published

    /// <summary>
    ///   <para>
    ///     图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of picture
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;

    /// <summary>
    ///   <para>
    ///     标题绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of caption
    ///   </para>
    /// </summary>
    property DrawCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
  end;

  TSkinImageType=class(TSkinControlType)
  protected
    FSkinImageIntf:ISkinImage;
    function GetSkinMaterial:TSkinImageMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //计算
    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;
  end;








  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinImageDefaultMaterial=class(TSkinImageMaterial);
  TSkinImageDefaultType=TSkinImageType;







  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinImage=class(TBaseSkinControl,
                  ISkinImage,
                  IBindSkinItemIconControl,
                  IBindSkinItemTextControl,
                  IBindSkinItemBoolControl,
                  IBindSkinItemValueControl,
                  IBindSkinItemObjectControl
                  )
  private
    function GetImageProperties:TImageProperties;
    procedure SetImageProperties(Value:TImageProperties);
  protected
    procedure Loaded;override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  protected
    FItemFieldValue:Variant;
    //多少Item启动了动画
    ItemAnimateRefCount:Integer;
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
    procedure BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
    procedure BindingItemIcon(AIcon:TBaseDrawPicture;AImageList:TObject;AImageIndex:Integer;ARefPicture:TSkinPicture;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
    procedure SetControlObjectByBindItemField(const AFieldName:String;
                                              const AFieldValue:TObject;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  public
//    //针对页面框架的控件接口
//    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;override;

    //获取提交的值,将设置的图片保存到文件夹
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;override;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            AImageServerUrl:String;
                            AValue:Variant;
                            AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);override;
  public
    constructor Create(AOwner:TComponent);override;
    property Prop:TImageProperties read GetImageProperties write SetImageProperties;
  public
    function SelfOwnMaterialToDefault:TSkinImageDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinImageDefaultMaterial;
    function Material:TSkinImageDefaultMaterial;
  published
    property Caption;
    //属性
    property Properties:TImageProperties read GetImageProperties write SetImageProperties;
  end;



  {$IFDEF VCL}
  TSkinWinImage=class(TSkinImage)
  end;
  {$ENDIF VCL}


  TSkinChildImage=TSkinImage;



//将开放平台页面框架的图片值赋给Image
procedure SetDrawPictureValue(APicture:TBaseDrawPicture;
                              APageDataDir:String;
                              AImageServerUrl:String;
                              AValue: Variant//;
//                              var APictureUrl:String
                              );
function GetDrawPictureUrl(AImageServerUrl:String;
                              AValue: Variant):String;

function CreateChildImage(AOwner:TComponent):TSkinChildImage;


implementation


function CreateChildImage(AOwner:TComponent):TSkinChildImage;
begin
  Result:=TSkinChildImage.Create(AOwner);
  Result.Caption:='';
end;






{ TSkinImageType }

function TSkinImageType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinImage,Self.FSkinImageIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinImage Interface');
    end;
  end;
end;

procedure TSkinImageType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinImageIntf:=nil;
end;

function TSkinImageType.GetSkinMaterial: TSkinImageMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinImageMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinImageType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  if Self.GetSkinMaterial<>nil then
  begin


      if Self.FSkinImageIntf.Prop.FAnimated
        //是GIF文件
        and (Self.FSkinImageIntf.Prop.Picture.SkinPictureEngine.CurrentIsGIF)
        //是GIF引擎
        and (Self.FSkinImageIntf.Prop.Picture.SkinPictureEngine is TSkinBaseGIFPictureEngine)
      then
      begin
        //GIF图片播放
        TSkinBaseGIFPictureEngine(Self.FSkinImageIntf.Prop.Picture.SkinPictureEngine).DrawToCanvas(ACanvas,
                                  Self.GetSkinMaterial.FDrawPictureParam,
                                  ADrawRect);
      end
      else
      begin

        //图片旋转
        Self.GetSkinMaterial.FDrawPictureParam.StaticRotateAngle:=Self.FSkinImageIntf.Prop.FCurrentRotateAngle;

        ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                            Self.FSkinImageIntf.Prop.Picture,
                            ADrawRect);
      end;

      //绘制标题
      if Self.FSkinControlIntf.Caption <> '' then
      begin
        ACanvas.DrawText(Self.GetSkinMaterial.FDrawCaptionParam,
                          Self.FSkinControlIntf.Caption,
                          ADrawRect);
      end;

  end;
end;

function TSkinImageType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
begin
  Result:=False;
  AWidth:=0;
  AHeight:=0;

  if not (csReading in Self.FSkinControl.ComponentState)
      and (Self.FSkinControlIntf.GetParent<>nil)
      and (Self.FSkinImageIntf.Prop.FPicture.CurrentPictureDrawWidth>0)
      and (Self.FSkinImageIntf.Prop.FPicture.CurrentPictureDrawHeight>0) then
  begin
    AWidth:=Self.FSkinImageIntf.Prop.FPicture.CurrentPictureDrawWidth;
    AHeight:=Self.FSkinImageIntf.Prop.FPicture.CurrentPictureDrawHeight;
    Result:=True;
  end;

end;


{ TSkinImageMaterial }

constructor TSkinImageMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','标题绘制参数');
  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
end;

destructor TSkinImageMaterial.Destroy;
begin
  FreeAndNil(FDrawCaptionParam);
  FreeAndNil(FDrawPictureParam);
  inherited;
end;

//function TSkinImageMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  I: Integer;
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
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
////    ;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinImageMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawPictureParam',FDrawPictureParam.Name);
////  Self.FDrawPictureParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//
//end;

procedure TSkinImageMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
begin
  FDrawCaptionParam.Assign(Value);
end;

procedure TSkinImageMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;



{ TImageProperties }


procedure TImageProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  FPicture.Assign(TImageProperties(Src).FPicture);
  FAnimated:=TImageProperties(Src).FAnimated;
  FAnimateSpeed:=TImageProperties(Src).FAnimateSpeed;
  FRotated:=TImageProperties(Src).FRotated;
  FRotateSpeed:=TImageProperties(Src).FRotateSpeed;
  FRotateIncrement:=TImageProperties(Src).FRotateIncrement;
end;

function TImageProperties.CanRotate: Boolean;
begin
  Result:=(Self.FPicture.SkinImageList<>nil)
    and (Self.FPicture.SkinImageList.Count>0);
end;

constructor TImageProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinImage,Self.FSkinImageIntf) then
  begin
    ShowException('This Component Do not Support ISkinImage Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=120;
    Self.FSkinControlIntf.Height:=100;

    FPicture:=CreateDrawPicture('Image.Picture','Image.图片');
    FPicture.GIFSupport:=True;
    FPicture.OnAnimateRePaint:=Self.DoGIFAnimateRePaint;
    FPicture.OnChange:=DoPictureChanged;

  {$IFDEF FAST_AS_HELL}
    FGIFDelayExp:= 10;		// Delay multiplier in mS.
  {$ELSE}
    FGIFDelayExp:= 12;		// Delay multiplier in mS. Tweaked.
  {$ENDIF}

    FAnimated:=False;
    FAnimateSpeed:=10;

    FRotated:=False;
    FRotateSpeed:=5;
    FRotateIncrement:=20;
    FCurrentRotateAngle:=0;

  end;

end;

procedure TImageProperties.CreateRotateTimer;
begin
  if FRotateTimer=nil then
  begin
    FRotateTimer:=TTimer.Create(nil);
    FRotateTimer.OnTimer:=Self.DoRotateTimer;
    FRotateTimer.Interval:=Ceil(Self.FRotateSpeed*10);
    FRotateTimer.Enabled:=False;
  end;
end;

destructor TImageProperties.Destroy;
begin
  FreeAndNil(FRotateTimer);

  FreeAndNil(FPicture);
  inherited;
end;

procedure TImageProperties.DoGIFAnimateRePaint(Sender: TObject);
begin
  //重绘
  Self.Invalidate;
end;

procedure TImageProperties.DoRotateTimer(Sender: TObject);
begin

  Inc(FAnimateTicket);

  if Not CanRotate then
  begin
      //如果没有图片列表,那么切换角度来滚动
      if FCurrentRotateAngle>=360 then
      begin
        FCurrentRotateAngle:=0;
      end;

      FCurrentRotateAngle:=FCurrentRotateAngle+Self.FRotateIncrement;

      if FCurrentRotateAngle>360 then
      begin
        FCurrentRotateAngle:=360;
      end;
  end
  else
  begin
      //如果有图片列表,那么切换ImageIndex来滚动
      if Self.FPicture.SkinImageList.Count>1 then
      begin
        Self.FPicture.ImageIndex:=
            (Self.FPicture.ImageIndex+1)
              mod Self.FPicture.SkinImageList.Count;
      end;
  end;

  Self.Invalidate;

end;

procedure TImageProperties.SetAnimated(const Value: Boolean);
begin
  if FAnimated<>Value then
  begin
    FAnimated := Value;
    TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).Animated:=FAnimated;
  end;
end;

procedure TImageProperties.SetAnimateSpeed(const Value: Double);
begin
  if FAnimateSpeed<>Value then
  begin
    FAnimateSpeed := Value;
    TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).AnimateSpeed:=FAnimateSpeed;
  end;
end;

procedure TImageProperties.SetCurrentRotateAngle(const Value: Integer);
begin
  if FCurrentRotateAngle<>Value then
  begin
    FCurrentRotateAngle := Value;
    Self.Invalidate;
  end;
end;

procedure TImageProperties.SetGIFDelayExp(const Value: Integer);
begin
  if FGIFDelayExp<>Value then
  begin
    if Value<=0 then
    begin
      FGIFDelayExp := 1;
    end
    else
    begin
      FGIFDelayExp := Value;
    end;
    TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).GIFDelayExp:=FGIFDelayExp;
  end;
end;

//procedure TImageProperties.SetIsClipRound(const Value: Boolean);
//begin
//  if FIsClipRound<>Value then
//  begin
//    FIsClipRound := Value;
//
//    Self.Picture.IsClipRound:=Value;
//  end;
//end;

procedure TImageProperties.SetPicture(Value: TDrawPicture);
begin
  FPicture.Assign(Value);
end;

procedure TImageProperties.SetRotated(const Value: Boolean);
begin
  if FRotated<>Value then
  begin
    FRotated := Value;
    if FRotated then
    begin
        //启动旋转动画
        Self.CreateRotateTimer;
        if Self.FRotateTimer<>nil then
        begin
          Self.FRotateTimer.Enabled:=True;
        end;
    end
    else
    begin
        //停止
        if Self.FRotateTimer<>nil then
        begin
          Self.FRotateTimer.Enabled:=False;
        end;
    end;
  end;
end;

procedure TImageProperties.SetRotateSpeed(const Value: Double);
begin
  if FRotateSpeed<>Value then
  begin
    FRotateSpeed := Value;
    if Self.FRotateTimer<>nil then
    begin
      Self.FRotateTimer.Interval:=Ceil(FRotateSpeed*10);
      Self.FRotateTimer.Enabled:=Self.FRotated;
    end;
  end;
end;

procedure TImageProperties.DoPictureChanged(Sender: TObject);
begin
  Self.AdjustAutoSizeBounds;
  Inherited;
end;

function TImageProperties.GetComponentClassify: String;
begin
  Result:='SkinImage';
end;



{ TSkinImage }


constructor TSkinImage.Create(AOwner:TComponent);
begin
  inherited;
end;

function TSkinImage.SelfOwnMaterialToDefault:TSkinImageDefaultMaterial;
begin
  Result:=TSkinImageDefaultMaterial(SelfOwnMaterial);
end;

function TSkinImage.Material:TSkinImageDefaultMaterial;
begin
  Result:=TSkinImageDefaultMaterial(SelfOwnMaterial);
end;
function TSkinImage.CurrentUseMaterialToDefault:TSkinImageDefaultMaterial;
begin
  Result:=TSkinImageDefaultMaterial(CurrentUseMaterial);
end;

function TSkinImage.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String): Variant;
begin
  Result:='';


  if Self.Prop.Picture.IsChanged then
  begin
      //改过,用新的

      //将图片保存到临时目录
      //返回相对路径
      if not Self.Prop.Picture.IsEmpty then
      begin
        SysUtils.ForceDirectories(APageDataDir+'pics\');
        //以控件名为命名的图片文件名
        //框架的图片
        Self.Prop.Picture.SaveToFile(APageDataDir+'pics\'+Name+'.png');

        Result:=Name+'.png';
      end;

  end
  else if not VarIsNULL(FItemFieldValue) then
  begin
    Result:=FItemFieldValue;
  end
  else
  begin
      //没有改过,用旧的,是url
      Result:=Self.Prop.Picture.Name;


      if (Self.Prop.Picture.Url<>'')
        and (Self.Prop.Picture.UrlPicture<>nil)
        and (Self.Prop.Picture.UrlPicture.State=dpsDownloadSucc) then
      begin
        SysUtils.ForceDirectories(APageDataDir+'pics\');
        //以控件名为命名的图片文件名
        //框架的图片
        Self.Prop.Picture.UrlPicture.Picture.SaveToFile(APageDataDir+'pics\'+Name+'.png');
      end;

  end;


end;

function TSkinImage.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TImageProperties;
end;

function TSkinImage.GetImageProperties: TImageProperties;
begin
  Result:=TImageProperties(Self.FProperties);
end;

procedure TSkinImage.SetControlObjectByBindItemField(const AFieldName: String;
  const AFieldValue: TObject; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
begin
  //有图片
//  if (Self.Prop.Picture.StaticPictureDrawType<>pdtReference) or (Self.Prop.Picture.StaticPictureDrawType<>pdtRefDrawPicture) then


  Self.Prop.Picture.StaticPictureDrawType:=pdtReference;


  if AFieldValue<>nil then
  begin

      //是否圆形根据图片控件设置
      TSkinPicture(AFieldValue).IsClipRound:=Self.Prop.Picture.IsClipRound or TSkinPicture(AFieldValue).IsClipRound;


      if (AFieldValue is TBaseDrawPicture) and (TBaseDrawPicture(AFieldValue).PictureDrawType=pdtRefDrawPicture) then
      begin
        Self.Prop.Picture.StaticPictureDrawType:=pdtRefDrawPicture;
        Self.Prop.Picture.StaticRefDrawPicture:=TDrawPicture(AFieldValue);
      end
      else if AFieldValue is TBaseDrawPicture then
      begin
        Self.Prop.Picture.StaticRefPicture:=TDrawPicture(AFieldValue).CurrentPicture;
      end
      else
      begin
        Self.Prop.Picture.StaticRefPicture:=TSkinPicture(AFieldValue);
      end;

  end
  else
  begin
      Self.Prop.Picture.StaticRefPicture:=nil;
  end;
end;

procedure TSkinImage.SetControlValueByBindItemField(const AFieldName: String;
  const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
var
  AFieldValueStr:String;
  ATempImageIndex:Integer;
  ATempBindDrawPicture:TDrawPicture;

  APicStream:TMemoryStream;
  AStringStream:TStringStream;
begin
//  if AFieldValue.Picture<>nil then
//  begin
//      //有图片
//      Self.Prop.Picture.StaticPictureDrawType:=pdtReference;
//      Self.Prop.Picture.StaticRefPicture:=AFieldValue.Picture;
//  end
//  else
  //用于判断图片有没有内容，用于页面框自动尺寸,内容为空,则Image的width将被设置为0
  FItemFieldValue:=AFieldValue;

  if VarType(AFieldValue)=varInteger then
  begin
      //只有下标
      Self.Prop.Picture.StaticImageIndex:=AFieldValue;
  end
  else if VarType(AFieldValue)=varBoolean then
  begin
      //只有是否,可以用于绑定TreeViewItem.Expanded等不同状态切换下标
      if not AFieldValue then
      begin
        Self.Prop.Picture.StaticImageIndex:=0;
      end
      else
      begin
        Self.Prop.Picture.StaticImageIndex:=1;
      end;
  end
  else
  begin
      AFieldValueStr:=AFieldValue;


      if (NewDelphiStringIndexOf(#13#10,AFieldValueStr)) then
      begin
          //是图片的Base64
          //但也不能每次都转换一下,毕竟Base64的字符串那么长
          //根据长度来判断吧

          ATempBindDrawPicture:=TBaseSkinItem(ASkinItem).FTempBindDrawPictureList.ItemsByName[AFieldName];
          if ATempBindDrawPicture=nil then
          begin
            ATempBindDrawPicture:=TBaseSkinItem(ASkinItem).FTempBindDrawPictureList.Add;
            ATempBindDrawPicture.ImageName:=AFieldName;
          end;
          //是否圆形根据图片控件设置
          ATempBindDrawPicture.IsClipRound:=Prop.Picture.IsClipRound or ATempBindDrawPicture.IsClipRound;

         if ATempBindDrawPicture.Base64Length<>Length(AFieldValueStr) then
         begin
              //有回车符,是Base64编码
              //Base64
              AStringStream:=TStringStream.Create(AFieldValueStr,TEncoding.UTF8);
              APicStream:=TMemoryStream.Create;
              try
                AStringStream.Position:=0;

        //        AStringStream.SaveToFile('C:\bad.base64');


                {$IF CompilerVersion >= 30.0}
                TNetEncoding.Base64.Decode(AStringStream,APicStream);
                {$IFEND}
                APicStream.Position:=0;

                //要引用
                //TSkinItem(ASkinItem).Icon.LoadFromStream(APicStream);
                //Self.Prop.Picture.LoadFromStream(APicStream);




                ATempBindDrawPicture.LoadFromStream(APicStream);

                ATempBindDrawPicture.Base64Length:=Length(AFieldValueStr);

              finally
                FreeAndNil(APicStream);
                FreeAndNil(AStringStream);
              end;

         end;

        Self.Prop.Picture.StaticPictureDrawType:=pdtReference;
        Self.Prop.Picture.StaticRefPicture:=ATempBindDrawPicture.CurrentPicture;

      end
      else if (NewDelphiStringIndexOf('http://',LowerCase(AFieldValueStr)))
        or (NewDelphiStringIndexOf('https://',LowerCase(AFieldValueStr))) then
      begin
          //图片的链接
          ATempBindDrawPicture:=TBaseSkinItem(ASkinItem).FTempBindDrawPictureList.ItemsByName[AFieldName];
          if ATempBindDrawPicture=nil then
          begin
            ATempBindDrawPicture:=TBaseSkinItem(ASkinItem).FTempBindDrawPictureList.Add;
            ATempBindDrawPicture.ImageName:=AFieldName;
          end;
          //是否圆形根据图片控件设置
          ATempBindDrawPicture.IsClipRound:=Prop.Picture.IsClipRound or ATempBindDrawPicture.IsClipRound;
          ATempBindDrawPicture.Url:=AFieldValueStr;


//          Self.Prop.Picture.StaticPictureDrawType:=pdtReference;
//          //这里调用CurrentPicture会造成立即下载
//          Self.Prop.Picture.StaticRefPicture:=ATempBindDrawPicture.CurrentPicture;
          //这样不会造成立即下载
          Self.Prop.Picture.StaticPictureDrawType:=pdtRefDrawPicture;
          Self.Prop.Picture.StaticRefDrawPicture:=ATempBindDrawPicture;


          //要刷新下ListBox,或者等图片下载完,刷新下ListBox
          //下载完图片,找到FTempBindDrawPictureList,再找到TSkinItem,刷新
          ATempBindDrawPicture.OnChange:=TBaseSkinItem(ASkinItem).DoPropChange;

      end
      else
      begin
          //图片的下标
          //Item.Detail为'0'、'1'、'2'表示设置Image的ImageIndex,为空时表示-1
          ATempImageIndex:=-1;
          if (AFieldValueStr<>'') and TryStrToInt(AFieldValueStr,ATempImageIndex) then
          begin
          end;
          Self.Prop.Picture.StaticPictureDrawType:=pdtImageList;
          Self.Prop.Picture.StaticImageIndex:=ATempImageIndex;

      end;

  end;


end;

procedure TSkinImage.SetImageProperties(Value: TImageProperties);
begin
  Self.FProperties.Assign(Value);
end;

function GetDrawPictureUrl(AImageServerUrl:String;
                              AValue: Variant):String;
begin
  Result:=AValue;


//  //如果本地不存在图片,那就远程取
//  if (APicPath<>'') then
//  begin
//      if not FileExists(APageDataDir+'pics\'+AFieldControlSetting.value) then
//      begin
//          //没有绑定,那么需要设置初始值,界面设计时的值,设计时的值,保存在开放平台,appid为1000的服务器上
//          //图片都从服务器下载
//          if (APicPath.IndexOf('http://')>=0)
//            or (APicPath.IndexOf('https://')>=0) then
//          begin
//              //不用加服务端地址了
//          end
//          else
//          begin
//              //加上图片服务器的链接
//              APicPath:=GlobalMainProgram.OpenPlatformImageUrl+ReplaceStr(APicPath,'\','/');;
//          end;
//      end;
//  end;

  //图片都从服务器下载
//  APicPath:=AResult.DataJson.V[AFieldControlSettingMap.Setting.field_name];
  if (Result<>'') then
  begin
      if (NewDelphiStringIndexOf(#13#10,Result)) then
      begin
        //Base64
      end

//      {$IF CompilerVersion >= 30.0}
//      else if (Result.IndexOf('http://')>=0)
//        or (Result.IndexOf('https://')>=0) then
//      begin
//          //不用加服务端地址了
//      end
//      {$ELSE}
      else if (NewDelphiStringIndexOf('http://',Result))
        or (NewDelphiStringIndexOf('https://',Result)) then
      begin
          //不用加服务端地址了
      end
//      {$IFEND}

      else
      begin
          //加上图片服务器的链接
          Result:=AImageServerUrl+ReplaceStr(Result,'\','/');;
      end;

  end;
end;

procedure SetDrawPictureValue(APicture:TBaseDrawPicture;
                              APageDataDir:String;
                              AImageServerUrl:String;
                              AValue: Variant//;
//                              var APictureUrl:String
                              );
var
  APicPath:String;
  APicStream:TMemoryStream;
  AStringStream:TStringStream;
begin
//  APictureUrl:='';

  APicPath:=AValue;


//  //如果本地不存在图片,那就远程取
//  if (APicPath<>'') then
//  begin
//      if not FileExists(APageDataDir+'pics\'+AFieldControlSetting.value) then
//      begin
//          //没有绑定,那么需要设置初始值,界面设计时的值,设计时的值,保存在开放平台,appid为1000的服务器上
//          //图片都从服务器下载
//          if (APicPath.IndexOf('http://')>=0)
//            or (APicPath.IndexOf('https://')>=0) then
//          begin
//              //不用加服务端地址了
//          end
//          else
//          begin
//              //加上图片服务器的链接
//              APicPath:=GlobalMainProgram.OpenPlatformImageUrl+ReplaceStr(APicPath,'\','/');;
//          end;
//      end;
//  end;

  //图片都从服务器下载
//  APicPath:=AResult.DataJson.V[AFieldControlSettingMap.Setting.field_name];
  if (APicPath<>'') and (APicPath<>'Image.Picture') then
  begin


      if (NewDelphiStringIndexOf(#13#10,APicPath)) then
      begin
        //Base64
      end

//      {$IF CompilerVersion >= 30.0}
//      else if (APicPath.IndexOf('http://')>=0)
//        or (APicPath.IndexOf('https://')>=0) then
//      begin
//          //不用加服务端地址了
//      end
//      {$ELSE}
      else if (NewDelphiStringIndexOf('http://',APicPath))
        or (NewDelphiStringIndexOf('https://',APicPath)) then
      begin
          //不用加服务端地址了
      end
//      {$IFEND}

      else
      begin
          //加上图片服务器的链接
          APicPath:=AImageServerUrl+ReplaceStr(APicPath,'\','/');
      end;

  end;



  if APicture<>nil then
  begin
    APicture.Clear;
  end;



  if (NewDelphiStringIndexOf(#13#10,APicPath)) then
  begin
      if APicture<>nil then
      begin
          //有回车符,是Base64编码
          //Base64
          AStringStream:=TStringStream.Create(APicPath,TEncoding.UTF8);
          APicStream:=TMemoryStream.Create;
          try
            AStringStream.Position:=0;

    //        AStringStream.SaveToFile('C:\bad.base64');

            {$IF CompilerVersion >= 30.0}
            TNetEncoding.Base64.Decode(AStringStream,APicStream);
            {$IFEND}

            APicStream.Position:=0;
            APicture.LoadFromStream(APicStream);
          finally
            FreeAndNil(APicStream);
            FreeAndNil(AStringStream);
          end;
      end;
  end
  else
  //先从本地找图片是否存在,如果本地不存在,再找远程的
  if FileExists(APageDataDir+'pics\'+APicPath) then
  begin
      if APicture<>nil then
      begin
          //以控件名为命名的图片文件名
          //框架的图片
          APicture.LoadFromFile(APageDataDir+'pics\'+APicPath);
      end;
  end
//  else if (Pos('http://',LowerCase(APicPath))>0)
//    or (Pos('https://',LowerCase(APicPath))>0) then


//  {$IF CompilerVersion >= 30.0}
//  else if (APicPath.IndexOf('http://')>=0)
//    or (APicPath.IndexOf('https://')>=0) then
//  begin
//      if APicture<>nil then
//      begin
//          //链接
//          APicture.Url:=APicPath;
//
//          //加载到自己里面
//    //      Self.Prop.Picture.IsLoadUrlPictureToSelf:=True;
//      end;
//  end
//  {$ELSE}
  else if (NewDelphiStringIndexOf('http://',APicPath))
    or (NewDelphiStringIndexOf('https://',APicPath)) then
  begin
      if APicture<>nil then
      begin
          //链接
          APicture.Url:=APicPath;

          //加载到自己里面
    //      Self.Prop.Picture.IsLoadUrlPictureToSelf:=True;
      end;
  end
//  {$IFEND}

  else
  begin
  end;


  if APicture<>nil then
  begin
      APicture.Name:=AValue;


      APicture.IsChanged:=False;
  end;


end;

procedure TSkinImage.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;
                                      AImageServerUrl:String;
                                      AValue: Variant;
                                      AValueCaption:String;
                                      //要设置多个值,整个字段的记录
                                      AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
//var
//  APicPath:String;
//  APicStream:TMemoryStream;
//  AStringStream:TStringStream;
begin
  SetDrawPictureValue(Self.Prop.Picture,APageDataDir,AImageServerUrl,AValue);

  //要刷新，不然在页面框架中切换的时候不会刷新
  Self.Invalidate;

//  APicPath:=AValue;
//
//
////  //如果本地不存在图片,那就远程取
////  if (APicPath<>'') then
////  begin
////      if not FileExists(APageDataDir+'pics\'+AFieldControlSetting.value) then
////      begin
////          //没有绑定,那么需要设置初始值,界面设计时的值,设计时的值,保存在开放平台,appid为1000的服务器上
////          //图片都从服务器下载
////          if (APicPath.IndexOf('http://')>=0)
////            or (APicPath.IndexOf('https://')>=0) then
////          begin
////              //不用加服务端地址了
////          end
////          else
////          begin
////              //加上图片服务器的链接
////              APicPath:=GlobalMainProgram.OpenPlatformImageUrl+ReplaceStr(APicPath,'\','/');;
////          end;
////      end;
////  end;
//
//  //图片都从服务器下载
////  APicPath:=AResult.DataJson.V[AFieldControlSettingMap.Setting.field_name];
//  if (APicPath<>'') then
//  begin
//      if (APicPath.IndexOf(#13#10)>=0) then
//      begin
//        //Base64
//      end
//      else if (APicPath.IndexOf('http://')>=0)
//        or (APicPath.IndexOf('https://')>=0) then
//      begin
//          //不用加服务端地址了
//      end
//      else
//      begin
//          //加上图片服务器的链接
//          APicPath:=AImageServerUrl+ReplaceStr(APicPath,'\','/');;
//      end;
//
//  end;
//
//
//
//  Self.Prop.Picture.Clear;
//
//
//
//  if (APicPath.IndexOf(#13#10)>=0) then
//  begin
//      //有回车符,是Base64编码
//      //Base64
//      AStringStream:=TStringStream.Create(APicPath,TEncoding.UTF8);
//      APicStream:=TMemoryStream.Create;
//      try
//        AStringStream.Position:=0;
//
////        AStringStream.SaveToFile('C:\bad.base64');
//
//        TNetEncoding.Base64.Decode(AStringStream,APicStream);
//        APicStream.Position:=0;
//        Self.Prop.Picture.LoadFromStream(APicStream);
//      finally
//        FreeAndNil(APicStream);
//        FreeAndNil(AStringStream);
//      end;
//  end
//  else
//  //先从本地找图片是否存在,如果本地不存在,再找远程的
//  if FileExists(APageDataDir+'pics\'+APicPath) then
//  begin
//      //以控件名为命名的图片文件名
//      //框架的图片
//      Self.Prop.Picture.LoadFromFile(APageDataDir+'pics\'+APicPath);
//  end
////  else if (Pos('http://',LowerCase(APicPath))>0)
////    or (Pos('https://',LowerCase(APicPath))>0) then
//  else if (APicPath.IndexOf('http://')>=0)
//    or (APicPath.IndexOf('https://')>=0) then
//  begin
//      //链接
//      Self.Prop.Picture.Url:=APicPath;
//
//      //加载到自己里面
////      Self.Prop.Picture.IsLoadUrlPictureToSelf:=True;
//  end
//  else
//  begin
//  end;
//
//
//  Self.Prop.Picture.Name:=AValue;
//
//
//  Self.Prop.Picture.IsChanged:=False;
end;

procedure TSkinImage.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetImageProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure TSkinImage.Loaded;
begin
  Inherited;
  if Self.GetImageProperties.Animated then
  begin
    if Self.GetImageProperties.Picture.SkinPictureEngine is TSkinBaseGIFPictureEngine then
    begin
      TSkinBaseGIFPictureEngine(Self.GetImageProperties.Picture.SkinPictureEngine).StartAnimate;
    end;
  end;

  {$IFDEF FMX}
  //更新工具栏
  SetControlAsToolBar(Self,Self.Properties.IsToolBar);
  {$ENDIF}

end;

//function TSkinImage.LoadFromFieldControlSetting(ASetting: TFieldControlSetting;AFieldControlSettingMap:TObject): Boolean;
//begin
//  Result:=Inherited;
////  Self.Prop.Picture.Url:=ASetting.pic_path;
//end;

procedure TSkinImage.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
var
  AImageIndex:Integer;
  AItem:TSkinItem;
  ATempBindDrawPicture:TDrawPicture;
begin
  AItem:=TSkinItem(ASkinItem);

  if AItem.AnimateEnable
    and Self.Prop.CanRotate
    and (AItem.AnimateItemBindingName=AName) then
  begin

      if csDesigning in Self.ComponentState then
      begin
          //设计时不启用

      end
      else
      begin
          //使用动画
          if AItem.AnimateStarted then
          begin
              if AItem.AnimateIsFirstStart then
              begin
                Inc(ItemAnimateRefCount);
                //第一次启动
                AItem.AnimateIsFirstStart:=False;
                //保存初始值
                AItem.AnimateStartTicket:=Self.Prop.FAnimateTicket;
                Self.Prop.Rotated:=True;
                Self.Prop.Picture.StaticImageIndex:=0;
              end
              else
              begin
                //第二次启动
                Self.Prop.Picture.StaticImageIndex:=
                  (Self.Prop.FAnimateTicket-AItem.AnimateStartTicket)
                    mod Self.Prop.Picture.SkinImageList.Count;
              end;
          end
          else
          begin
              if AItem.AnimateIsFirstStop then
              begin
                Dec(ItemAnimateRefCount);
                AItem.AnimateIsFirstStop:=False;

                if ItemAnimateRefCount=0 then
                begin
                  //动画停止
                  Self.Prop.Rotated:=False;
                end;

              end;
              Self.Prop.Picture.StaticImageIndex:=-1;
          end;
      end;

  end
  else
  begin

      if (NewDelphiStringIndexOf('http://',LowerCase(AText)))
        or (NewDelphiStringIndexOf('https://',LowerCase(AText))) then
      begin
            //图片的链接
            ATempBindDrawPicture:=AItem.FTempBindDrawPictureList.ItemsByName[AName];
            if ATempBindDrawPicture=nil then
            begin
              ATempBindDrawPicture:=AItem.FTempBindDrawPictureList.Add;
              ATempBindDrawPicture.ImageName:=AName;
            end;
            //是否圆形根据图片控件设置
            ATempBindDrawPicture.IsClipRound:=Prop.Picture.IsClipRound or ATempBindDrawPicture.IsClipRound;
            ATempBindDrawPicture.Url:=AText;

            Self.Prop.Picture.StaticPictureDrawType:=pdtReference;
            Self.Prop.Picture.StaticRefPicture:=ATempBindDrawPicture.CurrentPicture;

      end
      else
      begin
            //图片的下标
            //Item.Detail为'0'、'1'、'2'表示设置Image的ImageIndex,为空时表示-1
            AImageIndex:=-1;
            if (AText<>'') and TryStrToInt(AText,AImageIndex) then
            begin
            end;
            Self.Prop.Picture.StaticImageIndex:=AImageIndex;

      end;

  end;

end;

procedure TSkinImage.BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
var
  ImageIndex:Integer;
begin
  //可以绑定Item.Checked,Selected,如果为True表示是1,为False是0
  if not ABool then
  begin
    ImageIndex:=0;
  end
  else
  begin
    ImageIndex:=1;
  end;
  Self.Prop.Picture.StaticImageIndex:=ImageIndex;
end;

procedure TSkinImage.BindingItemIcon(AIcon:TBaseDrawPicture;AImageList:TObject;AImageIndex:Integer;ARefPicture:TSkinPicture;AIsDrawItemInteractiveState:Boolean);
begin
  if ((AIcon<>nil) and (AIcon.ImageIndex<>-1)) then
  begin
      //使用下标AItem.Icon.ImageIndex
      Self.Prop.Picture.StaticPictureDrawType:=pdtImageList;
      Self.Prop.Picture.StaticImageIndex:=AIcon.ImageIndex;
      if AIcon.SkinImageList<>nil then
      begin
        //使用ListBox自带的
        Self.Prop.Picture.StaticSkinImageList:=AIcon.SkinImageList;
      end
      else
      begin
        //使用自带的
      end;
  end
  else if (AImageIndex<>-1) then
  begin
      //使用Item.IconImageIndex
      Self.Prop.Picture.StaticPictureDrawType:=pdtImageList;
      Self.Prop.Picture.StaticImageIndex:=AImageIndex;
      if AImageList<>nil then
      begin
        Self.Prop.Picture.StaticSkinImageList:=TSkinImageList(AImageList);
      end
      else
      begin
        //使用自带的
      end;
  end
  else if (ARefPicture<>nil) then
  begin
      //使用Item.RefPicture
      Self.Prop.Picture.StaticPictureDrawType:=pdtReference;
      Self.Prop.Picture.StaticRefPicture:=ARefPicture;

      //是否圆形根据图片控件设置
      ARefPicture.IsClipRound:=Prop.Picture.IsClipRound or ARefPicture.IsClipRound;

  end
  else
  begin



      //使用Item.Icon
      Self.Prop.Picture.StaticPictureDrawType:=pdtReference;
      if AIcon<>nil then
      begin
          //是否圆形根据图片控件设置
          AIcon.IsClipRound:=Prop.Picture.IsClipRound or AIcon.IsClipRound;



          if (AIcon is TBaseDrawPicture) and (TBaseDrawPicture(AIcon).PictureDrawType=pdtRefDrawPicture) then
          begin
            Self.Prop.Picture.StaticPictureDrawType:=pdtRefDrawPicture;
            Self.Prop.Picture.StaticRefDrawPicture:=TDrawPicture(AIcon);
          end
          else if (AIcon is TBaseDrawPicture) then
          begin
            Self.Prop.Picture.StaticRefPicture:=AIcon.CurrentPicture;
          end
          else
          begin
            Self.Prop.Picture.StaticRefPicture:=AIcon;
          end;


//        Self.Prop.Picture.StaticRefPicture:=AIcon.CurrentPicture;
      end
      else
      begin
        Self.Prop.Picture.StaticRefPicture:=nil;
      end;


  end;

end;




end.




