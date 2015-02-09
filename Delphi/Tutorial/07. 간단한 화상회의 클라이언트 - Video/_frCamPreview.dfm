object frCamPreview: TfrCamPreview
  Left = 0
  Top = 0
  Width = 240
  Height = 180
  Color = clBlack
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 32
    Top = 20
  end
end
