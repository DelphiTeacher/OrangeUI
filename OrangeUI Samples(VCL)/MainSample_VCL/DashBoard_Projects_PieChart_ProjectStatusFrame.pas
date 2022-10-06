unit DashBoard_Projects_PieChart_ProjectStatusFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDrawCanvas, uSkinItems,

  //�����ز�ģ��
  EasyServiceCommonMaterialDataMoudle_VCL,


  uSkinVirtualChartType,
  uDrawPathParam,
  uGraphicCommon,
  uDrawParam,

  uSkinWindowsControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinPanelType, Vcl.StdCtrls,
  uSkinButtonType, uSkinVirtualListType, uSkinListViewType;

type
  TFramePieChart_ProjectStatus = class(TFrame)
    pnlClient: TSkinWinPanel;
    lblCaption: TLabel;
    SkinWinButton1: TSkinWinButton;
    lvData: TSkinWinListView;
    procedure gridDataResize(Sender: TObject);
  private
    { Private declarations }
  public
    FSkinVirtualChart:TSkinVirtualChart;
    constructor Create(AOwner: TComponent);
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFramePieChart_ProjectStatus.gridDataResize(Sender: TObject);
begin
  //���������ǰ�������,��ôÿ���϶��ߴ�,��Ҫ���¼���
  //Self.gridData.Prop.Columns.GetListLayoutsManager.DoItemSizeChange(nil);
end;

constructor TFramePieChart_ProjectStatus.Create(AOwner: TComponent);
var
  ASeries:TVirtualChartSeries;
  ADataItem:TVirtualChartSeriesDataItem;
begin
  inherited;
  FSkinVirtualChart:=TSkinVirtualChart.Create(Self);
  FSkinVirtualChart.Parent:=Self;
  FSkinVirtualChart.SetBounds(
                          10,
                          Self.lblCaption.Top+lblCaption.Height+10,
                          Width-10-10,
                          Height-(lblCaption.Top+lblCaption.Height+10)-lvData.Height-10
                          );
  FSkinVirtualChart.Anchors:=[akLeft,akTop,akRight,akBottom];
//  FSkinVirtualChart.Align:=alClient;
//  FSkinVirtualChart.AlignWithMargins:=True;


//  FSkinVirtualChart.SelfOwnMaterialToDefault.BarSizePercent:=0.4;
//  FSkinVirtualChart.SelfOwnMaterialToDefault.BackColor.IsFill:=True;
//  FSkinVirtualChart.SelfOwnMaterialToDefault.BarAxisLineParam.Color.Color:=clGray;
//  FSkinVirtualChart.SelfOwnMaterialToDefault.DrawAxisCaptionParam.FontColor:=clGray;
  FSkinVirtualChart.SelfOwnMaterialToDefault.SeriesLegendListViewVisible:=False;
  FSkinVirtualChart.SelfOwnMaterialToDefault.PieInfoVisible:=False;
  FSkinVirtualChart.SelfOwnMaterialToDefault.PieInnerRadiusPercent:=0.5;
  FSkinVirtualChart.SelfOwnMaterialToDefault.FSeriesColorArray[0]:=$97CF0A;
  FSkinVirtualChart.SelfOwnMaterialToDefault.FSeriesColorArray[1]:=$F57C72;
  FSkinVirtualChart.SelfOwnMaterialToDefault.FSeriesColorArray[2]:=$7C5CFA;


//  //��ʾX��ķָ���
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SkinControlType;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.BackColor.BorderWidth:=1;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColLine:=True;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColBeginLine:=True;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColEndLine:=True;
//
//  //��ʾY��ķָ���
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SkinControlType;
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SelfOwnMaterialToDefault.BackColor.BorderWidth:=1;
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SelfOwnMaterialToDefault.DrawItemDevideParam.IsFill:=True;



//  //X������
//  FSkinVirtualChart.Properties.XAxisItems.Add.Caption:='�����';
//  FSkinVirtualChart.Properties.XAxisItems.Add.Caption:='������';
//  FSkinVirtualChart.Properties.XAxisItems.Add.Caption:='����';



//  //Y�������ϵĵ�,�Զ�������Ҫ����
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,800';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,500';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,200';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='900';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='600';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='300';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='0';



  //����
  ASeries:=TVirtualChartSeries(FSkinVirtualChart.Properties.SeriesList.Add);
  //��ͼ
  ASeries.ChartType:=sctPie;
  ASeries.Caption:='����';

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='�����';
  ADataItem.Value:=64;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='������';
  ADataItem.Value:=26;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='����';
  ADataItem.Value:=10;



end;

end.
