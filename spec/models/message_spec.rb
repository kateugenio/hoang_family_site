require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:body) }
  end
end
