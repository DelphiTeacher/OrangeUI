//控件可以使用的平台声明
//单元中一定要引用Classes单元,不然在其他平台拖不到界面上去

  {$IFDEF FMX}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSSimulator or pidiOSDevice32 or pidiOSDevice64 or pidAndroid or pidAndroid64)]
  {$ENDIF}
