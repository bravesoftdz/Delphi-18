inherited IWfrmOnlineAndPay: TIWfrmOnlineAndPay
  Height = 1024
  ExplicitHeight = 1024
  DesignLeft = 8
  DesignTop = 8
  inherited IWRegionClient: TIWRegion
    Height = 949
    ExplicitHeight = 949
    inherited IWRegion1: TIWRegion
      Height = 919
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      ExplicitHeight = 919
      object IWRegion2: TIWRegion
        Left = 0
        Top = 0
        Width = 859
        Height = 47
        Cursor = crAuto
        RenderInvisibleControls = False
        Align = alTop
        BorderOptions.NumericWidth = 1
        BorderOptions.BorderWidth = cbwNumeric
        BorderOptions.Style = cbsSolid
        BorderOptions.Color = clNone
        Color = clNone
        ParentShowHint = False
        ShowHint = True
        ZIndex = 1000
        Splitter = False
        object IWLabel1: TIWLabel
          Left = 15
          Top = 13
          Width = 82
          Height = 16
          Cursor = crAuto
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = True
          StyleRenderOptions.RenderSize = True
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          Alignment = taLeftJustify
          BGColor = clNone
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          NoWrap = False
          ConvertSpaces = False
          HasTabOrder = False
          FriendlyName = 'IWLabel1'
          Caption = #36215#22987#26085#26399#65306
          RawText = False
        end
        object pSDate: TTIWDateSelector
          Left = 83
          Top = 9
          Width = 203
          Height = 24
          Cursor = crAuto
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = True
          StyleRenderOptions.RenderSize = True
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          BGColor = clNone
          Day = 1
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          Month = 1
          NameOfMonths.Strings = (
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12')
          ShowDay = True
          ShowYear = True
          Style = dpYearMonthDay
          TabOrder = 11
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object IWLabel3: TIWLabel
          Left = 248
          Top = 13
          Width = 82
          Height = 16
          Cursor = crAuto
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = True
          StyleRenderOptions.RenderSize = True
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          Alignment = taLeftJustify
          BGColor = clNone
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          NoWrap = False
          ConvertSpaces = False
          HasTabOrder = False
          FriendlyName = 'IWLabel1'
          Caption = #32467#26463#26085#26399#65306
          RawText = False
        end
        object pEDate: TTIWDateSelector
          Left = 309
          Top = 9
          Width = 203
          Height = 24
          Cursor = crAuto
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = True
          StyleRenderOptions.RenderSize = True
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          BGColor = clNone
          Day = 1
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          Month = 1
          NameOfMonths.Strings = (
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            '10'
            '11'
            '12')
          ShowDay = True
          ShowYear = True
          Style = dpYearMonthDay
          TabOrder = 12
          Year = 2010
          YearFrom = 2010
          YearTo = 2015
        end
        object IWBtnBuild: TIWButton
          Left = 515
          Top = 9
          Width = 75
          Height = 25
          Cursor = crAuto
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = True
          StyleRenderOptions.RenderSize = True
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          Caption = #29983#25104#22270#34920
          DoSubmitValidation = True
          Color = clBtnFace
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'IWBtnBuild'
          ScriptEvents = <>
          TabOrder = 13
          OnClick = IWBtnBuildClick
        end
        object IWButton6: TIWButton
          Left = 780
          Top = 8
          Width = 75
          Height = 25
          Cursor = crAuto
          Visible = False
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = True
          StyleRenderOptions.RenderSize = True
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          Caption = #35831#21247#28857#20987
          DoSubmitValidation = True
          Color = clBtnFace
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'IWButton1'
          ScriptEvents = <>
          TabOrder = 14
          OnClick = IWButton6Click
        end
        object IWAmdbMode: TIWCheckBox
          Left = 603
          Top = 12
          Width = 123
          Height = 19
          Cursor = crAuto
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = True
          StyleRenderOptions.RenderSize = True
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          Caption = #21382#21490#25968#25454#27169#24335
          Editable = True
          Font.Color = clWebBLUE
          Font.Size = 10
          Font.Style = [fsBold]
          SubmitOnAsyncEvent = True
          ScriptEvents = <>
          DoSubmitValidation = True
          Style = stNormal
          TabOrder = 17
          Checked = False
          FriendlyName = 'IWAmdbMode'
        end
      end
      object IWRegion3: TIWRegion
        Left = 0
        Top = 47
        Width = 859
        Height = 872
        Cursor = crAuto
        RenderInvisibleControls = False
        Align = alClient
        BorderOptions.NumericWidth = 1
        BorderOptions.BorderWidth = cbwNumeric
        BorderOptions.Style = cbsNone
        BorderOptions.Color = clNone
        Color = clNone
        ParentShowHint = False
        ShowHint = True
        ZIndex = 1000
        Splitter = False
        object TIWAdvChart1: TTIWAdvChart
          Left = 45
          Top = 475
          Width = 600
          Height = 371
          Cursor = crAuto
          Visible = False
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = True
          StyleRenderOptions.RenderSize = True
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          Chart.AxisMode = amAxisChartWidthHeight
          Chart.Background.Font.Charset = DEFAULT_CHARSET
          Chart.Background.Font.Color = clWindowText
          Chart.Background.Font.Height = -11
          Chart.Background.Font.Name = 'Tahoma'
          Chart.Background.Font.Style = []
          Chart.Bands.Distance = 2.000000000000000000
          Chart.CrossHair.CrossHairYValues.Position = [chYAxis]
          Chart.CrossHair.Distance = 0
          Chart.Legend.Font.Charset = DEFAULT_CHARSET
          Chart.Legend.Font.Color = clWindowText
          Chart.Legend.Font.Height = -11
          Chart.Legend.Font.Name = 'Tahoma'
          Chart.Legend.Font.Style = []
          Chart.Range.StartDate = 41194.689110960650000000
          Chart.Series = <
            item
              AutoRange = arCommon
              Pie.ValueFont.Charset = DEFAULT_CHARSET
              Pie.ValueFont.Color = clWindowText
              Pie.ValueFont.Height = -11
              Pie.ValueFont.Name = 'Tahoma'
              Pie.ValueFont.Style = []
              Pie.LegendFont.Charset = DEFAULT_CHARSET
              Pie.LegendFont.Color = clWindowText
              Pie.LegendFont.Height = -11
              Pie.LegendFont.Name = 'Tahoma'
              Pie.LegendFont.Style = []
              Annotations = <>
              CrossHairYValue.BorderWidth = 0
              CrossHairYValue.Font.Charset = DEFAULT_CHARSET
              CrossHairYValue.Font.Color = clWindowText
              CrossHairYValue.Font.Height = -11
              CrossHairYValue.Font.Name = 'Tahoma'
              CrossHairYValue.Font.Style = []
              CrossHairYValue.GradientSteps = 0
              CrossHairYValue.Visible = False
              LegendText = 'Serie 0'
              ShowInLegend = False
              Marker.MarkerType = mCircle
              Marker.MarkerColor = clRed
              Marker.MarkerSize = 6
              Marker.MarkerPicture.Data = {}
              Marker.MarkerColorTo = clWhite
              Name = 'Serie 0'
              ChartPattern.Data = {}
              ShowValue = True
              ValueFont.Charset = ANSI_CHARSET
              ValueFont.Color = clWindowText
              ValueFont.Height = -13
              ValueFont.Name = #23435#20307
              ValueFont.Style = []
              ValueFormat = '%g'
              ValueWidth = 10
              XAxis.DateTimeFont.Charset = DEFAULT_CHARSET
              XAxis.DateTimeFont.Color = clWindowText
              XAxis.DateTimeFont.Height = -11
              XAxis.DateTimeFont.Name = 'Tahoma'
              XAxis.DateTimeFont.Style = []
              XAxis.MajorFont.Charset = DEFAULT_CHARSET
              XAxis.MajorFont.Color = clWindowText
              XAxis.MajorFont.Height = -11
              XAxis.MajorFont.Name = 'Tahoma'
              XAxis.MajorFont.Style = []
              XAxis.MajorUnit = 1.000000000000000000
              XAxis.MajorUnitSpacing = 0
              XAxis.MinorFont.Charset = DEFAULT_CHARSET
              XAxis.MinorFont.Color = clWindowText
              XAxis.MinorFont.Height = -11
              XAxis.MinorFont.Name = 'Tahoma'
              XAxis.MinorFont.Style = []
              XAxis.MinorUnit = 1.000000000000000000
              XAxis.MinorUnitSpacing = 0
              XAxis.TextTop.Font.Charset = DEFAULT_CHARSET
              XAxis.TextTop.Font.Color = clWindowText
              XAxis.TextTop.Font.Height = -11
              XAxis.TextTop.Font.Name = 'Tahoma'
              XAxis.TextTop.Font.Style = []
              XAxis.TextBottom.Font.Charset = DEFAULT_CHARSET
              XAxis.TextBottom.Font.Color = clWindowText
              XAxis.TextBottom.Font.Height = -11
              XAxis.TextBottom.Font.Name = 'Tahoma'
              XAxis.TextBottom.Font.Style = []
              XAxis.TickMarkSize = 4
              YAxis.MajorFont.Charset = DEFAULT_CHARSET
              YAxis.MajorFont.Color = clWindowText
              YAxis.MajorFont.Height = -11
              YAxis.MajorFont.Name = 'Tahoma'
              YAxis.MajorFont.Style = []
              YAxis.MajorUnitSpacing = 0
              YAxis.MinorFont.Charset = DEFAULT_CHARSET
              YAxis.MinorFont.Color = clWindowText
              YAxis.MinorFont.Height = -11
              YAxis.MinorFont.Name = 'Tahoma'
              YAxis.MinorFont.Style = []
              YAxis.MinorUnitSpacing = 0
              YAxis.TextLeft.Font.Charset = DEFAULT_CHARSET
              YAxis.TextLeft.Font.Color = clWindowText
              YAxis.TextLeft.Font.Height = -11
              YAxis.TextLeft.Font.Name = 'Tahoma'
              YAxis.TextLeft.Font.Style = []
              YAxis.TextRight.Font.Charset = DEFAULT_CHARSET
              YAxis.TextRight.Font.Color = clWindowText
              YAxis.TextRight.Font.Height = -11
              YAxis.TextRight.Font.Name = 'Tahoma'
              YAxis.TextRight.Font.Style = []
              YAxis.TickMarkSize = 4
              SelectedMarkSize = 0
              BarValueTextFont.Charset = DEFAULT_CHARSET
              BarValueTextFont.Color = clWindowText
              BarValueTextFont.Height = -11
              BarValueTextFont.Name = 'Tahoma'
              BarValueTextFont.Style = []
              XAxisGroups = <>
              SerieType = stNormal
            end>
          Chart.Title.Alignment = taCenter
          Chart.Title.Font.Charset = GB2312_CHARSET
          Chart.Title.Font.Color = clBlue
          Chart.Title.Font.Height = -19
          Chart.Title.Font.Name = #21326#25991#20013#23435
          Chart.Title.Font.Style = [fsBold]
          Chart.Title.Position = tTop
          Chart.Title.Size = 40
          Chart.Title.Text = #24635#22312#32447
          Chart.XAxis.Font.Charset = DEFAULT_CHARSET
          Chart.XAxis.Font.Color = clWindowText
          Chart.XAxis.Font.Height = -11
          Chart.XAxis.Font.Name = 'Tahoma'
          Chart.XAxis.Font.Style = []
          Chart.XGrid.MajorDistance = 1
          Chart.XGrid.MinorLineColor = clGray
          Chart.XGrid.MajorLineColor = clSilver
          Chart.XGrid.MinorLineStyle = psDot
          Chart.XGrid.MajorFont.Charset = DEFAULT_CHARSET
          Chart.XGrid.MajorFont.Color = clWindowText
          Chart.XGrid.MajorFont.Height = -11
          Chart.XGrid.MajorFont.Name = 'Tahoma'
          Chart.XGrid.MajorFont.Style = []
          Chart.XGrid.MinorFont.Charset = DEFAULT_CHARSET
          Chart.XGrid.MinorFont.Color = clWindowText
          Chart.XGrid.MinorFont.Height = -11
          Chart.XGrid.MinorFont.Name = 'Tahoma'
          Chart.XGrid.MinorFont.Style = []
          Chart.XGrid.Visible = True
          Chart.YAxis.Font.Charset = DEFAULT_CHARSET
          Chart.YAxis.Font.Color = clWindowText
          Chart.YAxis.Font.Height = -11
          Chart.YAxis.Font.Name = 'Tahoma'
          Chart.YAxis.Font.Style = []
          Chart.YAxis.Size = 60
          Chart.YGrid.MinorDistance = 1.000000000000000000
          Chart.YGrid.MajorDistance = 2.000000000000000000
          Chart.YGrid.MajorLineStyle = psDot
          Chart.YGrid.Visible = True
        end
        object TIWAdvChart2: TTIWAdvChart
          Left = 15
          Top = 56
          Width = 600
          Height = 371
          Cursor = crAuto
          Visible = False
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = True
          StyleRenderOptions.RenderSize = True
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          Chart.AxisMode = amAxisChartWidthHeight
          Chart.Background.Font.Charset = DEFAULT_CHARSET
          Chart.Background.Font.Color = clWindowText
          Chart.Background.Font.Height = -11
          Chart.Background.Font.Name = 'Tahoma'
          Chart.Background.Font.Style = []
          Chart.Bands.Distance = 2.000000000000000000
          Chart.CrossHair.CrossHairYValues.Position = [chYAxis]
          Chart.CrossHair.Distance = 0
          Chart.Legend.Font.Charset = DEFAULT_CHARSET
          Chart.Legend.Font.Color = clWindowText
          Chart.Legend.Font.Height = -11
          Chart.Legend.Font.Name = 'Tahoma'
          Chart.Legend.Font.Style = []
          Chart.Range.StartDate = 41194.689110960650000000
          Chart.Series = <
            item
              AutoRange = arCommon
              Pie.ValueFont.Charset = DEFAULT_CHARSET
              Pie.ValueFont.Color = clWindowText
              Pie.ValueFont.Height = -11
              Pie.ValueFont.Name = 'Tahoma'
              Pie.ValueFont.Style = []
              Pie.LegendFont.Charset = DEFAULT_CHARSET
              Pie.LegendFont.Color = clWindowText
              Pie.LegendFont.Height = -11
              Pie.LegendFont.Name = 'Tahoma'
              Pie.LegendFont.Style = []
              Annotations = <>
              CrossHairYValue.BorderWidth = 0
              CrossHairYValue.Font.Charset = DEFAULT_CHARSET
              CrossHairYValue.Font.Color = clWindowText
              CrossHairYValue.Font.Height = -11
              CrossHairYValue.Font.Name = 'Tahoma'
              CrossHairYValue.Font.Style = []
              CrossHairYValue.GradientSteps = 0
              CrossHairYValue.Visible = False
              LegendText = 'Serie 0'
              ShowInLegend = False
              Marker.MarkerType = mCircle
              Marker.MarkerColor = clRed
              Marker.MarkerSize = 6
              Marker.MarkerPicture.Data = {}
              Marker.MarkerColorTo = clWhite
              Name = 'Serie 0'
              ChartPattern.Data = {}
              ShowValue = True
              ValueFont.Charset = ANSI_CHARSET
              ValueFont.Color = clWindowText
              ValueFont.Height = -13
              ValueFont.Name = #23435#20307
              ValueFont.Style = []
              ValueFormat = '%.1m'
              ValueWidth = 10
              XAxis.DateTimeFont.Charset = DEFAULT_CHARSET
              XAxis.DateTimeFont.Color = clWindowText
              XAxis.DateTimeFont.Height = -11
              XAxis.DateTimeFont.Name = 'Tahoma'
              XAxis.DateTimeFont.Style = []
              XAxis.MajorFont.Charset = DEFAULT_CHARSET
              XAxis.MajorFont.Color = clWindowText
              XAxis.MajorFont.Height = -11
              XAxis.MajorFont.Name = 'Tahoma'
              XAxis.MajorFont.Style = []
              XAxis.MajorUnit = 1.000000000000000000
              XAxis.MajorUnitSpacing = 0
              XAxis.MinorFont.Charset = DEFAULT_CHARSET
              XAxis.MinorFont.Color = clWindowText
              XAxis.MinorFont.Height = -11
              XAxis.MinorFont.Name = 'Tahoma'
              XAxis.MinorFont.Style = []
              XAxis.MinorUnit = 1.000000000000000000
              XAxis.MinorUnitSpacing = 0
              XAxis.TextTop.Font.Charset = DEFAULT_CHARSET
              XAxis.TextTop.Font.Color = clWindowText
              XAxis.TextTop.Font.Height = -11
              XAxis.TextTop.Font.Name = 'Tahoma'
              XAxis.TextTop.Font.Style = []
              XAxis.TextBottom.Font.Charset = DEFAULT_CHARSET
              XAxis.TextBottom.Font.Color = clWindowText
              XAxis.TextBottom.Font.Height = -11
              XAxis.TextBottom.Font.Name = 'Tahoma'
              XAxis.TextBottom.Font.Style = []
              XAxis.TickMarkSize = 4
              YAxis.MajorFont.Charset = DEFAULT_CHARSET
              YAxis.MajorFont.Color = clWindowText
              YAxis.MajorFont.Height = -11
              YAxis.MajorFont.Name = 'Tahoma'
              YAxis.MajorFont.Style = []
              YAxis.MajorUnitSpacing = 0
              YAxis.MinorFont.Charset = DEFAULT_CHARSET
              YAxis.MinorFont.Color = clWindowText
              YAxis.MinorFont.Height = -11
              YAxis.MinorFont.Name = 'Tahoma'
              YAxis.MinorFont.Style = []
              YAxis.MinorUnitSpacing = 0
              YAxis.TextLeft.Font.Charset = DEFAULT_CHARSET
              YAxis.TextLeft.Font.Color = clWindowText
              YAxis.TextLeft.Font.Height = -11
              YAxis.TextLeft.Font.Name = 'Tahoma'
              YAxis.TextLeft.Font.Style = []
              YAxis.TextRight.Font.Charset = DEFAULT_CHARSET
              YAxis.TextRight.Font.Color = clWindowText
              YAxis.TextRight.Font.Height = -11
              YAxis.TextRight.Font.Name = 'Tahoma'
              YAxis.TextRight.Font.Style = []
              YAxis.TickMarkSize = 4
              SelectedMarkSize = 0
              BarValueTextFont.Charset = DEFAULT_CHARSET
              BarValueTextFont.Color = clWindowText
              BarValueTextFont.Height = -11
              BarValueTextFont.Name = 'Tahoma'
              BarValueTextFont.Style = []
              XAxisGroups = <>
              SerieType = stNormal
            end>
          Chart.Title.Alignment = taCenter
          Chart.Title.Font.Charset = GB2312_CHARSET
          Chart.Title.Font.Color = clBlue
          Chart.Title.Font.Height = -19
          Chart.Title.Font.Name = #21326#25991#20013#23435
          Chart.Title.Font.Style = [fsBold]
          Chart.Title.Position = tTop
          Chart.Title.Size = 40
          Chart.Title.Text = #20805#20540#37329#39069#32479#35745
          Chart.XAxis.Font.Charset = DEFAULT_CHARSET
          Chart.XAxis.Font.Color = clWindowText
          Chart.XAxis.Font.Height = -11
          Chart.XAxis.Font.Name = 'Tahoma'
          Chart.XAxis.Font.Style = []
          Chart.XGrid.MajorDistance = 1
          Chart.XGrid.MinorLineColor = clGray
          Chart.XGrid.MajorLineColor = clSilver
          Chart.XGrid.MinorLineStyle = psDot
          Chart.XGrid.MajorFont.Charset = DEFAULT_CHARSET
          Chart.XGrid.MajorFont.Color = clWindowText
          Chart.XGrid.MajorFont.Height = -11
          Chart.XGrid.MajorFont.Name = 'Tahoma'
          Chart.XGrid.MajorFont.Style = []
          Chart.XGrid.MinorFont.Charset = DEFAULT_CHARSET
          Chart.XGrid.MinorFont.Color = clWindowText
          Chart.XGrid.MinorFont.Height = -11
          Chart.XGrid.MinorFont.Name = 'Tahoma'
          Chart.XGrid.MinorFont.Style = []
          Chart.XGrid.Visible = True
          Chart.YAxis.Font.Charset = DEFAULT_CHARSET
          Chart.YAxis.Font.Color = clWindowText
          Chart.YAxis.Font.Height = -11
          Chart.YAxis.Font.Name = 'Tahoma'
          Chart.YAxis.Font.Style = []
          Chart.YAxis.Size = 90
          Chart.YGrid.MinorDistance = 1.000000000000000000
          Chart.YGrid.MajorDistance = 2.000000000000000000
          Chart.YGrid.MajorLineStyle = psDot
          Chart.YGrid.Visible = True
        end
        object IWLabel4: TIWLabel
          Left = 15
          Top = 20
          Width = 0
          Height = 0
          Cursor = crAuto
          IW50Hint = False
          ParentShowHint = False
          ShowHint = True
          ZIndex = 0
          RenderSize = False
          StyleRenderOptions.RenderSize = False
          StyleRenderOptions.RenderPosition = True
          StyleRenderOptions.RenderFont = True
          StyleRenderOptions.RenderZIndex = True
          StyleRenderOptions.RenderVisibility = True
          StyleRenderOptions.RenderStatus = True
          StyleRenderOptions.RenderAbsolute = True
          Alignment = taLeftJustify
          BGColor = clNone
          Font.Color = clWebRED
          Font.FontName = #21326#25991#20013#23435
          Font.Size = 13
          Font.Style = []
          NoWrap = False
          ConvertSpaces = False
          HasTabOrder = False
          FriendlyName = 'IWLabel4'
          RawText = False
        end
      end
    end
  end
  inherited IWNavBarRegion: TIWRegion
    Height = 949
    ExplicitHeight = 949
    inherited TIWBasicSideNavBar1: TTIWExchangeBar
      Height = 949
      ExplicitHeight = 1925
    end
    inherited TIWGradientBarRight: TTIWGradientLabel
      Height = 949
      ExplicitHeight = 1925
    end
  end
end
