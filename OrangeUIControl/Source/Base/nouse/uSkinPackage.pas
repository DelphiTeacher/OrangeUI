
//
/// <summary>
///   <para>
///     Ƥ����
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





  //Ƥ���ز���Ŀ(�ؼ����͵�Ƥ���ز��б�)
  TMaterialSkinItem=class(TInterfacedPersistent,ISupportClassDocNode)
  private
    //�ز�����
    FName:String;


    FIsChanged:Boolean;


    //Ƥ���ز�
    FMaterial: TSkinControlMaterial;
    //�ز�֪ͨ���ĵ�����
    FMaterialChangeLink:TSkinObjectChangeLink;
    //�ؼ����
    FControlTypeSkinItem:TControlTypeSkinItem;

    procedure SetName(const Value: String);

    //�����ز�
    function CreateMaterial(AOwner:TComponent):TSkinControlMaterial;

    //Ƥ���زĸ����¼�
    procedure OnSkinMaterialChange(Sender: TObject);

    //Ƥ���ز��ͷ�֪ͨ�¼�
    procedure OnSkinMaterialDestroy(Sender: TObject);
  public
    constructor Create(AControlTypeSkinItem:TControlTypeSkinItem);
    destructor Destroy;override;
  public
    //���ĵ��ڵ��м���
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //���浽�ĵ��ڵ�
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  published
    //�ز�����
    property Name:String read FName write SetName;
    //Ƥ���ز�
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

    //����ز�
    function AddMaterialSkinItem:TMaterialSkinItem;
    //�����ز����Ʋ����ز�
    function FindItemByMaterialName(const AMaterialName:String):TMaterialSkinItem;
  public
    property Items[Index:Integer]:TMaterialSkinItem read GetItem;default;
  public
    //���ĵ��ڵ��м���
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //���浽�ĵ��ڵ�
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  end;









  //�ؼ������Ŀ
  TControlTypeSkinItem=class(TInterfacedPersistent,ISupportClassDocNode)
  private
    //�ؼ����
    FControlTypeReg:TSkinControlTypeReg;
    //Ĭ���ز�
    FDefaultMaterialSkinItem:TMaterialSkinItem;
    //�ز��б�
    FMaterialSkinList:TMaterialSkinList;
    //�ؼ�������
    FControlClassifySkinItem:TControlClassifySkinItem;
  public
    constructor Create(AControlClassifySkinItem:TControlClassifySkinItem;
                      AControlTypeReg:TSkinControlTypeReg);
    destructor Destroy;override;
  public
    procedure Clear;
    //���ĵ��ڵ��м���
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //���浽�ĵ��ڵ�
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  public
    //�ؼ����
    property ControlTypeReg:TSkinControlTypeReg read FControlTypeReg;
    //Ĭ���ز�
    property DefaultMaterialSkinItem:TMaterialSkinItem read FDefaultMaterialSkinItem;
    //�ز��б�
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
    //���ݿؼ���������
    function FindItemByControlTypeName(const AControlTypeName:String):TControlTypeSkinItem;
    //��ӿؼ�����
    function AddControlTypeSkinItem(AControlTypeReg:TSkinControlTypeReg
                                      ):TControlTypeSkinItem;
  public
    property Items[Index:Integer]:TControlTypeSkinItem read GetItem;default;
  public
    //���ĵ��ڵ��м���
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //���浽�ĵ��ڵ�
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  end;








  //Ƥ���������Ŀ
  TControlClassifySkinItem=class(TInterfacedPersistent,ISupportClassDocNode)
  private
    FSkinPackage:TSkinPackage;
    //����ע����
    FControlClassifyReg:TControlClassifyReg;
    //�����б�
    FControlTypeSkinList:TControlTypeSkinList;
  public
    constructor Create(
                ASkinPackage:TSkinPackage;
                AControlClassifyReg:TControlClassifyReg);
    destructor Destroy;override;
  public
    procedure Clear;
    //���ĵ��ڵ��м���
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //���浽�ĵ��ڵ�
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  public
    //����ע����
    property ControlClassifyReg:TControlClassifyReg read FControlClassifyReg;

    //�����б�
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
    //���ĵ��ڵ��м���
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //���浽�ĵ��ڵ�
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  end;








  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinPackage=class(TComponent)
  private
    FActive: Boolean;


    //����
    FCaption:String;
    //�汾
    FVersion:String;
    //����
    FAuthor:String;

    //����Ŀ¼
    FBackupHistroyDir: String;

    //Ӧ����һ��Ĭ����ɫ


    //Ƥ��������·��,�ļ���ΪClassify_Type_Name.material

    FControlClassifySkinList:TControlClassifySkinList;

    procedure SetActive(const Value: Boolean);

    //���ĵ��ڵ��м���
    function LoadFromDocNode(ADocNode:TBTNode20_Directory):Boolean;
    //���浽�ĵ��ڵ�
    function SaveToDocNode(ADocNode:TBTNode20_Directory):Boolean;
  protected
    function IsDataChanged:Boolean;
    procedure DefineProperties(Filer: TFiler);override;
    //��DFM�ж�д��������
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //���
    procedure Clear;

    //���浽��ʱ�ļ�
    procedure SaveBackupHistroy(Stream: TMemoryStream);overload;
    procedure SaveBackupHistroy;overload;

    //�Ӱ��ĵ�����Ƥ����
    function LoadFromDocFile(const ADocFilePath:String):Boolean;
    //����Ƥ�������ļ�
    function SaveToDocFile(const ADocFilePath:String):Boolean;

    //����ָ������Ĭ���ز�
    function FindMaterialByName(const AControlClassify:String;const AControlTypeName:String;AMaterialName:String):TSkinControlMaterial;
  public
    //������б�
    property ControlClassifySkinList:TControlClassifySkinList read FControlClassifySkinList;
  published
    property Active:Boolean read FActive write SetActive;

    //Ƥ��������
    property Caption:String read FCaption write FCaption;
    //����
    property Author:String read FAuthor write FAuthor;
    //�汾
    property Version:String read FVersion write FVersion;

    //����Ŀ¼
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
  //��ť
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

  //�ȴ���һ����ʱĿ¼,Ȼ����ݵ�ǰʱ�䱣����ʷ�ļ�
  FCaption:=CreateGUIDString;


  //Ĭ�ϱ���Ŀ¼
  FBackupHistroyDir:='C:\';


  FControlClassifySkinList:=TControlClassifySkinList.Create;


  //��ȫ��Ƥ��ע���ǵ���ȡ���еĿؼ����ͷ����б�
  for I := 0 to GlobalControlTypeRegManager.ControlClassifyRegList.Count - 1 do
  begin
    //���ط���
    Self.FControlClassifySkinList.Add(
            TControlClassifySkinItem.Create(
                Self,
                GlobalControlTypeRegManager.ControlClassifyRegList[I]
              )
            );
  end;



  //��ʼƤ��








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

  //���浽��ʱ�ļ�
  try
    if SysUtils.DirectoryExists(Self.FBackupHistroyDir) then
    begin
      Stream.Position:=0;
      //����ʱ����
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

  ABTNode:=ADocNode.AddChildNode_WideString('Caption','����');
  ABTNode.ConvertNode_WideString.Data:=FCaption;

  ABTNode:=ADocNode.AddChildNode_WideString('Author','����');
  ABTNode.ConvertNode_WideString.Data:=FAuthor;

  ABTNode:=ADocNode.AddChildNode_WideString('Version','�汾��');
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


    //���ĵ����浽����,д��������
    ADocStream:=TMemoryStream.Create;
    ADocStream.Size:=0;
    ADoc.SaveToStream(ADocStream);
    ADocStream.Position:=0;
    Stream.CopyFrom(ADocStream,ADocStream.Size);



    //���浽��ʱ�ļ�
    SaveBackupHistroy(ADocStream);
//    try
//      if SysUtils.DirectoryExists(Self.FBackupHistroyDir) then
//      begin
//        ADocStream.Position:=0;
//        //����ʱ����
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

  //�����ز�֪ͨ���ĵ�����
  FMaterialChangeLink:=TSkinObjectChangeLink.Create;
  FMaterialChangeLink.OnChange:=OnSkinMaterialChange;
  FMaterialChangeLink.OnDestroy:=OnSkinMaterialDestroy;

  //�������֪ͨ
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
      //��������
      FName:=ABTNode.ConvertNode_WideString.Data;

      //��������
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
      //����Ƥ���ز�
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


  //����������
  ADocNode.ClassName:=Self.ClassName;

  //��������
  ABTNode:=ADocNode.AddChildNode_WideString('Name','����');
  ABTNode.ConvertNode_WideString.Data:=FName;

  //�����ز�
  ABTNode:=ADocNode.AddChildNode_Class('Material','�ز�');
  FMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);



  Result:=True;

  FIsChanged:=False;
end;

procedure TMaterialSkinItem.SetName(const Value: String);
begin
  FName := Value;

  //��������
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


    //����������
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

  //����������
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


  //����������
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
  //Ĭ���ز�
  FDefaultMaterialSkinItem:=nil;
  //�زİ��б�
  FMaterialSkinList.Clear(True);
end;

constructor TControlTypeSkinItem.Create(
          AControlClassifySkinItem:TControlClassifySkinItem;
          AControlTypeReg:TSkinControlTypeReg);
begin
  //�ؼ����
  FControlTypeReg:=AControlTypeReg;
  //�ؼ�����
  FControlClassifySkinItem:=AControlClassifySkinItem;
  //�ز��б�
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
  
//  //����Ĭ�ϵķ��
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


  //����������
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

  //�ؼ�����ע����
  FControlClassifyReg:=AControlClassifyReg;
  //�����б�
  FControlTypeSkinList:=TControlTypeSkinList.Create(Self);


  //���ط��(�ؼ��زĶ�)
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
//      //����Ĭ�ϵķ��
//      if ADefaultControlTypeName<>'' then
//      begin
//        ADefaultSkinControlTypeReg:=GetGlobalSkinRegManager.FindControlTypeClassRegByControlTypeName(Self.FControlClassifyReg.ControlClassify,ADefaultControlTypeName);
//        if ADefaultSkinControlTypeReg=nil then
//        begin
//          ADefaultControlTypeName:='';
//        end
//        else
//        begin
//          //����Ĭ�Ϸ��
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

  //����������
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

  //����������
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








