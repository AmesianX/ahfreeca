object frChat: TfrChat
  Left = 0
  Top = 0
  Width = 314
  Height = 474
  TabOrder = 0
  object moMsgIn: TMemo
    Left = 0
    Top = 0
    Width = 314
    Height = 453
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 156
    ExplicitTop = 272
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
  object edMsgOut: TEdit
    Left = 0
    Top = 453
    Width = 314
    Height = 21
    Align = alBottom
    TabOrder = 1
    OnKeyPress = edMsgOutKeyPress
    ExplicitLeft = 100
    ExplicitTop = 332
    ExplicitWidth = 121
  end
end
