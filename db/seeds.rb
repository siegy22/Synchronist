Config::CONFIGS.each do |c|
  Config.find_or_create_by!(name: c)
end
