CONFIG = HashWithIndifferentAccess.new(YAML::load_file('config/config.yml')[Rails.env])
