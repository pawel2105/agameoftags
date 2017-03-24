Rails.application.config.middleware.use OmniAuth::Builder do
  provider :instagram, 'CLIENT_ID', 'API_SECRET', scope: 'basic public_content'
end