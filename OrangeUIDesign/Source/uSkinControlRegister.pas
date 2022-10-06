//convert pas to utf8 by ¥
//FireMonkey控件注册单元
unit uSkinControlRegister;

interface
{$I FrameWork.inc}



uses
  Classes,


  uBinaryObjectList,

  {$IF CompilerVersion >= 30.0}
  FMX.Edit,
  {$IFEND}


//  AddPictureListSubFrame,

  uComponentTypeRegister;



procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OrangeUI_Component',OrangeUI_ComponentArray);
  RegisterComponents('OrangeUI_Control',OrangeUI_ControlArray);
  RegisterComponents('OrangeUI_Material',OrangeUI_MaterialArray);



  RegisterComponents('OrangeUI_Component',[TTestBinaryObjectListStore]);


  {$IF CompilerVersion >= 30.0}
  RegisterComponents('Standard',[
                                TEditButton,
                                TClearEditButton,
                                TPasswordEditButton,
                                TSearchEditButton,
                                TEllipsesEditButton,
                                TDropDownEditButton,
                                TSpinEditButton
                                ]);
  {$IFEND}



  //独立出来
//  RegisterComponents('NewOUI_Control',NewOrangeUI_ControlArray);

//  {$IFDEF VCL}
//  RegisterComponents('Standard',[TClearEditButton]);
//  {$ENDIF}
//
//  {$IFDEF FMX}

//  {$ENDIF}

//  RegisterClass(TFrameAddPictureListSub);

end;



end.
