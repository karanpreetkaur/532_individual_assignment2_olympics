library(tidyverse)
library(dash)
library(dashHtmlComponents)
library(dashCoreComponents)

olympic <- readr::read_csv(here::here('data', 'olympic_after_2000.csv'))

# dropdown_list <-  olympic |>  select(Year) |> unique()
# dropdown_list <- sort(dropdown_list$Year, decreasing = TRUE)

app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)

app$layout(
  dbcContainer(
    list(
      dccDropdown(
        options = list(list(label = 2016 , value = 2016),
        list(label = 2014, value = 2014),
        list(label = 2012, value = 2012),
        list(label = 2010, value = 2010),
        list(label = 2008, value = 2008),
        list(label = 2006, value = 2006),
        list(label = 2004, value = 2004),
        list(label = 2002, value = 2002)
        ),
        value = 2016,
        id='year'
      ),
      dccGraph(id='plot-area')
    )
  )
)

app$callback(
  output('plot-area', 'figure'),
  list(input('year', 'value')),
  function(xcol) {
    olympic_year <- olympic %>% filter(Year == xcol)
    p <- ggplot(olympic_year, aes(x = Sex, y= stat(count), fill=Medal)) +
         geom_bar() +
         facet_wrap(~Medal) +
         labs(x = 'Gender', y = paste('Medals won in year', xcol)) +
         ggtitle('Medal distribution by Gender')
    ggplotly(p)
  }
)

app$run_server(host = '0.0.0.0')
