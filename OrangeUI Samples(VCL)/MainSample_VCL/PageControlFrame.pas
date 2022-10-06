unit PageControlFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDrawCanvas, uSkinItems,
  Vcl.StdCtrls, uSkinWindowsMemo, uSkinLabelType, uSkinImageType,
  EasyServiceCommonMaterialDataMoudle_VCL,
  uSkinListViewType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinButtonType, uSkinWindowsEdit,
  uSkinPanelType, uSkinPageControlType, uSkinWindowsControl, uSkinEditType,
  uSkinMaterial, uDrawPicture, uSkinImageList;

type
  TFramePageControl = class(TFrame)
    pcLeftAlign: TSkinWinPageControl;
    tsMailList: TSkinTabSheet;
    tsQuickReply: TSkinTabSheet;
    tsTask: TSkinTabSheet;
    pcLeftMargin2: TSkinWinPageControl;
    SkinTabSheet1: TSkinTabSheet;
    SkinTabSheet3: TSkinTabSheet;
    SkinTabSheet4: TSkinTabSheet;
    pcMain_Material: TSkinWinPageControl;
    SkinTabSheet5: TSkinTabSheet;
    SkinTabSheet7: TSkinTabSheet;
    SkinTabSheet8: TSkinTabSheet;
    pcMainFramePageControlMaterial: TSkinWinPageControl;
    SkinTabSheet9: TSkinTabSheet;
    SkinTabSheet11: TSkinTabSheet;
    SkinTabSheet12: TSkinTabSheet;
    pcOrder_Material: TSkinWinPageControl;
    SkinTabSheet14: TSkinTabSheet;
    SkinTabSheet15: TSkinTabSheet;
    SkinTabSheet16: TSkinTabSheet;
    imgShopHomeList: TSkinImageList;
    imgHomeIcons: TSkinImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
