require 'spec_helper'

describe Item do
  describe 'includes' do
    it 'class respond_to? :rateable' do
      User.respond_to?(:rateable)
    end
    it { should respond_to(:rated?) }
    it { should respond_to(:rating) }
    it { should respond_to(:ratings) }
    it { should respond_to(:average_rating) }
    it { should respond_to(:persons_rating) }
  end

  it "destroys ratings when destroyed" do
    item = FactoryGirl.create(:item)

    first_rating = double()
    first_rating.should_receive(:destroy)
    item.stub(:ratings_query) { [first_rating] }

    item.destroy
  end

end
