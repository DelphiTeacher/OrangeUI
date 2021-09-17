//convert pas to utf8 by ¥
unit ListItemStyleFrame_Page;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  Forms,

//  EasyServiceCommonMaterialDataMoudle,
  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,
  uPageStructure,

  uSkinItemDesignerPanelType;


type
  TFrameListItemStyle_Page = class(TFrame,IFrameBaseListItemStyle,IFrameBaseListItemStyle_Init)
  private
    FPage:TPage;
    FPageInstance:TPageInstance;
    ItemDesignerPanel:TSkinItemDesignerPanel;
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    procedure Init(AListItemStyleReg:TListItemStyleReg);
    { Public declarations }
  end;


implementation

{$R *.dfm}



{ TFrameListItemStyleFrame_Page }

constructor TFrameListItemStyle_Page.Create(AOwner: TComponent);
begin
  inherited;



  //找到Page,创建控件

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  //ItemDesignerPanel.Align:=TAlignLayout.None;
end;

destructor TFrameListItemStyle_Page.Destroy;
begin
  FreeAndNil(FPageInstance);
  inherited;
end;

function TFrameListItemStyle_Page.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameListItemStyle_Page.Init(AListItemStyleReg: TListItemStyleReg);
var
  AError:String;
begin
  if (AListItemStyleReg.DataObject<>nil) and (AListItemStyleReg.DataObject is TPage) then
  begin
    //将Page中的控件创建在ItemDesignerPanel上面
    FPage:=TPage(AListItemStyleReg.DataObject);
    FPageInstance:=TPageInstance.Create();
    FPageInstance.PageStructure:=FPage;
    if not FPageInstance.CreateControls(Self,
                                       Self,
                                       '',
                                       '',
                                       False,
                                       AError
                                       ) then
    begin
      Exit;
    end;

    ItemDesignerPanel:=TSkinItemDesignerPanel(FPageInstance.MainControlMapList.Items[0].Component);
  end;
end;

//initialization
//  RegisterListItemStyle('Page',TFrameListItemStyle_Page);
//
//finalization
//  UnRegisterListItemStyle(TFrameListItemStyle_Page);

end.
