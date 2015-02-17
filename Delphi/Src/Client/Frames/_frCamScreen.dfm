object frCamScreen: TfrCamScreen
  Left = 0
  Top = 0
  Width = 800
  Height = 600
  Color = clBlack
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  OnResize = FrameResize
  object Timer: TTimer
    Interval = 10
    OnTimer = TimerTimer
    Left = 388
    Top = 288
  end
end
