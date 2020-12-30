require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:ingredients) }
    it { is_expected.to validate_presence_of(:directions) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_numericality_of(:serving_size) }
    it { is_expected.to validate_numericality_of(:total_cook_time) }
    it { is_expected.to validate_inclusion_of(:category).in_array(Recipe::CATEGORIES) }
  end
end
