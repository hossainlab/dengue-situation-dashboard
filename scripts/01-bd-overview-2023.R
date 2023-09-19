# Color: https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/












# Viz 5: Comparison 
highchart()  |> 
  hc_xAxis(categories = seasonal_trends$Month) |> 
  hc_add_series(data = seasonal_trends$TotalCases, 
                type = "column", 
                name = "Confirmed Cases", 
                color = "#EFC000FF") |> 
  hc_add_series(data = seasonal_trends$TotalRecovered, 
                type = "column", 
                name = "Recovered Cases") |> 
  hc_add_series(data = seasonal_trends$TotalDeaths,
                type = "column", 
                name = "Deaths Cases") |> 
  hc_xAxis(title = list(text = "Month"))  |> 
  hc_yAxis(title = list(text = "Number of Reported Cases")) |> 
  hc_title(text = 'Seasonality of dengue outbreaks in Bangladesh in 2023',style = list(fontSize = '25px', fontWeight = 'bold')) |>
  hc_subtitle(text = 'By Month', style = list(fontSize = '16px')) |> 
  hc_caption(text = "Source: Directorate General of Health Services, Bangladesh (2023") |> 
  hc_credits(enabled = TRUE, text = '@Md. Jubayer Hossain') |> 
  hc_add_theme(hc_theme_google())
