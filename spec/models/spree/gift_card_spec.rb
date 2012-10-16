require 'spec_helper'

describe Spree::GiftCard do

  it {should validate_presence_of(:current_value)}
  it {should validate_presence_of(:email)}
  it {should validate_presence_of(:original_value)}
  it {should validate_presence_of(:name)}

  it "should generate token before create" do
    card = Spree::GiftCard.create(:email => "test@mail.com", :name => "John", :variant_id => create(:variant).id)
    card.token.should_not == nil
  end

  it "should set current_value and original_value before create" do
    card = Spree::GiftCard.create(:email => "test@mail.com", :name => "John", :variant_id => create(:variant).id)
    card.current_value.should_not == nil
    card.original_value.should_not == nil
  end

  it "should not allow user set line_item_id and user_id" do
    lambda {
      Spree::GiftCard.create(:email => "test@mail.com", :name => "John", :variant_id => create(:variant).id, :line_item_id => 1)
    }.should raise_error(ActiveModel::MassAssignmentSecurity::Error, /line_item_id/)
    lambda {
      Spree::GiftCard.create(:email => "test@mail.com", :name => "John", :variant_id => create(:variant).id, :user_id => 1)
    }.should raise_error(ActiveModel::MassAssignmentSecurity::Error, /user_id/)
  end
end
