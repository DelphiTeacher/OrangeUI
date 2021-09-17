unit uBitmapOperation;

interface
{$I FrameWork.inc}

uses
  SysUtils,

  {$IFDEF FMX}
  FMX.Graphics,
  UITypes,
  {$ENDIF FMX}

  {$IFDEF VCL}
  Types,
  Graphics,
  {$ENDIF VCL}


  Classes
  ;

  {$IFDEF FMX}

//反色
procedure Negative(Bmp:TBitmap);
//亮度调整
procedure BrightnessChange(const SrcBmp:TBitmap;
                          //const DestBmp:TBitmap;
                          ValueChange:integer);
//对比度调整
procedure ContrastChange(const SrcBmp:TBitmap;
                          //const DestBmp:TBitmap;
                          ValueChange:integer);

//饱和度调整
procedure SaturationChange(const SrcBmp:TBitmap;
                            //const DestBmp:TBitmap;
                            ValueChange:integer);
//RGB调整
procedure RGBChange(const SrcBmp:TBitmap;
                    //const DestBmp:TBitmap;
                    RedChange,GreenChange,BlueChange:integer);
  {$ENDIF FMX}


implementation

  {$IFDEF FMX}
//hueToRGB = function (m1, m2, h) {
//    h = (h < 0) ? h + 1 : ((h > 1) ? h - 1 : h);
//    if (h * 6 < 1) return m1 + (m2 - m1) * h * 6;
//    if (h * 2 < 1) return m2;
//    if (h * 3 < 2) return m1 + (m2 - m1) * (0.66666 - h) * 6;
//    return m1;
//  }



////浮雕
//procedure Emboss(SrcBmp,DestBmp:TBitmap;AzimuthChange:integer);overload;
//var
// i, j, Gray, Azimuthvalue, R, G, B: integer;
// SrcRGB, SrcRGB1, SrcRGB2, DestRGB: PAlphaColorRec;
//begin
// for i := 0 to SrcBmp.Height - 1 do
// begin
//  SrcRGB := SrcBmp.GetScanLine(i);
//  DestRGB := DestBmp.GetScanLine(i);
//  if (AzimuthChange >= -180) and (AzimuthChange < -135) then
//  begin
//   if i > 0 then
//    SrcRGB1 := SrcBmp.GetScanLine[i-1]
//   else
//    SrcRGB1 := SrcRGB;
//   Inc(SrcRGB1);
//   SrcRGB2 := SrcRGB;
//   Inc(SrcRGB2);
//  end
//  else if (AzimuthChange >= -135) and (AzimuthChange < -90) then
//  begin
//   if i > 0 then
//    SrcRGB1 := SrcBmp.GetScanLine[i-1]
//   else
//    SrcRGB1 := SrcRGB;
//   SrcRGB2 := SrcRGB1;
//   Inc(SrcRGB2);
//  end
//  else if (AzimuthChange >= -90) and (AzimuthChange < -45) then
//  begin
//   if i > 0 then
//    SrcRGB1 := SrcBmp.GetScanLine[i-1]
//   else
//    SrcRGB1 := SrcRGB;
//   SrcRGB2 := SrcRGB1;
//  end
//  else if (AzimuthChange >= -45) and (AzimuthChange < 0) then
//  begin
//   SrcRGB1 := SrcRGB;
//   if i > 0 then
//    SrcRGB2 := SrcBmp.GetScanLine[i-1]
//   else
//    SrcRGB2 := SrcRGB;
//  end
//  else if (AzimuthChange >= 0) and (AzimuthChange < 45) then
//  begin
//   SrcRGB2 := SrcRGB;
//   if (i < SrcBmp.Height - 1) then
//    SrcRGB1 := SrcBmp.GetScanLine[i+1]
//   else
//    SrcRGB1 := SrcRGB;
//  end
//  else if (AzimuthChange >= 45) and (AzimuthChange < 90) then
//  begin
//   if (i < SrcBmp.Height - 1) then
//    SrcRGB1 := SrcBmp.GetScanLine[i+1]
//   else
//    SrcRGB1 := SrcRGB;
//   SrcRGB2 := SrcRGB1;
//  end
//  else if (AzimuthChange >= 90) and (AzimuthChange < 135) then
//  begin
//   if (i < SrcBmp.Height - 1) then
//    SrcRGB1 := SrcBmp.GetScanLine[i+1]
//   else
//    SrcRGB1 := SrcRGB;
//   SrcRGB2 := SrcRGB1;
//   Inc(SrcRGB1);
//  end
//  else if (AzimuthChange >= 135) and (AzimuthChange <= 180) then
//  begin
//   if (i < SrcBmp.Height - 1) then
//    SrcRGB2 := SrcBmp.GetScanLine[i+1]
//   else
//    SrcRGB2 := SrcRGB;
//   Inc(SrcRGB2);
//   SrcRGB1 := SrcRGB;
//   Inc(SrcRGB1);
//  end;
//  for j := 0 to SrcBmp.Width - 1 do
//  begin
//   if (AzimuthChange >= -180) and (AzimuthChange < -135) then
//   begin
//    Azimuthvalue := AzimuthChange + 180;
//    R:=SrcRGB.R-((SrcRGB1.R)*Azimuthvalue div 45)-((SrcRGB2.R)*(45-Azimuthvalue) div 45)+78;
//    G:=SrcRGB.G-((SrcRGB1.G)*Azimuthvalue div 45)-((SrcRGB2.G)*(45-Azimuthvalue) div 45)+78;
//    B:=SrcRGB.B-((SrcRGB1.B)*Azimuthvalue div 45)-((SrcRGB2.B)*(45-Azimuthvalue) div 45)+78;
//   end
//   else if (AzimuthChange >= -135) and (AzimuthChange < -90) then
//   begin
//    Azimuthvalue := AzimuthChange + 135;
//    R:=SrcRGB.R-((SrcRGB1.R)*Azimuthvalue div 45)-((SrcRGB2.R)*(45-Azimuthvalue) div 45)+78;
//    G:=SrcRGB.G-((SrcRGB1.G)*Azimuthvalue div 45)-((SrcRGB2.G)*(45-Azimuthvalue) div 45)+78;
//    B:=SrcRGB.B-((SrcRGB1.B)*Azimuthvalue div 45)-((SrcRGB2.B)*(45-Azimuthvalue) div 45)+78;
//   end
//   else if (AzimuthChange >= -90) and (AzimuthChange < -45) then
//   begin
//    if j=1 then Inc(SrcRGB1,-1);
//    Azimuthvalue := AzimuthChange + 90;
//    R:=SrcRGB.R-((SrcRGB1.R)*Azimuthvalue div 45)-((SrcRGB2.R)*(45-Azimuthvalue) div 45)+78;
//    G:=SrcRGB.G-((SrcRGB1.G)*Azimuthvalue div 45)-((SrcRGB2.G)*(45-Azimuthvalue) div 45)+78;
//    B:=SrcRGB.B-((SrcRGB1.B)*Azimuthvalue div 45)-((SrcRGB2.B)*(45-Azimuthvalue) div 45)+78;
//   end
//   else if (AzimuthChange >= -45) and (AzimuthChange < 0) then
//   begin
//    if j=1 then
//    begin
//     Inc(SrcRGB1,-1);
//     Inc(SrcRGB2,-1);
//    end;
//    Azimuthvalue := AzimuthChange + 45;
//    R:=SrcRGB.R-((SrcRGB1.R)*Azimuthvalue div 45)-((SrcRGB2.R)*(45-Azimuthvalue) div 45)+78;
//    G:=SrcRGB.G-((SrcRGB1.G)*Azimuthvalue div 45)-((SrcRGB2.G)*(45-Azimuthvalue) div 45)+78;
//    B:=SrcRGB.B-((SrcRGB1.B)*Azimuthvalue div 45)-((SrcRGB2.B)*(45-Azimuthvalue) div 45)+78;
//   end
//   else if (AzimuthChange >= 0) and (AzimuthChange < 45) then
//   begin
//    if j=1 then
//    begin
//     Inc(SrcRGB1,-1);
//     Inc(SrcRGB2,-1);
//    end;
//    Azimuthvalue := AzimuthChange;
//    R:=SrcRGB.R-((SrcRGB1.R)*Azimuthvalue div 45)-((SrcRGB2.R)*(45-Azimuthvalue) div 45)+78;
//    G:=SrcRGB.G-((SrcRGB1.G)*Azimuthvalue div 45)-((SrcRGB2.G)*(45-Azimuthvalue) div 45)+78;
//    B:=SrcRGB.B-((SrcRGB1.B)*Azimuthvalue div 45)-((SrcRGB2.B)*(45-Azimuthvalue) div 45)+78;
//   end
//   else if (AzimuthChange >= 45) and (AzimuthChange < 90) then
//   begin
//    if j=1 then Inc(SrcRGB2,-1);
//    Azimuthvalue := AzimuthChange - 45;
//    R:=SrcRGB.R-((SrcRGB1.R)*Azimuthvalue div 45)-((SrcRGB2.R)*(45-Azimuthvalue) div 45)+78;
//    G:=SrcRGB.G-((SrcRGB1.G)*Azimuthvalue div 45)-((SrcRGB2.G)*(45-Azimuthvalue) div 45)+78;
//    B:=SrcRGB.B-((SrcRGB1.B)*Azimuthvalue div 45)-((SrcRGB2.B)*(45-Azimuthvalue) div 45)+78;
//   end
//   else if (AzimuthChange >= 90) and (AzimuthChange < 135) then
//   begin
//    Azimuthvalue := AzimuthChange - 90;
//    R:=SrcRGB.R-((SrcRGB1.R)*Azimuthvalue div 45)-((SrcRGB2.R)*(45-Azimuthvalue) div 45)+78;
//    G:=SrcRGB.G-((SrcRGB1.G)*Azimuthvalue div 45)-((SrcRGB2.G)*(45-Azimuthvalue) div 45)+78;
//    B:=SrcRGB.B-((SrcRGB1.B)*Azimuthvalue div 45)-((SrcRGB2.B)*(45-Azimuthvalue) div 45)+78;
//   end
//   else if (AzimuthChange >= 135) and (AzimuthChange <= 180) then
//   begin
//    Azimuthvalue := AzimuthChange - 135;
//    R:=SrcRGB.R-((SrcRGB1.R)*Azimuthvalue div 45)-((SrcRGB2.R)*(45-Azimuthvalue) div 45)+78;
//    G:=SrcRGB.G-((SrcRGB1.G)*Azimuthvalue div 45)-((SrcRGB2.G)*(45-Azimuthvalue) div 45)+78;
//    B:=SrcRGB.B-((SrcRGB1.B)*Azimuthvalue div 45)-((SrcRGB2.B)*(45-Azimuthvalue) div 45)+78;
//   end;
//   R:=Min(R,255);
//   R:=Max(R,0);
//   G:=Min(G,255);
//   G:=Max(G,0);
//   B:=Min(B,255);
//   B:=Max(B,0);
//   Gray := (R shr 2) + (R shr 4) + (G shr 1) + (G shr 4) + (B shr 3);
//   DestRGB.R:=Gray;
//   DestRGB.G:=Gray;
//   DestRGB.B:=Gray;
//   if (j=-180) and (AzimuthChange<-135)) or ((AzimuthChange>=90) and (AzimuthChange<=180))) then
//   begin
//    Inc(SrcRGB1);
//   end;
//   if (j=135) and (AzimuthChange<180)) or ((AzimuthChange>=-180) and (AzimuthChange<=-90))) then
//   begin
//    Inc(SrcRGB2);
//   end;
//   Inc(SrcRGB);
//   Inc(DestRGB);
//  end;
// end;
//end;
//procedure Emboss(Bmp:TBitmap;AzimuthChange:integer;ElevationChange:integer;WeightChange:integer);overload;
//var
// DestBmp:TBitmap;
//begin
//　　DestBmp:=TBitmap.Create;
//　　DestBmp.Assign(Bmp);
//　　Emboss(Bmp,DestBmp,AzimuthChange,ElevationChange,WeightChange);
//　　Bmp.Assign(DestBmp);
//end;

//反色
procedure Negative(Bmp:TBitmap);
var
 i, j: Integer;
// PRGB: PAlphaColorRec;
var
//   Gray, x, y ,v: Integer;
   A_BMPData : TBitmapData ;
//   p: PByteArray;
   p: PAlphaColorRec;
   b : TBitmap;
//   AColor:TAlphaColorRec;
begin
//   b := TBitmap.Create;
//   try
//     b.Assign(Bmp);

     b:=Bmp;

     if  b.Map( TMapAccess.ReadWrite, A_BMPData)  then
     begin
    //   Bmp.PixelFormat:=pf24Bit;
       for i := 0 to A_BMPData.Height - 1 do
       begin
        p := A_BMPData.GetScanline(i);
        for j := 0 to A_BMPData.Width - 1 do
        begin
         p^.R :=not p^.R ;
         p^.G :=not p^.G;
         p^.B :=not p^.B;
         Inc(p);
        end;
       end;

       b.Unmap(A_BMPData);
     end;

//     Bmp.Assign(b);
//
//   finally
//     FreeAndNil(b);
//   end;
end;

////曝光
//procedure Exposure(Bmp:TBitmap);
//var
// i, j: integer;
// PRGB: PAlphaColorRec;
//begin
// Bmp.PixelFormat:=pf24Bit;
// for i := 0 to Bmp.Height - 1 do
// begin
//  PRGB := Bmp.GetScanLine(i);
//  for j := 0 to Bmp.Width - 1 do
//  begin
//   if PRGB^.R<128 then
//    PRGB^.R :=not PRGB^.R ;
//   if PRGB^.G<128 then
//    PRGB^.G :=not PRGB^.G;
//   if PRGB^.B<128 then
//    PRGB^.B :=not PRGB^.B;
//   Inc(PRGB);
//  end;
// end;
//end;


////模糊
//procedure Blur(SrcBmp:TBitmap);
//var
// i, j:Integer;
// SrcRGB:PAlphaColorRec;
// SrcNextRGB:PAlphaColorRec;
// SrcPreRGB:PAlphaColorRec;
// Value:Integer;
// procedure IncRGB;
// begin
//  Inc(SrcPreRGB);
//  Inc(SrcRGB);
//  Inc(SrcNextRGB);
// end;
// procedure DecRGB;
// begin
//  Inc(SrcPreRGB,-1);
//  Inc(SrcRGB,-1);
//  Inc(SrcNextRGB,-1);
// end;
//begin
// SrcBmp.PixelFormat:=pf24Bit;
// for i := 0 to SrcBmp.Height - 1 do
// begin
//  if i > 0 then
//   SrcPreRGB:=SrcBmp.GetScanLine[i-1]
//  else
//   SrcPreRGB := SrcBmp.GetScanLine(i);
//  SrcRGB := SrcBmp.GetScanLine(i);
//  if i < SrcBmp.Height - 1 then
//   SrcNextRGB:=SrcBmp.GetScanLine[i+1]
//  else
//   SrcNextRGB:=SrcBmp.GetScanLine(i);
//  for j := 0 to SrcBmp.Width - 1 do
//  begin
//   if j > 0 then DecRGB;
//   Value:=SrcPreRGB.R+SrcRGB.R+SrcNextRGB.R;
//   if j > 0 then IncRGB;
//   Value:=Value+SrcPreRGB.R+SrcRGB.R+SrcNextRGB.R;
//   if j < SrcBmp.Width - 1 then IncRGB;
//   Value:=(Value+SrcPreRGB.R+SrcRGB.R+SrcNextRGB.R) div 9;
//   DecRGB;
//   SrcRGB.R:=value;
//   if j > 0 then DecRGB;
//   Value:=SrcPreRGB.G+SrcRGB.G+SrcNextRGB.G;
//   if j > 0 then IncRGB;
//   Value:=Value+SrcPreRGB.G+SrcRGB.G+SrcNextRGB.G;
//   if j < SrcBmp.Width - 1 then IncRGB;
//   Value:=(Value+SrcPreRGB.G+SrcRGB.G+SrcNextRGB.G) div 9;
//   DecRGB;
//   SrcRGB.G:=value;
//   if j > 0 then DecRGB;
//   Value:=SrcPreRGB.B+SrcRGB.B+SrcNextRGB.B;
//   if j > 0 then IncRGB;
//   Value:=Value+SrcPreRGB.B+SrcRGB.B+SrcNextRGB.B;
//   if j < SrcBmp.Width - 1 then IncRGB;
//   Value:=(Value+SrcPreRGB.B+SrcRGB.B+SrcNextRGB.B) div 9;
//   DecRGB;
//   SrcRGB.B:=value;
//   IncRGB;
//  end;
// end;
//end;


////锐化
//procedure Sharpen(SrcBmp:TBitmap);
//var
// i, j: integer;
// SrcRGB: PAlphaColorRec;
// SrcPreRGB: PAlphaColorRec;
// Value: integer;
//begin
// SrcBmp.PixelFormat:=pf24Bit;
// for i := 0 to SrcBmp.Height - 1 do
// begin
//  SrcRGB := SrcBmp.GetScanLine(i);
//  if i > 0 then
//   SrcPreRGB:=SrcBmp.GetScanLine[i-1]
//  else
//   SrcPreRGB:=SrcBmp.GetScanLine(i);
//  for j := 0 to SrcBmp.Width - 1 do
//  begin
//   if j = 1 then Dec(SrcPreRGB);
//   Value:=SrcRGB.R+(SrcRGB.R-SrcPreRGB.R) div 2;
//   Value:=Max(0,Value);
//   Value:=Min(255,Value);
//   SrcRGB.R:=value;
//   Value:=SrcRGB.G+(SrcRGB.G-SrcPreRGB.G) div 2;
//   Value:=Max(0,Value);
//   Value:=Min(255,Value);
//   SrcRGB.G:=value;
//   Value:=SrcRGB.B+(SrcRGB.B-SrcPreRGB.B) div 2;
//   Value:=Max(0,Value);
//   Value:=Min(255,Value);
//   SrcRGB.B:=value;
//   Inc(SrcRGB);
//   Inc(SrcPreRGB);
//  end;
// end;
//end;


// [图像的旋转和翻转]
//以下代码用ScanLine配合指针移动实现，用于24位色！
////旋转90度
//procedure Rotate90(const Bitmap:TBitmap);
//var
// i,j:Integer;
// rowIn,rowOut:PAlphaColorRec;
// Bmp:TBitmap;
// Width,Height:Integer;
//begin
// Bmp:=TBitmap.Create;
// Bmp.Width := Bitmap.Height;
// Bmp.Height := Bitmap.Width;
// Bmp.PixelFormat := pf24bit;
// Width:=Bitmap.Width-1;
// Height:=Bitmap.Height-1;
// for j := 0 to Height do
// begin
//  rowIn := Bitmap.GetScanLine[j];
//  for i := 0 to Width do
//  begin
//   rowOut := Bmp.GetScanLine(i);
//   Inc(rowOut,Height - j);
//   rowOut^ := rowIn^;
//   Inc(rowIn);
//  end;
// end;
// Bitmap.Assign(Bmp);
//end;
////旋转180度
//procedure Rotate180(const Bitmap:TBitmap);
//var
// i,j:Integer;
// rowIn,rowOut:PAlphaColorRec;
// Bmp:TBitmap;
// Width,Height:Integer;
//begin
// Bmp:=TBitmap.Create;
// Bmp.Width := Bitmap.Width;
// Bmp.Height := Bitmap.Height;
// Bmp.PixelFormat := pf24bit;
// Width:=Bitmap.Width-1;
// Height:=Bitmap.Height-1;
// for j := 0 to Height do
// begin
//  rowIn := Bitmap.GetScanLine[j];
//  for i := 0 to Width do
//  begin
//   rowOut := Bmp.GetScanLine[Height - j];
//   Inc(rowOut,Width - i);
//   rowOut^ := rowIn^;
//   Inc(rowIn);
//  end;
// end;
// Bitmap.Assign(Bmp);
//end;
////旋转270度
//procedure Rotate270(const Bitmap:TBitmap);
//var
// i,j:Integer;
// rowIn,rowOut:PAlphaColorRec;
// Bmp:TBitmap;
// Width,Height:Integer;
//begin
// Bmp:=TBitmap.Create;
// Bmp.Width := Bitmap.Height;
// Bmp.Height := Bitmap.Width;
// Bmp.PixelFormat := pf24bit;
// Width:=Bitmap.Width-1;
// Height:=Bitmap.Height-1;
// for j := 0 to Height do
// begin
//  rowIn := Bitmap.GetScanLine[j];
//  for i := 0 to Width do
//  begin
//   rowOut := Bmp.GetScanLine[Width - i];
//   Inc(rowOut,j);
//   rowOut^ := rowIn^;
//   Inc(rowIn);
//  end;
// end;
// Bitmap.Assign(Bmp);
//end;
////任意角度
//function RotateBitmap(Bitmap:TBitmap;Angle:Integer;BackColor:TColor):TBitmap;
//var
// i,j,iOriginal,jOriginal,CosPoint,SinPoint : integer;
// RowOriginal,RowRotated : PAlphaColorRec;
// SinTheta,CosTheta : Extended;
// AngleAdd : integer;
//begin
// Result:=TBitmap.Create;
// Result.PixelFormat := pf24bit;
// Result.Canvas.Brush.Color:=BackColor;
// Angle:=Angle Mod 360;
// if Angle<0 then Angle:=360-Abs(Angle);
// if Angle=0 then
//  Result.Assign(Bitmap)
// else if Angle=90 then
// begin
//  Result.Assign(Bitmap);
//  Rotate90(Result);//如果是旋转90度，直接调用上面的代码
// end
// else if (Angle>90) and (Angle<180) then
// begin
//  AngleAdd:=90;
//  Angle:=Angle-AngleAdd;
// end
// else if Angle=180 then
// begin
//  Result.Assign(Bitmap);
//  Rotate180(Result);//如果是旋转180度，直接调用上面的过程
// end
// else if (Angle>180) and (Angle<270) then
// begin
//  AngleAdd:=180;
//  Angle:=Angle-AngleAdd;
// end
// else if Angle=270 then
// begin
//  Result.Assign(Bitmap);
//  Rotate270(Result);//如果是旋转270度，直接调用上面的过程
// end
// else if (Angle>270) and (Angle<360) then
// begin
//  AngleAdd:=270;
//  Angle:=Angle-AngleAdd;
// end
// else
//  AngleAdd:=0;
// if (Angle>0) and (Angle<90) then
// begin
// SinCos((Angle + AngleAdd) * Pi / 180, SinTheta, CosTheta);
// if (SinTheta * CosTheta) < 0 then
// begin
//  Result.Width := Round(Abs(Bitmap.Width * CosTheta - Bitmap.Height * SinTheta));
//  Result.Height := Round(Abs(Bitmap.Width * SinTheta - Bitmap.Height * CosTheta));
// end
// else
// begin
//  Result.Width := Round(Abs(Bitmap.Width * CosTheta + Bitmap.Height * SinTheta));
//  Result.Height := Round(Abs(Bitmap.Width * SinTheta + Bitmap.Height * CosTheta));
// end;
// CosTheta:=Abs(CosTheta);
// SinTheta:=Abs(SinTheta);
// if (AngleAdd=0) or (AngleAdd=180) then
// begin
//  CosPoint:=Round(Bitmap.Height*CosTheta);
//  SinPoint:=Round(Bitmap.Height*SinTheta);
// end
// else
// begin
//  SinPoint:=Round(Bitmap.Width*CosTheta);
//  CosPoint:=Round(Bitmap.Width*SinTheta);
// end;
// for j := 0 to Result.Height-1 do
// begin
//  RowRotated := Result.Scanline[j];
//  for i := 0 to Result.Width-1 do
//  begin
//   Case AngleAdd of
//    0:
//    begin
//     jOriginal := Round((j+1)*CosTheta-(i+1-SinPoint)*SinTheta)-1;
//     iOriginal := Round((i+1)*CosTheta-(CosPoint-j-1)*SinTheta)-1;
//    end;
//    90:
//    begin
//     iOriginal := Round((j+1)*SinTheta-(i+1-SinPoint)*CosTheta)-1;
//     jOriginal := Bitmap.Height-Round((i+1)*SinTheta-(CosPoint-j-1)*CosTheta);
//    end;
//    180:
//    begin
//     jOriginal := Bitmap.Height-Round((j+1)*CosTheta-(i+1-SinPoint)*SinTheta);
//     iOriginal := Bitmap.Width-Round((i+1)*CosTheta-(CosPoint-j-1)*SinTheta);
//    end;
//    270:
//    begin
//     iOriginal := Bitmap.Width-Round((j+1)*SinTheta-(i+1-SinPoint)*CosTheta);
//     jOriginal := Round((i+1)*SinTheta-(CosPoint-j-1)*CosTheta)-1;
//    end;
//   end;
//   if (iOriginal >= 0) and (iOriginal <= Bitmap.Width-1)and
//     (jOriginal >= 0) and (jOriginal <= Bitmap.Height-1)
//   then
//   begin
//    RowOriginal := Bitmap.Scanline[jOriginal];
//    Inc(RowOriginal,iOriginal);
//    RowRotated^ := RowOriginal^;
//    Inc(RowRotated);
//   end
//   else
//   begin
//    Inc(RowRotated);
//   end;
//  end;
// end;
// end;
//end;
////水平翻转
//procedure FlipHorz(const Bitmap:TBitmap);
//var
// i,j:Integer;
// rowIn,rowOut:PAlphaColorRec;
// Bmp:TBitmap;
// Width,Height:Integer;
//begin
// Bmp:=TBitmap.Create;
// Bmp.Width := Bitmap.Width;
// Bmp.Height := Bitmap.Height;
// Bmp.PixelFormat := pf24bit;
// Width:=Bitmap.Width-1;
// Height:=Bitmap.Height-1;
// for j := 0 to Height do
// begin
//  rowIn := Bitmap.GetScanLine[j];
//  for i := 0 to Width do
//  begin
//   rowOut := Bmp.GetScanLine[j];
//   Inc(rowOut,Width - i);
//   rowOut^ := rowIn^;
//   Inc(rowIn);
//  end;
// end;
// Bitmap.Assign(Bmp);
//end;
////垂直翻转
//procedure FlipVert(const Bitmap:TBitmap);
//var
// i,j:Integer;
// rowIn,rowOut:PAlphaColorRec;
// Bmp:TBitmap;
// Width,Height:Integer;
//begin
// Bmp:=TBitmap.Create;
// Bmp.Width := Bitmap.Height;
// Bmp.Height := Bitmap.Width;
// Bmp.PixelFormat := pf24bit;
// Width:=Bitmap.Width-1;
// Height:=Bitmap.Height-1;
// for j := 0 to Height do
// begin
//  rowIn := Bitmap.GetScanLine[j];
//  for i := 0 to Width do
//  begin
//   rowOut := Bmp.GetScanLine[Height - j];
//   Inc(rowOut,i);
//   rowOut^ := rowIn^;
//   Inc(rowIn);
//  end;
// end;
// Bitmap.Assign(Bmp);
//end;


//[亮度、对比度、饱和度的调整]
//以下代码用ScanLine配合指针移动实现！
function Min(a, b: integer): integer;
begin
 if a < b then
  result := a
 else
  result := b;
end;
function Max(a, b: integer): integer;
begin
 if a > b then
  result := a
 else
  result := b;
end;
//亮度调整
procedure BrightnessChange(const SrcBmp:TBitmap;
//                          const DestBmp:TBitmap;
                          ValueChange:integer);
var
  i, j: integer;
  SrcRGB, DestRGB: PAlphaColorRec;
  SrcBmpData,DestBmpData : TBitmapData ;
begin
  if  SrcBmp.Map( TMapAccess.ReadWrite, SrcBmpData)  then
  begin


        DestBmpData:=srcBmpData;
//     if  DestBmp.Map( TMapAccess.ReadWrite, DestBmpData)  then
//     begin

        for i := 0 to SrcBmpData.Height - 1 do
        begin
          SrcRGB := SrcBmpData.GetScanLine(i);
          DestRGB := DestBmpData.GetScanLine(i);
          for j := 0 to SrcBmpData.Width - 1 do
          begin
             if ValueChange > 0 then
             begin
              DestRGB.R := Min(255, SrcRGB.R + ValueChange);
              DestRGB.G := Min(255, SrcRGB.G + ValueChange);
              DestRGB.B := Min(255, SrcRGB.B + ValueChange);
             end else begin
              DestRGB.R := Max(0, SrcRGB.R + ValueChange);
              DestRGB.G := Max(0, SrcRGB.G + ValueChange);
              DestRGB.B := Max(0, SrcRGB.B + ValueChange);
             end;
             Inc(SrcRGB);
             Inc(DestRGB);
          end;
        end;

//       DestBmp.Unmap(DestBmpData);
//     end;
     SrcBmp.Unmap(SrcBmpData);
  end;

end;


//对比度调整
procedure ContrastChange(const SrcBmp:TBitmap;
//                        const DestBmp:TBitmap;
                        ValueChange:integer);
var
 i, j: integer;
 SrcRGB, DestRGB: PAlphaColorRec;
  SrcBmpData,DestBmpData : TBitmapData ;
begin
  if  SrcBmp.Map( TMapAccess.ReadWrite, SrcBmpData)  then
  begin
        DestBmpData:=srcBmpData;
//     if  DestBmp.Map( TMapAccess.ReadWrite, DestBmpData)  then
//     begin

         for i := 0 to SrcBmpData.Height - 1 do
         begin
          SrcRGB := SrcBmpData.GetScanLine(i);
          DestRGB := DestBmpData.GetScanLine(i);
          for j := 0 to SrcBmpData.Width - 1 do
          begin
           if ValueChange>=0 then
           begin
           if SrcRGB.R >= 128 then
            DestRGB.R := Min(255, SrcRGB.R + ValueChange)
           else
            DestRGB.R := Max(0, SrcRGB.R - ValueChange);
           if SrcRGB.G >= 128 then
            DestRGB.G := Min(255, SrcRGB.G + ValueChange)
           else
            DestRGB.G := Max(0, SrcRGB.G - ValueChange);
           if SrcRGB.B >= 128 then
            DestRGB.B := Min(255, SrcRGB.B + ValueChange)
           else
            DestRGB.B := Max(0, SrcRGB.B - ValueChange);
           end
           else
           begin
           if SrcRGB.R >= 128 then
            DestRGB.R := Max(128, SrcRGB.R + ValueChange)
           else
            DestRGB.R := Min(128, SrcRGB.R - ValueChange);
           if SrcRGB.G >= 128 then
            DestRGB.G := Max(128, SrcRGB.G + ValueChange)
           else
            DestRGB.G := Min(128, SrcRGB.G - ValueChange);
           if SrcRGB.B >= 128 then
            DestRGB.B := Max(128, SrcRGB.B + ValueChange)
           else
            DestRGB.B := Min(128, SrcRGB.B - ValueChange);
           end;
           Inc(SrcRGB);
           Inc(DestRGB);
          end;
         end;

//       DestBmp.Unmap(DestBmpData);
//     end;
     SrcBmp.Unmap(SrcBmpData);
  end;
end;

//饱和度调整
procedure SaturationChange(const SrcBmp:TBitmap;
//                            const DestBmp:TBitmap;
                            ValueChange:integer);
var
 Grays: array[0..767] of Integer;
 Alpha: array[0..255] of Word;
 Gray, x, y: Integer;
 SrcRGB,DestRGB: PAlphaColorRec;
 i: Byte;
  SrcBmpData,DestBmpData : TBitmapData ;
begin
  if  SrcBmp.Map( TMapAccess.ReadWrite, SrcBmpData)  then
  begin

        DestBmpData:=srcBmpData;
//     if  DestBmp.Map( TMapAccess.ReadWrite, DestBmpData)  then
//     begin

        ValueChange:=ValueChange+255;
        for i := 0 to 255 do
         Alpha[i] := (i * ValueChange) Shr 8;
        x := 0;
        for i := 0 to 255 do
        begin
         Gray := i - Alpha[i];
         Grays[x] := Gray;
         Inc(x);
         Grays[x] := Gray;
         Inc(x);
         Grays[x] := Gray;
         Inc(x);
        end;
        for y := 0 to SrcBmpData.Height - 1 do
        begin
         SrcRGB := SrcBmpData.GetScanLine(Y);
         DestRGB := DestBmpData.GetScanLine(Y);
         for x := 0 to SrcBmpData.Width - 1 do
         begin
          Gray := Grays[SrcRGB.R + SrcRGB.G + SrcRGB.B];
          if Gray + Alpha[SrcRGB.R]>0 then
           DestRGB.R := Min(255,Gray + Alpha[SrcRGB.R])
          else
           DestRGB.R := 0;
          if Gray + Alpha[SrcRGB.G]>0 then
           DestRGB.G := Min(255,Gray + Alpha[SrcRGB.G])
          else
           DestRGB.G := 0;
          if Gray + Alpha[SrcRGB.B]>0 then
           DestRGB.B := Min(255,Gray + Alpha[SrcRGB.B])
          else
           DestRGB.B := 0;
          Inc(SrcRGB);
          Inc(DestRGB);
         end;
        end;

//       DestBmp.Unmap(DestBmpData);
//     end;
     SrcBmp.Unmap(SrcBmpData);
  end;
end;



//RGB调整
procedure RGBChange(const SrcBmp:TBitmap;
                    //const DestBmp:TBitmap;
                    RedChange,GreenChange,BlueChange:integer);
var
 SrcRGB, DestRGB: PAlphaColorRec;
 i,j:integer;
  SrcBmpData,DestBmpData : TBitmapData ;
begin
  if  SrcBmp.Map( TMapAccess.ReadWrite, SrcBmpData)  then
  begin


        DestBmpData:=srcBmpData;
//     if  DestBmp.Map( TMapAccess.ReadWrite, DestBmpData)  then
//     begin


       for i := 0 to SrcBmpData.Height- 1 do
       begin
        SrcRGB := SrcBmpData.GetScanLine(i);
        DestRGB :=DestBmpData.GetScanLine(i);



        for j := 0 to SrcBmpData.Width - 1 do
        begin


          if DestRGB.A>50 then
          begin

            {$IF DEFINED(ANDROID) OR DEFINED(IOS)}
           if RedChange> 0 then
            DestRGB.R := Min(255, SrcRGB.R + BlueChange)
           else
            DestRGB.R := Max(0, SrcRGB.R + BlueChange);

           if GreenChange> 0 then
            DestRGB.G := Min(255, SrcRGB.G + GreenChange)
           else
            DestRGB.G := Max(0, SrcRGB.G + GreenChange);

           if BlueChange> 0 then
            DestRGB.B := Min(255, SrcRGB.B + RedChange)
           else
            DestRGB.B := Max(0, SrcRGB.B + RedChange);
          {$ELSE}
           if RedChange> 0 then
            DestRGB.R := Min(255, SrcRGB.R + RedChange)
           else
            DestRGB.R := Max(0, SrcRGB.R + RedChange);

           if GreenChange> 0 then
            DestRGB.G := Min(255, SrcRGB.G + GreenChange)
           else
            DestRGB.G := Max(0, SrcRGB.G + GreenChange);

           if BlueChange> 0 then
            DestRGB.B := Min(255, SrcRGB.B + BlueChange)
           else
            DestRGB.B := Max(0, SrcRGB.B + BlueChange);
          {$IFEND}
          end;


         Inc(SrcRGB);
         Inc(DestRGB);
        end;


       end;

//       DestBmp.Unmap(DestBmpData);
//     end;
     SrcBmp.Unmap(SrcBmpData);
  end;
end;


//[颜色调整]
////RGB<=>BGR
//procedure RGB2BGR(const Bitmap:TBitmap);
//var
// X: Integer;
// Y: Integer;
// PRGB: PAlphaColorRec;
// Color: Byte;
//begin
// for Y := 0 to (Bitmap.Height - 1) do
// begin
//  for X := 0 to (Bitmap.Width - 1) do
//  begin
//   Color := PRGB^.R;
//   PRGB^.R := PRGB^.B;
//   PRGB^.B := Color;
//   Inc(PRGB);
//  end;
//  end
// end;
//end;


////灰度化(加权)
//procedure Grayscale(const Bitmap:TBitmap);
//var
// X: Integer;
// Y: Integer;
// PRGB: PAlphaColorRec;
// Gray: Byte;
//begin
// for Y := 0 to (Bitmap.Height - 1) do
// begin
//  PRGB := Bitmap.GetScanLine(Y);
//  for X := 0 to (Bitmap.Width - 1) do
//  begin
//   Gray := (77 * Red + 151 * Green + 28 * Blue) shr 8;
//   PRGB^.R:=Gray;
//   PRGB^.G:=Gray;
//   PRGB^.B:=Gray;
//   Inc(PRGB);
//  end;
// end;
//end;
  {$ENDIF FMX}

end.
