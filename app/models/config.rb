class Config < ApplicationRecord
  def self.get!(name)
    value = find_by!(name: name).value

    if name.end_with?("_folder")
      Pathname.new(value)
    else
      value
    end
  end
end
