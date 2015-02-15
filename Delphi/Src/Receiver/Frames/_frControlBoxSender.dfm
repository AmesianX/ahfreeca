object frControlBoxSender: TfrControlBoxSender
  Left = 0
  Top = 0
  Width = 240
  Height = 212
  Color = clBlack
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object BitmapTile1: TBitmapTile
    Left = 0
    Top = 180
    Width = 240
    Height = 32
    Align = alBottom
    Bitmap.Data = {
      46010000424D4601000000000000360000002800000002000000220000000100
      1800000000001001000000000000000000000000000000000000C5C5C5C5C5C5
      0000C6C6C6C6C6C60000C7C7C7C7C7C70000C9C9C9C9C9C90000CACACACACACA
      0000CCCCCCCCCCCC0000CDCDCDCDCDCD0000CFCFCFCFCFCF0000D1D1D1D1D1D1
      0000D3D3D3D3D3D30000D5D5D5D5D5D50000D7D7D7D7D7D70000D9D9D9D9D9D9
      0000DBDBDBDBDBDB0000DDDDDDDDDDDD0000DFDFDFDFDFDF0000E1E1E1E1E1E1
      0000E3E3E3E3E3E30000E5E5E5E5E5E50000E7E7E7E7E7E70000E9E9E9E9E9E9
      0000EBEBEBEBEBEB0000EDEDEDEDEDED0000EFEFEFEFEFEF0000F1F1F1F1F1F1
      0000F3F3F3F3F3F30000F5F5F5F5F5F50000F6F6F6F6F6F60000F8F8F8F8F8F8
      0000F9F9F9F9F9F90000FBFBFBFBFBFB0000FCFCFCFCFCFC0000FDFDFDFDFDFD
      0000FEFEFEFEFEFE0000}
    object LevelMeterBack: TShape
      Tag = 121
      Left = 38
      Top = 22
      Width = 156
      Height = 5
      Brush.Color = 25600
      Pen.Color = 25600
    end
    object LevelMeter: TShape
      Tag = 100
      Left = 38
      Top = 22
      Width = 156
      Height = 5
      Brush.Color = 1701917
      Pen.Color = 1701917
    end
    object lbVolume: TLabel
      Left = 200
      Top = 8
      Width = 36
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = '10%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object btMic: TSwitchButton
      Left = 0
      Top = 5
      Width = 32
      Height = 24
      Hint = #53364#47533#54616#49884#47732' '#51020#49548#44144#44032' '#46121#45768#45796'.'
      ShowHint = True
      OnClick = btMicClick
      Bitmap.Data = {
        36360000424D36360000000000003600000028000000C0000000180000000100
        1800000000000036000000000000000000000000000000000000C9C9C9C9C9C9
        C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9
        C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9
        C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C8C8C8B8B8B8
        AEAEAEABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB
        ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB
        ABABABABABABABABABABABABABABABABABAEAEAEB8B8B8C8C8C8CACACADBDBDB
        E6E6E6E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E6E6E6DBDBDBCACACAC9C9C9C9C9C9
        C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9
        C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9
        C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C8C8C8B8B8B8
        AEAEAEABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB
        ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB
        ABABABABABABABABABABABABABABABABABAEAEAEB8B8B8C8C8C8CACACADBDBDB
        E6E6E6E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E6E6E6DBDBDBCACACACBCBCBCBCBCB
        CBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCB
        CBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCB
        CBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBBABABA999999
        8C8C8C8989898989898989898989898989898989898989898989898989898989
        8989898989898989898989898989898989898989898989898989898989898989
        89898989898989898989898989898989898C8C8C999999B9B9B9DADAD9A4A4A4
        7D7D7D6E6D6C77777671706E7777767676767575757271717878777272717777
        7773727276767575757575757573737275757575757477777677767677777675
        75737575757373727575757574747474737D7D7DA8A8A8D9D9D9CBCBCBCBCBCB
        CBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCB
        CBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCB
        CBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBCBBABABA999999
        8C8C8C8989898989898989898989898989898989898989898989898989898989
        8989898989898989898989898989898989898989898989898989898989898989
        89898989898989898989898989898989898C8C8C999999B9B9B9DADAD9A4A4A4
        7D7D7D6E6D6C77777671706E7777767676767575757271717878777272717777
        7773727276767575757575757573737275757575757477777677767677777675
        75737575757373727575757574747474737D7D7DA8A8A8D9D9D9CDCDCDCDCDCD
        CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCD
        CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCD
        CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCD9C9C9CBCBCBC
        F4F4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F4BCBCBC9B9B9BAAAAA97D7D7C
        8685858A8A898786858C8B8B8987878C8B8B8B8B8A8B8B8B8C8C8B8B8B8B8281
        808282827E7D7C8080807C7B7B8080808282828382827F7E7D8C8B8B8786858E
        8E8D8F8E8E8C8B8B8A89878E8E8C8989888282827C7A7AAAAAAACDCDCDCDCDCD
        CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCD
        CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCD
        CDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCDCD9C9C9CBCBCBC
        F4F4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F4BCBCBC9B9B9BAAAAA97D7D7C
        8685858A8A898786858C8B8B8987878988888585848888888C8C8B8B8B8B8281
        808282827E7D7C8080807C7B7B8080808282828382827F7E7D8C8B8B8786858E
        8E8D8F8E8E8C8B8B8A89878E8E8C8989888282827C7A7AAAAAAACECECECECECE
        CECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEEBEB
        EBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBCECECECECECECE
        CECECECECECECECECECECECECECECECECECECECECECECECECECE8C8C8CF5F5F5
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F58C8C8C888886868584
        9190909594939898989A9A9A9A99999695949999989494929898988F8E8D8686
        867F7F7F7D7D7D7171707474737372727D7D7D7A79798686868C8B8A99989894
        92929A9A9A91908E9A9A9A9898989998988D8B8A898887868685CECECECECECE
        CECECECECECECECECECECECECECECECECECEEBEBEBCECECECECECECECECEEBEB
        EBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBCECECECECECECE
        CECECECECECECECECECECECECECECECECECECECECECECECECECE8C8C8CF5F5F5
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F58C8C8C888886868584
        9190909594939898989A9A9A9A9999908F8E8989898888869595958F8E8D8686
        867F7F7F7D7D7D7171707474737372727D7D7D7A79798686868C8B8A99989894
        92929A9A9A91908E9A9A9A9898989998988D8B8A898887868685D0D0D0D0D0D0
        D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D05E5E
        5D6564646A6A6A63636261616162605F6969686666665E5D5DD0D0D0D0D0D0D0
        D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0898989F3F3F3
        ECECECEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA3939
        393D3D3C4141413B3B3A3C3B3B3A3A394040403F3F3F3A3939EAEAEAEAEAEAEA
        EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAECECECF3F3F38989898180808D8D8D
        8C8B88989897929291999898969594989797989898969595989796959595C6C6
        C5C7C6C6C4C3C3C6C6C6C6C6C6C7C7C6C3C2C2C7C6C6C3C3C296959597969698
        9797908F8C9696959191909998989190909594948A8A89828282D0D0D0D0D0D0
        D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0545353ECECECD0D0D0D0D0D06161
        616665646A6A6A63636261616162605F6969686666665E5D5DD0D0D0D0D0D0D0
        D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0D0898989F3F3F3
        ECECECEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA333333F7F7F7EAEAEAEAEAEA3B3B
        3B3E3E3C4141413B3B3A3C3B3B3A3A394040403F3F3F3A3939EAEAEAEAEAEAEA
        EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAECECECF3F3F38989898180808D8D8D
        8C8B88989897929291999898969594959494C6C6C68483838C8B8A929292C6C6
        C5C7C6C6C4C3C3C6C6C6C6C6C6C7C7C6C3C2C2C7C6C6C3C3C296959597969698
        9797908F8C9696959191909998989190909594948A8A89828282D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        D2D5D5D5E2E2E27B7A7A807E7E7C7C7CE2E2E2D5D5D5D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2898989E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4
        E4E6E6E6EEEEEE4B4B4B4D4C4C4D4D4CEEEEEEE6E6E6E4E4E4E4E4E4E4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E48989898180808A8987
        93939295959497969690908E969595939290979796949392949393959595908F
        8F838282787878C2C2C1C5C5C5C4C4C37A7979868585908F8F8D8D8C9696968F
        8E8D9595949595949796969291909595949291908C8C8C807F7FD2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D25B5B5AEDEDEDD2D2D2D2D2
        D2D5D5D5E2E2E27B7A7A807E7E7C7C7CE2E2E2D5D5D5D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2898989E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4373737F4F4F4E4E4E4E4E4
        E4E6E6E6EEEEEE4B4B4B4D4C4C4D4D4CEEEEEEE6E6E6E4E4E4E4E4E4E4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E48989898180808A8987
        93939295959497969690908E969595939290949493C4C4C38281818989898D8C
        8C838282787878C2C2C1C5C5C5C4C4C37A7979868585908F8F8D8D8C9696968F
        8E8D9595949595949796969291909595949291908C8C8C807F7FD4D4D4D4D4D4
        D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4DEDE
        DEDBDBDB9A9A9A6B6A6A7A7A796D6D6C9C9C9BDBDBDBDEDEDED4D4D4D4D4D4D4
        D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4898989E0E0E0
        E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E7E7
        E7DCDCDC8686864141404A4A4A424242878786DCDCDCE7E7E7E0E0E0E0E0E0E0
        E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E08989897E7D7C8C8C8B
        8887859292928C8B8B93939295959492929192919094939391908F8D8D8C7E7D
        7D7C7B7BA1A1A0C4C4C3C4C3C3C3C3C29D9C9C7D7C7C7B7A798E8D8D8D8C8B94
        939391908F9292928E8C8C92929292919191919086858480807FD4D4D4D4D4D4
        D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D45F5F5EEEEEEEDEDE
        DEDBDBDB9A9A9A6B6A6A7A7A796D6D6C9C9C9BDBDBDBDEDEDED4D4D4D4D4D4D4
        D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4898989E0E0E0
        E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E03A3A39F3F3F3E7E7
        E7DCDCDC8686864141404A4A4A424242878786DCDCDCE7E7E7E0E0E0E0E0E0E0
        E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E08989897E7D7C8C8C8B
        8887859292928C8B8B939392959594929291929190919090C3C3C27E7E7D7877
        777C7B7BA1A1A0C4C4C3C4C3C3C3C3C29D9C9C7D7C7C7B7A798E8D8D8D8C8B94
        939391908F9292928E8C8C92929292919191919086858480807FD6D6D6D6D6D6
        D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6DCDCDCB7B7
        B76867676C6B69555555494847555554676766686767B6B6B6DCDCDCD6D6D6D6
        D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6898989DFDFDF
        DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFE4E4E4ACAC
        AC4343434140403333332C2C2B3333323F3E3E434343ABABABE4E4E4DFDFDFDF
        DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF8989897F7E7E888787
        90908F8C8C8A9292928D8C8B9393928A89889191909392928E8E8E7C7B7A908F
        8FBCBBBBC3C3C3BFBEBDC3C3C2C2C2C2C3C3C3BEBEBD8F8E8E7F7E7D8E8D8C91
        919092929091908F90908F9291909292928685848888887F7F7FD6D6D6D6D6D6
        D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6686868BABA
        B96B6B6B6F6E6D565656494948555554676766686767B6B6B6DCDCDCD6D6D6D6
        D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6898989DFDFDF
        DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF3F3F3FADAD
        AD4645454342423434342C2C2B3333323F3E3E434343ABABABE4E4E4DFDFDFDF
        DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF8989897F7E7E888787
        90908F8C8C8A9292928D8C8B9393928A89889191909392928B8B8BC0C0BF8D8D
        8DBBBBBAC3C3C3BFBEBDC3C3C2C2C2C2C3C3C3BEBEBD8F8E8E7F7E7D8E8D8C91
        919092929091908F90908F9291909292928685848888887F7F7FD9D9D9D9D9D9
        D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9C8C8C86B69
        69626160787878B6B6B6D9D9D9B6B6B6787878666665696969C9C9C9D9D9D9D9
        D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9898989E0E0E0
        E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0C2C2C24140
        403B3A3A676666B6B6B6E0E0E0B6B6B66666663F3E3E404040C3C3C3E0E0E0E0
        E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E08989897B7979868685
        858483908F8F9190909191908988878E8E8E8F8F8E919090848382888887C1C1
        C0C2C2C2A9A8A7989897858382999999ADADACC2C2C2C0C0C086868681807F8E
        8D8D8786858F8E8E9090908E8E8D8F8E8D8D8D8C8686857E7E7ED9D9D9D9D9D9
        D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9CBCBCA7573
        736D6C6B7F7E7EB7B7B7D9D9D9B6B6B6787878666665696969C9C9C9D9D9D9D9
        D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9D9898989E0E0E0
        E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0C4C4C44645
        454140406B6A6AB7B7B7E0E0E0B6B6B66666663F3E3E404040C3C3C3E0E0E0E0
        E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E0E08989897B7979868685
        858483908F8F9190909191908988878E8E8E8F8F8E919090848382888887C2C2
        C1C2C2C2A7A6A5969695858382999999ADADACC2C2C2C0C0C086868681807F8E
        8D8D8786858F8E8E9090908E8E8D8F8E8D8D8D8C8686857E7E7EDBDBDBDBDBDB
        DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB8E8E8E6C6A
        6A818181DBDBDBDBDBDBDBDBDBDBDBDBDBDBDB8483836A6A6A898989DBDBDBDB
        DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB898989E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E47373734140
        406C6C6BE4E4E4E4E4E4E4E4E4E4E4E4E4E4E4706F6F40403F6C6C6CE4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E48989897E7E7E7F7E7D
        8B89898E8C8C8F8E8E8D8C8B8C8C8B8D8C8C8D8D8C8C8B8A828281A7A7A6C1C1
        C1AAA9A98C8C8C8F8F8E8D8D8C8C8C8B898988A5A3A3C1C1C0AAAAAA8383828C
        8B8A8F8F8E8B8A888E8E8D8685848C8C8C898888878787787676DBDBDBDBDBDB
        DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB8F8F8F6E6C
        6C6B6B6BF1F1F1DBDBDBDBDBDBDBDBDBDBDBDB8483836A6A6A898989DBDBDBDB
        DBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDB898989E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E47373734242
        42404040F4F4F4E4E4E4E4E4E4E4E4E4E4E4E4706F6F40403F6C6C6CE4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E48989897E7E7E7F7E7D
        8B89898E8C8C8F8E8E8D8C8B8C8C8B8D8C8C8D8D8C8C8B8A828281A7A7A6C1C1
        C1BFBFBE7D7D7D8383828A8A898C8C8B898988A5A3A3C1C1C0AAAAAA8383828C
        8B8A8F8F8E8B8A888E8E8D8685848C8C8C898888878787787676DDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD706F6E6E6E
        6EC7C7C7DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDC7C7C76E6E6E727272DDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD898989E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E94A4A494242
        41CACACAE9E9E9E9E9E9E9E9E9E9E9E9E9E9E9CACACA4242414B4B4BE9E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9898989767573818181
        8686858988888988878D8D8C8685848C8C8B8A89888A8989817F7FBABABABCBB
        BB8C8B8B8483828A898982817F8B8B898A89898C8B8BBFBEBEBCBBBB7E7D7C8C
        8B8B8D8C8C8988888887858989888B8A8989898981807F7C7C7BDDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD706F6E6C6C
        6BC7C7C7646463F1F1F1DDDDDDDDDDDDDDDDDDC7C7C76E6E6E727272DDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD898989E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E94A4A494141
        41CACACA3C3C3CF6F6F6E9E9E9E9E9E9E9E9E9CACACA4242414B4B4BE9E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9898989767573818181
        8686858988888988878D8D8C8685848C8C8B8A89888A8989817F7FBABABABCBB
        BB898989BDBCBC7978787776758888868A89898C8B8BBFBEBEBCBBBB7E7D7C8C
        8B8B8D8C8C8988888887858989888B8A8989898981807F7C7C7BDFDFDFDFDFDF
        DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF6F6E6E7473
        72DEDEDEDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDEDEDE6E6D6C6F6E6EDFDFDFDF
        DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF898989EEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE4343434645
        45ECECECEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEECECEC424242434342EEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE8989897A79797A7A79
        8887878685848B8A8A8786868B8B8A8383818787868988877E7E7CBBBBBABEBE
        BD7575757D7C7C7B7A787C7B7B7B7A787F7E7E737171BFBFBFBDBCBC7F7F7E82
        818087878681807F8A8A898989888A8988838281838282787877DFDFDFDFDFDF
        DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF6F6E6E7473
        73DEDEDEDFDFDF6A6A69F2F2F2DFDFDFDFDFDFDEDEDE6E6D6C6F6E6EDFDFDFDF
        DFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDF898989EEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE4343434645
        45ECECECEEEEEE40403FF8F8F8EEEEEEEEEEEEECECEC424242434342EEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE8989897A79797A7A79
        8887878685848B8A8A8786868B8B8A8383818787868988877E7E7CBBBBBABEBE
        BD7575757A7979BDBDBC6F6E6E7675737F7E7E737171BFBFBFBDBCBC7F7F7E82
        818087878681807F8A8A898989888A8988838281838282787877E1E1E1E1E1E1
        E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E16C6C6B6969
        68F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F36B6B6A646362E1E1E1E1
        E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1898989F0F0F0
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F040403F3F3F
        3EF9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F94141403B3B3AF0F0F0F0
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F08989897877777E7E7D
        838281888686807F7E8786867F7E7D858484888787858484757473BDBCBCB9B9
        B8656564666564686767666665666565626260646462B9B9B8BEBEBD7A797988
        868685848389898881817F8988887D7C7B83828280807F757574E1E1E1E1E1E1
        E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E16C6C6B6969
        68F3F3F3F3F3F3F3F3F35F5F5FF3F3F3F3F3F3F3F3F36B6B6A646362E1E1E1E1
        E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1E1898989F0F0F0
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F040403F3F3F
        3EF9F9F9F9F9F9F9F9F9393939F9F9F9F9F9F9F9F9F94141403B3B3AF0F0F0F0
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F08989897877777E7E7D
        838281888686807F7E8786867F7E7D858484888787858484757473BDBCBCB9B9
        B8656564666564656565BDBDBD636262626260646462B9B9B8BEBEBD7A797988
        868685848389898881817F8988887D7C7B83828280807F757574E4E4E4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E46565656463
        62616161575756575756515050575756515050606060656463656564E4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4898989F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F33D3D3C3C3B
        3B3A3A3A3434343434343131313434343131303A39393C3C3B3D3D3CF3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F38989897473737D7C7B
        838382848383838382868483868686807F7E8686868483827E7D7DBCBCBCBDBD
        BDB9B9B8BEBDBDBBBBBABBBBBBBBBBBABDBDBDBDBDBCBCBCBCBBBABA7C7B7B84
        83828786868483838282817D7D7C83828281807F7F7F7F737271E4E4E4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E46565656463
        626161615858576363625C5B5B636362535251616060676665676766E4E4E4E4
        E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4898989F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F33D3D3C3C3B
        3B3A3A3A3535343B3B3B3837373B3B3B3131313A3A3A3E3E3D3E3E3DF3F3F3F3
        F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F38989897473737D7C7B
        838382848383838382868483868686807F7E8686868483827E7D7DBCBCBCBDBD
        BDB9B9B8BEBDBDBBBBBABBBBBBBBBBBABDBDBDBDBDBCBCBCBCBBBABA7C7B7B84
        83828786868483838282817D7D7C83828281807F7F7F7F737271E6E6E6E6E6E6
        E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E64443424E4E
        4D5453536464635757566160605958586363625353534D4C4C454545E6E6E6E6
        E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6898989F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F62929292F2F
        2E3232323C3C3B3534343A39393535353B3B3B3232322E2E2E292929F6F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6898989717070797979
        7D7D7C80807F7E7D7C808080838381807F7F81807F838383777675BDBCBCB9B9
        B8BBBABABBBBBABBBABAB9B9B8BABABABBBABABCBCBBB9B8B7BBBBBB79797783
        838282818081808081807F838181807F7F7E7D7D767574737372E6E6E6E6E6E6
        E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E64443424E4E
        4D545353646463575756616060595858646463575656525151494949E6E6E6E6
        E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6898989F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F62929292F2F
        2E3232323C3C3B3534343A39393535353B3B3B3434343131312C2C2CF6F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6898989717070797979
        7D7D7C80807F7E7D7C808080838381807F7F81807F838383777675BDBCBCB9B9
        B8BBBABABBBBBABBBABAB9B9B8BABABABBBABABCBCBBB9B8B7BBBBBB79797783
        838282818081808081807F838181807F7F7E7D7D767574737372E8E8E8E8E8E8
        E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
        E85A5A59F6F6F65D5D5CF6F6F65D5C5CF6F6F6595858E8E8E8E8E8E8E8E8E8E8
        E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8898989F9F9F9
        F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9
        F9373736FDFDFD383838FDFDFD383838FDFDFD363535F9F9F9F9F9F9F9F9F9F9
        F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F98989897272717A7A78
        80807F7F7E7D7E7D7D7E7D7C7F7E7E7675748282817E7E7D7E7E7E7A78787775
        75B6B6B5696968B7B6B6696969B9B9B9666565B9B9B87575747E7D7C7F7F7E83
        82827E7D7D7B7A79817F7F787776828181787876777676737272E8E8E8E8E8E8
        E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8
        E85A5A59F6F6F65D5D5CF6F6F65D5C5CF6F6F66B6A6AF6F6F6E8E8E8E8E8E8E8
        E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8E8898989F9F9F9
        F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9
        F9373736FDFDFD383838FDFDFD383838FDFDFD414040FDFDFDF9F9F9F9F9F9F9
        F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F98989897272717A7A78
        80807F7F7E7D7E7D7D7E7D7C7F7E7E7675748282817E7E7D7E7E7E7A78787775
        75B6B6B5696968B7B6B6696969B9B9B9666565B9B9B86969687473727C7C7B83
        82827E7D7D7B7A79817F7F787776828181787876777676737272EAEAEAEAEAEA
        EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA
        EA5C5B5B636363F7F7F7666565F7F7F76060605C5B5BEAEAEAEAEAEAEAEAEAEA
        EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA898989FBFBFB
        FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB
        FB3838373C3C3CFDFDFD3D3C3CFDFDFD3A3A39383837FBFBFBFBFBFBFBFBFBFB
        FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB8989896968687A7A79
        747372807D7D807E7E8181807B7A798181807B7A797D7C7C7877767C7B7B7978
        78B8B8B8B6B6B56B6B6BB9B8B86C6B6BB6B6B5B8B8B77878757D7D7C7A79787D
        7C7C7877767B7B7A807E7E7D7C7C7E7C7C7E7E7D757473717170EAEAEAEAEAEA
        EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA
        EA5C5B5B636363F7F7F7666565F7F7F7626261616060565656F7F7F7EAEAEAEA
        EAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEA898989FBFBFB
        FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB
        FB3838373C3C3CFDFDFD3D3C3CFDFDFD3B3B3A3B3B3A343433FDFDFDFBFBFBFB
        FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFB8989896968687A7A79
        747372807D7D807E7E8181807B7A798181807B7A797D7C7C7877767C7B7B7978
        78B8B8B8B6B6B56B6B6BB9B8B86C6B6BB6B6B5B8B8B7BABAB96E6E6D706F6E7A
        79797877767B7B7A807E7E7D7C7C7E7C7C7E7E7D757473717170ECECECECECEC
        ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
        EC6F6E6EF7F7F7626261F7F7F7616060F7F7F76C6B6BECECECECECECECECECEC
        ECECECECECECECECECECECECECECECECECECECECECECECECECEC898989FDFDFD
        FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD
        FD555555FEFEFE3A3A3AFEFEFE3A3939FEFEFE545353FDFDFDFDFDFDFDFDFDFD
        FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD8989896B6A6A737271
        7A7A787675747E7E7D7C7A797E7D7D7F7F7E7E7D7C7C7A797F7F7E7270707878
        76A9A9A8696969BABAB9656463B8B7B7686867ABAAAA7A78787F7E7E7D7A7A74
        73727F7F7E7877767A7A797A79787C7A7A7C7C7C777676686666ECECECECECEC
        ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
        EC6F6E6EF7F7F7626261F7F7F7616060F7F7F7666565ECECEC545453F7F7F7EC
        ECECECECECECECECECECECECECECECECECECECECECECECECECEC898989FDFDFD
        FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD
        FD555555FEFEFE3A3A3AFEFEFE3A3939FEFEFE505050FDFDFD323231FEFEFEFD
        FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD8989896B6A6A737271
        7A7A787675747E7E7D7C7A797E7D7D7F7F7E7E7D7C7C7A797F7F7E7270707878
        76A9A9A8696969BABAB9656463B8B7B7686867ABAAAA777575BAB9B96E6B6B6A
        6A697C7C7B7877767A7A797A79787C7A7A7C7C7C777676686666EEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEBCBCBC505050F6F6F65A5A59F6F6F64F4F4EB8B8B8EEEEEEEEEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE898989FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFBEBEBE303030FFFFFF343434FFFFFF2F2F2FB9B9B9FFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF898989636260757575
        7A7A797979787978777B78787574737C7B7B7B79787C7C7B7877777C7C7C7675
        738A8A88B3B3B3696666B6B5B5696968B9B8B88A898976757379787877767478
        78787979787C7C797978777B7B797472727B7A7A6D6D6B6C6C6CEEEEEEEEEEEE
        EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        EEBCBCBC505050F6F6F65A5A59F6F6F64F4F4EB8B8B8EEEEEEEEEEEE4F4F4FF8
        F8F8EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE898989FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFBEBEBE303030FFFFFF343434FFFFFF2F2F2FB9B9B9FFFFFFFFFFFF2F2F2FFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF898989636260757575
        7A7A797979787978777B78787574737C7B7B7B79787C7C7B7877777C7C7C7675
        738A8A88B3B3B3696666B6B5B5696968B9B8B88A8989767573767575B6B5B46C
        6C6C7474737C7C797978777B7B797472727B7A7A6D6D6B6C6C6CF0F0F0F0F0F0
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0
        F0F0F0F0BBBBBB6565644D4C4C676766BCBBBBF0F0F0F0F0F0F0F0F0F0F0F0F0
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0898989FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFBFBFBF555555303030565656BFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8989896A6A686E6D6C
        7775756F6F6E7A777776767577777672706F7A7A7A7675747A7A7872726F7877
        77767575888787A0A0A0B4B4B4A5A4A387878675747375757476757475757474
        7372777776726F6F7675757B7A7A7A7A7A6C6B6A737272656463F0F0F0F0F0F0
        F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0
        F0F0F0F0BBBBBB6565644D4C4C676766BCBBBBF0F0F0F0F0F0F0F0F0F0F0F043
        4343F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0898989FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFBFBFBF555555303030565656BFBFBFFFFFFFFFFFFFFFFFFFFFFFFF29
        2928FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8989896A6A686E6D6C
        7775756F6F6E7A777776767577777672706F7A7A7A7675747A7A7872726F7877
        77767575888787A0A0A0B4B4B4A5A4A3878786757473757574767574727271B4
        B4B3747473726F6F7675757B7A7A7A7A7A6C6B6A737272656463F2F2F2F2F2F2
        F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2
        F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2
        F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2898989FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF898989656363696868
        706E6D7171706E6C6C7776766B6A68757474747272777676706F6E7676756E6C
        6C727171706E6E777676767676757474706F6E72717175747272717177777674
        72726D6C6B7676767271707776767371707272716A6969676767F2F2F2F2F2F2
        F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2
        F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2
        F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2F2898989FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF898989656363696868
        706E6D7171706E6C6C7776766B6A68757474747272777676706F6E7676756E6C
        6C727171706E6E777676767676757474706F6E72717175747272717177777674
        72726D6C6B7676767271707776767371707272716A6969676767F4F4F4F4F4F4
        F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4
        F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4
        F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4909090F5F5F5
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F59090906665655E5C5C
        6666666B6B6A6F6F6E6E6D6B706F6F706E6D6F6F6E6E6D6B7070706B6B6A6E6E
        6D6A6968706F6E6F6E6D6F6E6E6E6D6B6D6D6D707070706E6E6E6D6B706E6E65
        65647070706F6F6D6D6D6B6C6A696B6A6A646362616060626161F4F4F4F4F4F4
        F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4
        F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4
        F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4909090F5F5F5
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F59090906665655E5C5C
        6666666B6B6A6F6F6E6E6D6B706F6F706E6D6F6F6E6E6D6B7070706B6B6A6E6E
        6D6A6968706F6E6F6E6D6F6E6E6E6D6B6D6D6D707070706E6E6E6D6B706E6E65
        65647070706F6F6D6D6D6B6C6A696B6A6A646362616060626161F6F6F6F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6BCBCBCBCBCBC
        F3F3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F3F3BCBCBCBCBCBC9B9A9A4E4D4D
        4D4C4A5A5A595959575C5C5A5D5C5C5D5D5C5A59575D5C5C5656545C5B5B5957
        575D5D5C5B5B5A5C5B5B5454545B5A5A5B5A595A5A595654545A5A595655545D
        5C5C5453515C5B5B5554545C5B5B5959585454544A49489C9B9BF6F6F6F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6
        F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6BCBCBCBCBCBC
        F3F3F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F3F3BCBCBCBCBCBC9B9A9A4E4D4D
        4D4C4A5A5A595959575C5C5A5D5C5C5D5D5C5A59575D5C5C5656545C5B5B5957
        575D5D5C5B5B5A5C5B5B5454545B5A5A5B5A595A5A595654545A5A595655545D
        5C5C5453515C5B5B5554545C5B5B5959585454544A49489C9B9BF7F7F7F7F7F7
        F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7
        F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7
        F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F4F4F4BEBEBE
        9595958989898989898989898989898989898989898989898989898989898989
        8989898989898989898989898989898989898989898989898989898989898989
        8989898989898989898989898989898989959595BEBEBEF4F4F4F3F3F3999999
        525252403F3F4241413F3E3D4343433E3C3C4343434141414343433E3C3C4343
        433F3F3E4341413D3C3C4343434141404343413E3D3C4343433E3D3C43434343
        43434141413C3C3C4141413E3E3C4240405453529A9A9AF3F3F3F7F7F7F7F7F7
        F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7
        F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7
        F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F4F4F4BEBEBE
        9595958989898989898989898989898989898989898989898989898989898989
        8989898989898989898989898989898989898989898989898989898989898989
        8989898989898989898989898989898989959595BEBEBEF4F4F4F3F3F3999999
        525252403F3F4241413F3E3D4343433E3C3C4343434141414343433E3C3C4343
        433F3F3E4341413D3C3C4343434141404343413E3D3C4343433E3D3C43434343
        43434141413C3C3C4141413E3E3C4240405453529A9A9AF3F3F3}
      BitmapCount = 6
      Center = True
      ClickEnabled = True
      ClickOnly = True
      SwitchOn = False
    end
    object Volume: TMusicTrackBar
      Left = 38
      Top = 4
      Width = 156
      Height = 15
      BitmapBackground.Data = {
        06030000424D060300000000000036000000280000000F0000000F0000000100
        180000000000D0020000120B0000120B00000000000000000000CFCFCFCFCFCF
        CFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCF
        CFCFCFCFCFCFCF000000D1D1D1D1D1D1D5D5D5E2E2E2EAEAEAEDEDEDEDEDEDED
        EDEDEDEDEDEDEDEDEAEAEAE2E2E2D5D5D5D1D1D1D1D1D1000000D3D3D3DADADA
        DADADA9A99997A7A7A7171717373726E6E6D7272727171717B7B7A9A9A99DADA
        DADADADAD3D3D3000000D8D8D8C7C7C77271717777777C7B7981818183828284
        8483828282818181797978777777706F6EC7C7C7D8D8D8000000D3D3D36F6E6E
        7878778382828C8B8B8887868C8C8B8585848A89898383828888878484837A79
        796B6B69D3D3D30000009898987171717A7A788787868382818A8A898989888C
        8C8B8A898889898881807F8685857877767373729A9999000000727272757573
        7F7E7E8686858A898981807F8B8A8A8583838887878A8A888787878483827F7F
        7E747372737372000000605F5E72717178777785838386858489898885848389
        8888868584878686807F7F8383827F7E7E737373636262000000686767636260
        7474737F7E7D8584848382818483838685858585848382818382827C7B7A7474
        7361605F6767670000008B8B8A59595868676773737271706F7E7C7C7E7D7C7E
        7D7C7D7C7B7E7E7D797878757474636362575656888888000000D0D0D0505050
        52525161605F6C6C6B6F6E6E7271716D6D6C7373716A69686C6C6B5C5C5B5453
        53505050D0D0D0000000E5E5E5B7B7B74545444545454F4E4E5756565554535B
        5B595959575757564E4D4C484747454444B7B6B6E5E5E5000000E7E7E7E7E7E7
        D2D2D27F7F7F4C4B4B3434343939393735353939393837374B4B4A7C7C7BD2D2
        D2E7E7E7E7E7E7000000E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9000000EBEBEBEBEBEB
        EBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEB
        EBEBEBEBEBEBEB000000}
      BitmapPositionBar.Data = {
        06030000424D060300000000000036000000280000000F0000000F0000000100
        180000000000D0020000120B0000120B00000000000000000000241CED241CED
        241CED241CED241CED241CED241CED241CED241CED241CED241CED241CED241C
        ED241CED241CED000000241CED241CED241CED241CED241CED241CED241CED24
        1CED241CED241CED241CED241CED241CED241CED241CED000000241CED241CED
        241CED404040404040404040404040404040404040404040404040404040241C
        ED241CED241CED000000241CED241CED404040B58A45E6991EFFA009FFA009FF
        A009FFA009FFA009E6991EB58A45404040241CED241CED000000241CED404040
        E19E25FFA90EFFA90EFFA90EFFA90EFFA90EFFA90EFFA90EFFA90EFFA90EE39F
        25404040241CED000000404040BB9851FFB315FFB315FFB315FFB315FFB315FF
        B315FFB315FFB315FFB315FFB315FFB315BB9951404040000000404040EDB62C
        FFBE1CFFBE1CFFBE1CFFBE1CFFBE1CFFBE1CFFBE1CFFBE1CFFBE1CFFBE1CFFBE
        1CEDB62B404040000000404040FCCE40FFC923FFC923FFC923FFC923FFC923FF
        C923FFC923FFC923FFC923FFC923FFC923FCCE40404040000000404040EBD891
        FFD42AFFD42AFFD42AFFD42AFFD42AFFD42AFFD42AFFD42AFFD42AFFD42AFFD4
        2AEBD891404040000000404040A9A9A8FFE764FFDF31FFDF31FFDF31FFDF31FF
        DF31FFDF31FFDF31FFDF31FFDF31FFE764A8A8A7404040000000241CED404040
        D4D4D3FFF5A6FFED60FFE93AFFE938FFE938FFE938FFE938FFED60FFF5A6D5D5
        D3404040241CED000000241CED241CED404040989898DCDCDCFDFDFDFFFFFFFF
        FFFFFFFFFFFFFFFFDCDBDB9A9999404040241CED241CED000000241CED241CED
        241CED404040404040404040404040404040404040404040404040404040241C
        ED241CED241CED000000241CED241CED241CED241CED241CED241CED241CED24
        1CED241CED241CED241CED241CED241CED241CED241CED000000241CED241CED
        241CED241CED241CED241CED241CED241CED241CED241CED241CED241CED241C
        ED241CED241CED000000}
      BitmapDownloader.Data = {
        06030000424D060300000000000036000000280000000F0000000F0000000100
        180000000000D0020000120B0000120B00000000000000000000CFCFCFCFCFCF
        CFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCFCF
        CFCFCFCFCFCFCF000000D1D1D1D1D1D1D5D5D5E2E2E2EAEAEAEDEDEDEDEDEDED
        EDEDEDEDEDEDEDEDEAEAEAE2E2E2D5D5D5D1D1D1D1D1D1000000D3D3D3DADADA
        CDCDCD7070704848483E3E3E3F3F3F3C3C3C3F3F3F3E3E3E494948707070CDCD
        CDDADADAD3D3D3000000D8D8D8AFAFAF41404041414144444247474748474748
        4848474747474747424242414141403F3FAFAFAFD8D8D8000000C7C7C73F3F3F
        4242414847474D4C4C4B4A4A4D4D4C4949484C4B4B4848474B4B4A4848484342
        423D3D3CC7C7C70000006F6F6F3E3E3E4343424A4A4A4847474C4C4B4B4B4B4D
        4D4C4C4B4B4B4B4B4746464A49494241413F3F3F71707000000044444440403F
        4645454A4A494C4B4B4746464C4C4C4948484B4A4A4C4C4B4A4A4A4848474646
        45403F3F4545440000003635353F3E3E4241414948484A49484B4B4B4948484B
        4B4B4A49484A4A4A4646464848474645453F3F3F3837370000003E3D3D363635
        40403F4645454948484847474848484A49494949484847474847474444434040
        3F3535343D3D3D0000006767663131303939393F3F3F3E3D3D45444445454445
        4544454444454545424242404040363636302F2F656565000000C5C5C52E2E2E
        2D2D2C3535343B3B3B3D3C3C3F3E3E3C3C3B3F3F3E3A3A393B3B3B3333322E2E
        2E2E2E2EC5C5C5000000E5E5E5A1A1A12727272626262B2B2B302F2F2F2E2E32
        323131313030302F2B2A2A282727272727A1A0A0E5E5E5000000E7E7E7E7E7E7
        C6C6C65D5D5D2E2D2D1D1D1D1F1F1F1E1D1D1F1F1F1F1E1E2D2D2D5A5A5AC6C6
        C6E7E7E7E7E7E7000000E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9
        E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9E9000000EBEBEBEBEBEB
        EBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEBEB
        EBEBEBEBEBEBEB000000}
      TransparentColorBackground = 33554687
      TransparentColorPositionBar = 35921133
      TransparentColorDownloader = 33554687
      Min = 0
      Max = 1000
      Position = 100
      Downloaded = 0
      OnChanged = VolumeChanged
    end
  end
  object Timer: TTimer
    Interval = 5
    OnTimer = TimerTimer
    Left = 108
    Top = 92
  end
end