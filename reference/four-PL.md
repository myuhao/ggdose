# 4-parameter logistic regression (4PL)

This stat will fit a 4PL line using
[`drc::drm()`](https://rdrr.io/pkg/drc/man/drm.html). The x data to be
used will not be transformed. In other word, the fitted model will not
be influenced by `scale_x_()` functions. The stat layer implement the
regression model, while the geom layer inherits from geom_line to make
the plot.

## Usage

``` r
stat_4PL(
  geom = GeomLine,
  position = position_identity(),
  fct = drc::LL.4(names = c("Slope", "Lower Limit", "Upper Limit", "EC50")),
  ...
)

geom_4PL(
  mapping = NULL,
  data = NULL,
  stat = Stat4PL,
  position = position_identity(),
  fct = drc::LL.4(names = c("Slope", "Lower Limit", "Upper Limit", "EC50")),
  x_offset = 0,
  y_offset = 0,
  ...
)
```

## Arguments

- ...:

  Arguments passed on to
  [`drc::drm`](https://rdrr.io/pkg/drc/man/drm.html)

  `fct`

  :   a list with three or more elements specifying the non-linear
      function, the accompanying self starter function, the names of the
      parameter in the non-linear function and, optionally, the first
      and second derivatives as well as information used for calculation
      of ED values. Currently available functions include, among others,
      the four- and five-parameter log-logistic models
      [`LL.4`](https://rdrr.io/pkg/drc/man/LL.4.html),
      [`LL.5`](https://rdrr.io/pkg/drc/man/LL.5.html) and the Weibull
      model [`W1.4`](https://rdrr.io/pkg/drc/man/W4.html). Use
      [`getMeanFunctions`](https://rdrr.io/pkg/drc/man/getMeanFunctions.html)
      for a full list.

- x_offset:

  A number from 0 to 1 to specifiy how much offset the label should be

- y_offset:

  A number from 0 to 1 to specifiy how much offset the label should be
