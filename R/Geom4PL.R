

Stat4PL = ggproto(
  "Stat4PL", Stat,
  compute_group = function(data, scales, fct) {
    # First inverse any transformation to the x as the model.
    data$x1 = scales$x$get_transformation()$inverse(data$x)

    # Fit the the model
    mod = .compute_4PL_model(data, y ~ x1, fct)
    EC50 = mod$fit$par[4]
    # Define the fitted line based on the transformed x limits
    new_x = seq(
      from = scales$x$get_limits()[1],
      to = scales$x$get_limits()[2],
      length.out = 100
    )
    new_x = data.frame(x = new_x)

    # Evaluate the newdata using the model after inverse transformation
    newdata = data %>%
      select(-c("x", "y", "x1")) %>%
      distinct() %>%
      expand_grid(new_x) %>%
      mutate(x1 = scales$x$get_transformation()$inverse(x)) %>%
      as.data.frame()

    newdata$y = predict(mod, newdata = newdata)
    newdata %>%
      mutate(EC50 = EC50)
  }
)


#' 4-parameter logistic regression (4PL)
#'
#' @rdname four-PL
#'
#' @inheritDotParams drc::drm fct
#'
#' @description
#' This stat will fit a 4PL line using `drc::drm()`.
#' The x data to be used will not be transformed.
#' In other word, the fitted model will not be influenced by `scale_x_()` functions.
#' The stat layer implement the regression model,
#' while the geom layer inherits from geom_line to make the plot.
#' @export
stat_4PL = function(
    geom = GeomLine,
    position = position_identity(),
    fct = drc::LL.4(names = c("Slope", "Lower Limit", "Upper Limit", "EC50")),
    ...
) {
  layer(
    stat = Stat4PL,
    geom = geom,
    position = position,
    params = list(
      fct = fct,
      ...
    )
  )
}



Geom4PL = ggproto(
  "Geom4PL", GeomLine,
  draw_panel = function(data, panel_params, coord, ...) {
    data2 = data %>%
      .get_group_location(panel_params$x.range, panel_params$y.range)
    # print(data2)
    grid::gList(
      GeomLine$draw_panel(data, panel_params, coord, ...),
      GeomText$draw_panel(data2, panel_params, coord, ...)
    )
  }
)


#' @rdname four-PL
#' @export
geom_4PL = function(
    geom = Geom4PL,
    stat = Stat4PL,
    position = position_identity(),
    fct = drc::LL.4(names = c("Slope", "Lower Limit", "Upper Limit", "EC50"))
) {
  layer(
    geom = geom,
    stat = stat,
    position = position,
    params = list(
      fct = fct
    )
  )
}


#' @keywords internal
.compute_4PL_model = function(data, formula, fct) {
  mod = drc::drm(
    formula = formula,
    data = data,
    fct = fct
  )
  mod
}


#' @keywords internal
.get_group_location = function(data, x.range, y.range, ...) {
  x0 = x.range[1]
  x1 = x.range[2]
  y1 = y.range[2]
  y0 = y.range[1]
  y_distance = y1 - y0
  x_distance = x1 - x0
  # see ggpubr .label_params for this magic number...
  # https://github.com/kassambara/ggpubr/blob/master/R/utilities_label.R
  step = 0.7 * length(unique(data$group))
  data %>%
    distinct(group, .keep_all = TRUE) %>%
    mutate(
      label = scales::label_number_auto()(EC50),
      x = x0 + x_distance * 0.05, # x poistion, offset by 0.05 of the total x length
      y = y1 - y_distance * 0.05, # initial y position, with offset
      angle = 0,
      hjust = 0,
      vjust = 0 + step * (row_number() - 1) # increment by step for each row using vjust
    )
}

