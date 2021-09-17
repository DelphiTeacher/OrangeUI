//convert pas to utf8 by ¥
//
/// <summary>
///   <para>
///     皮肤控件注册管理,用于管理控件类型和控件素材的配置
///   </para>
///   <para>
///     Skin control regist Manager,used for managing setting of control type
///     and control material
///   </para>
/// </summary>
unit uSkinRegManager;

interface
{$I FrameWork.inc}

uses
  SysUtils,
  uFuncCommon,
  Classes,
  uGraphicCommon,
  uBaseList,
  uDrawEngine,
  uDrawPicture,
  uSkinMaterial,
  uComponentType,
  uDrawParam,
  uDrawTextParam,
  uDrawPictureParam,
  uDrawRectParam,
  uDrawLineParam,
  uSkinBufferBitmap,
  uDrawCanvas;

type
  TControlTypeClass=class of TSkinControlType;
  TMaterialClass=class of TSkinControlMaterial;




  //控件类型项
  TControlTypeReg=class
  private
    //是否是默认
    FIsDefault:Boolean;
    //控件类型
    FControlTypeName:String;
    //描述
    FDescription:String;
    //控件行为类
    FControlTypeClass: TControlTypeClass;
    //素材类
    FMaterialClass: TMaterialClass;
  public
    //是否是默认
    property IsDefault:Boolean read FIsDefault write FIsDefault;
    //控件类型
    property ControlTypeName:String read FControlTypeName write FControlTypeName;
    //描述
    property Description:String read FDescription write FDescription;
    //控件行为类
    property ControlTypeClass:TControlTypeClass read FControlTypeClass write FControlTypeClass;
    //素材类
    property MaterialClass:TMaterialClass read FMaterialClass write FMaterialClass;
  end;
  TControlTypeRegList=class(TBaseList)
  private
    function GetItem(Index: Integer): TControlTypeReg;
  public
    property Items[Index:Integer]:TControlTypeReg read GetItem;default;
  end;






  //控件分类注册项
  TControlClassifyReg=class
  private
    //分类名称
    FControlClassify:String;
    //默认控件类型-Default
    FDefaultControlTypeReg:TControlTypeReg;
    //控件类型列表
    FControlTypeRegList: TControlTypeRegList;
  public
    constructor Create;
    destructor Destroy;override;
  public
    //皮肤注册列表
    property ControlTypeRegList:TControlTypeRegList read FControlTypeRegList;
    //控件分类名称
    property ControlClassify:String read FControlClassify write FControlClassify;
    //默认风格
    property DefaultControlTypeReg:TControlTypeReg read FDefaultControlTypeReg;
  end;
  TControlClassifyRegList=class(TBaseList)
  private
    function GetItem(Index: Integer): TControlClassifyReg;
  public
    property Items[Index:Integer]:TControlClassifyReg read GetItem;default;
  end;






  TControlTypeRegManager=class
  private
    FControlClassifyRegList:TControlClassifyRegList;
  public
    constructor Create;
    destructor Destroy;override;
    property ControlClassifyRegList:TControlClassifyRegList read FControlClassifyRegList;
  public
    //创建皮肤分类注册项
    function CreateControlTypeClassifyReg(const AControlClassify: String): TControlClassifyReg;

    //查找皮肤分类项
    function Find(const AControlClassify: String): TControlClassifyReg;
    function FindControlClassifyRegIndex(const AControlClassify: String): Integer;
    //查找默认的控件类型
    function FindDefaultControlTypeName(const AControlClassify:String):String;


    //查找指定皮肤
    function FindControlTypeClassByControlTypeName(const AControlClassify:String;Const AControlTypeName:String):TControlTypeClass;

    function FindMaterialClassByControlTypeName(const AControlClassify:String;Const AControlTypeName:String):TMaterialClass;

    function FindControlTypeClassRegByControlTypeName(const AControlClassify:String;Const AControlTypeName:String):TControlTypeReg;

    function FindControlTypeRegIndexByControlTypeNameInClassifyReg(AControlTypeClassifyReg:TControlClassifyReg;Const AControlTypeName:String):Integer;


  end;




var
  //控件类型-ComponentType-Material对照表
  //用于确立什么样的ComponentType创建什么样的SelfOwnMaterial
  GlobalControlTypeRegManager:TControlTypeRegManager;


//注册控件的风格
function RegisterSkinControlStyle(
            const AControlClassify:String;
            AControlTypeClass:TControlTypeClass;
            AMaterialClass:TMaterialClass;
            Const AControlTypeName:String;
            const AIsDefault:Boolean;
            const ADescription:String=''):TControlTypeReg;

//寻找素材
function FindGlobalMaterialByStyleName(
            const AControlClassify:String;
            AStyleName:String;
            var AComponentTypeName:String
            ):TSkinControlMaterial;


implementation

uses
  uComponentTypeRegister;



function FindGlobalMaterialByStyleName(
            const AControlClassify:String;
            AStyleName:String;
            var AComponentTypeName:String
            ):TSkinControlMaterial;
var
  I: Integer;
  J: Integer;
  AReg:TControlClassifyReg;
begin
  Result:=nil;
  AComponentTypeName:='';

  //先根据ControlClassify找到匹配的MaterialClassList
  AReg:=GlobalControlTypeRegManager.Find(AControlClassify);

  //所有控件素材列表
  for I := 0 to GlobalMaterialStyleList.Count-1 do
  begin
    //控件类型
    for J := 0 to AReg.ControlTypeRegList.Count-1 do
    begin
      if (GlobalMaterialStyleList[I] is AReg.ControlTypeRegList[J].FMaterialClass)
        and
          (
              SameText(TSkinControlMaterial(GlobalMaterialStyleList[I]).StyleName,AStyleName)
            or (TSkinControlMaterial(GlobalMaterialStyleList[I]).StyleNameAliases.IndexOf(AStyleName)<>-1)
            or SameText(TSkinControlMaterial(GlobalMaterialStyleList[I]).Name,AStyleName)
          ) then
      begin
          AComponentTypeName:=AReg.ControlTypeRegList[J].FControlTypeName;
          Result:=TSkinControlMaterial(GlobalMaterialStyleList[I]);
          Exit;
      end;
    end;
  end;

end;

function RegisterSkinControlStyle(const AControlClassify:String;
                                  AControlTypeClass:TControlTypeClass;
                                  AMaterialClass:TMaterialClass;
                                  Const AControlTypeName:String;
                                  const AIsDefault:Boolean;
                                  const ADescription:String):TControlTypeReg;
var
  AControlTypeClassifyReg:TControlClassifyReg;
begin
  Result:=nil;
  //创建分类
  AControlTypeClassifyReg:=GlobalControlTypeRegManager.CreateControlTypeClassifyReg(AControlClassify);


  Result:=TControlTypeReg.Create;
  Result.FControlTypeClass:=AControlTypeClass;
  Result.FMaterialClass:=AMaterialClass;
  Result.FControlTypeName:=AControlTypeName;
  Result.FDescription:=ADescription;
  Result.FIsDefault:=AIsDefault;

  AControlTypeClassifyReg.FControlTypeRegList.Add(Result);


  if AIsDefault then
  begin
    AControlTypeClassifyReg.FDefaultControlTypeReg:=Result;
  end;
end;


{ TControlClassifyReg }

constructor TControlClassifyReg.Create;
begin
  FControlTypeRegList:=TControlTypeRegList.Create;
end;

destructor TControlClassifyReg.Destroy;
begin
  FreeAndNil(FControlTypeRegList);
  inherited;
end;


{ TControlTypeRegList }

function TControlTypeRegList.GetItem(Index: Integer): TControlTypeReg;
begin
  Result:=TControlTypeReg(Inherited Items[Index]);
end;




{ TControlClassifyRegList }

function TControlClassifyRegList.GetItem(Index: Integer): TControlClassifyReg;
begin
  Result:=TControlClassifyReg(Inherited Items[Index]);
end;


{ TControlTypeRegManager }

constructor TControlTypeRegManager.Create;
begin
  FControlClassifyRegList:=TControlClassifyRegList.Create;
end;

destructor TControlTypeRegManager.Destroy;
begin
  FreeAndNil(FControlClassifyRegList);
  inherited;
end;

function TControlTypeRegManager.Find(const AControlClassify: String): TControlClassifyReg;
var
  I:Integer;
begin
  Result:=nil;
  for I:=0 to FControlClassifyRegList.Count-1 do
  begin
    if FControlClassifyRegList[I].FControlClassify=AControlClassify then
    begin
      Result:=FControlClassifyRegList[I];
      Break;
    end;
  end;
end;

function TControlTypeRegManager.FindControlClassifyRegIndex(const AControlClassify:String):Integer;
var
  I:Integer;
begin
  Result:=-1;
  for I:=0 to FControlClassifyRegList.Count-1 do
  begin
    if FControlClassifyRegList[I].FControlClassify=AControlClassify then
    begin
      Result:=I;
      Break;
    end;
  end;
end;



function TControlTypeRegManager.CreateControlTypeClassifyReg(const AControlClassify:String):TControlClassifyReg;
var
  AClassifyRegIndex:Integer;
begin
  AClassifyRegIndex:=FindControlClassifyRegIndex(AControlClassify);
  if AClassifyRegIndex=-1 then
  begin
    Result:=TControlClassifyReg.Create;
    Result.FControlClassify:=AControlClassify;
    FControlClassifyRegList.Add(Result);
  end
  else
  begin
    Result:=FControlClassifyRegList[AClassifyRegIndex];
  end;
end;

function TControlTypeRegManager.FindMaterialClassByControlTypeName(const AControlClassify:String;Const AControlTypeName:String):TMaterialClass;
var
  AClassifyRegIndex:Integer;
  AControlTypeRegIndex:Integer;
begin
  Result:=nil;
  AClassifyRegIndex:=FindControlClassifyRegIndex(AControlClassify);
  if AClassifyRegIndex<>-1 then
  begin
    AControlTypeRegIndex:=FindControlTypeRegIndexByControlTypeNameInClassifyReg(FControlClassifyRegList[AClassifyRegIndex],AControlTypeName);
    if AControlTypeRegIndex<>-1 then
    begin
      Result:=FControlClassifyRegList[AClassifyRegIndex].FControlTypeRegList[AControlTypeRegIndex].MaterialClass;
    end;
  end;
end;

function TControlTypeRegManager.FindControlTypeClassByControlTypeName(const AControlClassify:String;Const AControlTypeName:String):TControlTypeClass;
var
  AClassifyRegIndex:Integer;
  AControlTypeRegIndex:Integer;
begin
  Result:=nil;
  AClassifyRegIndex:=FindControlClassifyRegIndex(AControlClassify);
  if AClassifyRegIndex<>-1 then
  begin
    AControlTypeRegIndex:=FindControlTypeRegIndexByControlTypeNameInClassifyReg(FControlClassifyRegList[AClassifyRegIndex],AControlTypeName);
    if AControlTypeRegIndex<>-1 then
    begin
      Result:=FControlClassifyRegList[AClassifyRegIndex].FControlTypeRegList[AControlTypeRegIndex].FControlTypeClass;
    end;
  end;
end;

function TControlTypeRegManager.FindControlTypeClassRegByControlTypeName(const AControlClassify:String;Const AControlTypeName:String):TControlTypeReg;
var
  AClassifyRegIndex:Integer;
  AControlTypeRegIndex:Integer;
begin
  Result:=nil;
  AClassifyRegIndex:=FindControlClassifyRegIndex(AControlClassify);
  if AClassifyRegIndex<>-1 then
  begin
    AControlTypeRegIndex:=FindControlTypeRegIndexByControlTypeNameInClassifyReg(FControlClassifyRegList[AClassifyRegIndex],AControlTypeName);
    if AControlTypeRegIndex<>-1 then
    begin
      Result:=FControlClassifyRegList[AClassifyRegIndex].FControlTypeRegList[AControlTypeRegIndex];
    end;
  end;
end;

function TControlTypeRegManager.FindDefaultControlTypeName(const AControlClassify: String): String;
var
  AClassifyRegIndex:Integer;
begin
  Result:='';
  AClassifyRegIndex:=FindControlClassifyRegIndex(AControlClassify);
  if (AClassifyRegIndex<>-1) and (FControlClassifyRegList[AClassifyRegIndex].DefaultControlTypeReg<>nil) then
  begin
    Result:=FControlClassifyRegList[AClassifyRegIndex].DefaultControlTypeReg.FControlTypeName;
  end;
end;

function TControlTypeRegManager.FindControlTypeRegIndexByControlTypeNameInClassifyReg(AControlTypeClassifyReg:TControlClassifyReg;Const AControlTypeName:String):Integer;
var
  I:Integer;
begin
  Result:=-1;
  for I:=0 to AControlTypeClassifyReg.FControlTypeRegList.Count-1 do
  begin
    if TControlTypeReg(AControlTypeClassifyReg.FControlTypeRegList[I]).FControlTypeName=AControlTypeName then
    begin
      Result:=I;
      Break;
    end;
  end;
end;

initialization
  GlobalControlTypeRegManager:=TControlTypeRegManager.Create;


  //注册控件
  RegisterComponentTypes;
  RegisterComponentClasses;






finalization
  FreeAndNil(GlobalControlTypeRegManager);


end.



