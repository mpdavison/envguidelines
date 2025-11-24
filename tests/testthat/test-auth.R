test_that("get_api_key returns environment variable", {
  skip_if_not_installed("withr")
  withr::with_envvar(
    new = c(GUIDELINELY_API_KEY = "test_key"),
    code = {
      expect_equal(guidelinely:::get_api_key(), "test_key")
    }
  )
})

test_that("get_api_key prefers argument over environment variable", {
  skip_if_not_installed("withr")
  withr::with_envvar(
    new = c(GUIDELINELY_API_KEY = "env_key"),
    code = {
      expect_equal(guidelinely:::get_api_key("arg_key"), "arg_key")
    }
  )
})

test_that("get_api_key returns NULL when no key is available", {
  skip_if_not_installed("withr")
  withr::with_envvar(
    new = c(GUIDELINELY_API_KEY = ""),
    code = {
      expect_null(guidelinely:::get_api_key())
    }
  )
})
