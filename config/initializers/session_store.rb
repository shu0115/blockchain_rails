Rails.application.config.session_store(
  :cookie_store,
  key:          "_#{Settings.app_name.underscore}_session",
  expire_after: 2.weeks,
)
