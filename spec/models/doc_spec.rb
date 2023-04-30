require "rails_helper"

RSpec.describe Doc, type: :model do
  subject { create(:doc) }

  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:slug) }
end
