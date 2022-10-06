unit ChartFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uSkinVirtualChartType,
  uDrawPathParam,
  uGraphicCommon,
  uDrawParam,



  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinLabelType, uSkinPanelType,
  uSkinItemDesignerPanelType;

type
  TFrameChart = class(TFrame)
    SkinFMXVirtualChart1: TSkinFMXVirtualChart;
  private
    { Private declarations }
  public
    FSkinVirtualChart:TSkinVirtualChart;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameChart }

constructor TFrameChart.Create(AOwner: TComponent);
var
  ASeries:TVirtualChartSeries;
  ADataItem:TVirtualChartSeriesDataItem;
begin
  inherited;

  Exit;

  FSkinVirtualChart:=TSkinVirtualChart.Create(Self);
  FSkinVirtualChart.Parent:=Self;
  FSkinVirtualChart.Align:=TAlignLayout.Client;
  FSkinVirtualChart.SkinControlType;
//  FSkinVirtualChart.AlignWithMargins:=True;


  FSkinVirtualChart.SelfOwnMaterialToDefault.BackColor.IsFill:=True;
  FSkinVirtualChart.SelfOwnMaterialToDefault.BarAxisLineParam.Color.Color:=TAlphaColorRec.Gray;
  FSkinVirtualChart.SelfOwnMaterialToDefault.DrawAxisCaptionParam.FontColor:=TAlphaColorRec.Gray;
  //饼图内部空心圆的半径
  FSkinVirtualChart.SelfOwnMaterialToDefault.PieInnerRadiusPercent:=0;
//  FSkinVirtualChart.SelfOwnMaterialToDefault.PieInnerRadiusPercent:=0.4;


//  //显示X轴的分隔线
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SkinControlType;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.BackColor.BorderWidth:=1;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColLine:=True;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColBeginLine:=True;
//  FSkinVirtualChart.Prop.FXAxisSkinListView.SelfOwnMaterialToDefault.IsDrawColEndLine:=True;
//
//  //显示Y轴的分隔线
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SkinControlType;
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SelfOwnMaterialToDefault.BackColor.BorderWidth:=1;
//  FSkinVirtualChart.Prop.FYAxisSkinListView.SelfOwnMaterialToDefault.DrawItemDevideParam.IsFill:=True;



  //X轴坐标
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Mon';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Tue';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Wed';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Thu';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Fri';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Sat';
  FSkinVirtualChart.Properties.AxisItems.Add.Caption:='Sun';



//  //Y轴坐标上的点,自动，不需要设置
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,800';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,500';                        xl
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='1,200';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='900';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='600';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='300';
//  FSkinVirtualChart.Properties.YAxisItems.Add.Caption:='0';



  //数据
  ASeries:=TVirtualChartSeries(FSkinVirtualChart.Properties.SeriesList.Add);
  ASeries.Caption:='本星期金额';

//  ASeries.ChartType:=sctBar;//柱状图
//  ASeries.ChartType:=sctPie;//饼状图
  ASeries.ChartType:=sctLine;//线状图

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Mon';
  ADataItem.Value:=300;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Tue';
  ADataItem.Value:=600;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Wed';
  ADataItem.Value:=700;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Thu';
  ADataItem.Value:=900;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Fri';
  ADataItem.Value:=1300;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Sat';
  ADataItem.Value:=1600;

  ADataItem:=ASeries.DataItems.Add;
  ADataItem.Caption:='Sun';
  ADataItem.Value:=1800;


//  ASeries.ChartType:=sctPie;//饼状图
//  ASeries.ChartType:=sctLine;//线状图
//  ADataItem.Color:=clGreen;



//  //数据
//  ASeries:=TVirtualChartSeries(FSkinVirtualChart.Properties.SeriesList.Add);
//  ASeries.Caption:='上星期金额';
//
//  ASeries.ChartType:=sctBar;//柱状图
////  ASeries.ChartType:=sctPie;//饼状图
////  ASeries.ChartType:=sctLine;//线状图
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Mon';
//  ADataItem.Value:=400;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Tue';
//  ADataItem.Value:=700;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Wed';
//  ADataItem.Value:=800;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Thu';
//  ADataItem.Value:=400;
////  ADataItem.Color:=clGreen;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Fri';
//  ADataItem.Value:=400;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Sat';
//  ADataItem.Value:=600;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Sun';
//  ADataItem.Value:=800;
//
//
//
//  //数据
//  ASeries:=TVirtualChartSeries(FSkinVirtualChart.Properties.SeriesList.Add);
//  ASeries.Caption:='上上星期金额';
//
//  ASeries.ChartType:=sctBar;//柱状图
////  ASeries.ChartType:=sctPie;//饼状图
////  ASeries.ChartType:=sctLine;//线状图
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Mon';
//  ADataItem.Value:=400;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Tue';
//  ADataItem.Value:=700;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Wed';
//  ADataItem.Value:=800;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Thu';
//  ADataItem.Value:=400;
////  ADataItem.Color:=clGreen;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Fri';
//  ADataItem.Value:=400;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Sat';
//  ADataItem.Value:=600;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Sun';
//  ADataItem.Value:=800;
//
//
//
//
//  //数据
//  ASeries:=TVirtualChartSeries(FSkinVirtualChart.Properties.SeriesList.Add);
//  ASeries.Caption:='上上上星期金额';
//
//  ASeries.ChartType:=sctBar;//柱状图
////  ASeries.ChartType:=sctPie;//饼状图
////  ASeries.ChartType:=sctLine;//线状图
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Mon';
//  ADataItem.Value:=400;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Tue';
//  ADataItem.Value:=700;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Wed';
//  ADataItem.Value:=800;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Thu';
//  ADataItem.Value:=400;
////  ADataItem.Color:=clGreen;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Fri';
//  ADataItem.Value:=400;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Sat';
//  ADataItem.Value:=600;
//
//  ADataItem:=ASeries.DataItems.Add;
//  ADataItem.Caption:='Sun';
//  ADataItem.Value:=800;





end;

destructor TFrameChart.Destroy;
begin

  inherited;
end;

end.
