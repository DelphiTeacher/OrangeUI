//------------------------------------------------------------------
//
//                 OrangeUI Source Files
//
//  Module: OrangeUIControl
//  Unit: uSkinFormType
//  Description: ����
//
//  Copyright: delphiteacher
//  CodeBy: delphiteacher
//  Email: ggggcexx@163.com
//  Writing: 2012-2014
//
//------------------------------------------------------------------

//Ƥ������
unit uSkinFormType;

interface
{$I FrameWork.inc}


uses
  SysUtils,
  uFuncCommon,
  Classes,
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Graphics,
  {$ENDIF}
  {$IFDEF VCL}
  Windows,
  Messages,
  Graphics,
  Controls,
  Menus,
  Dialogs,
  ExtCtrls,
  Forms,
  {$ENDIF}
  Types,
  uVersion,
  uSkinPublic,
  uGraphicCommon,
  uBaseLog,
  uBaseList,
  uComponentType,
  uDrawEngine,
  uDrawCanvas,
  uSkinBufferBitmap,
  uDrawPicture,
//  uSkinPackage,
  uDrawParam,
  uSkinRegManager,
  uSkinMaterial,
  uBinaryTreeDoc,
  uDrawPictureParam,
  uDrawRectParam,
  uDrawLineParam,
  uDrawTextParam;

const
  IID_ISkinForm:TGUID='{F27B7AD0-BE90-49F1-AD00-574EB6CC2A6A}';

type

  TSkinControlList=class(TBaseList)
  private
    function GetItem(Index: Integer): TChildControl;
  public
    property Items[Index:Integer]:TChildControl read GetItem;default;
  end;





  ISkinForm=interface//(ISkinControl)
  ['{F27B7AD0-BE90-49F1-AD00-574EB6CC2A6A}']
    {$I Source\Controls\Windows\ISkinForm_Declare.inc}

    //����
    property Caption:String read GetCaption write SetCaption;
  end;













//  {$Region '��������'}
  //Form����
  TFormProperties=class(TSkinControlProperties)
  private
    FSkinFormIntf:ISkinForm;
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //��ȡ��������
    function GetComponentClassify:String;override;
  end;
//  {$EndRegion}













//  {$Region '���������'}
  //�����زĻ���
  TSkinFormMaterial=class(TSkinControlMaterial)
  private
    FSysBtnWidth: Integer;
    FSysBtnHeight: Integer;
    procedure SetFormRoundHeight(const Value: Integer);
    procedure SetFormRoundWidth(const Value: Integer);
    procedure SetIsRoundForm(const Value: Boolean);
    procedure SetSysBtnWidth(const Value: Integer);
    procedure SetSysBtnHeight(const Value: Integer);
  protected
    //�Ƿ���Բ�δ���
    FIsRoundForm: Boolean;

    //Բ�Ǵ���Ƕȳߴ�
    FFormRoundWidth: Integer;
    FFormRoundHeight: Integer;

    //����ϵͳ��ť����
    FAlignSysBtnTopMargin: Integer;
    FAlignSysBtnRightMargin: Integer;
    FAlignSysBtnSpace: Integer;


    //�����Զ�ϵͳ��ť����
    FEnableAutoAlignSysBtn:Boolean;


    procedure SetAlignSysBtnRightMargin(const Value: Integer);
    procedure SetAlignSysBtnSpace(const Value: Integer);
    procedure SetAlignSysBtnTopMargin(const Value: Integer);
    procedure SetEnableAutoAlignSysBtn(const Value: Boolean);
//  protected
//    //���ĵ��ڵ��м���
//    function CustomLoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //���浽�ĵ��ڵ�
//    function CustomSaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

  published

    //�Ƿ�Բ�Ǵ���
    property IsRoundForm:Boolean read FIsRoundForm write SetIsRoundForm;
    //����Բ�ǿ��
    property FormRoundWidth:Integer read FFormRoundWidth write SetFormRoundWidth;
    //����Բ�Ǹ߶�
    property FormRoundHeight:Integer read FFormRoundHeight write SetFormRoundHeight;


    //ϵͳ��ť�����ұ߾�
    property AlignSysBtnRightMargin:Integer read FAlignSysBtnRightMargin write SetAlignSysBtnRightMargin;
    //ϵͳ��ť�����ϱ߾�
    property AlignSysBtnTopMargin:Integer read FAlignSysBtnTopMargin write SetAlignSysBtnTopMargin;
    //ϵͳ��ť���м��
    property AlignSysBtnSpace:Integer read FAlignSysBtnSpace write SetAlignSysBtnSpace;
    //�����Զ�ϵͳ��ť����
    property EnableAutoAlignSysBtn:Boolean read FEnableAutoAlignSysBtn write SetEnableAutoAlignSysBtn;
    //ϵͳ��ť�����ұ߾�
    property SysBtnWidth:Integer read FSysBtnWidth write SetSysBtnWidth;
    property SysBtnHeight:Integer read FSysBtnHeight write SetSysBtnHeight;
  end;

  //���������
  TSkinBaseFormType=class(TSkinControlType)
  protected
    //Ƥ������ӿ�
    FSkinFormIntf:ISkinForm;
    //�Ƿ�������С��״̬
    FIsProcessIconicState: Boolean;

    //�Զ�����Ʒ���
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;

    //�󶨶���
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //�����
    procedure CustomUnBind;override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //�ڴ���ı��С֮ǰ�ػ�
    procedure InvalidateBeforeFormSize;virtual;
    //�ڴ���ı��С֮���ػ�
    procedure InvalidateAfterFormSize;virtual;
    //�ڴ���ı佹�����ػ�
    procedure InvalidateInFormNCMessage;virtual;




    //�Զ�����Ʒǿͻ���
    procedure PaintNotClient(ACanvas:TDrawCanvas);virtual;
    //���ƿͻ���
    procedure PaintClient(ACanvas:TDrawCanvas);virtual;


    //�������
    procedure EraseBackGnd(ACanvas:TDrawCanvas);virtual;


    //��С��ʱ����
    procedure IconicPaintNotClient(ACanvas:TDrawCanvas);virtual;
    procedure IconicPaintClient(ACanvas:TDrawCanvas);virtual;
    procedure IconicEraseBackGnd(ACanvas:TDrawCanvas);virtual;

    function GetCustomCaptionBarNCHeight:Integer;virtual;

    //��ȡ�Զ���߾�
    function GetCustomBorderLeftWidth:Integer;virtual;
    function GetCustomCaptionBarHeight:Integer;virtual;
    function GetCustomBorderRightWidth:Integer;virtual;
    function GetCustomBorderBottomHeight:Integer;virtual;



    //�Ƿ�������С��״̬//WMNCHitTest,WMNCPaint,WMNCUAHDrawCaption,WMSYNCPaint,WMEraseBackGnd
    property IsProcessIconicState:Boolean read FIsProcessIconicState write FIsProcessIconicState;
  end;












  //�������(�б߿��б���������ͼ��)
  TSkinFormBaseNormalMaterial=class(TSkinFormMaterial)
  protected
    FBorderRightWidth: Integer;
    FCaptionBarHeight: Integer;

    FBorderLeftWidth: Integer;
    FBorderBottomHeight: Integer;
//  protected
//    //���ĵ��ڵ��м���
//    function CustomLoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //���浽�ĵ��ڵ�
//    function CustomSaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //��߿���
    property BorderLeftWidth:Integer read FBorderLeftWidth write FBorderLeftWidth;
    //�������߶�
    property CaptionBarHeight:Integer read FCaptionBarHeight write FCaptionBarHeight;
    //�ұ߿���
    property BorderRightWidth:Integer read FBorderRightWidth write FBorderRightWidth;
    //�ױ߿�߶�
    property BorderBottomHeight:Integer read FBorderBottomHeight write FBorderBottomHeight;
  end;

  TSkinFormBaseNormalType=class(TSkinBaseFormType)
  private
    function GetSkinMaterial:TSkinFormBaseNormalMaterial;
  protected
    //��ȡ�Զ���߾�
    function GetCustomBorderLeftWidth:Integer;override;
    function GetCustomCaptionBarHeight:Integer;override;
    function GetCustomBorderRightWidth:Integer;override;
    function GetCustomBorderBottomHeight:Integer;override;

    //�������
    procedure EraseBackGnd(ACanvas:TDrawCanvas);override;
  end;















  //�������(�б߿��б���������ͼ��)
  TSkinFormNormalMaterial=class(TSkinFormBaseNormalMaterial)
  protected

    FDrawClientRectParam:TDrawRectParam;
    FDrawBorderRectParam:TDrawRectParam;
    FDrawCaptionBarRectParam:TDrawRectParam;

    procedure SetDrawBorderRectParam(const Value: TDrawRectParam);
    procedure SetDrawCaptionBarRectParam(const Value: TDrawRectParam);
    procedure SetDrawClientRectParam(const Value: TDrawRectParam);

//  protected
//    //���ĵ��ڵ��м���
//    function CustomLoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //���浽�ĵ��ڵ�
//    function CustomSaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published


    //�ͻ���
    property DrawClientRectParam:TDrawRectParam read FDrawClientRectParam write SetDrawClientRectParam;
    //�߿�
    property DrawBorderRectParam:TDrawRectParam read FDrawBorderRectParam write SetDrawBorderRectParam;
    //������
    property DrawCaptionBarRectParam:TDrawRectParam read FDrawCaptionBarRectParam write SetDrawCaptionBarRectParam;

  end;


  TSkinFormNormalType=class(TSkinFormBaseNormalType)
  private
    function GetSkinMaterial:TSkinFormNormalMaterial;
  protected
    //�ڴ���ı��С���ػ�
    procedure InvalidateBeforeFormSize;override;
    procedure InvalidateAfterFormSize;override;
    //�ڴ���ı佹�����ػ�
    procedure InvalidateInFormNCMessage;override;
    //���Ʒǿͻ���
    procedure PaintNotClient(ACanvas:TDrawCanvas);override;
    //���ƿͻ���
    procedure PaintClient(ACanvas:TDrawCanvas);override;
  end;












  //�ޱ߿���(�������嶼�ǿͻ���)
  TSkinFormBaseFullClientMaterial=class(TSkinFormMaterial)
  end;
  TSkinFormBaseFullClientType=class(TSkinBaseFormType)
  protected
    //�������
    procedure EraseBackGnd(ACanvas:TDrawCanvas);override;
    //�ڴ���ı��С���ػ�
    procedure InvalidateBeforeFormSize;override;
    procedure InvalidateAfterFormSize;override;
    //�ڴ���ı佹�����ػ�
    procedure InvalidateInFormNCMessage;override;
  end;


















  //Ĭ�Ϸ��,�ͻ���ռ����������,�б���ͼƬ,��ǰ��ͼƬ
  TSkinFormDefaultMaterial=class(TSkinFormBaseFullClientMaterial)
  private
    FBackGndDrawPicture: TDrawPicture;
    FBackGndDrawPictureParam:TDrawPictureParam;
//    FForeGndDrawPicture: TDrawPicture;
//    FForeGndDrawPictureParam:TDrawPictureParam;
//    procedure SetForeGndDrawPicture(const Value: TDrawPicture);
//    procedure SetForeGndDrawPictureParam(const Value: TDrawPictureParam);
    procedure SetBackGndDrawPicture(const Value: TDrawPicture);
    procedure SetBackGndDrawPictureParam(const Value: TDrawPictureParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //����ͼƬ
    property BackGndDrawPicture:TDrawPicture read FBackGndDrawPicture write SetBackGndDrawPicture;
    //����ͼƬ���Ʋ���
    property BackGndDrawPictureParam:TDrawPictureParam read FBackGndDrawPictureParam write SetBackGndDrawPictureParam;
  end;

  //ͼƬ������
  TSkinFormDefaultType=class(TSkinFormBaseFullClientType)
  private
    function GetSkinMaterial:TSkinFormDefaultMaterial;
  protected
    //���ƿͻ���
    procedure PaintClient(ACanvas:TDrawCanvas);override;
  end;







implementation





{ TSkinControlList }

function TSkinControlList.GetItem(Index: Integer): TChildControl;
begin
  Result:=TChildControl(Inherited Items[Index]);
end;


{ TSkinBaseFormType }



destructor TSkinBaseFormType.Destroy;
begin
  inherited;
end;

procedure TSkinBaseFormType.EraseBackGnd(ACanvas: TDrawCanvas);
begin
//  ShowException('TSkinBaseFormType.EraseBackGnd');
end;

function TSkinBaseFormType.GetCustomBorderBottomHeight: Integer;
begin
//  ShowException('û��ʵ��TSkinBaseFormType.GetCustomBorderBottomHeight');
//  Result:=0;
  //����߿�ȫΪ0�Ļ�����û����Ӱ�ˣ�Ҫ����Ӱ
  Result:=1;
end;

function TSkinBaseFormType.GetCustomBorderLeftWidth: Integer;
begin
//  ShowException('û��ʵ��TSkinBaseFormType.GetCustomBorderLeftWidth');
  Result:=0;
end;

function TSkinBaseFormType.GetCustomBorderRightWidth: Integer;
begin
//  ShowException('û��ʵ��TSkinBaseFormType.GetCustomBorderRightWidth');
  Result:=0;
end;

function TSkinBaseFormType.GetCustomCaptionBarNCHeight:Integer;
begin
//  ShowException('û��ʵ��TSkinBaseFormType.GetCustomCaptionBarHeight');
  Result:=0;
end;


function TSkinBaseFormType.GetCustomCaptionBarHeight: Integer;
begin
//  ShowException('û��ʵ��TSkinBaseFormType.GetCustomCaptionBarHeight');
  Result:=0;
end;

procedure TSkinBaseFormType.InvalidateAfterFormSize;
begin
end;

procedure TSkinBaseFormType.InvalidateBeforeFormSize;
begin
end;

procedure TSkinBaseFormType.InvalidateInFormNCMessage;
begin
end;

procedure TSkinBaseFormType.PaintClient(ACanvas: TDrawCanvas);
begin
//  ShowException('û��ʵ��TSkinBaseFormType.PaintClient');
end;

procedure TSkinBaseFormType.PaintNotClient(ACanvas: TDrawCanvas);
begin
//  ShowException('û��ʵ��TSkinBaseFormType.PaintNotClient');
end;

function TSkinBaseFormType.CustomBind(ASkinControl:TControl):Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinForm,Self.FSkinFormIntf) then
    begin
      Result:=True;
    end
    else
    begin
      raise Exception.Create('�������֧��ISkinForm�ӿ�');
    end;
  end;
end;

function TSkinBaseFormType.CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;
begin
  PaintNotClient(ACanvas);
  PaintClient(ACanvas);
end;

procedure TSkinBaseFormType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinFormIntf:=nil;
end;

constructor TSkinBaseFormType.Create(ASkinControl:TControl);
begin
  inherited;
  FIsProcessIconicState:=False;
end;


procedure TSkinBaseFormType.IconicPaintClient(ACanvas: TDrawCanvas);
begin

end;

procedure TSkinBaseFormType.IconicPaintNotClient(ACanvas: TDrawCanvas);
begin

end;

procedure TSkinBaseFormType.IconicEraseBackGnd(ACanvas:TDrawCanvas);
begin
end;


{ TSkinFormBaseNormalType }


procedure TSkinFormBaseNormalType.EraseBackGnd(ACanvas:TDrawCanvas);
begin
  if csDesigning in Self.FSkinControl.ComponentState then
  begin
  end
  else
  begin
    Self.FSkinFormIntf.UpdateWindowClient(ACanvas);
  end;
end;

function TSkinFormBaseNormalType.GetCustomBorderBottomHeight: Integer;
begin
  if Self.GetSkinMaterial<>nil then
  begin
    Result:=ScreenScaleSizeInt(Self.GetSkinMaterial.FBorderBottomHeight);
  end
  else
  begin
    Result:=0;
  end;
end;

function TSkinFormBaseNormalType.GetCustomBorderLeftWidth: Integer;
begin
  if Self.GetSkinMaterial<>nil then
  begin
    Result:=ScreenScaleSizeInt(Self.GetSkinMaterial.FBorderLeftWidth);
  end
  else
  begin
    Result:=0;
  end;
end;

function TSkinFormBaseNormalType.GetCustomBorderRightWidth: Integer;
begin
  if Self.GetSkinMaterial<>nil then
  begin
    Result:=ScreenScaleSizeInt(Self.GetSkinMaterial.FBorderRightWidth);
  end
  else
  begin
    Result:=0;
  end;
end;

function TSkinFormBaseNormalType.GetCustomCaptionBarHeight: Integer;
begin
  if Self.GetSkinMaterial<>nil then
  begin
    Result:=ScreenScaleSizeInt(Self.GetSkinMaterial.FCaptionBarHeight);
  end
  else
  begin
    Result:=0;
  end;
end;

function TSkinFormBaseNormalType.GetSkinMaterial: TSkinFormBaseNormalMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinFormBaseNormalMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;



{ TSkinFormBaseFullClientType }


procedure TSkinFormBaseFullClientType.EraseBackGnd(ACanvas:TDrawCanvas);
begin

    Self.FSkinFormIntf.UpdateWindowClient(ACanvas);

end;

procedure TSkinFormBaseFullClientType.InvalidateAfterFormSize;
begin
  if csDesigning in Self.FSkinControl.ComponentState then
  begin
    Self.FSkinFormIntf.UpdateWindowClient(nil);
  end
  else
  begin
    Self.FSkinFormIntf.UpdateWindowClient(nil);
    Self.Invalidate;
  end;
end;

procedure TSkinFormBaseFullClientType.InvalidateBeforeFormSize;
begin
end;


procedure TSkinFormBaseFullClientType.InvalidateInFormNCMessage;
begin
  inherited;
  Self.FSkinFormIntf.InvalidateSubControls;
  Self.FSkinFormIntf.UpdateWindowClient(nil);
end;




{ TSkinFormMaterial }

constructor TSkinFormMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FIsRoundForm:=False;
  FFormRoundWidth:=4;
  FFormRoundHeight:=4;


  FSysBtnWidth:=24;
  FSysBtnHeight:=24;



  FAlignSysBtnTopMargin:=0;
  FAlignSysBtnRightMargin:=2;
  FAlignSysBtnSpace:=0;
  FEnableAutoAlignSysBtn:=True;

end;

//function TSkinFormMaterial.CustomLoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  I:Integer;
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited CustomLoadFromDocNode(ADocNode);
//
//  for I := 0 to ADocNode.ChildNodes.Count - 1 do
//  begin
//    ABTNode:=ADocNode.ChildNodes[I];
//
//    if ABTNode.NodeName='IsRoundForm' then
//    begin
//      FIsRoundForm:=ABTNode.ConvertNode_Bool32.Data;
//    end
//    else if ABTNode.NodeName='FormRoundWidth' then
//    begin
//      FFormRoundWidth:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='FormRoundHeight' then
//    begin
//      FFormRoundHeight:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='EnableAutoAlignSysBtn' then
//    begin
//      FEnableAutoAlignSysBtn:=ABTNode.ConvertNode_Bool32.Data;
//    end
//    else if ABTNode.NodeName='AlignSysBtnRightMargin' then
//    begin
//      FAlignSysBtnRightMargin:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='AlignSysBtnTopMargin' then
//    begin
//      FAlignSysBtnTopMargin:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='AlignSysBtnSpace' then
//    begin
//      FAlignSysBtnSpace:=ABTNode.ConvertNode_Int32.Data;
//    end
//    ;
//  end;
//
//  Result:=True;
//end;
//
//function TSkinFormMaterial.CustomSaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited CustomSaveToDocNode(ADocNode);
//
//  ABTNode:=ADocNode.AddChildNode_Bool32('IsRoundForm','�Ƿ�Բ�Ǵ���');
//  ABTNode.ConvertNode_Bool32.Data:=FIsRoundForm;
//
//  ABTNode:=ADocNode.AddChildNode_Int32('FormRoundWidth','����Բ�ǿ��');
//  ABTNode.ConvertNode_Int32.Data:=FFormRoundWidth;
//
//  ABTNode:=ADocNode.AddChildNode_Int32('FormRoundHeight','����Բ�Ǹ߶�');
//  ABTNode.ConvertNode_Int32.Data:=FFormRoundHeight;
//
//  ABTNode:=ADocNode.AddChildNode_Bool32('EnableAutoAlignSysBtn','����ϵͳ��ť����');
//  ABTNode.ConvertNode_Bool32.Data:=FEnableAutoAlignSysBtn;
//
//  ABTNode:=ADocNode.AddChildNode_Int32('AlignSysBtnRightMargin','ϵͳ��ť�����ұ߾�');
//  ABTNode.ConvertNode_Int32.Data:=FAlignSysBtnRightMargin;
//
//  ABTNode:=ADocNode.AddChildNode_Int32('AlignSysBtnTopMargin','ϵͳ��ť�����ϱ߾�');
//  ABTNode.ConvertNode_Int32.Data:=FAlignSysBtnTopMargin;
//
//  ABTNode:=ADocNode.AddChildNode_Int32('AlignSysBtnSpace','ϵͳ��ť���м��');
//  ABTNode.ConvertNode_Int32.Data:=FAlignSysBtnSpace;
//
//
//  Result:=True;
//
//end;

destructor TSkinFormMaterial.Destroy;
begin

  inherited;
end;


procedure TSkinFormMaterial.SetAlignSysBtnRightMargin(const Value: Integer);
begin
  if FAlignSysBtnRightMargin<>Value then
  begin
    FAlignSysBtnRightMargin:=Value;
  end;
end;

procedure TSkinFormMaterial.SetAlignSysBtnSpace(const Value: Integer);
begin
  if FAlignSysBtnSpace<>Value then
  begin
    FAlignSysBtnSpace:=Value;
  end;
end;

procedure TSkinFormMaterial.SetAlignSysBtnTopMargin(const Value: Integer);
begin
  if FAlignSysBtnTopMargin<>Value then
  begin
    FAlignSysBtnTopMargin:=Value;
  end;
end;

procedure TSkinFormMaterial.SetEnableAutoAlignSysBtn(const Value: Boolean);
begin
  if FEnableAutoAlignSysBtn<>Value then
  begin
    FEnableAutoAlignSysBtn:=Value;
  end;
end;

procedure TSkinFormMaterial.SetFormRoundHeight(const Value: Integer);
begin
  if FFormRoundHeight<>Value then
  begin
    FFormRoundHeight:=Value;
  end;
end;

procedure TSkinFormMaterial.SetFormRoundWidth(const Value: Integer);
begin
  if FFormRoundWidth<>Value then
  begin
    FFormRoundWidth:=Value;
  end;
end;

procedure TSkinFormMaterial.SetIsRoundForm(const Value: Boolean);
begin
  if FIsRoundForm<>Value then
  begin
    FIsRoundForm:=Value;
  end;
end;

procedure TSkinFormMaterial.SetSysBtnHeight(const Value: Integer);
begin
  FSysBtnHeight := Value;
end;

procedure TSkinFormMaterial.SetSysBtnWidth(const Value: Integer);
begin
  FSysBtnWidth := Value;
end;

{ TSkinFormBaseNormalMaterial }

constructor TSkinFormBaseNormalMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FBorderRightWidth:=1;
  FCaptionBarHeight:=30;
  FBorderLeftWidth:=1;
  FBorderBottomHeight:=1;

end;

//function TSkinFormBaseNormalMaterial.CustomLoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  I:Integer;
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited CustomLoadFromDocNode(ADocNode);
//
//  for I := 0 to ADocNode.ChildNodes.Count - 1 do
//  begin
//    ABTNode:=ADocNode.ChildNodes[I];
//
//    if ABTNode.NodeName='BorderLeftWidth' then
//    begin
//      FBorderLeftWidth:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='CaptionBarHeight' then
//    begin
//      FCaptionBarHeight:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='BorderRightWidth' then
//    begin
//      FBorderRightWidth:=ABTNode.ConvertNode_Int32.Data;
//    end
//    else if ABTNode.NodeName='BorderBottomHeight' then
//    begin
//      FBorderBottomHeight:=ABTNode.ConvertNode_Int32.Data;
//    end
//    ;
//  end;
//
//  Result:=True;
//
//end;
//
//function TSkinFormBaseNormalMaterial.CustomSaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited CustomSaveToDocNode(ADocNode);
//
//  ABTNode:=ADocNode.AddChildNode_Int32('BorderLeftWidth','��߿���');
//  ABTNode.ConvertNode_Int32.Data:=FBorderLeftWidth;
//
//  ABTNode:=ADocNode.AddChildNode_Int32('CaptionBarHeight','�������߶�');
//  ABTNode.ConvertNode_Int32.Data:=FCaptionBarHeight;
//
//  ABTNode:=ADocNode.AddChildNode_Int32('BorderRightWidth','�ұ߿���');
//  ABTNode.ConvertNode_Int32.Data:=FBorderRightWidth;
//
//  ABTNode:=ADocNode.AddChildNode_Int32('BorderBottomHeight','�ױ߿�߶�');
//  ABTNode.ConvertNode_Int32.Data:=FBorderBottomHeight;
//
//
//  Result:=True;
//end;

destructor TSkinFormBaseNormalMaterial.Destroy;
begin

  inherited;
end;



{ TSkinFormNormalType }

function TSkinFormNormalType.GetSkinMaterial: TSkinFormNormalMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinFormNormalMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinFormNormalType.InvalidateAfterFormSize;
begin
  if csDesigning in Self.FSkinControl.ComponentState then
  begin
    Self.FSkinFormIntf.UpdateWindowNotClient;
    Self.FSkinFormIntf.UpdateWindowClient(nil);
    Self.FSkinControlIntf.Invalidate;
  end
  else
  begin
    Self.FSkinFormIntf.UpdateWindowNotClient;
    Self.FSkinFormIntf.UpdateWindowClient(nil);
    Self.FSkinControlIntf.Invalidate;
  end;
end;

procedure TSkinFormNormalType.InvalidateBeforeFormSize;
begin
end;

procedure TSkinFormNormalType.InvalidateInFormNCMessage;
begin
  inherited;
  Self.FSkinFormIntf.InvalidateSubControls;
  Self.FSkinFormIntf.UpdateWindowNotClient;
end;

procedure TSkinFormNormalType.PaintClient(ACanvas: TDrawCanvas);
begin
  if GetSkinMaterial<>nil then
  begin
    //���ƿͻ���
    ACanvas.DrawRect(GetSkinMaterial.FDrawClientRectParam,
                        RectF(Self.GetCustomBorderLeftWidth,
                              Self.GetCustomCaptionBarHeight,
                              Self.FSkinControlIntf.Width-Self.GetCustomBorderRightWidth,
                              Self.FSkinControlIntf.Height-Self.GetCustomBorderBottomHeight)
                        );
  end;
end;


procedure TSkinFormNormalType.PaintNotClient(ACanvas: TDrawCanvas);
begin
  if GetSkinMaterial<>nil then
  begin


    //���Ʊ�����
    ACanvas.DrawRect(GetSkinMaterial.FDrawCaptionBarRectParam,
                        RectF(0,
                            0,
                            Self.FSkinControlIntf.Width,
                            Self.GetCustomCaptionBarHeight)
                            );

    //���Ʊ߿�
    ACanvas.DrawRect(GetSkinMaterial.FDrawBorderRectParam,
                     RectF(0,
                          Self.GetCustomCaptionBarHeight,
                          Self.GetCustomBorderLeftWidth,
                          Self.FSkinControlIntf.Height)
                          );
    ACanvas.DrawRect(GetSkinMaterial.FDrawBorderRectParam,
                     RectF(Self.FSkinControlIntf.Width-Self.GetCustomBorderRightWidth,
                          Self.GetCustomCaptionBarHeight,
                          Self.FSkinControlIntf.Width,
                          Self.FSkinControlIntf.Height)
                          );
    ACanvas.DrawRect(GetSkinMaterial.FDrawBorderRectParam,
                     RectF(0,
                          Self.FSkinControlIntf.Height-Self.GetCustomBorderBottomHeight,
                          Self.FSkinControlIntf.Width-Self.GetCustomBorderLeftWidth,
                          Self.FSkinControlIntf.Height)
                          );

  end;
  Inherited PaintNotClient(ACanvas);
end;





{ TSkinFormNormalMaterial }

destructor TSkinFormNormalMaterial.Destroy;
begin
  FreeAndNil(FDrawCaptionBarRectParam);
  FreeAndNil(FDrawClientRectParam);
  FreeAndNil(FDrawBorderRectParam);
  inherited;
end;

procedure TSkinFormNormalMaterial.SetDrawBorderRectParam(const Value: TDrawRectParam);
begin
  FDrawBorderRectParam.Assign(Value);
end;

procedure TSkinFormNormalMaterial.SetDrawCaptionBarRectParam(const Value: TDrawRectParam);
begin
  FDrawCaptionBarRectParam.Assign(Value);
end;

procedure TSkinFormNormalMaterial.SetDrawClientRectParam(const Value: TDrawRectParam);
begin
  FDrawClientRectParam.Assign(Value);
end;


constructor TSkinFormNormalMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);


  //������������Ʋ���
  FDrawCaptionBarRectParam:=CreateDrawRectParam('DrawCaptionBarRectParam','������������Ʋ���');
  //����ͻ������Ʋ���
  FDrawClientRectParam:=CreateDrawRectParam('DrawClientRectParam','����ͻ������Ʋ���');
  //����߿���Ʋ���
  FDrawBorderRectParam:=CreateDrawRectParam('DrawBorderRectParam','����߿���Ʋ���');

end;

//function TSkinFormNormalMaterial.CustomLoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  I:Integer;
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited CustomLoadFromDocNode(ADocNode);
//
//  for I := 0 to ADocNode.ChildNodes.Count - 1 do
//  begin
//    ABTNode:=ADocNode.ChildNodes[I];
//
//
////    if ABTNode.NodeName='DrawClientRectParam' then
////    begin
////      FDrawClientRectParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='DrawBorderRectParam' then
////    begin
////      FDrawBorderRectParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='DrawCaptionBarRectParam' then
////    begin
////      FDrawCaptionBarRectParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='DrawCaptionBarBottomLineParam' then
////    begin
////      FDrawCaptionBarBottomLineParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else
////    if ABTNode.NodeName='ClientColor' then
////    begin
////      FClientColor:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='BorderRoundWidth' then
////    begin
////      FBorderRoundWidth:=ABTNode.ConvertNode_Int32.Data;
////    end
////    else if ABTNode.NodeName='BorderRoundHeight' then
////    begin
////      FBorderRoundHeight:=ABTNode.ConvertNode_Int32.Data;
////    end
////    else if ABTNode.NodeName='ActiveBorderColor' then
////    begin
////      FActiveBorderColor:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='InActiveBorderColor' then
////    begin
////      FInActiveBorderColor:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='ActiveCaptionBarColor1' then
////    begin
////      FActiveCaptionBarColor1:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='ActiveCaptionBarColor2' then
////    begin
////      FActiveCaptionBarColor2:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='InActiveCaptionBarColor1' then
////    begin
////      FInActiveCaptionBarColor1:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='InActiveCaptionBarColor2' then
////    begin
////      FInActiveCaptionBarColor2:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='ActiveCaptionBarBottomLine1Color' then
////    begin
////      FActiveCaptionBarBottomLine1Color:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='ActiveCaptionBarBottomLine2Color' then
////    begin
////      FActiveCaptionBarBottomLine2Color:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='InActiveCaptionBarBottomLine1Color' then
////    begin
////      FInActiveCaptionBarBottomLine1Color:=ABTNode.ConvertNode_Color.Data;
////    end
////    else if ABTNode.NodeName='InActiveCaptionBarBottomLine2Color' then
////    begin
////      FInActiveCaptionBarBottomLine2Color:=ABTNode.ConvertNode_Color.Data;
////    end
////    ;
//  end;
//
//  Result:=True;
//end;
//
//function TSkinFormNormalMaterial.CustomSaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited CustomSaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawClientRectParam',FDrawClientRectParam.Name);
////  Self.FDrawClientRectParam.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('DrawBorderRectParam',FDrawBorderRectParam.Name);
////  Self.FDrawBorderRectParam.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('DrawCaptionBarRectParam',FDrawCaptionBarRectParam.Name);
////  Self.FDrawCaptionBarRectParam.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('DrawCaptionBarBottomLineParam',FDrawCaptionBarBottomLineParam.Name);
////  Self.FDrawCaptionBarBottomLineParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//
////  ABTNode:=ADocNode.AddChildNode_Color('ClientColor','����ͻ�����ɫ');
////  ABTNode.ConvertNode_Color.Data:=FClientColor;
////
////  ABTNode:=ADocNode.AddChildNode_Int32('BorderRoundWidth','����߿�Բ�ǿ��');
////  ABTNode.ConvertNode_Int32.Data:=FBorderRoundWidth;
////
////  ABTNode:=ADocNode.AddChildNode_Int32('BorderRoundHeight','����߿�Բ�Ǹ߶�');
////  ABTNode.ConvertNode_Int32.Data:=FBorderRoundHeight;
////
////  ABTNode:=ADocNode.AddChildNode_Color('ActiveBorderColor','���弤��״̬�߿���ɫ');
////  ABTNode.ConvertNode_Color.Data:=FActiveBorderColor;
////
////  ABTNode:=ADocNode.AddChildNode_Color('InActiveBorderColor','����Ǽ���״̬�߿���ɫ');
////  ABTNode.ConvertNode_Color.Data:=FInActiveBorderColor;
////
////  ABTNode:=ADocNode.AddChildNode_Color('ActiveCaptionBarColor1','���弤��״̬��������ɫ1');
////  ABTNode.ConvertNode_Color.Data:=FActiveCaptionBarColor1;
////
////  ABTNode:=ADocNode.AddChildNode_Color('ActiveCaptionBarColor2','���弤��״̬��������ɫ2');
////  ABTNode.ConvertNode_Color.Data:=FActiveCaptionBarColor2;
////
////  ABTNode:=ADocNode.AddChildNode_Color('InActiveCaptionBarColor1','����Ǽ���״̬��������ɫ1');
////  ABTNode.ConvertNode_Color.Data:=FInActiveCaptionBarColor1;
////
////  ABTNode:=ADocNode.AddChildNode_Color('InActiveCaptionBarColor2','����Ǽ���״̬��������ɫ2');
////  ABTNode.ConvertNode_Color.Data:=FInActiveCaptionBarColor2;
////
////  ABTNode:=ADocNode.AddChildNode_Color('ActiveCaptionBarBottomLine1Color','���弤��״̬����������1��ɫ');
////  ABTNode.ConvertNode_Color.Data:=FActiveCaptionBarBottomLine1Color;
////
////  ABTNode:=ADocNode.AddChildNode_Color('ActiveCaptionBarBottomLine2Color','���弤��״̬����������2��ɫ');
////  ABTNode.ConvertNode_Color.Data:=FActiveCaptionBarBottomLine2Color;
////
////  ABTNode:=ADocNode.AddChildNode_Color('InActiveCaptionBarBottomLine1Color','����Ǽ���״̬����������1��ɫ');
////  ABTNode.ConvertNode_Color.Data:=FInActiveCaptionBarBottomLine1Color;
////
////  ABTNode:=ADocNode.AddChildNode_Color('InActiveCaptionBarBottomLine2Color','����Ǽ���״̬����������2��ɫ');
////  ABTNode.ConvertNode_Color.Data:=FInActiveCaptionBarBottomLine2Color;
//
//
//
//
//  Result:=True;
//
//end;





{ TSkinFormDefaultType }

procedure TSkinFormDefaultType.PaintClient(ACanvas: TDrawCanvas);
begin
  if Self.GetSkinMaterial<>nil then
  begin

    //���Ʊ���
    if GetSkinMaterial.IsTransparent then
    begin
//              DrawParent(Self,ACanvas.Handle,
//                                  0,0,Self.Width,Self.Height,
//                                  0,0);
    end
    else
    begin
      ACanvas.DrawRect(GetSkinMaterial.BackColor,
                        RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height)
                        );
    end;


    //���Ʊ���ͼƬ
    ACanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
              Self.GetSkinMaterial.FBackGndDrawPicture,
              RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height)
              );


//    //����ǰ��ͼƬ
//    ACanvas.DrawPicture(Self.GetSkinMaterial.FForeGndDrawPictureParam,
//              Self.GetSkinMaterial.FForeGndDrawPicture,
//              Rect(0,0,Self.FSkinFormIntf.Width,Self.FSkinFormIntf.Height));

//    if Not FBackGndBufferBitmapPainted
//      and (Self.GetSkinMaterial.FBackGndDrawPicture.Graphic<>nil)
//      and (Not Self.GetSkinMaterial.FBackGndDrawPicture.Graphic.Empty) then
//    begin
//      Self.FBackGndBufferBitmap.CreateBufferBitmap(
//                      Self.GetSkinMaterial.FBackGndDrawPicture.Width*2,
//                      Self.GetSkinMaterial.FBackGndDrawPicture.Height*2);
//      if (Self.FBackGndBufferBitmap.DrawCanvas<>nil) then
//      begin
//        FBackGndBufferBitmapPainted:=True;
//        //���Ʊ���ͼƬ
//        Self.FBackGndBufferBitmap.DrawCanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
//                  Self.GetSkinMaterial.FBackGndDrawPicture,
//                  Rect(0,0,
//                  Self.GetSkinMaterial.FBackGndDrawPicture.Width,
//                  Self.GetSkinMaterial.FBackGndDrawPicture.Height));
//        Self.FBackGndBufferBitmap.DrawCanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
//                  Self.GetSkinMaterial.FBackGndDrawPicture,
//                  Rect(Self.GetSkinMaterial.FBackGndDrawPicture.Width,0,
//                  Self.GetSkinMaterial.FBackGndDrawPicture.Width*2,
//                  Self.GetSkinMaterial.FBackGndDrawPicture.Height));
//        Self.FBackGndBufferBitmap.DrawCanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
//                  Self.GetSkinMaterial.FBackGndDrawPicture,
//                  Rect(0,Self.GetSkinMaterial.FBackGndDrawPicture.Height,
//                  Self.GetSkinMaterial.FBackGndDrawPicture.Width,
//                  Self.GetSkinMaterial.FBackGndDrawPicture.Height*2));
//        Self.FBackGndBufferBitmap.DrawCanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
//                  Self.GetSkinMaterial.FBackGndDrawPicture,
//                  Rect(Self.GetSkinMaterial.FBackGndDrawPicture.Width,Self.GetSkinMaterial.FBackGndDrawPicture.Height,
//                  Self.GetSkinMaterial.FBackGndDrawPicture.Width*2,
//                  Self.GetSkinMaterial.FBackGndDrawPicture.Height*2));
//      end;
//    end;
//
//    if Not FBackGndBufferBitmapPainted then Exit;
//
//    case Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchStyle of
//      issTensile:         //����
//      begin
//        //����ͼƬ
////        StretchBlt(ACanvas.Handle,0,0,
////                    Self.FSkinFormIntf.Width,Self.FSkinFormIntf.Height,
////                    Self.FBackGndBufferBitmap.Handle,
////                    0,0,
////                    Self.FBackGndBufferBitmap.Width,Self.FBackGndBufferBitmap.Height,
////                    SRCCOPY);
//        BitBlt(ACanvas.Handle,0,0,
//                    Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height,
//                    Self.FBackGndBufferBitmap.Handle,
//                    0,0,
//                    SRCCOPY);
//      end;
////      issTile:            //ƽ��(���)
////      begin
////
////      end;
////      issSquare:          //�Ź���
////      begin
////        //����ͼƬ
////        StretchBlt(ACanvas.Handle,0,0,
////                    Self.FSkinFormIntf.Width,Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    Self.FBackGndBufferBitmap.Handle,
////                    0,0,
////                    Self.FBackGndBufferBitmap.Width,Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    SRCCOPY);
////        StretchBlt(ACanvas.Handle,
////                    0,Self.FSkinFormIntf.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom,
////                    Self.FSkinFormIntf.Width,Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom,
////
////                    Self.FBackGndBufferBitmap.Handle,
////                    0,Self.FBackGndBufferBitmap.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom,
////                    Self.FBackGndBufferBitmap.Width,Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom,
////                    SRCCOPY);
////        StretchBlt(ACanvas.Handle,
////                    0,Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Left,
////                    Self.FSkinFormIntf.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////
////                    Self.FBackGndBufferBitmap.Handle,
////                    0,Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Left,
////                    Self.FBackGndBufferBitmap.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    SRCCOPY);
////        StretchBlt(ACanvas.Handle,
////                    Self.FSkinFormIntf.Width-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.FSkinFormIntf.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////
////                    Self.FBackGndBufferBitmap.Handle,
////                    Self.FBackGndBufferBitmap.Width-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.FBackGndBufferBitmap.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    SRCCOPY);
////
////        StretchBlt(ACanvas.Handle,
////                    Self.FSkinFormIntf.Width-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.FSkinFormIntf.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////
////                    Self.FBackGndBufferBitmap.Handle,
////                    Self.FBackGndBufferBitmap.Width-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.FBackGndBufferBitmap.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    SRCCOPY);
////
////        StretchBlt(ACanvas.Handle,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    Self.FSkinFormIntf.Width-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Left
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.FSkinFormIntf.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////
////                    Self.FBackGndBufferBitmap.Handle,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    Self.FBackGndBufferBitmap.Width-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Left
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Right,
////                    Self.FBackGndBufferBitmap.Height-Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Bottom
////                    -Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchMargins.Top,
////                    SRCCOPY);
////
////
////      end;
////      issThreePartHorz:   //ˮƽ���ַ�
////      begin
////
////      end;
////      issThreePartVert:    //ˮƽ���ַ�
////      begin
////
////      end;
//    end;
  end;
  Inherited PaintClient(ACanvas);
end;

function TSkinFormDefaultType.GetSkinMaterial: TSkinFormDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinFormDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;


{ TSkinFormDefaultMaterial }

constructor TSkinFormDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackGndDrawPicture:=CreateDrawPicture('BackGndDrawPicture','���屳��ͼƬ');
  FBackGndDrawPictureParam:=CreateDrawPictureParam('BackGndDrawPictureParam','���屳��ͼƬ���Ʋ���');
  FBackGndDrawPictureParam.IsStretch:=True;
  FBackGndDrawPictureParam.StretchStyle:=issTensile;

//  FForeGndDrawPicture:=CreateDrawPicture('ForeGndDrawPicture','����ǰ��ͼƬ');
//  FForeGndDrawPictureParam:=CreateDrawPictureParam('ForeGndDrawPictureParam','����ǰ��ͼƬ���Ʋ���');
//  FForeGndDrawPictureParam.IsStretch:=True;
//  FForeGndDrawPictureParam.StretchStyle:=issTensile;
end;

destructor TSkinFormDefaultMaterial.Destroy;
begin
  FreeAndNil(FBackGndDrawPicture);
  FreeAndNil(FBackGndDrawPictureParam);
//  FreeAndNil(FForeGndDrawPicture);
//  FreeAndNil(FForeGndDrawPictureParam);
  inherited;
end;

procedure TSkinFormDefaultMaterial.SetBackGndDrawPicture(const Value: TDrawPicture);
begin
  FBackGndDrawPicture.Assign(Value);
end;

procedure TSkinFormDefaultMaterial.SetBackGndDrawPictureParam(const Value: TDrawPictureParam);
begin
  FBackGndDrawPictureParam.Assign(Value);
end;

//procedure TSkinFormDefaultMaterial.SetForeGndDrawPicture(const Value: TDrawPicture);
//begin
//  FForeGndDrawPicture.Assign(Value);
//end;
//
//procedure TSkinFormDefaultMaterial.SetForeGndDrawPictureParam(const Value: TDrawPictureParam);
//begin
//  FForeGndDrawPictureParam.Assign(Value);
//end;



{ TFormProperties }

procedure TFormProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;

end;

constructor TFormProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinForm,Self.FSkinFormIntf) then
  begin
    ShowException('�������֧��ISkinForm�ӿ�');
  end;
end;

destructor TFormProperties.Destroy;
begin
  inherited;
end;

function TFormProperties.GetComponentClassify: String;
begin
  Result:='SkinForm';
end;

end.
//------------------------------------------------------------------
//
//                 OrangeUI Source Files
//
//  Module: OrangeUIControl
//  Unit: uSkinFormType
//  Description: ����
//
//  Copyright: delphiteacher
//  CodeBy: delphiteacher
//  Email: ggggcexx@163.com
//  Writing: 2012-2014
//
//------------------------------------------------------------------




