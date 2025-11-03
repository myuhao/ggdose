test_that("drm model works", {
  expect_no_error(
    .compute_4PL_model(drc::ryegrass, rootl ~ conc, fct = LL.4())
  )
})



test_that("Test Geom4PL", {
  base_plot = drc::ryegrass %>%
    mutate(
      rootl = 10 - rootl,
      ...group = "...gggg"
    ) %>%
    bind_rows(
      drc::ryegrass
    ) %>%
    mutate(
      ...facet = "...ffff",
    ) %>%
    ggplot(aes(x = conc, y = rootl, group = ...group, color = ...group)) +
    geom_4PL() +
    facet_grid(rows = vars(...facet), cols = vars("a"), scale = "free_y")
  vdiffr::expect_doppelganger(
    "Geom4PL Without Log Transform",
    base_plot
  )
  vdiffr::expect_doppelganger(
    "Geom4PL with log Transform",
    base_plot + scale_x_log10()
  )
})
