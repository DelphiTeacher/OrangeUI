//convert pas to utf8 by ¥

unit uManager;

interface

uses
  Classes,
  SysUtils,
  IniFiles,
  Types,

  Variants,

//  Variants,
  IdURI,
  uDrawPicture,

  uFuncCommon,
  uFileCommon,
  uBaseList,
  XSuperObject,
  XSuperJson
  ;


type

  TBaseJsonObjectClass=class of TBaseJsonObject;
  TBaseJsonObject=class
  public
    constructor Create;virtual;
    function ParseFromJson(AJson: ISuperObject): Boolean;virtual;abstract;
  end;
  TBaseJsonObjectList=class(TBaseList)
  public
    function ParseFromJsonArray(JsonObjectClass:TBaseJsonObjectClass;JsonArray:ISuperArray):Boolean;
  end;



  TGoodsCategory=class(TBaseJsonObject)
  public
    FID:Int64;//1,
    Name:String;//"\u6D3B\u52A8",
    OrderNO:Double;//1
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TGoodsCategoryList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TGoodsCategory;
  public
    property Items[Index:Integer]:TGoodsCategory read GetItem;default;
  end;






  TGoods=class(TBaseJsonObject)
  public
    FID:Int64;//1,
    Name:String;//"\u65B0\u95FB\u6807\u9898",
    Unit_:String;//"\u65B0\u95FB\u63CF\u8FF0",
    ThumbPicPath:String;//"1.png",
    Price:Double;//"1.html",
    AddTime:String;//"2016-07-15 00:00:00",
    GoodsCategoryID:Int64;//1

//    Number:Integer;
  public
    function GetThumbPicUrl:String;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TGoodsList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TGoods;
  public
    property Items[Index:Integer]:TGoods read GetItem;default;
  end;


//  TVersion=class(TBaseJsonObject)
//  public
//    function ParseFromJson(AJson: ISuperObject): Boolean;override;
//  end;


//
//  TBaseBook=class(TBaseJsonObject)
//  public
//    AddTime:String;//"2016-07-16 00:00:00",
//
//
////    FID_1:Int64;//1,
//    Name:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B",
//    PicPath:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.jpg",
//    FileSize:Int64;//34000,
////    FileName:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.doc",
//    FilePath:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.doc",
//    FileDesc:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B",
//    FileDescPath:String;//"1.html",
//    BookCategoryID:Int64;//1
//
//
//    //区分浏览
//    IOSFilePath:String;
//    AndroidFilePath:String;
//
//    //分段浏览
//    TextFilePath:String;
//
//    function GetBookID:Int64;virtual;abstract;
//  public
//    function GetLocalFilePath:String;
//    function GetLocalUrl:String;
//    function GetUrl:String;
//    function GetPicUrl:String;
//  public
//    function ParseFromJson(AJson: ISuperObject): Boolean;override;
//  end;
//  TBaseBookList=class(TBaseJsonObjectList)
//  private
//    function GetItem(Index: Integer): TBaseBook;
//  public
//    function FindItemByBookID(ABookID:Int64):TBaseBook;
//    property Items[Index:Integer]:TBaseBook read GetItem;default;
//  end;
//
//
//
//
//  TBook=class(TBaseBook)
//  public
//    FID:Int64;//1,
//    function GetBookID:Int64;override;
//  public
//    function ParseFromJson(AJson: ISuperObject): Boolean;override;
//  end;
//  TBookList=class(TBaseBookList)
//  end;
//
//
//  TUserBook=class(TBaseBook)
//  public
////    FID:Int64;//1,
////    UserID:Int64;//1,
//
//    BookID:Int64;//1,
////    AddTime:String;//"2016-07-16 00:00:00",
//    LastReadTime:String;//"",
//    LastReadPageIndex:String;//"",
//
//////    FID_1:Int64;//1,
////    Name:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B",
////    PicPath:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.jpg",
////    FileSize:Int64;//34000,
//////    FileName:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.doc",
////    FilePath:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.doc",
////    FileDesc:String;//"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B",
////    FileDescPath:String;//"1.html",
////    BookCategoryID:Int64;//1
////
////    IOSFilePath:String;
////
////    AndroidFilePath:String;
//    function GetBookID:Int64;override;
//  public
////    function GetLocalFilePath:String;
////    function GetLocalUrl:String;
////    function GetUrl:String;
////    function GetPicUrl:String;
//  public
//    function ParseFromJson(AJson: ISuperObject): Boolean;override;
//  end;
//  TUserBookList=class(TBaseBookList)
////  private
////    function GetItem(Index: Integer): TUserBook;
////  public
////    property Items[Index:Integer]:TUserBook read GetItem;default;
//  end;
//
//
//  TUserMind=class(TBaseJsonObject)
//  public
//    FID:Int64;//1,
//    UserID:Int64;//1,
//    BookID:Int64;//1,
//    SelectedContent:String;//"选取的内容",
//    Mind:String;//"想法心得",
//    AddTime:String;//"2016-07-16 00:00:00",
//    UserName:String;//"王能",
//    UserHeadPicPath:String;//"1.png",
//
//    BookName:String;//"党政领导干部选拔任用工作条例"
//
//    CompanyName:String;//"支队",
//  public
//    function GetUserHeadPicUrl:String;
//  public
//    function ParseFromJson(AJson: ISuperObject): Boolean;override;
//  end;
//  TUserMindList=class(TBaseJsonObjectList)
//  private
//    function GetItem(Index: Integer): TUserMind;
//  public
//    property Items[Index:Integer]:TUserMind read GetItem;default;
//  end;
//
//
//  TUserSpirit=class(TBaseJsonObject)
//  public
//    FID:Int64;//1,
//    UserID:Int64;//1,
//    Spirit:String;//"风采",
//
//    Pic1Width:Integer;
//    Pic1Height:Integer;
//
//
//    Pic1Path:String;//"1.jpeg",
//    Pic2Path:String;//"2.jpeg",
//    Pic3Path:String;//"3.jpeg",
//    Pic4Path:String;//"4.jpeg",
//    Pic5Path:String;//"5.jpeg",
//    Pic6Path:String;//"",
//    Pic7Path:String;//"",
//    Pic8Path:String;//"",
//    Pic9Path:String;//"",
//
//
//    AddTime:String;//"2016-07-16 00:00:00",
//
//    UserName:String;//"王能",
//    UserHeadPicPath:String;//"1.png"
//
//    CompanyName:String;//"支队",
//  public
//    function GetUserHeadPicUrl:String;
//  public
//    Pic1:TDrawPicture;//"1.jpeg",
//    Pic2:TDrawPicture;//"2.jpeg",
//    Pic3:TDrawPicture;//"3.jpeg",
//    Pic4:TDrawPicture;//"4.jpeg",
//    Pic5:TDrawPicture;//"5.jpeg",
//    Pic6:TDrawPicture;//"",
//    Pic7:TDrawPicture;//"",
//    Pic8:TDrawPicture;//"",
//    Pic9:TDrawPicture;//"",
//
//    PicList:TDrawPictureList;
//
//    function GetPic1Url:String;
//    function GetPic2Url:String;
//    function GetPic3Url:String;
//    function GetPic4Url:String;
//    function GetPic5Url:String;
//    function GetPic6Url:String;
//    function GetPic7Url:String;
//    function GetPic8Url:String;
//    function GetPic9Url:String;
//
//
//    constructor Create;override;
//    destructor Destroy;override;
//  public
//    function ParseFromJson(AJson: ISuperObject): Boolean;override;
//  end;
//  TUserSpiritList=class(TBaseJsonObjectList)
//  private
//    function GetItem(Index: Integer): TUserSpirit;
//  public
//    property Items[Index:Integer]:TUserSpirit read GetItem;default;
//  end;
//



  TManager=class
  public

    //用户名
    RoomNO:String;
    //密码
    WaitorNO:String;

  public
    function LoadFromINI(AINIFilePath: String): Boolean;
    function SaveToINI(AINIFilePath: String): Boolean;
  public
    constructor Create;
    destructor Destroy;override;
  public
    procedure Load;
    procedure Save;
  end;


var
//  CurrentVersion:String;
  ServerUrl:String;
  GlobalManager:TManager;


function GetJsonDoubleValue(AJson: ISuperObject;Name:String):Double;

implementation


function GetJsonDoubleValue(AJson: ISuperObject;Name:String):Double;
begin
//  if AJson.Null[Name]=jNull then
//  begin
//    Result:='';
//  end
//  else
//  begin
//    Result:=AJson.V[Name];
//  end;
  if VarIsNull(AJson.V[Name]) then
  begin
    Result:=0.00;
  end
  else
  if (AJson.GetType(Name)=varString) and (AJson.V[Name]='') then
  begin
    Result:=0.00;
  end
  else
  begin
    Result:=AJson.V[Name];
  end;
end;



{ TManager }

constructor TManager.Create;
begin
end;

destructor TManager.Destroy;
begin
  inherited;
end;

procedure TManager.Load;
begin
  Self.LoadFromINI(uFileCommon.GetApplicationPath+'Config.ini');

end;

function TManager.LoadFromINI(AINIFilePath: String): Boolean;
var
  AIniFile:TIniFile;
begin
  Result:=False;

  AIniFile:=TIniFile.Create(AINIFilePath);

  Self.RoomNO:=AIniFile.ReadString('','RoomNO','');
  Self.WaitorNO:=AIniFile.ReadString('','WaitorNO','');


  uFuncCommon.FreeAndNil(AIniFile);

  Result:=True;

end;

procedure TManager.Save;
begin
  Self.SaveToINI(uFileCommon.GetApplicationPath+'Config.ini');

end;

function TManager.SaveToINI(AINIFilePath: String): Boolean;
var
  AIniFile:TIniFile;
begin
  Result:=False;
  AIniFile:=TIniFile.Create(AINIFilePath);

  AIniFile.WriteString('','RoomNO',Self.RoomNO);
  AIniFile.WriteString('','WaitorNO',Self.WaitorNO);

  uFuncCommon.FreeAndNil(AIniFile);
  Result:=True;

end;


{ TBaseJsonObjectList }

function TBaseJsonObjectList.ParseFromJsonArray(JsonObjectClass:TBaseJsonObjectClass;JsonArray: ISuperArray): Boolean;
var
  I:Integer;
  ABaseJsonObject:TBaseJsonObject;
begin
  Result:=False;

  for I := 0 to JsonArray.Length - 1 do
  begin
    ABaseJsonObject:=JsonObjectClass.Create();
    ABaseJsonObject.ParseFromJson(JsonArray.O[I]);
    Self.Add(ABaseJsonObject);
  end;

  Result:=True;
end;

{ TBaseJsonObject }

constructor TBaseJsonObject.Create;
begin

end;

{ TGoodsCategory }

function TGoodsCategory.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  FID:=AJson.I['FID'];//1,
  Name:=AJson.S['Name'];//"\u6D3B\u52A8",
  OrderNO:=GetJsonDoubleValue(AJson,'OrderNO');//1
end;

{ TGoodsCategoryList }

function TGoodsCategoryList.GetItem(Index: Integer): TGoodsCategory;
begin
  Result:=TGoodsCategory(Inherited Items[Index]);
end;

{ TGoods }

function TGoods.GetThumbPicUrl: String;
begin
  Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Goods/ThumbPic/'+Self.ThumbPicPath);
end;

function TGoods.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  FID:=AJson.I['FID'];//1,
  Name:=AJson.S['Name'];//"\u65B0\u95FB\u6807\u9898",
  Unit_:=AJson.S['Unit'];//"\u65B0\u95FB\u63CF\u8FF0",
  ThumbPicPath:=AJson.S['ThumbPicPath'];//"1.png",
  Price:=GetJsonDoubleValue(AJson,'Price');//"1.html",
  AddTime:=AJson.S['AddTime'];//"2016-07-15 00:00:00",
  GoodsCategoryID:=AJson.I['GoodsCategoryID'];//1

//  Number:=0;
end;




{ TGoodsList }

function TGoodsList.GetItem(Index: Integer): TGoods;
begin
  Result:=TGoods(Inherited Items[Index]);
end;

//{ TUserBook }
//
//function TUserBook.GetBookID: Int64;
//begin
//  Result:=BookID;
//end;
//
//function TUserBook.ParseFromJson(AJson: ISuperObject): Boolean;
//begin
//  Inherited;
//
////  FID:=AJson.I['FID'];//1,
////  UserID:=AJson.I['UserID'];//1,
//  BookID:=AJson.I['BookID'];//1,
////  AddTime:=AJson.S['AddTime'];//"2016-07-16 00:00:00",
////  LastReadTime:=AJson.S['LastReadTime'];//"",
////  LastReadPageIndex:=AJson.S['LastReadPageIndex'];//"",
//////  FID_1:=AJson.I['FID_1'];//1,
////  Name:=AJson.S['Name'];
////  PicPath:=AJson.S['PicPath'];
////  FileSize:=AJson.I['FileSize'];//34000,
////
//////  FileName:=AJson.S['FileName'];
//////"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.doc",
////  FilePath:=AJson.S['FilePath'];
////  //"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.doc",
////
////  FileDesc:=AJson.S['FileDesc'];
////  //"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B",
////  FileDescPath:=AJson.S['FileDescPath'];//"1.html",
////  BookCategoryID:=AJson.I['BookCategoryID'];//1
////
//////  IOSFileName:=AJson.S['IOSFileName'];
////  IOSFilePath:=AJson.S['IOSFilePath'];
////
//////  AndroidFileName:=AJson.S['AndroidFileName'];
////  AndroidFilePath:=AJson.S['AndroidFilePath'];
//
//end;
//
////function TUserBook.GetLocalUrl: String;
////begin
////  Result:='file://'+GetLocalFilePath;
////  {$IFDEF ANDROID}
////  Result:='file:/'+GetLocalFilePath;
////  {$ENDIF}
////end;
////
////function TUserBook.GetPicUrl: String;
////begin
////  Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Books/Pic/'+Self.PicPath);
////end;
////
////function TUserBook.GetLocalFilePath: String;
////begin
////  Result:=GetApplicationPath+'Books'+PathDelim+IntToStr(Self.GetBookID)+PathDelim+Self.FilePath;
////  {$IFDEF IOS}
////  if Self.IOSFilePath<>'' then
////  begin
////    Result:=GetApplicationPath+'Books'+PathDelim+IntToStr(Self.GetBookID)+PathDelim+Self.IOSFilePath;
////  end;
////  {$ENDIF}
////
////  {$IFDEF ANDROID}
////  if Self.AndroidFilePath<>'' then
////  begin
////    Result:=GetApplicationPath+'Books'+PathDelim+IntToStr(Self.GetBookID)+PathDelim+Self.AndroidFilePath;
////  end;
////  {$ENDIF}
////
////end;
////
////function TUserBook.GetUrl: String;
////begin
////  //URLEncode
////  Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Books/'+IntToStr(Self.GetBookID)+'/'+Self.FilePath);
////  {$IFDEF IOS}
////  if Self.IOSFilePath<>'' then
////  begin
////    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Books/'+IntToStr(Self.GetBookID)+'/'+Self.IOSFilePath);
////  end;
////  {$ENDIF}
////
////  {$IFDEF ANDROID}
////  if Self.AndroidFilePath<>'' then
////  begin
////    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Books/'+IntToStr(Self.GetBookID)+'/'+Self.AndroidFilePath);
////  end;
////  {$ENDIF}
////
////end;
////
////{ TUserBookList }
////
////function TUserBookList.GetItem(Index: Integer): TUserBook;
////begin
////  Result:=TUserBook(Inherited Items[Index]);
////end;
//
//
//
//{ TBaseBook }
//
//function TBaseBook.ParseFromJson(AJson: ISuperObject): Boolean;
//begin
////  FID:=AJson.I['FID'];//1,
//  AddTime:=AJson.S['AddTime'];//"2016-07-16 00:00:00",
////  LastReadTime:=AJson.S['LastReadTime'];//"",
////  LastReadPageIndex:=AJson.S['LastReadPageIndex'];//"",
////  FID_1:=AJson.I['FID_1'];//1,
//  Name:=AJson.S['Name'];
//  PicPath:=AJson.S['PicPath'];
//  FileSize:=AJson.I['FileSize'];//34000,
//
////  FileName:=AJson.S['FileName'];
////"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.doc",
//  FilePath:=AJson.S['FilePath'];
//  //"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B.doc",
//
//  FileDesc:=AJson.S['FileDesc'];
//  //"\u515A\u653F\u9886\u5BFC\u5E72\u90E8\u9009\u62D4\u4EFB\u7528\u5DE5\u4F5C\u6761\u4F8B",
//  FileDescPath:=AJson.S['FileDescPath'];//"1.html",
//  BookCategoryID:=AJson.I['BookCategoryID'];//1
//
//  IOSFilePath:=AJson.S['IOSFilePath'];
//
//  AndroidFilePath:=AJson.S['AndroidFilePath'];
//
//  TextFilePath:=AJson.S['TextFilePath'];
//
//end;
//
//function TBaseBook.GetLocalUrl: String;
//begin
//  Result:='file://'+GetLocalFilePath;
//  {$IFDEF ANDROID}
//  Result:='file:/'+GetLocalFilePath;
//  {$ENDIF}
//end;
//
//function TBaseBook.GetPicUrl: String;
//begin
//  Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Books/Pic/'+Self.PicPath);
//end;
//
//function TBaseBook.GetLocalFilePath: String;
//begin
//  if Self.TextFilePath<>'' then
//  begin
//    Result:=GetApplicationPath+'Books'+PathDelim+IntToStr(Self.GetBookID)+PathDelim+Self.TextFilePath;
//
//  end
//  else
//  begin
//
//    Result:=GetApplicationPath+'Books'+PathDelim+IntToStr(Self.GetBookID)+PathDelim+Self.FilePath;
//
//    {$IFDEF IOS}
//    if Self.IOSFilePath<>'' then
//    begin
//      Result:=GetApplicationPath+'Books'+PathDelim+IntToStr(Self.GetBookID)+PathDelim+Self.IOSFilePath;
//    end;
//    {$ENDIF}
//
//    {$IFDEF ANDROID}
//    if Self.AndroidFilePath<>'' then
//    begin
//      Result:=GetApplicationPath+'Books'+PathDelim+IntToStr(Self.GetBookID)+PathDelim+Self.AndroidFilePath;
//    end;
//    {$ENDIF}
//
//  end;
//
//end;
//
//function TBaseBook.GetUrl: String;
//begin
//  if Self.TextFilePath<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Books/'+IntToStr(Self.GetBookID)+'/'+Self.TextFilePath);
//
//  end
//  else
//  begin
//    //URLEncode
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Books/'+IntToStr(Self.GetBookID)+'/'+Self.FilePath);
//    {$IFDEF IOS}
//    if Self.IOSFilePath<>'' then
//    begin
//      Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Books/'+IntToStr(Self.GetBookID)+'/'+Self.IOSFilePath);
//    end;
//    {$ENDIF}
//
//    {$IFDEF ANDROID}
//    if Self.AndroidFilePath<>'' then
//    begin
//      Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Books/'+IntToStr(Self.GetBookID)+'/'+Self.AndroidFilePath);
//    end;
//    {$ENDIF}
//
//  end;
//end;
//
//{ TBaseBookList }
//
//function TBaseBookList.FindItemByBookID(ABookID: Int64): TBaseBook;
//var
//  I: Integer;
//begin
//  Result:=nil;
//  for I := 0 to Self.Count-1 do
//  begin
//    if Items[I].GetBookID=ABookID then
//    begin
//      Result:=Items[I];
//      Break;
//    end;
//  end;
//end;
//
//function TBaseBookList.GetItem(Index: Integer): TBaseBook;
//begin
//  Result:=TBaseBook(Inherited Items[Index]);
//end;
//
//
//{ TUser }
//
//function TUser.GetHeadPicUrl: String;
//begin
//  if HeadPicPath='' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/UserHead/'+'default.png');
//  end
//  else
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/UserHead/'+Self.HeadPicPath);
//  end;
//end;
//
//function TUser.ParseFromJson(AJson: ISuperObject): Boolean;
//begin
//  FID:=AJson.I['FID'];//1,
//  LoginUser:=AJson.S['LoginUser'];//"18957901025",
//  LoginPass:=AJson.S['LoginPass'];//"123456",
//  Name:=AJson.S['Name'];//"王能",
//  Phone:=AJson.S['Phone'];//"18957901025",
//
//  try
//    CompanyID:=AJson.I['CompanyID'];//1,
//  except
//  end;
//
////  try
////    if VarIsNull(AJson.V['ReadSeconds']) then
////    begin
////      ReadSeconds:=0;
////    end
////    else
////    begin
//      ReadSeconds:=AJson.I['ReadSeconds'];//"",
////    end;
////  except
////  end;
//
//  RegTime:=AJson.S['RegTime'];//"2016-07-14 00:00:00",
//  HeadPicPath:=AJson.S['HeadPicPath'];//""
//  CompanyName:=AJson.S['CompanyName'];//"公安局十七支队",
//end;
//
//
//{ TUserList }
//
//function TUserList.GetItem(Index: Integer): TUser;
//begin
//  Result:=TUser(Inherited Items[Index]);
//end;
//
//{ TUserMind }
//
//function TUserMind.GetUserHeadPicUrl: String;
//begin
//  if UserHeadPicPath<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/UserHead/'+Self.UserHeadPicPath);
//  end
//  else
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/UserHead/'+'default.png');
//  end;
//end;
//
//function TUserMind.ParseFromJson(AJson: ISuperObject): Boolean;
//begin
//  FID:=AJson.I['FID'];//1,
//  UserID:=AJson.I['UserID'];//1,
//  BookID:=AJson.I['BookID'];//1,
//  SelectedContent:=AJson.S['SelectedContent'];//"选取的内容",
//  Mind:=AJson.S['Mind'];//"想法心得",
//  AddTime:=AJson.S['AddTime'];//"2016-07-16 00:00:00",
//  UserName:=AJson.S['UserName'];//"王能",
//  UserHeadPicPath:=AJson.S['UserHeadPicPath'];//"1.png",
//  BookName:=AJson.S['BookName'];//"党政领导干部选拔任用工作条例"
//
//  CompanyName:=AJson.S['CompanyName'];//"支队",
//
//end;
//
//{ TUserMindList }
//
//function TUserMindList.GetItem(Index: Integer): TUserMind;
//begin
//  Result:=TUserMind(Inherited Items[Index]);
//end;
//
//{ TUserSpiritList }
//
//function TUserSpiritList.GetItem(Index: Integer): TUserSpirit;
//begin
//  Result:=TUserSpirit(Inherited Items[Index]);
//end;
//
//{ TUserSpirit }
//
//constructor TUserSpirit.Create;
//begin
//  inherited;
//
//
//  PicList:=TDrawPictureList.Create(ooReference);
//
//  Pic1:=TDrawPicture.Create('','');//"1.jpeg",
//  Pic2:=TDrawPicture.Create('','');//"2.jpeg",
//  Pic3:=TDrawPicture.Create('','');//"3.jpeg",
//  Pic4:=TDrawPicture.Create('','');//"4.jpeg",
//  Pic5:=TDrawPicture.Create('','');//"5.jpeg",
//  Pic6:=TDrawPicture.Create('','');//"",
//  Pic7:=TDrawPicture.Create('','');//"",
//  Pic8:=TDrawPicture.Create('','');//"",
//  Pic9:=TDrawPicture.Create('','');//"",
//
//  PicList.Add(Pic1);
//  PicList.Add(Pic2);
//  PicList.Add(Pic3);
//  PicList.Add(Pic4);
//  PicList.Add(Pic5);
//  PicList.Add(Pic6);
//  PicList.Add(Pic7);
//  PicList.Add(Pic8);
//  PicList.Add(Pic9);
//
//end;
//
//destructor TUserSpirit.Destroy;
//begin
//  uFuncCommon.FreeAndNil(Pic1);
//  uFuncCommon.FreeAndNil(Pic2);
//  uFuncCommon.FreeAndNil(Pic3);
//  uFuncCommon.FreeAndNil(Pic4);
//  uFuncCommon.FreeAndNil(Pic5);
//  uFuncCommon.FreeAndNil(Pic6);
//  uFuncCommon.FreeAndNil(Pic7);
//  uFuncCommon.FreeAndNil(Pic8);
//  uFuncCommon.FreeAndNil(Pic9);
//
//  uFuncCommon.FreeAndNil(PicList);
//
//  inherited;
//end;
//
//function TUserSpirit.GetPic1Url: String;
//begin
//  Result:='';
//  if Pic1Path<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+Pic1Path);
//  end;
//end;
//
//function TUserSpirit.GetPic2Url: String;
//begin
//  Result:='';
//  if Pic2Path<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+Pic2Path);
//  end;
//end;
//
//function TUserSpirit.GetPic3Url: String;
//begin
//  Result:='';
//  if Pic3Path<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+Pic3Path);
//  end;
//end;
//
//function TUserSpirit.GetPic4Url: String;
//begin
//  Result:='';
//  if Pic4Path<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+Pic4Path);
//  end;
//end;
//
//function TUserSpirit.GetPic5Url: String;
//begin
//  Result:='';
//  if Pic5Path<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+Pic5Path);
//  end;
//end;
//
//function TUserSpirit.GetPic6Url: String;
//begin
//  Result:='';
//  if Pic6Path<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+Pic6Path);
//  end;
//end;
//
//function TUserSpirit.GetPic7Url: String;
//begin
//  Result:='';
//  if Pic7Path<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+Pic7Path);
//  end;
//end;
//
//function TUserSpirit.GetPic8Url: String;
//begin
//  Result:='';
//  if Pic8Path<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+Pic8Path);
//  end;
//end;
//
//function TUserSpirit.GetPic9Url: String;
//begin
//  Result:='';
//  if Pic9Path<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+Pic9Path);
//  end;
//end;
//
//function TUserSpirit.GetUserHeadPicUrl: String;
//begin
//  if UserHeadPicPath<>'' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/UserHead/'+Self.UserHeadPicPath);
//  end
//  else
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/UserHead/'+'default.png');
//  end;
//end;
//
//function TUserSpirit.ParseFromJson(AJson: ISuperObject): Boolean;
//begin
//
//  Pic1Width:=0;
//  Pic1Height:=0;
//
//  FID:=AJson.I['FID'];//1,
//  UserID:=AJson.I['UserID'];//1,
//  Spirit:=AJson.S['Spirit'];//"风采",
//  Pic1Path:=AJson.S['Pic1Path'];//"1.jpeg",
//  Pic2Path:=AJson.S['Pic2Path'];//"2.jpeg",
//  Pic3Path:=AJson.S['Pic3Path'];//"3.jpeg",
//  Pic4Path:=AJson.S['Pic4Path'];//"4.jpeg",
//  Pic5Path:=AJson.S['Pic5Path'];//"5.jpeg",
//  Pic6Path:=AJson.S['Pic6Path'];//"",
//  Pic7Path:=AJson.S['Pic7Path'];//"",
//  Pic8Path:=AJson.S['Pic8Path'];//"",
//  Pic9Path:=AJson.S['Pic9Path'];//"",
//
//
//  AddTime:=AJson.S['AddTime'];//"2016-07-16 00:00:00",
//  UserName:=AJson.S['UserName'];//"王能",
//  UserHeadPicPath:=AJson.S['UserHeadPicPath'];//"1.png"
//
//  CompanyName:=AJson.S['CompanyName'];//"支队",
//
//
//
//  Pic1Width:=AJson.I['Pic1Width'];//"1.png"
//  Pic1Height:=AJson.I['Pic1Height'];//"1.png"
//
//
//  Pic1.Url:=Self.GetPic1Url;//"1.jpeg",
//  Pic2.Url:=Self.GetPic2Url;//"2.jpeg",
//  Pic3.Url:=Self.GetPic3Url;//"3.jpeg",
//  Pic4.Url:=Self.GetPic4Url;//"4.jpeg",
//  Pic5.Url:=Self.GetPic5Url;//"5.jpeg",
//  Pic6.Url:=Self.GetPic6Url;//"",
//  Pic7.Url:=Self.GetPic7Url;//"",
//  Pic8.Url:=Self.GetPic8Url;//"",
//  Pic9.Url:=Self.GetPic9Url;//"",
//
//end;
//
//{ TFriendList }
//
//function TFriendList.GetItem(Index: Integer): TFriend;
//begin
//  Result:=TFriend(Inherited Items[Index]);
//end;
//
//{ TFriend }
//
//function TFriend.GetHeadPicUrl: String;
//begin
//  if HeadPicPath='' then
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/UserHead/'+'default.png');
//  end
//  else
//  begin
//    Result:=TIdURI.URLEncode(ServerUrl+'/Upload/UserHead/'+Self.HeadPicPath);
//  end;
//end;
//
//function TFriend.ParseFromJson(AJson: ISuperObject): Boolean;
//begin
//  UserID:=AJson.I['UserID'];//4,
//  Name:=AJson.S['Name'];//"王能",
//  Phone:=AJson.S['Phone'];//"18957901025",
//  ReadSeconds:=AJson.I['ReadSeconds'];//300,
//  HeadPicPath:=AJson.S['HeadPicPath'];//""
//end;
//
//{ TBook }
//
//function TBook.GetBookID: Int64;
//begin
//  Result:=FID;
//end;
//
//function TBook.ParseFromJson(AJson: ISuperObject): Boolean;
//begin
//  Inherited;
//
//  FID:=AJson.I['FID'];//1,
//
//end;



initialization
  GlobalManager:=TManager.Create;


finalization
  uFuncCommon.FreeAndNil(GlobalManager);



end.
