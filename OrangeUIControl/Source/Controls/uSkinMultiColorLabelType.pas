//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     多颜色标签
///   </para>
///   <para>
///     Multicolor label
///   </para>
/// </summary>
unit uSkinMultiColorLabelType;

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
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.TextLayout,
  {$ENDIF}
  StrUtils,
  uLang,
  uBaseLog,
  uSkinItems,
  uBaseSkinControl,
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
  IID_ISkinMultiColorLabel:TGUID='{9E222F03-D2CA-4D3D-9C24-D09945A62FE5}';

type
  TMultiColorLabelProperties=class;
  TColorTexts=class;






  /// <summary>
  ///   <para>
  ///     多颜色标签接口
  ///   </para>
  ///   <para>
  ///     Multicolor label interface
  ///   </para>
  /// </summary>
  ISkinMultiColorLabel=interface//(ISkinControl)
    ['{9E222F03-D2CA-4D3D-9C24-D09945A62FE5}']

    function GetMultiColorLabelProperties:TMultiColorLabelProperties;
    property Properties:TMultiColorLabelProperties read GetMultiColorLabelProperties;
    property Prop:TMultiColorLabelProperties read GetMultiColorLabelProperties;
  end;





  /// <summary>
  ///   <para>
  ///     颜色文本项
  ///   </para>
  ///   <para>
  ///     Color TextItem
  ///   </para>
  /// </summary>
  TColorTextItem=class(TBaseColorTextItem)
  protected
    FName: String;

    procedure SetDrawFont(const Value: TDrawFont);
    procedure SetText(const Value: String);
    procedure SetName(const Value: String);
    procedure SetIsUseDefaultDrawFont(const Value: Boolean);
    procedure SetIsUseDefaultDrawFontColor(const Value: Boolean);
  private
    //有些字段都在TBaseColorTextItem中定义了,不需要再定义了
    FIsBindingItem: Boolean;

//    FIsUseDefaultDrawFont: Boolean;
//    FIsUseDefaultDrawFontColor: Boolean;
//    FIsUseDefaultDrawFont: Boolean;
//    FIsUseDefaultDrawFontColor: Boolean;
//    FDrawFont: TDrawFont;
//    FText: String;
//    FDrawFont: TDrawFont;
//    FText: String;

//    FBindItemFieldName:String;
  protected
    procedure DoChange(Sender:TObject);
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy;override;
  public
    property StaticText:String read FText write FText;
  published

    /// <summary>
    ///   <para>
    ///     名字,可以根据Name来绑定,比如ItemCaption,ItemDetail,ItemDetail1等
    ///   </para>
    ///   <para>
    ///     Name
    ///   </para>
    /// </summary>
    property Name:String read FName write SetName;
    property BindItemFieldName:String read FName write SetName;

    /// <summary>
    ///   <para>
    ///     文本
    ///   </para>
    ///   <para>
    ///     Text
    ///   </para>
    /// </summary>
    property Text:String read FText write SetText;

    /// <summary>
    ///   <para>
    ///     绘制字体
    ///   </para>
    ///   <para>
    ///     DrawFont
    ///   </para>
    /// </summary>
    property DrawFont:TDrawFont read FDrawFont write SetDrawFont;


    /// <summary>
    ///   <para>
    ///     是否使用默认的字体绘制
    ///   </para>
    ///   <para>
    ///     Whether use default font to draw
    ///   </para>
    /// </summary>
    property IsUseDefaultDrawFont:Boolean read FIsUseDefaultDrawFont write SetIsUseDefaultDrawFont;

    /// <summary>
    ///   <para>
    ///     是否使用默认的绘制字体颜色(如果不使用,那么使用自带的颜色)
    ///   </para>
    ///   <para>
    ///     Whether use default DrawFont color(if not use,then use its own
    ///     color)
    ///   </para>
    /// </summary>
    property IsUseDefaultDrawFontColor:Boolean read FIsUseDefaultDrawFontColor write SetIsUseDefaultDrawFontColor;

    //是否是绑定的项，//只有一个是绑定项,就自动绑定
    property IsBindingItem:Boolean read FIsBindingItem write FIsBindingItem;
  end;

  TColorTextCollectionItem=TColorTextItem;





  /// <summary>
  ///   多颜色文本项的集合
  /// </summary>
  TColorTexts=class(TCollection,IColorTextList)
  private
    FOwnerInterface: IInterface;
  protected
    { IInterface }
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    procedure AfterConstruction; override;
  protected
    FProperties:TMultiColorLabelProperties;
    function GetItem(Index: Integer): TColorTextItem;
    procedure SetItem(Index: Integer;const Value: TColorTextItem);
    function GetItemByName(Name: String): TColorTextItem;
//    function GetItemByBindItemFieldName(Name: String): TColorTextItem;
  public
    function Add:TColorTextItem;
    function GetColorTextCount:Integer;
    function GetColorTextItem(Index:Integer):TBaseColorTextItem;
  public
    constructor Create(AProperties:TMultiColorLabelProperties=nil);
  public
    function GetText:String;
    property Properties:TMultiColorLabelProperties read FProperties;
    property Prop:TMultiColorLabelProperties read FProperties;
  public
    property ItemByName[Name:String]:TColorTextItem read GetItemByName;
    property Items[Index:Integer]:TColorTextItem read GetItem write SetItem;default;
  end;


  TColorTextCollection=TColorTexts;




  /// <summary>
  ///   <para>
  ///     多颜色文本标签属性
  ///   </para>
  ///   <para>
  ///     Multicolor label property
  ///   </para>
  /// </summary>
  TMultiColorLabelProperties=class(TSkinControlProperties)
  private
    function GetText(AName: String): String;
    procedure SetText(AName: String; const Value: String);
    function GetColor1: TDelphiColor;
    function GetColor2: TDelphiColor;
    function GetColor3: TDelphiColor;
    function GetColor4: TDelphiColor;
    procedure SetColor4(const Value: TDelphiColor);
    procedure SetColor1(const Value: TDelphiColor);
    procedure SetColor2(const Value: TDelphiColor);
    procedure SetColor3(const Value: TDelphiColor);
    function GetText1: String;
    function GetText2: String;
    function GetText3: String;
    function GetText4: String;
    procedure SetText1(const Value: String);
    procedure SetText2(const Value: String);
    procedure SetText3(const Value: String);
    procedure SetText4(const Value: String);
    function GetName1: String;
    function GetName2: String;
    function GetName3: String;
    procedure SetName1(const Value: String);
    procedure SetName2(const Value: String);
    procedure SetName3(const Value: String);
    function GetName4: String;
    procedure SetName4(const Value: String);

    function GetColorIndex(AIndex:Integer):TDelphiColor;
    procedure SetColorIndex(AIndex:Integer;AColor:TDelphiColor);
    function GetTextIndex(AIndex:Integer):String;
    procedure SetTextIndex(AIndex:Integer;AText:String);
    function GetNameIndex(AIndex:Integer):String;
    procedure SetNameIndex(AIndex:Integer;AName:String);
  protected
    FSkinMultiColorLabelIntf:ISkinMultiColorLabel;
    FColorTextCollection: TColorTexts;
    procedure SetColorTextCollection(const Value: TColorTexts);
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //引用的,在朋友圈里面使用,避免重复的创建释放
    RefColorTextCollection:TColorTexts;

    //获取分类名称
    function GetComponentClassify:String;override;
    property Items:TColorTexts read FColorTextCollection write SetColorTextCollection;
    property Text[AName:String]:String read GetText write SetText;
  published
    property AutoSize;
    /// <summary>
    ///   <para>
    ///     多颜色文本项的集合
    ///   </para>
    ///   <para>
    ///     Collection of multicolor TextItem
    ///   </para>
    /// </summary>
    property ColorTextCollection:TColorTexts read FColorTextCollection write SetColorTextCollection;
    //方便
    property Name1:String read GetName1 write SetName1;
    property Name2:String read GetName2 write SetName2;
    property Name3:String read GetName3 write SetName3;
    property Name4:String read GetName4 write SetName4;
    property Text1:String read GetText1 write SetText1;
    property Text2:String read GetText2 write SetText2;
    property Text3:String read GetText3 write SetText3;
    property Text4:String read GetText4 write SetText4;
    property Color1:TDelphiColor read GetColor1 write SetColor1;
    property Color2:TDelphiColor read GetColor2 write SetColor2;
    property Color3:TDelphiColor read GetColor3 write SetColor3;
    property Color4:TDelphiColor read GetColor4 write SetColor4;

  end;









  /// <summary>
  ///   <para>
  ///     多颜色文本标签素材基类
  ///   </para>
  ///   <para>
  ///     Multicolor label material base class
  ///   </para>
  /// </summary>
  TSkinMultiColorLabelMaterial=class(TSkinControlMaterial)
  private
    //标题绘制参数
    FDrawCaptionParam:TDrawTextParam;
    procedure SetDrawCaptionParam(const Value: TDrawTextParam);
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
    ///     标题的绘制参数
    ///   </para>
    ///   <para>
    ///     Caption draw parameter
    ///   </para>
    /// </summary>
    property DrawCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
  end;


  TSkinMultiColorLabelType=class(TSkinControlType)
  private
    FSkinMultiColorLabelIntf:ISkinMultiColorLabel;
    function GetSkinMaterial:TSkinMultiColorLabelMaterial;
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
  TSkinMultiColorLabelDefaultMaterial=class(TSkinMultiColorLabelMaterial);
  TSkinMultiColorLabelDefaultType=TSkinMultiColorLabelType;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinMultiColorLabel=class(TBaseSkinControl,
                              ISkinMultiColorLabel,
                              IBindSkinItemTextControl,
                              IBindSkinItemValueControl
                              )
  private
    function GetMultiColorLabelProperties:TMultiColorLabelProperties;
    procedure SetMultiColorLabelProperties(Value:TMultiColorLabelProperties);
  protected
    {$IFDEF FMX}
    function GetCaption:String;override;
    procedure SetCaption(const Value:String);override;
    {$ENDIF}
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  protected
    //绑定列表项的值
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  public
    //记录多语言的索引
    procedure RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);override;
    //翻译
    procedure TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);override;
  public
    function SelfOwnMaterialToDefault:TSkinMultiColorLabelDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinMultiColorLabelDefaultMaterial;
    function Material:TSkinMultiColorLabelDefaultMaterial;
  public
    procedure CheckAutoBinding(AItemDataTypeName:String);
    property Prop:TMultiColorLabelProperties read GetMultiColorLabelProperties write SetMultiColorLabelProperties;
  published
    //不需要
    //标题
    property Caption;
    property Text;
    //属性
    property Properties:TMultiColorLabelProperties read GetMultiColorLabelProperties write SetMultiColorLabelProperties;
  end;


  {$IFDEF VCL}
  TSkinWinMultiColorLabel=class(TSkinMultiColorLabel)
  end;
  {$ENDIF VCL}



implementation



//uses
//  uSkinItems;




{ TSkinMultiColorLabelType }

function TSkinMultiColorLabelType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinMultiColorLabel,Self.FSkinMultiColorLabelIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinMultiColorLabel Interface');
    end;
  end;
end;

procedure TSkinMultiColorLabelType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinMultiColorLabelIntf:=nil;
end;

function TSkinMultiColorLabelType.GetSkinMaterial: TSkinMultiColorLabelMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinMultiColorLabelMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinMultiColorLabelType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  BSkinMaterial:TSkinMultiColorLabelMaterial;
begin

  BSkinMaterial:=GetSkinMaterial;
  if BSkinMaterial<>nil then
  begin
      if Self.FSkinMultiColorLabelIntf.Prop.RefColorTextCollection<>nil then
      begin
        ACanvas.DrawText(BSkinMaterial.FDrawCaptionParam,
                          Self.FSkinMultiColorLabelIntf.Prop.RefColorTextCollection.GetText,
                          ADrawRect,
                          Self.FSkinMultiColorLabelIntf.Prop.RefColorTextCollection);
      end
      else
      begin
        ACanvas.DrawText(BSkinMaterial.FDrawCaptionParam,
                          Self.FSkinMultiColorLabelIntf.Prop.FColorTextCollection.GetText,
                          ADrawRect,
                          Self.FSkinMultiColorLabelIntf.Prop.FColorTextCollection);
      end;

  end;
end;

function TSkinMultiColorLabelType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
begin
  Result:=False;
  AWidth:=0;
  AHeight:=0;
  if (GetGlobalAutoSizeBufferBitmap.DrawCanvas<>nil)
  and (Self.GetSkinMaterial<>nil) then
  begin
    Result:=GetGlobalAutoSizeBufferBitmap.DrawCanvas.CalcTextDrawSize(
                        Self.GetSkinMaterial.FDrawCaptionParam,
                        Self.FSkinControlIntf.GetCaption,
                        RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height),
                        AWidth,
                        AHeight,
                        cdstBoth);
//    AWidth:=AWidth+10;
  end;
end;


{ TSkinMultiColorLabelMaterial }

constructor TSkinMultiColorLabelMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','标题绘制参数');
end;

destructor TSkinMultiColorLabelMaterial.Destroy;
begin
  FreeAndNil(FDrawCaptionParam);
  inherited;
end;

procedure TSkinMultiColorLabelMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
begin
  FDrawCaptionParam.Assign(Value);
end;


{ TMultiColorLabelProperties }


constructor TMultiColorLabelProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinMultiColorLabel,Self.FSkinMultiColorLabelIntf) then
  begin
    ShowException('This Component Do not Support ISkinMultiColorLabel Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=120;
    Self.FSkinControlIntf.Height:=22;

    FColorTextCollection:=TColorTexts.Create(Self);

  end;
end;

destructor TMultiColorLabelProperties.Destroy;
begin
  FreeAndNil(FColorTextCollection);
  inherited;
end;

function TMultiColorLabelProperties.GetColor1: TDelphiColor;
begin
  Result:=GetColorIndex(0);
end;

function TMultiColorLabelProperties.GetColor2: TDelphiColor;
begin
  Result:=GetColorIndex(1);
end;

function TMultiColorLabelProperties.GetColor3: TDelphiColor;
begin
  Result:=GetColorIndex(2);
end;

function TMultiColorLabelProperties.GetColor4: TDelphiColor;
begin
  Result:=GetColorIndex(3);
end;

function TMultiColorLabelProperties.GetColorIndex(AIndex: Integer): TDelphiColor;
begin
  Result:=BlackColor;
  if AIndex<Self.FColorTextCollection.Count then
  begin
    Result:=FColorTextCollection[AIndex].DrawFont.Color;
  end;
end;

function TMultiColorLabelProperties.GetComponentClassify: String;
begin
  Result:='SkinMultiColorLabel';
end;

function TMultiColorLabelProperties.GetText(AName: String): String;
begin
  Result:=FColorTextCollection.ItemByName[AName].Text;
end;

function TMultiColorLabelProperties.GetText1: String;
begin
  Result:=GetTextIndex(0);
end;

function TMultiColorLabelProperties.GetText2: String;
begin
  Result:=GetTextIndex(1);
end;

function TMultiColorLabelProperties.GetText3: String;
begin
  Result:=GetTextIndex(2);
end;

function TMultiColorLabelProperties.GetText4: String;
begin
  Result:=GetTextIndex(3);
end;

function TMultiColorLabelProperties.GetTextIndex(AIndex: Integer): String;
begin
  Result:='';
  if AIndex<Self.FColorTextCollection.Count then
  begin
    Result:=FColorTextCollection[AIndex].Text;
  end;
end;

function TMultiColorLabelProperties.GetName1: String;
begin
  Result:=GetNameIndex(0);
end;

function TMultiColorLabelProperties.GetName2: String;
begin
  Result:=GetNameIndex(1);
end;

function TMultiColorLabelProperties.GetName3: String;
begin
  Result:=GetNameIndex(2);
end;

function TMultiColorLabelProperties.GetName4: String;
begin
  Result:=GetNameIndex(3);
end;

function TMultiColorLabelProperties.GetNameIndex(AIndex: Integer): String;
begin
  Result:='';
  if AIndex<Self.FColorTextCollection.Count then
  begin
    Result:=FColorTextCollection[AIndex].Name;
  end;
end;


procedure TMultiColorLabelProperties.SetColor1(const Value: TDelphiColor);
begin
  SetColorIndex(0,Value);
end;

procedure TMultiColorLabelProperties.SetColor2(const Value: TDelphiColor);
begin
  SetColorIndex(1,Value);
end;

procedure TMultiColorLabelProperties.SetColor3(const Value: TDelphiColor);
begin
  SetColorIndex(2,Value);
end;

procedure TMultiColorLabelProperties.SetColor4(const Value: TDelphiColor);
begin
  SetColorIndex(3,Value);
end;

procedure TMultiColorLabelProperties.SetColorIndex(AIndex: Integer;
  AColor: TDelphiColor);
var
  I: Integer;
  AStartIndex:Integer;
begin
  if GetColorIndex(AIndex)<>AColor then
  begin
      AStartIndex:=Self.FColorTextCollection.Count;
      for I := AStartIndex to AIndex do
      begin
        FColorTextCollection.Add;
      end;
      FColorTextCollection[AIndex].DrawFont.Color:=AColor;
  end;
end;

procedure TMultiColorLabelProperties.SetColorTextCollection(const Value: TColorTexts);
begin
  FColorTextCollection.Assign(Value);
end;

procedure TMultiColorLabelProperties.SetText(AName: String; const Value: String);
begin
  FColorTextCollection.ItemByName[AName].Text:=Value;
end;

procedure TMultiColorLabelProperties.SetText1(const Value: String);
begin
  SetTextIndex(0,Value);
end;

procedure TMultiColorLabelProperties.SetText2(const Value: String);
begin
  SetTextIndex(1,Value);
end;

procedure TMultiColorLabelProperties.SetText3(const Value: String);
begin
  SetTextIndex(2,Value);
end;

procedure TMultiColorLabelProperties.SetText4(const Value: String);
begin
  SetTextIndex(3,Value);
end;

procedure TMultiColorLabelProperties.SetTextIndex(AIndex: Integer;
  AText: String);
var
  I: Integer;
  AStartIndex:Integer;
begin
  if GetTextIndex(AIndex)<>AText then
  begin
      AStartIndex:=Self.FColorTextCollection.Count;
      for I := AStartIndex to AIndex do
      begin
        FColorTextCollection.Add;
      end;
      FColorTextCollection[AIndex].Text:=AText;
  end;
end;


procedure TMultiColorLabelProperties.SetName1(const Value: String);
begin
  SetNameIndex(0,Value);
end;

procedure TMultiColorLabelProperties.SetName2(const Value: String);
begin
  SetNameIndex(1,Value);
end;

procedure TMultiColorLabelProperties.SetName3(const Value: String);
begin
  SetNameIndex(2,Value);
end;

procedure TMultiColorLabelProperties.SetName4(const Value: String);
begin
  SetNameIndex(3,Value);
end;

procedure TMultiColorLabelProperties.SetNameIndex(AIndex: Integer;
  AName: String);
var
  I: Integer;
  AStartIndex:Integer;
begin
  if GetNameIndex(AIndex)<>AName then
  begin
      AStartIndex:=Self.FColorTextCollection.Count;
      for I := AStartIndex to AIndex do
      begin
        FColorTextCollection.Add;
      end;
      FColorTextCollection[AIndex].Name:=AName;
  end;
end;


{ TColorTextItem }

procedure TColorTextItem.AssignTo(Dest: TPersistent);
begin
//  inherited;
  if (Dest<>nil) and (Dest is TColorTextItem) then
  begin
    TColorTextItem(Dest).FName:=FName;
    TColorTextItem(Dest).FText:=FText;
    TColorTextItem(Dest).FIsUseDefaultDrawFont:=IsUseDefaultDrawFont;
    TColorTextItem(Dest).FDrawFont.Assign(FDrawFont);
  end;
end;

constructor TColorTextItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FDrawFont:=TDrawFont.Create();

  FDrawFont.OnChanged:=Self.DoChange;

  FIsUseDefaultDrawFont:=True;
  FIsUseDefaultDrawFontColor:=False;

end;

destructor TColorTextItem.Destroy;
begin
  FreeAndNil(FDrawFont);
  inherited;
end;

procedure TColorTextItem.DoChange(Sender:TObject);
begin
  if (Self.Collection<>nil) then
  begin
    if TColorTexts(Self.Collection).FProperties<>nil then
    begin
      //自定义大小
      TColorTexts(Self.Collection).FProperties.AdjustAutoSizeBounds;
      //重绘
      TColorTexts(Self.Collection).FProperties.Invalidate;
    end;
  end;
end;

procedure TColorTextItem.SetDrawFont(const Value: TDrawFont);
begin
  FDrawFont.Assign(Value);
end;

procedure TColorTextItem.SetIsUseDefaultDrawFont(const Value: Boolean);
begin
  if FIsUseDefaultDrawFont<>Value then
  begin
    FIsUseDefaultDrawFont := Value;
    DoChange(Self);
  end;
end;

procedure TColorTextItem.SetIsUseDefaultDrawFontColor(const Value: Boolean);
begin
  if FIsUseDefaultDrawFontColor<>Value then
  begin
    FIsUseDefaultDrawFontColor := Value;
    DoChange(Self);
  end;
end;

procedure TColorTextItem.SetName(const Value: String);
begin
  if FName<>Value then
  begin
    FName := Value;
    DoChange(Self);
  end;
end;

procedure TColorTextItem.SetText(const Value: String);
begin
  if FText<>Value then
  begin
    //#13#10不能有回车
    if NewDelphiStringIndexOf(#13,Value) then
    begin
      FText := ReplaceStr(Value,#13#10,'  ');
      FText := ReplaceStr(Value,#13,'  ');
    end
    else
    begin
      FText:=Value;
    end;
    DoChange(Self);
  end;
end;

{ TColorTexts }

constructor TColorTexts.Create(AProperties:TMultiColorLabelProperties);
begin
  Inherited Create(TColorTextItem);
  FProperties:=AProperties;
end;

function TColorTexts.GetColorTextCount: Integer;
begin
  Result:=Count;
end;

function TColorTexts.GetColorTextItem(Index: Integer): TBaseColorTextItem;
begin
  Result:=Items[Index];
end;

function TColorTexts.GetItem(Index: Integer): TColorTextItem;
begin
  Result:=TColorTextItem(Inherited Items[Index]);
end;

//function TColorTexts.GetItemByBindItemFieldName(Name: String): TColorTextItem;
//var
//  I: Integer;
//begin
//  Result:=nil;
//  for I := 0 to Self.Count-1 do
//  begin
//    if Items[I].FBindItemFieldName=Name then
//    begin
//      Result:=Items[I];
//      Break;
//    end;
//  end;
//
//end;

function TColorTexts.GetItemByName(Name: String): TColorTextItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FName=Name then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TColorTexts.GetText: String;
var
  I: Integer;
begin
  Result:='';
  for I := 0 to Self.Count-1 do
  begin
    Result:=Result+Self.Items[I].FText;
  end;
end;

procedure TColorTexts.SetItem(Index: Integer;const Value: TColorTextItem);
begin
  Inherited Items[Index]:=Value;
end;

function TColorTexts.Add: TColorTextItem;
begin
  Result:=TColorTextItem(Inherited Add);
end;

procedure TColorTexts.AfterConstruction;
begin
  inherited;
  if GetOwner <> nil then
    GetOwner.GetInterface(IInterface, FOwnerInterface);
end;

function TColorTexts._AddRef: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._AddRef else
    Result := -1;
end;

function TColorTexts._Release: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._Release else
    Result := -1;
end;

function TColorTexts.QueryInterface(const IID: TGUID;
  out Obj): HResult;
const
  E_NOINTERFACE = HResult($80004002);
begin
  if GetInterface(IID, Obj) then Result := 0 else Result := E_NOINTERFACE;
end;




{ TSkinMultiColorLabel }

{$IFDEF FMX}
procedure TSkinMultiColorLabel.SetCaption(const Value:String);
begin
  //不处理
end;
{$ENDIF FMX}


procedure TSkinMultiColorLabel.SetControlValueByBindItemField(
  const AFieldName: String; const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
var
  I: Integer;
  ATempFieldValue:Variant;
//var
//  AColorTextCollectionItem:TColorTextItem;
begin
//      AColorTextCollectionItem:=Self.Properties.ColorTextCollection.GetItemByBindItemFieldName(Self.Properties.ColorTextCollection[I].BindItemFieldName);
//      if AColorTextCollectionItem<>nil then
//      begin
//        AColorTextCollectionItem.StaticText:=AFieldValue;
//      end;

  for I := 0 to Self.Properties.ColorTextCollection.Count-1 do
  begin
    if Self.Properties.ColorTextCollection[I].Name<>'' then
    begin
      ATempFieldValue:=TSkinItem(ASkinItem).GetValueByBindItemField(Self.Properties.ColorTextCollection[I].Name);
      Self.Properties.ColorTextCollection[I].StaticText:=ATempFieldValue;
    end;
  end;

end;

{$IFDEF FMX}
function TSkinMultiColorLabel.GetCaption:String;
begin
  Result:=GetMultiColorLabelProperties.ColorTextCollection.GetText;
end;
{$ENDIF FMX}

function TSkinMultiColorLabel.Material:TSkinMultiColorLabelDefaultMaterial;
begin
  Result:=TSkinMultiColorLabelDefaultMaterial(SelfOwnMaterial);
end;

procedure TSkinMultiColorLabel.RecordControlLangIndex(APrefix: String; ALang: TLang; ACurLang: String);
var
  I: Integer;
begin
  inherited;

  for I := 0 to Self.Prop.ColorTextCollection.Count-1 do
  begin
    if (Self.Prop.ColorTextCollection[I].Text<>'') then
    begin
      RecordLangIndex(ALang,APrefix+Name+'.Items['+IntToStr(I)+'].Text',ACurLang,Self.Prop.ColorTextCollection[I].Text);
    end;
  end;
end;

function TSkinMultiColorLabel.SelfOwnMaterialToDefault:TSkinMultiColorLabelDefaultMaterial;
begin
  Result:=TSkinMultiColorLabelDefaultMaterial(SelfOwnMaterial);
end;

procedure TSkinMultiColorLabel.CheckAutoBinding(AItemDataTypeName: String);
var
  I: Integer;
  AIsBindingItem:TColorTextItem;
  AIsBindingItemCount:Integer;
begin
  if AItemDataTypeName<>'' then
  begin
      AIsBindingItem:=nil;
      AIsBindingItemCount:=0;
      for I := 0 to Self.Prop.Items.Count-1 do
      begin
        if Self.Prop.Items[I].IsBindingItem then
        begin
          AIsBindingItem:=Self.Prop.Items[I];
          Inc(AIsBindingItemCount);
        end;
      end;

      if (AIsBindingItemCount=1) and (AIsBindingItem.FName='') then
      begin
        //只有一个是绑定项,就自动绑定
        AIsBindingItem.FName:=AItemDataTypeName;
      end;
  end;

end;

function TSkinMultiColorLabel.CurrentUseMaterialToDefault:TSkinMultiColorLabelDefaultMaterial;
begin
  Result:=TSkinMultiColorLabelDefaultMaterial(CurrentUseMaterial);
end;

function TSkinMultiColorLabel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TMultiColorLabelProperties;
end;

function TSkinMultiColorLabel.GetMultiColorLabelProperties: TMultiColorLabelProperties;
begin
  Result:=TMultiColorLabelProperties(Self.FProperties);
end;

procedure TSkinMultiColorLabel.SetMultiColorLabelProperties(Value: TMultiColorLabelProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinMultiColorLabel.TranslateControlLang(APrefix: String;
  ALang: TLang; ACurLang: String);
var
  I:Integer;
begin
  inherited;

  for I := 0 to Self.Prop.ColorTextCollection.Count-1 do
  begin
    if GetLangValue(ALang,APrefix+Name+'.Items['+IntToStr(I)+'].Text',ACurLang)<>'' then
    begin
      Self.Prop.ColorTextCollection[I].Text:=GetLangValue(ALang,APrefix+Name+'.ColorTextCollection['+IntToStr(I)+'].Text',ACurLang);
    end;
  end;
end;

procedure TSkinMultiColorLabel.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetMultiColorLabelProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure TSkinMultiColorLabel.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
var
  AColorTextCollectionItem:TColorTextItem;
begin
  AColorTextCollectionItem:=Self.Properties.ColorTextCollection.ItemByName[AName];
  if AColorTextCollectionItem<>nil then
  begin
    AColorTextCollectionItem.StaticText:=AText;
  end;
end;




end.



