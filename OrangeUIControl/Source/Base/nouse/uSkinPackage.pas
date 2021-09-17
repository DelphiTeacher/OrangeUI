
//
/// <summary>
///   <para>
///     皮肤包
///   </para>
///   <para>
///     Skin package
///   </para>
/// </summary>
unit uSkinPackage;

interface
{$I FrameWork.inc}

uses
  SysUtils,
  uFuncCommon,
  Classes,
  Types,
  uBaseLog,
  uBaseList,
  uSkinMaterial,
  uComponentType,
  uSkinRegManager,
  uBinaryTreeDoc;

type
  TControlClassifySkinItem=class;
  TControlTypeSkinItem=class;
  TSkinPackage=class;





  //皮肤素材项目(控件类型的皮肤素材列表)
  TMaterialSkinItem=class(TInterfacedPersistent,ISupportClassDocNode)
  private
    //素材名称
    FName:String;


    FIsChanged:Boolean;


    //皮肤素材
    FMaterial: TSkinControlMaterial;
    //素材通知更改的链接
    FMaterialChangeLink:TSkinObjectChangeLink;
    //控件风格
    FControlTypeSkinItem:TControlTypeSkinItem;

    procedure SetName(const Value: String);

    //创建素材
    function CreateMaterial(AOwner:TComponent):TSkinControlMaterial;

    //皮肤素材更改事件
    procedure OnSkinMaterialChange(Sender: TObject);

    //皮肤素材释放通知事件
    procedure OnSkinMaterialDestroy(Sender: TObject);
  public
    constructor Create(AControlTypeSkinItem:TControlTypeSkinItem);
    destructor Destroy;override;
  public
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  published
    //素材名称
    property Name:String read FName write SetName;
    //皮肤素材
    property Material:TSkinControlMaterial read FMaterial;
  end;
  TMaterialSkinList=class(TBaseList,ISupportClassDocNode)
  private

    FIsChanged:Boolean;

    FControlTypeSkinItem:TControlTypeSkinItem;
    function GetItem(Index: Integer): TMaterialSkinItem;
  public
    constructor Create(AControlTypeSkinItem:TControlTypeSkinItem);
  public

    //添加素材
    function AddMaterialSkinItem:TMaterialSkinItem;
    //根据素材名称查找素材
    function FindItemByMaterialName(const AMaterialName:String):TMaterialSkinItem;
  public
    property Items[Index:Integer]:TMaterialSkinItem read GetItem;default;
  public
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  end;









  //控件风格项目
  TControlTypeSkinItem=class(TInterfacedPersistent,ISupportClassDocNode)
  private
    //控件风格
    FControlTypeReg:TSkinControlTypeReg;
    //默认素材
    FDefaultMaterialSkinItem:TMaterialSkinItem;
    //素材列表
    FMaterialSkinList:TMaterialSkinList;
    //控件分类项
    FControlClassifySkinItem:TControlClassifySkinItem;
  public
    constructor Create(AControlClassifySkinItem:TControlClassifySkinItem;
                      AControlTypeReg:TSkinControlTypeReg);
    destructor Destroy;override;
  public
    procedure Clear;
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  public
    //控件风格
    property ControlTypeReg:TSkinControlTypeReg read FControlTypeReg;
    //默认素材
    property DefaultMaterialSkinItem:TMaterialSkinItem read FDefaultMaterialSkinItem;
    //素材列表
    property MaterialSkinList:TMaterialSkinList read FMaterialSkinList;
  published
  end;
  TControlTypeSkinList=class(TBaseList,ISupportClassDocNode)
  private
    FControlClassifySkinItem:TControlClassifySkinItem;
    function GetItem(Index: Integer): TControlTypeSkinItem;
  public
    constructor Create(AControlClassifySkinItem:TControlClassifySkinItem);
  public
    //根据控件类型名称
    function FindItemByControlTypeName(const AControlTypeName:String):TControlTypeSkinItem;
    //添加控件类型
    function AddControlTypeSkinItem(AControlTypeReg:TSkinControlTypeReg
                                      ):TControlTypeSkinItem;
  public
    property Items[Index:Integer]:TControlTypeSkinItem read GetItem;default;
  public
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  end;








  //皮肤分类包项目
  TControlClassifySkinItem=class(TInterfacedPersistent,ISupportClassDocNode)
  private
    FSkinPackage:TSkinPackage;
    //分类注册项
    FControlClassifyReg:TControlClassifyReg;
    //风格包列表
    FControlTypeSkinList:TControlTypeSkinList;
  public
    constructor Create(
                ASkinPackage:TSkinPackage;
                AControlClassifyReg:TControlClassifyReg);
    destructor Destroy;override;
  public
    procedure Clear;
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  public
    //分类注册项
    property ControlClassifyReg:TControlClassifyReg read FControlClassifyReg;

    //风格包列表
    property ControlTypeSkinList:TControlTypeSkinList read FControlTypeSkinList;
  published
  end;
  TControlClassifySkinList=class(TBaseList,ISupportClassDocNode)
  private
    function GetItem(Index: Integer): TControlClassifySkinItem;
  public
    function FindItemByControlClassify(const AControlClassify:String):TControlClassifySkinItem;
  public
    property Items[Index:Integer]:TControlClassifySkinItem read GetItem;default;
  public
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  end;








  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinPackage=class(TComponent)
  private
    FActive: Boolean;


    //名称
    FCaption:String;
    //版本
    FVersion:String;
    //作者
    FAuthor:String;

    //备份目录
    FBackupHistroyDir: String;

    //应该有一个默认配色


    //皮肤包保存路径,文件名为Classify_Type_Name.material

    FControlClassifySkinList:TControlClassifySkinList;

    procedure SetActive(const Value: Boolean);

    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Directory):Boolean;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Directory):Boolean;
  protected
    function IsDataChanged:Boolean;
    procedure DefineProperties(Filer: TFiler);override;
    //从DFM中读写属性数据
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //清除
    procedure Clear;

    //保存到临时文件
    procedure SaveBackupHistroy(Stream: TMemoryStream);overload;
    procedure SaveBackupHistroy;overload;

    //从包文档加载皮肤包
    function LoadFromDocFile(const ADocFilePath:String):Boolean;
    //保存皮肤包到文件
    function SaveToDocFile(const ADocFilePath:String):Boolean;

    //搜索指定风格的默认素材
    function FindMaterialByName(const AControlClassify:String;const AControlTypeName:String;AMaterialName:String):TSkinControlMaterial;
  public
    //分类包列表
    property ControlClassifySkinList:TControlClassifySkinList read FControlClassifySkinList;
  published
    property Active:Boolean read FActive write SetActive;

    //皮肤包名称
    property Caption:String read FCaption write FCaption;
    //作者
    property Author:String read FAuthor write FAuthor;
    //版本
    property Version:String read FVersion write FVersion;

    //备份目录
    property BackupHistroyDir:String read FBackupHistroyDir write FBackupHistroyDir;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinManager=class(TComponent)
  private
    FCurrentSkinPackage:TSkinPackage;
    procedure SetCurrentSkinPackage(const Value: TSkinPackage);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public

  published
    property CurrentSkinPackage:TSkinPackage read FCurrentSkinPackage write SetCurrentSkinPackage;
  end;





var
  DefaultSkinPackage:TSkinPackage;
  GlobalSkinPackageList:TBaseList;

  GlobalSkinManager:TSkinManager;


procedure InitDefaultSkinPackage(ASkinPackage:TSkinPackage);


implementation



procedure InitDefaultSkinPackage(ASkinPackage:TSkinPackage);
var
  AControlClassifySkinItem:TControlClassifySkinItem;
begin
  //按钮
  AControlClassifySkinItem:=ASkinPackage.FControlClassifySkinList.FindItemByControlClassify('SkinButton');



end;


{ TSkinPackage }

procedure TSkinPackage.Clear;
var
  I: Integer;
begin
  FCaption:='';
  FVersion:='';
  FAuthor:='';

//  FDefaultControlTypeUseKind:=ctukDefault;
//  FDefaultMaterialUseKind:=mukSelfOwn;
////
//  FPackageInfoSkinItem.Clear;

  for I := 0 to Self.FControlClassifySkinList.Count - 1 do
  begin
    Self.FControlClassifySkinList[I].Clear;
  end;
end;

constructor TSkinPackage.Create(AOwner:TComponent);
var
  I:Integer;
begin
  Inherited;

  //先创建一个临时目录,然后根据当前时间保存历史文件
  FCaption:=CreateGUIDString;


  //默认备份目录
  FBackupHistroyDir:='C:\';


  FControlClassifySkinList:=TControlClassifySkinList.Create;


  //从全局皮肤注册那到获取所有的控件类型分类列表
  for I := 0 to GlobalControlTypeRegManager.ControlClassifyRegList.Count - 1 do
  begin
    //加载分类
    Self.FControlClassifySkinList.Add(
            TControlClassifySkinItem.Create(
                Self,
                GlobalControlTypeRegManager.ControlClassifyRegList[I]
              )
            );
  end;



  //初始皮肤








  GlobalSkinPackageList.Add(Self);

end;

procedure TSkinPackage.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('Data', ReadData, WriteData, True);
end;

destructor TSkinPackage.Destroy;
begin

  GlobalSkinPackageList.Remove(Self,False);

//  uBaseLog.HandleException(nil,'OrangeUI','uSkinPackage','TSkinPackage.Destroy'+' '+IntToStr(Integer(Self)));

//  if (GlobalSkinManager<>nil)
//    and (GlobalSkinManager.FCurrentSkinPackage=Self) then
//  begin
//    GlobalSkinManager.FCurrentSkinPackage:=nil;
//  end;

  uFuncCommon.FreeAndNil(FControlClassifySkinList);
  inherited;
end;

function TSkinPackage.FindMaterialByName(const AControlClassify:String;const AControlTypeName:String;AMaterialName:String):TSkinControlMaterial;
var
  AStyleSkinItem:TControlTypeSkinItem;
  AControlClassifySkinItem:TControlClassifySkinItem;
  AMaterialSkinItem:TMaterialSkinItem;
begin
  Result:=nil;
  AControlClassifySkinItem:=Self.FControlClassifySkinList.FindItemByControlClassify(AControlClassify);
  if AControlClassifySkinItem<>nil then
  begin
    AStyleSkinItem:=AControlClassifySkinItem.FControlTypeSkinList.FindItemByControlTypeName(AControlTypeName);
    if (AStyleSkinItem<>nil) then
    begin
      AMaterialSkinItem:=AStyleSkinItem.FMaterialSkinList.FindItemByMaterialName(AMaterialName);
      if AMaterialSkinItem<>nil then
      begin
        Result:=AMaterialSkinItem.FMaterial;
      end;
    end;
  end;
end;

function TSkinPackage.IsDataChanged: Boolean;
var
  I: Integer;
  J: Integer;
  AControlClassifySkinItem:TControlClassifySkinItem;
  AControlTypeSkinItem:TControlTypeSkinItem;
  K: Integer;
begin
  Result:=False;
  for I := 0 to Self.FControlClassifySkinList.Count-1 do
  begin
    AControlClassifySkinItem:=TControlClassifySkinItem(Self.FControlClassifySkinList[I]);
    for J := 0 to AControlClassifySkinItem.FControlTypeSkinList.Count-1 do
    begin
      AControlTypeSkinItem:=AControlClassifySkinItem.FControlTypeSkinList[J];


      if AControlTypeSkinItem.MaterialSkinList.FIsChanged then
      begin
        Result:=True;
        Break;
      end;

      for K := 0 to AControlTypeSkinItem.MaterialSkinList.Count-1 do
      begin
        if AControlTypeSkinItem.MaterialSkinList[K].FIsChanged then
        begin
          Result:=True;
          Break;
        end;
      end;

    end;
  end;
end;

//function TSkinPackage.FindDefaultControlTypeNameByControlClassify(const AControlClassify: String): String;
//var
//  ASkinControlTypeReg:TSkinControlTypeReg;
//begin
//  Result:='';
//  ASkinControlTypeReg:=FindDefaultSkinControlTypeRegByControlClassify(AControlClassify);
//  if ASkinControlTypeReg<>nil then
//  begin
//    Result:=ASkinControlTypeReg.ControlTypeName;
//  end;
//end;
//
//function TSkinPackage.FindDefaultMaterial(const AControlClassify,AControlTypeName: String): TSkinControlMaterial;
//var
//  AStyleSkinItem:TControlTypeSkinItem;
//  AControlClassifySkinItem:TControlClassifySkinItem;
//begin
//  Result:=nil;
//  AControlClassifySkinItem:=Self.FControlClassifySkinList.FindItemByControlClassify(AControlClassify);
//  if AControlClassifySkinItem<>nil then
//  begin
//    AStyleSkinItem:=AControlClassifySkinItem.FControlTypeSkinList.FindItemByControlTypeName(AControlTypeName);
//    if (AStyleSkinItem<>nil) and (AStyleSkinItem.FDefaultMaterialSkinItem<>nil) then
//    begin
//      Result:=AStyleSkinItem.FDefaultMaterialSkinItem.FMaterial;
//    end;
//  end;
//end;
//
//function TSkinPackage.FindDefaultMaterialName(const AControlClassify,AControlTypeName: String): String;
//var
//  AStyleSkinItem:TControlTypeSkinItem;
//  AControlClassifySkinItem:TControlClassifySkinItem;
//begin
//  Result:='';
//  AControlClassifySkinItem:=Self.FControlClassifySkinList.FindItemByControlClassify(AControlClassify);
//  if AControlClassifySkinItem<>nil then
//  begin
//    AStyleSkinItem:=AControlClassifySkinItem.FControlTypeSkinList.FindItemByControlTypeName(AControlTypeName);
//    if (AStyleSkinItem<>nil) and (AStyleSkinItem.FDefaultMaterialSkinItem<>nil) then
//    begin
//      Result:=AStyleSkinItem.FDefaultMaterialSkinItem.FMaterialName;
//    end;
//  end;
//end;
//
//function TSkinPackage.FindDefaultSkinControlTypeRegByControlClassify(const AControlClassify: String): TSkinControlTypeReg;
//var
//  AControlClassifySkinItem:TControlClassifySkinItem;
//begin
//  Result:=nil;
//  AControlClassifySkinItem:=Self.FControlClassifySkinList.FindItemByControlClassify(AControlClassify);
//  if AControlClassifySkinItem<>nil then
//  begin
//    Result:=AControlClassifySkinItem.FDefaultSkinControlTypeReg;
//  end;
//end;

function TSkinPackage.LoadFromDocFile(const ADocFilePath: String): Boolean;
var
  ADoc:TBTDOC20;
begin
  Result:=False;

  ADoc:=TBTDOC20.Create;
  ADoc.LoadFromFile(ADocFilePath);

  Result:=LoadFromDocNode(ADoc.TopNode);

  uFuncCommon.FreeAndNil(ADoc);
end;

procedure TSkinPackage.SaveBackupHistroy(Stream: TMemoryStream);
begin

  //保存到临时文件
  try
    if SysUtils.DirectoryExists(Self.FBackupHistroyDir) then
    begin
      Stream.Position:=0;
      //加上时分秒
      Stream.SaveToFile(FBackupHistroyDir
                          +Self.FCaption
                          +' '
                          +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.skin');
    end;
  except
    on E:Exception do
    begin
      HandleException(E,'Base','uSkinPackage','TSkinPackage.SaveBackupHistroy');
    end;
  end;


end;

procedure TSkinPackage.SaveBackupHistroy;
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    WriteData(Stream);
  finally
    FreeAndNIl(Stream);
  end;
end;

function TSkinPackage.SaveToDocFile(const ADocFilePath: String): Boolean;
var
  ADoc:TBTDOC20;
begin
  Result:=False;

  ADoc:=TBTDOC20.Create;

  Result:=SaveToDocNode(ADoc.TopNode);

  ADoc.SaveToFile(ADocFilePath);

  uFuncCommon.FreeAndNil(ADoc);
end;


function TSkinPackage.LoadFromDocNode(ADocNode: TBTNode20_Directory): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Self.Clear;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];
//    if ABTNode.NodeName='PackageInfo' then
//    begin
//      Self.FPackageInfoSkinItem.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    else

    if ABTNode.NodeName='Caption' then
    begin
      FCaption:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Author' then
    begin
      FAuthor:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Version' then
    begin
      FVersion:=ABTNode.ConvertNode_WideString.Data;
    end


    else if ABTNode.NodeName='ControlClassifySkinList' then
    begin
      Self.FControlClassifySkinList.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end

    ;
  end;


  Result:=True;
end;

function TSkinPackage.SaveToDocNode(ADocNode: TBTNode20_Directory): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

//  ABTNode:=ADocNode.AddChildNode_Class('PackageInfo');
//  Self.FPackageInfoSkinItem.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_WideString('Caption','标题');
  ABTNode.ConvertNode_WideString.Data:=FCaption;

  ABTNode:=ADocNode.AddChildNode_WideString('Author','作者');
  ABTNode.ConvertNode_WideString.Data:=FAuthor;

  ABTNode:=ADocNode.AddChildNode_WideString('Version','版本号');
  ABTNode.ConvertNode_WideString.Data:=FVersion;


  ABTNode:=ADocNode.AddChildNode_Class('ControlClassifySkinList');
  Self.FControlClassifySkinList.SaveToDocNode(ABTNode.ConvertNode_Class);


  Result:=True;
end;


procedure TSkinPackage.SetActive(const Value: Boolean);
var
  I: Integer;
begin
  if FActive<>Value then
  begin
    if FActive then
    begin
      DefaultSkinPackage:=nil;
    end;


    if Value then
    begin

      for I := 0 to GlobalSkinPackageList.Count-1 do
      begin
        TSkinPackage(GlobalSkinPackageList[I]).Active:=False;
      end;


      FActive := Value;

      DefaultSkinPackage:=Self;
    end;


  end;
end;

procedure TSkinPackage.ReadData(Stream: TStream);
var
  ADoc:TBTDOC20;
begin
  Clear;
  if Stream.Size=0 then Exit;
  ADoc:=TBTDOC20.Create;
  ADoc.LoadFromStream(Stream);
  try
    LoadFromDocNode(ADoc.TopNode);
  finally
    uFuncCommon.FreeAndNil(ADoc);
  end;
end;

procedure TSkinPackage.WriteData(Stream: TStream);
var
  ADoc:TBTDOC20;
  ADocStream:TMemoryStream;
begin
  ADoc:=TBTDOC20.Create;
  try
    SaveToDocNode(ADoc.TopNode);


    //将文档保存到流中,写到属性中
    ADocStream:=TMemoryStream.Create;
    ADocStream.Size:=0;
    ADoc.SaveToStream(ADocStream);
    ADocStream.Position:=0;
    Stream.CopyFrom(ADocStream,ADocStream.Size);



    //保存到临时文件
    SaveBackupHistroy(ADocStream);
//    try
//      if SysUtils.DirectoryExists(Self.FBackupHistroyDir) then
//      begin
//        ADocStream.Position:=0;
//        //加上时分秒
//        ADocStream.SaveToFile(FBackupHistroyDir
//                            +Self.FCaption
//                            +' '
//                            +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.skin');
//      end;
//    except
//      on E:Exception do
//      begin
//        HandleException(E,'Base','uSkinPackage','TSkinPackage.WriteData');
//      end;
//    end;

  finally
    uFuncCommon.FreeAndNil(ADoc);
    uFuncCommon.FreeAndNil(ADocStream);
  end;
end;

{ TMaterialSkinItem }

constructor TMaterialSkinItem.Create(AControlTypeSkinItem:TControlTypeSkinItem);
begin
  FControlTypeSkinItem:=AControlTypeSkinItem;

  FMaterial:=CreateMaterial(
            FControlTypeSkinItem.FControlClassifySkinItem.FSkinPackage
            );

  //创建素材通知更改的链接
  FMaterialChangeLink:=TSkinObjectChangeLink.Create;
  FMaterialChangeLink.OnChange:=OnSkinMaterialChange;
  FMaterialChangeLink.OnDestroy:=OnSkinMaterialDestroy;

  //加入更改通知
  Self.FMaterial.RegisterChanges(FMaterialChangeLink);

  FIsChanged:=False;
end;

function TMaterialSkinItem.CreateMaterial(AOwner:TComponent): TSkinControlMaterial;
begin
  Result:=nil;
  if (Self.FControlTypeSkinItem<>nil) then
  begin
    Result:=Self.FControlTypeSkinItem.FControlTypeReg.MaterialClass.Create(AOwner);
    Result.SetSubComponent(True);
  end;
end;

destructor TMaterialSkinItem.Destroy;
begin
  uFuncCommon.FreeAndNil(FMaterialChangeLink);
  uFuncCommon.FreeAndNil(FMaterial);
  inherited;
end;

function TMaterialSkinItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Name' then
    begin
      //加载名称
      FName:=ABTNode.ConvertNode_WideString.Data;

      //设置名称
      SetName(FName);

//      FMaterial.Name:=Self.FControlTypeSkinItem.FControlClassifySkinItem.FControlClassifyReg.ControlClassify
//                      +'_'
//                      +Self.FControlTypeSkinItem.FControlTypeReg.ControlTypeName
//                      +'_'
//                      +FName;

    end
    else
    if ABTNode.NodeName='Material' then
    begin
      //加载皮肤素材
      FMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);;
    end
  end;

  Result:=True;

  FIsChanged:=False;
end;

procedure TMaterialSkinItem.OnSkinMaterialChange(Sender: TObject);
begin
  FIsChanged:=True;
end;

procedure TMaterialSkinItem.OnSkinMaterialDestroy(Sender: TObject);
begin

end;

function TMaterialSkinItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;


  //保存类类型
  ADocNode.ClassName:=Self.ClassName;

  //保存名称
  ABTNode:=ADocNode.AddChildNode_WideString('Name','名称');
  ABTNode.ConvertNode_WideString.Data:=FName;

  //保存素材
  ABTNode:=ADocNode.AddChildNode_Class('Material','素材');
  FMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);



  Result:=True;

  FIsChanged:=False;
end;

procedure TMaterialSkinItem.SetName(const Value: String);
begin
  FName := Value;

  //设置名称
  FMaterial.Name:=Self.FControlTypeSkinItem.FControlClassifySkinItem.FControlClassifyReg.ControlClassify
                  +'_'
                  +Self.FControlTypeSkinItem.FControlTypeReg.ControlTypeName
                  +'_'
                  +FName;

end;

{ TMaterialSkinList }

function TMaterialSkinList.AddMaterialSkinItem: TMaterialSkinItem;
begin
  Result:=TMaterialSkinItem.Create(FControlTypeSkinItem);
  Self.Add(Result);

  FIsChanged:=True;
end;

constructor TMaterialSkinList.Create(AControlTypeSkinItem: TControlTypeSkinItem);
begin
  Inherited Create;

//  Inherited Create(TMaterialSkinItem);
  FControlTypeSkinItem:=AControlTypeSkinItem;

  FIsChanged:=False;
end;

function TMaterialSkinList.FindItemByMaterialName(const AMaterialName: String): TMaterialSkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count - 1 do
  begin
    if Items[I].FName=AMaterialName then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TMaterialSkinList.GetItem(Index: Integer): TMaterialSkinItem;
begin
  Result:=TMaterialSkinItem(Inherited Items[Index]);
end;

function TMaterialSkinList.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  AMaterialSkinItem:TMaterialSkinItem;
begin
  Result:=False;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];


    //创建并加载
    AMaterialSkinItem:=AddMaterialSkinItem;
    AMaterialSkinItem.LoadFromDocNode(ABTNode.ConvertNode_Class);

  end;

  Result:=True;

  FIsChanged:=False;
end;

function TMaterialSkinList.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  AMaterialSkinItem:TMaterialSkinItem;
begin
  Result:=False;

  //保存类类型
  ADocNode.ClassName:=Self.ClassName;

  for I := 0 to Self.Count - 1 do
  begin
    AMaterialSkinItem:=Items[I];

    ABTNode:=ADocNode.AddChildNode_Class('MaterialSkinItem');
    AMaterialSkinItem.SaveToDocNode(ABTNode.ConvertNode_Class);

  end;

  Result:=True;

  FIsChanged:=False;
end;

{ TControlTypeSkinList }

function TControlTypeSkinList.AddControlTypeSkinItem(
          AControlTypeReg:TSkinControlTypeReg
          ): TControlTypeSkinItem;
begin
  Result:=TControlTypeSkinItem.Create(FControlClassifySkinItem,AControlTypeReg);
  Self.Add(Result);
end;

function TControlTypeSkinList.FindItemByControlTypeName(const AControlTypeName: String): TControlTypeSkinItem;
var
  I:Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count - 1 do
  begin
    if Items[I].FControlTypeReg.ControlTypeName=AControlTypeName then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

constructor TControlTypeSkinList.Create(
    AControlClassifySkinItem: TControlClassifySkinItem);
begin
  Inherited Create;
  FControlClassifySkinItem:=AControlClassifySkinItem;
end;

function TControlTypeSkinList.GetItem(Index: Integer): TControlTypeSkinItem;
begin
  Result:=TControlTypeSkinItem(Inherited Items[Index]);
end;

function TControlTypeSkinList.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  AStyleSkinItem:TControlTypeSkinItem;
begin
  Result:=False;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    AStyleSkinItem:=Self.FindItemByControlTypeName(ABTNode.NodeName);
    if AStyleSkinItem<>nil then
    begin
      AStyleSkinItem.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end;

  end;

  Result:=True; 
end;

function TControlTypeSkinList.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  AStyleSkinItem:TControlTypeSkinItem;
begin
  Result:=False;


  //保存类类型
  ADocNode.ClassName:=Self.ClassName;


  for I := 0 to Self.Count - 1 do
  begin
    AStyleSkinItem:=Items[I];

    ABTNode:=ADocNode.AddChildNode_Class(AStyleSkinItem.FControlTypeReg.ControlTypeName);
    AStyleSkinItem.SaveToDocNode(ABTNode.ConvertNode_Class);

  end;

  Result:=True;
end;

{ TControlTypeSkinItem }

procedure TControlTypeSkinItem.Clear;
begin
  //默认素材
  FDefaultMaterialSkinItem:=nil;
  //素材包列表
  FMaterialSkinList.Clear(True);
end;

constructor TControlTypeSkinItem.Create(
          AControlClassifySkinItem:TControlClassifySkinItem;
          AControlTypeReg:TSkinControlTypeReg);
begin
  //控件风格
  FControlTypeReg:=AControlTypeReg;
  //控件分类
  FControlClassifySkinItem:=AControlClassifySkinItem;
  //素材列表
  FMaterialSkinList:=TMaterialSkinList.Create(Self);
end;

destructor TControlTypeSkinItem.Destroy;
begin
  uFuncCommon.FreeAndNil(FMaterialSkinList);
  inherited;
end;

function TControlTypeSkinItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  ADefaultMaterialSkinItem:TMaterialSkinItem;
begin
  Result:=False;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];


//    if ABTNode.NodeName='DefaultMaterialName' then
//    begin
//      Self.FDefaultMaterialName:=ABTNode.ConvertNode_WideString.Data;
//    end
//    else

    if ABTNode.NodeName='MaterialSkinList' then
    begin
      Self.FMaterialSkinList.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    ;

  end;
  
//  //设置默认的风格
//  if FDefaultMaterialName<>'' then
//  begin
//    ADefaultMaterialSkinItem:=Self.FMaterialSkinList.FindItemByMaterialName(FDefaultMaterialName);
//    if ADefaultMaterialSkinItem<>nil then
//    begin
//      Self.FDefaultMaterialSkinItem:=ADefaultMaterialSkinItem;
//    end;
//  end;
  
  Result:=True;

end;

function TControlTypeSkinItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;


  //保存类类型
  ADocNode.ClassName:=Self.ClassName;


//  ABTNode:=ADocNode.AddChildNode_WideString('DefaultMaterialName');
//  ABTNode.ConvertNode_WideString.Data:=FDefaultMaterialName;

  ABTNode:=ADocNode.AddChildNode_Class('MaterialSkinList');
  Self.FMaterialSkinList.SaveToDocNode(ABTNode.ConvertNode_Class);
  
  Result:=True;
end;

{ TControlClassifySkinItem }

procedure TControlClassifySkinItem.Clear;
var
  I: Integer;
begin
//  Self.FDefaultControlTypeName:='';
//  FDefaultStyleSkinItem:=nil;
//  if FControlClassifyReg.DefaultSkinControlTypeReg<>nil then
//  begin
//    Self.FDefaultSkinControlTypeReg:=FControlClassifyReg.DefaultSkinControlTypeReg;
//    for I := 0 to Self.FControlTypeSkinList.Count - 1 do
//    begin
//      if Self.FControlTypeSkinList[I].FControlTypeReg=Self.FDefaultSkinControlTypeReg then
//      begin
//        Self.FDefaultStyleSkinItem:=Self.FControlTypeSkinList[I];
//        Break;
//      end;
//    end;
//  end
//  else
//  begin
//    Self.FDefaultSkinControlTypeReg:=nil;
//  end;

  for I := 0 to Self.FControlTypeSkinList.Count - 1 do
  begin
    Self.FControlTypeSkinList[I].Clear;
  end;
end;

constructor TControlClassifySkinItem.Create(
                  ASkinPackage:TSkinPackage;
                  AControlClassifyReg:TControlClassifyReg);
var
  I:Integer;
begin
  FSkinPackage:=ASkinPackage;

  //控件分类注册项
  FControlClassifyReg:=AControlClassifyReg;
  //风格包列表
  FControlTypeSkinList:=TControlTypeSkinList.Create(Self);


  //加载风格(控件素材对)
  for I := 0 to AControlClassifyReg.SkinControlTypeRegList.Count - 1 do
  begin
    Self.FControlTypeSkinList.AddControlTypeSkinItem(
            AControlClassifyReg.SkinControlTypeRegList[I]
              );
  end;

end;

destructor TControlClassifySkinItem.Destroy;
begin
  uFuncCommon.FreeAndNil(FControlTypeSkinList);

  inherited;
end;

function TControlClassifySkinItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I,J: Integer;
  ABTNode:TBTNode20;
  ADefaultControlTypeName:String;
  ADefaultSkinControlTypeReg:TSkinControlTypeReg;
begin
  Result:=False;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

//    if ABTNode.NodeName='DefaultControlTypeName' then
//    begin
//      ADefaultControlTypeName:=ABTNode.ConvertNode_WideString.Data;
//      //设置默认的风格
//      if ADefaultControlTypeName<>'' then
//      begin
//        ADefaultSkinControlTypeReg:=GetGlobalSkinRegManager.FindControlTypeClassRegByControlTypeName(Self.FControlClassifyReg.ControlClassify,ADefaultControlTypeName);
//        if ADefaultSkinControlTypeReg=nil then
//        begin
//          ADefaultControlTypeName:='';
//        end
//        else
//        begin
//          //搜索默认风格
//          for J := 0 to Self.FControlTypeSkinList.Count - 1 do
//          begin
//            if Self.FControlTypeSkinList[J].FControlTypeReg=ADefaultSkinControlTypeReg then
//            begin
//              Self.FDefaultStyleSkinItem:=Self.FControlTypeSkinList[J];
//              Break;
//            end;
//          end;
//        end;
//        Self.FDefaultSkinControlTypeReg:=ADefaultSkinControlTypeReg;
//        Self.FDefaultControlTypeName:=ADefaultControlTypeName;
//      end;
//    end
//    else

    if ABTNode.NodeName='ControlTypeSkinList' then
    begin
      Self.FControlTypeSkinList.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    ;

  end;


  Result:=True;
end;

function TControlClassifySkinItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  //保存类类型
  ADocNode.ClassName:=Self.ClassName;



//  ABTNode:=ADocNode.AddChildNode_WideString('DefaultControlTypeName');
//  ABTNode.ConvertNode_WideString.Data:=FDefaultControlTypeName;

  ABTNode:=ADocNode.AddChildNode_Class('ControlTypeSkinList');
  Self.FControlTypeSkinList.SaveToDocNode(ABTNode.ConvertNode_Class);

  
  Result:=True;
end;

{ TControlClassifySkinList }

function TControlClassifySkinList.FindItemByControlClassify(const AControlClassify: String): TControlClassifySkinItem;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count - 1 do
  begin
    if Items[I].FControlClassifyReg.ControlClassify=AControlClassify then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TControlClassifySkinList.GetItem(Index: Integer): TControlClassifySkinItem;
begin
  Result:=TControlClassifySkinItem(Inherited Items[Index]);
end;

function TControlClassifySkinList.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  AControlClassifySkinItem:TControlClassifySkinItem;
begin
  Result:=False;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    AControlClassifySkinItem:=Self.FindItemByControlClassify(ABTNode.NodeName);
    if AControlClassifySkinItem<>nil then
    begin
      AControlClassifySkinItem.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end;

  end;

  Result:=True;
end;

function TControlClassifySkinList.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
  AControlClassifySkinItem:TControlClassifySkinItem;
begin
  Result:=False;

  //保存类类型
  ADocNode.ClassName:=Self.ClassName;

  for I := 0 to Self.Count - 1 do
  begin
    AControlClassifySkinItem:=Items[I];

    ABTNode:=ADocNode.AddChildNode_Class(AControlClassifySkinItem.FControlClassifyReg.ControlClassify);
    AControlClassifySkinItem.SaveToDocNode(ABTNode.ConvertNode_Class);

  end;

  Result:=True;
end;

{ TSkinManager }

constructor TSkinManager.Create(AOwner: TComponent);
begin
  inherited;

//  uBaseLog.HandleException(nil,'OrangeUI','uSkinPackage','TSkinManager.Create'+' '+IntToStr(Integer(Self)));

//  if GlobalSkinManager=nil then
//  begin
////    uBaseLog.HandleException(nil,'OrangeUI','uSkinPackage','GlobalSkinManager'+' '+IntToStr(Integer(Self)));
//    GlobalSkinManager:=Self;
//  end;

end;

destructor TSkinManager.Destroy;
begin

//  uBaseLog.HandleException(nil,'OrangeUI','uSkinPackage','TSkinManager.Destroy'+' '+IntToStr(Integer(Self)));

//  if GlobalSkinManager=Self then
//  begin
//    GlobalSkinManager:=nil;
//  end;

  inherited;
end;

procedure TSkinManager.SetCurrentSkinPackage(const Value: TSkinPackage);
begin
  FCurrentSkinPackage:=Value;
end;




initialization
  GlobalSkinPackageList:=TBaseList.Create(ooReference);
  DefaultSkinPackage:=TSkinPackage.Create(nil);



finalization
  uFuncCommon.FreeAndNil(DefaultSkinPackage);
  uFuncCommon.FreeAndNil(GlobalSkinPackageList);




end.








