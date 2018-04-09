class Asset < ApplicationRecord
  belongs_to :assetable, :polymorphic => true
  delegate :url, to: :attachment
  do_not_validate_attachment_file_type :attachment
end
