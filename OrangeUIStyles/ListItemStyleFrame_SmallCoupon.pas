//convert pas to utf8 by ¥
unit ListItemStyleFrame_SmallCoupon;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uGraphicCommon,
  uSkinItems,
  uSkinBufferBitmap,
  uSkinCustomListType,
  BaseListItemStyleFrame,

  ListItemStyleFrame_Base, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinButtonType, uSkinFireMonkeyButton;

type
  TFrameSmallCouponListItemStyle = class(TFrameBaseListItemStyleBase)
    lblCouponMoney1: TSkinFMXLabel;
    lblCouponDetail1: TSkinFMXLabel;
    btnTakeCoupon: TSkinFMXButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}


initialization
  RegisterListItemStyle('SmallCoupon',TFrameSmallCouponListItemStyle);


finalization
  UnRegisterListItemStyle(TFrameSmallCouponListItemStyle);


end.
