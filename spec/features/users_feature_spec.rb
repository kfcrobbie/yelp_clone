require 'rails_helper'

feature "User can sign in and out" do
  context "user not signed in and on the homepage" do
    it "should see a 'sign in' link and a 'sign up' link" do
      visit '/'
      expect(page).to have_link('Sign in')
      expect(page).to have_link('Sign up')
    end

    it "should not see 'sign out' link" do
      visit '/'
      expect(page).not_to have_link('Sign out')
    end
  end

  context "user signed in on the homepage" do
    before do
    sign_up
    end

    it "should see 'sign out' link" do
      visit '/'
      expect(page).not_to have_link('Sign in')
      expect(page).not_to have_link('Sign up')
    end
  end

  context "when logged in" do
    before do
      sign_up
    end

    it "users should be able to create restaurant" do
      create_restaurant
      expect(current_path).to eq '/restaurants'
    end
  end

  context "when not logged in" do

    it "user should not be able to create a restaurant" do
      visit '/'
      click_link 'Add a restaurant'
      expect(page).to have_content 'Log in'
      expect(current_path).to eq '/users/sign_in'
    end
  end

  context "for a restaurant which they have created" do

    it "can be edited" do
      sign_up
      create_restaurant
      expect(current_path).to eq '/restaurants'
      click_link 'Edit Culpeper'
      expect(page).to have_button 'Update Restaurant'
    end

      it "can be deleted" do
        sign_up
        create_restaurant
        expect(current_path).to eq '/restaurants'
        click_link 'Delete Culpeper'
        expect(page).to have_content 'Restaurant deleted successfully'
    end
  end

  context "for a restaurant which they have not created" do

    it "they can not edit them" do
      sign_up
      expect(current_path).to eq '/restaurants'
      click_link 'Edit KFC'
      expect(page).to have_content 'Log in'
      expect(current_path).to eq '/users/sign_in'
    end

    it "they can not delete them" do
      sign_up
      expect(current_path).to eq '/restaurants'
      click_link 'Delete KFC'
      expect(page).to have_content 'Log in'
      expect(current_path).to eq '/users/sign_in'
    end
  end

  def sign_up
    visit '/'
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  def create_restaurant
    visit '/'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'Culpeper'
    click_button 'Create Restaurant'
    expect(page).to have_content 'Culpeper'
  end
end
