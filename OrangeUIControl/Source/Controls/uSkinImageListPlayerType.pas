//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     图片列表播放框
///   </para>
///   <para>
///     ImageList player Box
///   </para>
/// </summary>
unit uSkinImageListPlayerType;

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
  Math,
  uBaseLog,
  uBaseSkinControl,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinAnimator,
  uSkinImageList,
  uComponentType,
  uDrawEngine,
  uSkinPicture,
  uDrawPicture,
  uSkinButtonType,
  uDrawTextParam,
  uDrawRectParam,
  uSkinRegManager,
  uDrawPictureParam;



const
  IID_ISkinImageListPlayer:TGUID='{A53D5EC8-7245-4B6D-B1AB-317EEFEB0EB8}';

type
  TImageListPlayerProperties=class;




  /// <summary>
  ///   <para>
  ///     图片列表播放框接口
  ///   </para>
  ///   <para>
  ///     Interface of ImageList Player
  ///   </para>
  /// </summary>
  ISkinImageListPlayer=interface//(ISkinControl)
  ['{A53D5EC8-7245-4B6D-B1AB-317EEFEB0EB8}']

    //绑定的按钮控件
    function GetSwitchButtonGroup:TSkinBaseButtonGroup;
    function GetSwitchButtonGroupIntf:ISkinButtonGroup;


    function GetImageListPlayerProperties:TImageListPlayerProperties;
    property Properties:TImageListPlayerProperties read GetImageListPlayerProperties;
    property Prop:TImageListPlayerProperties read GetImageListPlayerProperties;
  end;






  /// <summary>
  ///   <para>
  ///     图片列表播放框属性
  ///   </para>
  ///   <para>
  ///     Properties of ImageList Player
  ///   </para>
  /// </summary>
  TImageListPlayerProperties=class(TSkinControlProperties)
  protected

    //当前切换显示的图片的前一张
    FCurrentSwitchBeforeImageIndex:Integer;
    //当前切换显示的图片的后一张
    FCurrentSwitchAfterImageIndex:Integer;
    //当前图片的切换顺序
    FCurrentSwitchOrderType:TAnimateOrderType;


    //绘制的图片
    FPicture: TDrawPicture;


    //GIF支持
    FAnimated:Boolean;
    FAnimateSpeed:Double;


    //图片列表循环
    FImageListAnimated: Boolean;
    //图片列表循环速度
    FImageListAnimateSpeed: Double;
    //图片列表循环顺序类型-0.1.2还是2.1.0
    FImageListAnimateOrderType:TAnimateOrderType;




    //当前正在切换
    FImageListSwitching:Boolean;
    //当前切换的进度
    FImageListSwitchingProgress:Integer;
    //当前切换的速度
    FImageListSwitchingSpeed: Double;
    //当前切换的增量
    FImageListSwitchingProgressIncement: Integer;
    //切换的类型-从左往右、从上到下
    FImageListSwitchEffectType: TAnimateSwitchEffectType;


    //无用
    FRotated:Boolean;
    FRotateSpeed:Double;
    FRotateIncrement:Integer;
    //当前旋转的角度
    FCurrentRotateAngle:Integer;





//    FRotateTimer:TTimer;

    FImageListAnimateTimer:TTimer;

    //默认使用定时器线性的平移
    FImageListSwitchingTimer:TTimer;

    FSkinImageListPlayerIntf:ISkinImageListPlayer;

    //播放GIF定时器
    procedure DoGIFAnimateRePaint(Sender:TObject);

//    //图片旋转定时器
//    procedure CreateRotateTimer;
//    procedure DoRotateTimer(Sender:TObject);

    //图片列表循环定时器
    procedure CreateImageListAnimateTimer;
    procedure DoImageListAnimateTimer(Sender:TObject);


    //图片切换定时器
    procedure CreateImageListSwitchingTimer;
    procedure DoImageListSwitchingTimer(Sender:TObject);

//    procedure SetAnimated(const Value: Boolean);
//    procedure SetAnimateSpeed(const Value: Double);


    procedure SetImageListAnimated(const Value: Boolean);
    procedure SetImageListAnimateSpeed(const Value: Double);
    procedure SetImageListAnimateOrderType(const Value: TAnimateOrderType);


    procedure SetImageListSwitching(const Value: Boolean);
    procedure SetImageListSwitchingSpeed(const Value: Double);
    procedure SetImageListSwitchingProgressIncement(const Value: Integer);
    procedure SetImageListSwitchEffectType(const Value: TAnimateSwitchEffectType);


    function GetImageListSwitchingBeforePictureDrawRect(const ADrawRect:TRectF):TRectF;
    function GetImageListSwitchingAfterPictureDrawRect(const ADrawRect:TRectF):TRectF;



    procedure SetPicture(Value:TDrawPicture);
    procedure DoPictureChanged(Sender: TObject);override;
//
//    procedure SetRotated(const Value: Boolean);
//    procedure SetRotateSpeed(const Value: Double);
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //检查是否需要图片列表切换
    function CheckIfNeedImageListSwitching:Boolean;
    //获取切换之前的图片下标
    function GetCurrentBeforePictureImageIndex:Integer;
    function GetCurrentBeforeSkinPicture:TDrawPicture;
    //获取切换之后的图片下标
    function GetCurrentAfterPictureImageIndex:Integer;
    function GetCurrentAfterSkinPicture:TDrawPicture;
    //获取当前的切换方向
    function GetCurrentSwitchOrderType:TAnimateOrderType;
    //切换图片
    procedure SwitchPicture(ABeginImageIndex:Integer;AAfterImageIndex:Integer);
    //排列切换按钮
    procedure AlignSwitchButtons;
//    procedure FreeSwitchButtons;
    procedure DoImageListSwitchButtonClick(Sender:TObject);
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  published
    property AutoSize;
    //
    /// <summary>
    ///   <para>
    ///     图片
    ///   </para>
    ///   <para>
    ///     Picture
    ///   </para>
    /// </summary>
    property Picture: TDrawPicture read FPicture write SetPicture;



    //
    /// <summary>
    ///   <para>
    ///     动画显示
    ///   </para>
    ///   <para>
    ///     Animate display
    ///   </para>
    /// </summary>
    property Animated:Boolean read FAnimated write FAnimated;//SetAnimated;
    property AnimateSpeed:Double read FAnimateSpeed write FAnimateSpeed;//SetAnimateSpeed;




    //
    /// <summary>
    ///   <para>
    ///     图片列表循环播放
    ///   </para>
    ///   <para>
    ///     ImageList loop play
    ///   </para>
    /// </summary>
    property ImageListAnimated:Boolean read FImageListAnimated write SetImageListAnimated;
    /// <summary>
    ///   <para>
    ///     图片列表循环播放速度
    ///   </para>
    ///   <para>
    ///     Speed of ImageList loop play
    ///   </para>
    /// </summary>
    property ImageListAnimateSpeed:Double read FImageListAnimateSpeed write SetImageListAnimateSpeed;
    /// <summary>
    ///   <para>
    ///     图片列表循环播放的顺序类型
    ///   </para>
    ///   <para>
    ///    Order type of ImageList loop play
    ///   </para>
    /// </summary>
    property ImageListAnimateOrderType:TAnimateOrderType read FImageListAnimateOrderType write SetImageListAnimateOrderType;




    //
    /// <summary>
    ///   <para>
    ///     图片列表播放的切换效果类型
    ///   </para>
    ///   <para>
    ///     ImageList switch effect type
    ///   </para>
    /// </summary>
    property ImageListSwitchEffectType: TAnimateSwitchEffectType read FImageListSwitchEffectType write SetImageListSwitchEffectType;
    /// <summary>
    ///   <para>
    ///     图片列表播放的切换效果速度
    ///   </para>
    ///   <para>
    ///     Speed of ImageList switch effect
    ///   </para>
    /// </summary>
    property ImageListSwitchingSpeed:Double read FImageListSwitchingSpeed write SetImageListSwitchingSpeed;
    /// <summary>
    ///   <para>
    ///     图片列表播放的切换效果移动步长
    ///   </para>
    ///   <para>
    ///     Move steps of ImageList switch effect
    ///   </para>
    /// </summary>
    property ImageListSwitchingProgressIncement:Integer read FImageListSwitchingProgressIncement write SetImageListSwitchingProgressIncement;




    //无用
    //是否旋转
    property Rotated:Boolean read FRotated write FRotated;
    property RotateSpeed:Double read FRotateSpeed write FRotateSpeed;
    property RotateIncrement:Integer read FRotateIncrement write FRotateIncrement;
  end;









  /// <summary>
  ///   <para>
  ///     图片列表播放框素材基类
  ///   </para>
  ///   <para>
  ///     Base class of ImageList Player Box
  ///   </para>
  /// </summary>
  TSkinImageListPlayerMaterial=class(TSkinControlMaterial)
  private
    //图片绘制参数
    FDrawPictureParam:TDrawPictureParam;
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
    //图片绘制参数
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;
  end;

  TSkinImageListPlayerType=class(TSkinControlType)
  protected
    FSkinImageListPlayerIntf:ISkinImageListPlayer;
    function GetSkinMaterial:TSkinImageListPlayerMaterial;
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
  TSkinImageListPlayerDefaultMaterial=class(TSkinImageListPlayerMaterial);
  TSkinImageListPlayerDefaultType=TSkinImageListPlayerType;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinImageListPlayer=class(TBaseSkinControl,
                            ISkinImageListPlayer)
  private
    function GetImageListPlayerProperties:TImageListPlayerProperties;
    procedure SetImageListPlayerProperties(Value:TImageListPlayerProperties);
  protected
    //水平滚动条
    FSwitchButtonGroup:TSkinBaseButtonGroup;
    FSwitchButtonGroupIntf:ISkinButtonGroup;
  protected
    procedure Loaded;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;

    procedure SetSwitchButtonGroup(Value: TSkinBaseButtonGroup);
  public
    //水平滚动条
    function GetSwitchButtonGroup:TSkinBaseButtonGroup;
    function GetSwitchButtonGroupIntf:ISkinButtonGroup;
  public
    function SelfOwnMaterialToDefault:TSkinImageListPlayerDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinImageListPlayerDefaultMaterial;
    function Material:TSkinImageListPlayerDefaultMaterial;
  public
    constructor Create(AOwner:TComponent);override;
  public
    property Prop:TImageListPlayerProperties read GetImageListPlayerProperties write SetImageListPlayerProperties;
  published
    property SwitchButtonGroup: TSkinBaseButtonGroup read GetSwitchButtonGroup write SetSwitchButtonGroup;
    //属性
    property Properties:TImageListPlayerProperties read GetImageListPlayerProperties write SetImageListPlayerProperties;
  end;


  {$IFDEF VCL}
  TSkinWinImageListPlayer=class(TSkinImageListPlayer)
  end;
  {$ENDIF VCL}



implementation



{ TSkinImageListPlayerType }

function TSkinImageListPlayerType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinImageListPlayer,Self.FSkinImageListPlayerIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinImageListPlayer Interface');
    end;
  end;
end;

procedure TSkinImageListPlayerType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinImageListPlayerIntf:=nil;
end;

function TSkinImageListPlayerType.GetSkinMaterial: TSkinImageListPlayerMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinImageListPlayerMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;


function TSkinImageListPlayerType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ABeforePicture:TDrawPicture;
  AAfterPicture:TDrawPicture;

  ABeforePictureDrawRect:TRectF;
  AAfterPictureDrawRect:TRectF;
begin
  if Self.GetSkinMaterial<>nil then
  begin



//      //图片旋转
//      Self.GetSkinMaterial.FDrawPictureParam.StaticRotateAngle:=Self.FSkinImageListPlayerIntf.Prop.FCurrentRotateAngle;



      //当前正在切换图片
      if Self.FSkinImageListPlayerIntf.Prop.CheckIfNeedImageListSwitching then
      begin

        //允许图片列表切换
        //切换之前的图片
        ABeforePicture:=Self.FSkinImageListPlayerIntf.Prop.GetCurrentBeforeSkinPicture;
        //切换之后的图片
        AAfterPicture:=Self.FSkinImageListPlayerIntf.Prop.GetCurrentAfterSkinPicture;


        //切换之前图片和切换之后图片的绘制矩形
        ABeforePictureDrawRect:=Self.FSkinImageListPlayerIntf.Prop.GetImageListSwitchingBeforePictureDrawRect(ADrawRect);
        AAfterPictureDrawRect:=Self.FSkinImageListPlayerIntf.Prop.GetImageListSwitchingAfterPictureDrawRect(ADrawRect);

        //绘制之前的图片
        if (ABeforePicture<>nil) then
        begin
            if Self.FSkinImageListPlayerIntf.Prop.FAnimated
              //是GIF文件
              and (ABeforePicture.SkinPictureEngine.CurrentIsGIF)
              //是GIF引擎
              and (ABeforePicture.SkinPictureEngine is TSkinBaseGIFPictureEngine)
            then
            begin
              //GIF图片播放
              TSkinBaseGIFPictureEngine(ABeforePicture.SkinPictureEngine).DrawToCanvas(ACanvas,
                                              Self.GetSkinMaterial.FDrawPictureParam,
                                              ABeforePictureDrawRect);
            end
            else
            begin
              ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                                      ABeforePicture,
                                      ABeforePictureDrawRect//,
//                                      False,
//                                      Rect(0,0,0,0),
//                                      Rect(0,0,0,0)
                                      );
            end;
        end;



        //绘制之后的图片
        if (AAfterPicture<>nil) then
        begin
          if Self.FSkinImageListPlayerIntf.Prop.FAnimated
            //是GIF文件
            and (AAfterPicture.SkinPictureEngine.CurrentIsGIF)
            //是GIF引擎
            and (AAfterPicture.SkinPictureEngine is TSkinBaseGIFPictureEngine)
          then
          begin
            //GIF图片播放
            TSkinBaseGIFPictureEngine(AAfterPicture.SkinPictureEngine).DrawToCanvas(ACanvas,
                                            Self.GetSkinMaterial.FDrawPictureParam,
                                            AAfterPictureDrawRect);
          end
          else
          begin
            ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                                    AAfterPicture,
                                    AAfterPictureDrawRect//,
//                                    False,
//                                    Rect(0,0,0,0),
//                                    Rect(0,0,0,0)
                                    );
          end;
        end;


    end
    else
    begin

        if Self.FSkinImageListPlayerIntf.Prop.FAnimated
          //是GIF文件
          and (Self.FSkinImageListPlayerIntf.Prop.Picture.SkinPictureEngine.CurrentIsGIF)
          //是GIF引擎
          and (Self.FSkinImageListPlayerIntf.Prop.Picture.SkinPictureEngine is TSkinBaseGIFPictureEngine)
        then
        begin
          //GIF图片播放
          TSkinBaseGIFPictureEngine(Self.FSkinImageListPlayerIntf.Prop.Picture.SkinPictureEngine).DrawToCanvas(ACanvas,
                                          Self.GetSkinMaterial.FDrawPictureParam,
                                          ADrawRect);
        end
        else
        begin

//          if Self.FSkinImageListPlayerIntf.Prop.Rotated then
//          begin
            //图片旋转
//            Self.GetSkinMaterial.FDrawPictureParam.StaticRotateAngle:=Self.FSkinImageListPlayerIntf.Prop.FCurrentRotateAngle;
//          end;

          ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                              Self.FSkinImageListPlayerIntf.Prop.Picture,
                              ADrawRect);
        end;

    end;


  end;
end;

function TSkinImageListPlayerType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
begin
  Result:=False;
  AWidth:=0;
  AHeight:=0;

  if not (csReading in Self.FSkinControl.ComponentState)
      and (Self.FSkinControlIntf.GetParent<>nil)
      and (Self.FSkinImageListPlayerIntf.Prop.FPicture.CurrentPictureDrawWidth>0)
      and (Self.FSkinImageListPlayerIntf.Prop.FPicture.CurrentPictureDrawHeight>0) then
  begin
    AWidth:=Self.FSkinImageListPlayerIntf.Prop.FPicture.CurrentPictureDrawWidth;
    AHeight:=Self.FSkinImageListPlayerIntf.Prop.FPicture.CurrentPictureDrawHeight;
    Result:=True;
  end;

end;


{ TSkinImageListPlayerMaterial }

constructor TSkinImageListPlayerMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
end;

destructor TSkinImageListPlayerMaterial.Destroy;
begin
  FreeAndNil(FDrawPictureParam);
  inherited;
end;

//function TSkinImageListPlayerMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//function TSkinImageListPlayerMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
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

procedure TSkinImageListPlayerMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;


{ TImageListPlayerProperties }


procedure TImageListPlayerProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  FPicture.Assign(TImageListPlayerProperties(Src).FPicture);
  FAnimated:=TImageListPlayerProperties(Src).FAnimated;
  FAnimateSpeed:=TImageListPlayerProperties(Src).FAnimateSpeed;
//  FRotated:=TImageListPlayerProperties(Src).FRotated;
//  FRotateSpeed:=TImageListPlayerProperties(Src).FRotateSpeed;
//  FRotateIncrement:=TImageListPlayerProperties(Src).FRotateIncrement;

  FImageListAnimated:=TImageListPlayerProperties(Src).FImageListAnimated;
  FImageListAnimateSpeed:=TImageListPlayerProperties(Src).FImageListAnimateSpeed;
  FImageListAnimateOrderType:=TImageListPlayerProperties(Src).FImageListAnimateOrderType;

  FImageListSwitching:=TImageListPlayerProperties(Src).FImageListSwitching;
  FImageListSwitchingSpeed:=TImageListPlayerProperties(Src).FImageListSwitchingSpeed;
  FImageListSwitchingProgress:=TImageListPlayerProperties(Src).FImageListSwitchingProgress;
  FImageListSwitchingProgressIncement:=TImageListPlayerProperties(Src).FImageListSwitchingProgressIncement;
  FImageListSwitchEffectType:=TImageListPlayerProperties(Src).FImageListSwitchEffectType;//ilasetMoveHorz;//
end;

function TImageListPlayerProperties.CheckIfNeedImageListSwitching: Boolean;
begin
  //当前是否正在切换
  Result:=False;
  if Self.FSkinImageListPlayerIntf.Prop.FImageListSwitching
//    and (Self.FSkinImageListPlayerIntf.Prop.FImageListSwitchingProgress<100)
    and (Self.FSkinImageListPlayerIntf.Prop.FPicture.SkinImageList<>nil)
    and (Self.FSkinImageListPlayerIntf.Prop.FPicture.SkinImageList.Count>1) then
  begin
    case Self.FSkinImageListPlayerIntf.Prop.FImageListSwitchEffectType of
      ilasetNone: ;
      ilasetMoveHorz,ilasetMoveVert:
      begin
        Result:=True;
      end;
//      ilasetDisappear:
//      begin
//        Result:=True;
//      end;
    end;
  end;
end;

constructor TImageListPlayerProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinImageListPlayer,Self.FSkinImageListPlayerIntf) then
  begin
    ShowException('This Component Do not Support ISkinImageListPlayer Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=120;
    Self.FSkinControlIntf.Height:=100;

    //支持GIF
    FPicture:=CreateDrawPicture('Picture','图片');
    FPicture.GIFSupport:=True;
    FPicture.OnAnimateRePaint:=Self.DoGIFAnimateRePaint;
    FPicture.OnChange:=DoPictureChanged;


    FAnimated:=False;
    FAnimateSpeed:=10;

    FImageListAnimated:=False;
    FImageListAnimateSpeed:=500;
    FImageListSwitchingSpeed:=5;
    FImageListSwitching:=False;
    FImageListSwitchingProgress:=0;
    //增量
    FImageListSwitchingProgressIncement:=20;
    FImageListAnimateOrderType:=TAnimateOrderType.ilaotAsc;
    FImageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetNone;//ilasetMoveHorz;//



    FCurrentSwitchBeforeImageIndex:=-1;
    FCurrentSwitchAfterImageIndex:=-1;
    FCurrentSwitchOrderType:=TAnimateOrderType.ilaotNone;



//    FRotated:=False;
//    FRotateSpeed:=10;
//    FRotateIncrement:=10;
//    FCurrentRotateAngle:=0;

  end;

end;

//procedure TImageListPlayerProperties.CreateRotateTimer;
//begin
//  if FRotateTimer=nil then
//  begin
//    FRotateTimer:=TTimer.Create(nil);
//    FRotateTimer.OnTimer:=Self.DoRotateTimer;
//    FRotateTimer.Interval:=Ceil(Self.FRotateSpeed*10);
//    FRotateTimer.Enabled:=False;
//  end;
//end;

procedure TImageListPlayerProperties.CreateImageListAnimateTimer;
begin
  if FImageListAnimateTimer=nil then
  begin
    FImageListAnimateTimer:=TTimer.Create(nil);
    FImageListAnimateTimer.OnTimer:=Self.DoImageListAnimateTimer;
    FImageListAnimateTimer.Interval:=Ceil(Self.FImageListAnimateSpeed*10);
    FImageListAnimateTimer.Enabled:=False;
  end;
end;

procedure TImageListPlayerProperties.CreateImageListSwitchingTimer;
begin
  if FImageListSwitchingTimer=nil then
  begin
    FImageListSwitchingTimer:=TTimer.Create(nil);
    FImageListSwitchingTimer.OnTimer:=Self.DoImageListSwitchingTimer;
    FImageListSwitchingTimer.Interval:=Ceil(Self.FImageListSwitchingSpeed*10);
    FImageListSwitchingTimer.Enabled:=False;
  end;
end;

destructor TImageListPlayerProperties.Destroy;
begin
//  FreeAndNil(FRotateTimer);
  FreeAndNil(FImageListAnimateTimer);
  FreeAndNil(FImageListSwitchingTimer);


  FreeAndNil(FPicture);

  inherited;
end;

procedure TImageListPlayerProperties.DoGIFAnimateRePaint(Sender: TObject);
begin
  //重绘
  Self.Invalidate;
end;

//procedure TImageListPlayerProperties.DoRotateTimer(Sender: TObject);
//begin
//  //ShowDialog('FCurrentRotateAngle');
//
//  if FCurrentRotateAngle>=360 then
//  begin
//    FCurrentRotateAngle:=0;
//  end;
//
//  FCurrentRotateAngle:=FCurrentRotateAngle+Self.FRotateIncrement;
//
//  if FCurrentRotateAngle>360 then
//  begin
//    FCurrentRotateAngle:=360;
//  end;
//
//  Self.Invalidate;
//end;

procedure TImageListPlayerProperties.DoImageListAnimateTimer(Sender: TObject);
var
  ABeginImageIndex:Integer;
  AAfterImageIndex:Integer;
begin
  //如果当前正在切换,那么不处理
  if Self.FImageListSwitching then Exit;

  if Self.FPicture.SkinImageList<>nil then
  begin

    //当前显示的图片下标
    ABeginImageIndex:=Self.FSkinImageListPlayerIntf.Prop.Picture.ImageIndex;
    AAfterImageIndex:=ABeginImageIndex;
    case GetCurrentSwitchOrderType of
      ilaotAsc:
      begin
        //顺序
        if AAfterImageIndex+1>Self.FPicture.SkinImageList.Count then
        begin
          AAfterImageIndex:=-1;
        end;
        AAfterImageIndex:=AAfterImageIndex+1;
      end;
      ilaotDesc:
      begin
        //倒序
        if AAfterImageIndex-1<0 then
        begin
          AAfterImageIndex:=Self.FPicture.SkinImageList.Count;
        end;
        AAfterImageIndex:=AAfterImageIndex-1;
      end;
    end;

    if //(Self.FImageListSwitchEffectType<>TAnimateSwitchEffectType.ilasetNone)
      //and
      (Self.FImageListAnimateOrderType<>TAnimateOrderType.ilaotNone) then
    begin
      Self.SwitchPicture(ABeginImageIndex,AAfterImageIndex);
      //SetImageListSwitching(True);
    end;

  end;

end;

procedure TImageListPlayerProperties.DoImageListSwitchingTimer(Sender: TObject);
begin
  case Self.FImageListSwitchEffectType of
    ilasetNone:
    begin
      //没有切换效果
      Self.FPicture.ImageIndex:=Self.GetCurrentAfterPictureImageIndex;
      Self.SetImageListSwitching(False);
      Invalidate;
    end;
    ilasetMoveHorz,ilasetMoveVert:
    begin
      //水平垂直切换
      Inc(Self.FImageListSwitchingProgress,FImageListSwitchingProgressIncement);
      if FImageListSwitchingProgress>=100 then
      begin
        //切换结束
        Self.SetImageListSwitching(False);
        Self.FPicture.ImageIndex:=Self.GetCurrentAfterPictureImageIndex;
        Self.AlignSwitchButtons;

        Self.FCurrentSwitchBeforeImageIndex:=-1;
        Self.FCurrentSwitchAfterImageIndex:=-1;
        Self.FImageListSwitchingProgress:=0;
        Self.FCurrentSwitchOrderType:=TAnimateOrderType.ilaotNone;
        //如果是GIF图片那就启动
        //如果是GIF,则播放GIF
        if Self.Animated then
        begin
          if FPicture.CurrentPictureIsGIF then
          begin
            if Self.FPicture.SkinPictureEngine is TSkinBaseGIFPictureEngine then
            begin
              TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).StartAnimate;
            end;
          end
          else
          begin
            if Self.FPicture.SkinPictureEngine is TSkinBaseGIFPictureEngine then
            begin
              TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).StopAnimate;
            end;
          end;
        end;

      end;
      Invalidate;
    end;
  end;

end;

//procedure TImageListPlayerProperties.SetAnimated(const Value: Boolean);
//begin
//  if FAnimated<>Value then
//  begin
//    FAnimated := Value;
//    TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).Animated:=FAnimated;
//  end;
//end;
//
//procedure TImageListPlayerProperties.SetAnimateSpeed(const Value: Double);
//begin
//  if FAnimateSpeed<>Value then
//  begin
//    FAnimateSpeed := Value;
//    TSkinBaseGIFPictureEngine(Self.FPicture.SkinPictureEngine).AnimateSpeed:=FAnimateSpeed;
//  end;
//end;

procedure TImageListPlayerProperties.SetImageListAnimated(const Value: Boolean);
begin
  if FImageListAnimated<>Value then
  begin
    FImageListAnimated := Value;
    if FImageListAnimated then
    begin
      Self.CreateImageListAnimateTimer;
      if Self.FImageListAnimateTimer<>nil then
      begin
        Self.FImageListAnimateTimer.Enabled:=True;
      end;
    end
    else
    begin
      if Self.FImageListAnimateTimer<>nil then
      begin
        Self.FImageListAnimateTimer.Enabled:=False;
      end;
    end;
  end;
end;

procedure TImageListPlayerProperties.SetImageListAnimateOrderType(const Value: TAnimateOrderType);
begin
  if FImageListAnimateOrderType<>Value then
  begin
    FImageListAnimateOrderType := Value;
//    Self.Invalidate;
  end;
end;

procedure TImageListPlayerProperties.SetImageListSwitchEffectType(const Value: TAnimateSwitchEffectType);
begin
  if FImageListSwitchEffectType<>Value then
  begin
    FImageListSwitchEffectType := Value;
//    Invalidate;
  end;
end;

procedure TImageListPlayerProperties.SetImageListSwitching(const Value: Boolean);
begin
  if FImageListSwitching<>Value then
  begin
//    if Value and (Self.FImageListSwitchEffectType=TAnimateSwitchEffectType.ilasetNone) then
//    begin
//      FImageListSwitching:=False;
//    end
//    else
//    begin
      FImageListSwitching := Value;
//    end;
    if FImageListSwitching then
    begin
      Self.CreateImageListSwitchingTimer;
      if Self.FImageListSwitchingTimer<>nil then
      begin
        Self.FImageListSwitchingTimer.Enabled:=True;
        Self.FImageListSwitchingProgress:=0;
//        uDialogCommon.ShowDialog('True');
      end;
      //ShowException('SetRotated');
    end
    else
    begin
//      uDialogCommon.ShowDialog('False');
      if Self.FImageListSwitchingTimer<>nil then
      begin
        Self.FImageListSwitchingTimer.Enabled:=False;
        Self.FImageListSwitchingProgress:=100;
      end;
    end;
  end;
end;

procedure TImageListPlayerProperties.SetImageListSwitchingProgressIncement(const Value: Integer);
begin
  if FImageListSwitchingProgressIncement<>Value then
  begin
    FImageListSwitchingProgressIncement := Value;
    Invalidate;
  end;
end;

procedure TImageListPlayerProperties.SetImageListAnimateSpeed(const Value: Double);
begin
  if FImageListAnimateSpeed<>Value then
  begin
    FImageListAnimateSpeed := Value;
    if Self.FImageListAnimateTimer<>nil then
    begin
//      ShowDialog('SetRotateSpeed');
      Self.FImageListAnimateTimer.Interval:=Ceil(FImageListAnimateSpeed*10);
      Self.FImageListAnimateTimer.Enabled:=Self.FImageListAnimated;
    end;
  end;
end;

procedure TImageListPlayerProperties.SetImageListSwitchingSpeed(const Value: Double);
begin
  if FImageListSwitchingSpeed<>Value then
  begin
    FImageListSwitchingSpeed := Value;
    if Self.FImageListSwitchingTimer<>nil then
    begin
//      ShowDialog('SetRotateSpeed');
      Self.FImageListSwitchingTimer.Interval:=Ceil(FImageListSwitchingSpeed*10);
    end;
  end;
end;

procedure TImageListPlayerProperties.SetPicture(Value: TDrawPicture);
begin
  FPicture.Assign(Value);
end;

//procedure TImageListPlayerProperties.SetRotated(const Value: Boolean);
//begin
//  if FRotated<>Value then
//  begin
//    FRotated := Value;
//    if FRotated then
//    begin
//      Self.CreateRotateTimer;
//      if Self.FRotateTimer<>nil then
//      begin
//        Self.FRotateTimer.Enabled:=True;
////        uDialogCommon.ShowDialog('True');
//      end;
//      //ShowException('SetRotated');
//    end
//    else
//    begin
////      uDialogCommon.ShowDialog('False');
//      if Self.FRotateTimer<>nil then
//      begin
//        Self.FRotateTimer.Enabled:=False;
//      end;
//    end;
//  end;
//end;
//
//procedure TImageListPlayerProperties.SetRotateSpeed(const Value: Double);
//begin
//  if FRotateSpeed<>Value then
//  begin
//    FRotateSpeed := Value;
//    if Self.FRotateTimer<>nil then
//    begin
////      ShowDialog('SetRotateSpeed');
//      Self.FRotateTimer.Interval:=Ceil(FRotateSpeed*10);
//      Self.FRotateTimer.Enabled:=Self.FRotated;
//    end;
//  end;
//end;

procedure TImageListPlayerProperties.SwitchPicture(ABeginImageIndex: Integer;AAfterImageIndex:Integer);
begin
  //判断是否合法
  if (Self.FPicture.SkinImageList<>nil) and (Self.FPicture.SkinImageList.Count>1) then
  begin

//    if (ABeginImageIndex>-1) and (ABeginImageIndex<Self.FPicture.SkinImageList.Count) then
//    begin
      FCurrentSwitchBeforeImageIndex:=ABeginImageIndex;
//    end;
//    if (AAfterImageIndex>-1) and (AAfterImageIndex<Self.FPicture.SkinImageList.Count) then
//    begin
      FCurrentSwitchAfterImageIndex:=AAfterImageIndex;
//    end;

    if FCurrentSwitchBeforeImageIndex=FCurrentSwitchAfterImageIndex then
    begin
      Self.FPicture.ImageIndex:=FCurrentSwitchBeforeImageIndex;
    end
    else
    begin

      //判断切换方向
      case FImageListAnimateOrderType of
        ilaotNone: ;
        ilaotAsc:
        begin
          //判断切换方向
          if (FCurrentSwitchBeforeImageIndex<FCurrentSwitchAfterImageIndex)
            or
              //顺序,当前是第一张图片,切换到最后一张
              (FCurrentSwitchBeforeImageIndex=Self.FPicture.SkinImageList.Count-1) and (FCurrentSwitchAfterImageIndex=0)
               then
          begin
            FCurrentSwitchOrderType:=TAnimateOrderType.ilaotAsc;
          end
          else
          begin
            FCurrentSwitchOrderType:=TAnimateOrderType.ilaotDesc;
          end;
        end;
        ilaotDesc:
        begin
          //判断切换方向
          if (FCurrentSwitchBeforeImageIndex<FCurrentSwitchAfterImageIndex)
            and
            not ((FCurrentSwitchBeforeImageIndex=0) and (FCurrentSwitchAfterImageIndex=Self.FPicture.SkinImageList.Count-1)) then
          begin
            FCurrentSwitchOrderType:=TAnimateOrderType.ilaotAsc;
          end
          else
          begin
            FCurrentSwitchOrderType:=TAnimateOrderType.ilaotDesc;
          end;
        end;
      end;


      //开始切换
      Self.SetImageListSwitching(True);

//      Self.CreateImageListSwitchingTimer;
//      if Self.FImageListSwitchingTimer<>nil then
//      begin
//        Self.FImageListSwitchingTimer.Enabled:=True;
//        Self.FImageListSwitchingProgress:=0;
//      end;

    end;
  end;

end;

procedure TImageListPlayerProperties.AlignSwitchButtons;
begin
  if (Self.FSkinImageListPlayerIntf.GetSwitchButtonGroup<>nil)
    and (Self.FSkinImageListPlayerIntf.Prop.Picture.SkinImageList<>nil) then
  begin

    Self.FSkinImageListPlayerIntf.GetSwitchButtonGroupIntf.FixChildButtonCount(Self.Picture.SkinImageList.Count,
                                  Self.Picture.ImageIndex,
                                  DoImageListSwitchButtonClick);

  end;
end;

//procedure TImageListPlayerProperties.FreeSwitchButtons;
//begin
//  if (Self.FSkinImageListPlayerIntf.GetSwitchButtonGroup<>nil) then
//  begin
//    Self.FSkinImageListPlayerIntf.GetSwitchButtonGroupIntf.FreeChildButtons;
//  end;
//end;

procedure TImageListPlayerProperties.DoPictureChanged(Sender: TObject);
begin
  Self.AdjustAutoSizeBounds;

  Self.AlignSwitchButtons;

  Inherited;

end;

function TImageListPlayerProperties.GetCurrentAfterPictureImageIndex: Integer;
begin
  Result:=-1;
  if Self.FSkinImageListPlayerIntf.Prop.FPicture.SkinImageList=nil then Exit;

//  case Self.FSkinImageListPlayerIntf.Prop.FImageListSwitchEffectType of
//    ilasetNone: ;
//    ilasetMoveHorz,ilasetMoveVert:
//    begin
      case Self.FSkinImageListPlayerIntf.Prop.GetCurrentSwitchOrderType of
        ilaotAsc:
        begin
          Result:=Self.FSkinImageListPlayerIntf.Prop.FPicture.ImageIndex+1;
          if Self.FSkinImageListPlayerIntf.Prop.FPicture.ImageIndex=Self.FSkinImageListPlayerIntf.Prop.FPicture.SkinImageList.Count-1 then
          begin
            Result:=0;
          end;
        end;
        ilaotDesc:
        begin
          Result:=Self.FSkinImageListPlayerIntf.Prop.FPicture.ImageIndex-1;
          if Self.FSkinImageListPlayerIntf.Prop.FPicture.ImageIndex=0 then
          begin
            Result:=Self.FSkinImageListPlayerIntf.Prop.FPicture.SkinImageList.Count-1;
          end;
        end;
      end;
//    end;
//  end;
end;

function TImageListPlayerProperties.GetCurrentAfterSkinPicture: TDrawPicture;
begin
  Result:=nil;
  if Self.FSkinImageListPlayerIntf.Prop.FPicture.SkinImageList=nil then Exit;
  if Self.GetCurrentAfterPictureImageIndex>-1 then
  begin
    Result:=Self.FPicture.SkinImageList.PictureList[GetCurrentAfterPictureImageIndex];
  end;
end;

function TImageListPlayerProperties.GetCurrentBeforePictureImageIndex: Integer;
begin
  Result:=-1;
  if Self.FCurrentSwitchBeforeImageIndex<>-1 then
  begin
    Result:=Self.FCurrentSwitchBeforeImageIndex;
  end
  else
  begin
    case Self.FSkinImageListPlayerIntf.Prop.FImageListSwitchEffectType of
      ilasetNone: ;
      ilasetMoveHorz,ilasetMoveVert:
      begin
        case Self.FSkinImageListPlayerIntf.Prop.GetCurrentSwitchOrderType of
          ilaotAsc:
          begin
            Result:=Self.FSkinImageListPlayerIntf.Prop.FPicture.ImageIndex;
          end;
          ilaotDesc:
          begin
            Result:=Self.FSkinImageListPlayerIntf.Prop.FPicture.ImageIndex;
          end;
        end;
      end;
    end;
  end;
end;

//function TImageListPlayerProperties.GetCurrentPictureImageIndex: Integer;
//begin
//  Result:=Self.FSkinImageListPlayerIntf.Prop.FPicture.ImageIndex;
//end;
//
//function TImageListPlayerProperties.GetCurrentSkinPicture: TDrawPicture;
//begin
//  Result:=nil;
//  if Self.GetCurrentPictureImageIndex>-1 then
//  begin
//    Result:=Self.FPicture.SkinImageList.PictureList[GetCurrentPictureImageIndex];
//  end;
//end;

function TImageListPlayerProperties.GetCurrentBeforeSkinPicture: TDrawPicture;
begin
  Result:=nil;
  if Self.FSkinImageListPlayerIntf.Prop.FPicture.SkinImageList=nil then Exit;
  if Self.GetCurrentBeforePictureImageIndex>-1 then
  begin
    Result:=Self.FPicture.SkinImageList.PictureList[GetCurrentBeforePictureImageIndex];
  end;
end;

function TImageListPlayerProperties.GetCurrentSwitchOrderType: TAnimateOrderType;
begin
  Result:=ilaotNone;
  if Self.FCurrentSwitchOrderType<>ilaotNone then
  begin
    Result:=FCurrentSwitchOrderType;
  end
  else
  begin
    Result:=Self.FImageListAnimateOrderType;
  end;
end;

function TImageListPlayerProperties.GetComponentClassify: String;
begin
  Result:='SkinImageListPlayer';
end;

function TImageListPlayerProperties.GetImageListSwitchingBeforePictureDrawRect(const ADrawRect: TRectF): TRectF;
begin
  Result:=ADrawRect;
  case Self.FImageListSwitchEffectType of
    ilasetNone: ;
    ilasetMoveHorz:
    begin
      case GetCurrentSwitchOrderType of
        ilaotAsc:
        begin
          Result.Left:=Result.Left-RectWidthF(ADrawRect)*Self.FImageListSwitchingProgress/100;
          Result.Right:=Result.Left+RectWidthF(ADrawRect);
        end;
        ilaotDesc:
        begin
          Result.Left:=Result.Left+RectWidthF(ADrawRect)*Self.FImageListSwitchingProgress/100;
          Result.Right:=Result.Left+RectWidthF(ADrawRect);
        end;
      end;
    end;
    ilasetMoveVert:
    begin
      case GetCurrentSwitchOrderType of
        ilaotAsc:
        begin
          Result.Top:=Result.Top-RectHeightF(ADrawRect)*Self.FImageListSwitchingProgress/100;
          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
        end;
        ilaotDesc:
        begin
          Result.Top:=Result.Top+RectHeightF(ADrawRect)*Self.FImageListSwitchingProgress/100;
          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
        end;
      end;
    end;
  end;
end;


procedure TImageListPlayerProperties.DoImageListSwitchButtonClick(Sender: TObject);
begin
  //图标列表切换按钮按下
  Self.SwitchPicture(Self.FPicture.ImageIndex,((Sender as TChildControl) as ISkinButton).Properties.ButtonIndex);
end;

function TImageListPlayerProperties.GetImageListSwitchingAfterPictureDrawRect(const ADrawRect: TRectF): TRectF;
begin
  Result:=ADrawRect;
  case Self.FImageListSwitchEffectType of
    ilasetNone: ;
    ilasetMoveHorz:
    begin
      case GetCurrentSwitchOrderType of
        ilaotAsc:
        begin
          Result.Left:=Result.Right-RectWidthF(ADrawRect)*Self.FImageListSwitchingProgress/100;
          Result.Right:=Result.Left+RectWidthF(ADrawRect);
        end;
        ilaotDesc:
        begin
          Result.Left:=Result.Left-RectWidthF(ADrawRect)*(100-Self.FImageListSwitchingProgress)/100;
          Result.Right:=Result.Left+RectWidthF(ADrawRect);
        end;
      end;
    end;
    ilasetMoveVert:
    begin
      case GetCurrentSwitchOrderType of
        ilaotAsc:
        begin
          Result.Top:=Result.Bottom-RectHeightF(ADrawRect)*Self.FImageListSwitchingProgress/100;
          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
        end;
        ilaotDesc:
        begin
          Result.Top:=Result.Top-RectHeightF(ADrawRect)*(100-Self.FImageListSwitchingProgress)/100;
          Result.Bottom:=Result.Top+RectHeightF(ADrawRect);
        end;
      end;
    end;
  end;
end;





{ TSkinImageListPlayer }

constructor TSkinImageListPlayer.Create(AOwner:TComponent);
begin
  inherited;
  {$IFDEF FMX}
  Touch.DefaultInteractiveGestures := Touch.DefaultInteractiveGestures + [TInteractiveGesture.{$IF CompilerVersion >= 35.0}Pan{$ELSE}igPan{$IFEND}];
  Touch.InteractiveGestures := Touch.InteractiveGestures + [TInteractiveGesture.{$IF CompilerVersion >= 35.0}Pan{$ELSE}igPan{$IFEND}];
  {$ENDIF}

end;

function TSkinImageListPlayer.Material:TSkinImageListPlayerDefaultMaterial;
begin
  Result:=TSkinImageListPlayerDefaultMaterial(SelfOwnMaterial);
end;

function TSkinImageListPlayer.SelfOwnMaterialToDefault:TSkinImageListPlayerDefaultMaterial;
begin
  Result:=TSkinImageListPlayerDefaultMaterial(SelfOwnMaterial);
end;

function TSkinImageListPlayer.CurrentUseMaterialToDefault:TSkinImageListPlayerDefaultMaterial;
begin
  Result:=TSkinImageListPlayerDefaultMaterial(CurrentUseMaterial);
end;

function TSkinImageListPlayer.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TImageListPlayerProperties;
end;

function TSkinImageListPlayer.GetImageListPlayerProperties: TImageListPlayerProperties;
begin
  Result:=TImageListPlayerProperties(Self.FProperties);
end;

procedure TSkinImageListPlayer.SetImageListPlayerProperties(Value: TImageListPlayerProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinImageListPlayer.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetImageListPlayerProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure TSkinImageListPlayer.Loaded;
begin
  Inherited;
  //如果是GIF,则播放GIF
  if Self.GetImageListPlayerProperties.Animated then
  begin
    if Self.GetImageListPlayerProperties.Picture.SkinPictureEngine is TSkinBaseGIFPictureEngine then
    begin
      TSkinBaseGIFPictureEngine(Self.GetImageListPlayerProperties.Picture.SkinPictureEngine).StartAnimate;
    end;
  end;
  //创建图片列表下标按钮
  Properties.AlignSwitchButtons;
end;

function TSkinImageListPlayer.GetSwitchButtonGroupIntf:ISkinButtonGroup;
begin
  Result:=FSwitchButtonGroupIntf;
end;

function TSkinImageListPlayer.GetSwitchButtonGroup: TSkinBaseButtonGroup;
begin
  Result:=Self.FSwitchButtonGroup;
end;

procedure TSkinImageListPlayer.SetSwitchButtonGroup(Value: TSkinBaseButtonGroup);
begin
  if FSwitchButtonGroup<>Value then
  begin
      //将原Style释放或解除绑定
      if FSwitchButtonGroup<>nil then
      begin
          uComponentType.RemoveFreeNotification(FSwitchButtonGroup,Self);

          if (FSwitchButtonGroup.Owner=Self) then
          begin
            //释放自己创建的
            //释放里面的按钮
            FreeAndNil(FSwitchButtonGroup);
          end
          else
          begin
            //解除别人的
            FSwitchButtonGroup:=nil;
            FSwitchButtonGroupIntf:=nil;
          end;
      end;


      FSwitchButtonGroup:=Value;


      if FSwitchButtonGroup<>nil then
      begin
          AddFreeNotification(FSwitchButtonGroup,Self);
          FSwitchButtonGroupIntf:=FSwitchButtonGroup as ISkinButtonGroup;

          //创建图片列表下标按钮
          Properties.AlignSwitchButtons;
      end;
  end;
end;

procedure TSkinImageListPlayer.Notification(AComponent: TComponent;Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  begin
    if (AComponent=Self.FSwitchButtonGroup) then
    begin
      SetSwitchButtonGroup(nil);
    end;
  end;
end;



end.

