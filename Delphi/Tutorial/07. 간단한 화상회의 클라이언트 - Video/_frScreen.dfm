object frScreen: TfrScreen
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  ParentBackground = False
  TabOrder = 0
  object Image: TImage
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    Center = True
    ExplicitTop = -3
  end
  object Timer: TTimer
    Interval = 10
    OnTimer = TimerTimer
    Left = 148
    Top = 108
  end
end
