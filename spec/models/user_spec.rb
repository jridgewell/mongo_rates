require 'spec_helper'

describe User do
  describe 'includes' do
    it 'class respond_to? :rates' do
      User.respond_to?(:rates)
    end
    it { should respond_to(:rate) }
    it { should respond_to(:recommended) }
    it { should respond_to(:update_recommendations) }
  end

  describe "when destroyed" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "destroys person" do
      person = double()
      person.should_receive(:destroy)
      MongoRates::Models::Person.stub(:find_person).with(@user) { person }
      @user.destroy
    end

    it "destroys person's ratings" do
      # Would be wonderful to make this a stub/mock
      # but how?...
      item = FactoryGirl.create(:item)
      @user.rate item, 10
      @user.destroy

      MongoRates::Models::Person.find_person!(@user)
      assert_nil item.persons_rating(@user)
    end
  end

end
