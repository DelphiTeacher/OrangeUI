//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     列表基类
///   </para>
///   <para>
///     Base class of list
///   </para>
/// </summary>
unit uBinaryObjectList;


interface
{$I FrameWork.inc}


uses
  Classes,
  SysUtils,

  uBaseLog,
  uBaseList,

//  FMX.Dialogs,

  uFuncCommon,
  uBinaryTreeDoc;



type
  /// <summary>
  ///   <para>
  ///     在设计时可存储的对象
  ///   </para>
  ///   <para>
  ///     Storable object at designing time
  ///   </para>
  /// </summary>
  TBinaryObject=class(TInterfacedPersistent,ISupportClassDocNode)
  protected

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
  end;







  /// <summary>
  ///   <para>
  ///     在设计时可存储的对象列表
  ///   </para>
  ///   <para>
  ///     Storable object list when designing
  ///   </para>
  /// </summary>
  TBinaryObjectList=class(TBaseList)
  private
    function GetItem(Index: Integer): TInterfacedPersistent;
    procedure SetItem(Index: Integer; const Value: TInterfacedPersistent);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure DefineProperties(Filer: TFiler);override;
  protected
    /// <summary>
    ///   <para>
    ///     创建子对象
    ///   </para>
    ///   <para>
    ///     Create subobject
    ///   </para>
    /// </summary>
    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;virtual;
    /// <summary>
    ///   <para>
    ///     获取子对象的类类型
    ///   </para>
    ///   <para>
    ///     Get class type of subobject
    ///   </para>
    /// </summary>
    function GetBinaryObjectClassName:String;virtual;
  protected

    /// <summary>
    ///   <para>
    ///     从DFM中读属性数据
    ///   </para>
    ///   <para>
    ///     Read property data from DFM
    ///   </para>
    /// </summary>
    procedure DoReadData(Stream: TStream;const AIsNeedClear:Boolean=True);
    procedure ReadData(Stream: TStream);
    /// <summary>
    ///   <para>
    ///     写入属性数据到DFM中
    ///   </para>
    ///   <para>
    ///     Write property data to DFM
    ///   </para>
    /// </summary>
    procedure WriteData(Stream: TStream);
  public

    /// <summary>
    ///   <para>
    ///     从文件加载
    ///   </para>
    ///   <para>
    ///     Load from file
    ///   </para>
    /// </summary>
    procedure LoadFromFile(const AFilePath: String;const AIsNeedClear:Boolean=True);

    /// <summary>
    ///   <para>
    ///     保存到文件
    ///   </para>
    ///   <para>
    ///     Save to file
    ///   </para>
    /// </summary>
    procedure SaveToFile(const AFilePath: String);
  public

    /// <summary>
    ///   <para>
    ///     添加可存储对象
    ///   </para>
    ///   <para>
    ///     Add adroable object
    ///   </para>
    /// </summary>
    function AddBinaryObject:TInterfacedPersistent;

    /// <summary>
    ///   <para>
    ///     添加子对象
    ///   </para>
    ///   <para>
    ///     Add subobject
    ///   </para>
    /// </summary>
    function Add:TInterfacedPersistent;overload;
//    function Add(AObject:TInterfacedPersistent):Integer;overload;

    /// <summary>
    ///   <para>
    ///     创建并插入子对象
    ///   </para>
    ///   <para>
    ///     Create and insert subobject
    ///   </para>
    /// </summary>
    function Insert(Index:Integer):TInterfacedPersistent;overload;
  public

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Directory):Boolean;virtual;

    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Directory):Boolean;virtual;

    /// <summary>
    ///   <para>
    ///     子对象是否可以保存到文档节点
    ///   </para>
    ///   <para>
    ///     Whether can save subobject to document node
    ///   </para>
    /// </summary>
    function CanSaveToDocNode(ABinaryObject:TInterfacedPersistent):Boolean;virtual;
  public
    /// <summary>
    ///   <para>
    ///     子对象
    ///   </para>
    ///   <para>
    ///     Subobject
    ///   </para>
    /// </summary>
    property Items[Index:Integer]:TInterfacedPersistent read GetItem write SetItem;default;
  end;


  TBinaryObjectListReader=class(TReader)

  end;

  TBinaryObjectListWriter=class(TWriter)

  end;


  TTestBinaryObject=class(TBinaryObject)
  private
    FBB: String;
    FAA: String;
  public
  published
    property AA:String read FAA write FAA;
    property BB:String read FBB write FBB;
  end;

  TTestBinaryObjectList=class(TBaseList)
  private
    function GetItem(Index: Integer): TTestBinaryObject;
    procedure SetItem(Index: Integer; const Value: TTestBinaryObject);
  protected
    function Add:TTestBinaryObject;virtual;
    procedure ReadBinaryObjectList(Reader: TReader);
    procedure WriteBinaryObjectList(Writer: TWriter);
    property Items[Index:Integer]:TTestBinaryObject read GetItem write SetItem;default;
  end;

  TTestBinaryObjectListStore=class(TComponent)
  private
    FItems:TTestBinaryObjectList;
    function GetItems: TBaseList;
    procedure SetItems(const Value: TBaseList);
    procedure DefineProperties(Filer: TFiler);override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    property Items:TBaseList read GetItems write SetItems;
  end;








//保存节点到文件
function SaveToDocFile(ASupportClassDocNodeIntf:ISupportClassDocNode;const ANodeName:String;const ADocFilePath: String): Boolean;
//从文件加载节点
function LoadFromDocFile(ASupportClassDocNodeIntf:ISupportClassDocNode;const ANodeName:String;const ADocFilePath: String): Boolean;



implementation




function SaveToDocFile(ASupportClassDocNodeIntf:ISupportClassDocNode;const ANodeName:String;const ADocFilePath: String): Boolean;
var
  ADoc:TBTDOC20;
begin
  Result:=False;

  ADoc:=TBTDOC20.Create;

  Result:=ASupportClassDocNodeIntf.SaveToDocNode(ADoc.TopNode.AddChildNode_Class(ANodeName).ConvertNode_Class);

  ADoc.SaveToFile(ADocFilePath);

  FreeAndNil(ADoc);
end;

function LoadFromDocFile(ASupportClassDocNodeIntf:ISupportClassDocNode;const ANodeName:String;const ADocFilePath: String): Boolean;
var
  ADoc:TBTDOC20;
begin
  Result:=False;

  ADoc:=TBTDOC20.Create;
  ADoc.LoadFromFile(ADocFilePath);

  Result:=ASupportClassDocNodeIntf.LoadFromDocNode(ADoc.TopNode.FindChildNodeByName(ANodeName).ConvertNode_Class);

  FreeAndNil(ADoc);
end;









{ TBinaryObjectList }

function TBinaryObjectList.Add: TInterfacedPersistent;
begin
  Result:=AddBinaryObject;
end;

function TBinaryObjectList.Insert(Index:Integer): TInterfacedPersistent;
begin
  Result:=Self.CreateBinaryObject();
  Inherited Insert(Index,Result);
end;

//function TBinaryObjectList.Add(AObject: TInterfacedPersistent):Integer;
//begin
//  Result:=Inherited Add(AObject);
//end;

function TBinaryObjectList.AddBinaryObject: TInterfacedPersistent;
begin
  Result:=Self.CreateBinaryObject;
  Inherited Add(Result);
end;

procedure TBinaryObjectList.AssignTo(Dest: TPersistent);
var
  I: Integer;
  DestObject:TBinaryObjectList;
  DestBinaryObject:TInterfacedPersistent;
begin
  if (Dest is TBinaryObjectList) then
  begin
    DestObject:=TBinaryObjectList(Dest);
    DestObject.BeginUpdate;
    try
      DestObject.Clear(True);
      for I := 0 to Self.Count - 1 do
      begin
        DestBinaryObject:=DestObject.CreateBinaryObject;
        DestBinaryObject.Assign(Self.Items[I]);
        DestObject.Add(DestBinaryObject);
      end;
    finally
      DestObject.EndUpdate;
    end;
  end;
end;

function TBinaryObjectList.CanSaveToDocNode(ABinaryObject: TInterfacedPersistent): Boolean;
begin
  Result:=True;
end;

function TBinaryObjectList.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
begin
  uBaseLog.ShowException('Have Not Implement TBinaryObjectList.CreateBinaryObject');
end;

procedure TBinaryObjectList.DefineProperties(Filer: TFiler);
begin
  Filer.DefineBinaryProperty('Data', ReadData, WriteData,True);
end;

function TBinaryObjectList.GetBinaryObjectClassName: String;
begin
  Result:='BinaryObject';
end;

function TBinaryObjectList.GetItem(Index: Integer): TInterfacedPersistent;
begin
  Result:=TBinaryObject(Inherited Items[Index]);
end;

function TBinaryObjectList.LoadFromDocNode(ADocNode: TBTNode20_Directory): Boolean;
var
  I: Integer;
  AClassName:String;
  AClassNameNode:TBTNode20;
  ABinaryObjectNode:TBTNode20;
  ABinaryObject:TInterfacedPersistent;
  ABinaryObjectIntf:ISupportClassDocNode;
//  APersistentClass:TPersistentClass;
begin
  Self.BeginUpdate;
//  IsLoading:=True;
  try
    for I := 0 to ADocNode.ChildNodes.Count - 1 do
    begin

        ABinaryObjectNode:=ADocNode.ChildNodes.Items[I];

        ABinaryObject:=nil;
        AClassName:='';
        AClassNameNode:=ABinaryObjectNode.FindChildNodeByName('ClassName');
        if AClassNameNode<>nil then
        begin
            //看看节点有没有指定类
            AClassName:=AClassNameNode.ConvertNode_WideString.Data;
//            if AClassName<>'' then
//            begin
//              APersistentClass:=FindClass(AClassName);
//              if APersistentClass<>nil then
//              begin
//                ABinaryObject:=TInterfacedPersistent(APersistentClass.Create);
//              end;
//            end;
        end;

//        if ABinaryObject=nil then
//        begin
          ABinaryObject:=CreateBinaryObject(AClassName);
//        end;

        if ABinaryObject.GetInterface(IID_ISupportClassDocNode,ABinaryObjectIntf) then
        begin
          ABinaryObjectIntf.LoadFromDocNode(ABinaryObjectNode.ConvertNode_Class);
          Self.Add(ABinaryObject);
        end;

    end;
  finally
    //不能更换位置
//    IsLoading:=False;
    Self.EndUpdate();
  end;
end;

procedure TBinaryObjectList.LoadFromFile(const AFilePath: String;const AIsNeedClear:Boolean);
var
  AFileStream:TFileStream;
begin
  AFileStream:=TFileStream.Create(AFilePath,fmOpenRead);
  try
    DoReadData(AFileStream,AIsNeedClear);
  finally
    FreeAndNil(AFileStream);
  end;
end;

function TBinaryObjectList.SaveToDocNode(ADocNode: TBTNode20_Directory): Boolean;
var
  I: Integer;
  ABinaryObjectNode:TBTNode20;
  ABinaryObjectIntf:ISupportClassDocNode;
begin
  for I := 0 to Self.Count - 1 do
  begin
    if Self.Items[I]<>nil then
    begin
      ABinaryObjectNode:=ADocNode.AddChildNode_Class(GetBinaryObjectClassName);
      if Self.Items[I].GetInterface(IID_ISupportClassDocNode,ABinaryObjectIntf)
        and CanSaveToDocNode(Self.Items[I]) then
      begin
        ABinaryObjectIntf.SaveToDocNode(ABinaryObjectNode.ConvertNode_Class);
      end
      else
      begin
//        uBaseLog.HandleException(nil,'TBinaryObjectList.SaveToDocNode Can Not Save To DocNode');
      end;
    end;
  end;
end;

procedure TBinaryObjectList.SaveToFile(const AFilePath: String);
var
  AFileStream:TFileStream;
begin
  try
    AFileStream:=TFileStream.Create(AFilePath,fmCreate or fmOpenWrite);
    try
      WriteData(AFileStream);
    finally
      FreeAndNil(AFileStream);
    end;
  except

  end;
end;

procedure TBinaryObjectList.SetItem(Index: Integer; const Value: TInterfacedPersistent);
begin
  Inherited Items[Index]:=Value;
end;

procedure TBinaryObjectList.DoReadData(Stream: TStream;const AIsNeedClear:Boolean);
var
  ADoc:TBTDOC20;
begin
  if AIsNeedClear then
  begin
    Clear(True);
  end;

  if Stream.Size=0 then Exit;
  ADoc:=TBTDOC20.Create;
  try
    ADoc.LoadFromStream(Stream);
    LoadFromDocNode(ADoc.TopNode);
  finally
    FreeAndNil(ADoc);
  end;
end;

procedure TBinaryObjectList.ReadData(Stream: TStream);
begin
  DoReadData(Stream);
end;

procedure TBinaryObjectList.WriteData(Stream: TStream);
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
  finally
    FreeAndNil(ADoc);
    FreeAndNil(ADocStream);
  end;
end;

{ TBinaryObject }


function TBinaryObject.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
begin
  Result:=True;
end;

function TBinaryObject.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
begin
  Result:=True;
end;






{ TTestBinaryObjectListStore }

constructor TTestBinaryObjectListStore.Create(AOwner: TComponent);
var
  A:TTestBinaryObject;
begin
  Inherited;
  FItems:=TTestBinaryObjectList.Create;


  A:=Self.FItems.Add;
  A.AA:='AA';
  A.BB:='BB';

end;

procedure TTestBinaryObjectListStore.DefineProperties(Filer: TFiler);
begin
  inherited;

  Filer.DefineProperty('Items', FItems.ReadBinaryObjectList, FItems.WriteBinaryObjectList,
    True);

end;

destructor TTestBinaryObjectListStore.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

//function TTestBinaryObjectListStore.GetItem(Index: Integer): TTestBinaryObject;
//begin
//  Result:=TTestBinaryObject(FItems[Index]);
//end;

function TTestBinaryObjectListStore.GetItems: TBaseList;
begin
  Result:=FItems;
end;

//procedure TTestBinaryObjectListStore.SetItem(Index: Integer;
//  const Value: TTestBinaryObject);
//begin
//  TTestBinaryObject(FItems[Index]).Assign(Value);
//end;

procedure TTestBinaryObjectListStore.SetItems(const Value: TBaseList);
begin
  if Value<>nil then
  begin
    FItems.Assign(Value);
  end
  else
  begin
    FItems.Clear;
  end;
end;


{ TTestBinaryObjectList }


function TTestBinaryObjectList.Add: TTestBinaryObject;
begin
  Result:=TTestBinaryObject.Create;
  Inherited Add(Result);
end;

function TTestBinaryObjectList.GetItem(Index: Integer): TTestBinaryObject;
begin
  Result:=TTestBinaryObject(Inherited Items[Index]);
end;

procedure TTestBinaryObjectList.ReadBinaryObjectList(Reader: TReader);
var
  Item: TPersistent;
begin
//  ShowMessage('ReadBinaryObjectList');

  Self.BeginUpdate;
  try
    if not Reader.EndOfList then FItems.Clear;
    while not Reader.EndOfList do
    begin

//      if Reader.NextValue in [vaInt8, vaInt16, vaInt32] then Reader.ReadInteger;


      Item := Self.Add;
      Reader.ReadListBegin;
      while not Reader.EndOfList do TBinaryObjectListReader(Reader).ReadProperty(Item);
      Reader.ReadListEnd;
    end;
    Reader.ReadListEnd;
  finally
    Self.EndUpdate;
  end;

end;
procedure TTestBinaryObjectList.SetItem(Index: Integer;
  const Value: TTestBinaryObject);
begin
  TTestBinaryObject(Inherited Items[Index]).Assign(Value);
end;

procedure TTestBinaryObjectList.WriteBinaryObjectList(Writer: TWriter);
var
  I: Integer;
  OldAncestor: TPersistent;
begin
//  ShowMessage('WriteBinaryObjectList');
  OldAncestor := Writer.Ancestor;
  Writer.Ancestor := nil;
  try
//    TBinaryObjectListWriter(Writer).Write(vaCollection);


//    if Value <> nil then
      for I := 0 to Self.Count - 1 do
      begin
        Writer.WriteListBegin;
//        Writer.WriteProperties(Self.Items[I]);
        Writer.WriteListEnd;
      end;
    Writer.WriteListEnd;
  finally
    Writer.Ancestor := OldAncestor;
  end;
end;

end.



