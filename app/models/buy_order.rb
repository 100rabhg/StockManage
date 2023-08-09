class BuyOrder < ApplicationRecord
  belongs_to :supplier, class_name: "Supplier"
end
