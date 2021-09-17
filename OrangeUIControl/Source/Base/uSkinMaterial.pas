//convert pas to utf8 by ¥
//
/// <summary>
///   <para>
///     素材基类
///   </para>
///   <para>
///     Base type of material
///   </para>
/// </summary>
unit uSkinMaterial;

interface
{$I FrameWork.inc}



uses
  SysUtils,
  Classes,
  Types,

  {$IFDEF FMX}
  UITypes,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics,
  {$ENDIF}

  uBaseLog,
  uBaseList,
  uGraphicCommon,
  uFuncCommon,
  uDrawParam,
  uDrawCanvas,
  uDrawPicture,
  uDrawLineParam,
  uDrawTextParam,
  uDrawPictureParam,
  uDrawPathParam,
  uDrawRectParam,
  uBinaryTreeDoc;

type
  TSkinControlMaterial=class;







  /// <summary>
  ///   <para>
  ///     皮肤素材(多个控件可以共享同一个素材)
  ///   </para>
  ///   <para>
  ///     Skin material(several controls can share one material)
  ///   </para>
  /// </summary>
  TSkinMaterial=class(TComponent,ISupportClassDocNode)
  protected
    FSkinObjectChangeManager:TSkinObjectChangeManager;


    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(const Value: TNotifyEvent);
  protected
    /// <summary>
    ///   <para>
    ///     执行更改
    ///   </para>
    ///   <para>
    ///     Excute change
    ///   </para>
    /// </summary>
    procedure DoChange(Sender:TObject=nil);virtual;

    /// <summary>
    ///   <para>
    ///     复制
    ///   </para>
    ///   <para>
    ///     Copy
    ///   </para>
    /// </summary>
    procedure AssignTo(Dest: TPersistent); override;

  protected

    //创建自己的DrawColor
    function CreateDrawColor(const AName: String;const ACaption:String):TDrawColor;
    //创建自己的DrawPicture
    function CreateDrawPicture(const AName:String;const ACaption:String;const AGroup:String=''):TDrawPicture;
    //创建自己的DrawLineParam
    function CreateDrawLineParam(const AName:String;const ACaption:String):TDrawLineParam;
    //创建自己的DrawTextParam
    function CreateDrawTextParam(const AName:String;const ACaption:String):TDrawTextParam;
    //创建自己的DrawPictureParam
    function CreateDrawPictureParam(const AName:String;const ACaption:String):TDrawPictureParam;
    //创建自己的DrawRectParam
    function CreateDrawRectParam(const AName:String;const ACaption:String):TDrawRectParam;
    function CreateDrawPathParam(const AName:String;const ACaption:String):TDrawPathParam;

  protected

    /// <summary>
    ///   <para>
    ///     开始更新
    ///   </para>
    ///   <para>
    ///     Begin Update
    ///   </para>
    /// </summary>
    procedure BeginUpdate;

    /// <summary>
    ///   <para>
    ///     结束更新
    ///   </para>
    ///   <para>
    ///     End update
    ///   </para>
    /// </summary>
    procedure EndUpdate;
    /// <summary>
    ///   <para>
    ///     通知更改的管理者
    ///   </para>
    ///   <para>
    ///     Manager of NotifyChange
    ///   </para>
    /// </summary>
    property SkinObjectChangeManager:TSkinObjectChangeManager read FSkinObjectChangeManager;

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //参数列表
    FDrawParamList:TBaseList;
    //图片列表
    FDrawPictureList:TBaseList;

    function FindParamByName(const AName:String):TDrawParam;
    function FindPictureByName(const AName:String):TDrawPicture;

    /// <summary>
    ///   <para>
    ///     是否拥有鼠标点击效果
    ///   </para>
    ///   <para>
    ///     Whether have mouse click effect
    ///   </para>
    /// </summary>
    function HasMouseDownEffect:Boolean;virtual;
    /// <summary>
    ///   <para>
    ///     是否拥有鼠标停靠效果
    ///   </para>
    ///   <para>
    ///     Whether have mouse hover effect
    ///   </para>
    /// </summary>
    function HasMouseOverEffect:Boolean;virtual;
  public
    //注册通知更改的链接(可以被多个控件引用)
    procedure RegisterChanges(Value: TSkinObjectChangeLink);
    //反注册通知更改的链接
    procedure UnRegisterChanges(Value: TSkinObjectChangeLink);
  public

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;virtual;

    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;virtual;
  public

    /// <summary>
    ///   <para>
    ///     更改的事件
    ///   </para>
    ///   <para>
    ///     Changed event
    ///   </para>
    /// </summary>
    property OnChange:TNotifyEvent read GetOnChange write SetOnChange;


    /// <summary>
    ///   <para>
    ///     绘制参数列表
    ///   </para>
    ///   <para>
    ///     Parameters list
    ///   </para>
    /// </summary>
    property DrawParamList:TBaseList read FDrawParamList;

    /// <summary>
    ///   <para>
    ///     图片列表
    ///   </para>
    ///   <para>
    ///     Picture list
    ///   </para>
    /// </summary>
    property DrawPictureList:TBaseList read FDrawPictureList;
  end;









  /// <summary>
  ///   <para>
  ///     控件素材基类(有背景透明可以选)
  ///   </para>
  ///   <para>
  ///     Base type of control material(you can choose whether background is
  ///     parent)
  ///   </para>
  /// </summary>
  TSkinControlMaterial=class(TSkinMaterial)
  protected
    FIsInGlobalStyleList:Boolean;

    //风格名称
    FStyleName:String;
    FStyleNameAliases: TStringList;
    //背景是否透明
    FIsTransparent:Boolean;
    //背景颜色矩形绘制参数
    FDrawBackColorParam:TDrawRectParam;
    procedure SetDrawBackColorParam(const Value: TDrawRectParam);
    procedure SetIsTransparent(const Value: Boolean);
    function IsIsTransparentStored: Boolean;
    //当前多少控件引用了该素材
    function GetRefControlCount: Integer;
    procedure SetStyleName(const Value: String);
    procedure SetStyleNameAliases(const Value: TStringList);
  protected
    /// <summary>
    ///   <para>
    ///     复制
    ///   </para>
    ///   <para>
    ///     Copy
    ///   </para>
    /// </summary>
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;

    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;

    /// <summary>
    ///   <para>
    ///     背景矩形绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of back rectangle
    ///   </para>
    /// </summary>
    property DrawBackColorParam:TDrawRectParam read FDrawBackColorParam write SetDrawBackColorParam;
  published
    //风格名称
    property StyleName:String read FStyleName write SetStyleName;
    //风格名称别名
    property StyleNameAliases:TStringList read FStyleNameAliases write SetStyleNameAliases;
    /// <summary>
    ///   <para>
    ///     引用计数(当Material单独做为组件时,显示这个计数,让用户知道有没有被控件所使用)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property RefControlCount:Integer read GetRefControlCount;
    /// <summary>
    ///   <para>
    ///     背景矩形绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of back rectangle
    ///   </para>
    /// </summary>
    property BackColor:TDrawRectParam read FDrawBackColorParam write SetDrawBackColorParam;

    /// <summary>
    ///   <para>
    ///     是否透明
    ///   </para>
    ///   <para>
    ///     Whether transparent
    ///   </para>
    /// </summary>
    property IsTransparent:Boolean read FIsTransparent write SetIsTransparent stored IsIsTransparentStored;
  end;



//  TSkinControlMaterial=class(TSkinControlMaterial)
//  published
//    property BackColor;
//    property IsTransparent;
//    property RefControlCount;
//  end;
var
  GlobalMaterialStyleList:TBaseList;
//  //主题色
//  GlobalSkinThemeColor:TDelphiColor;
//  //主题色2
//  GlobalSkinThemeColor1:TDelphiColor;


implementation





uses
  uDrawEngine;




{ TSkinMaterial }

procedure TSkinMaterial.DoChange(Sender:TObject);
begin
  if (SkinControlInvalidateLocked=0)
      and (Self.Owner<>nil)
      and not (csReading in Self.Owner.ComponentState)
      and not (csLoading in Self.Owner.ComponentState)
    then
  begin
    Self.FSkinObjectChangeManager.DoChange(Self);
  end;
end;

constructor TSkinMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSkinObjectChangeManager:=TSkinObjectChangeManager.Create(Self);

  //绘制参数列表
  FDrawParamList:=TBaseList.Create(ooReference);
  //图片列表
  FDrawPictureList:=TBaseList.Create(ooReference);
end;

function TSkinMaterial.CreateDrawColor(const AName: String;const ACaption:String): TDrawColor;
begin
  Result:=TDrawColor.Create(AName,ACaption);
  Result.OnChange:=DoChange;
end;

function TSkinMaterial.CreateDrawPathParam(const AName,ACaption: String): TDrawPathParam;
begin
  Result:=TDrawPathParam.Create(AName,ACaption);
  Result.OnChange:=Self.DoChange;
  Result.SkinMaterial:=Self;
  Self.FDrawParamList.Add(Result);
end;

function TSkinMaterial.CreateDrawPicture(const AName: String;const ACaption:String;const AGroup:String): TDrawPicture;
begin
  Result:=uDrawEngine.CreateCurrentEngineDrawPicture(AName,ACaption,AGroup);
  Result.OnChange:=Self.DoChange;
  Result.SkinMaterial:=Self;
  Self.FDrawPictureList.Add(Result);
end;

function TSkinMaterial.CreateDrawPictureParam(const AName: String;const ACaption:String): TDrawPictureParam;
begin
  Result:=TDrawPictureParam.Create(AName,ACaption);
  Result.OnChange:=Self.DoChange;
  Result.SkinMaterial:=Self;
  Self.FDrawParamList.Add(Result);
end;

function TSkinMaterial.CreateDrawRectParam(const AName: String;const ACaption:String): TDrawRectParam;
begin
  Result:=TDrawRectParam.Create(AName,ACaption);
  Result.OnChange:=Self.DoChange;
  Result.SkinMaterial:=Self;
  Self.FDrawParamList.Add(Result);
end;

function TSkinMaterial.CreateDrawTextParam(const AName: String;const ACaption:String): TDrawTextParam;
begin
  Result:=TDrawTextParam.Create(AName,ACaption);
  Result.OnChange:=Self.DoChange;
  Result.SkinMaterial:=Self;
  Self.FDrawParamList.Add(Result);
end;

function TSkinMaterial.CreateDrawLineParam(const AName: String;const ACaption:String): TDrawLineParam;
begin
  Result:=TDrawLineParam.Create(AName,ACaption);
  Result.OnChange:=Self.DoChange;
  Result.SkinMaterial:=Self;
  Self.FDrawParamList.Add(Result);
end;

procedure TSkinMaterial.UnRegisterChanges(Value: TSkinObjectChangeLink);
begin
  FSkinObjectChangeManager.UnRegisterChanges(Value);
end;

procedure TSkinMaterial.RegisterChanges(Value: TSkinObjectChangeLink);
begin
  FSkinObjectChangeManager.RegisterChanges(Value);
end;

procedure TSkinMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinMaterial;
  I: Integer;
  ASrcDrawParam:TDrawParam;
  ASrcDrawPicture:TDrawPicture;
begin
  if (Dest is TSkinMaterial) then
  begin
    DestObject:=TSkinMaterial(Dest);


    //复制DrawParam
    for I := 0 to DestObject.FDrawParamList.Count-1 do
    begin
      ASrcDrawParam:=Self.FindParamByName(TDrawParam(DestObject.FDrawParamList[I]).Name);
      if ASrcDrawParam<>nil then
      begin
        TDrawParam(DestObject.FDrawParamList[I]).Assign(ASrcDrawParam);
      end;
    end;


    //复制DrawPicture
    for I := 0 to DestObject.FDrawPictureList.Count-1 do
    begin
      ASrcDrawPicture:=Self.FindPictureByName(TDrawPicture(DestObject.FDrawPictureList[I]).Name);
      if ASrcDrawPicture<>nil then
      begin
        TDrawPicture(DestObject.FDrawPictureList[I]).Assign(ASrcDrawPicture);
      end;
    end;


    DestObject.DoChange;
  end
  else
  begin
    Inherited;
  end;
end;

procedure TSkinMaterial.BeginUpdate;
begin
  Self.FSkinObjectChangeManager.BeginUpdate;
end;

procedure TSkinMaterial.EndUpdate;
begin
  FSkinObjectChangeManager.EndUpdate;
end;

//function TSkinMaterial.FindParam(AName: String): TDrawParam;
//var
//  I: Integer;
//begin
//  for I := Low to High do
//
//end;

function TSkinMaterial.FindParamByName(const AName: String): TDrawParam;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.FDrawParamList.Count-1 do
  begin
    if TDrawParam(FDrawParamList[I]).Name=AName then
    begin
      Result:=TDrawParam(FDrawParamList[I]);
      Break;
    end;
  end;
end;

function TSkinMaterial.FindPictureByName(const AName: String): TDrawPicture;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.FDrawPictureList.Count-1 do
  begin
    if TDrawPicture(FDrawPictureList[I]).Name=AName then
    begin
      Result:=TDrawPicture(FDrawPictureList[I]);
      Break;
    end;
  end;
end;

function TSkinMaterial.GetOnChange: TNotifyEvent;
begin
  Result:=Self.FSkinObjectChangeManager.OnChange;
end;

function TSkinMaterial.HasMouseDownEffect: Boolean;
var
  I: Integer;
begin
  Result:=False;
  for I := 0 to Self.FDrawParamList.Count-1 do
  begin
    Result:=Result or TDrawParam(Self.FDrawParamList[I]).DrawEffectSetting.MouseDownEffect.HasEffectTypes;
  end;
end;

function TSkinMaterial.HasMouseOverEffect: Boolean;
var
  I: Integer;
begin
  Result:=False;
  for I := 0 to Self.FDrawParamList.Count-1 do
  begin
    Result:=Result or TDrawParam(Self.FDrawParamList[I]).DrawEffectSetting.MouseOverEffect.HasEffectTypes;
  end;
end;

procedure TSkinMaterial.SetOnChange(const Value: TNotifyEvent);
begin
  Self.FSkinObjectChangeManager.OnChange:=Value;
end;

destructor TSkinMaterial.Destroy;
begin
  FSkinObjectChangeManager.BeginDestroy(Self);



  //绘制参数列表
  FreeAndNil(FDrawParamList);
  //图片列表
  FreeAndNil(FDrawPictureList);

  //素材通知更改的链接管理者
//  FreeAndNil(FSkinObjectChangeManager);
  //通知控件去掉引用它,从FSkinObjectChangeManager中删除控件
  inherited Destroy;

  //才能再释放FSkinObjectChangeManager
  FreeAndNil(FSkinObjectChangeManager);
end;

function TSkinMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  ADrawParam:TDrawParam;
  ADrawPicture:TDrawPicture;
begin
  Result:=False;


  //加载图片列表
  for I := 0 to Self.FDrawPictureList.Count - 1 do
  begin
    ADrawPicture:=TDrawPicture(Self.FDrawPictureList[I]);
    ABTNode:=ADocNode.FindChildNodeByName(ADrawPicture.Name);
    if ABTNode<>nil then
    begin
      ADrawPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end;
  end;



  //加载参数列表
  for I := 0 to Self.FDrawParamList.Count - 1 do
  begin
    ADrawParam:=TDrawParam(Self.FDrawParamList[I]);
    ABTNode:=ADocNode.FindChildNodeByName(ADrawParam.Name);
    if ABTNode<>nil then
    begin
      ADrawParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end;
  end;



  Result:=True;
end;

function TSkinMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  ADrawParam:TDrawParam;
  ADrawPicture:TDrawPicture;
begin
  Result:=False;

  //保存类类型
  ADocNode.ClassName:=Self.ClassName;

//  //保存名称
//  ABTNode:=ADocNode.AddChildNode_WideString('Name');
//  ABTNode.ConvertNode_WideString.Data:=Name;


  //保存图片列表
  for I := 0 to Self.FDrawPictureList.Count - 1 do
  begin
    ADrawPicture:=TDrawPicture(Self.FDrawPictureList[I]);
    ABTNode:=ADocNode.AddChildNode_Class(ADrawPicture.Name,ADrawPicture.Caption);
    ADrawPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
  end;

  //保存参数列表
  for I := 0 to Self.FDrawParamList.Count - 1 do
  begin
    ADrawParam:=TDrawParam(Self.FDrawParamList[I]);
    ABTNode:=ADocNode.AddChildNode_Class(ADrawParam.Name,ADrawParam.Caption);
    ADrawParam.SaveToDocNode(ABTNode.ConvertNode_Class);
  end;

  Result:=True;
end;






{ TSkinControlMaterial }

procedure TSkinControlMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinControlMaterial;
begin
  if Dest is TSkinControlMaterial then
  begin
    DestObject:=TSkinControlMaterial(Dest);

    DestObject.FIsTransparent:=FIsTransparent;

    //DrawBackColorParam素材在DrawParamList中复制
  end;

  inherited;
end;

constructor TSkinControlMaterial.Create(AOwner: TComponent);
begin
  FIsTransparent:=True;

  inherited Create(AOwner);

  FStyleNameAliases:=TStringList.Create;

  FIsTransparent:=True;


  {$IFDEF VCL}
  FIsTransparent:=False;
  {$ENDIF}


  FDrawBackColorParam:=CreateDrawRectParam('DrawBackColorParam','背景颜色矩形绘制参数');
  {$IFDEF VCL}
  FDrawBackColorParam.IsFill:=True;
  {$ENDIF}

end;

destructor TSkinControlMaterial.Destroy;
begin
  //从全局素材中去除
  if FIsInGlobalStyleList then
  begin
    FIsInGlobalStyleList:=False;
    if GlobalMaterialStyleList<>nil then
    begin
      GlobalMaterialStyleList.Remove(Self,False);
    end;
  end;

  FreeAndNil(FStyleNameAliases);

  FreeAndNil(FDrawBackColorParam);
  inherited;
end;

function TSkinControlMaterial.GetRefControlCount: Integer;
begin
  Result:=Self.FSkinObjectChangeManager.LinkCount;
end;

function TSkinControlMaterial.IsIsTransparentStored: Boolean;
begin

  Result:=(FIsTransparent<>True);

  {$IFDEF VCL}
  Result:=True;
  {$ENDIF}

end;

function TSkinControlMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);



  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsTransparent' then
    begin
      FIsTransparent:=ABTNode.ConvertNode_Bool32.Data;
    end

    //DrawBackColorParam通过DrawParamList来加载

    ;

  end;

  Result:=True;

end;

function TSkinControlMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsTransparent','是否透明');
  ABTNode.ConvertNode_Bool32.Data:=FIsTransparent;


  //DrawBackColorParam通过DrawParamList来保存

  Result:=True;

end;

procedure TSkinControlMaterial.SetDrawBackColorParam(const Value: TDrawRectParam);
begin
  FDrawBackColorParam.Assign(Value);
end;

procedure TSkinControlMaterial.SetIsTransparent(const Value: Boolean);
begin
  if FIsTransparent<>Value then
  begin
    FIsTransparent := Value;
    Self.DoChange;
  end;
end;

procedure TSkinControlMaterial.SetStyleName(const Value: String);
begin
  FStyleName := Value;

  if Trim(FStyleName)<>'' then
  begin
      //如果有风格名称,那么加入到全局公共素材中
      GlobalMaterialStyleList.Add(Self);
      FIsInGlobalStyleList:=True;
  end
  else
  begin
      if FIsInGlobalStyleList then
      begin
        FIsInGlobalStyleList:=False;
        GlobalMaterialStyleList.Remove(Self,False);
      end;
  end;
  
end;

procedure TSkinControlMaterial.SetStyleNameAliases(const Value: TStringList);
begin
  FStyleNameAliases.Assign(Value);
end;

initialization
  GlobalMaterialStyleList:=TBaseList.Create(ooReference);

finalization
  FreeAndNil(GlobalMaterialStyleList);

end.

