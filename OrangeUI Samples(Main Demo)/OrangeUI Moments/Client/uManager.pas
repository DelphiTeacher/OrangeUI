//convert pas to utf8 by ¥

unit uManager;

interface

uses
  Classes,
  SysUtils,
  IniFiles,
  Types,
  UITypes,
  FMX.Forms,
  FMX.Graphics,
  uDrawTextParam,

  Variants,
  IdURI,
  uDrawPicture,
  uSkinMultiColorLabelType,

//  uThumbCommon,
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
    function ParseFromJsonArray(JsonObjectClass:TBaseJsonObjectClass;JsonArray:ISuperArray):Boolean;virtual;
  end;


  TUser=class(TBaseJsonObject)
  public
    FID:Int64;//1,
    LoginUser:String;//"18957901025",
    LoginPass:String;//"123456",
    Name:String;//"王能",
    Phone:String;//"18957901025",
    RegTime:String;//"2016-07-14 00:00:00",
    HeadPicPath:String;//""
    CompanyName:String;//"部门",


    Sex:Boolean;//"�Ա�"
    Sign:String;//"ǩ��"
   
  public
    function GetHeadPicUrl: String;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;



  TSpiritLike=class(TBaseJsonObject)
  public
    UserID:Integer;
    UserName:String;
  public
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TSpiritLikeList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TSpiritLike;
  public
    function FindByUserID(AUserID:Integer):TSpiritLike;
    property Items[Index:Integer]:TSpiritLike read GetItem;default;
  end;




  TSpiritComment=class(TBaseJsonObject)
  public
    UserID:Integer;
    UserName:String;
    Comment:String;
    ReplyUserID:Integer;
    ReplyUserName:String;
  public
    DrawColorTextCollection:TColorTextCollection;
    constructor Create;override;
    destructor Destroy;override;
    procedure SyncDrawColorTextCollection;
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TSpiritCommentList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TSpiritComment;
  public
    property Items[Index:Integer]:TSpiritComment read GetItem;default;
  end;


  TUserSpirit=class(TBaseJsonObject)
  public
    FID:Int64;//1,

    UserID:Int64;//1,


    Spirit:String;//"朋友圈",

    Pic1Width:Integer;
    Pic1Height:Integer;


    Pic1Path:String;//"1.jpeg",
    Pic2Path:String;//"2.jpeg",
    Pic3Path:String;//"3.jpeg",
    Pic4Path:String;//"4.jpeg",
    Pic5Path:String;//"5.jpeg",
    Pic6Path:String;//"",
    Pic7Path:String;//"",
    Pic8Path:String;//"",
    Pic9Path:String;//"",

    Latitude:Double;//"经度"
    Longitude:Double;//"纬度"
    Addr:String;//"所在位置"
    PhoneType:String;//"手机型号"
    AddTime:String;//"2016-07-16 00:00:00",

    UserName:String;//"王能",
    UserHeadPicPath:String;//"1.png"

    CompanyName:String;//"部门",

    //评论数
    CommentCount:Integer;
    //点赞数
    LikeCount:Integer;

    LikeList:TSpiritLikeList;
    CommentList:TSpiritCommentList;



  public
    function GetUserHeadPicUrl:String;
  public
    Pic1:TDrawPicture;//"1.jpeg",
    Pic2:TDrawPicture;//"2.jpeg",
    Pic3:TDrawPicture;//"3.jpeg",
    Pic4:TDrawPicture;//"4.jpeg",
    Pic5:TDrawPicture;//"5.jpeg",
    Pic6:TDrawPicture;//"",
    Pic7:TDrawPicture;//"",
    Pic8:TDrawPicture;//"",
    Pic9:TDrawPicture;//"",

    PicList:TDrawPictureList;
    OriginPicUrlList:TStringList;

    function GetPic1Url(const AIsThumb:Boolean):String;
    function GetPic2Url(const AIsThumb:Boolean):String;
    function GetPic3Url(const AIsThumb:Boolean):String;
    function GetPic4Url(const AIsThumb:Boolean):String;
    function GetPic5Url(const AIsThumb:Boolean):String;
    function GetPic6Url(const AIsThumb:Boolean):String;
    function GetPic7Url(const AIsThumb:Boolean):String;
    function GetPic8Url(const AIsThumb:Boolean):String;
    function GetPic9Url(const AIsThumb:Boolean):String;


    constructor Create;override;
    destructor Destroy;override;
  public
    LikesDrawColorTextCollection:TColorTextCollection;
    procedure SyncLikesDrawColorTextCollection;
    function ParseFromJson(AJson: ISuperObject): Boolean;override;
  end;
  TUserSpiritList=class(TBaseJsonObjectList)
  private
    function GetItem(Index: Integer): TUserSpirit;
  public
    property Items[Index:Integer]:TUserSpirit read GetItem;default;
  end;




  TManager=class
  public

    //用户名
    LastLoginUser:String;
    //密码
    LastLoginPass:String;


    LoginKey:String;

    //用户信息
    User:TUser;

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
  //图片下载url
  ImageHttpServerUrl:String;
  GlobalManager:TManager;

function GetUserSpiritPicUrl(AUserSpiritFID:Integer;APicPath:String;const AIsThumb:Boolean):String;

implementation

function GetUserSpiritPicUrl(AUserSpiritFID:Integer;APicPath:String;const AIsThumb:Boolean):String;
begin
  Result:='';
  if APicPath<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(AUserSpiritFID)+'/'+GetThumbFilePrefix(AIsThumb)+APicPath);
  end;
end;


{ TManager }

constructor TManager.Create;
begin
  User:=TUser.Create;

end;

destructor TManager.Destroy;
begin
  uFuncCommon.FreeAndNil(User);
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

  Self.LastLoginUser:=AIniFile.ReadString('','LastLoginUser','');
  Self.LastLoginPass:=AIniFile.ReadString('','LastLoginPass','');


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

  AIniFile.WriteString('','LastLoginUser',Self.LastLoginUser);
  AIniFile.WriteString('','LastLoginPass',Self.LastLoginPass);

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


{ TUser }

function TUser.GetHeadPicUrl: String;
begin
  if HeadPicPath='' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/UserHead/'+'default.png');
  end
  else
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/UserHead/'+Self.HeadPicPath);
  end;
end;


function TUser.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  FID:=AJson.I['FID'];//1,
  LoginUser:=AJson.S['LoginUser'];//"18957901025",
  LoginPass:=AJson.S['LoginPass'];//"123456",
  Name:=AJson.S['Name'];//"王能",
  Phone:=AJson.S['Phone'];//"18957901025",
 
  Sex:=AJson.B['Sex']; //"�Ա�"
  Sign:=AJson.S['Sign'];//"ǩ��"


//  CompanyID:=AJson.I['CompanyID'];//1,

//  Latitude:=AJson.F['Latitude'];
//  Longitude:=AJson.F['Longitude'];
//  Addr:=AJson.S['Addr'];
//  PhoneType:=AJson.S['PhoneType'];


  RegTime:=AJson.S['RegTime'];//"2016-07-14 00:00:00",
  HeadPicPath:=AJson.S['HeadPicPath'];//""
  CompanyName:=AJson.S['CompanyName'];//"部门",
end;


{ TUserSpiritList }

function TUserSpiritList.GetItem(Index: Integer): TUserSpirit;
begin
  Result:=TUserSpirit(Inherited Items[Index]);
end;

{ TUserSpirit }

constructor TUserSpirit.Create;
begin
  inherited;

  LikeList:=TSpiritLikeList.Create();
  CommentList:=TSpiritCommentList.Create();

  PicList:=TDrawPictureList.Create(ooReference);
  OriginPicUrlList:=TStringList.Create;

  Pic1:=TDrawPicture.Create('','');//"1.jpeg",
  Pic2:=TDrawPicture.Create('','');//"2.jpeg",
  Pic3:=TDrawPicture.Create('','');//"3.jpeg",
  Pic4:=TDrawPicture.Create('','');//"4.jpeg",
  Pic5:=TDrawPicture.Create('','');//"5.jpeg",
  Pic6:=TDrawPicture.Create('','');//"",
  Pic7:=TDrawPicture.Create('','');//"",
  Pic8:=TDrawPicture.Create('','');//"",
  Pic9:=TDrawPicture.Create('','');//"",

  PicList.Add(Pic1);
  PicList.Add(Pic2);
  PicList.Add(Pic3);
  PicList.Add(Pic4);
  PicList.Add(Pic5);
  PicList.Add(Pic6);
  PicList.Add(Pic7);
  PicList.Add(Pic8);
  PicList.Add(Pic9);

  LikesDrawColorTextCollection:=TColorTextCollection.Create;
  LikesDrawColorTextCollection.Add;
  LikesDrawColorTextCollection.Add;
  LikesDrawColorTextCollection.Add;
  LikesDrawColorTextCollection[0].DrawFont.Color:=TAlphaColorRec.Cornflowerblue;
  LikesDrawColorTextCollection[1].DrawFont.Color:=TAlphaColorRec.Cornflowerblue;
  LikesDrawColorTextCollection[2].DrawFont.Color:=TAlphaColorRec.Cornflowerblue;
end;

destructor TUserSpirit.Destroy;
begin
  uFuncCommon.FreeAndNil(Pic1);
  uFuncCommon.FreeAndNil(Pic2);
  uFuncCommon.FreeAndNil(Pic3);
  uFuncCommon.FreeAndNil(Pic4);
  uFuncCommon.FreeAndNil(Pic5);
  uFuncCommon.FreeAndNil(Pic6);
  uFuncCommon.FreeAndNil(Pic7);
  uFuncCommon.FreeAndNil(Pic8);
  uFuncCommon.FreeAndNil(Pic9);

  uFuncCommon.FreeAndNil(PicList);
  uFuncCommon.FreeAndNil(OriginPicUrlList);

  uFuncCommon.FreeAndNil(LikeList);
  uFuncCommon.FreeAndNil(CommentList);

  FreeAndNil(LikesDrawColorTextCollection);
  inherited;
end;



function TUserSpirit.GetPic1Url(const AIsThumb:Boolean): String;
begin
  Result:='';
  if Pic1Path<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+GetThumbFilePrefix(AIsThumb)+Pic1Path);
  end;
end;

function TUserSpirit.GetPic2Url(const AIsThumb:Boolean): String;
begin
  Result:='';
  if Pic2Path<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+GetThumbFilePrefix(AIsThumb)+Pic2Path);
  end;
end;

function TUserSpirit.GetPic3Url(const AIsThumb:Boolean): String;
begin
  Result:='';
  if Pic3Path<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+GetThumbFilePrefix(AIsThumb)+Pic3Path);
  end;
end;

function TUserSpirit.GetPic4Url(const AIsThumb:Boolean): String;
begin
  Result:='';
  if Pic4Path<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+GetThumbFilePrefix(AIsThumb)+Pic4Path);
  end;
end;

function TUserSpirit.GetPic5Url(const AIsThumb:Boolean): String;
begin
  Result:='';
  if Pic5Path<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+GetThumbFilePrefix(AIsThumb)+Pic5Path);
  end;
end;

function TUserSpirit.GetPic6Url(const AIsThumb:Boolean): String;
begin
  Result:='';
  if Pic6Path<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+GetThumbFilePrefix(AIsThumb)+Pic6Path);
  end;
end;

function TUserSpirit.GetPic7Url(const AIsThumb:Boolean): String;
begin
  Result:='';
  if Pic7Path<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+GetThumbFilePrefix(AIsThumb)+Pic7Path);
  end;
end;

function TUserSpirit.GetPic8Url(const AIsThumb:Boolean): String;
begin
  Result:='';
  if Pic8Path<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+GetThumbFilePrefix(AIsThumb)+Pic8Path);
  end;
end;

function TUserSpirit.GetPic9Url(const AIsThumb:Boolean): String;
begin
  Result:='';
  if Pic9Path<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/Spirit/'+IntToStr(Self.FID)+'/'+GetThumbFilePrefix(AIsThumb)+Pic9Path);
  end;
end;

function TUserSpirit.GetUserHeadPicUrl: String;
begin
  if UserHeadPicPath<>'' then
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/UserHead/'+Self.UserHeadPicPath);
  end
  else
  begin
    Result:=TIdURI.URLEncode(ImageHttpServerUrl+'/Upload/UserHead/'+'default.png');
  end;
end;

function TUserSpirit.ParseFromJson(AJson: ISuperObject): Boolean;
begin

  Pic1Width:=0;
  Pic1Height:=0;

  FID:=AJson.I['FID'];//1,
  UserID:=AJson.I['UserID'];//1,
  Spirit:=AJson.S['Spirit'];//"朋友圈",
  Pic1Path:=AJson.S['Pic1Path'];//"1.jpeg",
  Pic2Path:=AJson.S['Pic2Path'];//"2.jpeg",
  Pic3Path:=AJson.S['Pic3Path'];//"3.jpeg",
  Pic4Path:=AJson.S['Pic4Path'];//"4.jpeg",
  Pic5Path:=AJson.S['Pic5Path'];//"5.jpeg",
  Pic6Path:=AJson.S['Pic6Path'];//"",
  Pic7Path:=AJson.S['Pic7Path'];//"",
  Pic8Path:=AJson.S['Pic8Path'];//"",
  Pic9Path:=AJson.S['Pic9Path'];//"",

//  Latitude:=AJson.F['Latitude'];
//  Longitude:=AJson.F['Longitude'];
  Addr:=AJson.S['Addr'];
  PhoneType:=AJson.S['PhoneType'];

  AddTime:=AJson.S['AddTime'];//"2016-07-16 00:00:00",
  UserName:=AJson.S['UserName'];//"王能",
  UserHeadPicPath:=AJson.S['UserHeadPicPath'];//"1.png"


  CompanyName:=AJson.S['CompanyName'];//"部门",

  CommentCount:=AJson.I['CommentCount'];
  LikeCount:=AJson.I['LikeCount'];

  Self.LikeList.ParseFromJsonArray(TSpiritLike,AJson.O['Like'].A['LikeList']);

  Self.CommentList.ParseFromJsonArray(TSpiritComment,AJson.O['Comment'].A['CommentList']);

  Pic1Width:=AJson.I['Pic1Width'];//"1.png"
  Pic1Height:=AJson.I['Pic1Height'];//"1.png"


  Pic1.Url:=Self.GetPic1Url(True);//"1.jpeg",
  Pic2.Url:=Self.GetPic2Url(True);//"2.jpeg",
  Pic3.Url:=Self.GetPic3Url(True);//"3.jpeg",
  Pic4.Url:=Self.GetPic4Url(True);//"4.jpeg",
  Pic5.Url:=Self.GetPic5Url(True);//"5.jpeg",
  Pic6.Url:=Self.GetPic6Url(True);//"",
  Pic7.Url:=Self.GetPic7Url(True);//"",
  Pic8.Url:=Self.GetPic8Url(True);//"",
  Pic9.Url:=Self.GetPic9Url(True);//"",

  OriginPicUrlList.Clear;
  OriginPicUrlList.Add(Self.GetPic1Url(False));
  OriginPicUrlList.Add(Self.GetPic2Url(False));
  OriginPicUrlList.Add(Self.GetPic3Url(False));
  OriginPicUrlList.Add(Self.GetPic4Url(False));
  OriginPicUrlList.Add(Self.GetPic5Url(False));
  OriginPicUrlList.Add(Self.GetPic6Url(False));
  OriginPicUrlList.Add(Self.GetPic7Url(False));
  OriginPicUrlList.Add(Self.GetPic8Url(False));
  OriginPicUrlList.Add(Self.GetPic9Url(False));


  SyncLikesDrawColorTextCollection;
end;




procedure TUserSpirit.SyncLikesDrawColorTextCollection;
var
  I:Integer;
begin
  //3个
  for I := 0 to Self.LikesDrawColorTextCollection.Count-1 do
  begin
    if I<Self.LikeList.Count then
    begin
      //不能超出固定设置好的数目
      LikesDrawColorTextCollection[I].Text:=LikeList[I].UserName+' ';
    end
    else
    begin
      //超出了,清空
      LikesDrawColorTextCollection[I].Text:='';
    end;
  end;

end;

{ TSpiritLikeList }


function TSpiritLikeList.FindByUserID(AUserID: Integer): TSpiritLike;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if Self.Items[I].UserID=GlobalManager.User.FID then
    begin
      Result:=Self.Items[I];
    end;
  end;
end;

function TSpiritLikeList.GetItem(Index: Integer): TSpiritLike;
begin
  Result:=TSpiritLike(Inherited Items[Index]);
end;


{ TSpiritLike }

function TSpiritLike.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  UserID:=AJson.I['UserID'];//4,
  UserName:=AJson.S['UserName'];//"王能",

end;



{ TSpiritCommentList }

function TSpiritCommentList.GetItem(Index: Integer): TSpiritComment;
begin
  Result:=TSpiritComment(Inherited Items[Index]);
end;

{ TSpiritComment }

constructor TSpiritComment.Create;
begin
  inherited;
  DrawColorTextCollection:=TColorTextCollection.Create;
  DrawColorTextCollection.Add;
  DrawColorTextCollection.Add;
  DrawColorTextCollection.Add;
  DrawColorTextCollection.Add;
  DrawColorTextCollection[0].DrawFont.Color:=TAlphaColorRec.Cornflowerblue;
  DrawColorTextCollection[2].DrawFont.Color:=TAlphaColorRec.Cornflowerblue;
end;

destructor TSpiritComment.Destroy;
begin
  FreeAndNil(DrawColorTextCollection);
  inherited;
end;

function TSpiritComment.ParseFromJson(AJson: ISuperObject): Boolean;
begin
  UserID:=AJson.I['UserID'];//4,
  UserName:=AJson.S['UserName'];//"王能",
  Comment:=AJson.S['Comment'];
  ReplyUserID:=AJson.I['ReplyUserID'];//1,
  ReplyUserName:=AJson.S['ReplyUserName'];//"DelphiTeacher",

  SyncDrawColorTextCollection;
end;


procedure TSpiritComment.SyncDrawColorTextCollection;
begin
  DrawColorTextCollection.Items[0].Text:=UserName;
  DrawColorTextCollection.Items[0].Name:=IntToStr(UserID);
  if Self.ReplyUserID=0 then
  begin
    DrawColorTextCollection.Items[1].Text:='';
    DrawColorTextCollection.Items[2].Text:='';
  end
  else
  begin
    DrawColorTextCollection.Items[1].Text:='回复';
    DrawColorTextCollection.Items[2].Name:=IntToStr(ReplyUserID);
    DrawColorTextCollection.Items[2].Text:=ReplyUserName;
  end;
  DrawColorTextCollection.Items[3].Text:=': '+Comment;
end;




initialization
  GlobalManager:=TManager.Create;


finalization
  uFuncCommon.FreeAndNil(GlobalManager);



end.
