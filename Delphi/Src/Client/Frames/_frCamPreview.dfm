object frCamPreview: TfrCamPreview
  Left = 0
  Top = 0
  Width = 800
  Height = 600
  Color = clBlack
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  OnResize = FrameResize
  object plClient: TPanel
    Left = 0
    Top = 41
    Width = 800
    Height = 559
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 636
    ExplicitHeight = 427
  end
  object BitmapTile1: TBitmapTile
    Left = 0
    Top = 0
    Width = 800
    Height = 41
    Align = alTop
    Bitmap.Data = {
      F6000000424DF600000000000000360000002800000008000000080000000100
      180000000000C0000000C40E0000C40E000000000000000000001F1F1F1F1F1F
      1C1C1C0303030303031C1C1C1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1C1C1C1C1C
      1C1F1F1F1F1F1F1F1F1F1C1C1C1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1C
      1C1C0303031C1C1C1F1F1F1F1F1F1F1F1F1F1F1F1C1C1C0303030303031C1C1C
      1F1F1F1F1F1F1F1F1F1F1F1F1C1C1C0303031C1C1C1F1F1F1F1F1F1F1F1F1F1F
      1F1F1F1F1F1F1F1C1C1C1F1F1F1F1F1F1F1F1F1C1C1C1C1C1C1F1F1F1F1F1F1F
      1F1F1F1F1F1F1F1F1C1C1C0303030303031C1C1C1F1F1F1F1F1F}
    ExplicitWidth = 636
    object btCamOn: TButton
      Left = 8
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Cam On'
      TabOrder = 0
      OnClick = btCamOnClick
    end
    object btCamOff: TButton
      Left = 84
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Cam Off'
      TabOrder = 1
      OnClick = btCamOffClick
    end
  end
  object Timer: TTimer
    Interval = 100
    OnTimer = TimerTimer
    Left = 72
    Top = 344
  end
end
