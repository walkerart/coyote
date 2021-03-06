RSpec.describe 'User adding and changing' do
  include_context 'as a logged-in staff user'

  let!(:editable_user) { create(:user) }
  let!(:representation) { create(:representation, author: editable_user) }

  scenario 'succeeds' do
    click_first_link 'User Management (Staff)'
    expect(page.current_path).to eq(staff_users_path)

    click_first_link editable_user.email
    expect(page.current_path).to eq(staff_user_path(editable_user))

    click_first_link 'Edit'
    expect(page.current_path).to eq(edit_staff_user_path(editable_user))

    fill_in 'First name', with: 'Wintermute'

    expect {
      click_button 'Update User'
      editable_user.reload
    }.to change(editable_user, :first_name).
      to('Wintermute')

    expect(page.current_path).to eq(staff_user_path(editable_user))

    expect {
      click_button 'Send password reset email'
    }.to change(ActionMailer::Base.deliveries, :count).
      from(0).to(1)

    ActionMailer::Base.deliveries.pop.tap do |email|
      expect(email.to).to eq([editable_user.email])
      expect(email.subject).to match(/reset password/i)
    end

    expect(page.current_path).to eq(staff_user_path(editable_user))

    expect {
      click_button 'Archive'
      editable_user.reload
    }.to(change {
      editable_user.active?
    })

    expect(page.current_path).to eq(staff_users_path)
  end
end
