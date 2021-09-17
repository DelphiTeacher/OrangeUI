object FrameGroupDrawPicture: TFrameGroupDrawPicture
  Left = 0
  Top = 0
  Width = 193
  Height = 219
  TabOrder = 0
  object Label6: TLabel
    Left = 52
    Top = 12
    Width = 65
    Height = 16
    Caption = #32032#26448#21517#31216':'
  end
  object Button1: TButton
    Left = 52
    Top = 183
    Width = 75
    Height = 25
    Caption = #35774#32622
    TabOrder = 0
    OnClick = Button1Click
  end
  object ScrollBox1: TScrollBox
    Left = 5
    Top = 71
    Width = 185
    Height = 106
    TabOrder = 1
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 170
      Height = 93
      OnPaint = PaintBox1Paint
    end
  end
end
