//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     签名画板
///   </para>
///   <para>
///     DrawPanel
///   </para>
/// </summary>
unit uSkinDrawPanelType;

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
  Graphics,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Graphics,
  {$ENDIF}
  uBaseLog,
  Math,
  uBaseList,
  uBaseSkinControl,
  uSkinPicture,
  uBasePathData,
  uDrawLineParam,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPictureParam;


const
  IID_ISkinDrawPanel:TGUID='{FF105EFD-047B-4FB5-8E0E-E082514DE73C}';


type
  TDrawPanelProperties=class;


  /// <summary>
  ///   <para>
  ///     签名画板接口
  ///   </para>
  ///   <para>
  ///     Interface of DrawPanel
  ///   </para>
  /// </summary>
  ISkinDrawPanel=interface//(ISkinControl)
    ['{FF105EFD-047B-4FB5-8E0E-E082514DE73C}']
    function GetDrawPanelProperties:TDrawPanelProperties;
    property Properties:TDrawPanelProperties read GetDrawPanelProperties;
    property Prop:TDrawPanelProperties read GetDrawPanelProperties;
  end;





  /// <summary>
  ///   <para>
  ///     绘制路径数据列表
  ///   </para>
  ///   <para>
  ///     List of draw path data
  ///   </para>
  /// </summary>
  TBaseDrawPathDataList=class(TBaseList)
  private
    function GetItem(Index: Integer): TBaseDrawPathData;
  public
    property Items[Index:Integer]:TBaseDrawPathData read GetItem;default;
  end;





  /// <summary>
  ///   <para>
  ///     签名画板属性
  ///   </para>
  ///   <para>
  ///     Properties of DrawPanel
  ///   </para>
  /// </summary>
  TDrawPanelProperties=class(TSkinControlProperties)
  protected
    FDrawPathData:TBaseDrawPathData;
    FDrawPathDataList:TBaseDrawPathDataList;
    //可恢复的列表
    FUndoDrawPathDataList:TBaseDrawPathDataList;

    //绘制精度
    FDrawPrecision:Double;
    //重绘距离
    FRePaintDistance:Double;


    //绘制的图
    FPicture: TSkinPicture;
    //背景图
    FBackGndPicture: TSkinPicture;


    FSkinDrawPanelIntf:ISkinDrawPanel;

    procedure SetPicture(const Value: TSkinPicture);
    procedure DoPictureChanged(Sender:TObject);

    procedure SetBackGndPicture(const Value: TSkinPicture);
    procedure DoBackGndPictureChanged(Sender:TObject);

  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    /// <summary>
    ///   <para>
    ///     清除
    ///   </para>
    ///   <para>
    ///     Clear
    ///   </para>
    /// </summary>
    procedure Clear;
    /// <summary>
    ///   <para>
    ///     撤消
    ///   </para>
    ///   <para>
    ///     Undo
    ///   </para>
    /// </summary>
    procedure Undo;
    /// <summary>
    ///   <para>
    ///     重做
    ///   </para>
    ///   <para>
    ///     Redo
    ///   </para>
    /// </summary>
    procedure Redo;
    /// <summary>
    ///   <para>
    ///     是否可以撤消
    ///   </para>
    ///   <para>
    ///     Whether can undo
    ///   </para>
    /// </summary>
    function CanUndo:Boolean;
    /// <summary>
    ///   <para>
    ///     是否可以重做
    ///   </para>
    ///   <para>
    ///     Whether can redo
    ///   </para>
    /// </summary>
    function CanRedo:Boolean;


    /// <summary>
    ///   <para>
    ///     绘制路径数据列表
    ///   </para>
    ///   <para>
    ///     Draw path data list
    ///   </para>
    /// </summary>
    property DrawPathDataList:TBaseDrawPathDataList read FDrawPathDataList;

    /// <summary>
    ///   <para>
    ///     已经撤消的绘制路径数据列表
    ///   </para>
    ///   <para>
    ///      DataList which is used for storing undo draw path
    ///   </para>
    /// </summary>
    property UndoDrawPathDataList:TBaseDrawPathDataList read FUndoDrawPathDataList;

    /// <summary>
    ///   <para>
    ///     绘制精度
    ///   </para>
    ///   <para>
    ///     Draw precision
    ///   </para>
    /// </summary>
    property DrawPrecision:Double read FDrawPrecision write FDrawPrecision;
  published
    //
    /// <summary>
    ///   <para>
    ///     图片
    ///   </para>
    ///   <para>
    ///     Picture
    ///   </para>
    /// </summary>
    property Picture:TSkinPicture read FPicture write SetPicture;
    //
    /// <summary>
    ///   <para>
    ///     背景图片
    ///   </para>
    ///   <para>
    ///     Background Picture
    ///   </para>
    /// </summary>
    property BackGndPicture:TSkinPicture read FBackGndPicture write SetBackGndPicture;
  end;










  /// <summary>
  ///   <para>
  ///     签名画板素材基类
  ///   </para>
  ///   <para>
  ///     Base class of DrawPanel material
  ///   </para>
  /// </summary>
  TSkinDrawPanelMaterial=class(TSkinControlMaterial)
  private
    //线条绘制参数
    FDrawLineParam:TDrawLineParam;
    //图片绘制参数
    FDrawPictureParam:TDrawPictureParam;
    //背景图片绘制参数
    FDrawBackGndPictureParam:TDrawPictureParam;
    procedure SetDrawLineParam(const Value: TDrawLineParam);
    procedure SetDrawPictureParam(const Value: TDrawPictureParam);
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
    ///     线条绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of line
    ///   </para>
    /// </summary>
    property DrawLineParam:TDrawLineParam read FDrawLineParam write SetDrawLineParam;
    //
    /// <summary>
    ///   <para>
    ///     图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of picture
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;
    //
    /// <summary>
    ///   <para>
    ///     背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of background picture
    ///   </para>
    /// </summary>
    property DrawBackGndPictureParam:TDrawPictureParam read FDrawBackGndPictureParam write SetDrawBackGndPictureParam;
  end;

  TSkinDrawPanelType=class(TSkinControlType)
  private
    FLastDrawMouseMovePt:TPointF;
    FLastDisMouseMovePt:TPointF;
    FDrawDistance:Double;

    FSkinDrawPanelIntf:ISkinDrawPanel;

    function GetSkinMaterial:TSkinDrawPanelMaterial;
  protected
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState; X, Y: Double);override;

    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  public

    /// <summary>
    ///   生成图片
    /// </summary>
    function CombinePicture(UseBackGndPictureSize:Boolean=False):TSkinPicture;
    procedure Combine(UseBackGndPictureSize:Boolean=False);
  end;








  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinDrawPanelDefaultMaterial=class(TSkinDrawPanelMaterial);
  TSkinDrawPanelDefaultType=TSkinDrawPanelType;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinDrawPanel=class(TBaseSkinControl,
                        ISkinDrawPanel)
  private
    function GetDrawPanelProperties:TDrawPanelProperties;
    procedure SetDrawPanelProperties(Value:TDrawPanelProperties);
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinDrawPanelDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinDrawPanelDefaultMaterial;
    function Material:TSkinDrawPanelDefaultMaterial;
  public
    property Prop:TDrawPanelProperties read GetDrawPanelProperties write SetDrawPanelProperties;
  published
    //属性
    property Properties:TDrawPanelProperties read GetDrawPanelProperties write SetDrawPanelProperties;
  end;


  {$IFDEF VCL}
  TSkinWinDrawPanel=class(TSkinDrawPanel)
  end;
  {$ENDIF VCL}


implementation



{ TSkinDrawPanelType }

function TSkinDrawPanelType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinDrawPanel,Self.FSkinDrawPanelIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinDrawPanel Interface');
    end;
  end;
end;

procedure TSkinDrawPanelType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinDrawPanelIntf:=nil;
end;

function TSkinDrawPanelType.GetSkinMaterial: TSkinDrawPanelMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinDrawPanelMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinDrawPanelType.CustomMouseMove(Shift: TShiftState; X, Y: Double);
begin
  inherited;

  {$IFNDEF IOS}
  if Not Self.FSkinControlIntf.IsMouseDown then Exit;
  {$ENDIF}
  {$IFNDEF ANDROID}
  if Not Self.FSkinControlIntf.IsMouseDown then Exit;
  {$ENDIF}

//  {$IF NOT DEFINED(IOS) AND NOT DEFINED(ANDROID)}
//  if Self.FSkinControlIntf.IsMouseDown then
//  begin
//  {$ENDIF}




    if (Self.FSkinDrawPanelIntf.Prop.FDrawPathData=nil) and (GetSkinMaterial<>nil) then
    begin
      //第一次鼠标点击
      FLastDrawMouseMovePt:=PointF(X,Y);
      FLastDisMouseMovePt:=PointF(X,Y);
      FDrawDistance:=0;

      //创建路径
      Self.FSkinDrawPanelIntf.Prop.FDrawPathData:=GlobalDrawPathDataClass.Create;
      Self.FSkinDrawPanelIntf.Prop.FDrawPathData.PenWidth:=GetSkinMaterial.FDrawLineParam.PenWidth;
      Self.FSkinDrawPanelIntf.Prop.FDrawPathData.PenColor.Color:=GetSkinMaterial.FDrawLineParam.PenDrawColor.Color;

//      {$IFDEF FMX}
//      Self.FSkinDrawPanelIntf.Prop.FDrawPathData.PathData.MoveTo(PointF(X,Y));
//      {$ENDIF}
//      {$IFDEF VCL}
      Self.FSkinDrawPanelIntf.Prop.FDrawPathData.MoveTo(X,Y);
//      {$ENDIF}
    end;


    if
//        (Sqrt(Power(FLastDrawMouseMovePt.X-X,2)+Power(FLastDrawMouseMovePt.Y-Y,2))>Self.GetSkinMaterial.FDrawLineParam.PenWidth)
//        and (

        //角度变了立即绘制
        (FLastDrawMouseMovePt.X<>X) and (FLastDrawMouseMovePt.Y<>Y)
          //超过长度绘制
         or
         (FLastDrawMouseMovePt.Y=Y) and (ABS(FLastDrawMouseMovePt.X-X)>Self.FSkinDrawPanelIntf.Prop.FDrawPrecision)
         //超过长度绘制
         or (FLastDrawMouseMovePt.X=X) and (ABS(FLastDrawMouseMovePt.Y-Y)>Self.FSkinDrawPanelIntf.Prop.FDrawPrecision)

//         )
         then
    begin
      if Self.FSkinDrawPanelIntf.Prop.FDrawPathData<>nil then
      begin
//        {$IFDEF FMX}
//        Self.FSkinDrawPanelIntf.Prop.FDrawPathData.PathData.LineTo(PointF(X,Y));
//        {$ENDIF}
//        {$IFDEF VCL}
        Self.FSkinDrawPanelIntf.Prop.FDrawPathData.LineTo(X,Y);
//        {$ENDIF}
        FLastDrawMouseMovePt:=PointF(X,Y);
      end;
    end;


    //重绘距离
    FDrawDistance:=FDrawDistance+GetDis(FLastDisMouseMovePt,PointF(X,Y));
          //Sqrt(Power(FLastDisMouseMovePt.X-X,2)+Power(FLastDisMouseMovePt.Y-Y,2));
    if FDrawDistance>Self.FSkinDrawPanelIntf.Prop.FRePaintDistance then
    begin
      if Self.FSkinDrawPanelIntf.Prop.FDrawPathData<>nil then
      begin
        Self.Invalidate;
      end;
    end;
    FLastDisMouseMovePt:=PointF(X,Y);

//  {$IF NOT DEFINED(IOS) AND NOT DEFINED(ANDROID)}
//  end;
//  {$ENDIF}

end;

procedure TSkinDrawPanelType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Double);
begin
  inherited;
  //最后的绘制

  //绘制在Picture上面
  if (Self.FSkinDrawPanelIntf.Prop.FDrawPathData<>nil) then
  begin
    //结束绘制
    Self.FSkinDrawPanelIntf.Prop.FDrawPathDataList.Add(Self.FSkinDrawPanelIntf.Prop.FDrawPathData);
    Self.FSkinDrawPanelIntf.Prop.FDrawPathData:=nil;
    //清除可恢复列表
    Self.FSkinDrawPanelIntf.Prop.FUndoDrawPathDataList.Clear(True);
  end;

  FLastDrawMouseMovePt:=PointF(X,Y);

  Invalidate;
end;

function TSkinDrawPanelType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  I: Integer;
  BSkinMaterial:TSkinDrawPanelMaterial;
begin
  BSkinMaterial:=GetSkinMaterial;
  if BSkinMaterial<>nil then
  begin


    ACanvas.DrawSkinPicture(BSkinMaterial.FDrawBackGndPictureParam,
                            Self.FSkinDrawPanelIntf.Prop.BackGndPicture,
                            ADrawRect,False,ADrawRect,ADrawRect);
    ACanvas.DrawSkinPicture(BSkinMaterial.FDrawPictureParam,
                            Self.FSkinDrawPanelIntf.Prop.Picture,
                            ADrawRect,False,ADrawRect,ADrawRect);

    if Not APaintData.IsInDrawDirectUI then
    begin
      for I := 0 to Self.FSkinDrawPanelIntf.Prop.FDrawPathDataList.Count-1 do
      begin
        ACanvas.DrawPathData(Self.FSkinDrawPanelIntf.Prop.FDrawPathDataList[I]);
      end;

      if Self.FSkinDrawPanelIntf.Prop.FDrawPathData<>nil then
      begin
        ACanvas.DrawPathData(Self.FSkinDrawPanelIntf.Prop.FDrawPathData);
      end;
    end;


  end;
end;

procedure TSkinDrawPanelType.Combine(UseBackGndPictureSize:Boolean);
var
  ASkinPicture:TSkinPicture;
begin
  ASkinPicture:=CombinePicture(UseBackGndPictureSize);
  if ASkinPicture<>nil then
  begin
    Self.FSkinDrawPanelIntf.Prop.FBackGndPicture.Assign(ASkinPicture);
    FreeAndNil(ASkinPicture);
    Self.FSkinDrawPanelIntf.Prop.Clear;
  end;
end;

function TSkinDrawPanelType.CombinePicture(UseBackGndPictureSize:Boolean): TSkinPicture;
var
  I:Integer;
  AWidth,AHeight:Integer;

  ResultPictureDrawCanvas:TDrawCanvas;
  ResultPictureCanvas:TCanvas;

  PathDataPicture:TSkinPicture;
  PathDataPictureSize:TSizeF;
  PathDataPictureDrawCanvas:TDrawCanvas;
  PathDataPictureCanvas:TCanvas;

  APaintData:TPaintData;
var
  ASkinMaterial:TSkinControlMaterial;
begin
  Result:=nil;


  if (Self.FSkinControlIntf.GetSkinControlType<>nil)
      and (Self.FSkinControlIntf.Width>0)
      and (Self.FSkinControlIntf.Height>0) then
  begin


    Result:=uDrawEngine.CreateCurrentEngineSkinPicture;


    if UseBackGndPictureSize
      and Not Self.FSkinDrawPanelIntf.Prop.FBackGndPicture.IsEmpty then
    begin
      //使用背景图片的尺寸
      AWidth:=Self.FSkinDrawPanelIntf.Prop.FBackGndPicture.Width;
      AHeight:=Self.FSkinDrawPanelIntf.Prop.FBackGndPicture.Height;
    end
    else
    begin
      //使用控件的大小
      AWidth:=Ceil(Self.FSkinControlIntf.Width);
      AHeight:=Ceil(Self.FSkinControlIntf.Height);
    end;


    //设置图片大小
//    {$IFDEF FMX}
    Result.SetSize(AWidth,AHeight);
//    {$ENDIF}
//    {$IFDEF VCL}
//    Result.Bitmap.Width:=AWidth;
//    Result.Bitmap.Height:=AHeight;
//    {$ENDIF}




    //创建画布
    ResultPictureDrawCanvas:=uDrawEngine.CreateDrawCanvas('TSkinDrawPanelType.CombinePicture');
    try
      if ResultPictureDrawCanvas<>nil then
      begin
        {$IFDEF FMX}
        ResultPictureCanvas:=TCanvasManager.CreateFromBitmap(Result);
//            ,TCanvasQuality.HighQuality);
        {$ENDIF}
        {$IFDEF VCL}
        ResultPictureCanvas:=Result.Bitmap.Canvas;
        {$ENDIF}
        ResultPictureDrawCanvas.Prepare(ResultPictureCanvas);


        if ResultPictureDrawCanvas.BeginDraw then
        begin
          {$IFDEF FMX}
          ResultPictureCanvas.Clear(0);
          {$ENDIF}
          try

              APaintData:=GlobalNullPaintData;
              APaintData.IsDrawInteractiveState:=True;
              //不绘制线段
              APaintData.IsInDrawDirectUI:=True;


              ASkinMaterial:=FSkinControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial;
              Self.FSkinControlIntf.GetSkinControlType.Paint(ResultPictureDrawCanvas,
                                                              ASkinMaterial,
                                                              RectF(0,0,AWidth,AHeight),
                                                              APaintData);


              //绘制线段
              if Self.FSkinDrawPanelIntf.Prop.FDrawPathDataList.Count>0 then
              begin
                  //控件大小
                  PathDataPicture:=uDrawEngine.CreateCurrentEngineSkinPicture;

                  //合适的比
                  PathDataPictureSize:=AutoFitPictureDrawRect(AWidth,AHeight,
                                Self.FSkinControlIntf.Width,
                                Self.FSkinControlIntf.Height);


                  PathDataPicture.SetSize(Ceil(PathDataPictureSize.cx),
                                          Ceil(PathDataPictureSize.cy));


                  PathDataPictureDrawCanvas:=uDrawEngine.CreateDrawCanvas('TSkinDrawPanelType.CombinePicture');
                  {$IFDEF FMX}
                  PathDataPictureCanvas:=TCanvasManager.CreateFromBitmap(PathDataPicture);
              //            ,TCanvasQuality.HighQuality);
                  {$ENDIF}
                  {$IFDEF VCL}
                  PathDataPictureCanvas:=PathDataPicture.Bitmap.Canvas;
                  {$ENDIF}
                  PathDataPictureDrawCanvas.Prepare(PathDataPictureCanvas);


                  try
                    if PathDataPictureDrawCanvas.BeginDraw then
                    begin
                      {$IFDEF FMX}
                      PathDataPictureCanvas.Clear(0);
                      {$ENDIF FMX}

                      for I := 0 to Self.FSkinDrawPanelIntf.Prop.FDrawPathDataList.Count-1 do
                      begin
                        PathDataPictureDrawCanvas.DrawPathData(Self.FSkinDrawPanelIntf.Prop.FDrawPathDataList[I]);
                      end;
                      PathDataPictureDrawCanvas.EndDraw;




//                      ResultPictureDrawCanvas.FCanvas.DrawBitmap(
//                                       PathDataPicture,
//                                       RectF(0,0,PathDataPicture.Width,PathDataPicture.Height),
//                                       RectF(0,0,AWidth,AHeight),
//                                       1);

//                      PathDataPicture.SaveToFile('E:\aaa.png');
                      ResultPictureDrawCanvas.DrawSkinPicture(
                                        GlobalDrawPictureParam,
                                       PathDataPicture,
                                       RectF(0,0,PathDataPicture.Width,PathDataPicture.Height),
                                       True,
                                       RectF(0,0,PathDataPicture.Width,PathDataPicture.Height),
                                       RectF(0,0,AWidth,AHeight));



                    end;
                  finally
                    FreeAndNil(PathDataPictureDrawCanvas);
                    FreeAndNil(PathDataPictureCanvas);
                    FreeAndNil(PathDataPicture);
                  end;
              end;



          finally
            ResultPictureDrawCanvas.EndDraw;
          end;
        end;

      end;
    finally
      FreeAndNil(ResultPictureCanvas);
      FreeAndNil(ResultPictureDrawCanvas);
    end;

  end;

end;


{ TSkinDrawPanelMaterial }

constructor TSkinDrawPanelMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
  FDrawBackGndPictureParam:=CreateDrawPictureParam('DrawBackGndPictureParam','背景图片绘制参数');
  FDrawLineParam:=CreateDrawLineParam('DrawLineParam','线条绘制参数');
end;

//function TSkinDrawPanelMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
////    if ABTNode.NodeName='DrawLineParam' then
////    begin
////      FDrawLineParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinDrawPanelMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawLineParam',FDrawLineParam.Name);
////  Self.FDrawLineParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//end;

destructor TSkinDrawPanelMaterial.Destroy;
begin
  FreeAndNil(FDrawLineParam);
  FreeAndNil(FDrawPictureParam);
  FreeAndNil(FDrawBackGndPictureParam);
  inherited;
end;

procedure TSkinDrawPanelMaterial.SetDrawLineParam(const Value: TDrawLineParam);
begin
  FDrawLineParam.Assign(Value);
end;

procedure TSkinDrawPanelMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;


procedure TSkinDrawPanelMaterial.SetDrawBackGndPictureParam(const Value: TDrawPictureParam);
begin
  FDrawBackGndPictureParam.Assign(Value);
end;


{ TDrawPanelProperties }


procedure TDrawPanelProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

function TDrawPanelProperties.CanRedo: Boolean;
begin
  Result:=Self.FUndoDrawPathDataList.Count>0;
end;

function TDrawPanelProperties.CanUndo: Boolean;
begin
  Result:=Self.FDrawPathDataList.Count>0;
end;

procedure TDrawPanelProperties.Clear;
begin
  Self.FDrawPathDataList.Clear(True);
  Self.FUndoDrawPathDataList.Clear(True);
  Invalidate;
end;

//procedure TDrawPanelProperties.ClearPicture;
//begin
//  FreeAndNil(FPictureCanvas);
//  FreeAndNil(FPictureDrawCanvas);
//
//  if FIsAutoAdjustPictureSize then
//  begin
//    {$IFDEF FMX}
//    Self.FPicture.SetSize(0,0);
//    {$ENDIF}
//    {$IFDEF VCL}
//    Self.FPicture.Bitmap.SetSize(0,0);
//    {$ENDIF}
//  end
//  else
//  begin
//    {$IFDEF FMX}
//    Self.FPicture.Clear(WhiteColor);
//    {$ENDIF}
//    {$IFDEF VCL}
//    Self.FPicture.Bitmap.Canvas.Brush.Color:=WhiteColor;
//    Self.FPicture.Bitmap.Canvas.FillRect(Rect(0,0,Self.FPicture.Bitmap.Width,Self.FPicture.Bitmap.Height));
//    {$ENDIF}
//  end;
//  Clear;
//end;

constructor TDrawPanelProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinDrawPanel,Self.FSkinDrawPanelIntf) then
  begin
    ShowException('This Component Do not Support ISkinDrawPanel Interface');
  end
  else
  begin
    FDrawPathDataList:=TBaseDrawPathDataList.Create;
    FUndoDrawPathDataList:=TBaseDrawPathDataList.Create;

    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=100;


    FDrawPrecision:=2;
    FRePaintDistance:=10;

//    FPictureDrawCanvas:=nil;
//    FPictureCanvas:=nil;

    FPicture:=uDrawEngine.CreateCurrentEngineSkinPicture;
    FPicture.OnChange:=Self.DoPictureChanged;

    FBackGndPicture:=uDrawEngine.CreateCurrentEngineSkinPicture;
    FBackGndPicture.OnChange:=DoBackGndPictureChanged;


  end;
end;

destructor TDrawPanelProperties.Destroy;
begin
  FreeAndNil(FPicture);
  FreeAndNil(FBackGndPicture);

  FreeAndNil(FDrawPathDataList);
  FreeAndNil(FUndoDrawPathDataList);
  inherited;
end;

procedure TDrawPanelProperties.DoBackGndPictureChanged(Sender: TObject);
begin
  Self.Invalidate;
end;

procedure TDrawPanelProperties.DoPictureChanged(Sender: TObject);
begin
  Self.Invalidate;
end;

function TDrawPanelProperties.GetComponentClassify: String;
begin
  Result:='SkinDrawPanel';
end;

procedure TDrawPanelProperties.Redo;
var
  ADrawPathData:TBaseDrawPathData;
begin
  if CanRedo then
  begin
    ADrawPathData:=Self.FUndoDrawPathDataList.Items[FUndoDrawPathDataList.Count-1];
    FUndoDrawPathDataList.Remove(ADrawPathData,False);
    Self.FDrawPathDataList.Add(ADrawPathData);
    Self.Invalidate;
  end;
end;

procedure TDrawPanelProperties.SetPicture(const Value: TSkinPicture);
begin
  FPicture.Assign(Value);
end;

procedure TDrawPanelProperties.SetBackGndPicture(const Value: TSkinPicture);
begin
  FBackGndPicture.Assign(Value);
end;

procedure TDrawPanelProperties.Undo;
var
  ADrawPathData:TBaseDrawPathData;
begin
  if CanUndo then
  begin
    ADrawPathData:=Self.FDrawPathDataList.Items[FDrawPathDataList.Count-1];
    FDrawPathDataList.Remove(ADrawPathData,False);
    Self.FUndoDrawPathDataList.Add(ADrawPathData);
    Self.Invalidate;
  end;
end;



{ TBaseDrawPathDataList }

function TBaseDrawPathDataList.GetItem(Index: Integer): TBaseDrawPathData;
begin
  Result:=TBaseDrawPathData(Inherited Items[Index]);
end;


{ TSkinDrawPanel }

function TSkinDrawPanel.Material:TSkinDrawPanelDefaultMaterial;
begin
  Result:=TSkinDrawPanelDefaultMaterial(SelfOwnMaterial);
end;

function TSkinDrawPanel.SelfOwnMaterialToDefault:TSkinDrawPanelDefaultMaterial;
begin
  Result:=TSkinDrawPanelDefaultMaterial(SelfOwnMaterial);
end;

function TSkinDrawPanel.CurrentUseMaterialToDefault:TSkinDrawPanelDefaultMaterial;
begin
  Result:=TSkinDrawPanelDefaultMaterial(CurrentUseMaterial);
end;

function TSkinDrawPanel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TDrawPanelProperties;
end;

function TSkinDrawPanel.GetDrawPanelProperties: TDrawPanelProperties;
begin
  Result:=TDrawPanelProperties(Self.FProperties);
end;

procedure TSkinDrawPanel.SetDrawPanelProperties(Value: TDrawPanelProperties);
begin
  Self.FProperties.Assign(Value);
end;




end.
//------------------------------------------------------------------
//
//                 OrangeUI Source Files
//
//  Module: OrangeUIControl
//  Unit: uSkinDrawPanelType
//  Description: 绘制画板
//
//  Copyright: delphiteacher
//  CodeBy: delphiteacher
//  Email: ggggcexx@163.com
//  Writing: 2012-2014
//
//------------------------------------------------------------------




