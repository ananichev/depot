class Product < ActiveRecord::Base

  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01, message: "can't be so tiny, it's should be a little more than 0.01"}
  validates :title, uniqueness: true, length: {minimum: 10}
  validates :image_url, allow_blank: true, format: {
            with: /\.(gif|jpg|png)\z/i,
            message: 'URL must point to GIT/JPG/PNG pictures'
  }

  has_many :line_items
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  private

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      true
    else
      errors.add(:base, 'line items are exist')
      false
    end
  end

end
